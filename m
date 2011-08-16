Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab1HPNI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 09:08:27 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:44499 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab1HPNIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 09:08:22 -0400
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Aug 2011 09:08:22 EDT
From: Philipp Marek <philipp.marek@linbit.com>
Organization: Linbit HA GmbH
To: linux-kernel@vger.kernel.org
Subject: Hanging threads with pthread_detach and gdb
Date: Tue, 16 Aug 2011 14:58:35 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-1-amd64; KDE/4.6.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_7lmSOhGZaBLJB1x"
Message-Id: <201108161458.35774.philipp.marek@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_7lmSOhGZaBLJB1x
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello everybody,


I've found a strange behaviour, and I think it's a kernel bug - or, at 
least, a bad interaction with GDB.


The attached program creates a few detached pthreads, and quits.
Running the program as-is works without any problem; but when it's started 
via gdb there's an occasional hang at the end (1 out of 5 to 10 runs).


CTRL-C doesn't work:
    $ gdb -ex r --args ./t
    ...
    Starting program: t 
    [Thread debugging using libthread_db enabled]
    [New Thread 0x7ffff783c700 (LWP 8227)]
    thread (nil) START
    [New Thread 0x7ffff703b700 (LWP 8228)]
    thread 0x1 START
    [New Thread 0x7ffff683a700 (LWP 8229)]
    thread 0x2 START
    [New Thread 0x7ffff6039700 (LWP 8230)]
    thread 0x3 START
    [New Thread 0x7ffff5838700 (LWP 8231)]
    thread 0x4 START
    thread 0x4 END
    thread 0x2 END
    thread (nil) END
    the end is near.
    [Thread 0x7ffff6039700 (LWP 8230) exited]
    [Thread 0x7ffff683a700 (LWP 8229) exited]
    [Thread 0x7ffff703b700 (LWP 8228) exited]
    [Thread 0x7ffff783c700 (LWP 8227) exited]
    ^C


"ps fax" shows that the test program would be done:
     8210 pts/13   S      0:00          \_ gdb -ex r --args ./t
     8226 pts/13   Zl+    0:00              \_ [t] <defunct>


but GDB still waits for it:
    $ strace -p 8210
    Process 8120 attached - interrupt to quit
    wait4(8226, ^C <unfinished ...>
    Process 8120 detached

The kernel stack trace shows need_resched()
    $ sudo cat /proc/8226/task/*/stack
    [<ffffffff810383fc>] need_resched+0x1a/0x23
    [<ffffffff8103840a>] should_resched+0x5/0x24
    [<ffffffff81049ea0>] do_exit+0x73e/0x740
    [<ffffffff8104a119>] do_group_exit+0x77/0xa1
    [<ffffffff8104a155>] sys_exit_group+0x12/0x19
    [<ffffffff8133ba92>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
    [<ffffffff810383fc>] need_resched+0x1a/0x23
    [<ffffffff8103840a>] should_resched+0x5/0x24
    [<ffffffff81049ea0>] do_exit+0x73e/0x740
    [<ffffffff8104a119>] do_group_exit+0x77/0xa1
    [<ffffffff8105676f>] get_signal_to_deliver+0x37c/0x3a3
    [<ffffffff810d22bb>] handle_pte_fault+0x295/0x79b
    [<ffffffff81008e37>] do_signal+0x6c/0x649
    [<ffffffff8133983a>] do_page_fault+0x2d3/0x30e
    [<ffffffff810383fc>] need_resched+0x1a/0x23
    [<ffffffff8103840a>] should_resched+0x5/0x24
    [<ffffffff8103aec8>] mmdrop+0xd/0x1c
    [<ffffffff8103b0a2>] finish_task_switch+0x84/0xaf
    [<ffffffff810383fc>] need_resched+0x1a/0x23
    [<ffffffff81009450>] do_notify_resume+0x25/0x6b
    [<ffffffff81336fd2>] paranoid_userspace+0x46/0x50
    [<ffffffffffffffff>] 0xffffffffffffffff

(but I've seen traces like this, too:)
    [<ffffffff810ed076>] kmem_cache_free+0x2d/0x69
    [<ffffffff81055739>] ptrace_stop+0xff/0x19e
    [<ffffffff81056550>] get_signal_to_deliver+0x15d/0x3a3
    [<ffffffff81008e37>] do_signal+0x6c/0x649
    [<ffffffff81035861>] __wake_up_common+0x41/0x78
    [<ffffffff810383fc>] need_resched+0x1a/0x23
    [<ffffffff8103840a>] should_resched+0x5/0x24
    [<ffffffff810121dd>] arch_ptrace+0x7d/0x1bd
    [<ffffffff8104fc48>] put_task_struct+0xd/0x1c
    [<ffffffff8105084e>] sys_ptrace+0x7d/0x8d
    [<ffffffff810fc8b0>] fput+0x1a/0x1a2
    [<ffffffff81009450>] do_notify_resume+0x25/0x6b
    [<ffffffff810fbd2d>] sys_write+0x5f/0x6b
    [<ffffffff81336fd2>] paranoid_userspace+0x46/0x50
    [<ffffffffffffffff>] 0xffffffffffffffff


This is with a distribution kernel (sorry), recent userspace:
    $ uname -a
    Linux 3.0.0-1-amd64 #1 SMP Sun Jul 24 02:24:44 UTC 2011 x86_64 GNU/Linux
    $ gdb --version
    GNU gdb (GDB) 7.2-debian
    $ dpkg-query -l libpth20 gdb
    ii  libpth20         2.0.7-16       The GNU Portable Threads
    ii  gdb              7.2-1          The GNU Debugger


I've tried with a vanilla 3.0 ARCH=um (clean 3.0 checkout, git rev 
(02f8c6aee8df3cdc935e9bdd4f2d020306035dbe), but get hit by
"Couldn't write debug register: Input/Output error" which seems to be 
reported as http://marc.info/?l=user-mode-linux-devel&m=126038615513701 and 
http://marc.info/?l=user-mode-linux-devel&m=127181550231140.


Any help would be appreciated!
Please keep me CC'ed; thank you.


Regards,

Phil

--Boundary-00=_7lmSOhGZaBLJB1x
Content-Type: text/x-csrc;
  charset="utf-8";
  name="t.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="t.c"

#include <stdio.h>
#include <unistd.h>
#include <pthread.h>

int stop;

void *thr(void *x)
{
	pthread_detach(pthread_self());
	printf("thread %p START\n", x);
	while (!stop) ;
	printf("thread %p END\n", x);
	return NULL;
}

int main(int argc, char *args[])
{
	int x, i;
	pthread_t pt;

	x = sysconf(_SC_NPROCESSORS_ONLN) + 1;
	stop = 0;
	for(i=0; i<x; i++) {
		pthread_create(&pt, NULL, thr, (void*)(long)i);
	}

	usleep(10e3);
	stop = 1;

	printf("the end is near.\n");
	return 0;
}


--Boundary-00=_7lmSOhGZaBLJB1x
Content-Type: text/x-makefile;
  charset="utf-8";
  name="Makefile"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="Makefile"


CFLAGS	+= -g -Wall
LDFLAGS	+= -lpthread -g

t: t.c

--Boundary-00=_7lmSOhGZaBLJB1x--
