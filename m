Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab2ECGdW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 02:33:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:32974 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab2ECGdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 02:33:20 -0400
Message-ID: <4FA226A8.1080903@gmail.com>
Date: Thu, 03 May 2012 14:33:12 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Milton Miller <miltonm@bga.com>, Grant Likely <grant.likely@secretlab.ca>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: use local var instead of local_paca->irq_happened
 directly in __check_irq_replay
References: <4FA1E527.1090807@gmail.com> <1336011306.2653.3.camel@pasglop> <1336018961.2653.11.camel@pasglop>
In-Reply-To: <1336018961.2653.11.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012年05月03日 12:22, Benjamin Herrenschmidt wrote:
> 
>> It should not as __check_irq_replay() should always be called
>> with interrupts hard disabled... Do you see any code path
>> where that is not the case ?
> 
> More specifically, your backtrace seems to indicate that
> __check_irq_repay() was called from arch_local_irq_restore() which
> should have done this before calling __check_irq_replay():
> 
> 	if (unlikely(irq_happened != PACA_IRQ_HARD_DIS))
> 		__hard_irq_disable();
> 
> Now, the only possibility that I can see for an interrupt to come in
> and trip the problem you observed would be if for some reason we
> had irq_happened set to PACA_IRQ_HARD_DIS while interrupts were
> not hard disabled.
> 
> Can you try if removing the test (and thus unconditionally calling
> __hard_irq_disable()) fixes the problem for you ?

The system crashed before I started the LTP test run.
========================================================
kernel BUG at /usr/src/kernels/linux/arch/powerpc/kernel/irq.c:188!
cpu 0x3: Vector: 700 (Program Check) at [c00000026ffd3bb0]
    pc: c00000000000ea9c: .__check_irq_replay+0x7c/0x90
    lr: c00000000001058c: .arch_local_irq_restore+0x4c/0x90
    sp: c00000026ffd3e30
   msr: 8000000000029032
  current = 0xc0000002694e0110
  paca    = 0xc000000003580900	 softe: 0	 irq_happened: 0x01
    pid   = 0, comm = swapper/3
kernel BUG at /usr/src/kernels/linux/arch/powerpc/kernel/irq.c:188!
enter ? for help
[link register   ] c00000000001058c .arch_local_irq_restore+0x4c/0x90
[c00000026ffd3e30] c000000000f42100 softirq_vec+0x0/0x80 (unreliable)
[c00000026ffd3ea0] c0000000000857d4 .__do_softirq+0xa4/0x2a0
[c00000026ffd3f90] c000000000022958 .call_do_softirq+0x14/0x24
[c0000002694778e0] c0000000000106c8 .do_softirq+0xf8/0x130
[c000000269477980] c0000000000854c4 .irq_exit+0xc4/0xf0
[c000000269477a00] c00000000001e970 .timer_interrupt+0x120/0x290
[c000000269477ab0] c000000000003a40 decrementer_common+0x140/0x180
--- Exception: 901 (Decrementer) at c0000000000105c4 .arch_local_irq_restore+0x84/0x90
[c000000269477da0] c000000000058400 .pSeries_idle+0x10/0x40 (unreliable)
[c000000269477e10] c000000000017d50 .cpu_idle+0x190/0x290
[c000000269477ed0] c00000000061ab04 .start_secondary+0x348/0x354
[c000000269477f90] c00000000000936c .start_secondary_prolog+0x10/0x14
3:mon> e
cpu 0x3: Vector: 700 (Program Check) at [c00000026ffd3bb0]
    pc: c00000000000ea9c: .__check_irq_replay+0x7c/0x90
    lr: c00000000001058c: .arch_local_irq_restore+0x4c/0x90
    sp: c00000026ffd3e30
   msr: 8000000000029032
  current = 0xc0000002694e0110
  paca    = 0xc000000003580900	 softe: 0	 irq_happened: 0x01
    pid   = 0, comm = swapper/3
