Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab1IPJg7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 05:36:59 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42934 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751630Ab1IPJg5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 05:36:57 -0400
Message-ID: <4E7318CB.8010105@arm.com>
Date: Fri, 16 Sep 2011 10:37:15 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/3] genirq: add support for per-cpu dev_id interrupts
References: <1316105551-17505-1-git-send-email-marc.zyngier@arm.com> <1316105551-17505-2-git-send-email-marc.zyngier@arm.com> <alpine.LFD.2.02.1109152207010.2723@ionos>
In-Reply-To: <alpine.LFD.2.02.1109152207010.2723@ionos>
X-Enigmail-Version: 1.2.1
X-OriginalArrivalTime: 16 Sep 2011 09:36:51.0864 (UTC) FILETIME=[2A0F9180:01CC7454]
X-MC-Unique: 111091610365501101
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/09/11 23:49, Thomas Gleixner wrote:
> Marc,
> 
> On Thu, 15 Sep 2011, Marc Zyngier wrote:
>>
>> Based on an initial patch by Thomas Gleixner.
> 
> Was more an idea than a patch :)

Almost the same thing :)

> 
>> +	void			*dev_id;
>> +#ifdef CONFIG_IRQ_PERCPU_DEVID
>> +	void __percpu		*percpu_dev_id;
>> +#endif
> 
> Can we please avoid that ifdef and use an anon union ?

See my reply to Michał on the same subject. Doing so breaks existing
code because of what looks like a GCC problem.

> 
>> +#ifdef CONFIG_IRQ_PERCPU_DEVID
>> +static inline int irq_set_percpu_devid(unsigned int irq)
> 
> Real function in kernel/irq/ please

I will then have to split it somehow, as anything that includes irq.h
and refers to a IRQ_* flag falls into the "GOT_YOU_MORON" trap...

