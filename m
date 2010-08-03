Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab0HCIBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 04:01:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:21485 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab0HCIBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 04:01:20 -0400
Message-ID: <4C57CCBB.1010608@kernel.org>
Date: Tue, 03 Aug 2010 01:00:59 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Dave Airlie <airlied@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: oops in ioapic_write_entry
References: <AANLkTimeFuABgQHJzq38uJ-4gTQbfSRfQBb91P+NPwCS@mail.gmail.com>	<AANLkTimqDPvTqOZiBgUn7t4JJhgQU4ShVTsCJEzV=8fR@mail.gmail.com>	<AANLkTi=sNRwxmv8aKN_jo7tAx6SQ-AOFfAXJxcPnNZQp@mail.gmail.com>	<4C577197.9020003@kernel.org> <4C57723C.1060400@kernel.org> <m1bp9k2xsg.fsf@fess.ebiederm.org> <4C57C319.8070800@kernel.org>
In-Reply-To: <4C57C319.8070800@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4C57CCC3.0008,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2010 12:19 AM, Yinghai Lu wrote:
> On 08/02/2010 08:13 PM, Eric W. Biederman wrote:
>> Yinghai Lu <yinghai@kernel.org> writes:
>>
>>> On 08/02/2010 06:32 PM, Yinghai Lu wrote:
>>>> On 08/02/2010 04:17 PM, Dave Airlie wrote:
>>>>>>
>>>>>> the kernel is using mptable, and the  system have mcp55, so how come
>>>>>> with irq 35?
>>>>>> assume we should only have ioapic irq 0 - 23 ...
>>>>>>
>>>>>> Can you send out boot log with "debug apic=debug pci=routeirq" with
>>>>>> 2.6.32 and 2.6.35?
>>>>>
>>>>> Okay el6log is from a RHEL6 2.6.32 kernel, but it should give a good
>>>>> baseline, the 2.6.35 oops even earlier with all those options and is
>>>>> in the second attachment.
>>>>
>>>
>>
>> This patch is wrong and there is no reason to even suspect it will
>> affect this problem.  At best this patch will trade one set of bugs
>> for another because at least on some platforms we always did something
>> like this.  Having an irq 35 is odd and certainly a result of recent
>> changes, but in this case it doesn't look like it has anything to do
>> with the problem.
>>
>> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>>
>>> please use this one instead..., forget to run quilt refresh before sending it.
>>>
>>> [PATCH -v2] x86: fix pin_2_irq mapping
>>>
>>> We should not twist gsi to irq mapping if acpi is not used.
>>>
>>> -v2 remove not used irq_to_gsi()
>>>
>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>
>>> ---
>>>  arch/x86/include/asm/io_apic.h |   10 ++++++++++
>>>  arch/x86/kernel/acpi/boot.c    |    4 ++--
>>>  arch/x86/kernel/apic/io_apic.c |    5 +----
>>>  3 files changed, 13 insertions(+), 6 deletions(-)
>>>
>>> Index: linux-2.6/arch/x86/include/asm/io_apic.h
>>> ===================================================================
>>> --- linux-2.6.orig/arch/x86/include/asm/io_apic.h
>>> +++ linux-2.6/arch/x86/include/asm/io_apic.h
>>> @@ -185,6 +185,16 @@ int mp_find_ioapic_pin(int ioapic, u32 g
>>>  void __init mp_register_ioapic(int id, u32 address, u32 gsi_base);
>>>  extern void __init pre_init_apic_IRQ0(void);
>>>  
>>> +#ifdef CONFIG_ACPI
>>> +unsigned int gsi_to_irq(unsigned int gsi);
>>> +u32 irq_to_gsi(int irq);
>>> +#else
>>> +static inline unsigned int gsi_to_irq(unsigned int gsi)
>>> +{
>>> +	return gsi;
>>> +}
>>> +#endif
>>> +
>>>  #else  /* !CONFIG_X86_IO_APIC */
>>>  
>>>  #define io_apic_assign_pci_irqs 0
>>> Index: linux-2.6/arch/x86/kernel/acpi/boot.c
>>> ===================================================================
>>> --- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
>>> +++ linux-2.6/arch/x86/kernel/acpi/boot.c
>>> @@ -100,7 +100,7 @@ static u32 isa_irq_to_gsi[NR_IRQS_LEGACY
>>>  	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
>>>  };
>>>  
>>> -static unsigned int gsi_to_irq(unsigned int gsi)
>>> +unsigned int gsi_to_irq(unsigned int gsi)
>>>  {
>>>  	unsigned int irq = gsi + NR_IRQS_LEGACY;
>>>  	unsigned int i;
>>> @@ -123,7 +123,7 @@ static unsigned int gsi_to_irq(unsigned
>>>  	return irq;
>>>  }
>>>  
>>> -static u32 irq_to_gsi(int irq)
>>> +u32 irq_to_gsi(int irq)
>>>  {
>>>  	unsigned int gsi;
>>>  
>>> Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
>>> ===================================================================
>>> --- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
>>> +++ linux-2.6/arch/x86/kernel/apic/io_apic.c
>>> @@ -1029,10 +1029,7 @@ static int pin_2_irq(int idx, int apic,
>>>  	} else {
>>>  		u32 gsi = mp_gsi_routing[apic].gsi_base + pin;
>>>  
>>> -		if (gsi >= NR_IRQS_LEGACY)
>>> -			irq = gsi;
>>> -		else
>>> -			irq = gsi_top + gsi;
>>> +		irq = gsi_to_irq(gsi);
>>>  	}
>>>  
>>>  #ifdef CONFIG_X86_32
> 
> what is the point for making irq = gsi_top + gsi when mptable is used instead of acpi?
> 

just tried those blind shifting gsi cause kernel with acpi crash in virtual box.

[    5.536000] querying PCI -> IRQ mapping bus:0, slot:11, pin:0.
[    5.540000] ehci_hcd 0000:00:0b.0: can't find IRQ for PCI INT A; probably buggy MP table
[

and on kvm it got:
[    4.352280] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k6-NAPI
[    4.356012] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    4.360120] querying PCI -> IRQ mapping bus:0, slot:3, pin:0.
[    4.364006] PCI BIOS passed nonexistent PCI bus 0!
[    4.368007] e1000 0000:00:03.0: can't find IRQ for PCI INT A; probably buggy MP table
[    4.372049] e1000 0000:00:03.0: setting latency timer to 64

Yinghai
