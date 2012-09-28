Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946274Ab2I1Vb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:31:57 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:35040 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946261Ab2I1Vbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 17:31:52 -0400
MIME-Version: 1.0
Date: Fri, 28 Sep 2012 14:31:52 -0700
Message-ID: <CAOvz8aLi5siht_hvM6fsPdzhkAUdWuzSWeT1iZuYd-8UZWsNTg@mail.gmail.com>
Subject: call_usermodehelper_exec stdout is being forwarded to most recent
 client socket
From: Neil Hellfeldt <neilhellfeldt@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A while back for in house development I wanted to have a socket server
in the kernel
I did this by mapping the syscall's

unsigned long **sys_call_table;

long (*_accept)(int,struct sockaddr __user*,int __user*);
long (*_bind)(int,struct sockaddr __user*,int);
long (*_close)(unsigned int);
long (*_listen)(int,int);
long (*_select)(int,fd_set __user*,fd_set __user*,fd_set
__user*,struct timeval __user*);
long (*_setsockopt)(int,int,int,char __user*,int);
long (*_socket)(int,int,int);
long (*_read)(unsigned int,const char __user*,size_t);
long (*_write)(unsigned int,const char __user*,size_t);
long (*_getpeername)(int,struct sockaddr __user*,int*);


if(!(sys_call_table = aquire_sys_call_table()))
  return -1;

_socket = (void*)sys_call_table[__NR_socket];
_setsockopt = (void*)sys_call_table[__NR_setsockopt];
_bind   = (void*)sys_call_table[__NR_bind];
_listen = (void*)sys_call_table[__NR_listen];
_select = (void*)sys_call_table[__NR_select];
_accept = (void*) sys_call_table[__NR_accept];
_read   = (void*)sys_call_table[__NR_read];
_getpeername = (void*)sys_call_table[__NR_getpeername];
_write  = (void*)sys_call_table[__NR_write];
_close  = (void*)sys_call_table[__NR_close];


after that I create a thread.

server_task = kthread_run(est210_cal_main,cal,"test_srv");

int the thread I run the syscall's in this order I actually use error
checking in the code.

_ksocket = _socket(PF_INET,SOCK_STREAM,0);
_setsockopt(_ksocket,SOL_SOCKET,SO_REUSEADDR,(char*)&yes,sizeof(int));
_bind(_ksocket,(struct sockaddr*)&saddr,sizeof(struct sockaddr));
_listen(_ksocket,MAXQUE);

while loop true
set_current_state(TASK_RUNNING);
_select(t_sockets+1,&r_sockets,NULL,NULL,&twait);
cl_socket = _accept(_ksocket,(struct sockaddr*)&cl_saddr,&cl_sinsize)) < 0);
set_current_state(TASK_INTERRUPTIBLE);
while loop

Once I accept the incoming connect I have a parser that lets me
configure a wireless device I am working

and I wanted to save some of the data to the permanent data of the os
so when it boots it calibrated.

I decided to use  call_usermodehelper_exec

I noticed something weird when I send /usr/bin/which true
the client would receive /bin/true
I knew I did not send this info.

 the file handle created by the _accept became the stdout for all
programs called by any of the call_usermodehelper's

I know what I am doing is uncommon and I am not looking for help, I am
just reporting something that I think should not
happen even if what I am doing is uncommon.

also it is the handle of the last _accept so if I run two scripts and
cause the right timing the output will end up on the wrong client.

I also know from other readings that there is not supposed to be a way
to redirect the stdout with the call_usermodehelper

and that is the reason why I am reporting this.