kernel BUG at /usr/src/kernels/linux/arch/powerpc/kernel/irq.c:188!
3:mon> r
R00 = 0000000000000001   R16 = 0000000000000000
R01 = c00000026ffd3e30   R17 = 0000000000000000
R02 = c000000000edd220   R18 = 0000000000000000
R03 = 0000000000000500   R19 = 0000000000000000
R04 = 0000000000000000   R20 = c000000000f42100
R05 = 00000000000004ca   R21 = 0000000000000000
R06 = 0000000002dcc370   R22 = c000000000955b80
R07 = 003524b183dca42e   R23 = c000000000955b80
R08 = 0000000000920000   R24 = 000000000000000a
R09 = c000000003580900   R25 = 0000000000000003
R10 = 0000000000000008   R26 = c000000269474100
R11 = 0000000000000000   R27 = c00000026ffd0000
R12 = c000000000653ba8   R28 = 0000000000000000
R13 = c000000003580900   R29 = c000000000f42100
R14 = c000000269477f90   R30 = c000000000e60890
R15 = 000000000ef03f20   R31 = 0000000000000082
pc  = c00000000000ea9c .__check_irq_replay+0x7c/0x90
cfar= c00000000000ea38 .__check_irq_replay+0x18/0x90
lr  = c00000000001058c .arch_local_irq_restore+0x4c/0x90
msr = 8000000000029032   cr  = 28000028
ctr = c00000000001df50   xer = 0000000000000000   trap =  700
3:mon> t
[link register   ] c00000000001058c .arch_local_irq_restore+0x4c/0x90
[c00000026ffd3e30] c000000000f42100 softirq_vec+0x0/0x80 (unreliable)
[c00000026ffd3ea0] c0000000000857d4 .__do_softirq+0xa4/0x2a0
[c00000026ffd3f90] c000000000022958 .call_do_softirq+0x14/0x24
[c0000002694778e0] c0000000000106c8 .do_softirq+0xf8/0x130
[c000000269477980] c0000000000854c4 .irq_exit+0xc4/0xf0
[c000000269477a00] c00000000001e970 .timer_interrupt+0x120/0x290
[c000000269477ab0] c000000000003a40 decrementer_common+0x140/0x180
--- Exception: 901 (Decrementer) at c0000000000105c4 .arch_local_irq_restore+0x84/0x90
[c000000269477da0] c000000000058400 .pSeries_idle+0x10/0x40 (unreliable)
[c000000269477e10] c000000000017d50 .cpu_idle+0x190/0x290
[c000000269477ed0] c00000000061ab04 .start_secondary+0x348/0x354
[c000000269477f90] c00000000000936c .start_secondary_prolog+0x10/0x14
3:mon> di  c00000000000ea9c
c00000000000ea9c  0b000000	tdnei	r0,0
c00000000000eaa0  38600000	li	r3,0
c00000000000eaa4  4bffffc4	b	c00000000000ea68	# .__check_irq_replay+0x48/0x90
c00000000000eaa8  60000000	nop
 ...
c00000000000eab0  7c0802a6	mflr	r0
c00000000000eab4  fbc1fff0	std	r30,-16(r1)
c00000000000eab8  fba1ffe8	std	r29,-24(r1)
c00000000000eabc  fbe1fff8	std	r31,-8(r1)
c00000000000eac0  ebc28128	ld	r30,-32472(r2)
c00000000000eac4  3d230002	addis	r9,r3,2
c00000000000eac8  f8010010	std	r0,16(r1)
c00000000000eacc  f821ff71	stdu	r1,-144(r1)
c00000000000ead0  38a5ffd8	addi	r5,r5,-40
c00000000000ead4  ebe92060	ld	r31,8288(r9)
c00000000000ead8  80050048	lwz	r0,72(r5)


