Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379Ab1ERXcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 19:32:24 -0400
Received: from mga14.intel.com ([143.182.124.37]:35438 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932245Ab1ERXcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 19:32:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,234,1304319600"; 
   d="scan'208";a="438684302"
Message-Id: <20110518233157.830697056@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Wed, 18 May 2011 16:31:36 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, daniel.blueman@gmail.com,
        suresh.b.siddha@intel.com
Subject: [patch 6/9] x86, ioapic: conslidate ioapic_saved_data[] into struct ioapic
References: <20110518233130.524634928@sbsiddha-MOBL3.sc.intel.com>
Content-Disposition: inline; filename=move_saved_data_to_ioapic_struct.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
@@ -81,6 +81,10 @@ static struct ioapic {
 	 * # of IRQ routing registers
 	 */
 	int nr_registers;
+	/*
+	 * Saved state during suspend/resume, or while enabling intr-remap.
+	 */
+	struct IO_APIC_route_entry *saved_registers;
 } ioapics[MAX_IO_APICS];
 
 /* I/O APIC entries */
@@ -102,11 +106,6 @@ int mp_irq_entries;
 /* GSI interrupts */
 static int nr_irqs_gsi = NR_IRQS_LEGACY;
 
-/*
- * Saved I/O APIC state during suspend/resume, or while enabling intr-remap.
-*/
-static struct IO_APIC_route_entry *ioapic_saved_data[MAX_IO_APICS];
-
 #if defined (CONFIG_MCA) || defined (CONFIG_EISA)
 int mp_bus_id_to_type[MAX_MP_BUSSES];
 #endif
@@ -187,10 +186,10 @@ int __init arch_early_irq_init(void)
 	}
 
 	for (i = 0; i < nr_ioapics; i++) {
-		ioapic_saved_data[i] =
+		ioapics[i].saved_registers =
 			kzalloc(sizeof(struct IO_APIC_route_entry) *
 				ioapics[i].nr_registers, GFP_KERNEL);
-		if (!ioapic_saved_data[i])
+		if (!ioapics[i].saved_registers)
 			pr_err("IOAPIC %d: suspend/resume impossible!\n", i);
 	}
 
@@ -639,13 +638,13 @@ int save_ioapic_entries(void)
 	int err = 0;
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
-		if (!ioapic_saved_data[apic]) {
+		if (!ioapics[apic].saved_registers) {
 			err = -ENOMEM;
 			continue;
 		}
 
 		for (pin = 0; pin < ioapics[apic].nr_registers; pin++)
-			ioapic_saved_data[apic][pin] =
+			ioapics[apic].saved_registers[pin] =
 				ioapic_read_entry(apic, pin);
 	}
 
@@ -660,13 +659,13 @@ void mask_ioapic_entries(void)
 	int apic, pin;
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
-		if (!ioapic_saved_data[apic])
+		if (ioapics[apic].saved_registers)
 			continue;
 
 		for (pin = 0; pin < ioapics[apic].nr_registers; pin++) {
 			struct IO_APIC_route_entry entry;
 
-			entry = ioapic_saved_data[apic][pin];
+			entry = ioapics[apic].saved_registers[pin];
 			if (!entry.mask) {
 				entry.mask = 1;
 				ioapic_write_entry(apic, pin, entry);
@@ -676,19 +675,19 @@ void mask_ioapic_entries(void)
 }
 
 /*
- * Restore IO APIC entries which was saved in ioapic_saved_data
+ * Restore IO APIC entries which was saved in the ioapic structure.
  */
 int restore_ioapic_entries(void)
 {
 	int apic, pin;
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
-		if (!ioapic_saved_data[apic])
+		if (ioapics[apic].saved_registers)
 			continue;
 
 		for (pin = 0; pin < ioapics[apic].nr_registers; pin++)
 			ioapic_write_entry(apic, pin,
-					   ioapic_saved_data[apic][pin]);
+					   ioapics[apic].saved_registers[pin]);
 	}
 	return 0;
 }


