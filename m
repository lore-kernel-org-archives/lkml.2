Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988Ab2I1M1D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 08:27:03 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:55495
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757725Ab2I1MYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 08:24:18 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzd6f1izz1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah11b5h121eh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1155h)
X-WSS-ID: 0MB27SB-01-LKZ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 07/16] iommu/amd: Add IRTE invalidation routine
Date: Fri, 28 Sep 2012 14:23:57 +0200
Message-ID: <1348835046-3262-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
References: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
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
index b6a8079..a2c1f7a 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -902,6 +902,13 @@ static void build_inv_all(struct iommu_cmd *cmd)
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
@@ -1023,12 +1030,32 @@ static void iommu_flush_all(struct amd_iommu *iommu)
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
index 1a7d480..b183306 100644
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


