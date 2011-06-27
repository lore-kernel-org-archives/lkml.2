Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032Ab1F0J7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 05:59:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:58323 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757799Ab1F0J5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 05:57:50 -0400
Message-ID: <4E08541A.4060302@linutronix.de>
Date: Mon, 27 Jun 2011 11:57:46 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Andres Salomon <dilinger@queued.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH] irq: add irq_domain translation infrastructure
References: <20110526065438.23444.69386.stgit@ponder>	 <20110627090059.GA31287@linutronix.de> <1309166659.32158.380.camel@pasglop>
In-Reply-To: <1309166659.32158.380.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Mon, 2011-06-27 at 11:00 +0200, Sebastian Andrzej Siewior wrote:
>> * Grant Likely | 2011-05-26 00:54:38 [-0600]:
>>
>>> diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
>>> index 39645b6..9891cd4 100644
>>> --- a/arch/x86/kernel/devicetree.c
>>> +++ b/arch/x86/kernel/devicetree.c
>>> @@ -371,36 +321,49 @@ static struct of_ioapic_type of_ioapic_type[] =
>>> 	},
>>> };
>>>
>>> -static int ioapic_xlate(struct irq_domain *id, const u32 *intspec, u32 intsize,
>>> -			u32 *out_hwirq, u32 *out_type)
>>> +static int ioapic_dt_translate(struct irq_domain *domain,
>>> +				struct device_node *controller,
>>> +				const u32 *intspec, u32 intsize,
>>> +				irq_hw_number_t *out_hwirq, u32 *out_type)
>>> {
>>> -	struct mp_ioapic_gsi *gsi_cfg;
>>> 	struct io_apic_irq_attr attr;
>>> 	struct of_ioapic_type *it;
>>> 	u32 line, idx, type;
>>> +	int rc;
>>>
>>> -	if (intsize < 2)
>>> +	if (controller != domain->of_node)
>>> 		return -EINVAL;
>> Is there a reason not havining the (controller != domain->of_node) check
>> in irq_create_of_mapping()?
> 
> Not all domains are associated with a single OF node.
> 
> Take xics, where there can be quite a few "source controllers" which act
> as device-tree interrupt parents but there's a single global domain.

I see. No, actually I don't. xics is pseries where I don't see the .dts. 
So you are saying that we have one irq_domain but 2+ different
interrupt-parents nodes?

How do you distinguish then between two different controllers lets say
xics and a gpio based controller? This implementation calls ->dt_translate
until one controller returns 0 which looks like brute force.

xics_host_xlate() returns always zero so you would have to go for
the compatible and check it.
Every device has an interrupt-parent node. Shouldn't the code call exact 
this irq controller xlate function instead of trying them all?

>  
> Cheers,
> Ben.
> 
Sebastian

