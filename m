Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644Ab2CISpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 13:45:55 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56105 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab2CISpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 13:45:54 -0500
Message-ID: <4F5A4FDE.1030305@gmail.com>
Date: Fri, 09 Mar 2012 10:45:50 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: David Daney <david.s.daney@gmail.com>, Rob Herring <robherring2@gmail.com>,
        David Daney <ddaney.cavm@gmail.com>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 4/5] MIPS: Octeon: Setup irq_domains for interrupts.
References: <1330563422-14078-1-git-send-email-ddaney.cavm@gmail.com> <1330563422-14078-5-git-send-email-ddaney.cavm@gmail.com> <4F50D7C2.7080204@gmail.com> <4F510B8E.3070201@cavium.com> <20120302190744.571E03E1C63@localhost> <4F511FB0.5070901@cavium.com> <4F527285.1020500@gmail.com> <4F52F90C.5060306@gmail.com> <20120309055704.465823E0901@localhost>
In-Reply-To: <20120309055704.465823E0901@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2012 09:57 PM, Grant Likely wrote:
> On Sat, 03 Mar 2012 21:09:32 -0800, David Daney<david.s.daney@gmail.com>  wrote:
>> On 03/03/2012 11:35 AM, Rob Herring wrote:
>>> On 03/02/2012 01:29 PM, David Daney wrote:
>>>> On 03/02/2012 11:07 AM, Grant Likely wrote:
>>>>> +static void __init octeon_irq_set_ciu_mapping(unsigned int irq,
>>>>> +                          unsigned int line,
>>>>> +                          unsigned int bit,
>>>>> +                          struct irq_domain *domain,
>>>>>                                struct irq_chip *chip,
>>>>>                                irq_flow_handler_t handler)
>>>>>      {
>>>>> +    struct irq_data *irqd;
>>>>>          union octeon_ciu_chip_data cd;
>>>>>
>>>>>          irq_set_chip_and_handler(irq, chip, handler);
>>>>> -
>>>>>          cd.l = 0;
>>>>>          cd.s.line = line;
>>>>>          cd.s.bit = bit;
>>>>>
>>>>>          irq_set_chip_data(irq, cd.p);
>>>>>          octeon_irq_ciu_to_irq[line][bit] = irq;
>>>>> +
>>>>> +    irqd = irq_get_irq_data(irq);
>>>>> +    irqd->hwirq = line<<     6 | bit;
>>>>> +    irqd->domain = domain;
>>>>>>> I think the domain code will set these.
>>>>>> It is my understanding that the domain code only does this for:
>>>>>>
>>>>>> o irq_domain_add_legacy()
>>>>>>
>>>>>> o irq_create_direct_mapping()
>>>>>>
>>>>>> o irq_create_mapping()
>>>>>>
>>>>>> We use none of those.  So I do it here.
>>>>>>
>>>>>> If there is a better way, I am open to suggestions.
>>>>> irq_create_mapping is called by irq_create_of_mapping() which is
>>>>> in turn called by irq_of_parse_and-map().  irq_domain always
>>>>> manages the hwirq and domain values.  Driver code cannot manipulate
>>>>> them manually.
>>>>>
>>>> I really must be missing something.
>>>>
>>>> Given:
>>>>
>>>> 1) I must have a mapping between hwirq and irq that I control so that
>>>> non-OF code using the OCTEON_IRQ_* constants continues to work.
>>> Those defines are what you need to work to get rid of.
>>
>> We are not starting from a blank slate here.  There is a lot of in-tree
>> code using these symbols.  We cannot make them disappear with wishful
>> thinking.
>>
>> The first step is a switch to irq_domains using the existing mappings.
>>
>> After we do that, I have patches to transition some drivers to use the
>> OF mapping via irq_domains.  After those are merged, we can work toward
>> getting rid of OCTEON_IRQ_*.  But I think it must be the last step in
>> the process, not the first.
>>>
>>>> 2) irq_create_mapping() will allocate a random irq value if none is
>>>> already assigned to the hwirq.
>>>>
>>>> Therefore: To avoid having random irq values assigned, I must manually
>>>> assign them.
>>>>
>>> So you should be using legacy domain if you need to maintain fixed hwirq
>>> to linux irq numbers. "linear" is a bit confusing as it doesn't mean
>>> linear 1:1 irq number assignment, but linear search.
>>
>> My reading of Grant's code in linux-next directly contradicts this
>> statement.  There is no code in irqdomain.c, that I can see, that allows
>> me to have an arbitrary mapping of irq<-->  hwirq values.
>
> There are 4 kinds of mappings available; legacy, linear, radix and nomap.
>

Yes, I had discovered that.

> Ignore nomap and radix; you don't want them.
>
> legacy maps a contiguous range of hwirq numbers to a contiguous range of
> linux irq numbers.  To preserve the exising #define mappings but still add
> DT support, this is the one that you want.

This is precisely the point that you and Rob seem to have missed in the 
last three or four back-and-forths about this.

Probably I have not explained well enough why legacy will not work.

We have three different interrupt controllers (although only one is 
currently in-tree).  hwirq to irq mapping for them is more or less as 
follows:

irq                 hwirqCIU        hwirqCIU2      hwirqCIU3
----------------------------------------------------------------------
OCTEON_IRQ_USB0     56               81             934562
OCTEON_IRQ_TWSI     45              224             100543
OCTEON_IRQ_UART0    34              228               4572
.
.
.

Now what we notice here is that there is no possible 1:1 linearly 
increasing mapping possible for the irq and *all* three hwirq sets.  We 
want a single binary that contains support for all three interrupt 
controllers, so the OCTEON_IRQ_* values have to be the same for all 
three interrupt controllers.  Because of this, legacy mapping is 
*impossible*.

Since the possible ranges of the hwirq values is very large and quite 
sparse, probably the radix mapping will be required.

Also to support non-OF drivers and architecture specific code for the 
near future, I really think the existing IRQ values *must* be preserved.

Therefore, as I said above, we need a way for my SOC/board code to 
specify the mapping.

Perhaps we need to add an optional function to struct irq_domain_ops 
that would allow the default mapping to be overridden on a per 
irq_domain basis.

Otherwise, I think I will have to keep poking into the internal 
irq_domain data structures to get the mappings I want.

What do you think?

David Daney
