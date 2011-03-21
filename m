Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab1CUS04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 14:26:56 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:13626 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab1CUS0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 14:26:55 -0400
Message-ID: <4D879869.8060405@caviumnetworks.com>
Date: Mon, 21 Mar 2011 11:26:49 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] genirq: Add chip hooks for taking CPUs on/off
 line.
References: <1300484916-11133-1-git-send-email-ddaney@caviumnetworks.com> <1300484916-11133-2-git-send-email-ddaney@caviumnetworks.com> <alpine.LFD.2.00.1103192050400.2787@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1103192050400.2787@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Mar 2011 18:26:54.0308 (UTC) FILETIME=[8DDA2A40:01CBE7F5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2011 01:51 PM, Thomas Gleixner wrote:
> On Fri, 18 Mar 2011, David Daney wrote:
>> --- a/include/linux/irqdesc.h
>> +++ b/include/linux/irqdesc.h
>> @@ -178,6 +178,12 @@ static inline int irq_has_action(unsigned int irq)
>>   	return desc->action != NULL;
>>   }
>>
>> +/* Test to see if the irq is currently enabled */
>> +static inline int irq_desc_is_enabled(struct irq_desc *desc)
>> +{
>> +	return desc->depth == 0;
>> +}
>
> That want's to go into kernel/irq/internal.h

I think I need to use this in my irq_chip.irq_unmask method.

Consider this:


CPU0                   CPU1
handle_level_irq
   lock
   mask
   handle_irq_event
     unlock
     .
     .                  disable_irq
     .
     lock
   unmask
   unlock


I need to know in my .unmask method if the interrupt has been disabled. 
  If it has, I will not re-enable (unmask)it.

>
>>   #ifndef CONFIG_GENERIC_HARDIRQS_NO_COMPAT
>>   static inline int irq_balancing_disabled(unsigned int irq)
>>   {
>> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
>> index c9c0601..40736f7 100644
>> --- a/kernel/irq/chip.c
>> +++ b/kernel/irq/chip.c
>> @@ -689,3 +689,38 @@ void irq_modify_status(unsigned int irq, unsigned long clr, unsigned long set)
>>
>>   	irq_put_desc_unlock(desc, flags);
>>   }
>> +
>> +void irq_cpu_online(unsigned int irq)
>
> Odd function name. It does not reflect that this is for per cpu
> interrupts. So something like irq_xxx_per_cpu_irq(irq)
> might be a bit more descriptive.

I am using it for per cpu interrupts, but I didn't want to impose that 
policy on others.



>
>> +{
>
> So that's called on the cpu which goes online, right?
>

Yes.

> I wonder whether we can add any sanity check to verify this.
>
> Though I would not worry too much about it. Calling that from a cpu
> which is not going offline should have enough nasty side effects that
> it's noticed during development. :)
>
>> +	unsigned long flags;
>> +	struct irq_chip *chip;
>> +	struct irq_desc *desc = irq_to_desc(irq);
>
> Needs to check !desc

OK.

>
>> +	raw_spin_lock_irqsave(&desc->lock, flags);
>> +
>> +	chip = irq_data_get_irq_chip(&desc->irq_data);
>> +
>> +	if (chip&&  chip->irq_cpu_online)
>> +		chip->irq_cpu_online(&desc->irq_data,
>> +				     irq_desc_is_enabled(desc));
>> +
>> +	raw_spin_unlock_irqrestore(&desc->lock, flags);
>> +}
>> +
>> +void irq_cpu_offline(unsigned int irq)
>> +{
>> +	unsigned long flags;
>> +	struct irq_chip *chip;
>> +	struct irq_desc *desc = irq_to_desc(irq);
>
> See above.
>
> Style nit: I prefer ordering:
>
> +	struct irq_desc *desc = irq_to_desc(irq);
> +	struct irq_chip *chip;
> +	unsigned long flags;
>
> For some reason, probably because I'm used to it, that's easier to
> parse. But don't worry about that, I'll turn it around before sticking
> it into git. :)
>
> Otherwise I'm fine with the approach itself.
>
> Though one question remains: should we just iterate over the irq space
> and call the online/offline callbacks when available instead of having
> the arch code do the iteration.
>

That would be good I think, especially for sparse irqs.

In the case of the CPU going offline, the .irq_cpu_offline() may need to 
adjust the affinity so that the irq no longer has affinity for the 
off-lined CPU.

This is something needed even for non-per-cpu interrupts.  Also I would 
need a way to call irq_set_affinity() while holding the desc->lock.

David Daney

