Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963Ab0FURFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 13:05:10 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40887 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932312Ab0FURFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 13:05:08 -0400
Date: Mon, 21 Jun 2010 10:05:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcutorture: add random preemption
Message-ID: <20100621170505.GE2354@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4C1F2986.7080006@cn.fujitsu.com>
 <20100621164306.GC2354@linux.vnet.ibm.com>
 <1277139011.1875.522.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277139011.1875.522.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 06:50:11PM +0200, Peter Zijlstra wrote:
> On Mon, 2010-06-21 at 09:43 -0700, Paul E. McKenney wrote:
> > > +#ifdef CONFIG_PREEMPT
> > > +     if (!preempt_count() && !(rcu_random(rrsp) % (nrealreaders * 20000)))
> > > +             preempt_schedule();
> > > +#endif
> > 
> > This one scared me for a bit -- then I realized that preempt_schedule()
> > won't actually schedule if preemption is in any way disabled.  So the
> > above really is OK, because Classic RCU and RCU-bh disable preemption.
> > 
> > So, should we have a comment to this effect, or is my hypersensitivity to
> > RCU semantics unique to me? 
> 
> Well it seems to do a !preempt_count() test too, so I wouldn't worry too
> much about it, still using preempt_schedule() doesn't seem right, why
> not use cond_resched()?

My guess is that Lai wants to force a call to rcu_sched_qs() even if
!need_resched().  One reason for doing this would be to put more stress
on preemptible RCU's handling of context switches in RCU read-side
critical sections.

Another approach would be to have some high-priority threads that wake up
periodically, as I plan to make rcutorture do for RCU priority boosting.
Of course, this is not necessarily mutually exclusive with Lai's approach.

							Thanx, Paul
