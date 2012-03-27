Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab2C0FPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 01:15:30 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:34644 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab2C0FP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 01:15:27 -0400
Date: Mon, 26 Mar 2012 22:15:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org, torvalds@linux-foundation.org
Subject: Re: [PATCH RFC] rcu: Make __rcu_read_lock() inlinable
Message-ID: <20120327051515.GO2450@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120325205249.GA29528@linux.vnet.ibm.com>
 <1332748484.16159.61.camel@twins>
 <20120326183232.GK2450@linux.vnet.ibm.com>
 <1332787630.16159.182.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332787630.16159.182.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032705-5518-0000-0000-0000033B46D0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 08:47:10PM +0200, Peter Zijlstra wrote:
> On Mon, 2012-03-26 at 11:32 -0700, Paul E. McKenney wrote:
> > 
> > I could inline them into sched.h, if you are agreeable.
> 
> Sure, or put it in kernel/sched/core.c.

That was my first thought, but there is a use of switch_to() in
arch/um/drivers/mconsole_kern.c.

> > I am a bit concerned about putting them both together because I am betting
> > that at least some of the architectures having tracing in switch_to(),
> > which I currently do not handle well. 
> 
> I would hope not.. there's a generic trace_sched_switch() and
> switch_to() is supposed to be black magic. I'd be fine breaking that as
> long as we can detect it.

Hmmm...  I am not yet sure whether it is easier to make RCU use legal
in switch_to() or to detect it.  I am inclined to take whatever course
is easiest, which is likely to make it legal.  :-/

> >  At the moment, the ways I can
> > think of to handle it well require saving before the switch and restoring
> > afterwards.  Otherwise, I can end up with the ->rcu_read_unlock_special
> > flags getting associated with the wrong RCU read-side critical section,
> > as happened last year.
> > 
> > Preemption is disabled at this point, correct?
> 
> Yeah, and soon we'll have interrupts disabled as well (on all archs,
> currently only ARM has interrupts enabled at this point).

Good to know!

> > Hmmm...  One way that I could reduce the overhead that preemptible RCU
> > imposes on the scheduler would be to move the task_struct queuing from
> > its current point upon entry to the scheduler to just before switch_to().
> > (The _bh and _sched quiescent states still need to remain at scheduler
> > entry.)  That would mean that RCU would not queue tasks that entered
> > the scheduler, but did not actually do a context switch.
> 
> That would make sense anyhow, right? No point in queueing a task if you
> didn't actually switch away from it.

Also it would simplify the save and restore operation, I believe.

> > Would that be helpful?
> 
> For now that's preemptible rcu only, and as such a somewhat niche
> feature (iirc its not enabled in the big distros) so I don't think it
> matters too much. But yeah, would be nice.

OK, let me see what works best.

							Thanx, Paul

