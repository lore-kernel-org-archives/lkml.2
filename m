Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab1LENfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:35:09 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:38222
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932250Ab1LENfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:35:06 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVQGEB-02-AUB-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 04/22] iommu/amd: Setup PPR log when supported by IOMMU
Date: Mon, 5 Dec 2011 14:34:19 +0100
Message-ID: <1323092077-25501-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
References: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate and enable a log buffer for peripheral page faults
when the IOMMU supports this feature.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_init.c  |   51 +++++++++++++++++++++++++++++++++++++++
 drivers/iommu/amd_iommu_types.h |   14 ++++++++++
 2 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index fb4afd6..60716ce 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -583,6 +583,46 @@ static void __init free_event_buffer(struct amd_iommu *iommu)
 	free_pages((unsigned long)iommu->evt_buf, get_order(EVT_BUFFER_SIZE));
 }
 
+/* allocates the memory where the IOMMU will log its events to */
+static u8 * __init alloc_ppr_log(struct amd_iommu *iommu)
+{
+	iommu->ppr_log = (u8 *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+						get_order(PPR_LOG_SIZE));
+
+	if (iommu->ppr_log == NULL)
+		return NULL;
+
+	return iommu->ppr_log;
+}
+
+static void iommu_enable_ppr_log(struct amd_iommu *iommu)
+{
+	u64 entry;
+
+	if (iommu->ppr_log == NULL)
+		return;
+
+	entry = (u64)virt_to_phys(iommu->ppr_log) | PPR_LOG_SIZE_512;
+
+	memcpy_toio(iommu->mmio_base + MMIO_PPR_LOG_OFFSET,
+		    &entry, sizeof(entry));
+
+	/* set head and tail to zero manually */
+	writel(0x00, iommu->mmio_base + MMIO_PPR_HEAD_OFFSET);
+	writel(0x00, iommu->mmio_base + MMIO_PPR_TAIL_OFFSET);
+
+	iommu_feature_enable(iommu, CONTROL_PPFLOG_EN);
+	iommu_feature_enable(iommu, CONTROL_PPR_EN);
+}
+
+static void __init free_ppr_log(struct amd_iommu *iommu)
+{
+	if (iommu->ppr_log == NULL)
+		return;
+
+	free_pages((unsigned long)iommu->ppr_log, get_order(PPR_LOG_SIZE));
+}
+
 /* sets a specific bit in the device table entry. */
 static void set_dev_entry_bit(u16 devid, u8 bit)
 {
@@ -914,6 +954,7 @@ static void __init free_iommu_one(struct amd_iommu *iommu)
 {
 	free_command_buffer(iommu);
 	free_event_buffer(iommu);
+	free_ppr_log(iommu);
 	iommu_unmap_mmio_space(iommu);
 }
 
@@ -977,6 +1018,12 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
 	init_iommu_from_acpi(iommu, h);
 	init_iommu_devices(iommu);
 
+	if (iommu_feature(iommu, FEATURE_PPR)) {
+		iommu->ppr_log = alloc_ppr_log(iommu);
+		if (!iommu->ppr_log)
+			return -ENOMEM;
+	}
+
 	if (iommu->cap & (1UL << IOMMU_CAP_NPCACHE))
 		amd_iommu_np_cache = true;
 
@@ -1063,6 +1110,9 @@ static int iommu_setup_msi(struct amd_iommu *iommu)
 	iommu->int_enabled = true;
 	iommu_feature_enable(iommu, CONTROL_EVT_INT_EN);
 
+	if (iommu->ppr_log != NULL)
+		iommu_feature_enable(iommu, CONTROL_PPFINT_EN);
+
 	return 0;
 }
 
@@ -1287,6 +1337,7 @@ static void enable_iommus(void)
 		iommu_set_device_table(iommu);
 		iommu_enable_command_buffer(iommu);
 		iommu_enable_event_buffer(iommu);
+		iommu_enable_ppr_log(iommu);
 		iommu_set_exclusion_range(iommu);
 		iommu_init_msi(iommu);
 		iommu_enable(iommu);
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index 0a62685..59405c8 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -69,11 +69,14 @@
 #define MMIO_EXCL_BASE_OFFSET   0x0020
 #define MMIO_EXCL_LIMIT_OFFSET  0x0028
 #define MMIO_EXT_FEATURES	0x0030
+#define MMIO_PPR_LOG_OFFSET	0x0038
 #define MMIO_CMD_HEAD_OFFSET	0x2000
 #define MMIO_CMD_TAIL_OFFSET	0x2008
 #define MMIO_EVT_HEAD_OFFSET	0x2010
 #define MMIO_EVT_TAIL_OFFSET	0x2018
 #define MMIO_STATUS_OFFSET	0x2020
+#define MMIO_PPR_HEAD_OFFSET	0x2030
+#define MMIO_PPR_TAIL_OFFSET	0x2038
 
 
 /* Extended Feature Bits */
@@ -125,6 +128,7 @@
 #define CONTROL_CMDBUF_EN       0x0cULL
 #define CONTROL_PPFLOG_EN       0x0dULL
 #define CONTROL_PPFINT_EN       0x0eULL
+#define CONTROL_PPR_EN          0x0fULL
 
 /* command specific defines */
 #define CMD_COMPL_WAIT          0x01
@@ -168,6 +172,13 @@
 #define EVT_BUFFER_SIZE		8192 /* 512 entries */
 #define EVT_LEN_MASK		(0x9ULL << 56)
 
+/* Constants for PPR Log handling */
+#define PPR_LOG_ENTRIES		512
+#define PPR_LOG_SIZE_SHIFT	56
+#define PPR_LOG_SIZE_512	(0x9ULL << PPR_LOG_SIZE_SHIFT)
+#define PPR_ENTRY_SIZE		16
+#define PPR_LOG_SIZE		(PPR_ENTRY_SIZE * PPR_LOG_ENTRIES)
+
 #define PAGE_MODE_NONE    0x00
 #define PAGE_MODE_1_LEVEL 0x01
 #define PAGE_MODE_2_LEVEL 0x02
@@ -435,6 +446,9 @@ struct amd_iommu {
 	/* MSI number for event interrupt */
 	u16 evt_msi_num;
 
+	/* Base of the PPR log, if present */
+	u8 *ppr_log;
+
 	/* true if interrupts for this IOMMU are already enabled */
 	bool int_enabled;
 
-- 
1.7.5.4


