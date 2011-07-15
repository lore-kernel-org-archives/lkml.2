Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab1GORQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:16:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63284 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab1GORQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:16:49 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=MwenTAR9eMQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=bA9FToZzJlh2MWmTs6wA:9 a=WSEEPbo2kpLprKkSX-AA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: INFO: possible circular locking dependency detected
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ed Tomlinson <edt@aei.ca>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110715170304.GD2327@linux.vnet.ibm.com>
References: <20110714144946.GA3354@swordfish.minsk.epam.com>
	 <1310665613.27864.50.camel@gandalf.stny.rr.com>
	 <20110714191809.GF2349@linux.vnet.ibm.com> <201107150705.46248.edt@aei.ca>
	 <1310729362.2586.325.camel@twins>
	 <20110715124206.GA2376@linux.vnet.ibm.com>
	 <1310735259.2586.330.camel@twins>
	 <1310748957.27864.62.camel@gandalf.stny.rr.com>
	 <20110715170304.GD2327@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 15 Jul 2011 13:16:44 -0400
Message-ID: <1310750204.27864.69.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 10:03 -0700, Paul E. McKenney wrote:
> On Fri, Jul 15, 2011 at 12:55:57PM -0400, Steven Rostedt wrote:
> > On Fri, 2011-07-15 at 15:07 +0200, Peter Zijlstra wrote:
> > 
> > > OK, so the latter case cannot happen (rcu_preempt_check_callbacks only
> > > sets NEED_QS when rcu_read_lock_nesting), we need two interrupts for
> > > this to happen.
> > > 
> > > rcu_read_lock()
> > > 
> > >  <IRQ>
> > >    |= RCU_READ_UNLOCK_NEED_QS
> > > 
> > > rcu_read_unlock()
> > >   __rcu_read_unlock()
> > >    --rcu_read_lock_nesting;
> > >      <IRQ>
> > > 	ttwu()
> > >           rcu_read_lock()
> > > 	  rcu_read_unlock()
> > > 	    rcu_read_unlock_special()
> > > 	      *BANG*
> > >    rcu_read_unlock_special()
> > > 
> > 
> > What about this patch? Not even compiled tested.
> 
> This runs afoul of the restriction that ->rcu_read_unlock_special must
> be updated with irqs disabled, please see below.

What about changing special into a local_t, then it could be updated
atomically wrt interrupts (not for other CPUs).

> 
> I am also missing what the goal is -- I don't immediatly see how this
> prevents the scenario that Ed ran into, for example.

>From the example that Peter showed above:

The interrupt happens after decrementing lock_nesting, and then when it
did the rcu_read_unlock(), it would call special() because the ->special
variable was set. My patch makes it so that ->special will *not* be set.

We will probably need to put a preempt_disable() in there too, to keep
the ->special being zero and scheduled out.

> 
> 								Thanx, Paul
> 
> > -- Steve
> > 
> > diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> > index 14dc7dd..e3545fa 100644
> > --- a/kernel/rcutree_plugin.h
> > +++ b/kernel/rcutree_plugin.h
> > @@ -284,18 +284,17 @@ static struct list_head *rcu_next_node_entry(struct task_struct *t,
> >   * notify RCU core processing or task having blocked during the RCU
> >   * read-side critical section.
> >   */
> > -static void rcu_read_unlock_special(struct task_struct *t)
> > +static int rcu_read_unlock_special(struct task_struct *t, int special)
> >  {
> >  	int empty;
> >  	int empty_exp;
> >  	unsigned long flags;
> >  	struct list_head *np;
> >  	struct rcu_node *rnp;
> > -	int special;
> > 
> >  	/* NMI handlers cannot block and cannot safely manipulate state. */
> >  	if (in_nmi())
> > -		return;
> > +		return special;
> > 
> >  	local_irq_save(flags);
> > 
> > @@ -303,7 +302,6 @@ static void rcu_read_unlock_special(struct task_struct *t)
> >  	 * If RCU core is waiting for this CPU to exit critical section,
> >  	 * let it know that we have done so.
> >  	 */
> > -	special = t->rcu_read_unlock_special;
> >  	if (special & RCU_READ_UNLOCK_NEED_QS) {
> >  		rcu_preempt_qs(smp_processor_id());
> >  	}
> > @@ -311,7 +309,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
> >  	/* Hardware IRQ handlers cannot block. */
> >  	if (in_irq()) {
> >  		local_irq_restore(flags);
> > -		return;
> > +		return special;
> >  	}
> > 
> >  	/* Clean up if blocked during RCU read-side critical section. */
> > @@ -373,6 +371,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
> >  	} else {
> >  		local_irq_restore(flags);
> >  	}
> > +	return special;
> >  }
> > 
> >  /*
> > @@ -385,13 +384,21 @@ static void rcu_read_unlock_special(struct task_struct *t)
> >  void __rcu_read_unlock(void)
> >  {
> >  	struct task_struct *t = current;
> > +	int special;
> > 
> > +	special = ACCESS_ONCE(t->rcu_read_unlock_special);
> > +	/*
> > +	 * Clear special here to prevent interrupts from seeing it
> > +	 * enabled after decrementing lock_nesting and calling
> > +	 * rcu_read_unlock_special().
> > +	 */
> 
> Any change to ->rcu_read_unlock_special from an irq handler that happens
> here is lost.  Changes to ->rcu_read_unlock_special must be done with
> irqs disabled.  And I hope to avoid irq disabling on the rcu_read_unlock()
> fastpath.

We can check if special changed afterwards. Hmm, would a xchg be bad to
do?


> 
> > +	t->rcu_read_unlock_special = 0;
> >  	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutree.c */
> >  	--t->rcu_read_lock_nesting;
> >  	barrier();  /* decrement before load of ->rcu_read_unlock_special */
> > -	if (t->rcu_read_lock_nesting == 0 &&
> > -	    unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
> > -		rcu_read_unlock_special(t);
> > +	if (t->rcu_read_lock_nesting == 0 && special)
> > +		special = rcu_read_unlock_special(t, special);
> 
> And changes to ->rcu_read_unlock_special from an irq handler that happens
> here are also lost.

How expensive is xchg?

	special = xchg(&t->rcu_read_lock_special, 0);
	[..]
	special = xchg(&t->rcu_read_lock_special, special);
	/* check special */

Or is xchg too expensive for rcu_read_unlock()?

-- Steve

> 
> > +	t->rcu_read_unlock_special = special;
> >  #ifdef CONFIG_PROVE_LOCKING
> >  	WARN_ON_ONCE(ACCESS_ONCE(t->rcu_read_lock_nesting) < 0);
> >  #endif /* #ifdef CONFIG_PROVE_LOCKING */
> > 
> > 


