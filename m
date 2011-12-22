Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab1LVOBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 09:01:36 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:27551
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751774Ab1LVOBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 09:01:30 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LWLYYC-02-236-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/3] iommu/amd: Set IOTLB invalidation timeout
Date: Thu, 22 Dec 2011 15:01:19 +0100
Message-ID: <1324562479-29755-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1324562479-29755-1-git-send-email-joerg.roedel@amd.com>
References: <1324562479-29755-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To protect the command buffer from hanging when a device
does not respond to an IOTLB invalidation, set a timeout of
1s for outstanding IOTLB invalidations.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_init.c  |   13 +++++++++++++
 drivers/iommu/amd_iommu_types.h |   10 ++++++++++
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 38784733..bdea288 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -306,6 +306,16 @@ static void iommu_feature_disable(struct amd_iommu *iommu, u8 bit)
 	writel(ctrl, iommu->mmio_base + MMIO_CONTROL_OFFSET);
 }
 
+static void iommu_set_inv_tlb_timeout(struct amd_iommu *iommu, int timeout)
+{
+	u32 ctrl;
+
+	ctrl = readl(iommu->mmio_base + MMIO_CONTROL_OFFSET);
+	ctrl &= ~CTRL_INV_TO_MASK;
+	ctrl |= (timeout << CONTROL_INV_TIMEOUT) & CTRL_INV_TO_MASK;
+	writel(ctrl, iommu->mmio_base + MMIO_CONTROL_OFFSET);
+}
+
 /* Function to enable the hardware */
 static void iommu_enable(struct amd_iommu *iommu)
 {
@@ -1300,6 +1310,9 @@ static void iommu_init_flags(struct amd_iommu *iommu)
 	 * make IOMMU memory accesses cache coherent
 	 */
 	iommu_feature_enable(iommu, CONTROL_COHERENT_EN);
+
+	/* Set IOTLB invalidation timeout to 1s */
+	iommu_set_inv_tlb_timeout(iommu, CTRL_INV_TO_1S);
 }
 
 static void iommu_apply_resume_quirks(struct amd_iommu *iommu)
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index 6ad8b10..2452f3b 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -127,6 +127,7 @@
 #define CONTROL_EVT_LOG_EN      0x02ULL
 #define CONTROL_EVT_INT_EN      0x03ULL
 #define CONTROL_COMWAIT_EN      0x04ULL
+#define CONTROL_INV_TIMEOUT	0x05ULL
 #define CONTROL_PASSPW_EN       0x08ULL
 #define CONTROL_RESPASSPW_EN    0x09ULL
 #define CONTROL_COHERENT_EN     0x0aULL
@@ -137,6 +138,15 @@
 #define CONTROL_PPR_EN          0x0fULL
 #define CONTROL_GT_EN           0x10ULL
 
+#define CTRL_INV_TO_MASK	(7 << CONTROL_INV_TIMEOUT)
+#define CTRL_INV_TO_NONE	0
+#define CTRL_INV_TO_1MS		1
+#define CTRL_INV_TO_10MS	2
+#define CTRL_INV_TO_100MS	3
+#define CTRL_INV_TO_1S		4
+#define CTRL_INV_TO_10S		5
+#define CTRL_INV_TO_100S	6
+
 /* command specific defines */
 #define CMD_COMPL_WAIT          0x01
 #define CMD_INV_DEV_ENTRY       0x02
-- 
1.7.5.4


