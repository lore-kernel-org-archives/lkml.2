Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675Ab2GEMhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:37:21 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:49945
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932579Ab2GEMhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:37:08 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M6OTPL-02-6NP-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 19/28] iommu/amd: Add IRTE invalidation routine
Date: Thu, 5 Jul 2012 14:36:39 +0200
Message-ID: <1341491808-23083-20-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
References: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add routine to invalidate the IOMMU cache for interupt
translations. Also include the IRTE caches when flushing all
IOMMU caches.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu.c       |   27 +++++++++++++++++++++++++++
 drivers/iommu/amd_iommu_types.h |    1 +
 2 files changed, 28 insertions(+)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 6282dab..7006605 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -834,6 +834,13 @@ static void build_inv_all(struct iommu_cmd *cmd)
 	CMD_SET_TYPE(cmd, CMD_INV_ALL);
 }
 
+static void build_inv_irt(struct iommu_cmd *cmd, u16 devid)
+{
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->data[0] = devid;
+	CMD_SET_TYPE(cmd, CMD_INV_IRT);
+}
+
 /*
  * Writes the command to the IOMMUs command buffer and informs the
  * hardware about the new command.
@@ -955,12 +962,32 @@ static void iommu_flush_all(struct amd_iommu *iommu)
 	iommu_completion_wait(iommu);
 }
 
+static void iommu_flush_irt(struct amd_iommu *iommu, u16 devid)
+{
+	struct iommu_cmd cmd;
+
+	build_inv_irt(&cmd, devid);
+
+	iommu_queue_command(iommu, &cmd);
+}
+
+static void iommu_flush_irt_all(struct amd_iommu *iommu)
+{
+	u32 devid;
+
+	for (devid = 0; devid <= 0xffff; ++devid)
+		iommu_flush_irt(iommu, devid);
+
+	iommu_completion_wait(iommu);
+}
+
 void iommu_flush_all_caches(struct amd_iommu *iommu)
 {
 	if (iommu_feature(iommu, FEATURE_IA)) {
 		iommu_flush_all(iommu);
 	} else {
 		iommu_flush_dte_all(iommu);
+		iommu_flush_irt_all(iommu);
 		iommu_flush_tlb_all(iommu);
 	}
 }
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index 1155389..0791451 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -152,6 +152,7 @@
 #define CMD_INV_DEV_ENTRY       0x02
 #define CMD_INV_IOMMU_PAGES	0x03
 #define CMD_INV_IOTLB_PAGES	0x04
+#define CMD_INV_IRT		0x05
 #define CMD_COMPLETE_PPR	0x07
 #define CMD_INV_ALL		0x08
 
-- 
1.7.9.5


