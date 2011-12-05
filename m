Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481Ab1LENgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:36:14 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:39714
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932250Ab1LENgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:36:11 -0500
X-SpamScore: 2
X-BigFish: VPS2(z616jzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LVQGEA-01-IPH-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 03/22] iommu/amd: Get the maximum number of PASIDs supported
Date: Mon, 5 Dec 2011 14:34:18 +0100
Message-ID: <1323092077-25501-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
References: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Read the number of PASIDs supported by each IOMMU in the
system and take the smallest number as the maximum value
supported by the IOMMU driver.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_init.c  |   13 +++++++++++++
 drivers/iommu/amd_iommu_types.h |    6 ++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 17e0f77..fb4afd6 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -141,6 +141,8 @@ int amd_iommus_present;
 bool amd_iommu_np_cache __read_mostly;
 bool amd_iommu_iotlb_sup __read_mostly = true;
 
+u32 amd_iommu_max_pasids __read_mostly = ~0;
+
 /*
  * The ACPI table parsing functions set this variable on an error
  */
@@ -699,6 +701,17 @@ static void __init init_iommu_from_pci(struct amd_iommu *iommu)
 
 	iommu->features = ((u64)high << 32) | low;
 
+	if (iommu_feature(iommu, FEATURE_GT)) {
+		u32 pasids;
+		u64 shift;
+
+		shift   = iommu->features & FEATURE_PASID_MASK;
+		shift >>= FEATURE_PASID_SHIFT;
+		pasids  = (1 << shift);
+
+		amd_iommu_max_pasids = min(amd_iommu_max_pasids, pasids);
+	}
+
 	if (!is_rd890_iommu(iommu->dev))
 		return;
 
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index a8a994b..0a62685 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -87,6 +87,9 @@
 #define FEATURE_HE		(1ULL<<8)
 #define FEATURE_PC		(1ULL<<9)
 
+#define FEATURE_PASID_SHIFT	32
+#define FEATURE_PASID_MASK	(0x1fULL << FEATURE_PASID_SHIFT)
+
 /* MMIO status bits */
 #define MMIO_STATUS_COM_WAIT_INT_MASK	0x04
 
@@ -550,6 +553,9 @@ extern unsigned long *amd_iommu_pd_alloc_bitmap;
  */
 extern bool amd_iommu_unmap_flush;
 
+/* Smallest number of PASIDs supported by any IOMMU in the system */
+extern u32 amd_iommu_max_pasids;
+
 /* takes bus and device/function and returns the device id
  * FIXME: should that be in generic PCI code? */
 static inline u16 calc_devid(u8 bus, u8 devfn)
-- 
1.7.5.4


