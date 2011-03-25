Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab1CYWaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 18:30:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:36798 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285Ab1CYWaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 18:30:09 -0400
Date: Fri, 25 Mar 2011 23:30:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Daney <ddaney@caviumnetworks.com>
cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] genirq: Reserve the irq when calling
 irq_set_chip()
In-Reply-To: <1301081931-11240-2-git-send-email-ddaney@caviumnetworks.com>
Message-ID: <alpine.LFD.2.00.1103252328510.31464@localhost6.localdomain6>
References: <1301081931-11240-1-git-send-email-ddaney@caviumnetworks.com> <1301081931-11240-2-git-send-email-ddaney@caviumnetworks.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Mar 2011, David Daney wrote:

> The helper macros and functions like for_each_active_irq() don't work
> unless the irq is in the allocated_irqs set.
> 
> In the case of !CONFIG_SPARSE_IRQ, instead of forcing all users of the
> irq infrastructure to explicitly call irq_reserve_irq(), do it for
> them.
> 
> Signed-off-by: David Daney <ddaney@caviumnetworks.com>
> ---
>  kernel/irq/chip.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index c9c0601..54d9aab 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -37,6 +37,12 @@ int irq_set_chip(unsigned int irq, struct irq_chip *chip)
>  	irq_chip_set_defaults(chip);
>  	desc->irq_data.chip = chip;
>  	irq_put_desc_unlock(desc, flags);
> +	/*
> +	 * For !CONFIG_SPARSE_IRQ make the irq show up in
> +	 * allocated_irqs.  For the CONFIG_SPARSE_IRQ case, it may
> +	 * already be there, and this call is harmless.

For SPARSE=y it _IS_ already there, otherwise we would not reach that
code.

> +	 */
> +	irq_reserve_irq(irq);
>  	return 0;
>  }
>  EXPORT_SYMBOL(irq_set_chip);
> -- 
> 1.7.2.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
