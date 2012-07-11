Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab2GKNnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:43:45 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:12963
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757736Ab2GKNjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:39:24 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M700LF-01-AXK-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 16/27] iommu/amd: Split device table initialization into irq and dma part
Date: Wed, 11 Jul 2012 15:39:01 +0200
Message-ID: <1342013952-10174-17-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342013952-10174-1-git-send-email-joerg.roedel@amd.com>
References: <1342013952-10174-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the IOMMU is enabled very early (as with irq-remapping)
some devices are still in BIOS hand. When dma is blocked
early this can cause lots of IO_PAGE_FAULTs. So delay the
DMA initialization and do it right before the dma_ops are
initialized.
To be secure, block all interrupts by default when irq-remapping is
enabled in the system. They will be reenabled on demand
later.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_init.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index a25201f..0b4093c 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1381,7 +1381,7 @@ static int __init init_memory_definitions(struct acpi_table_header *table)
  * Init the device table to not allow DMA access for devices and
  * suppress all page faults
  */
-static void init_device_table(void)
+static void init_device_table_dma(void)
 {
 	u32 devid;
 
@@ -1391,6 +1391,17 @@ static void init_device_table(void)
 	}
 }
 
+static void init_device_table(void)
+{
+	u32 devid;
+
+	if (!amd_iommu_irq_remap)
+		return;
+
+	for (devid = 0; devid <= amd_iommu_last_bdf; ++devid)
+		set_dev_entry_bit(devid, DEV_ENTRY_IRQ_TBL_EN);
+}
+
 static void iommu_init_flags(struct amd_iommu *iommu)
 {
 	iommu->acpi_flags & IVHD_FLAG_HT_TUN_EN_MASK ?
@@ -1778,8 +1789,14 @@ static bool detect_ivrs(void)
 
 static int amd_iommu_init_dma(void)
 {
+	struct amd_iommu *iommu;
 	int ret;
 
+	init_device_table_dma();
+
+	for_each_iommu(iommu)
+		iommu_flush_all_caches(iommu);
+
 	if (iommu_pass_through)
 		ret = amd_iommu_init_passthrough();
 	else
-- 
1.7.9.5


