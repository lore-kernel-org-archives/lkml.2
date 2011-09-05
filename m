Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab1IEO5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 10:57:19 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:52313
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752803Ab1IEO5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 10:57:17 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bh8275dhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LR21J8-01-GE0-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>,
        <stable@kernel.org>
Subject: [PATCH 1/2] iommu/amd: Make sure iommu->need_sync contains correct value
Date: Mon, 5 Sep 2011 16:57:00 +0200
Message-ID: <1315234621-26694-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315234621-26694-1-git-send-email-joerg.roedel@amd.com>
References: <1315234621-26694-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The value is only set to true but never set back to false,
which causes to many completion-wait commands to be sent to
hardware. Fix it with this patch.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index a14f8dc..4565223 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -605,7 +605,9 @@ static void build_inv_all(struct iommu_cmd *cmd)
  * Writes the command to the IOMMUs command buffer and informs the
  * hardware about the new command.
  */
-static int iommu_queue_command(struct amd_iommu *iommu, struct iommu_cmd *cmd)
+static int iommu_queue_command_sync(struct amd_iommu *iommu,
+				    struct iommu_cmd *cmd,
+				    bool sync)
 {
 	u32 left, tail, head, next_tail;
 	unsigned long flags;
@@ -639,13 +641,18 @@ again:
 	copy_cmd_to_buffer(iommu, cmd, tail);
 
 	/* We need to sync now to make sure all commands are processed */
-	iommu->need_sync = true;
+	iommu->need_sync = sync;
 
 	spin_unlock_irqrestore(&iommu->lock, flags);
 
 	return 0;
 }
 
+static int iommu_queue_command(struct amd_iommu *iommu, struct iommu_cmd *cmd)
+{
+	return iommu_queue_command_sync(iommu, cmd, true);
+}
+
 /*
  * This function queues a completion wait command into the command
  * buffer of an IOMMU
@@ -661,7 +668,7 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 
 	build_completion_wait(&cmd, (u64)&sem);
 
-	ret = iommu_queue_command(iommu, &cmd);
+	ret = iommu_queue_command_sync(iommu, &cmd, false);
 	if (ret)
 		return ret;
 
-- 
1.7.4.1


