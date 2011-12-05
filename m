Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402Ab1LENfO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:35:14 -0500
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:55601
	"EHLO VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932310Ab1LENfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:35:06 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LVQGEB-02-AUD-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 06/22] iommu/amd: Add iommuv2 flag to struct amd_iommu
Date: Mon, 5 Dec 2011 14:34:21 +0100
Message-ID: <1323092077-25501-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
References: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In mixed IOMMU setups this flag inidicates whether an IOMMU
supports the v2 features or not. This patch also adds a
global flag together with a function to query that flag from
other code. The flag shows if at least one IOMMUv2 is in the
system.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_init.c  |   15 +++++++++++++++
 drivers/iommu/amd_iommu_proto.h |    3 +++
 drivers/iommu/amd_iommu_types.h |    5 +++++
 3 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 2c25ae3..d1e5067 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -25,6 +25,7 @@
 #include <linux/interrupt.h>
 #include <linux/msi.h>
 #include <linux/amd-iommu.h>
+#include <linux/export.h>
 #include <asm/pci-direct.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
@@ -143,6 +144,8 @@ bool amd_iommu_iotlb_sup __read_mostly = true;
 
 u32 amd_iommu_max_pasids __read_mostly = ~0;
 
+bool amd_iommu_v2_present __read_mostly;
+
 /*
  * The ACPI table parsing functions set this variable on an error
  */
@@ -760,6 +763,12 @@ static void __init init_iommu_from_pci(struct amd_iommu *iommu)
 		amd_iommu_max_pasids = min(amd_iommu_max_pasids, pasids);
 	}
 
+	if (iommu_feature(iommu, FEATURE_GT) &&
+	    iommu_feature(iommu, FEATURE_PPR)) {
+		iommu->is_iommu_v2   = true;
+		amd_iommu_v2_present = true;
+	}
+
 	if (!is_rd890_iommu(iommu->dev))
 		return;
 
@@ -1645,3 +1654,9 @@ IOMMU_INIT_FINISH(amd_iommu_detect,
 		  gart_iommu_hole_init,
 		  0,
 		  0);
+
+bool amd_iommu_v2_supported(void)
+{
+	return amd_iommu_v2_present;
+}
+EXPORT_SYMBOL(amd_iommu_v2_supported);
diff --git a/drivers/iommu/amd_iommu_proto.h b/drivers/iommu/amd_iommu_proto.h
index 7ffaa64..3a46c30 100644
--- a/drivers/iommu/amd_iommu_proto.h
+++ b/drivers/iommu/amd_iommu_proto.h
@@ -31,6 +31,9 @@ extern int amd_iommu_init_devices(void);
 extern void amd_iommu_uninit_devices(void);
 extern void amd_iommu_init_notifier(void);
 extern void amd_iommu_init_api(void);
+
+extern bool amd_iommu_v2_supported(void);
+
 #ifndef CONFIG_AMD_IOMMU_STATS
 
 static inline void amd_iommu_stats_init(void) { }
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index c26a16d..535cd07 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -415,6 +415,9 @@ struct amd_iommu {
 	/* Extended features */
 	u64 features;
 
+	/* IOMMUv2 */
+	bool is_iommu_v2;
+
 	/*
 	 * Capability pointer. There could be more than one IOMMU per PCI
 	 * device function if there are more than one AMD IOMMU capability
@@ -571,6 +574,8 @@ extern bool amd_iommu_unmap_flush;
 /* Smallest number of PASIDs supported by any IOMMU in the system */
 extern u32 amd_iommu_max_pasids;
 
+extern bool amd_iommu_v2_present;
+
 /* takes bus and device/function and returns the device id
  * FIXME: should that be in generic PCI code? */
 static inline u16 calc_devid(u8 bus, u8 devfn)
-- 
1.7.5.4


