Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab0HCGAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 02:00:23 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55880 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab0HCGAW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 02:00:22 -0400
To: Dave Airlie <airlied@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: oops in ioapic_write_entry
References: <AANLkTimeFuABgQHJzq38uJ-4gTQbfSRfQBb91P+NPwCS@mail.gmail.com>
	<AANLkTimqDPvTqOZiBgUn7t4JJhgQU4ShVTsCJEzV=8fR@mail.gmail.com>
	<AANLkTi=sNRwxmv8aKN_jo7tAx6SQ-AOFfAXJxcPnNZQp@mail.gmail.com>
	<m139uw1imy.fsf@fess.ebiederm.org>
	<AANLkTi=qtLkY0=h77=EVL+y1q41b_cMBODvL4Hu6A6wL@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 02 Aug 2010 23:00:13 -0700
In-Reply-To: <AANLkTi=qtLkY0=h77=EVL+y1q41b_cMBODvL4Hu6A6wL@mail.gmail.com> (Dave Airlie's message of "Tue\, 3 Aug 2010 14\:02\:46 +1000")
Message-ID: <m1bp9kxmky.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie <airlied@gmail.com> writes:

> On Tue, Aug 3, 2010 at 1:26 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Dave Airlie <airlied@gmail.com> writes:

>>> Okay el6log is from a RHEL6 2.6.32 kernel, but it should give a good
>>> baseline, the 2.6.35 oops even earlier with all those options and is
>>> in the second attachment.
>>
>> It appears we have a smoking gun:
>>
>> For some reason setup_IO_APIC_IRQS thinks we at least 2 io_apics,
>> but we have only setup 1 io_apic.  Since io_apics need a kmap entry
>> accessing an apic that hasn't been setup will definitely give a
>> page fault.  It sounds like something is stomping nr_ioapics.
>>
>> From: 2.6.35-debuglog
>> IOAPIC[0]: apic_id 8, version 17, address 0xfec00000, GSI 0-23
>> ....
>> IOAPIC[1]: Set routing entry (0-16 -> 0x51 -> IRQ 16 Mode:1 Active:1)
>>
>> Can we get your System.map of the failing kernel (so we can see what
>> is close to nr_ioapics), and could you add a print statement in
>> arch/x86/kernel/apic/io_apic:setup_IO_APIC_irqs to print nr_ioapics?
>>
>> I would be surprised if drm changes could have affected this.
>>
>
> Okay, from my debug addition it still only seems to have one ioapic

Thanks. I goofed reading that code.  I saw setup_IO_APIC_irq and made
the incorrect leap that said we came from setup_IO_APIC_irqs, when
in fact we are coming from io_apic_set_pci_routing.

So let's see can I figure out why we are getting a bad apic_id.

For that I need to track back to pirq_enable_irq, which leads
me to IO_APIC_get_PCI_irq_vector.  The likely canidate is that we
simply are not finding the apicid that is present in the mp_irqs
entry that we decided to return.  The patch below should add
appropriate debugging and fix the lookup 

The real difference appears to be that acpi is disabled where it
is not disabled in your reference kernel.

Dave can you verify this fixes the oops for you?

It would be nice if we didn't crash early in boot even without
acpi present.

Eric

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e41ed24..e824e14 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1067,7 +1067,7 @@ static int pin_2_irq(int idx, int apic, int pin)
 int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
 				struct io_apic_irq_attr *irq_attr)
 {
-	int apic, i, best_guess = -1;
+	int i, best_guess = -1;
 
 	apic_printk(APIC_DEBUG,
 		    "querying PCI -> IRQ mapping bus:%d, slot:%d, pin:%d.\n",
@@ -1080,16 +1080,29 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
 	for (i = 0; i < mp_irq_entries; i++) {
 		int lbus = mp_irqs[i].srcbus;
 
-		for (apic = 0; apic < nr_ioapics; apic++)
-			if (mp_ioapics[apic].apicid == mp_irqs[i].dstapic ||
-			    mp_irqs[i].dstapic == MP_APIC_ALL)
-				break;
-
 		if (!test_bit(lbus, mp_bus_not_pci) &&
 		    !mp_irqs[i].irqtype &&
 		    (bus == lbus) &&
 		    (slot == ((mp_irqs[i].srcbusirq >> 2) & 0x1f))) {
-			int irq = pin_2_irq(i, apic, mp_irqs[i].dstirq);
+			int apic;
+			int irq;
+
+			/* Lookup the ioapic by id */
+			for (apic = 0; apic < nr_ioapics; apic++)
+				if (mp_ioapics[apic].apicid == mp_irqs[i].dstapic ||
+					mp_irqs[i].dstapic == MP_APIC_ALL)
+					break;
+
+			/* Verify we found the ioapic */
+			if (apic >= nr_ioapics) {
+				printk(KERN_ERR 
+					"%02x:%02x.%c: APIC_ID %u pin: %u not found BIOS bug?\n",
+					bus, slot, 'A' + pin - 1,
+					mp_irqs[i].dstapic, mp_irqs[i].dstirq);
+				continue;
+			}
+
+			irq = pin_2_irq(i, apic, mp_irqs[i].dstirq);
 
 			if (!(apic || IO_APIC_IRQ(irq)))
 				continue;
@@ -1099,7 +1112,8 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
 						     mp_irqs[i].dstirq,
 						     irq_trigger(i),
 						     irq_polarity(i));
-				return irq;
+				best_guess = irq;
+				goto out;
 			}
 			/*
 			 * Use the first all-but-pin matching entry as a
@@ -1114,6 +1128,12 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
 			}
 		}
 	}
+out:
+	if (best_guess >= 0)
+		apic_printk(APIC_DEBUG,
+			"%02x:%02x.%c: IRQ %u IOAPIC: %u pin: %u",
+			bus, slot, 'A' + pin - 1,
+			best_guess, irq_attr->ioapic, irq_attr->ioapic_pin);
 	return best_guess;
 }
 EXPORT_SYMBOL(IO_APIC_get_PCI_irq_vector);
