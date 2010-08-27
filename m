Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab0H0SNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 14:13:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:13061 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab0H0SNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 14:13:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,279,1280732400"; 
   d="scan'208";a="651965064"
Message-Id: <20100827181049.095067319@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Fri, 27 Aug 2010 11:09:49 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 2/3] x86, intr-remap: remove IRTE setup duplicate code
References: <20100827181049.013051492@sbsiddha-MOBL3.sc.intel.com>
Content-Disposition: inline; filename=cleanup_irte_setup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove IRTE setup duplicate code with prepare_irte()

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/irq_remapping.h |   27 +++++++++++++++++++++++++++
 arch/x86/kernel/apic/io_apic.c       |   27 ++-------------------------
 2 files changed, 29 insertions(+), 25 deletions(-)

Index: tree/arch/x86/kernel/apic/io_apic.c
===================================================================
--- tree.orig/arch/x86/kernel/apic/io_apic.c
+++ tree/arch/x86/kernel/apic/io_apic.c
@@ -1377,22 +1377,7 @@ int setup_ioapic_entry(int apic_id, int 
 		if (index < 0)
 			panic("Failed to allocate IRTE for ioapic %d\n", apic_id);
 
-		memset(&irte, 0, sizeof(irte));
-
-		irte.present = 1;
-		irte.dst_mode = apic->irq_dest_mode;
-		/*
-		 * Trigger mode in the IRTE will always be edge, and the
-		 * actual level or edge trigger will be setup in the IO-APIC
-		 * RTE. This will help simplify level triggered irq migration.
-		 * For more details, see the comments above explainig IO-APIC
-		 * irq migration in the presence of interrupt-remapping.
-		 */
-		irte.trigger_mode = 0;
-		irte.dlvry_mode = apic->irq_delivery_mode;
-		irte.vector = vector;
-		irte.dest_id = IRTE_DEST(destination);
-		irte.redir_hint = 1;
+		prepare_irte(&irte, vector, destination);
 
 		/* Set source-id of interrupt request */
 		set_ioapic_sid(&irte, apic_id);
@@ -3336,15 +3321,7 @@ static int msi_compose_msg(struct pci_de
 		ir_index = map_irq_to_irte_handle(irq, &sub_handle);
 		BUG_ON(ir_index == -1);
 
-		memset (&irte, 0, sizeof(irte));
-
-		irte.present = 1;
-		irte.dst_mode = apic->irq_dest_mode;
-		irte.trigger_mode = 0; /* edge */
-		irte.dlvry_mode = apic->irq_delivery_mode;
-		irte.vector = cfg->vector;
-		irte.dest_id = IRTE_DEST(dest);
-		irte.redir_hint = 1;
+		prepare_irte(&irte, cfg->vector, dest);
 
 		/* Set source-id of interrupt request */
 		if (pdev)
Index: tree/arch/x86/include/asm/irq_remapping.h
===================================================================
--- tree.orig/arch/x86/include/asm/irq_remapping.h
+++ tree/arch/x86/include/asm/irq_remapping.h
@@ -3,4 +3,31 @@
 
 #define IRTE_DEST(dest) ((x2apic_mode) ? dest : dest << 8)
 
+#ifdef CONFIG_INTR_REMAP
+static inline void prepare_irte(struct irte *irte, int vector,
+			        unsigned int dest)
+{
+	memset(irte, 0, sizeof(*irte));
+
+	irte->present = 1;
+	irte->dst_mode = apic->irq_dest_mode;
+	/*
+	 * Trigger mode in the IRTE will always be edge, and for IO-APIC, the
+	 * actual level or edge trigger will be setup in the IO-APIC
+	 * RTE. This will help simplify level triggered irq migration.
+	 * For more details, see the comments (in io_apic.c) explainig IO-APIC
+	 * irq migration in the presence of interrupt-remapping.
+	*/
+	irte->trigger_mode = 0;
+	irte->dlvry_mode = apic->irq_delivery_mode;
+	irte->vector = vector;
+	irte->dest_id = IRTE_DEST(dest);
+	irte->redir_hint = 1;
+}
+#else
+static void prepare_irte(struct irte *irte, int vector, unsigned int dest)
+{
+}
+#endif
+
 #endif	/* _ASM_X86_IRQ_REMAPPING_H */


