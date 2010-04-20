Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab0DTJUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 05:20:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33092 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111Ab0DTJUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 05:20:11 -0400
Subject: Re: Considerations on sched APIs under RT patch
From: Peter Zijlstra <peterz@infradead.org>
To: Primiano Tucci <p.tucci@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx <tglx@linutronix.de>,
       rostedt <rostedt@goodmis.org>
In-Reply-To: <s2uc5b2c05b1004191348p517c8ac4z32104ea91dd1ca67@mail.gmail.com>
References: <s2uc5b2c05b1004191348p517c8ac4z32104ea91dd1ca67@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Apr 2010 11:20:08 +0200
Message-ID: <1271755208.1676.422.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-19 at 22:48 +0200, Primiano Tucci wrote:

> Yesterday days I found a strange behavior of the scheduler API's using
> the RT patch, in particular the pthread_setaffinity_np (that stands on
> sched_setaffinity).

> I think the main problem is that sched_setaffinity makes use of a
> rwlock, but rwlocks are pre-emptible with the RT patch.

It does? where?

sys_sched_setaffinity()
  sched_setaffinity()
    set_cpus_allowed_ptr()

set_cpus_allowed_ptr() is the one that does the real work, and that
takes the rq->lock and plays games with the migration thread, non of
which should be able to cause any form of priority inversion.

> So it could happen that an high priority process/thread that makes use
> of the sched_setaffinity facility could be unwillingly preempted when
> controlling other (even low-priority) processes/threads.

Well, suppose there was a rwlock_t, then for PREEMPT_RT=y that would be
mapped to an rt_mutex, which is PI aware.

> I think sched_setaffinity should make use of raw_spinlocks, or should
> anyway be guaranteed to not be pre-empted (maybe a preempt_disable?),
> otherwise could lead in unwanted situations for a Real Time OS, such
> the one described below.

It does, rq->lock is a non preemptible lock, and the migration thread
runs at a priority higher than FIFO-99.

> The issue can be easily reproduced taking inspiration from this scenario:
> 
> I have 4 Real Time Threads (SCHED_FIFO) distributed as follows:
> 
> T0 : CPU 0, Priority 2 (HIGH)
> T1 : CPU 1, Priority 2 (HIGH)
> T3 : CPU 0, Priority 1 (LOW)
> T4 : CPU 1, Priority 1 (LOW)
> 
> So T0 and T1 are actually the "big bosses" on CPUs #0 and #1, T3 and
> T4, instead, never execute (let's assume that each thread is a simple
> busy wait that never sleeps/yields) Now, at a certain point, from T0
> code, I want to migrate T4 from CPU #1 to #0, keeping its low
> priority.
> Therefore I perform a pthread_setaffinity_np from T0 changing T4 mask
> from CPU #1 to #0.
> 
> In this scenario it happens that T3 (that should never execute since
> there is T0 with higher priority currently running on the same CPU #0)
> "emerge" and executes for a bit.
> It seems that the pthread_setaffinity_np syscall is somehow
> "suspensive" for the time needed to migrate T4 and let the scheduler
> to execute T3 for that bunch of time.
> 
> What do you think about this situation? Should sched APIs be revised?

Not sure why you thinking the APIs should be changed. If this does
indeed happen then there is a bug somewhere in the implementation, the
trick will be finding it.

So you run these four RT tasks on CPUs 0,1 and then control them from
another cpu, say 2?

Can you get a function trace that illustrates T3 getting scheduled,
preferably while running the latest -rt kernel?

