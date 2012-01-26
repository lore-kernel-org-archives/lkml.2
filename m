Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab2AZSQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 13:16:00 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45586 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab2AZSP7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 13:15:59 -0500
MIME-Version: 1.0
In-Reply-To: <4F216819.7030106@gmail.com>
References: <1327450719-25590-1-git-send-email-grant.likely@secretlab.ca>
 <4F1F5FE0.9090901@gmail.com> <CACxGe6s3R0fcBSf_YHTpXp15gtEBHRQg5-YM=cDO5UfY9cRGrQ@mail.gmail.com>
 <CACxGe6tgGqQSThzVVEzwOdtYkjKHT1uQhZBOkCTwkutyKXDCAg@mail.gmail.com> <4F216819.7030106@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 26 Jan 2012 11:15:39 -0700
X-Google-Sender-Auth: X1Xa7FS5a8bHXAP7wPnTnrQHFwk
Message-ID: <CACxGe6tseS77b9SGC2OkWUx-GcrVG3P6ziAnCQ2DvY-AdApJ6w@mail.gmail.com>
Subject: Re: [RFC 1/2] irq_domain: Create common xlate functions that device
 drivers can use
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 7:50 AM, Rob Herring <robherring2@gmail.com> wrote:
> On 01/25/2012 11:59 AM, Grant Likely wrote:
>> On Tue, Jan 24, 2012 at 10:35 PM, Grant Likely
>> <grant.likely@secretlab.ca> wrote:
>>> On Tue, Jan 24, 2012 at 6:50 PM, Rob Herring <robherring2@gmail.com> wrote:
>>>>
>>>>
>>>> On 01/24/2012 06:18 PM, Grant Likely wrote:
>>>>> Rather than having each interrupt controller driver creating its own barely
>>>>> unique .xlate function for irq_domain, create a library of translators which
>>>>> any driver can use directly.
>>>>>
>>>>> diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
>>>>> index e7379a3..5e497a0 100644
>>>>> --- a/include/linux/irqdomain.h
>>>>> +++ b/include/linux/irqdomain.h
>>>>> @@ -110,6 +110,9 @@ struct irq_domain {
>>>>>       void *host_data;
>>>>>       irq_hw_number_t inval_irq;
>>>>>
>>>>> +     /* Data for common irq xlate functions */
>>>>> +     unsigned int xlate_type;
>>>>> +
>>>>
>>>> How does this get set? Do we want interrupt controllers messing with the
>>>> domain struct directly long term?
>>>
>>> It defaults to IRQ_TYPE_NONE in the alloc function and drivers can
>>> override it.  Alternately it could be made part of the
>>> irq_domain_add() arguments, but I'm not thrilled with adding a whole
>>> bunch of arguments to the function prototype.
>>
>> Do you like this better (built on top of this patch)?
>
> Yes, I think it's better.

I've changed my mind on this after looking at the generated code.
These functions are so simple that it actually is larger (both in
source and object size) to call out to a common function.  I've gone
back to each _xlate_*() function open coding the two assignments.

g.

>
>> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
>> index ef2b1fe..7856c04 100644
>> --- a/kernel/irq/irqdomain.c
>> +++ b/kernel/irq/irqdomain.c
>> @@ -701,12 +701,10 @@ int irq_domain_xlate_onecell(struct irq_domain
>> *d, struct device_node *ctrlr,
>>                            const u32 *intspec, unsigned int intsize,
>>                            unsigned long *out_hwirq, unsigned int *out_type)
>>  {
>> -     if (WARN(intsize < 1, "Bad intspec for %s: intsize=%i < 1\n",
>> -              ctrlr->full_name, intsize))
>> +     if (WARN_ON(intsize < 1))
>>               return -EINVAL;
>> -     *out_hwirq = intspec[0];
>> -     *out_type = d->xlate_type;
>> -     return 0;
>> +     return irq_domain_xlate_onetwocell(d, ctrlr, intspec, 1,
>> +                                        out_hwirq, out_type);
>>  }
>>  EXPORT_SYMBOL_GPL(irq_domain_xlate_onecell);
>>
>> @@ -721,12 +719,10 @@ int irq_domain_xlate_twocell(struct irq_domain
>> *d, struct device_node *ctrlr,
>>                       const u32 *intspec, unsigned int intsize,
>>                       irq_hw_number_t *out_hwirq, unsigned int *out_type)
>>  {
>> -     if (WARN(intsize < 2, "Bad intspec for %s: intsize=%i < 2\n",
>> -              ctrlr->full_name, intsize))
>> +     if (WARN_ON(intsize < 2))
>>               return -EINVAL;
>> -     *out_hwirq = intspec[0];
>> -     *out_type = intspec[1] & IRQ_TYPE_SENSE_MASK;
>> -     return 0;
>> +     return irq_domain_xlate_onetwocell(d, ctrlr, intspec, intsize,
>> +                                        out_hwirq, out_type);
>>  }
>>  EXPORT_SYMBOL_GPL(irq_domain_xlate_twocell);
>>
>> @@ -746,8 +742,7 @@ int irq_domain_xlate_onetwocell(struct irq_domain *d,
>>                               const u32 *intspec, unsigned int intsize,
>>                               unsigned long *out_hwirq, unsigned int *out_type)
>>  {
>> -     if (WARN(intsize < 1, "Bad intspec for %s: intsize=%i < 1\n",
>> -              ctrlr->full_name, intsize))
>> +     if (WARN_ON(intsize < 1))
>>               return -EINVAL;
>>       *out_hwirq = intspec[0];
>>       *out_type = d->xlate_type;
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
