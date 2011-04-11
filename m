Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab1DKJcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 05:32:15 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:55472 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab1DKJcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 05:32:12 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJHEHJ-01-B1R-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/2] x86/amd-iommu: Add support for invalidate_all command
Date: Mon, 11 Apr 2011 11:32:04 +0200
Message-ID: <1302514324-14717-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302514324-14717-1-git-send-email-joerg.roedel@amd.com>
References: <1302514324-14717-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the invalidate_all command
present in new versions of the AMD IOMMU.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    1 +
 arch/x86/kernel/amd_iommu.c            |   24 ++++++++++++++++++++++--
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 5c24e46..df62d26 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -127,6 +127,7 @@
 #define CMD_COMPL_WAIT          0x01
 #define CMD_INV_DEV_ENTRY       0x02
 #define CMD_INV_IOMMU_PAGES     0x03
+#define CMD_INV_ALL		0x08
 
 #define CMD_COMPL_WAIT_STORE_MASK	0x01
 #define CMD_COMPL_WAIT_INT_MASK		0x02
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index d609610..a9b5cf7 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -463,6 +463,12 @@ static void build_inv_iommu_pages(struct iommu_cmd *cmd, u64 address,
 		cmd->data[2] |= CMD_INV_IOMMU_PAGES_PDE_MASK;
 }
 
+static void build_inv_all(struct iommu_cmd *cmd)
+{
+	memset(cmd, 0, sizeof(*cmd));
+	CMD_SET_TYPE(cmd, CMD_INV_DEV_ENTRY);
+}
+
 /*
  * Writes the command to the IOMMUs command buffer and informs the
  * hardware about the new command.
@@ -567,10 +573,24 @@ static void iommu_flush_tlb_all(struct amd_iommu *iommu)
 	iommu_completion_wait(iommu);
 }
 
+static void iommu_flush_all(struct amd_iommu *iommu)
+{
+	struct iommu_cmd cmd;
+
+	build_inv_all(&cmd);
+
+	iommu_queue_command(iommu, &cmd);
+	iommu_completion_wait(iommu);
+}
+
 void iommu_flush_all_caches(struct amd_iommu *iommu)
 {
-	iommu_flush_dte_all(iommu);
-	iommu_flush_tlb_all(iommu);
+	if (iommu_feature(iommu, FEATURE_IA)) {
+		iommu_flush_all(iommu);
+	} else {
+		iommu_flush_dte_all(iommu);
+		iommu_flush_tlb_all(iommu);
+	}
 }
 
 /*
-- 
1.7.1


