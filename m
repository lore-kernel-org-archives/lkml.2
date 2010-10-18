Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558Ab0JRWW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 18:22:56 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:54623 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab0JRWWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 18:22:55 -0400
Message-ID: <4CBCC8B3.7030706@kernel.org>
Date: Mon, 18 Oct 2010 15:22:43 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100914 SUSE/3.0.8 Thunderbird/3.0.8
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, irq: Check if irq is remapped before freeing irte
References: <4CBCB274.7010108@kernel.org> <alpine.LFD.2.00.1010182304050.6815@localhost6.localdomain6> <alpine.LFD.2.00.1010182311110.6815@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1010182311110.6815@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2010 02:17 PM, Thomas Gleixner wrote:
> 
> 
> On Mon, 18 Oct 2010, Thomas Gleixner wrote:
> 
>> On Mon, 18 Oct 2010, Yinghai Lu wrote:
>>>
>>> Index: linux-2.6/drivers/pci/intr_remapping.c
>>> ===================================================================
>>> --- linux-2.6.orig/drivers/pci/intr_remapping.c
>>> +++ linux-2.6/drivers/pci/intr_remapping.c
>>> @@ -60,7 +60,7 @@ int get_irte(int irq, struct irte *entry
>>>  	unsigned long flags;
>>>  	int index;
>>>  
>>> -	if (!entry || !irq_iommu)
>>> +	if (!entry || !irq_iommu || !irq_iommu->iommu)
>>>  		return -1;
>>
>> Hmm, why do we need this? This is only called from
>> ir_ioapic_set_affinity() and ir_msi_set_affinity().
>>
>> We should never end up there when intr_remapping=off, right ?
> 
> Thinking more about it, this check is actively bogus. The call sites do:
> 
>         struct irte irte;
> 
>         if (get_irte(irq, &irte))
>                 return -1;
> 
> So entry _CANNOT_ be NULL.
> 
> And in fact we should change get_irte() to
> 
> get_irte(struct irq_2_iommu *irq_iommu, struct irte *entry)
> 
> The call site already knows about it. No need to lookup irq_iommu
> based on the irq number.

looks like all irq-irte related API could replace "int irq" to "struct irq_2_iommu *irq_iommu"

extern int get_irte(int irq, struct irte *entry);
extern int modify_irte(int irq, struct irte *irte_modified);
extern int alloc_irte(struct intel_iommu *iommu, int irq, u16 count);
extern int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index,
                        u16 sub_handle);
extern int map_irq_to_irte_handle(int irq, u16 *sub_handle);
extern int free_irte(int irq);

Thanks

Yinghai
