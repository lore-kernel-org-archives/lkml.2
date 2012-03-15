Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032147Ab2CORmt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:42:49 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:27136
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032042Ab2CORkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:40:06 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M0XT2O-01-13Z-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/9] iommu/vt-d: Convert missing apic.c intr-remapping call to remap_ops
Date: Thu, 15 Mar 2012 18:39:46 +0100
Message-ID: <1331833191-25779-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1331833191-25779-1-git-send-email-joerg.roedel@amd.com>
References: <1331833191-25779-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert these calls too:

	* Disable of remapping hardware
	* Reenable of remapping hardware
	* Enable fault handling

With that all of arch/x86/kernel/apic/apic.c is converted to
use the generic intr-remapping interface.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/intr_remapping.h |    6 ++++++
 arch/x86/kernel/apic/apic.c           |    6 +++---
 drivers/iommu/intel_intr_remapping.c  |    7 +++++--
 drivers/iommu/intr_remapping.c        |   24 ++++++++++++++++++++++++
 drivers/iommu/intr_remapping.h        |    9 +++++++++
 include/linux/dmar.h                  |   18 ------------------
 6 files changed, 47 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/intr_remapping.h b/arch/x86/include/asm/intr_remapping.h
index 207c605..55aa892 100644
--- a/arch/x86/include/asm/intr_remapping.h
+++ b/arch/x86/include/asm/intr_remapping.h
@@ -30,6 +30,9 @@ extern void setup_intr_remapping(void);
 extern int intr_remapping_supported(void);
 extern int intr_hardware_init(void);
 extern int intr_hardware_enable(void);
+extern void intr_hardware_disable(void);
+extern int intr_hardware_reenable(int);
+extern int intr_enable_fault_handling(void);
 
 #else  /* CONFIG_IRQ_REMAP */
 
@@ -39,6 +42,9 @@ static inline void setup_intr_remapping(void) { }
 static inline int intr_remapping_supported(void) { return 0; }
 static inline int intr_hardware_init(void) { return -ENODEV; }
 static inline int intr_hardware_enable(void) { return -ENODEV; }
+static inline void intr_hardware_disable(void) { }
+static inline int intr_hardware_reenable(int eim) { return -ENODEV; }
+static inline int intr_enable_fault_handling(void) { return -ENODEV; }
 
 #endif /* CONFIG_IRQ_REMAP */
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 578a452..d7863cc 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1438,7 +1438,7 @@ void __init bsp_end_local_APIC_setup(void)
 	 * handling for interrupt remapping.
 	 */
 	if (intr_remapping_enabled)
-		enable_drhd_fault_handling();
+		intr_enable_fault_handling();
 
 }
 
@@ -2172,7 +2172,7 @@ static int lapic_suspend(void)
 	disable_local_APIC();
 
 	if (intr_remapping_enabled)
-		disable_intr_remapping();
+		intr_hardware_disable();
 
 	local_irq_restore(flags);
 	return 0;
@@ -2239,7 +2239,7 @@ static void lapic_resume(void)
 	apic_read(APIC_ESR);
 
 	if (intr_remapping_enabled)
-		reenable_intr_remapping(x2apic_mode);
+		intr_hardware_reenable(x2apic_mode);
 
 	local_irq_restore(flags);
 }
diff --git a/drivers/iommu/intel_intr_remapping.c b/drivers/iommu/intel_intr_remapping.c
index 9c742fb..610b75b 100644
--- a/drivers/iommu/intel_intr_remapping.c
+++ b/drivers/iommu/intel_intr_remapping.c
@@ -764,7 +764,7 @@ int __init ir_dev_scope_init(void)
 }
 rootfs_initcall(ir_dev_scope_init);
 
-void disable_intr_remapping(void)
+static void disable_intr_remapping(void)
 {
 	struct dmar_drhd_unit *drhd;
 	struct intel_iommu *iommu = NULL;
@@ -780,7 +780,7 @@ void disable_intr_remapping(void)
 	}
 }
 
-int reenable_intr_remapping(int eim)
+static int reenable_intr_remapping(int eim)
 {
 	struct dmar_drhd_unit *drhd;
 	int setup = 0;
@@ -818,4 +818,7 @@ struct irq_remap_ops intel_irq_remap_ops = {
 	.supported		= intel_intr_remapping_supported,
 	.hardware_init		= dmar_table_init,
 	.hardware_enable	= intel_enable_intr_remapping,
+	.hardware_disable	= disable_intr_remapping,
+	.hardware_reenable	= reenable_intr_remapping,
+	.enable_faulting	= enable_drhd_fault_handling,
 };
diff --git a/drivers/iommu/intr_remapping.c b/drivers/iommu/intr_remapping.c
index 670c69a..9aabed7 100644
--- a/drivers/iommu/intr_remapping.c
+++ b/drivers/iommu/intr_remapping.c
@@ -74,3 +74,27 @@ int __init intr_hardware_enable(void)
 
 	return remap_ops->hardware_enable();
 }
+
+void intr_hardware_disable(void)
+{
+	if (!remap_ops || !remap_ops->hardware_disable)
+		return;
+
+	remap_ops->hardware_disable();
+}
+
+int intr_hardware_reenable(int mode)
+{
+	if (!remap_ops || !remap_ops->hardware_reenable)
+		return 0;
+
+	return remap_ops->hardware_reenable(mode);
+}
+
+int __init intr_enable_fault_handling(void)
+{
+	if (!remap_ops || !remap_ops->enable_faulting)
+		return -ENODEV;
+
+	return remap_ops->enable_faulting();
+}
diff --git a/drivers/iommu/intr_remapping.h b/drivers/iommu/intr_remapping.h
index d6df732..2744c9a 100644
--- a/drivers/iommu/intr_remapping.h
+++ b/drivers/iommu/intr_remapping.h
@@ -37,6 +37,15 @@ struct irq_remap_ops {
 
 	/* Enables the remapping hardware */
 	int  (*hardware_enable)(void);
+
+	/* Disables the remapping hardware */
+	void (*hardware_disable)(void);
+
+	/* Reenables the remapping hardware */
+	int  (*hardware_reenable)(int);
+
+	/* Enable fault handling */
+	int  (*enable_faulting)(void);
 };
 
 extern struct irq_remap_ops intel_irq_remap_ops;
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 6d66c9c..f2bd87f 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -115,9 +115,6 @@ struct irte {
 };
 
 #ifdef CONFIG_IRQ_REMAP
-extern void disable_intr_remapping(void);
-extern int reenable_intr_remapping(int);
-
 extern int get_irte(int irq, struct irte *entry);
 extern int modify_irte(int irq, struct irte *irte_modified);
 extern int alloc_irte(struct intel_iommu *iommu, int irq, u16 count);
@@ -179,21 +176,6 @@ static inline int set_msi_sid(struct irte *irte, struct pci_dev *dev)
 	return 0;
 }
 
-#define intr_remapping_enabled		(0)
-
-static inline int enable_intr_remapping(void)
-{
-	return -1;
-}
-
-static inline void disable_intr_remapping(void)
-{
-}
-
-static inline int reenable_intr_remapping(int eim)
-{
-	return 0;
-}
 #endif
 
 enum {
-- 
1.7.5.4


