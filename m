Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747Ab2I1M0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 08:26:34 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:48681
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757771Ab2I1MYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 08:24:19 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzd6f1izz1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah11b5h121eh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1155h)
X-WSS-ID: 0MB27S9-02-8L8-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 13/16] iommu/amd: Make sure irq remapping still works on dma init failure
Date: Fri, 28 Sep 2012 14:24:03 +0200
Message-ID: <1348835046-3262-14-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
References: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
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
index 42db810..0608ef4 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1396,6 +1396,16 @@ static void init_device_table_dma(void)
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
@@ -1564,11 +1574,6 @@ static void __init free_on_init_error(void)
 
 	}
 
-	amd_iommu_uninit_devices();
-
-	free_pages((unsigned long)amd_iommu_pd_alloc_bitmap,
-		   get_order(MAX_DOMAIN_ID/8));
-
 	free_pages((unsigned long)amd_iommu_rlookup_table,
 		   get_order(rlookup_table_size));
 
@@ -1580,8 +1585,6 @@ static void __init free_on_init_error(void)
 
 	free_iommu_all();
 
-	free_unity_maps();
-
 #ifdef CONFIG_GART_IOMMU
 	/*
 	 * We failed to initialize the AMD IOMMU - try fallback to GART
@@ -1609,6 +1612,16 @@ static bool __init check_ioapic_information(void)
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
@@ -1949,8 +1962,17 @@ static int __init amd_iommu_init(void)
 
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


