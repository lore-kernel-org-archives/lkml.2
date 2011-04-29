Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934002Ab1D2W0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:26:08 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:55730 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933993Ab1D2W0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:26:04 -0400
Date: Fri, 29 Apr 2011 16:26:00 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, sodaville@linutronix.de,
        Torben Hohn <torbenh@linutronix.de>,
        Florian Fainelli <florian@openwrt.org>
Subject: Re: [PATCH 1/2] x86/dtb: make irq host list accessible
Message-ID: <20110429222600.GJ7497@ponder.secretlab.ca>
References: <20110427143423.GB15211@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110427143423.GB15211@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 04:34:23PM +0200, Sebastian Andrzej Siewior wrote:
> From: Torben Hohn <torbenh@linutronix.de>
> 
> There is an gpio irq chip comming which needs this from the outside.
> There is no EXPORT_SYMBOL because this does not yet work in modules.
> 
> Signed-off-by: Torben Hohn <torbenh@linutronix.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  arch/x86/include/asm/irq_controller.h |    2 ++
>  arch/x86/kernel/devicetree.c          |   15 +++++++++++----
>  2 files changed, 13 insertions(+), 4 deletions(-)

Can you rework this to sit on top of the of_irq_domain series I sent
out yesterday?  I *really* hope to get of_irq_domain merged into .40,
but this change would conflict.

Thanks,
g.

> 
> diff --git a/arch/x86/include/asm/irq_controller.h b/arch/x86/include/asm/irq_controller.h
> index 423bbbd..04fecc0 100644
> --- a/arch/x86/include/asm/irq_controller.h
> +++ b/arch/x86/include/asm/irq_controller.h
> @@ -9,4 +9,6 @@ struct irq_domain {
>  	struct list_head l;
>  };
>  
> +extern void irq_add_of_interrupt_host(struct irq_domain *ih);
> +extern void irq_remove_of_interrupt_host(struct irq_domain *ih);
>  #endif
> diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
> index e90f084..58c4208 100644
> --- a/arch/x86/kernel/devicetree.c
> +++ b/arch/x86/kernel/devicetree.c
> @@ -26,8 +26,7 @@ static DEFINE_RAW_SPINLOCK(big_irq_lock);
>  
>  int __initdata of_ioapic;
>  
> -#ifdef CONFIG_X86_IO_APIC
> -static void add_interrupt_host(struct irq_domain *ih)
> +void irq_add_of_interrupt_host(struct irq_domain *ih)
>  {
>  	unsigned long flags;
>  
> @@ -35,7 +34,15 @@ static void add_interrupt_host(struct irq_domain *ih)
>  	list_add(&ih->l, &irq_domains);
>  	raw_spin_unlock_irqrestore(&big_irq_lock, flags);
>  }
> -#endif
> +
> +void irq_remove_of_interrupt_host(struct irq_domain *ih)
> +{
> +	unsigned long flags;
> +
> +	raw_spin_lock_irqsave(&big_irq_lock, flags);
> +	list_del(&ih->l);
> +	raw_spin_unlock_irqrestore(&big_irq_lock, flags);
> +}
>  
>  static struct irq_domain *get_ih_from_node(struct device_node *controller)
>  {
> @@ -415,7 +422,7 @@ static void __init ioapic_add_ofnode(struct device_node *np)
>  			id->controller = np;
>  			id->xlate = ioapic_xlate;
>  			id->priv = (void *)i;
> -			add_interrupt_host(id);
> +			irq_add_of_interrupt_host(id);
>  			return;
>  		}
>  	}
> -- 
> 1.7.4.4
> 
