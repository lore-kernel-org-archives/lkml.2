Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab2CZTPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 15:15:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44300 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab2CZTPi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 15:15:38 -0400
Message-ID: <1332787630.16159.182.camel@twins>
Subject: Re: [PATCH RFC] rcu: Make __rcu_read_lock() inlinable
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org, torvalds@linux-foundation.org
Date: Mon, 26 Mar 2012 20:47:10 +0200
In-Reply-To: <20120326183232.GK2450@linux.vnet.ibm.com>
References: <20120325205249.GA29528@linux.vnet.ibm.com>
	 <1332748484.16159.61.camel@twins>
	 <20120326183232.GK2450@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-26 at 11:32 -0700, Paul E. McKenney wrote:
> 
> I could inline them into sched.h, if you are agreeable.

Sure, or put it in kernel/sched/core.c.

> I am a bit concerned about putting them both together because I am betting
> that at least some of the architectures having tracing in switch_to(),
> which I currently do not handle well. 

I would hope not.. there's a generic trace_sched_switch() and
switch_to() is supposed to be black magic. I'd be fine breaking that as
long as we can detect it.

>  At the moment, the ways I can
> think of to handle it well require saving before the switch and restoring
> afterwards.  Otherwise, I can end up with the ->rcu_read_unlock_special
> flags getting associated with the wrong RCU read-side critical section,
> as happened last year.
> 
> Preemption is disabled at this point, correct?

Yeah, and soon we'll have interrupts disabled as well (on all archs,
currently only ARM has interrupts enabled at this point).

> Hmmm...  One way that I could reduce the overhead that preemptible RCU
> imposes on the scheduler would be to move the task_struct queuing from
> its current point upon entry to the scheduler to just before switch_to().
> (The _bh and _sched quiescent states still need to remain at scheduler
> entry.)  That would mean that RCU would not queue tasks that entered
> the scheduler, but did not actually do a context switch.

That would make sense anyhow, right? No point in queueing a task if you
didn't actually switch away from it.

> Would that be helpful?

For now that's preemptible rcu only, and as such a somewhat niche
feature (iirc its not enabled in the big distros) so I don't think it
matters too much. But yeah, would be nice.
