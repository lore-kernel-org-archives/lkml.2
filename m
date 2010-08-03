Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab0HCJiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 05:38:13 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26599 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714Ab0HCJiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 05:38:09 -0400
Message-ID: <4C57E32A.9070401@kernel.org>
Date: Tue, 03 Aug 2010 02:36:42 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Dave Airlie <airlied@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: oops in ioapic_write_entry
References: <AANLkTimeFuABgQHJzq38uJ-4gTQbfSRfQBb91P+NPwCS@mail.gmail.com>	<AANLkTimqDPvTqOZiBgUn7t4JJhgQU4ShVTsCJEzV=8fR@mail.gmail.com>	<AANLkTi=sNRwxmv8aKN_jo7tAx6SQ-AOFfAXJxcPnNZQp@mail.gmail.com>	<4C577197.9020003@kernel.org> <4C57723C.1060400@kernel.org>	<m1bp9k2xsg.fsf@fess.ebiederm.org> <4C57C319.8070800@kernel.org>	<m11vagw2fl.fsf@fess.ebiederm.org> <4C57CD9C.70602@kernel.org>	<m1fwywoz0f.fsf@fess.ebiederm.org> <4C57DACF.1090503@kernel.org> <m17hk8oy5g.fsf@fess.ebiederm.org>
In-Reply-To: <m17hk8oy5g.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4C57E36E.0017,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2010 02:15 AM, Eric W. Biederman wrote:
> Yinghai Lu <yinghai@kernel.org> writes:
> 
>> On 08/03/2010 01:56 AM, Eric W. Biederman wrote:
>>> Yinghai Lu <yinghai@kernel.org> writes:
>>>
>>>> On 08/03/2010 01:00 AM, Eric W. Biederman wrote:
>>>>> Yinghai Lu <yinghai@kernel.org> writes:
>>>>>
>>>>>>>> Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
>>>>>>>> ===================================================================
>>>>>>>> --- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
>>>>>>>> +++ linux-2.6/arch/x86/kernel/apic/io_apic.c
>>>>>>>> @@ -1029,10 +1029,7 @@ static int pin_2_irq(int idx, int apic,
>>>>>>>>  	} else {
>>>>>>>>  		u32 gsi = mp_gsi_routing[apic].gsi_base + pin;
>>>>>>>>  
>>>>>>>> -		if (gsi >= NR_IRQS_LEGACY)
>>>>>>>> -			irq = gsi;
>>>>>>>> -		else
>>>>>>>> -			irq = gsi_top + gsi;
>>>>>>>> +		irq = gsi_to_irq(gsi);
>>>>>>>>  	}
>>>>>>>>  
>>>>>>>>  #ifdef CONFIG_X86_32
>>>>>>
>>>>>> what is the point for making irq = gsi_top + gsi when mptable is used instead of acpi?
>>>>>
>>>>> Because it is only convention that when mptables are used that the
>>>>> first apic pins 0-15 are the ISA irqs.  This thread witnessed and a
>>>>> pci irq that came in pin < 16 that was not an ISA irq.  The truly rare
>>>>> and exotic case would be for the ISA irqs to be outside the first 16
>>>>> ioapic pins but the es7000 did exactly that.
>>>>
>>>> nvidia chipset if acpi is enabled, external pci device will use ioapic from 16 to 23.
>>>>
>>>> if mptable is used, external pci device will not use pin from 16 to 23..., and lot of devices will share same pin.
>>>
>>> Exactly.  Pins < 16 are not necessarily ISA irqs, and can be possibly
>>> shared level triggered PCI irqs.  Unfortunately there are strange
>>> boards like the es7000 where pins > 16 are ISA irqs.
>>>
>>> The other thing that is gained by having pin_2_irq always remap pins <
>>> 16 is we can get away with the numerous hard codes in the arch/x86 and elsewhere
>>> that assume irq < 16 is an ISA irq.
>>
>> how about this one ?
> 
> You can't share an edge triggered ISA irq, it isn't really physically
> possible.  So I don't see how this extra complexity will change anything.
> 

Dave's system mptble:

