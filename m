Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842Ab2GKNj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:39:57 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:42584
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757796Ab2GKNje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:39:34 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M700LG-02-1PG-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 13/27] iommu/amd: Add slab-cache for irq remapping tables
Date: Wed, 11 Jul 2012 15:38:58 +0200
Message-ID: <1342013952-10174-14-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342013952-10174-1-git-send-email-joerg.roedel@amd.com>
References: <1342013952-10174-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The irq remapping tables for the AMD IOMMU need to be
aligned on a 128 byte boundary. Create a seperate slab-cache
to guarantee this alignment.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu.c       |    2 ++
 drivers/iommu/amd_iommu_init.c  |   23 +++++++++++++++++++++++
 drivers/iommu/amd_iommu_types.h |    9 +++++++++
 drivers/iommu/irq_remapping.h   |    4 ++++
 4 files changed, 38 insertions(+)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 2e98cf3..b02db09 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -93,6 +93,8 @@ struct iommu_cmd {
 	u32 data[4];
 };
 
+struct kmem_cache *amd_iommu_irq_cache;
+
 static void update_domain(struct protection_domain *domain);
 static int __init alloc_passthrough_domain(void);
 
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 5789525..49e72b9 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -36,6 +36,7 @@
 
 #include "amd_iommu_proto.h"
 #include "amd_iommu_types.h"
+#include "irq_remapping.h"
 
 /*
  * definitions for the ACPI scanning code
@@ -124,6 +125,7 @@ struct ivmd_header {
 } __attribute__((packed));
 
 bool amd_iommu_dump;
+bool amd_iommu_irq_remap __read_mostly;
 
 static bool amd_iommu_detected;
 static bool __initdata amd_iommu_disabled;
@@ -1530,6 +1532,11 @@ static struct syscore_ops amd_iommu_syscore_ops = {
 
 static void __init free_on_init_error(void)
 {
+	if (amd_iommu_irq_cache) {
+		kmem_cache_destroy(amd_iommu_irq_cache);
+		amd_iommu_irq_cache = NULL;
+	}
+
 	amd_iommu_uninit_devices();
 
 	free_pages((unsigned long)amd_iommu_pd_alloc_bitmap,
@@ -1669,6 +1676,19 @@ static int __init early_amd_iommu_init(void)
 	if (ret)
 		goto out;
 
+	if (amd_iommu_irq_remap) {
+		/*
+		 * Interrupt remapping enabled, create kmem_cache for the
+		 * remapping tables.
+		 */
+		amd_iommu_irq_cache = kmem_cache_create("irq_remap_cache",
+				MAX_IRQS_PER_TABLE * sizeof(u32),
+				IRQ_TABLE_ALIGNMENT,
+				0, NULL);
+		if (!amd_iommu_irq_cache)
+			goto out;
+	}
+
 	ret = init_memory_definitions(ivrs_base);
 	if (ret)
 		goto out;
@@ -1713,6 +1733,9 @@ static bool detect_ivrs(void)
 
 	early_acpi_os_unmap_memory((char __iomem *)ivrs_base, ivrs_size);
 
+	if (!disable_irq_remap)
+		amd_iommu_irq_remap = true;
+
 	return true;
 }
 
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index 7795b71..0e15e78 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -334,6 +334,15 @@ extern bool amd_iommu_np_cache;
 /* Only true if all IOMMUs support device IOTLBs */
 extern bool amd_iommu_iotlb_sup;
 
+#define MAX_IRQS_PER_TABLE	256
+#define IRQ_TABLE_ALIGNMENT	128
+
+/* Interrupt remapping feature used? */
+extern bool amd_iommu_irq_remap;
+
+/* kmem_cache to get tables with 128 byte alignement */
+extern struct kmem_cache *amd_iommu_irq_cache;
+
 /*
  * Make iterating over all IOMMUs easier
  */
diff --git a/drivers/iommu/irq_remapping.h b/drivers/iommu/irq_remapping.h
index be9d729..b3f70c9 100644
--- a/drivers/iommu/irq_remapping.h
+++ b/drivers/iommu/irq_remapping.h
@@ -85,6 +85,10 @@ struct irq_remap_ops {
 
 extern struct irq_remap_ops intel_irq_remap_ops;
 
+#else  /* CONFIG_IRQ_REMAP */
+
+#define disable_irq_remap	1
+
 #endif /* CONFIG_IRQ_REMAP */
 
 #endif /* __IRQ_REMAPPING_H */
-- 
1.7.9.5


