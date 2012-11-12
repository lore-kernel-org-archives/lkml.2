Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab2KLTul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 14:50:41 -0500
Received: from www.linutronix.de ([62.245.132.108]:48784 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab2KLTuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 14:50:39 -0500
Date: Mon, 12 Nov 2012 20:50:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [RFC PATCH v1 02/31] ARC: irqflags
In-Reply-To: <1352281674-2186-3-git-send-email-vgupta@synopsys.com>
Message-ID: <alpine.LFD.2.02.1211122039100.10000@ionos>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <1352281674-2186-3-git-send-email-vgupta@synopsys.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2012, Vineet Gupta wrote:
> + ******************************************************************
> + *      Inline ASM macros to read/write AUX Regs
> + *      Essentially invocation of lr/sr insns from "C"
> + */
> +
> +#if 1

Leftover ???

> +#define read_aux_reg(reg)	__builtin_arc_lr(reg)
> +
> +/* gcc builtin sr needs reg param to be long immediate */
> +#define write_aux_reg(reg_immed, val)		\
> +		__builtin_arc_sr((unsigned int)val, reg_immed)
> +
> +#else
> +/*
> + * Conditionally Enable IRQs

  Unconditionally methinks


The following two functions are related to irq chips I guess. So why
would you want them here ?

> +static inline void arch_mask_irq(unsigned int irq)
> +{
> +	unsigned int ienb;
> +
> +	ienb = read_aux_reg(AUX_IENABLE);
> +	ienb &= ~(1 << irq);
> +	write_aux_reg(AUX_IENABLE, ienb);
> +}
> +
> +static inline void arch_unmask_irq(unsigned int irq)
> +{
> +	unsigned int ienb;
> +
> +	ienb = read_aux_reg(AUX_IENABLE);
> +	ienb |= (1 << irq);
> +	write_aux_reg(AUX_IENABLE, ienb);
> +}

The only user is the interrupt controller code, right?

> diff --git a/arch/arc/kernel/irq.c b/arch/arc/kernel/irq.c
> new file mode 100644
> index 0000000..16fcbe8
> --- /dev/null
> +++ b/arch/arc/kernel/irq.c
> @@ -0,0 +1,32 @@
> +/*
> + * Copyright (C) 2011-12 Synopsys, Inc. (www.synopsys.com)
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <asm/irqflags.h>
> +#include <asm/arcregs.h>
> +
> +void arch_local_irq_enable(void)
> +{
> +
> +	unsigned long flags;
> +	flags = arch_local_save_flags();
> +	flags |= (STATUS_E1_MASK | STATUS_E2_MASK);
> +
> +	/*
> +	 * If called from hard ISR (between irq_enter and irq_exit)
> +	 * don't allow Level 1. In Soft ISR we allow further Level 1s
> +	 */
> +
> +	if (in_irq())
> +		flags &= ~(STATUS_E1_MASK | STATUS_E2_MASK);

Hmm. This looks weird and the comment is not very helpful. So using my
crystal ball you want to enforce, that nothing enables interrupts
while a hard interrupt handler is running, right?

Is there a chip limitation which you have to enforce here? If yes,
then please explain it.

Btw, all hard interrupt handlers in Linux run with interrupts disabled and
they are not supposed to reenable interrupts, which is true for almost
all drivers except for a few archaic IDE drivers. In fact you might
even WARN about it at least once, so the offending code gets fixed.

Also the code flow is backwards. What about:

     unsigned long flags;

     if (in_irq())
	    return;

     flags = ....	    


> +	arch_local_irq_restore(flags);
> +}

Thanks,

	tglx
