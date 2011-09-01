Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041Ab1IAJ4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 05:56:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:43692 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756960Ab1IAJ4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 05:56:47 -0400
Date: Thu, 1 Sep 2011 11:56:42 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Miller <davem@davemloft.net>
cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: process time < thread time?
In-Reply-To: <20110831.230718.2029810906806382170.davem@davemloft.net>
Message-ID: <alpine.LFD.2.02.1109011148060.2723@ionos>
References: <20110831.230718.2029810906806382170.davem@davemloft.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

On Wed, 31 Aug 2011, David Miller wrote:
> If someone who understands our thread/process time implementation can
> look into this, I'd appreciate it.
> 
> Attached below is a watered-down version of rt/tst-cpuclock2.c from
> GLIBC.  Just build it with "gcc -o test test.c -lpthread -lrt" or
> similar.
> 
> Run it several times, and you will see cases where the main thread
> will measure a process clock difference before and after the nanosleep
> which is smaller than the cpu-burner thread's individual thread clock
> difference.  This doesn't make any sense since the cpu-burner thread
> is part of the top-level process's thread group.
> 
> I've reproduced this on both x86-64 and sparc64 (using both 32-bit and
> 64-bit binaries).
> 
> For example:
> 
> [davem@boricha build-x86_64-linux]$ ./test
> process: before(0.001221967) after(0.498624371) diff(497402404)
> thread:  before(0.000081692) after(0.498316431) diff(498234739)
> self:    before(0.001223521) after(0.001240219) diff(16698)
> [davem@boricha build-x86_64-linux]$ 
> 
> The diff of 'process' should always be >= the diff of 'thread'.
> 
> I make sure to wrap the 'thread' clock measurements the most tightly
> around the nanosleep() call, and that the 'process' clock measurements
> are the outer-most ones.
> 
> I suspect this might be some kind of artifact of how the partial
> runqueue ->clock and ->clock_task updates work?  Maybe some weird
> interaction with ->skip_clock_update?
> 
> Or is this some known issue?

That's an SMP artifact. If you run "taskset 01 ./test" the result is
always correct.

The reason why this shows deviations on SMP is how the thread times
are accumulated in thread_group_cputime(). We sum
t->se.sum_exec_runtime of all threads. So if the hog thread is
currently running on the other core (which is likely) then the runtime
field of that thread is not up to date.

The untested patch below should cure this.

Thanks,

	tglx

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 58f405b..42378cb 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -250,7 +250,7 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 	do {
 		times->utime = cputime_add(times->utime, t->utime);
 		times->stime = cputime_add(times->stime, t->stime);
-		times->sum_exec_runtime += t->se.sum_exec_runtime;
+		times->sum_exec_runtime += task_sched_runtime(t);
 	} while_each_thread(tsk, t);
 out:
 	rcu_read_unlock();


