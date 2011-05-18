Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab1ERXd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 19:33:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:52806 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756170Ab1ERXb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 19:31:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,234,1304319600"; 
   d="scan'208";a="3674367"
Message-Id: <20110518233157.744315519@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Wed, 18 May 2011 16:31:35 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, daniel.blueman@gmail.com,
        suresh.b.siddha@intel.com
Subject: [patch 5/9] x86, ioapic: add struct ioapic
References: <20110518233130.524634928@sbsiddha-MOBL3.sc.intel.com>
Content-Disposition: inline; filename=setup_ioapic_struct.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce struct ioapic with nr_registers field.

This will pave way for consolidating different MAX_IO_APICS arrays into it.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/io_apic.h |    1 -
 arch/x86/kernel/apic/io_apic.c |   32 +++++++++++++++++---------------
 2 files changed, 17 insertions(+), 16 deletions(-)

Index: linux-2.6-tip/arch/x86/include/asm/io_apic.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/io_apic.h
+++ linux-2.6-tip/arch/x86/include/asm/io_apic.h
@@ -105,7 +105,6 @@ struct IR_IO_APIC_route_entry {
  * # of IO-APICs and # of IRQ routing registers
  */
 extern int nr_ioapics;
-extern int nr_ioapic_registers[MAX_IO_APICS];
 
 #define MP_MAX_IOAPIC_PIN 127
 
Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
@@ -76,10 +76,12 @@ int sis_apic_bug = -1;
 static DEFINE_RAW_SPINLOCK(ioapic_lock);
 static DEFINE_RAW_SPINLOCK(vector_lock);
 
-/*
- * # of IRQ routing registers
- */
-int nr_ioapic_registers[MAX_IO_APICS];
+static struct ioapic {
+	/*
+	 * # of IRQ routing registers
+	 */
+	int nr_registers;
+} ioapics[MAX_IO_APICS];
 
 /* I/O APIC entries */
 struct mpc_ioapic mp_ioapics[MAX_IO_APICS];
@@ -187,7 +189,7 @@ int __init arch_early_irq_init(void)
 	for (i = 0; i < nr_ioapics; i++) {
 		ioapic_saved_data[i] =
 			kzalloc(sizeof(struct IO_APIC_route_entry) *
-				nr_ioapic_registers[i], GFP_KERNEL);
+				ioapics[i].nr_registers, GFP_KERNEL);
 		if (!ioapic_saved_data[i])
 			pr_err("IOAPIC %d: suspend/resume impossible!\n", i);
 	}
@@ -586,7 +588,7 @@ static void clear_IO_APIC (void)
 	int apic, pin;
 
 	for (apic = 0; apic < nr_ioapics; apic++)
-		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++)
+		for (pin = 0; pin < ioapics[apic].nr_registers; pin++)
 			clear_IO_APIC_pin(apic, pin);
 }
 
@@ -642,7 +644,7 @@ int save_ioapic_entries(void)
 			continue;
 		}
 
-		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++)
+		for (pin = 0; pin < ioapics[apic].nr_registers; pin++)
 			ioapic_saved_data[apic][pin] =
 				ioapic_read_entry(apic, pin);
 	}
@@ -661,7 +663,7 @@ void mask_ioapic_entries(void)
 		if (!ioapic_saved_data[apic])
 			continue;
 
-		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
+		for (pin = 0; pin < ioapics[apic].nr_registers; pin++) {
 			struct IO_APIC_route_entry entry;
 
 			entry = ioapic_saved_data[apic][pin];
@@ -684,7 +686,7 @@ int restore_ioapic_entries(void)
 		if (!ioapic_saved_data[apic])
 			continue;
 
-		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++)
+		for (pin = 0; pin < ioapics[apic].nr_registers; pin++)
 			ioapic_write_entry(apic, pin,
 					   ioapic_saved_data[apic][pin]);
 	}
@@ -1191,7 +1193,7 @@ static inline int IO_APIC_irq_trigger(in
 	int apic, idx, pin;
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
-		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
+		for (pin = 0; pin < ioapics[apic].nr_registers; pin++) {
 			idx = find_irq_entry(apic, pin, mp_INT);
 			if ((idx != -1) && (irq == pin_2_irq(idx, apic, pin)))
 				return irq_trigger(idx);
@@ -1358,7 +1360,7 @@ static void __init __io_apic_setup_irqs(
 	struct io_apic_irq_attr attr;
 	unsigned int pin, irq;
 
-	for (pin = 0; pin < nr_ioapic_registers[apic_id]; pin++) {
+	for (pin = 0; pin < ioapics[apic_id].nr_registers; pin++) {
 		idx = find_irq_entry(apic_id, pin, mp_INT);
 		if (io_apic_pin_not_connected(idx, apic_id, pin))
 			continue;
@@ -1480,7 +1482,7 @@ __apicdebuginit(void) print_IO_APIC(void
 	printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
 	for (i = 0; i < nr_ioapics; i++)
 		printk(KERN_DEBUG "number of IO-APIC #%d registers: %d.\n",
-		       mp_ioapics[i].apicid, nr_ioapic_registers[i]);
+		       mp_ioapics[i].apicid, ioapics[i].nr_registers);
 
 	/*
 	 * We are a bit conservative about what we expect.  We have to
@@ -1794,7 +1796,7 @@ void __init enable_IO_APIC(void)
 	for(apic = 0; apic < nr_ioapics; apic++) {
 		int pin;
 		/* See if any of the pins is in ExtINT mode */
-		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
+		for (pin = 0; pin < ioapics[apic].nr_registers; pin++) {
 			struct IO_APIC_route_entry entry;
 			entry = ioapic_read_entry(apic, pin);
 
@@ -3754,7 +3756,7 @@ void __init setup_ioapic_dest(void)
 		return;
 
 	for (ioapic = 0; ioapic < nr_ioapics; ioapic++)
-	for (pin = 0; pin < nr_ioapic_registers[ioapic]; pin++) {
+	for (pin = 0; pin < ioapics[ioapic].nr_registers; pin++) {
 		irq_entry = find_irq_entry(ioapic, pin, mp_INT);
 		if (irq_entry == -1)
 			continue;
@@ -3948,7 +3950,7 @@ void __init mp_register_ioapic(int id, u
 	/*
 	 * The number of IO-APIC IRQ registers (== #pins):
 	 */
-	nr_ioapic_registers[idx] = entries;
+	ioapics[idx].nr_registers = entries;
 
 	if (mp_gsi_routing[idx].gsi_end >= gsi_top)
 		gsi_top = mp_gsi_routing[idx].gsi_end + 1;


