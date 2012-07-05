Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631Ab2GEMhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:37:17 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:21845
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932581Ab2GEMhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:37:08 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M6OTPM-02-6NU-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 25/28] iommu/amd: Make sure irq remapping still works on dma init failure
Date: Thu, 5 Jul 2012 14:36:45 +0200
Message-ID: <1341491808-23083-26-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
References: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not deinitialize the AMD IOMMU driver completly when
interrupt remapping is already in use but the initialization
of the DMA layer fails for some reason. Make sure the IOMMU
can still be used to remap interrupts.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_init.c |   40 +++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 204dfea..1bfeef5 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1401,6 +1401,16 @@ static void init_device_table_dma(void)
 	}
 }
 
+static void __init uninit_device_table_dma(void)
+{
+	u32 devid;
+
+	for (devid = 0; devid <= amd_iommu_last_bdf; ++devid) {
+		amd_iommu_dev_table[devid].data[0] = 0ULL;
+		amd_iommu_dev_table[devid].data[1] = 0ULL;
+	}
+}
+
 static void init_device_table(void)
 {
 	u32 devid;
@@ -1569,11 +1579,6 @@ static void __init free_on_init_error(void)
 
 	}
 
-	amd_iommu_uninit_devices();
-
-	free_pages((unsigned long)amd_iommu_pd_alloc_bitmap,
-		   get_order(MAX_DOMAIN_ID/8));
-
 	free_pages((unsigned long)amd_iommu_rlookup_table,
 		   get_order(rlookup_table_size));
 
@@ -1585,8 +1590,6 @@ static void __init free_on_init_error(void)
 
 	free_iommu_all();
 
-	free_unity_maps();
-
 #ifdef CONFIG_GART_IOMMU
 	/*
 	 * We failed to initialize the AMD IOMMU - try fallback to GART
@@ -1614,6 +1617,16 @@ static bool __init check_ioapic_information(void)
 	return true;
 }
 
+static void __init free_dma_resources(void)
+{
+	amd_iommu_uninit_devices();
+
+	free_pages((unsigned long)amd_iommu_pd_alloc_bitmap,
+		   get_order(MAX_DOMAIN_ID/8));
+
+	free_unity_maps();
+}
+
 /*
  * This is the hardware init function for AMD IOMMU in the system.
  * This function is called either from amd_iommu_init or from the interrupt
@@ -1951,8 +1964,17 @@ static int __init amd_iommu_init(void)
 
 	ret = iommu_go_to_state(IOMMU_INITIALIZED);
 	if (ret) {
-		disable_iommus();
-		free_on_init_error();
+		free_dma_resources();
+		if (!irq_remapping_enabled) {
+			disable_iommus();
+			free_on_init_error();
+		} else {
+			struct amd_iommu *iommu;
+
+			uninit_device_table_dma();
+			for_each_iommu(iommu)
+				iommu_flush_all_caches(iommu);
+		}
 	}
 
 	return ret;
-- 
1.7.9.5


