Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab0HPWYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 18:24:08 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60844 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756457Ab0HPWYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 18:24:06 -0400
Date: Mon, 16 Aug 2010 15:24:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH tip/core/rcu 08/10] rcu: Add a TINY_PREEMPT_RCU
Message-ID: <20100816222402.GM2388@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100809221447.GA24358@linux.vnet.ibm.com>
 <1281392111-25060-8-git-send-email-paulmck@linux.vnet.ibm.com>
 <20100816150737.GB8320@Krystal>
 <20100816183355.GH2388@linux.vnet.ibm.com>
 <20100816191947.GA970@Krystal>
 <20100816213200.GK2388@linux.vnet.ibm.com>
 <20100816214123.GA15663@Krystal>
 <20100816215555.GL2388@linux.vnet.ibm.com>
 <20100816220705.GA18650@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100816220705.GA18650@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 06:07:05PM -0400, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Mon, Aug 16, 2010 at 05:41:23PM -0400, Mathieu Desnoyers wrote:
> > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > On Mon, Aug 16, 2010 at 03:19:47PM -0400, Mathieu Desnoyers wrote:
> > > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > > > On Mon, Aug 16, 2010 at 11:07:37AM -0400, Mathieu Desnoyers wrote:
> > > > > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > > > > [...]
> > > > > > > > +
> > > > > > > > +/*
> > > > > > > > + * Tiny-preemptible RCU implementation for rcu_read_unlock().
> > > > > > > > + * Decrement ->rcu_read_lock_nesting.  If the result is zero (outermost
> > > > > > > > + * rcu_read_unlock()) and ->rcu_read_unlock_special is non-zero, then
> > > > > > > > + * invoke rcu_read_unlock_special() to clean up after a context switch
> > > > > > > > + * in an RCU read-side critical section and other special cases.
> > > > > > > > + */
> > > > > > > > +void __rcu_read_unlock(void)
> > > > > > > > +{
> > > > > > > > +	struct task_struct *t = current;
> > > > > > > > +
> > > > > > > > +	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutiny.c */
> > > > > > > > +	if (--t->rcu_read_lock_nesting == 0 &&
> > > > > > > > +	    unlikely(t->rcu_read_unlock_special))
> > > > > > 
> > > > > > First, thank you for looking this over!!!
> > > > > > 
> > > > > > > Hrm I think we discussed this in a past life, but would the following
> > > > > > > sequence be possible and correct ?
> > > > > > > 
> > > > > > > CPU 0
> > > > > > > 
> > > > > > > read t->rcu_read_unlock_special
> > > > > > >   interrupt comes in, preempts. sets t->rcu_read_unlock_special
> > > > > > >   <preempted>
> > > > > > >   <scheduled back>
> > > > > > >   iret
> > > > > > > decrement and read t->rcu_read_lock_nesting
> > > > > > > test both old "special" value (which we have locally on the stack) and
> > > > > > > detect that rcu_read_lock_nesting is 0.
> > > > > > > 
> > > > > > > We actually missed a reschedule.
> > > > > > > 
> > > > > > > I think we might need a barrier() between the t->rcu_read_lock_nesting
> > > > > > > and t->rcu_read_unlock_special reads.
> > > > > > 
> > > > > > You are correct -- I got too aggressive in eliminating synchronization.
> > > > > > 
> > > > > > Good catch!!!
> > > > > > 
> > > > > > I added an ACCESS_ONCE() to the second term of the "if" condition so
> > > > > > that it now reads:
> > > > > > 
> > > > > > 	if (--t->rcu_read_lock_nesting == 0 &&
> > > > > > 	    unlikely((ACCESS_ONCE(t->rcu_read_unlock_special)))
> > > > > > 
> > > > > > This prevents the compiler from reordering because the ACCESS_ONCE()
> > > > > > prohibits accessing t->rcu_read_unlock_special unless the value of
> > > > > > t->rcu_read_lock_nesting is known to be zero.
> > > > > 
> > > > > Hrm, --t->rcu_read_lock_nesting does not have any globally visible
> > > > > side-effect, so the compiler is free to reorder the memory access across
> > > > > the rcu_read_unlock_special access. I think we need the ACCESS_ONCE()
> > > > > around the t->rcu_read_lock_nesting access too.
> > > > 
> > > > Indeed, it is free to reorder that access.  This has the effect of
> > > > extending the scope of the RCU read-side critical section, which is
> > > > harmless as long as it doesn't pull a lock or some such into it.
> > > > 
> > > 
> > > So what happens if we get:
> > > 
> > > CPU 0
> > > 
> > > read t->rcu_read_lock_nesting
> > > check if equals to 1
> > > read t->rcu_read_unlock_special
> > >   interrupt comes in, preempts. sets t->rcu_read_unlock_special
> > >   <preempted>
> > >   <scheduled back>
> > >   iret
> > > decrement t->rcu_read_lock_nesting
> > 
> > Moving this down past the check of t->rcu_read_lock_special (which is
> > now covered by ACCESS_ONCE()) would violate the C standard, as it would
> > be equivalent to moving a volatile up past a sequence point.
> 
> Hrm, I'm not quite convinced yet. I am not concerned about gcc moving
> the volatile access prior to the sequence point (as you say, this is
> forbidden by the C standard), but rather that:
> 
> --(t->rcu_read_lock_nesting)
> 
> could be split in two distinct operations:
> 
> read t->rcu_read_lock_nesting
> decrement t->rcu_read_lock_nesting
> 
> Note that in order to know the result required to pass the sequence
> point "&&" (the test), we only need to perform the read, not the
> decrement. AFAIU, gcc would be in its rights to move the
> t->rcu_read_lock_nesting update after the volatile access.

I will run this by some compiler experts.

							Thanx, Paul
