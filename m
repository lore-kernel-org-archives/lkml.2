Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab1IZVcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 17:32:23 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54750 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab1IZVcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 17:32:21 -0400
Message-ID: <4E80EF61.2000509@gmail.com>
Date: Mon, 26 Sep 2011 16:32:17 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110918 Thunderbird/7.0
MIME-Version: 1.0
To: Jamie Iles <jamie@jamieiles.com>
CC: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        marc.zyngier@arm.com, thomas.abraham@linaro.org, b-cousson@ti.com,
        shawn.guo@linaro.org, dave.martin@linaro.org, linux@arm.linux.org.uk,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 3/3] ARM: gic: add OF based initialization
References: <1316550244-3655-1-git-send-email-robherring2@gmail.com> <1316550244-3655-4-git-send-email-robherring2@gmail.com> <20110926195704.GD9194@gallagher> <4E80E547.2080004@gmail.com> <20110926211127.GE9194@gallagher>
In-Reply-To: <20110926211127.GE9194@gallagher>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2011 04:11 PM, Jamie Iles wrote:
> On Mon, Sep 26, 2011 at 03:49:11PM -0500, Rob Herring wrote:
>> On 09/26/2011 02:57 PM, Jamie Iles wrote:
>>> Hi Rob,
>>>
>>> On Tue, Sep 20, 2011 at 03:24:04PM -0500, Rob Herring wrote:
>>> [...]
>>>> +int __init gic_of_init(struct device_node *node, struct device_node *parent)
>>>> +{
>>>> +	void __iomem *cpu_base;
>>>> +	void __iomem *dist_base;
>>>> +	int irq;
>>>> +	struct irq_domain *domain = &gic_data[gic_cnt].domain;
>>>> +
>>>> +	if (WARN_ON(!node))
>>>> +		return -ENODEV;
>>>> +
>>>> +	dist_base = of_iomap(node, 0);
>>>> +	WARN(!dist_base, "unable to map gic dist registers\n");
>>>> +
>>>> +	cpu_base = of_iomap(node, 1);
>>>> +	WARN(!cpu_base, "unable to map gic cpu registers\n");
>>>> +
>>>> +	domain->nr_irq = gic_irq_count(dist_base);
>>>> +	/* subtract off SGIs. Also subtract off PPIs for secondary GICs */
>>>> +	if (parent)
>>>> +		domain->nr_irq -= 32;
>>>> +	else
>>>> +		domain->nr_irq -= 16;
>>>> +
>>>> +	domain->irq_base = irq_alloc_descs(-1, 16, domain->nr_irq, numa_node_id());
>>>
>>> The way I understand irq_alloc_descs() (probably not very well) is that 
>>> having the irq parameter < 0 and the from parameter 16 means that it 
>>> needs to find domain->nr_irq descs starting from at least 16.  But if 
>>> the base is greater than 16, does this still work with the gic entry 
>>> macros as they are?
>>
>> No, but that would only happen if a platform calls irq_alloc_descs prior
>> to this code. The root controller must be initialized first (for other
>> reasons as well). There are no calls to irq_alloc_descs in arch/arm.
>>
>> With the MULTI_IRQ GIC support Marc Z is working on, we could make the
>> GIC irq mapping be completely dynamic. Although, there's probably not
>> much reason to do so for the root controller.
> 
> OK, that makes sense.  I think that if you were to do 
> irq_alloc_descs(16, 16, domain->nr_irqs, num_node_id()) then that will 
> guarantee the descriptors start from 16 (if they are available) which is 
> probably nicer.
> 
That would break secondary GICs though as it would always fail. For
secondary GIC, we skip SGIs and PPIs and allocate the first available
block of irq_desc's.

Rob
