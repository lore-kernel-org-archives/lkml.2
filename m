Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab2ITDhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 23:37:21 -0400
Received: from wsip-98-175-252-166.sd.sd.cox.net ([98.175.252.166]:1728 "EHLO
	memeplex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339Ab2ITDhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 23:37:19 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Sep 2012 23:37:18 EDT
Message-ID: <505A8E40.5080202@memeplex.com>
Date: Wed, 19 Sep 2012 20:32:16 -0700
From: Andrew Athan <linux_kernel_aathan@memeplex.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Processes in D state / development of real-time apps
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All:

I am simply not sure whether this is the right list to post this 
question to.  Please redirect me if not.

I chose to post here based on some indications that the problem may 
involve some aspects of the kernel given the involvement of tty/sshd/and 
a process stuck in "D" state waiting on flush_work.

Short version:  Kernel 2.6.32.  Lots of CPUs but not CPU 15 at 100% 
running spin-waiting threads.  Emacs, sshd, and all other processes & 
also IRQs forced onto CPU 15 at high priority (taskset/renice).   
However, the terminal session in which the app was started hangs, and 
emacs is in "D" or "S" states until the app is interrupted, making it 
difficult to debug.

Question: What elements of the system may be at fault, and can 
subsystems involved in the terminal<->sshd session be configured such 
that control is not lost?  Or, are the mechanisms used to shuttle 
terminal IO always going to be starved by this scenario?





Details:

I am developing an application where many threads are spin-waiting on 
input--i.e., they are pegged at 100%.  One thread per CPU.  The spin is 
on a memory location, and does not involve interruptible/preemtable 
system calls.  The threads are priority=99 SCHED_FIFO.  In this run, the 
kernel is not a preemtable kernel and the application runs as root to 
allow setting of priority and scheduler.

The machine is remote, and accessed via ssh.  To ease development of 
this app, it would be nice if it could be run in gdb, within emacs. 
Therefore, in order to ensure that CPU is allocated to sshd, I run a 
script that moves all processes to CPU 15 (hyperthreading enabled, 8 
physical cores) via taskset -cp.  I also run a script which sets the 
/proc/irq/*/smp_affinity on all interrupts listend in /proc/interrupts 
to CPU 15.  This includes all sshd, bash, emacs, etc processes which I 
also renice -20.

Note that CPU 15 is not one of the CPUs on which the "pegged" 
application threads are running.

After a small amount of output to stdout, although the application 
itself appears to continue to run, no further interaction with the 
controlling terminal is possible and no output is seen.  No input seems 
to reach emacs, or the controlling tty.  Other bash/ssh sessions are 
fine, and sending a SIGINT (e.g., pkill -SIGINT pid) allows the process 
to drop back into the debugger and control to be restored.

While the emacs session is hung, I inspect the process state on emacs 
and the high priority app.

$ sudo ps -Leo psr,pid,tid,class,rtprio,stat,comm,wchan | grep emacs
  15 11901 11901 TS       - D<+  emacs           flush_work
or sometimes
  15 11901 11901 TS       - S<+  emacs poll_schedule_timeout

$ sudo ps -Leo psr,pid,tid,class,rtprio,stat,comm,wchan | grep 
HighPriorityApp

  15 13517 13517 TS       - SNLl+ HighPriorityApp futex_wait_queue_me
   1 13517 13518 RR      99 SNLl+ HighPriorityApp hrtimer_nanosleep
   0 13517 13519 TS       - SNLl+ HighPriorityApp futex_wait_queue_me
   1 13517 13520 TS       - SNLl+ HighPriorityApp futex_wait_queue_me
   8 13517 13521 TS       - SNLl+ HighPriorityApp futex_wait_queue_me
   9 13517 13522 TS       - SNLl+ HighPriorityApp futex_wait_queue_me
   0 13517 13523 TS       - SNLl+ HighPriorityApp ep_poll
   1 13517 13524 TS       - SNLl+ HighPriorityApp futex_wait_queue_me
   8 13517 13525 TS       - SNLl+ HighPriorityApp futex_wait_queue_me
   9 13517 13526 TS       - SNLl+ HighPriorityApp futex_wait_queue_me
   2 13517 13527 FF      99 RNLl+ HighPriorityApp -
   3 13517 13528 FF      99 RNLl+ HighPriorityApp -
   6 13517 13529 FF      99 RNLl+ HighPriorityApp -
   7 13517 13530 FF      99 RNLl+ HighPriorityApp -
   4 13517 13531 FF      99 RNLl+ HighPriorityApp -
   5 13517 13532 FF      99 RNLl+ HighPriorityApp -
  15 13517 13533 TS       - SNLl+ HighPriorityApp poll_schedule_timeout
  15 13517 13534 TS       - SNLl+ HighPriorityApp poll_schedule_timeout
  15 13517 13535 TS       - RNLl+ HighPriorityApp -
  15 13517 13536 TS       - RNLl+ HighPriorityApp -
  15 13517 13537 TS       - RNLl+ HighPriorityApp -
  15 13517 13538 TS       - SNLl+ HighPriorityApp poll_schedule_timeout
  15 13517 13539 TS       - SNLl+ HighPriorityApp poll_schedule_timeout
  15 13517 13540 TS       - RNLl+ HighPriorityApp -
  15 13517 13541 TS       - RNLl+ HighPriorityApp -
  15 13517 13542 TS       - SNLl+ HighPriorityApp poll_schedule_timeout


It appears that emacs enters the "D" and or "S" states despite what I 
think are all of the relevant processes (including emacs itself) being 
on CPU 15.  Once the process is interrupted (SIGINT) and it drops back 
into gdb, resulting in the various CPUs it is using quiescing,  then a 
bunch of output that has been buffered somewhere is sent down the ssh 
connection.  Emacs/the tty becomes responsive again.

It does not appear that the high priority process itself is blocked in 
write() while the session is hung.  However, it's hard to say since I 
can't access it within the debugger.  However, there are other signs of 
life that lead me to believe it is not hung.  Also, it's possible that 
it would eventually hang, and it simply hasn't output enough to get to 
that point by the time I interrupt it.  It is also possible that one 
thread is hung while others are showing signs of life.  I cannot 
determine which is the case.

The HighPriorityApp threads on CPU 15 are generally in select() in a 
python interpreter and are running at no higher priority than emacs 
(they have inherited priority and scheduler from the emacs parent process).

Can anyone offer some hints as to how to configure the various software 
elements of the system so that terminal I/O from the high-priority 
process and/or the emacs session it is running in is able to reach 
sshd?  It is not clear to me what aspect to the chain of pipes/fds 
linking the process stdin/stdout/stderr to emacs gdb-mode and emacs to 
the tty and the tty to sshd are involved here.

Or, am I misreading the situation?  Is the D state possibly only 
associated with pending disk (and not pipe/tty/network) I/O?  Or could 
the problem be emacs' elevated priority while having affinity to the 
same single CPU as *all* other processes?  I don't think so, given D is 
a wait state.  I did try to run emacs at a lower priority with no change 
in behavior.

$ uname -a
Linux HOST 2.6.32-41-server #94-Ubuntu SMP Fri Jul 6 18:15:07 UTC 2012 
x86_64 GNU/Linux

A.

