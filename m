Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965010Ab2CBSED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 13:04:03 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:10723 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab2CBSEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 13:04:01 -0500
Message-ID: <4F510B8E.3070201@cavium.com>
Date: Fri, 02 Mar 2012 10:03:58 -0800
From: David Daney <david.daney@cavium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: David Daney <ddaney.cavm@gmail.com>, linux-mips@linux-mips.org,
        ralf@linux-mips.org, devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 4/5] MIPS: Octeon: Setup irq_domains for interrupts.
References: <1330563422-14078-1-git-send-email-ddaney.cavm@gmail.com> <1330563422-14078-5-git-send-email-ddaney.cavm@gmail.com> <4F50D7C2.7080204@gmail.com>
In-Reply-To: <4F50D7C2.7080204@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Mar 2012 18:03:59.0537 (UTC) FILETIME=[D7C40210:01CCF89E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2012 06:22 AM, Rob Herring wrote:
[...]
>> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
>> index ce30e2f..01344ae 100644
>> --- a/arch/mips/Kconfig
>> +++ b/arch/mips/Kconfig
>> @@ -1432,6 +1432,7 @@ config CPU_CAVIUM_OCTEON
>>   	select WEAK_ORDERING
>>   	select CPU_SUPPORTS_HIGHMEM
>>   	select CPU_SUPPORTS_HUGEPAGES
>> +	select IRQ_DOMAIN
>
> IIRC, Grant has a patch cued up that enables IRQ_DOMAIN for all of MIPS.
>

Indeed, I now see it in linux-next.  I will remove this one.

>>   	help
>>   	  The Cavium Octeon processor is a highly integrated chip containing
>>   	  many ethernet hardware widgets for networking tasks. The processor
>> diff --git a/arch/mips/cavium-octeon/octeon-irq.c b/arch/mips/cavium-octeon/octeon-irq.c
>> index bdcedd3..e9f2f6c 100644
>> --- a/arch/mips/cavium-octeon/octeon-irq.c
>> +++ b/arch/mips/cavium-octeon/octeon-irq.c
[...]
>> +static void __init octeon_irq_set_ciu_mapping(unsigned int irq,
>> +					      unsigned int line,
>> +					      unsigned int bit,
>> +					      struct irq_domain *domain,
>>   					      struct irq_chip *chip,
>>   					      irq_flow_handler_t handler)
>>   {
>> +	struct irq_data *irqd;
>>   	union octeon_ciu_chip_data cd;
>>
>>   	irq_set_chip_and_handler(irq, chip, handler);
>> -
>>   	cd.l = 0;
>>   	cd.s.line = line;
>>   	cd.s.bit = bit;
>>
>>   	irq_set_chip_data(irq, cd.p);
>>   	octeon_irq_ciu_to_irq[line][bit] = irq;
>> +
>> +	irqd = irq_get_irq_data(irq);
>> +	irqd->hwirq = line<<  6 | bit;
>> +	irqd->domain = domain;
>
> I think the domain code will set these.

It is my understanding that the domain code only does this for:

o irq_domain_add_legacy()

o irq_create_direct_mapping()

o irq_create_mapping()

We use none of those.  So I do it here.

If there is a better way, I am open to suggestions.

[...]
>> @@ -982,6 +1092,10 @@ static void __init octeon_irq_init_ciu(void)
>>   	struct irq_chip *chip_mbox;
>>   	struct irq_chip *chip_wd;
>>   	struct irq_chip *chip_gpio;
>> +	struct device_node *gpio_node;
>> +	struct device_node *ciu_node;
>> +	struct irq_domain *gpio_domain;
>> +	struct irq_domain *ciu_domain;
>>
>>   	octeon_irq_init_ciu_percpu();
>>   	octeon_irq_setup_secondary = octeon_irq_setup_secondary_ciu;
>> @@ -1011,83 +1125,144 @@ static void __init octeon_irq_init_ciu(void)
>>   	/* Mips internal */
>>   	octeon_irq_init_core();
>>
>> +	gpio_node = of_find_compatible_node(NULL, NULL, "cavium,octeon-3860-gpio");
>> +	ciu_node = of_find_compatible_node(NULL, NULL, "cavium,octeon-3860-ciu");
>> +	/* gpio domain host_data is the base hwirq number. */
>> +	gpio_domain = irq_domain_add_linear(gpio_node, 16,&octeon_irq_domain_gpio_ops, (void *)16);
>
> It would be better to define a struct here rather than casting a data
> value to a ptr.

You mean allocate storage for the data somewhere and then pass a pointer 
to it?

If so, I could, but it would just be adding code and data size just to 
satisfy some coding style thing...

Or do you want a union of the pointer and my int?  That would use the 
same amount of storage, but add more source code to gain what?

[...]
>> +	octeon_irq_set_ciu_mapping(OCTEON_IRQ_PEM0, 1, 48,
>> +				   ciu_domain, chip, handle_level_irq);
>> +	octeon_irq_set_ciu_mapping(OCTEON_IRQ_PEM1, 1, 49,
>> +				   ciu_domain, chip, handle_level_irq);
>> +	octeon_irq_set_ciu_mapping(OCTEON_IRQ_SRIO0, 1, 50,
>> +				   ciu_domain, chip, handle_level_irq);
>> +	octeon_irq_set_ciu_mapping(OCTEON_IRQ_SRIO1, 1, 51,
>> +				   ciu_domain, chip, handle_level_irq);
>> +	octeon_irq_set_ciu_mapping(OCTEON_IRQ_LMC0, 1, 52,
>> +				   ciu_domain, chip, handle_level_irq);
>> +	octeon_irq_set_ciu_mapping(OCTEON_IRQ_DFM, 1, 56,
>> +				   ciu_domain, chip, handle_level_irq);
>> +	octeon_irq_set_ciu_mapping(OCTEON_IRQ_RST, 1, 63,
>> +				   ciu_domain, chip, handle_level_irq);
>>
>
> Can all these calls be moved into the .map function somehow?
>

No, the non-OF code using the OCTEON_IRQ_* symbols doesn't use 
irq_domain, so the .map function would never be used.


> edge vs. level should be driven by dts.
>

We may have to disagree on this point.  Because:

1) edge vs. level can be accurately probed, as we do here.

2) The dts doesnt contain the information.


David Daney
