FROM ubuntu:16.04

#-------------------------------------------------------------------------
# Parameters modifiable when using the 'docker build' command

ARG user=tester
ARG user_id=6010

ARG group=tester
ARG group_id=1234

#-------------------------------------------------------------------------
# Package management

#RUN apt-get install -y libc6-i386       # 32 bits for pvm

RUN apt-get update && \
    apt-get install -y sudo \
                       openssh-client \
                       libfontconfig \
                       libxext6 \
                       libxaw7 \
                       libxmu6 \
                       libglu1-mesa \
                       libxrender1 \
                       libxcursor1 libxrandr2 \
                       pciutils \
                       netbase \
                       g++ \
                       libc6-i386

# Link to fool flexlm about lsb
RUN ln -s /lib64/ld-linux-x86-64.so.2 /lib64/ld-lsb-x86-64.so.3

#-------------------------------------------------------------------------
# User creation management

RUN groupadd $group -g $group_id
RUN useradd $user -g $group -u $user_id -d /home/$user --create-home --shell=/bin/bash

RUN chmod 700 /home/$user

# give sudo permissions for installing extra software
#
RUN echo $user ALL=NOPASSWD: /usr/bin/apt, /usr/bin/apt-get >> /etc/sudoers
RUN echo $user ALL=NOPASSWD: /bin/dmesg >> /etc/sudoers

#-----------------------------------------------------------------------

VOLUME ["/home/tester/mount"]

#COPY entrypoint.sh /home/$user/mount/

RUN chown -R $user:$group /home/$user

USER $user
ENV USER  $user
ENV HOME  /home/$user
ENV SHELL /bin/bash
WORKDIR   /home/$user

#-----------------------------------------------------------------------

ENTRYPOINT ["/home/tester/mount/test_installation.sh"]
CMD []


