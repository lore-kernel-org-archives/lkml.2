Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622Ab2GKNss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:48:48 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:9861
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757675Ab2GKNjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:39:19 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M700LC-02-1P8-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 03/27] iommu/amd: Fix sparse warnings
Date: Wed, 11 Jul 2012 15:38:48 +0200
Message-ID: <1342013952-10174-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342013952-10174-1-git-send-email-joerg.roedel@amd.com>
References: <1342013952-10174-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few sparse warnings fire in drivers/iommu/amd_iommu_init.c.
Fix most of them with this patch. Also fix the sparse
warnings in drivers/iommu/irq_remapping.c while at it.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu.c       |    2 +-
 drivers/iommu/amd_iommu_init.c  |   16 +++++-----------
 drivers/iommu/amd_iommu_types.h |    8 +++++++-
 drivers/iommu/amd_iommu_v2.c    |    2 +-
 drivers/iommu/irq_remapping.c   |    5 +++++
 5 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index a2e418c..a0ccdcb 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2071,7 +2071,7 @@ out_err:
 /* FIXME: Move this to PCI code */
 #define PCI_PRI_TLP_OFF		(1 << 15)
 
-bool pci_pri_tlp_required(struct pci_dev *pdev)
+static bool pci_pri_tlp_required(struct pci_dev *pdev)
 {
 	u16 status;
 	int pos;
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 542024b..1b3f699 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -190,12 +190,6 @@ static u32 dev_table_size;	/* size of the device table */
 static u32 alias_table_size;	/* size of the alias table */
 static u32 rlookup_table_size;	/* size if the rlookup table */
 
-/*
- * This function flushes all internal caches of
- * the IOMMU used by this driver.
- */
-extern void iommu_flush_all_caches(struct amd_iommu *iommu);
-
 static int amd_iommu_enable_interrupts(void);
 
 static inline void update_last_devid(u16 devid)
@@ -358,7 +352,7 @@ static void iommu_disable(struct amd_iommu *iommu)
  * mapping and unmapping functions for the IOMMU MMIO space. Each AMD IOMMU in
  * the system has one.
  */
-static u8 * __init iommu_map_mmio_space(u64 address)
+static u8 __iomem * __init iommu_map_mmio_space(u64 address)
 {
 	if (!request_mem_region(address, MMIO_REGION_LENGTH, "amd_iommu")) {
 		pr_err("AMD-Vi: Can not reserve memory region %llx for mmio\n",
@@ -367,7 +361,7 @@ static u8 * __init iommu_map_mmio_space(u64 address)
 		return NULL;
 	}
 
-	return ioremap_nocache(address, MMIO_REGION_LENGTH);
+	return (u8 __iomem *)ioremap_nocache(address, MMIO_REGION_LENGTH);
 }
 
 static void __init iommu_unmap_mmio_space(struct amd_iommu *iommu)
@@ -1217,7 +1211,7 @@ static int __init init_exclusion_range(struct ivmd_header *m)
 /* called for unity map ACPI definition */
 static int __init init_unity_map_range(struct ivmd_header *m)
 {
-	struct unity_map_entry *e = 0;
+	struct unity_map_entry *e = NULL;
 	char *s;
 
 	e = kzalloc(sizeof(*e), GFP_KERNEL);
@@ -1727,8 +1721,8 @@ __setup("amd_iommu=", parse_amd_iommu_options);
 
 IOMMU_INIT_FINISH(amd_iommu_detect,
 		  gart_iommu_hole_init,
-		  0,
-		  0);
+		  NULL,
+		  NULL);
 
 bool amd_iommu_v2_supported(void)
 {
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index 2435555..594faaf 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -487,7 +487,7 @@ struct amd_iommu {
 	/* physical address of MMIO space */
 	u64 mmio_phys;
 	/* virtual address of MMIO space */
-	u8 *mmio_base;
+	u8 __iomem *mmio_base;
 
 	/* capabilities of that IOMMU read from ACPI */
 	u32 cap;
@@ -664,6 +664,12 @@ extern bool amd_iommu_force_isolation;
 /* Max levels of glxval supported */
 extern int amd_iommu_max_glx_val;
 
+/*
+ * This function flushes all internal caches of
+ * the IOMMU used by this driver.
+ */
+extern void iommu_flush_all_caches(struct amd_iommu *iommu);
+
 /* takes bus and device/function and returns the device id
  * FIXME: should that be in generic PCI code? */
 static inline u16 calc_devid(u8 bus, u8 devfn)
diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index 036fe9b..77c28b7 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -81,7 +81,7 @@ struct fault {
 	u16 flags;
 };
 
-struct device_state **state_table;
+static struct device_state **state_table;
 static spinlock_t state_lock;
 
 /* List and lock for all pasid_states */
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 40cda8e..9276996 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -1,6 +1,11 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
+#include <linux/cpumask.h>
 #include <linux/errno.h>
+#include <linux/msi.h>
+
+#include <asm/hw_irq.h>
+#include <asm/irq_remapping.h>
 
 #include "irq_remapping.h"
 
-- 
1.7.9.5


