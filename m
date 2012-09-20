Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab2ITF1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 01:27:47 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:55112 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751442Ab2ITF1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 01:27:45 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18Ldt5LUGcLNonwCLdr3dr3tbbO9aicab06NdEYGm
	4S5OyPGw0H0+Cr
Message-ID: <1348118846.7061.88.camel@marge.simpson.net>
Subject: Re: Processes in D state / development of real-time apps
From: Mike Galbraith <efault@gmx.de>
To: Andrew Athan <linux_kernel_aathan@memeplex.com>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 20 Sep 2012 07:27:26 +0200
In-Reply-To: <505A8E40.5080202@memeplex.com>
References: <505A8E40.5080202@memeplex.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-19 at 20:32 -0700, Andrew Athan wrote: 
> All:
> 
> I am simply not sure whether this is the right list to post this 
> question to.  Please redirect me if not.
> 
> I chose to post here based on some indications that the problem may 
> involve some aspects of the kernel given the involvement of tty/sshd/and 
> a process stuck in "D" state waiting on flush_work.

Yeah, when workqueues can't run, box stops working.

> I am developing an application where many threads are spin-waiting on 
> input--i.e., they are pegged at 100%.  One thread per CPU.  The spin is 
> on a memory location, and does not involve interruptible/preemtable 
> system calls.  The threads are priority=99 SCHED_FIFO.  In this run, the 
> kernel is not a preemtable kernel and the application runs as root to 
> allow setting of priority and scheduler.

It doesn't matter if the kernel is preemptible or not, as soon as a
SCHED_FIFO:99 task starts spinning, it's game over if anything needs to
happen on a CPU that GOD is using as a toaster.  Either you give
workqueues a break, or you ensure that you don't need them, else they
sink their teeth in godly behinds :)

> It appears that emacs enters the "D" and or "S" states despite what I 
> think are all of the relevant processes (including emacs itself) being 
> on CPU 15.  Once the process is interrupted (SIGINT) and it drops back 
> into gdb, resulting in the various CPUs it is using quiescing,  then a 
> bunch of output that has been buffered somewhere is sent down the ssh 
> connection.  Emacs/the tty becomes responsive again.

If worker thread is waiting on a spinners CPU, you are toast.

<ponder>  In 2.6.32, if you disable AFFINE_WAKEUPS scheduler feature,
and enable SD_BALANCE_WAKE scheduler domain flag in all domains, you may
receive some salvation.  If a worker thread is awakened (one that is not
pinned to a pegged CPU that is) or trying to be born via kthreadd who
was previously on a now pegged CPU, wakeup balancing may put things that
need to happen someplace where they _can_ happen.  If OTOH an RT task
preempts then spins, you'll need help from periodic load balancing,
because we don't evict SCHED_OTHER class upon RT class arrival.
> It does not appear that the high priority process itself is blocked in 
> write() while the session is hung.  However, it's hard to say since I 
> can't access it within the debugger.  However, there are other signs of 
> life that lead me to believe it is not hung.  Also, it's possible that 
> it would eventually hang, and it simply hasn't output enough to get to 
> that point by the time I interrupt it.  It is also possible that one 
> thread is hung while others are showing signs of life.  I cannot 
> determine which is the case.

If you use the RT throttle, and backport fixes such that it will really
stop an RT spinfest, you should be able to debug it.  The throttle will
yank the CPU away from spinners, worker threads and whatnot can then
run, and the world starts spinning again, though a bit raggedly with the
default 95% CPU reserved for RT.

-Mike

