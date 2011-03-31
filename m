Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486Ab1CaPsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:48:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:36117 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab1CaPsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:48:50 -0400
Date: Thu, 31 Mar 2011 17:48:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
cc: linux-iio@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 13/21] arm: irq: export set flags
In-Reply-To: <1301583255-28468-14-git-send-email-jic23@cam.ac.uk>
Message-ID: <alpine.LFD.2.00.1103311735580.22418@localhost6.localdomain6>
References: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk> <1301583255-28468-14-git-send-email-jic23@cam.ac.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011, Jonathan Cameron wrote:

> ---
>  arch/arm/kernel/irq.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
> index 3535d37..e4fd9e4 100644
> --- a/arch/arm/kernel/irq.c
> +++ b/arch/arm/kernel/irq.c
> @@ -163,6 +163,7 @@ void set_irq_flags(unsigned int irq, unsigned int iflags)
>  		desc->status &= ~IRQ_NOAUTOEN;
>  	raw_spin_unlock_irqrestore(&desc->lock, flags);
>  }
> +EXPORT_SYMBOL(set_irq_flags);

For one it would be EXPORT_SYMBOL_GPL, but that code has changed, so
the patch wont apply. Please make sure your patches apply to latest
linus git next time.

So the code looks like this now.

void set_irq_flags(unsigned int irq, unsigned int iflags)
{
	unsigned long clr = 0, set = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;

	if (irq >= nr_irqs) {
		printk(KERN_ERR "Trying to set irq flags for IRQ%d\n", irq);
		return;
	}

	if (iflags & IRQF_VALID)
		clr |= IRQ_NOREQUEST;
	if (iflags & IRQF_PROBE)
		clr |= IRQ_NOPROBE;
	if (!(iflags & IRQF_NOAUTOEN))
		clr |= IRQ_NOAUTOEN;
	/* Order is clear bits in "clr" then set bits in "set" */
	irq_modify_status(irq, clr, set & ~clr);
}

There are tons of drivers which use it under an ARM ifdef. That's
really silly. The flags are in 100% of the cases constants, so if we
remove the irq_nr check, then the compiler can optimize that code down
to
	irq_modify_status(irq, X, Y);

So we have two options here to solve that.

Use coccinelle and sweep the whole tree and convert it to

    irq_modify_status(irq, X, Y);

calls or move that set_irq_flags() stuff as an inline helper (minus
the printk) - the core code does the irq validity check already - into
linux/interrupt.h and clean up all the ifdef ARM stuff in drivers/* 

I'd vote for the first one, but I have no real objection against the
second solution.

Russell ??

Thanks,

	tglx

