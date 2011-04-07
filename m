Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab1DGNac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 09:30:32 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:6115 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab1DGNaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 09:30:15 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJAAU7-01-CQF-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/9] x86/amd-iommu: Cleanup completion-wait handling
Date: Thu, 7 Apr 2011 15:29:59 +0200
Message-ID: <1302183004-4081-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302183004-4081-1-git-send-email-joerg.roedel@amd.com>
References: <1302183004-4081-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up the implementation of completion-wait
command sending. It also switches the completion indicator
from the MMIO bit to a memory store which can be checked
without IOMMU locking.
As a side effect this patch makes the __iommu_queue_command
function obsolete and so it is removed too.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |  107 +++++++++++-------------------------------
 1 files changed, 28 insertions(+), 79 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index f8ec28e..073c64b 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -25,6 +25,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/iommu-helper.h>
 #include <linux/iommu.h>
+#include <linux/delay.h>
 #include <asm/proto.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
@@ -34,7 +35,7 @@
 
 #define CMD_SET_TYPE(cmd, t) ((cmd)->data[1] |= ((t) << 28))
 
-#define EXIT_LOOP_COUNT 10000000
+#define LOOP_TIMEOUT	100000
 
 static DEFINE_RWLOCK(amd_iommu_devtable_lock);
 
@@ -383,10 +384,14 @@ irqreturn_t amd_iommu_int_handler(int irq, void *data)
  *
  ****************************************************************************/
 
-static void build_completion_wait(struct iommu_cmd *cmd)
+static void build_completion_wait(struct iommu_cmd *cmd, u64 address)
 {
+	WARN_ON(address & 0x7ULL);
+
 	memset(cmd, 0, sizeof(*cmd));
-	cmd->data[0] = CMD_COMPL_WAIT_INT_MASK;
+	cmd->data[0] = lower_32_bits(__pa(address)) | CMD_COMPL_WAIT_STORE_MASK;
+	cmd->data[1] = upper_32_bits(__pa(address));
+	cmd->data[2] = 1;
 	CMD_SET_TYPE(cmd, CMD_COMPL_WAIT);
 }
 
@@ -432,12 +437,14 @@ static void build_inv_iommu_pages(struct iommu_cmd *cmd, u64 address,
  * Writes the command to the IOMMUs command buffer and informs the
  * hardware about the new command. Must be called with iommu->lock held.
  */
-static int __iommu_queue_command(struct amd_iommu *iommu, struct iommu_cmd *cmd)
+static int iommu_queue_command(struct amd_iommu *iommu, struct iommu_cmd *cmd)
 {
+	unsigned long flags;
 	u32 tail, head;
 	u8 *target;
 
 	WARN_ON(iommu->cmd_buf_size & CMD_BUFFER_UNINITIALIZED);
+	spin_lock_irqsave(&iommu->lock, flags);
 	tail = readl(iommu->mmio_base + MMIO_CMD_TAIL_OFFSET);
 	target = iommu->cmd_buf + tail;
 	memcpy_toio(target, cmd, sizeof(*cmd));
@@ -446,99 +453,41 @@ static int __iommu_queue_command(struct amd_iommu *iommu, struct iommu_cmd *cmd)
 	if (tail == head)
 		return -ENOMEM;
 	writel(tail, iommu->mmio_base + MMIO_CMD_TAIL_OFFSET);
-
-	return 0;
-}
-
-/*
- * General queuing function for commands. Takes iommu->lock and calls
- * __iommu_queue_command().
- */
-static int iommu_queue_command(struct amd_iommu *iommu, struct iommu_cmd *cmd)
-{
-	unsigned long flags;
-	int ret;
-
-	spin_lock_irqsave(&iommu->lock, flags);
-	ret = __iommu_queue_command(iommu, cmd);
-	if (!ret)
-		iommu->need_sync = true;
+	iommu->need_sync = true;
 	spin_unlock_irqrestore(&iommu->lock, flags);
 
-	return ret;
-}
-
-/*
- * This function waits until an IOMMU has completed a completion
- * wait command
- */
-static void __iommu_wait_for_completion(struct amd_iommu *iommu)
-{
-	int ready = 0;
-	unsigned status = 0;
-	unsigned long i = 0;
-
-	INC_STATS_COUNTER(compl_wait);
-
-	while (!ready && (i < EXIT_LOOP_COUNT)) {
-		++i;
-		/* wait for the bit to become one */
-		status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
-		ready = status & MMIO_STATUS_COM_WAIT_INT_MASK;
-	}
-
-	/* set bit back to zero */
-	status &= ~MMIO_STATUS_COM_WAIT_INT_MASK;
-	writel(status, iommu->mmio_base + MMIO_STATUS_OFFSET);
-
-	if (unlikely(i == EXIT_LOOP_COUNT))
-		iommu->reset_in_progress = true;
+	return 0;
 }
 
 /*
  * This function queues a completion wait command into the command
  * buffer of an IOMMU
  */
-static int __iommu_completion_wait(struct amd_iommu *iommu)
-{
-	struct iommu_cmd cmd;
-
-	build_completion_wait(&cmd);
-
-	 return __iommu_queue_command(iommu, &cmd);
-}
-
-/*
- * This function is called whenever we need to ensure that the IOMMU has
- * completed execution of all commands we sent. It sends a
- * COMPLETION_WAIT command and waits for it to finish. The IOMMU informs
- * us about that by writing a value to a physical address we pass with
- * the command.
- */
 static int iommu_completion_wait(struct amd_iommu *iommu)
 {
-	int ret = 0;
-	unsigned long flags;
-
-	spin_lock_irqsave(&iommu->lock, flags);
+	struct iommu_cmd cmd;
+	volatile u64 sem = 0;
+	int ret, i = 0;
 
 	if (!iommu->need_sync)
-		goto out;
-
-	ret = __iommu_completion_wait(iommu);
+		return 0;
 
-	iommu->need_sync = false;
+	build_completion_wait(&cmd, (u64)&sem);
 
+	ret = iommu_queue_command(iommu, &cmd);
 	if (ret)
-		goto out;
-
-	__iommu_wait_for_completion(iommu);
+		return ret;
 
-out:
-	spin_unlock_irqrestore(&iommu->lock, flags);
+	while (sem == 0 && i < LOOP_TIMEOUT) {
+		udelay(1);
+		i += 1;
+	}
 
-	if (iommu->reset_in_progress)
+	if (i == LOOP_TIMEOUT) {
+		pr_alert("AMD-Vi: Completion-Wait loop timed out\n");
+		iommu->reset_in_progress = true;
 		reset_iommu_command_buffer(iommu);
+	}
 
 	return 0;
 }
-- 
1.7.1


