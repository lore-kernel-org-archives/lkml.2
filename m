Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab0HCBdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 21:33:32 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31535 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab0HCBdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 21:33:31 -0400
Message-ID: <4C577197.9020003@kernel.org>
Date: Mon, 02 Aug 2010 18:32:07 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: oops in ioapic_write_entry
References: <AANLkTimeFuABgQHJzq38uJ-4gTQbfSRfQBb91P+NPwCS@mail.gmail.com>	<AANLkTimqDPvTqOZiBgUn7t4JJhgQU4ShVTsCJEzV=8fR@mail.gmail.com> <AANLkTi=sNRwxmv8aKN_jo7tAx6SQ-AOFfAXJxcPnNZQp@mail.gmail.com>
In-Reply-To: <AANLkTi=sNRwxmv8aKN_jo7tAx6SQ-AOFfAXJxcPnNZQp@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4C5771DF.01DA,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 04:17 PM, Dave Airlie wrote:
>>
>> the kernel is using mptable, and the  system have mcp55, so how come
>> with irq 35?
>> assume we should only have ioapic irq 0 - 23 ...
>>
>> Can you send out boot log with "debug apic=debug pci=routeirq" with
>> 2.6.32 and 2.6.35?
> 
> Okay el6log is from a RHEL6 2.6.32 kernel, but it should give a good
> baseline, the 2.6.35 oops even earlier with all those options and is
> in the second attachment.

please check

[PATCH] x86: fix pin_2_irq mapping

We should not twist gsi to irq mapping if acpi is not used.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/io_apic.h |   14 ++++++++++++++
 arch/x86/kernel/acpi/boot.c    |    4 ++--
 arch/x86/kernel/apic/io_apic.c |    5 +----
 3 files changed, 17 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/include/asm/io_apic.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/io_apic.h
+++ linux-2.6/arch/x86/include/asm/io_apic.h
@@ -185,6 +185,20 @@ int mp_find_ioapic_pin(int ioapic, u32 g
 void __init mp_register_ioapic(int id, u32 address, u32 gsi_base);
 extern void __init pre_init_apic_IRQ0(void);
 
+#ifdef CONFIG_ACPI
+unsigned int gsi_to_irq(unsigned int gsi);
+u32 irq_to_gsi(int irq);
+#else
+static inline unsigned int gsi_to_irq(unsigned int gsi)
+{
+	return gsi;
+}
+static u32 irq_to_gsi(int irq)
+{
+	return irq;
+}
+#endif
+
 #else  /* !CONFIG_X86_IO_APIC */
 
 #define io_apic_assign_pci_irqs 0
Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -100,7 +100,7 @@ static u32 isa_irq_to_gsi[NR_IRQS_LEGACY
 	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
 };
 
-static unsigned int gsi_to_irq(unsigned int gsi)
+unsigned int gsi_to_irq(unsigned int gsi)
 {
 	unsigned int irq = gsi + NR_IRQS_LEGACY;
 	unsigned int i;
@@ -123,7 +123,7 @@ static unsigned int gsi_to_irq(unsigned
 	return irq;
 }
 
-static u32 irq_to_gsi(int irq)
+u32 irq_to_gsi(int irq)
 {
 	unsigned int gsi;
 
Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -1029,10 +1029,7 @@ static int pin_2_irq(int idx, int apic,
 	} else {
 		u32 gsi = mp_gsi_routing[apic].gsi_base + pin;
 
-		if (gsi >= NR_IRQS_LEGACY)
-			irq = gsi;
-		else
-			irq = gsi_top + gsi;
+		irq = gsi_to_irq(gsi);
 	}
 
 #ifdef CONFIG_X86_32
