Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab1CWWDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 18:03:39 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51318 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081Ab1CWWDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 18:03:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=EDWgmOs77A84vwyUmMAyEDcFNUBfcUEnfKhLidobxa04ceD84Ul4a4Uimp+IRxZ8JO
         HfKS8r9Mv+jlOoEYbaQzEUw5NGObvVlRe5CNpK2seLn38sJ3s+1qdOnO5cTjNXez66kq
         PSZPKtq829lYKt8u80jAGWrewgZDxLSE5wrPM=
Message-ID: <4D8A6E38.7020203@gmail.com>
Date: Wed, 23 Mar 2011 15:03:36 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] genirq: Add chip hooks for taking CPUs on/off
 line.
References: <1300484916-11133-1-git-send-email-ddaney@caviumnetworks.com> <1300484916-11133-2-git-send-email-ddaney@caviumnetworks.com> <alpine.LFD.2.00.1103192050400.2787@localhost6.localdomain6> <4D879869.8060405@caviumnetworks.com> <alpine.LFD.2.00.1103212136430.24415@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1103212136430.24415@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2011 02:13 PM, Thomas Gleixner wrote:
> On Mon, 21 Mar 2011, David Daney wrote:
>
>> On 03/19/2011 01:51 PM, Thomas Gleixner wrote:
>>> On Fri, 18 Mar 2011, David Daney wrote:
>>>> --- a/include/linux/irqdesc.h
>>>> +++ b/include/linux/irqdesc.h
>>>> @@ -178,6 +178,12 @@ static inline int irq_has_action(unsigned int irq)
>>>>    	return desc->action != NULL;
>>>>    }
>>>>
>>>> +/* Test to see if the irq is currently enabled */
>>>> +static inline int irq_desc_is_enabled(struct irq_desc *desc)
>>>> +{
>>>> +	return desc->depth == 0;
>>>> +}
>>>
>>> That want's to go into kernel/irq/internal.h
>>
>> I think I need to use this in my irq_chip.irq_unmask method.
>>
>> Consider this:
>>
>>
>> CPU0                   CPU1
>> handle_level_irq
>>    lock
>>    mask
>>    handle_irq_event
>>      unlock
>>      .
>>      .                  disable_irq
>>      .
>>      lock
>>    unmask
>>    unlock
>
> handle level irq does:
>
> 	if (!(desc->istate&  (IRQS_DISABLED | IRQS_ONESHOT)))
> 		unmask_irq(desc);
>
> So it does not call unmask.
>
>> I need to know in my .unmask method if the interrupt has been disabled.  If it
>> has, I will not re-enable (unmask)it.
>
> It wont be called :)
>

I missed that.  Really irq_desc_is_enabled() should just use the 
IRQS_DISABLED flag.

I will do that.


>>>
>>>>    #ifndef CONFIG_GENERIC_HARDIRQS_NO_COMPAT
>>>>    static inline int irq_balancing_disabled(unsigned int irq)
>>>>    {
>>>> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
>>>> index c9c0601..40736f7 100644
>>>> --- a/kernel/irq/chip.c
>>>> +++ b/kernel/irq/chip.c
>>>> @@ -689,3 +689,38 @@ void irq_modify_status(unsigned int irq, unsigned
>>>> long clr, unsigned long set)
>>>>
>>>>    	irq_put_desc_unlock(desc, flags);
>>>>    }
>>>> +
>>>> +void irq_cpu_online(unsigned int irq)
>>>
>>> Odd function name. It does not reflect that this is for per cpu
>>> interrupts. So something like irq_xxx_per_cpu_irq(irq)
>>> might be a bit more descriptive.
>>
>> I am using it for per cpu interrupts, but I didn't want to impose that policy
>> on others.
>
> I can't imagine any other purpose for that.

Modifying the affinity of non-per-cpu IRQs to use the new CPU?

>
>>> Though one question remains: should we just iterate over the irq space
>>> and call the online/offline callbacks when available instead of having
>>> the arch code do the iteration.
>>>
>>
>> That would be good I think, especially for sparse irqs.
>>
>> In the case of the CPU going offline, the .irq_cpu_offline() may need to
>> adjust the affinity so that the irq no longer has affinity for the off-lined
>> CPU.
>>
>> This is something needed even for non-per-cpu interrupts.  Also I would need a
>> way to call irq_set_affinity() while holding the desc->lock.
>
> Hmm. The offline fixup_irq() code is arch specific and usually calls
> desc->irq_data.chip->irq_set_affinity under desc->lock. I have not yet
> found an arch independent way to do that. Any ideas welcome.
>

There are all the new affinity callbacks, and the things shown in 
procfs?  Are those handled properly if I call chip->irq_set_affinity?  I 
think not.

David Daney

