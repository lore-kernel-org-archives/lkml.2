Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab1DGNcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 09:32:06 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:6115 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab1DGNaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 09:30:14 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJAAU7-02-JOM-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7/9] x86/amd-iommu: Improve handling of full command buffer
Date: Thu, 7 Apr 2011 15:30:02 +0200
Message-ID: <1302183004-4081-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302183004-4081-1-git-send-email-joerg.roedel@amd.com>
References: <1302183004-4081-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch improved the handling of commands when the IOMMU
command buffer is nearly full. In this case it issues an
completion wait command and waits until the IOMMU has
processed it before continuing queuing new commands.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   88 +++++++++++++++++++++++++++++++-----------
 1 files changed, 65 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 9d66b20..75c7f8c 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -381,6 +381,39 @@ irqreturn_t amd_iommu_int_handler(int irq, void *data)
  *
  ****************************************************************************/
 
+static int wait_on_sem(volatile u64 *sem)
+{
+	int i = 0;
+
+	while (*sem == 0 && i < LOOP_TIMEOUT) {
+		udelay(1);
+		i += 1;
+	}
+
+	if (i == LOOP_TIMEOUT) {
+		pr_alert("AMD-Vi: Completion-Wait loop timed out\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static void copy_cmd_to_buffer(struct amd_iommu *iommu,
+			       struct iommu_cmd *cmd,
+			       u32 tail)
+{
+	u8 *target;
+
+	target = iommu->cmd_buf + tail;
+	tail   = (tail + sizeof(*cmd)) % iommu->cmd_buf_size;
+
+	/* Copy command to buffer */
+	memcpy(target, cmd, sizeof(*cmd));
+
+	/* Tell the IOMMU about it */
+	writel(tail, iommu->mmio_base + MMIO_CMD_TAIL_OFFSET);
+}
+
 static void build_completion_wait(struct iommu_cmd *cmd, u64 address)
 {
 	WARN_ON(address & 0x7ULL);
@@ -432,25 +465,44 @@ static void build_inv_iommu_pages(struct iommu_cmd *cmd, u64 address,
 
 /*
  * Writes the command to the IOMMUs command buffer and informs the
- * hardware about the new command. Must be called with iommu->lock held.
+ * hardware about the new command.
  */
 static int iommu_queue_command(struct amd_iommu *iommu, struct iommu_cmd *cmd)
 {
+	u32 left, tail, head, next_tail;
 	unsigned long flags;
-	u32 tail, head;
-	u8 *target;
 
 	WARN_ON(iommu->cmd_buf_size & CMD_BUFFER_UNINITIALIZED);
+
+again:
 	spin_lock_irqsave(&iommu->lock, flags);
-	tail = readl(iommu->mmio_base + MMIO_CMD_TAIL_OFFSET);
-	target = iommu->cmd_buf + tail;
-	memcpy_toio(target, cmd, sizeof(*cmd));
-	tail = (tail + sizeof(*cmd)) % iommu->cmd_buf_size;
-	head = readl(iommu->mmio_base + MMIO_CMD_HEAD_OFFSET);
-	if (tail == head)
-		return -ENOMEM;
-	writel(tail, iommu->mmio_base + MMIO_CMD_TAIL_OFFSET);
+
+	head      = readl(iommu->mmio_base + MMIO_CMD_HEAD_OFFSET);
+	tail      = readl(iommu->mmio_base + MMIO_CMD_TAIL_OFFSET);
+	next_tail = (tail + sizeof(*cmd)) % iommu->cmd_buf_size;
+	left      = (head - next_tail) % iommu->cmd_buf_size;
+
+	if (left <= 2) {
+		struct iommu_cmd sync_cmd;
+		volatile u64 sem = 0;
+		int ret;
+
+		build_completion_wait(&sync_cmd, (u64)&sem);
+		copy_cmd_to_buffer(iommu, &sync_cmd, tail);
+
+		spin_unlock_irqrestore(&iommu->lock, flags);
+
+		if ((ret = wait_on_sem(&sem)) != 0)
+			return ret;
+
+		goto again;
+	}
+
+	copy_cmd_to_buffer(iommu, cmd, tail);
+
+	/* We need to sync now to make sure all commands are processed */
 	iommu->need_sync = true;
+
 	spin_unlock_irqrestore(&iommu->lock, flags);
 
 	return 0;
@@ -464,7 +516,7 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 {
 	struct iommu_cmd cmd;
 	volatile u64 sem = 0;
-	int ret, i = 0;
+	int ret;
 
 	if (!iommu->need_sync)
 		return 0;
@@ -475,17 +527,7 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 	if (ret)
 		return ret;
 
-	while (sem == 0 && i < LOOP_TIMEOUT) {
-		udelay(1);
-		i += 1;
-	}
-
-	if (i == LOOP_TIMEOUT) {
-		pr_alert("AMD-Vi: Completion-Wait loop timed out\n");
-		ret = -EIO;
-	}
-
-	return 0;
+	return wait_on_sem(&sem);
 }
 
 /*
-- 
1.7.1


