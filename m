Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab0JGEkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 00:40:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51489 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab0JGEkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 00:40:36 -0400
Message-ID: <4CAD4EC3.5060809@kernel.org>
Date: Wed, 06 Oct 2010 21:38:27 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 00/47] Sparse irq rework
References: <20100930221351.682772535@linutronix.de> <20101003112312.GB9844@angua.secretlab.ca> <20101003112920.GB32736@n2100.arm.linux.org.uk> <AANLkTingVuhgdaLZ8U3bM+F2vZJ_kScwKqNtHW=g6DcH@mail.gmail.com> <alpine.LFD.2.00.1010031544340.14550@localhost6.localdomain6> <alpine.LFD.2.00.1010051219580.2556@localhost6.localdomain6> <4CACFC23.4080504@kernel.org> <alpine.LFD.2.00.1010070050410.17015@localhost6.localdomain6> <4CAD082B.40908@kernel.org> <4CAD1154.3080403@kernel.org> <alpine.LFD.2.00.1010070559480.17015@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1010070559480.17015@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2010 09:01 PM, Thomas Gleixner wrote:
> On Wed, 6 Oct 2010, Yinghai Lu wrote:
> 
>> On 10/06/2010 04:37 PM, Yinghai Lu wrote:
>>> On 10/06/2010 03:52 PM, Thomas Gleixner wrote:
>>>> On Wed, 6 Oct 2010, Yinghai Lu wrote:
>>>>
>>>>> On 10/05/2010 03:22 AM, Thomas Gleixner wrote:
>>>>>> On Sun, 3 Oct 2010, Thomas Gleixner wrote:
>>>>>>> On Sun, 3 Oct 2010, Grant Likely wrote:
>>>>>>>> Okay, patch 14 looks good to me too (including Yinghai's comment).
>>>>>>>> The new allocator seems sane, and I didn't see any obvious errors in
>>>>>>>> patches 16-47.  I've not tested any of this yet.  Hopefully I'll be
>>>>>>>> able to carve out some time to do so early this week.
>>>>>>>
>>>>>>> Wait until I pushed out a fixed tree. In meantime I found out how I
>>>>>>> managed to screw up the quilt series :(
>>>>>>>
>>>>>>> Will post, once it's ready.
>>>>>>
>>>>>> Pushed out an updated tree to
>>>>>>
>>>>>>  git://git.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-sparse-irq.git master
>>>>>>
>>>>>
>>>>> test it together with tip, it seems all io apic routing is not set rightly. MSI is ok...
>>>>>
>>>>> [  200.290040] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
>>>>> [  200.290991] ehci_hcd 0000:00:1d.7: setting latency timer to 64
>>>>> [  200.310002] ehci_hcd 0000:00:1d.7: EHCI Host Controller
>>>>> [  200.310455] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
>>>>> [  200.330127] ehci_hcd 0000:00:1d.7: debug port 1
>>>>> [  200.334395] ehci_hcd 0000:00:1d.7: cache line size of 256 is not supported
>>>>> [  200.350042] ehci_hcd 0000:00:1d.7: request interrupt 23 failed
>>>>> [  200.350491] ehci_hcd 0000:00:1d.7: USB bus 1 deregistered
>>>>> [  200.372257] ehci_hcd 0000:00:1d.7: PCI INT A disabled
>>>>> [  200.372644] ehci_hcd 0000:00:1d.7: init 0000:00:1d.7 fail, -38
>>>>> [  200.389916] ehci_hcd: probe of 0000:00:1d.7 failed with error -38
>>>>
>>>> Yep. Ingo's testing found that already. Does the patch below fix it ?
>>>>
>>>> Thanks,
>>>>
>>>> 	tglx
>>>> ---
>>>> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
>>>> index 2f171df..eb3d01d 100644
>>>> --- a/arch/x86/kernel/apic/io_apic.c
>>>> +++ b/arch/x86/kernel/apic/io_apic.c
>>>> @@ -252,11 +252,15 @@ static struct irq_cfg *alloc_irq_and_cfg_at(unsigned int at, int node)
>>>>  static struct irq_cfg *get_irq_cfg_at(unsigned int at, int node)
>>>>  {
>>>>  	int res = irq_alloc_desc_at(at, node);
>>>> +	struct irq_data *data;
>>>>  
>>>>  	if (res < 0 && res != -EEXIST)
>>>>  		return NULL;
>>>>  
>>>> -	return get_irq_chip_data(at);
>>>> +	data = irq_get_irq_data(at);
>>>> +	if (res >= 0 && !data->chip_data)
>>>> +		data->chip_data = alloc_irq_cfg(at, node);
>>>> +	return data->chip_data;
>>>>  }
>>>>  
>>>>  static int alloc_irq_from(unsigned int from, int node)
>>>
>>> yes, it fixes the problem.
>>>
>>> but can you merge get_irq_cfg_at() and alloc_irq_and_cfg_at() ? 
>>> it's confusing to let get_...() to do the alloc work.
> 
> Well, I'm not too happy about this preallocated stuff anyway, which is
> the reason for the warning below.
>  
>> [   80.726176] WARNING: at drivers/pci/intr_remapping.c:67 irq_2_iommu_alloc+0x52/0xdc()
>> [   80.745935] Hardware name: Sun Fire X4800
>> [   80.746179] irq_2_iommu!=NULL irq 8
> 

no, irq_2_iommu are all dynamically allocated even for irq < 16.

that trace look like pnpacpi try to register the irq.

Yinghai
