Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab2ECGwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 02:52:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:38768 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934Ab2ECGwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 02:52:49 -0400
Message-ID: <1336027947.12740.8.camel@pasglop>
Subject: Re: [PATCH] powerpc: use local var instead of
 local_paca->irq_happened directly in __check_irq_replay
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: Milton Miller <miltonm@bga.com>, Grant Likely <grant.likely@secretlab.ca>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Thu, 03 May 2012 16:52:27 +1000
In-Reply-To: <4FA21CD8.4060800@gmail.com>
References: <4FA1E527.1090807@gmail.com> <1336011306.2653.3.camel@pasglop>
	 <1336018961.2653.11.camel@pasglop> <4FA21CD8.4060800@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-03 at 13:51 +0800, Wang Sheng-Hui wrote:
> On 2012年05月03日 12:22, Benjamin Herrenschmidt wrote:
> > 
> >> It should not as __check_irq_replay() should always be called
> >> with interrupts hard disabled... Do you see any code path
> >> where that is not the case ?
> > 
> > More specifically, your backtrace seems to indicate that
> > __check_irq_repay() was called from arch_local_irq_restore() which
> > should have done this before calling __check_irq_replay():
> > 
> > 	if (unlikely(irq_happened != PACA_IRQ_HARD_DIS))
> > 		__hard_irq_disable();
> > 
> > Now, the only possibility that I can see for an interrupt to come in
> > and trip the problem you observed would be if for some reason we
> > had irq_happened set to PACA_IRQ_HARD_DIS while interrupts were
> > not hard disabled.
> 
> I have a chance to notice that the value is 0x05, not just 0x01.
> So I think this is not the case.

Well, it depends, the value could have been 0x01 before it hit there... 

However 0x05 means that EE is set too which means it should never have
hard-enabled to begin with. This is all very odd, we'll need to dig.

If the value had been anything other than 0x01 it would have hard
disabled interrupts meaning that paca->irq_happened cannot change
anymore until they are re-enabled at the bottom of the function.

So please try making this disable unconditional see if that makes any
difference...

Cheers,
Ben.
> > Can you try if removing the test (and thus unconditionally calling
> > __hard_irq_disable()) fixes the problem for you ?
> > 
> > If that is the case, then we need to audit the code to figure out how we
> > can end up with that bit in irq_happened set and interrupts hard
> > enabled.
> > 
> > Something like may_hard_irq_enable() shouldn't cause it since it should
> > only be called while hard disabled but adding a check in there might be
> > worth it (something like WARN_ON(mfmsr() & MSR_EE)).
> > 
> > Cheers,
> > Ben.
> > 
> >> Cheers,
> >> Ben.
> >>
> >>> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> >>> ---
> >>>  arch/powerpc/kernel/irq.c |   46 +++++++++++++++++++++++++++++---------------
> >>>  1 files changed, 30 insertions(+), 16 deletions(-)
> >>>
> >>> diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
> >>> index 5ec1b23..3d48b23 100644
> >>> --- a/arch/powerpc/kernel/irq.c
> >>> +++ b/arch/powerpc/kernel/irq.c
> >>> @@ -137,15 +137,17 @@ static inline notrace int decrementer_check_overflow(void)
> >>>   */
> >>>  notrace unsigned int __check_irq_replay(void)
> >>>  {
> >>> +	unsigned int ret_val;
> >>>  	/*
> >>>  	 * We use local_paca rather than get_paca() to avoid all
> >>>  	 * the debug_smp_processor_id() business in this low level
> >>>  	 * function
> >>>  	 */
> >>> -	unsigned char happened = local_paca->irq_happened;
> >>> +	unsigned char happened, irq_happened;
> >>> +	happened = irq_happened = local_paca->irq_happened;
> >>>  
> >>>  	/* Clear bit 0 which we wouldn't clear otherwise */
> >>> -	local_paca->irq_happened &= ~PACA_IRQ_HARD_DIS;
> >>> +	irq_happened &= ~PACA_IRQ_HARD_DIS;
> >>>  
> >>>  	/*
> >>>  	 * Force the delivery of pending soft-disabled interrupts on PS3.
> >>> @@ -161,33 +163,45 @@ notrace unsigned int __check_irq_replay(void)
> >>>  	 * decrementer itself rather than the paca irq_happened field
> >>>  	 * in case we also had a rollover while hard disabled
> >>>  	 */
> >>> -	local_paca->irq_happened &= ~PACA_IRQ_DEC;
> >>> -	if (decrementer_check_overflow())
> >>> -		return 0x900;
> >>> +	irq_happened &= ~PACA_IRQ_DEC;
> >>> +	if (decrementer_check_overflow()) {
> >>> +		ret_val = 0x900;
> >>> +		goto replay;
> >>> +	}
> >>>  
> >>>  	/* Finally check if an external interrupt happened */
> >>> -	local_paca->irq_happened &= ~PACA_IRQ_EE;
> >>> -	if (happened & PACA_IRQ_EE)
> >>> -		return 0x500;
> >>> +	irq_happened &= ~PACA_IRQ_EE;
> >>> +	if (happened & PACA_IRQ_EE) {
> >>> +		ret_val = 0x500;
> >>> +		goto replay;
> >>> +	}
> >>>  
> >>>  #ifdef CONFIG_PPC_BOOK3E
> >>>  	/* Finally check if an EPR external interrupt happened
> >>>  	 * this bit is typically set if we need to handle another
> >>>  	 * "edge" interrupt from within the MPIC "EPR" handler
> >>>  	 */
> >>> -	local_paca->irq_happened &= ~PACA_IRQ_EE_EDGE;
> >>> -	if (happened & PACA_IRQ_EE_EDGE)
> >>> -		return 0x500;
> >>> +	irq_happened &= ~PACA_IRQ_EE_EDGE;
> >>> +	if (happened & PACA_IRQ_EE_EDGE) {
> >>> +		ret_val = 0x500;
> >>> +		goto replay;
> >>> +	}
> >>>  
> >>> -	local_paca->irq_happened &= ~PACA_IRQ_DBELL;
> >>> -	if (happened & PACA_IRQ_DBELL)
> >>> -		return 0x280;
> >>> +	irq_happened &= ~PACA_IRQ_DBELL;
> >>> +	if (happened & PACA_IRQ_DBELL) {
> >>> +		ret_val = 0x280;
> >>> +		goto replay;
> >>> +	}
> >>>  #endif /* CONFIG_PPC_BOOK3E */
> >>>  
> >>>  	/* There should be nothing left ! */
> >>> -	BUG_ON(local_paca->irq_happened != 0);
> >>> +	BUG_ON(irq_happened != 0);
> >>> +	ret_val = 0;
> >>>  
> >>> -	return 0;
> >>> +replay:
> >>> +	local_paca->irq_happened = irq_happened;
> >>> +
> >>> +	return ret_val;
> >>>  }
> >>>  
> >>>  notrace void arch_local_irq_restore(unsigned long en)
> >>
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> > 
> > 


