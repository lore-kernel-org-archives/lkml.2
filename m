Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922Ab2I1M0N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 08:26:13 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:43550
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757791Ab2I1MYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 08:24:20 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzd6f1izz1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah11b5h121eh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1155h)
X-WSS-ID: 0MB27S9-01-LKW-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 05/16] iommu/amd: Split device table initialization into irq and dma part
Date: Fri, 28 Sep 2012 14:23:55 +0200
Message-ID: <1348835046-3262-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
References: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
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
index 3f0b68f..8e9d71c 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1378,7 +1378,7 @@ static int __init init_memory_definitions(struct acpi_table_header *table)
  * Init the device table to not allow DMA access for devices and
  * suppress all page faults
  */
-static void init_device_table(void)
+static void init_device_table_dma(void)
 {
 	u32 devid;
 
@@ -1388,6 +1388,17 @@ static void init_device_table(void)
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


