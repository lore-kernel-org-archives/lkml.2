Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab1G2Wer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 18:34:47 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:65114 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab1G2Wep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 18:34:45 -0400
Message-ID: <4E33356B.40509@kernel.org>
Date: Fri, 29 Jul 2011 15:34:19 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] x86, ioapic: Seperate print_IO_APIC() to only print one
 io apic
References: <4E1F0BC9.1040102@kernel.org> <CAErSpo5CzU2j81moWLsHDoRxTs5107=AEAWYi3ezy3Xfw86qiQ@mail.gmail.com> <4E29BEEA.4020600@kernel.org> <20110725072831.GB22518@elte.hu> <4E33334D.1030007@kernel.org>
In-Reply-To: <4E33334D.1030007@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090207.4E333576.000A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It is getting too big after interrupt remaping entries debug print out
was added.

Original print_IO_APIC become print_IO_APICs.
New print_IO_APIC will only print one ioapic registers

it will make checpatch.pl happy with removing indent warning..

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/io_apic.c |   46 +++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 22 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -1512,30 +1512,14 @@ static void __init setup_timer_IRQ0_pin(
 	ioapic_write_entry(apic_id, pin, entry);
 }
 
-
-__apicdebuginit(void) print_IO_APIC(void)
+__apicdebuginit(void) print_IO_APIC(int apic)
 {
-	int apic, i;
+	int i;
 	union IO_APIC_reg_00 reg_00;
 	union IO_APIC_reg_01 reg_01;
 	union IO_APIC_reg_02 reg_02;
 	union IO_APIC_reg_03 reg_03;
 	unsigned long flags;
-	struct irq_cfg *cfg;
-	unsigned int irq;
-
-	printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
-	for (i = 0; i < nr_ioapics; i++)
-		printk(KERN_DEBUG "number of IO-APIC #%d registers: %d.\n",
-		       mpc_ioapic_id(i), ioapics[i].nr_registers);
-
-	/*
-	 * We are a bit conservative about what we expect.  We have to
-	 * know about every hardware change ASAP.
-	 */
-	printk(KERN_INFO "testing the IO APIC.......................\n");
-
-	for (apic = 0; apic < nr_ioapics; apic++) {
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	reg_00.raw = io_apic_read(apic, 0);
@@ -1636,7 +1620,27 @@ __apicdebuginit(void) print_IO_APIC(void
 			);
 		}
 	}
-	}
+}
+
+__apicdebuginit(void) print_IO_APICs(void)
+{
+	int apic, i;
+	struct irq_cfg *cfg;
+	unsigned int irq;
+
+	printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
+	for (i = 0; i < nr_ioapics; i++)
+		printk(KERN_DEBUG "number of IO-APIC #%d registers: %d.\n",
+		       mpc_ioapic_id(i), ioapics[i].nr_registers);
+
+	/*
+	 * We are a bit conservative about what we expect.  We have to
+	 * know about every hardware change ASAP.
+	 */
+	printk(KERN_INFO "testing the IO APIC.......................\n");
+
+	for (apic = 0; apic < nr_ioapics; apic++)
+		print_IO_APIC(apic);
 
 	printk(KERN_DEBUG "IRQ to pin mappings:\n");
 	for_each_active_irq(irq) {
@@ -1655,8 +1659,6 @@ __apicdebuginit(void) print_IO_APIC(void
 	}
 
 	printk(KERN_INFO ".................................... done.\n");
-
-	return;
 }
 
 __apicdebuginit(void) print_APIC_field(int base)
@@ -1850,7 +1852,7 @@ __apicdebuginit(int) print_ICs(void)
 		return 0;
 
 	print_local_APICs(show_lapic);
-	print_IO_APIC();
+	print_IO_APICs();
 
 	return 0;
 }
