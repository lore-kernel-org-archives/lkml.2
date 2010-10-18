Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933355Ab0JRVaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 17:30:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:33744 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755704Ab0JRVaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 17:30:23 -0400
References: <4CBCB274.7010108@kernel.org> <alpine.LFD.2.00.1010182304050.6815@localhost6.localdomain6> <alpine.LFD.2.00.1010182311110.6815@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1010182311110.6815@localhost6.localdomain6>
Mime-Version: 1.0 (iPhone Mail 8B117)
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <54A1618A-3DAC-43A7-8FCD-1EE8992F7413@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: iPhone Mail (8B117)
From: Yinghai <yinghai@kernel.org>
Subject: Re: [PATCH] x86, irq: Check if irq is remapped before freeing irte
Date: Mon, 18 Oct 2010 14:28:18 -0700
To: Thomas Gleixner <tglx@linutronix.de>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.3 (hera.kernel.org [140.211.167.34]); Mon, 18 Oct 2010 21:30:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Oct 18, 2010, at 2:17 PM, Thomas Gleixner <tglx@linutronix.de> wrote:

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
>>>    unsigned long flags;
>>>    int index;
>>> 
>>> -    if (!entry || !irq_iommu)
>>> +    if (!entry || !irq_iommu || !irq_iommu->iommu)
>>>        return -1;
>> 
>> Hmm, why do we need this? This is only called from
>> ir_ioapic_set_affinity() and ir_msi_set_affinity().
>> 
>> We should never end up there when intr_remapping=off, right ?
> 
> Thinking more about it, this check is actively bogus. The call sites do:
> 
>        struct irte irte;
> 
>        if (get_irte(irq, &irte))
>                return -1;
> 
> So entry _CANNOT_ be NULL.
> 
> And in fact we should change get_irte() to
> 
> get_irte(struct irq_2_iommu *irq_iommu, struct irte *entry)
> 
> The call site already knows about it. No need to lookup irq_iommu
> based on the irq number.

Yes
