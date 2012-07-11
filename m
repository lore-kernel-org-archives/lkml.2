Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653Ab2GKNrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:47:52 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:30265
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757715Ab2GKNjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:39:20 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M700LD-02-1PB-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 14/27] iommu/amd: Allocate data structures to keep track of irq remapping tables
Date: Wed, 11 Jul 2012 15:38:59 +0200
Message-ID: <1342013952-10174-15-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342013952-10174-1-git-send-email-joerg.roedel@amd.com>
References: <1342013952-10174-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To easily map device ids to interrupt remapping table
entries a new lookup table is necessary.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_init.c  |   16 ++++++++++++++++
 drivers/iommu/amd_iommu_types.h |    9 +++++++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 49e72b9..473a51d 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -181,6 +181,12 @@ u16 *amd_iommu_alias_table;
 struct amd_iommu **amd_iommu_rlookup_table;
 
 /*
+ * This table is used to find the irq remapping table for a given device id
+ * quickly.
+ */
+struct irq_remap_table **irq_lookup_table;
+
+/*
  * AMD IOMMU allows up to 2^16 differend protection domains. This is a bitmap
  * to know which ones are already in use.
  */
@@ -1532,9 +1538,13 @@ static struct syscore_ops amd_iommu_syscore_ops = {
 
 static void __init free_on_init_error(void)
 {
+	free_pages((unsigned long)irq_lookup_table,
+		   get_order(rlookup_table_size));
+
 	if (amd_iommu_irq_cache) {
 		kmem_cache_destroy(amd_iommu_irq_cache);
 		amd_iommu_irq_cache = NULL;
+
 	}
 
 	amd_iommu_uninit_devices();
@@ -1687,6 +1697,12 @@ static int __init early_amd_iommu_init(void)
 				0, NULL);
 		if (!amd_iommu_irq_cache)
 			goto out;
+
+		irq_lookup_table = (void *)__get_free_pages(
+				GFP_KERNEL | __GFP_ZERO,
+				get_order(rlookup_table_size));
+		if (!irq_lookup_table)
+			goto out;
 	}
 
 	ret = init_memory_definitions(ivrs_base);
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index 0e15e78..ceaa499 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -175,6 +175,7 @@
 #define DEV_ENTRY_EX            0x67
 #define DEV_ENTRY_SYSMGT1       0x68
 #define DEV_ENTRY_SYSMGT2       0x69
+#define DEV_ENTRY_IRQ_TBL_EN	0x80
 #define DEV_ENTRY_INIT_PASS     0xb8
 #define DEV_ENTRY_EINT_PASS     0xb9
 #define DEV_ENTRY_NMI_PASS      0xba
@@ -337,6 +338,14 @@ extern bool amd_iommu_iotlb_sup;
 #define MAX_IRQS_PER_TABLE	256
 #define IRQ_TABLE_ALIGNMENT	128
 
+struct irq_remap_table {
+	spinlock_t lock;
+	unsigned min_index;
+	u32 *table;
+};
+
+extern struct irq_remap_table **irq_lookup_table;
+
 /* Interrupt remapping feature used? */
 extern bool amd_iommu_irq_remap;
 
-- 
1.7.9.5