MPTABLE: OEM ID: DELL    
MPTABLE: Product ID: Dell XPS710 
MPTABLE: APIC at: 0xFEE00000
Processor #0 (Bootup-CPU)
Processor #1
Bus #0 is PCI   
Bus #1 is PCI   
Bus #2 is PCI   
Bus #3 is PCI   
Bus #4 is PCI   
Bus #5 is PCI   
Bus #6 is PCI   
Bus #7 is PCI   
Bus #8 is PCI   
Bus #9 is PCI   
Bus #10 is ISA   
I/O APIC #8 Version 17 at 0xFEC00000.
IOAPIC[0]: apic_id 8, version 17, address 0xfec00000, GSI 0-23
Int: type 0, pol 0, trig 0, bus 0a, IRQ 00, APIC ID 8, APIC INT 00
Int: type 0, pol 0, trig 0, bus 0a, IRQ 01, APIC ID 8, APIC INT 01
Int: type 3, pol 1, trig 1, bus 0a, IRQ 00, APIC ID 8, APIC INT 02
Int: type 0, pol 0, trig 0, bus 0a, IRQ 03, APIC ID 8, APIC INT 03
Int: type 0, pol 0, trig 0, bus 0a, IRQ 04, APIC ID 8, APIC INT 04
Int: type 0, pol 0, trig 0, bus 0a, IRQ 05, APIC ID 8, APIC INT 05
Int: type 0, pol 0, trig 0, bus 0a, IRQ 06, APIC ID 8, APIC INT 06
Int: type 0, pol 0, trig 0, bus 0a, IRQ 07, APIC ID 8, APIC INT 07
Int: type 0, pol 0, trig 0, bus 0a, IRQ 08, APIC ID 8, APIC INT 08
Int: type 0, pol 0, trig 0, bus 0a, IRQ 09, APIC ID 8, APIC INT 09
Int: type 0, pol 0, trig 0, bus 0a, IRQ 0a, APIC ID 8, APIC INT 0a
Int: type 0, pol 0, trig 0, bus 0a, IRQ 0b, APIC ID 8, APIC INT 0b
Int: type 0, pol 0, trig 0, bus 0a, IRQ 0c, APIC ID 8, APIC INT 0c
Int: type 0, pol 0, trig 0, bus 0a, IRQ 0e, APIC ID 8, APIC INT 0e
Int: type 0, pol 0, trig 0, bus 0a, IRQ 0f, APIC ID 8, APIC INT 0f
Int: type 0, pol 0, trig 0, bus 00, IRQ 28, APIC ID 8, APIC INT 09
Int: type 0, pol 0, trig 0, bus 00, IRQ 2c, APIC ID 8, APIC INT 0a
Int: type 0, pol 0, trig 0, bus 00, IRQ 2d, APIC ID 8, APIC INT 0a
Int: type 0, pol 0, trig 0, bus 00, IRQ 34, APIC ID 8, APIC INT 0e
Int: type 0, pol 0, trig 0, bus 00, IRQ 38, APIC ID 8, APIC INT 0b
Int: type 0, pol 0, trig 0, bus 00, IRQ 38, APIC ID 8, APIC INT 0b
Int: type 0, pol 0, trig 0, bus 00, IRQ 38, APIC ID 8, APIC INT 0b
Int: type 0, pol 0, trig 0, bus 00, IRQ 34, APIC ID 8, APIC INT 09
Int: type 0, pol 0, trig 0, bus 01, IRQ 00, APIC ID 8, APIC INT 0b
Int: type 0, pol 0, trig 0, bus 01, IRQ 01, APIC ID 8, APIC INT 0a
Int: type 0, pol 0, trig 0, bus 01, IRQ 02, APIC ID 8, APIC INT 09
Int: type 0, pol 0, trig 0, bus 03, IRQ 00, APIC ID 0, APIC INT 10
Int: type 0, pol 0, trig 0, bus 04, IRQ 00, APIC ID 0, APIC INT 10
Int: type 0, pol 0, trig 0, bus 04, IRQ 01, APIC ID 0, APIC INT 11
Int: type 0, pol 0, trig 0, bus 05, IRQ 00, APIC ID 8, APIC INT 0a
Int: type 0, pol 0, trig 0, bus 05, IRQ 01, APIC ID 8, APIC INT 09
Int: type 0, pol 0, trig 0, bus 05, IRQ 03, APIC ID 8, APIC INT 0b
Int: type 0, pol 0, trig 0, bus 06, IRQ 00, APIC ID 8, APIC INT 09
Int: type 0, pol 0, trig 0, bus 07, IRQ 0c, APIC ID 8, APIC INT 09
Int: type 0, pol 0, trig 0, bus 07, IRQ 0e, APIC ID 8, APIC INT 0b
Int: type 0, pol 0, trig 0, bus 07, IRQ 0f, APIC ID 8, APIC INT 0a
Int: type 0, pol 0, trig 0, bus 07, IRQ 10, APIC ID 8, APIC INT 0b
Int: type 0, pol 0, trig 0, bus 07, IRQ 11, APIC ID 8, APIC INT 0a
Int: type 0, pol 0, trig 0, bus 07, IRQ 12, APIC ID 8, APIC INT 09
Int: type 0, pol 0, trig 0, bus 07, IRQ 14, APIC ID 8, APIC INT 0a
Int: type 0, pol 0, trig 0, bus 07, IRQ 15, APIC ID 8, APIC INT 09
Int: type 0, pol 0, trig 0, bus 07, IRQ 17, APIC ID 8, APIC INT 0b
Int: type 0, pol 0, trig 0, bus 07, IRQ 28, APIC ID 8, APIC INT 09
Int: type 0, pol 0, trig 0, bus 08, IRQ 00, APIC ID 8, APIC INT 0a
Int: type 0, pol 0, trig 0, bus 08, IRQ 01, APIC ID 8, APIC INT 09
Int: type 0, pol 0, trig 0, bus 08, IRQ 03, APIC ID 8, APIC INT 0b
Int: type 0, pol 0, trig 0, bus 09, IRQ 00, APIC ID 8, APIC INT 0b
Int: type 0, pol 0, trig 0, bus 09, IRQ 01, APIC ID 8, APIC INT 0a
Int: type 0, pol 0, trig 0, bus 09, IRQ 02, APIC ID 8, APIC INT 09
Lint: type 3, pol 1, trig 1, bus 0a, IRQ 00, APIC ID ff, APIC LINT 00
Lint: type 1, pol 1, trig 1, bus 0a, IRQ 00, APIC ID ff, APIC LINT 01
