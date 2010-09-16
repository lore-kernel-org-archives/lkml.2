Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab0IPAw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 20:52:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:43032 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281Ab0IPAw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 20:52:57 -0400
Date: Thu, 16 Sep 2010 00:52:33 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20100827181049.095067319@sbsiddha-MOBL3.sc.intel.com>
References: <20100827181049.095067319@sbsiddha-MOBL3.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/x2apic] x86, intr-remap: Remove IRTE setup duplicate code
Message-ID: <tip-62a92f4c69cd1d9361ad8c16be1dd16e6821bc15@git.kernel.org>
Git-Commit-ID: 62a92f4c69cd1d9361ad8c16be1dd16e6821bc15
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Sep 2010 00:52:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  62a92f4c69cd1d9361ad8c16be1dd16e6821bc15
Gitweb:     http://git.kernel.org/tip/62a92f4c69cd1d9361ad8c16be1dd16e6821bc15
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Fri, 27 Aug 2010 11:09:49 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 15 Sep 2010 17:36:45 -0700

x86, intr-remap: Remove IRTE setup duplicate code

Remove IRTE setup duplicate code with prepare_irte().

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20100827181049.095067319@sbsiddha-MOBL3.sc.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/irq_remapping.h |   27 +++++++++++++++++++++++++++
 arch/x86/kernel/apic/io_apic.c       |   27 ++-------------------------
 2 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index f275e22..8d84150 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
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
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 90f8a75..e8c95a2 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1377,22 +1377,7 @@ int setup_ioapic_entry(int apic_id, int irq,
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
@@ -3336,15 +3321,7 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
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
