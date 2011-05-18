Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558Ab1ERXcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 19:32:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:53061 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756181Ab1ERXb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 19:31:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,234,1304319600"; 
   d="scan'208";a="4284422"
Message-Id: <20110518233157.574469296@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Wed, 18 May 2011 16:31:33 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, daniel.blueman@gmail.com,
        suresh.b.siddha@intel.com
Subject: [patch 3/9] x86, ioapic: use ioapic_saved_data while enabling intr-remapping
References: <20110518233130.524634928@sbsiddha-MOBL3.sc.intel.com>
Content-Disposition: inline; filename=use_ioapic_saved_data_for_intremap.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code flow for enabling interrupt-remapping was allocating/freeing buffers
for saving/restoring io-apic RTE's. ioapic suspend/resume code uses boot
time allocated ioapic_saved_data that is a perfect match for reuse here.

This will remove the unnecessary allocation/free of the temporary buffers
during suspend/resume of interrupt-remapping enabled platforms aswell
as paving the way for further code consolidation.

Tested-by: Daniel J Blueman <daniel.blueman@gmail.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/io_apic.h |   20 +++-------
 arch/x86/kernel/apic/apic.c    |   48 ++++++------------------
 arch/x86/kernel/apic/io_apic.c |   80 +++++++++--------------------------------
 3 files changed, 37 insertions(+), 111 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
@@ -101,7 +101,7 @@ int mp_irq_entries;
 static int nr_irqs_gsi = NR_IRQS_LEGACY;
 
 /*
- * Saved I/O APIC state during suspend/resume.
+ * Saved I/O APIC state during suspend/resume, or while enabling intr-remap.
 */
 static struct IO_APIC_route_entry *ioapic_saved_data[MAX_IO_APICS];
 
@@ -628,74 +628,43 @@ static int __init ioapic_pirq_setup(char
 __setup("pirq=", ioapic_pirq_setup);
 #endif /* CONFIG_X86_32 */
 
-struct IO_APIC_route_entry **alloc_ioapic_entries(void)
-{
-	int apic;
-	struct IO_APIC_route_entry **ioapic_entries;
-
-	ioapic_entries = kzalloc(sizeof(*ioapic_entries) * nr_ioapics,
-				GFP_ATOMIC);
-	if (!ioapic_entries)
-		return 0;
-
-	for (apic = 0; apic < nr_ioapics; apic++) {
-		ioapic_entries[apic] =
-			kzalloc(sizeof(struct IO_APIC_route_entry) *
-				nr_ioapic_registers[apic], GFP_ATOMIC);
-		if (!ioapic_entries[apic])
-			goto nomem;
-	}
-
-	return ioapic_entries;
-
-nomem:
-	while (--apic >= 0)
-		kfree(ioapic_entries[apic]);
-	kfree(ioapic_entries);
-
-	return 0;
-}
-
 /*
  * Saves all the IO-APIC RTE's
  */
-int save_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries)
+int save_ioapic_entries(void)
 {
 	int apic, pin;
-
-	if (!ioapic_entries)
-		return -ENOMEM;
+	int err = 0;
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
-		if (!ioapic_entries[apic])
-			return -ENOMEM;
+		if (!ioapic_saved_data[apic]) {
+			err = -ENOMEM;
+			continue;
+		}
 
 		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++)
-			ioapic_entries[apic][pin] =
+			ioapic_saved_data[apic][pin] =
 				ioapic_read_entry(apic, pin);
 	}
 
-	return 0;
+	return err;
 }
 
 /*
  * Mask all IO APIC entries.
  */
-void mask_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries)
+void mask_ioapic_entries(void)
 {
 	int apic, pin;
 
-	if (!ioapic_entries)
-		return;
-
 	for (apic = 0; apic < nr_ioapics; apic++) {
-		if (!ioapic_entries[apic])
-			break;
+		if (!ioapic_saved_data[apic])
+			continue;
 
 		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
 			struct IO_APIC_route_entry entry;
 
-			entry = ioapic_entries[apic][pin];
+			entry = ioapic_saved_data[apic][pin];
 			if (!entry.mask) {
 				entry.mask = 1;
 				ioapic_write_entry(apic, pin, entry);
@@ -705,36 +674,23 @@ void mask_IO_APIC_setup(struct IO_APIC_r
 }
 
 /*
- * Restore IO APIC entries which was saved in ioapic_entries.
+ * Restore IO APIC entries which was saved in ioapic_saved_data
  */
-int restore_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries)
+int restore_ioapic_entries(void)
 {
 	int apic, pin;
 
-	if (!ioapic_entries)
-		return -ENOMEM;
-
 	for (apic = 0; apic < nr_ioapics; apic++) {
-		if (!ioapic_entries[apic])
-			return -ENOMEM;
+		if (!ioapic_saved_data[apic])
+			continue;
 
 		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++)
 			ioapic_write_entry(apic, pin,
-					ioapic_entries[apic][pin]);
+					   ioapic_saved_data[apic][pin]);
 	}
 	return 0;
 }
 
-void free_ioapic_entries(struct IO_APIC_route_entry **ioapic_entries)
-{
-	int apic;
-
-	for (apic = 0; apic < nr_ioapics; apic++)
-		kfree(ioapic_entries[apic]);
-
-	kfree(ioapic_entries);
-}
-
 /*
  * Find the IRQ entry number of a certain pin.
  */