> 
> If that is the case, then we need to audit the code to figure out how we
> can end up with that bit in irq_happened set and interrupts hard
> enabled.
> 
> Something like may_hard_irq_enable() shouldn't cause it since it should
> only be called while hard disabled but adding a check in there might be
> worth it (something like WARN_ON(mfmsr() & MSR_EE)).
> 
> Cheers,
> Ben.
> 
>> Cheers,
>> Ben.
>>
>>> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
>>> ---
>>>  arch/powerpc/kernel/irq.c |   46 +++++++++++++++++++++++++++++---------------
>>>  1 files changed, 30 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
>>> index 5ec1b23..3d48b23 100644
>>> --- a/arch/powerpc/kernel/irq.c
>>> +++ b/arch/powerpc/kernel/irq.c
>>> @@ -137,15 +137,17 @@ static inline notrace int decrementer_check_overflow(void)
>>>   */
>>>  notrace unsigned int __check_irq_replay(void)
>>>  {
>>> +	unsigned int ret_val;
>>>  	/*
>>>  	 * We use local_paca rather than get_paca() to avoid all
>>>  	 * the debug_smp_processor_id() business in this low level
>>>  	 * function
>>>  	 */
>>> -	unsigned char happened = local_paca->irq_happened;
>>> +	unsigned char happened, irq_happened;
>>> +	happened = irq_happened = local_paca->irq_happened;
>>>  
>>>  	/* Clear bit 0 which we wouldn't clear otherwise */
>>> -	local_paca->irq_happened &= ~PACA_IRQ_HARD_DIS;
>>> +	irq_happened &= ~PACA_IRQ_HARD_DIS;
>>>  
>>>  	/*
>>>  	 * Force the delivery of pending soft-disabled interrupts on PS3.
>>> @@ -161,33 +163,45 @@ notrace unsigned int __check_irq_replay(void)
>>>  	 * decrementer itself rather than the paca irq_happened field
>>>  	 * in case we also had a rollover while hard disabled
>>>  	 */
>>> -	local_paca->irq_happened &= ~PACA_IRQ_DEC;
>>> -	if (decrementer_check_overflow())
>>> -		return 0x900;
>>> +	irq_happened &= ~PACA_IRQ_DEC;
>>> +	if (decrementer_check_overflow()) {
>>> +		ret_val = 0x900;
>>> +		goto replay;
>>> +	}
>>>  
>>>  	/* Finally check if an external interrupt happened */
>>> -	local_paca->irq_happened &= ~PACA_IRQ_EE;
>>> -	if (happened & PACA_IRQ_EE)
>>> -		return 0x500;
>>> +	irq_happened &= ~PACA_IRQ_EE;
>>> +	if (happened & PACA_IRQ_EE) {
>>> +		ret_val = 0x500;
>>> +		goto replay;
>>> +	}
>>>  
>>>  #ifdef CONFIG_PPC_BOOK3E
>>>  	/* Finally check if an EPR external interrupt happened
>>>  	 * this bit is typically set if we need to handle another
>>>  	 * "edge" interrupt from within the MPIC "EPR" handler
>>>  	 */
>>> -	local_paca->irq_happened &= ~PACA_IRQ_EE_EDGE;
>>> -	if (happened & PACA_IRQ_EE_EDGE)
>>> -		return 0x500;
>>> +	irq_happened &= ~PACA_IRQ_EE_EDGE;
>>> +	if (happened & PACA_IRQ_EE_EDGE) {
>>> +		ret_val = 0x500;
>>> +		goto replay;
>>> +	}
>>>  
>>> -	local_paca->irq_happened &= ~PACA_IRQ_DBELL;
>>> -	if (happened & PACA_IRQ_DBELL)
>>> -		return 0x280;
>>> +	irq_happened &= ~PACA_IRQ_DBELL;
>>> +	if (happened & PACA_IRQ_DBELL) {
>>> +		ret_val = 0x280;
>>> +		goto replay;
>>> +	}
>>>  #endif /* CONFIG_PPC_BOOK3E */
>>>  
>>>  	/* There should be nothing left ! */
>>> -	BUG_ON(local_paca->irq_happened != 0);
>>> +	BUG_ON(irq_happened != 0);
>>> +	ret_val = 0;
>>>  
>>> -	return 0;
>>> +replay:
>>> +	local_paca->irq_happened = irq_happened;
>>> +
>>> +	return ret_val;
>>>  }
>>>  
>>>  notrace void arch_local_irq_restore(unsigned long en)
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

