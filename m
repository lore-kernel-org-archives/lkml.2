Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab0HCJBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 05:01:25 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24175 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab0HCJBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 05:01:24 -0400
Message-ID: <4C57DACF.1090503@kernel.org>
Date: Tue, 03 Aug 2010 02:01:03 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Dave Airlie <airlied@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: oops in ioapic_write_entry
References: <AANLkTimeFuABgQHJzq38uJ-4gTQbfSRfQBb91P+NPwCS@mail.gmail.com>	<AANLkTimqDPvTqOZiBgUn7t4JJhgQU4ShVTsCJEzV=8fR@mail.gmail.com>	<AANLkTi=sNRwxmv8aKN_jo7tAx6SQ-AOFfAXJxcPnNZQp@mail.gmail.com>	<4C577197.9020003@kernel.org> <4C57723C.1060400@kernel.org>	<m1bp9k2xsg.fsf@fess.ebiederm.org> <4C57C319.8070800@kernel.org>	<m11vagw2fl.fsf@fess.ebiederm.org> <4C57CD9C.70602@kernel.org> <m1fwywoz0f.fsf@fess.ebiederm.org>
In-Reply-To: <m1fwywoz0f.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4C57DAD9.01E2,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2010 01:56 AM, Eric W. Biederman wrote:
> Yinghai Lu <yinghai@kernel.org> writes:
> 
>> On 08/03/2010 01:00 AM, Eric W. Biederman wrote:
>>> Yinghai Lu <yinghai@kernel.org> writes:
>>>
>>>>>> Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
>>>>>> ===================================================================
>>>>>> --- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
>>>>>> +++ linux-2.6/arch/x86/kernel/apic/io_apic.c
>>>>>> @@ -1029,10 +1029,7 @@ static int pin_2_irq(int idx, int apic,
>>>>>>  	} else {
>>>>>>  		u32 gsi = mp_gsi_routing[apic].gsi_base + pin;
>>>>>>  
>>>>>> -		if (gsi >= NR_IRQS_LEGACY)
>>>>>> -			irq = gsi;
>>>>>> -		else
>>>>>> -			irq = gsi_top + gsi;
>>>>>> +		irq = gsi_to_irq(gsi);
>>>>>>  	}
>>>>>>  
>>>>>>  #ifdef CONFIG_X86_32
>>>>
>>>> what is the point for making irq = gsi_top + gsi when mptable is used instead of acpi?
>>>
>>> Because it is only convention that when mptables are used that the
>>> first apic pins 0-15 are the ISA irqs.  This thread witnessed and a
>>> pci irq that came in pin < 16 that was not an ISA irq.  The truly rare
>>> and exotic case would be for the ISA irqs to be outside the first 16
>>> ioapic pins but the es7000 did exactly that.
>>
>> nvidia chipset if acpi is enabled, external pci device will use ioapic from 16 to 23.
>>
>> if mptable is used, external pci device will not use pin from 16 to 23..., and lot of devices will share same pin.
> 
> Exactly.  Pins < 16 are not necessarily ISA irqs, and can be possibly
> shared level triggered PCI irqs.  Unfortunately there are strange
> boards like the es7000 where pins > 16 are ISA irqs.
> 
> The other thing that is gained by having pin_2_irq always remap pins <
> 16 is we can get away with the numerous hard codes in the arch/x86 and elsewhere
> that assume irq < 16 is an ISA irq.

how about this one ?

---
 arch/x86/kernel/apic/io_apic.c |   31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -1013,6 +1013,28 @@ static inline int irq_trigger(int idx)
 	return MPBIOS_trigger(idx);
 }
 
+static int shared_with_legacy(int apic, int pin)
+{
+	int i;
+
+	for (i = 0; i < mp_irq_entries; i++) {
+		int bus = mp_irqs[i].srcbus;
+
+		if (!test_bit(bus, mp_bus_not_pci))
+			continue;
+
+		if (mp_ioapics[apic].apicid != mp_irqs[i].dstapic)
+			continue;
+
+		if (mp_irqs[i].dstirq != pin)
+			continue;
+
+		return mp_irqs[i].srcbusirq;
+	}
+
+	return -1;
+}
+
 static int pin_2_irq(int idx, int apic, int pin)
 {
 	int irq;
@@ -1029,10 +1051,13 @@ static int pin_2_irq(int idx, int apic,
 	} else {
 		u32 gsi = mp_gsi_routing[apic].gsi_base + pin;
 
-		if (gsi >= NR_IRQS_LEGACY)
+		if (gsi >= NR_IRQS_LEGACY) {
 			irq = gsi;
-		else
-			irq = gsi_top + gsi;
+		} else {
+			irq = shared_with_legacy(apic, pin);
+			if (irq < 0)
+				irq = gsi_top + gsi;
+		}
 	}
 
 #ifdef CONFIG_X86_32
