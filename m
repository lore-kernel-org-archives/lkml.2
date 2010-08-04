Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab0HDVpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 17:45:55 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:59303 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab0HDVps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 17:45:48 -0400
Subject: Re: [RT,RFC] Hacks allowing -rt to run on POWER7 / Powerpc.
From: Will Schmidt <will_schmidt@vnet.ibm.com>
Reply-To: will_schmidt@vnet.ibm.com
To: Milton Miller <miltonm@bga.com>
Cc: rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Darren Hart <dvhltc@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1278834594_17749@mail4.comsite.net>
References: <1278701701.24737.19.camel@lexx>
	 <1278834594_17749@mail4.comsite.net>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Wed, 04 Aug 2010 16:45:34 -0500
Message-ID: <1280958334.4034.187.camel@lexx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-07-11 at 02:49 -0500, Milton Miller wrote:
> On Fri, 09 Jul 2010 about 08:55:01 -0000, Will Schmidt wrote:
> > We've been seeing some issues with userspace randomly SIGSEGV'ing while
> > running the -RT kernels on POWER7 based systems.   After lots of
> > debugging, head scratching, and experimental changes to the code, the
> > problem has been narrowed down such that we can avoid the problems by
> > disabling the TLB batching.
> > 
> > After some input from Ben and further debug, we've found that the
> > restoration of the batch->active value near the end of __switch_to()
> > seems to be the key.    ( The -RT related  changes within
> > arch/powerpc/kernel/processor.c __switch_to()  do the equivalent of a
> > arch_leave_lazy_mmu_mode() before calling _switch, use a hadbatch flag
> > to indicate if batching was active, and then restore that batch->active
> > value on the way out after the call to _switch_to.    That particular
> > code is in the -RT branch, and not found in mainline  )
> > 
> > Deferring to Ben (or others in the know) for whether this is the proper
> > solution or if there is something deeper, but.. 

I believe this is still on Ben's list of things to look at.   Between
then and now, I'll see if I can get Thomas to pick this up for the -RT
tree to keep RT functional on P7 in the mean-time.  

A bit more debug info below.

> 
> 
> I looked at the patch and noticed 2 changes:
> 	1) the batch is checked and cleared after local_irq_save
> 	2) enabling the batch is skipped
> 
> I talked to Will and had him try moving the local_irq_save above the
> check for the active batch.  That alone did not seem to be enough.
> However, he confirmed that we are setting batch to active when it is
> already active in lazy_mmu_enter, meaning that batching is being turned
> on recursively.  I suggested debug to check that irqs are off after the
> restore when re-enabling when our debug session timed out.

Based on some of the debug suggestions from Milton:


A WARN_ON for (!irqs_disabled) after local_irq_restore() did not show
any hits.  (while otherwise continuing to suffer from the tlb batching
troubles). 

---><----

	hard_irq_disable();
	last = _switch(old_thread, new_thread);

	local_irq_restore(flags);

	WARN_ON(!irqs_disabled());        <<<<----------


#if defined(CONFIG_PPC64) && defined(CONFIG_PREEMPT_RT) && 1
	if (hadbatch) {
		batch = &__get_cpu_var(ppc64_tlb_batch);
		batch->active = 1;
	}
#endif

----><---- 


Another assortment of WARN_ONs in the arch_{enter,leave}_lazy_mmu_mode
functions.  As Milton stated above, the check for batch->active on the
way into the arch_enter_* function did generate lots of hits, the other
warn_ons did not.

-----><-------
static inline void arch_enter_lazy_mmu_mode(void)
{
	struct ppc64_tlb_batch *batch = &get_cpu_var(ppc64_tlb_batch);

//|-----WARN_ON(batch->active);     /* lots of hits if enabled */
|-------WARN_ON(irqs_disabled());     /* nothing.... */
|-------batch->active = 1;

....


static inline void arch_leave_lazy_mmu_mode(void)
{
|-------struct ppc64_tlb_batch *batch = &get_cpu_var(ppc64_tlb_batch);

|-------WARN_ON(!batch->active);    /* nothing.....*/
|-------WARN_ON(irqs_disabled());    /* nothing.... */

....



> 
> milton
> 
> > 
> > diff -aurp linux-2.6.33.5-rt23.orig/arch/powerpc/kernel/process.c linux-2.6.33.5-rt23.exp/arch/powerpc/kernel/process.c
> > --- linux-2.6.33.5-rt23.orig/arch/powerpc/kernel/process.c	2010-06-21 11:41:34.402513904 -0500
> > +++ linux-2.6.33.5-rt23.exp/arch/powerpc/kernel/process.c	2010-07-09 13:15:13.533269904 -0500
> > @@ -304,10 +304,6 @@ struct task_struct *__switch_to(struct t
> >  	struct thread_struct *new_thread, *old_thread;
> >  	unsigned long flags;
> >  	struct task_struct *last;
> > -#if defined(CONFIG_PPC64) && defined (CONFIG_PREEMPT_RT)
> > -	struct ppc64_tlb_batch *batch;
> > -	int hadbatch;
> > -#endif
> >  
> >  #ifdef CONFIG_SMP
> >  	/* avoid complexity of lazy save/restore of fpu
> > @@ -401,16 +397,6 @@ struct task_struct *__switch_to(struct t
> >  		new_thread->start_tb = current_tb;
> >  	}
> >  
> > -#ifdef CONFIG_PREEMPT_RT
> > -	batch = &__get_cpu_var(ppc64_tlb_batch);
> > -	if (batch->active) {
> > -		hadbatch = 1;
> > -		if (batch->index) {
> > -			__flush_tlb_pending(batch);
> > -		}
> > -		batch->active = 0;
> > -	}
> > -#endif /* #ifdef CONFIG_PREEMPT_RT */
> >  #endif
> >  
> >  	local_irq_save(flags);
> > @@ -425,16 +411,13 @@ struct task_struct *__switch_to(struct t
> >  	 * of sync. Hard disable here.
> >  	 */
> >  	hard_irq_disable();
> > -	last = _switch(old_thread, new_thread);
> > -
> > -	local_irq_restore(flags);
> >  
> >  #if defined(CONFIG_PPC64) && defined(CONFIG_PREEMPT_RT)
> > -	if (hadbatch) {
> > -		batch = &__get_cpu_var(ppc64_tlb_batch);
> > -		batch->active = 1;
> > -	}
> > +	arch_leave_lazy_mmu_mode();
> >  #endif
> > +	last = _switch(old_thread, new_thread);
> > +
> > +	local_irq_restore(flags);
> >  
> >  	return last;
> >  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


