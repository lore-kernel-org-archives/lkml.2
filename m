Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab0JAFtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 01:49:42 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:42258 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab0JAFtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 01:49:40 -0400
Message-ID: <4CA5760E.1030303@kernel.org>
Date: Thu, 30 Sep 2010 22:47:58 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 40/47] genirq: Sanitize dynamic irq handling
References: <20100930221351.682772535@linutronix.de> <20100930221742.416816916@linutronix.de>
In-Reply-To: <20100930221742.416816916@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2010 04:17 PM, Thomas Gleixner wrote:
> Use the cleanup functions of the dynamic allocator. No need to have
> separate implementations.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  include/linux/irq.h    |   12 +++--
>  kernel/irq/chip.c      |  104 -------------------------------------------------
>  kernel/irq/internals.h |    1 
>  kernel/irq/irqdesc.c   |   37 +++++++++++------
>  4 files changed, 33 insertions(+), 121 deletions(-)
> 
> Index: linux-2.6-tip/include/linux/irq.h
> ===================================================================
> --- linux-2.6-tip.orig/include/linux/irq.h
> +++ linux-2.6-tip/include/linux/irq.h
> @@ -497,11 +497,15 @@ static inline int irq_has_action(unsigne
>  	return desc->action != NULL;
>  }
>  
> -/* Dynamic irq helper functions */
> -extern void dynamic_irq_init(unsigned int irq);
> -void dynamic_irq_init_keep_chip_data(unsigned int irq);
> +/*
> + * Dynamic irq helper functions. Obsolete. Use irq_alloc_desc* and
> + * irq_free_desc instead.
> + */
>  extern void dynamic_irq_cleanup(unsigned int irq);
> -void dynamic_irq_cleanup_keep_chip_data(unsigned int irq);
> +static inline void dynamic_irq_init(unsigned int irq)
> +{
> +	dynamic_irq_cleanup(irq);
> +}
>  
>  /* Set/get chip/data for an IRQ: */
>  extern int set_irq_chip(unsigned int irq, struct irq_chip *chip);
> Index: linux-2.6-tip/kernel/irq/chip.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/irq/chip.c
> +++ linux-2.6-tip/kernel/irq/chip.c
> @@ -18,110 +18,6 @@
>  
>  #include "internals.h"
>  
> -static void dynamic_irq_init_x(unsigned int irq, bool keep_chip_data)
> -{
> -	struct irq_desc *desc;
> -	unsigned long flags;
> -
> -	desc = irq_to_desc(irq);
> -	if (!desc) {
> -		WARN(1, KERN_ERR "Trying to initialize invalid IRQ%d\n", irq);
> -		return;
> -	}
> -
> -	/* Ensure we don't have left over values from a previous use of this irq */
> -	raw_spin_lock_irqsave(&desc->lock, flags);
> -	desc->status = IRQ_DEFAULT_INIT_FLAGS;
> -	desc->chip = &no_irq_chip;
> -	desc->irq_data.chip = &no_irq_chip;
> -	desc->handle_irq = handle_bad_irq;
> -	desc->depth = 1;
> -	desc->irq_data.msi_desc = NULL;
> -	desc->irq_data.handler_data = NULL;
> -	if (!keep_chip_data)
> -		desc->irq_data.chip_data = NULL;
> -	desc->action = NULL;
> -	desc->irq_count = 0;
> -	desc->irqs_unhandled = 0;
> -#ifdef CONFIG_SMP
> -	cpumask_setall(desc->affinity);
> -#ifdef CONFIG_GENERIC_PENDING_IRQ
> -	cpumask_clear(desc->pending_mask);
> -#endif
> -#endif
> -	raw_spin_unlock_irqrestore(&desc->lock, flags);
> -}
> -
> -/**
> - *	dynamic_irq_init - initialize a dynamically allocated irq
> - *	@irq:	irq number to initialize
> - */
> -void dynamic_irq_init(unsigned int irq)
> -{
> -	dynamic_irq_init_x(irq, false);
> -}
> -
> -/**
> - *	dynamic_irq_init_keep_chip_data - initialize a dynamically allocated irq
> - *	@irq:	irq number to initialize
> - *
> - *	does not set irq_to_desc(irq)->chip_data to NULL
> - */
> -void dynamic_irq_init_keep_chip_data(unsigned int irq)
> -{
> -	dynamic_irq_init_x(irq, true);
> -}
> -
> -static void dynamic_irq_cleanup_x(unsigned int irq, bool keep_chip_data)
> -{
> -	struct irq_desc *desc = irq_to_desc(irq);
> -	unsigned long flags;
> -
> -	if (!desc) {
> -		WARN(1, KERN_ERR "Trying to cleanup invalid IRQ%d\n", irq);
> -		return;
> -	}
> -
> -	raw_spin_lock_irqsave(&desc->lock, flags);
> -	if (desc->action) {
> -		raw_spin_unlock_irqrestore(&desc->lock, flags);
> -		WARN(1, KERN_ERR "Destroying IRQ%d without calling free_irq\n",
> -			irq);
> -		return;
> -	}
> -	desc->irq_data.msi_desc = NULL;
> -	desc->irq_data.handler_data = NULL;
> -	if (!keep_chip_data)
> -		desc->irq_data.chip_data = NULL;
> -	desc->handle_irq = handle_bad_irq;
> -	desc->chip = &no_irq_chip;
> -	desc->irq_data.chip = &no_irq_chip;
> -	desc->name = NULL;
> -	clear_kstat_irqs(desc);
> -	raw_spin_unlock_irqrestore(&desc->lock, flags);
> -}
> -
> -/**
> - *	dynamic_irq_cleanup - cleanup a dynamically allocated irq
> - *	@irq:	irq number to initialize
> - */
> -void dynamic_irq_cleanup(unsigned int irq)
> -{
> -	dynamic_irq_cleanup_x(irq, false);
> -}
> -
> -/**
> - *	dynamic_irq_cleanup_keep_chip_data - cleanup a dynamically allocated irq
> - *	@irq:	irq number to initialize
> - *
> - *	does not set irq_to_desc(irq)->chip_data to NULL
> - */
> -void dynamic_irq_cleanup_keep_chip_data(unsigned int irq)
> -{
> -	dynamic_irq_cleanup_x(irq, true);
> -}
> -
> -
>  /**
>   *	set_irq_chip - set the irq chip for an irq
>   *	@irq:	irq number
> Index: linux-2.6-tip/kernel/irq/internals.h
> ===================================================================
> --- linux-2.6-tip.orig/kernel/irq/internals.h
> +++ linux-2.6-tip/kernel/irq/internals.h
> @@ -17,7 +17,6 @@ extern void __enable_irq(struct irq_desc
>  
>  extern struct lock_class_key irq_desc_lock_class;
>  extern void init_kstat_irqs(struct irq_desc *desc, int node, int nr);
> -extern void clear_kstat_irqs(struct irq_desc *desc);
>  extern raw_spinlock_t sparse_irq_lock;
>  
>  #ifdef CONFIG_SPARSE_IRQ
> Index: linux-2.6-tip/kernel/irq/irqdesc.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/irq/irqdesc.c
> +++ linux-2.6-tip/kernel/irq/irqdesc.c
> @@ -54,10 +54,13 @@ static void desc_smp_init(struct irq_des
>  	desc->node = node;
>  	desc->irq_data.affinity = &desc->affinity;
>  	cpumask_copy(desc->affinity, irq_default_affinity);
> +#ifdef CONFIG_GENERIC_PENDING_IRQ
> +	cpumask_clear(desc->pending_mask);
> +#endif
>  }
> -
> +static inline int desc_node(struct irq_desc *desc) { return desc->node; }
>  #else
> -static inline int
> +static inline int desc_node(struct irq_desc *desc) { return 0; }
>  alloc_masks(struct irq_desc *desc, gfp_t gfp, int node) { return 0; }
>  static inline void desc_smp_init(struct irq_desc *desc, int node) { }
>  #endif
> @@ -72,6 +75,8 @@ static void desc_set_defaults(unsigned i
>  	desc->irq_data.chip = &no_irq_chip;
>  	desc->handle_irq = handle_bad_irq;
>  	desc->depth = 1;
> +	desc->irq_count = 0;
> +	desc->irqs_unhandled = 0;
>  	desc->name = NULL;
>  	memset(desc->kstat_irqs, 0, nr_cpu_ids * sizeof(*(desc->kstat_irqs)));
>  	desc_smp_init(desc, node);
> @@ -136,6 +141,7 @@ static void free_masks(struct irq_desc *
>  #endif
>  	free_cpumask_var(desc->affinity);
>  }
> +static int node

?

>  #else
>  static inline void free_masks(struct irq_desc *desc) { }
>  #endif
> @@ -290,16 +296,7 @@ struct irq_desc *irq_to_desc_alloc_node(
>  
>  static void free_desc(unsigned int irq)
>  {
> -	struct irq_desc *desc = irq_to_desc(irq);
> -	unsigned long flags;
> -
> -	raw_spin_lock_irqsave(&desc->lock, flags);
> -#ifdef CONFIG_SMP
> -	desc_set_defaults(irq, desc, desc->node);
> -#else
> -	desc_set_defaults(irq, desc, 0);
> -#endif
> -	raw_spin_unlock_irqrestore(&desc->lock, flags);
> +	dynamic_irq_cleanup(irq);
>  }
>  
>  static inline int alloc_descs(unsigned int start, unsigned int cnt, int node)
> @@ -386,6 +383,22 @@ unsigned int irq_get_next_irq(unsigned i
>  	return res;
>  }
>  
> +/**
> + * dynamic_irq_cleanup - cleanup a dynamically allocated irq
> + * @irq:	irq number to initialize
> + */
> +void dynamic_irq_cleanup(unsigned int irq)
> +{
> +	struct irq_desc *desc = irq_to_desc(irq);
> +	unsigned long flags;
> +
> +	raw_spin_lock_irqsave(&desc->lock, flags);
> +	desc_set_defaults(irq, desc, desc_node(desc));
> +	raw_spin_unlock_irqrestore(&desc->lock, flags);
> +}
> +
> + unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
> +
>  /* Statistics access */
>  void clear_kstat_irqs(struct irq_desc *desc)
>  {
> 

