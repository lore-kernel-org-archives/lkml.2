Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab1DGNbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 09:31:00 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:47346
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751692Ab1DGNa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 09:30:58 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJAAU6-01-CQ8-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/9] x86/amd-iommu: Move inv-dte command building to own function
Date: Thu, 7 Apr 2011 15:29:57 +0200
Message-ID: <1302183004-4081-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302183004-4081-1-git-send-email-joerg.roedel@amd.com>
References: <1302183004-4081-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves command building for the invalidate-dte
command into its own function.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index eebd504..4e5631a 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -390,6 +390,13 @@ static void build_completion_wait(struct iommu_cmd *cmd)
 	CMD_SET_TYPE(cmd, CMD_COMPL_WAIT);
 }
 
+static void build_inv_dte(struct iommu_cmd *cmd, u16 devid)
+{
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->data[0] = devid;
+	CMD_SET_TYPE(cmd, CMD_INV_DEV_ENTRY);
+}
+
 /*
  * Writes the command to the IOMMUs command buffer and informs the
  * hardware about the new command. Must be called with iommu->lock held.
@@ -533,10 +540,7 @@ static int iommu_flush_device(struct device *dev)
 	devid = get_device_id(dev);
 	iommu = amd_iommu_rlookup_table[devid];
 
-	/* Build command */
-	memset(&cmd, 0, sizeof(cmd));
-	CMD_SET_TYPE(&cmd, CMD_INV_DEV_ENTRY);
-	cmd.data[0] = devid;
+	build_inv_dte(&cmd, devid);
 
 	return iommu_queue_command(iommu, &cmd);
 }
-- 
1.7.1


