Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab1BWOLq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 09:11:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48604 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880Ab1BWOLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 09:11:45 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=jNfASM90n5oA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=VnNF1IyMAAAA:8 a=BlnHduZpV6Z90Tvco4cA:9 a=EO-E5QtwyNllPJREo9FXne_ZC-kA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH RFC tip/core/rcu 05/11] rcu: add comment saying why
 DEBUG_OBJECTS_RCU_HEAD depends on PREEMPT.
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com
In-Reply-To: <BLU0-SMTP615CB0BE0A2623EF62925096DB0@phx.gbl>
References: <20110223013917.GA20996@linux.vnet.ibm.com>
	 <1298425183-21265-5-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1298431409.7666.76.camel@gandalf.stny.rr.com>
	 <BLU0-SMTP615CB0BE0A2623EF62925096DB0@phx.gbl>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 23 Feb 2011 09:11:43 -0500
Message-ID: <1298470303.7666.80.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-23 at 08:59 -0500, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > On Tue, 2011-02-22 at 17:39 -0800, Paul E. McKenney wrote:
> > > The build will break if you change the Kconfig to allow
> > > DEBUG_OBJECTS_RCU_HEAD and !PREEMPT, so document the reasoning
> > > near where the breakage would occur.
> > > 
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > ---
> > >  kernel/rcupdate.c |    5 +++++
> > >  1 files changed, 5 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
> > > index afd21d1..f3240e9 100644
> > > --- a/kernel/rcupdate.c
> > > +++ b/kernel/rcupdate.c
> > > @@ -214,6 +214,11 @@ static int rcuhead_fixup_free(void *addr, enum debug_obj_state state)
> > >  		 * Ensure that queued callbacks are all executed.
> > >  		 * If we detect that we are nested in a RCU read-side critical
> > >  		 * section, we should simply fail, otherwise we would deadlock.
> > > +		 * Note that the machinery to reliably determine whether
> > > +		 * or not we are in an RCU read-side critical section
> > > +		 * exists only in the preemptible RCU implementations
> > > +		 * (TINY_PREEMPT_RCU and TREE_PREEMPT_RCU), which is why
> > > +		 * DEBUG_OBJECTS_RCU_HEAD is disallowed if !PREEMPT.
> > >  		 */
> > 
> > Shouldn't this comment also be in the kconfig where
> > DEBUG_OBJECTS_RCU_HEAD is defined?
> 
> hrm, but this is a "rcuhead_fixup_init" : it does not need to always

Looks like it was in rcuhead_fixup_free to me.

> succeed. It's just that when it is safe to recover from an error
> situation, it does it. We could do:
> 
> #ifdef CONFIG_PREEMPT
>                 /*
>                  * Ensure that queued callbacks are all executed.
>                  * If we detect that we are nested in a RCU read-side
>                  * critical
>                  * section, we should simply fail, otherwise we would
>                  * deadlock.
>                  */
>                 if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
>                     irqs_disabled()) {
>                         WARN_ON(1);
>                         return 0;
>                 }
>                 rcu_barrier();
>                 rcu_barrier_sched();
>                 rcu_barrier_bh();
>                 debug_object_init(head, &rcuhead_debug_descr);
>                 return 1;
> #else
> 		return 0;
> #endif
> 
> instead, no ?

The point is that this entire block of code is wrapped in #ifdef
CONFIG_DEBUG_OBJECTS_RCU_HEAD, and that config depends on PREEMPT. Thus
you will never have a case where #ifdef CONFIG_PREEMPT is false.

-- Steve