>> +{
>> +	struct irq_desc *desc = irq_to_desc(irq);
>> +
>> +	if (!desc)
>> +		return -EINVAL;
>> +
>> +	if (!zalloc_cpumask_var(&desc->percpu_enabled, GFP_KERNEL))
>> +		return -ENOMEM;
> 
> What prevents that allocation happening more than once ?

Will fix.

>> +	irq_set_status_flags(irq,
>> +			     IRQ_NOAUTOEN | IRQ_PER_CPU | IRQ_NOTHREAD |
>> +			     IRQ_NOPROBE | IRQ_PER_CPU_DEVID);
>> +	return 0;
>> +}
>> +#endif
>> +
>>  /* Handle dynamic irq creation and destruction */
>>  extern unsigned int create_irq_nr(unsigned int irq_want, int node);
>>  extern int create_irq(void);
>> diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
>> index 150134a..0b4419a 100644
>> --- a/include/linux/irqdesc.h
>> +++ b/include/linux/irqdesc.h
>> @@ -53,6 +53,9 @@ struct irq_desc {
>>  	unsigned long		last_unhandled;	/* Aging timer for unhandled count */
>>  	unsigned int		irqs_unhandled;
>>  	raw_spinlock_t		lock;
>> +#ifdef CONFIG_IRQ_PERCPU_DEVID
> 
> Can we just make that a pointer and get rid of the config option ?

Yes. Will add the necessary allocation to irq_set_percpu_devid();

> 
>> +#ifdef CONFIG_IRQ_PERCPU_DEVID
>> +void irq_percpu_enable(struct irq_desc *desc)
>> +{
>> +	unsigned int cpu = get_cpu();
> 
> get_cpu() is overkill here. That's called with desc->lock held and
> interrupts disabled. No way that the cpu can go away :)

Ah, that's only me getting paranoid... ;-)

> I'd rather have a check in the calling function, which makes sure that
> enable_percpu_irq() is called from proper per cpu context. See comment
> below.
> 
>>  void remove_irq(unsigned int irq, struct irqaction *act)
>>  {
>> -	__free_irq(irq, act->dev_id);
>> +	struct irq_desc *desc = irq_to_desc(irq);
>> +
>> +	if (desc && !irq_settings_is_per_cpu_devid(desc))
> 
> That probably should be
> 
>      if (!WARN_ON(....))

Right.

>> +	    __free_irq(irq, act->dev_id);
>>  }
>>  EXPORT_SYMBOL_GPL(remove_irq);
>>  
>> @@ -1246,7 +1251,7 @@ void free_irq(unsigned int irq, void *dev_id)
>>  {
>>  	struct irq_desc *desc = irq_to_desc(irq);
>>  
>> -	if (!desc)
>> +	if (!desc || irq_settings_is_per_cpu_devid(desc))
>>  		return;
> 
> Please make these percpu_devid checks WARN_ON so we can avoid stupid
> questions on the mailing lists.

OK.

>>  #ifdef CONFIG_SMP
>> @@ -1324,7 +1329,8 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
>>  	if (!desc)
>>  		return -EINVAL;
>>  
>> -	if (!irq_settings_can_request(desc))
>> +	if (!irq_settings_can_request(desc) ||
>> +	    irq_settings_is_per_cpu_devid(desc))
>>  		return -EINVAL;
> 
> That's fine.
>   
>>  	if (!handler) {
>> @@ -1409,3 +1415,198 @@ int request_any_context_irq(unsigned int irq, irq_handler_t handler,
>>  	return !ret ? IRQC_IS_HARDIRQ : ret;
>>  }
>>  EXPORT_SYMBOL_GPL(request_any_context_irq);
>> +
>> +#ifdef CONFIG_IRQ_PERCPU_DEVID
>> +void enable_percpu_irq(unsigned int irq)
>> +{
>> +	unsigned long flags;
>> +	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags);
>> +
>> +	if (!desc)
>> +		return;
>> +
>> +	irq_percpu_enable(desc);
>> +	irq_put_desc_busunlock(desc, flags);
> 
> To make this luser proof and better debuggable I'd like to have that as:
> 
> 	int cpu = smp_processsor_id();
> 	unsigned long flags;
> 	....
> 	irq_percpu_enable(desc, cpu);
> 
> That way we catch at least lusers who call that from random thread
> context - assuming that they enabled some debug options .....

Ah, nice trick.

>> +}
>> +EXPORT_SYMBOL(enable_percpu_irq);
> 
> _GPL please if at all. Not sure whether this needs to be available for
> modules.

Well, At the moment, the only potential users of that code are timers,
which cannot be modules. I'd be happy to drop this altogether.

>> +/*
>> + * Internal function to unregister a percpu irqaction.
>> + */
>> +static struct irqaction *__free_percpu_irq(unsigned int irq, void __percpu *dev_id)
>> +{
>> +	struct irq_desc *desc = irq_to_desc(irq);
>> +	struct irqaction *action;
>> +	unsigned long flags;
>> +
>> +	WARN(in_interrupt(), "Trying to free IRQ %d from IRQ context!\n", irq);
>> +
>> +	if (!desc)
>> +		return NULL;
>> +
>> +	raw_spin_lock_irqsave(&desc->lock, flags);
>> +
>> +	action = desc->action;
>> +	if (!action || action->percpu_dev_id != dev_id) {
>> +		WARN(1, "Trying to free already-free IRQ %d\n", irq);
>> +		raw_spin_unlock_irqrestore(&desc->lock, flags);
>> +		return NULL;
>> +	}
>> +
>> +	/* Found it - now remove it from the list of entries: */
>> +	WARN(!cpumask_empty(desc->percpu_enabled),
>> +	     "percpu IRQ %d still enabled on CPU%d!\n",
>> +	     irq, cpumask_first(desc->percpu_enabled));
>> +	desc->action = NULL;
>> +
>> +#ifdef CONFIG_SMP
>> +	/* make sure affinity_hint is cleaned up */
>> +	if (WARN_ON_ONCE(desc->affinity_hint))
>> +		desc->affinity_hint = NULL;
>> +#endif
> 
> We don't want to have an affinity hint for percpu interrupts. That's
> pretty useless AFACIT :)

Copy paste issue. Will fix :)

>> +
>> +	raw_spin_unlock_irqrestore(&desc->lock, flags);
>> +
>> +	unregister_handler_proc(irq, action);
>> +
>> +	/* Make sure it's not being used on another CPU: */
>> +	synchronize_irq(irq);
> 
> That's not helping w/o making synchronize_irq() aware of the percpu
> stuff. Also there is the question whether we need the ability to
> remove such interrupts in the first place. The target users are low
> level arch interrupts not some random device drivers.

Again, there is no need for this at the moment (the timer code runs
running forever), and this is only there for completeness.

I'll see if I can come up with a synchronize_percpu_irq() without adding
too much bloat to irqdesc.

Thanks for reviewing!

	M.
-- 
Jazz is not dead. It just smells funny...

