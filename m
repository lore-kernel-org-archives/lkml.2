Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935264Ab1IOWtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 18:49:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:47407 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935230Ab1IOWtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 18:49:14 -0400
Date: Fri, 16 Sep 2011 00:49:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Marc Zyngier <marc.zyngier@arm.com>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/3] genirq: add support for per-cpu dev_id
 interrupts
In-Reply-To: <1316105551-17505-2-git-send-email-marc.zyngier@arm.com>
Message-ID: <alpine.LFD.2.02.1109152207010.2723@ionos>
References: <1316105551-17505-1-git-send-email-marc.zyngier@arm.com> <1316105551-17505-2-git-send-email-marc.zyngier@arm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc,

On Thu, 15 Sep 2011, Marc Zyngier wrote:
> 
> Based on an initial patch by Thomas Gleixner.

Was more an idea than a patch :)

> +	void			*dev_id;
> +#ifdef CONFIG_IRQ_PERCPU_DEVID
> +	void __percpu		*percpu_dev_id;
> +#endif

Can we please avoid that ifdef and use an anon union ?

> +#ifdef CONFIG_IRQ_PERCPU_DEVID
> +static inline int irq_set_percpu_devid(unsigned int irq)

Real function in kernel/irq/ please

> +{
> +	struct irq_desc *desc = irq_to_desc(irq);
> +
> +	if (!desc)
> +		return -EINVAL;
> +
> +	if (!zalloc_cpumask_var(&desc->percpu_enabled, GFP_KERNEL))
> +		return -ENOMEM;

What prevents that allocation happening more than once ?

> +	irq_set_status_flags(irq,
> +			     IRQ_NOAUTOEN | IRQ_PER_CPU | IRQ_NOTHREAD |
> +			     IRQ_NOPROBE | IRQ_PER_CPU_DEVID);
> +	return 0;
> +}
> +#endif
> +
>  /* Handle dynamic irq creation and destruction */
>  extern unsigned int create_irq_nr(unsigned int irq_want, int node);
>  extern int create_irq(void);
> diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
> index 150134a..0b4419a 100644
> --- a/include/linux/irqdesc.h
> +++ b/include/linux/irqdesc.h
> @@ -53,6 +53,9 @@ struct irq_desc {
>  	unsigned long		last_unhandled;	/* Aging timer for unhandled count */
>  	unsigned int		irqs_unhandled;
>  	raw_spinlock_t		lock;
> +#ifdef CONFIG_IRQ_PERCPU_DEVID

Can we just make that a pointer and get rid of the config option ?

> +#ifdef CONFIG_IRQ_PERCPU_DEVID
> +void irq_percpu_enable(struct irq_desc *desc)
> +{
> +	unsigned int cpu = get_cpu();

get_cpu() is overkill here. That's called with desc->lock held and
interrupts disabled. No way that the cpu can go away :)

I'd rather have a check in the calling function, which makes sure that
enable_percpu_irq() is called from proper per cpu context. See comment
below.

>  void remove_irq(unsigned int irq, struct irqaction *act)
>  {
> -	__free_irq(irq, act->dev_id);
> +	struct irq_desc *desc = irq_to_desc(irq);
> +
> +	if (desc && !irq_settings_is_per_cpu_devid(desc))

That probably should be

     if (!WARN_ON(....))

> +	    __free_irq(irq, act->dev_id);
>  }
>  EXPORT_SYMBOL_GPL(remove_irq);
>  
> @@ -1246,7 +1251,7 @@ void free_irq(unsigned int irq, void *dev_id)
>  {
>  	struct irq_desc *desc = irq_to_desc(irq);
>  
> -	if (!desc)
> +	if (!desc || irq_settings_is_per_cpu_devid(desc))
>  		return;

Please make these percpu_devid checks WARN_ON so we can avoid stupid
questions on the mailing lists.

>  #ifdef CONFIG_SMP
> @@ -1324,7 +1329,8 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
>  	if (!desc)
>  		return -EINVAL;
>  
> -	if (!irq_settings_can_request(desc))
> +	if (!irq_settings_can_request(desc) ||
> +	    irq_settings_is_per_cpu_devid(desc))
>  		return -EINVAL;

That's fine.
  
>  	if (!handler) {
> @@ -1409,3 +1415,198 @@ int request_any_context_irq(unsigned int irq, irq_handler_t handler,
>  	return !ret ? IRQC_IS_HARDIRQ : ret;
>  }
>  EXPORT_SYMBOL_GPL(request_any_context_irq);
> +
> +#ifdef CONFIG_IRQ_PERCPU_DEVID
> +void enable_percpu_irq(unsigned int irq)
> +{
> +	unsigned long flags;
> +	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags);
> +
> +	if (!desc)
> +		return;
> +
> +	irq_percpu_enable(desc);
> +	irq_put_desc_busunlock(desc, flags);

To make this luser proof and better debuggable I'd like to have that as:

	int cpu = smp_processsor_id();
	unsigned long flags;
	....
	irq_percpu_enable(desc, cpu);

That way we catch at least lusers who call that from random thread
context - assuming that they enabled some debug options .....

> +}
> +EXPORT_SYMBOL(enable_percpu_irq);

_GPL please if at all. Not sure whether this needs to be available for
modules.

> +/*
> + * Internal function to unregister a percpu irqaction.
> + */
> +static struct irqaction *__free_percpu_irq(unsigned int irq, void __percpu *dev_id)
> +{
> +	struct irq_desc *desc = irq_to_desc(irq);
> +	struct irqaction *action;
> +	unsigned long flags;
> +
> +	WARN(in_interrupt(), "Trying to free IRQ %d from IRQ context!\n", irq);
> +
> +	if (!desc)
> +		return NULL;
> +
> +	raw_spin_lock_irqsave(&desc->lock, flags);
> +
> +	action = desc->action;
> +	if (!action || action->percpu_dev_id != dev_id) {
> +		WARN(1, "Trying to free already-free IRQ %d\n", irq);
> +		raw_spin_unlock_irqrestore(&desc->lock, flags);
> +		return NULL;
> +	}
> +
> +	/* Found it - now remove it from the list of entries: */
> +	WARN(!cpumask_empty(desc->percpu_enabled),
> +	     "percpu IRQ %d still enabled on CPU%d!\n",
> +	     irq, cpumask_first(desc->percpu_enabled));
> +	desc->action = NULL;
> +
> +#ifdef CONFIG_SMP
> +	/* make sure affinity_hint is cleaned up */
> +	if (WARN_ON_ONCE(desc->affinity_hint))
> +		desc->affinity_hint = NULL;
> +#endif

We don't want to have an affinity hint for percpu interrupts. That's
pretty useless AFACIT :)

> +
> +	raw_spin_unlock_irqrestore(&desc->lock, flags);
> +
> +	unregister_handler_proc(irq, action);
> +
> +	/* Make sure it's not being used on another CPU: */
> +	synchronize_irq(irq);

That's not helping w/o making synchronize_irq() aware of the percpu
stuff. Also there is the question whether we need the ability to
remove such interrupts in the first place. The target users are low
level arch interrupts not some random device drivers.

Otherwise this is a pretty cool patch!

Thanks,

	tglx
