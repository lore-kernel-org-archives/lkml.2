Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab3AAHob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 02:44:31 -0500
Received: from kiruna.synopsys.com ([198.182.44.80]:37304 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab3AAHo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 02:44:28 -0500
Message-ID: <50E293CD.8040004@synopsys.com>
Date: Tue, 1 Jan 2013 13:14:13 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>
Subject: Re: [RFC PATCH v1 02/31] ARC: irqflags
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <1352281674-2186-3-git-send-email-vgupta@synopsys.com> <alpine.LFD.2.02.1211122039100.10000@ionos>
In-Reply-To: <alpine.LFD.2.02.1211122039100.10000@ionos>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2012 01:20 AM, Thomas Gleixner wrote:
> On Wed, 7 Nov 2012, Vineet Gupta wrote:
>> + ******************************************************************
>> + *      Inline ASM macros to read/write AUX Regs
>> + *      Essentially invocation of lr/sr insns from "C"
>> + */
>> +
>> +#if 1
> 
> Leftover ???

Kind of -  the gcc builtins sometimes tend to generate good code and sometimes
they don't. I wanted to retain the inline asm version for experimenting sake. But
if it's too ugly, I can get rid of one of them.

> 
>> +#define read_aux_reg(reg)	__builtin_arc_lr(reg)
>> +
>> +/* gcc builtin sr needs reg param to be long immediate */
>> +#define write_aux_reg(reg_immed, val)		\
>> +		__builtin_arc_sr((unsigned int)val, reg_immed)
>> +
>> +#else
>> +/*
>> + * Conditionally Enable IRQs
> 
>   Unconditionally methinks

ofcourse - fixed !


> The following two functions are related to irq chips I guess. So why
> would you want them here ?
> 
>> +static inline void arch_mask_irq(unsigned int irq)
>> +{
>> +	unsigned int ienb;
>> +
>> +	ienb = read_aux_reg(AUX_IENABLE);
>> +	ienb &= ~(1 << irq);
>> +	write_aux_reg(AUX_IENABLE, ienb);
>> +}
>> +
>> +static inline void arch_unmask_irq(unsigned int irq)
>> +{
>> +	unsigned int ienb;
>> +
>> +	ienb = read_aux_reg(AUX_IENABLE);
>> +	ienb |= (1 << irq);
>> +	write_aux_reg(AUX_IENABLE, ienb);
>> +}
> 
> The only user is the interrupt controller code, right?

These are the platform agnostic routines which handle the in-core interrupt
controller, hence provided as helpers. The simpler plat-arcfpga (PATCH 12/31) uses
them as it is while a bunch of other platforms (yet to be submitted) might
conditionally use depending upon whether a IRQ is cascaded or not.


>> diff --git a/arch/arc/kernel/irq.c b/arch/arc/kernel/irq.c
>> new file mode 100644
>> index 0000000..16fcbe8
>> --- /dev/null
>> +++ b/arch/arc/kernel/irq.c
>> @@ -0,0 +1,32 @@
>> +/*
>> + * Copyright (C) 2011-12 Synopsys, Inc. (www.synopsys.com)
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + */
>> +
>> +#include <linux/interrupt.h>
>> +#include <linux/module.h>
>> +#include <asm/irqflags.h>
>> +#include <asm/arcregs.h>
>> +
>> +void arch_local_irq_enable(void)
>> +{
>> +
>> +	unsigned long flags;
>> +	flags = arch_local_save_flags();
>> +	flags |= (STATUS_E1_MASK | STATUS_E2_MASK);
>> +
>> +	/*
>> +	 * If called from hard ISR (between irq_enter and irq_exit)
>> +	 * don't allow Level 1. In Soft ISR we allow further Level 1s
>> +	 */
>> +
>> +	if (in_irq())
>> +		flags &= ~(STATUS_E1_MASK | STATUS_E2_MASK);
> 
> Hmm. This looks weird and the comment is not very helpful. So using my
> crystal ball you want to enforce, that nothing enables interrupts
> while a hard interrupt handler is running, right?

Correct. I'll fix the comment.

> 
> Is there a chip limitation which you have to enforce here? If yes,
> then please explain it.

Yes and No. This is from our 2.6.26 days and AFAIKR, it was indeed ARC IDE driver
enabling IRQ from within hard ISR context. The issue however became critical when
I added support for the ARC700 in-core interrupt controller which provides 2
levels of interrupts per IRQ (kind of ARM FIQ): L2 (High priority) could interrupt
L1 (low). The priority management (among other - don't allow L1 if L2 active) is
done with 2 pairs of bits in STATUS32 (CPU flags) register
* A1/A2 (Level-n active)
* E1/E2 (Level-n enabled)

However since the OS is allowed to write to E1/E2 bits, independent of A1/A2, it
is possible to re-enable interrupts even from hard-isr context. When IDE driver
re-enabled L1 interrupts in L2 ISR - we had the basic low level irq handling
messed by because of L1-L2-L1 scenarion

The patch which implements the 2 intc priorities support is separate. It probably
fell of your radar since it was in mini-series #2 of v1 patchset @
https://lkml.org/lkml/2012/11/12/125). Once I respin v2 series for review, would
request you to please take a look at that one as well (currently has a bad hack of
disabling task preemption in a corner case - which of all people, you, would
certainly loathe seeing)


> Btw, all hard interrupt handlers in Linux run with interrupts disabled and
> they are not supposed to reenable interrupts, which is true for almost
> all drivers except for a few archaic IDE drivers. In fact you might
> even WARN about it at least once, so the offending code gets fixed.

Sure - did that in next version.


> Also the code flow is backwards. What about:
> 
>      unsigned long flags;
> 
>      if (in_irq())
> 	    return;
> 
>      flags = ....	    
> 
> 
>> +	arch_local_irq_restore(flags);
>> +}
> 

Indeed fixed in v2. Actually the prev version would *disable* the IRQs if
in_irq(), now we leave status quo and return - but given that we return - they
will not be enabled in first place - so there's no semantical change - assuming
everything goes via local_irq_xxx friends.

Honestly I'm a bit ashamed for having had above crappy snippet for years. Thanks
for taking time to review this and sincere apologies for coming back to you so
late - I was held up with other things including a big ticket item pointed by Arnd
in review (no-legacy syscalls).


> Thanks,
> 
> 	tglx
> 