Index: linux-2.6-tip/arch/x86/include/asm/io_apic.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/io_apic.h
+++ linux-2.6-tip/arch/x86/include/asm/io_apic.h
@@ -152,11 +152,9 @@ extern void ioapic_insert_resources(void
 
 int io_apic_setup_irq_pin_once(unsigned int irq, int node, struct io_apic_irq_attr *attr);
 
-extern struct IO_APIC_route_entry **alloc_ioapic_entries(void);
-extern void free_ioapic_entries(struct IO_APIC_route_entry **ioapic_entries);
-extern int save_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
-extern void mask_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
-extern int restore_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
+extern int save_ioapic_entries(void);
+extern void mask_ioapic_entries(void);
+extern int restore_ioapic_entries(void);
 
 extern int get_nr_irqs_gsi(void);
 
@@ -192,19 +190,13 @@ struct io_apic_irq_attr;
 static inline int io_apic_set_pci_routing(struct device *dev, int irq,
 		 struct io_apic_irq_attr *irq_attr) { return 0; }
 
-static inline struct IO_APIC_route_entry **alloc_ioapic_entries(void)
-{
-	return NULL;
-}
-
-static inline void free_ioapic_entries(struct IO_APIC_route_entry **ent) { }
-static inline int save_IO_APIC_setup(struct IO_APIC_route_entry **ent)
+static inline int save_ioapic_entries(void)
 {
 	return -ENOMEM;
 }
 
-static inline void mask_IO_APIC_setup(struct IO_APIC_route_entry **ent) { }
-static inline int restore_IO_APIC_setup(struct IO_APIC_route_entry **ent)
+static inline void mask_ioapic_entries(void) { }
+static inline int restore_ioapic_entries(void)
 {
 	return -ENOMEM;
 }
Index: linux-2.6-tip/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/apic.c
@@ -1461,7 +1461,6 @@ int __init enable_IR(void)
 void __init enable_IR_x2apic(void)
 {
 	unsigned long flags;
-	struct IO_APIC_route_entry **ioapic_entries;
 	int ret, x2apic_enabled = 0;
 	int dmar_table_init_ret;
 
@@ -1469,13 +1468,7 @@ void __init enable_IR_x2apic(void)
 	if (dmar_table_init_ret && !x2apic_supported())
 		return;
 
-	ioapic_entries = alloc_ioapic_entries();
-	if (!ioapic_entries) {
-		pr_err("Allocate ioapic_entries failed\n");
-		goto out;
-	}
-
-	ret = save_IO_APIC_setup(ioapic_entries);
+	ret = save_ioapic_entries();
 	if (ret) {
 		pr_info("Saving IO-APIC state failed: %d\n", ret);
 		goto out;
@@ -1483,7 +1476,7 @@ void __init enable_IR_x2apic(void)
 
 	local_irq_save(flags);
 	legacy_pic->mask_all();
-	mask_IO_APIC_setup(ioapic_entries);
+	mask_ioapic_entries();
 
 	if (dmar_table_init_ret)
 		ret = 0;
@@ -1514,14 +1507,11 @@ void __init enable_IR_x2apic(void)
 
 nox2apic:
 	if (!ret) /* IR enabling failed */
-		restore_IO_APIC_setup(ioapic_entries);
+		restore_ioapic_entries();
 	legacy_pic->restore_mask();
 	local_irq_restore(flags);
 
 out:
-	if (ioapic_entries)
-		free_ioapic_entries(ioapic_entries);
-
 	if (x2apic_enabled)
 		return;
 
@@ -2095,28 +2085,20 @@ static void lapic_resume(void)
 {
 	unsigned int l, h;
 	unsigned long flags;
-	int maxlvt, ret;
-	struct IO_APIC_route_entry **ioapic_entries = NULL;
+	int maxlvt;
 
 	if (!apic_pm_state.active)
 		return;
 
 	local_irq_save(flags);
 	if (intr_remapping_enabled) {
-		ioapic_entries = alloc_ioapic_entries();
-		if (!ioapic_entries) {
-			WARN(1, "Alloc ioapic_entries in lapic resume failed.");
-			goto restore;
-		}
-
-		ret = save_IO_APIC_setup(ioapic_entries);
-		if (ret) {
-			WARN(1, "Saving IO-APIC state failed: %d\n", ret);
-			free_ioapic_entries(ioapic_entries);
-			goto restore;
-		}
-
-		mask_IO_APIC_setup(ioapic_entries);
+		/*
+		 * IO-APIC and PIC have their own resume routines.
+		 * We just mask them here to make sure the interrupt
+		 * subsystem is completely quiet while we enable x2apic
+		 * and interrupt-remapping.
+		 */
+		mask_ioapic_entries();
 		legacy_pic->mask_all();
 	}
 
@@ -2159,13 +2141,9 @@ static void lapic_resume(void)
 	apic_write(APIC_ESR, 0);
 	apic_read(APIC_ESR);
 
-	if (intr_remapping_enabled) {
+	if (intr_remapping_enabled)
 		reenable_intr_remapping(x2apic_mode);
-		legacy_pic->restore_mask();
-		restore_IO_APIC_setup(ioapic_entries);
-		free_ioapic_entries(ioapic_entries);
-	}
-restore:
+
 	local_irq_restore(flags);
 }
 


