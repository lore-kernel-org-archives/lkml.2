Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab2BPMSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 07:18:16 -0500
Received: from mail.openrapids.net ([64.15.138.104]:45271 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751080Ab2BPMSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 07:18:15 -0500
Date: Thu, 16 Feb 2012 07:18:07 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu] rcu: direct algorithmic SRCU
	implementation
Message-ID: <20120216121807.GA3426@Krystal>
References: <20120213020951.GA12138@linux.vnet.ibm.com> <20120215143116.GA1696@Krystal> <20120215145144.GA6277@Krystal> <20120216063805.GF2976@linux.vnet.ibm.com> <20120216110030.GA1425@Krystal> <1329393115.2293.204.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329393115.2293.204.camel@twins>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 07:03:14 up 449 days, 17:06,  1 user,  load average: 0.16, 0.79,
	0.90
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Thu, 2012-02-16 at 06:00 -0500, Mathieu Desnoyers wrote:
> > This brings the following question then: which memory barriers, in the
> > scheduler activity, act as full memory barriers to migrated threads ? I
> > see that the rq_lock is taken, but this lock is permeable in one
> > direction (operations can spill into the critical section). I'm probably
> > missing something else, but this something else probably needs to be
> > documented somewhere, since we are doing tons of assumptions based on
> > it. 
> 
> A migration consists of two context switches, one switching out the task
> on the old cpu, and one switching in the task on the new cpu.

If we have memory barriers on both context switches, then we should be
good. If just fail to see them.

> Now on x86 all the rq->lock grabbery is plenty implied memory barriers
> to make anybody happy.

Indeed. Outside of x86 is far less certain though.

> But I think, since there's guaranteed order (can't switch to before
> switching from) you can match the UNLOCK from the switch-from to the
> LOCK from the switch-to to make your complete MB.
> 
> Does that work or do we need more?

Hrm, I think we'd need a little more than just lock/unlock ordering
guarantees. Let's consider the following, where the stores would be
expected to be seen as "store A before store B" by CPU 2

CPU 0             CPU 1               CPU 2

                                      load B, smp_rmb, load A in loop,
                                      expecting that when updated A is
                                      observed, B is always observed as
                                      updated too.
store A
(lock is permeable:
outside can leak
inside)
lock(rq->lock)

      -> migration ->

                  unlock(rq->lock)
                  (lock is permeable:
                  outside can leak inside)
                  store B

As we notice, the "store A" could theoretically be still pending in
CPU 0's write buffers when store B occurs, because the memory barrier
associated with "lock" only has acquire semantic (so memory operations
prior to the lock can leak into the critical section).

Given that the unlock(rq->lock) on CPU 0 is not guaranteed to happen in
a bound time-frame, no memory barrier with release semantic can be
assumed to have happened. This could happen if we have a long critical
section holding the rq->lock on CPU 0, and a much shorter critical
section on CPU 1.

Does that make sense, or should I get my first morning coffee ? :)

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
