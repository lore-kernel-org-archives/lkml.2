Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab1K1RRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 12:17:49 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50064 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab1K1RRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 12:17:48 -0500
Date: Mon, 28 Nov 2011 09:15:13 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 24/28] rcu: Introduce bulk reference
 count
Message-ID: <20111128171513.GF2346@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111102203017.GA3830@linux.vnet.ibm.com>
 <1320265849-5744-24-git-send-email-paulmck@linux.vnet.ibm.com>
 <1322484071.2921.115.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322484071.2921.115.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11112817-8974-0000-0000-0000036A3023
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 01:41:11PM +0100, Peter Zijlstra wrote:
> On Wed, 2011-11-02 at 13:30 -0700, Paul E. McKenney wrote:
> > The RCU implementations, including SRCU, are designed to be used in a
> > lock-like fashion, so that the read-side lock and unlock primitives must
> > execute in the same context for any given read-side critical section.
> > This constraint is enforced by lockdep-RCU.  However, there is a need for
> > something that acts more like a reference count than a lock, in order
> > to allow (for example) the reference to be acquired within the context
> > of an exception, while that same reference is released in the context of
> > the task that encountered the exception.  The cost of this capability is
> > that the read-side operations incur the overhead of disabling interrupts.
> > Some optimization is possible, and will be carried out if warranted.
> > 
> > Note that although the current implementation allows a given reference to
> > be acquired by one task and then released by another, all known possible
> > implementations that allow this have scalability problems.  Therefore,
> > a given reference must be released by the same task that acquired it,
> > though perhaps from an interrupt or exception handler running within
> > that task's context.
> 
> I'm having trouble with the naming as well as the need for an explicit
> new API.
> 
> To me this looks like a regular (S)RCU variant, nothing to do with
> references per-se (aside from the fact that SRCU is a refcounted rcu
> variant). Also WTF is this bulk stuff about? Its still a single ref at a
> time, not 10s or 100s or whatnot.

It is a bulk reference in comparison to a conventional atomic_inc()-style
reference count, which is normally associated with a specific structure.
In contrast, doing a bulkref_get() normally protects a group of structures,
everything covered by the bulkref_t.

Yes, in theory you could have a global reference counter that protected
a group of structures, but in practice we both know that this would not
end well.  ;-)

> > +static inline int bulkref_get(bulkref_t *brp)
> > +{
> > +	unsigned long flags;
> > +	int ret;
> > +
> > +	local_irq_save(flags);
> > +	ret =  __srcu_read_lock(brp);
> > +	local_irq_restore(flags);
> > +	return ret;
> > +}
> > +
> > +static inline void bulkref_put(bulkref_t *brp, int idx)
> > +{
> > +	unsigned long flags;
> > +
> > +	local_irq_save(flags);
> > +	__srcu_read_unlock(brp, idx);
> > +	local_irq_restore(flags);
> > +}
> 
> This seems to be the main gist of the patch, which to me sounds utterly
> ridiculous. Why not document that srcu_read_{un,}lock() aren't IRQ safe
> and if you want to use it from those contexts you have to fix it up
> yourself.

I thought I had documented this, but I guess not.  I will add that.

I lost you on the "fix it up yourself" -- what are you suggesting that
someone needing to use RCU in this manner actually do?

> RCU lockdep doesn't do the full validation so it won't actually catch it
> if you mess up the irq states, but I guess if you want we could look at
> adding that.

Ah, I had missed that.  Yes, it would be very good if that could be added.
The vast majority of the uses exit the RCU read-side critical section in
the same context that they enter it, so it would be good to check.

> > diff --git a/kernel/srcu.c b/kernel/srcu.c
> > index 73ce23f..10214c8 100644
> > --- a/kernel/srcu.c
> > +++ b/kernel/srcu.c
> > @@ -34,13 +34,14 @@
> >  #include <linux/delay.h>
> >  #include <linux/srcu.h>
> >  
> > -static int init_srcu_struct_fields(struct srcu_struct *sp)
> > +int init_srcu_struct_fields(struct srcu_struct *sp)
> >  {
> >  	sp->completed = 0;
> >  	mutex_init(&sp->mutex);
> >  	sp->per_cpu_ref = alloc_percpu(struct srcu_struct_array);
> >  	return sp->per_cpu_ref ? 0 : -ENOMEM;
> >  }
> > +EXPORT_SYMBOL_GPL(init_srcu_struct_fields);
> 
> What do we need this export for? Usually we don't add exports unless
> there's a use-case. Since Srikar requested this nonsense, I guess the
> user is uprobes, but that isn't a module, so no export needed.

Yep, the user is uprobes.  The export is for rcutorture, which can run
as a module.

							Thanx, Paul

