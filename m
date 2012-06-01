Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969Ab2FAOGD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 10:06:03 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:20883
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754623Ab2FAOFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 10:05:18 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bh8275dhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M4XZ4K-01-7D4-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/2] iommu/amd: Fix deadlock in ppr-handling error path
Date: Fri, 1 Jun 2012 16:05:01 +0200
Message-ID: <1338559501-15478-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1338559501-15478-1-git-send-email-joerg.roedel@amd.com>
References: <1338559501-15478-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the error path of the ppr_notifer it can happen that the
iommu->lock is taken recursivly. This patch fixes the
problem by releasing the iommu->lock before any notifier is
invoked. This also requires to move the erratum workaround
for the ppr-log (interrupt may be faster than data in the log)
one function up.

Cc: stable@vger.kernel.org # v3.3, v3.4
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu.c |   71 ++++++++++++++++++++++++++++-----------------
 1 file changed, 44 insertions(+), 27 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index d90a421..a2e418c 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -547,26 +547,12 @@ static void iommu_poll_events(struct amd_iommu *iommu)
 	spin_unlock_irqrestore(&iommu->lock, flags);
 }
 
-static void iommu_handle_ppr_entry(struct amd_iommu *iommu, u32 head)
+static void iommu_handle_ppr_entry(struct amd_iommu *iommu, u64 *raw)
 {
 	struct amd_iommu_fault fault;
-	volatile u64 *raw;
-	int i;
 
 	INC_STATS_COUNTER(pri_requests);
 
-	raw = (u64 *)(iommu->ppr_log + head);
-
-	/*
-	 * Hardware bug: Interrupt may arrive before the entry is written to
-	 * memory. If this happens we need to wait for the entry to arrive.
-	 */
-	for (i = 0; i < LOOP_TIMEOUT; ++i) {
-		if (PPR_REQ_TYPE(raw[0]) != 0)
-			break;
-		udelay(1);
-	}
-
 	if (PPR_REQ_TYPE(raw[0]) != PPR_REQ_FAULT) {
 		pr_err_ratelimited("AMD-Vi: Unknown PPR request received\n");
 		return;
@@ -578,12 +564,6 @@ static void iommu_handle_ppr_entry(struct amd_iommu *iommu, u32 head)
 	fault.tag       = PPR_TAG(raw[0]);
 	fault.flags     = PPR_FLAGS(raw[0]);
 
-	/*
-	 * To detect the hardware bug we need to clear the entry
-	 * to back to zero.
-	 */
-	raw[0] = raw[1] = 0;
-
 	atomic_notifier_call_chain(&ppr_notifier, 0, &fault);
 }
 
@@ -595,25 +575,62 @@ static void iommu_poll_ppr_log(struct amd_iommu *iommu)
 	if (iommu->ppr_log == NULL)
 		return;
 
+	/* enable ppr interrupts again */
+	writel(MMIO_STATUS_PPR_INT_MASK, iommu->mmio_base + MMIO_STATUS_OFFSET);
+
 	spin_lock_irqsave(&iommu->lock, flags);
 
 	head = readl(iommu->mmio_base + MMIO_PPR_HEAD_OFFSET);
 	tail = readl(iommu->mmio_base + MMIO_PPR_TAIL_OFFSET);
 
 	while (head != tail) {
+		volatile u64 *raw;
+		u64 entry[2];
+		int i;
 
-		/* Handle PPR entry */
-		iommu_handle_ppr_entry(iommu, head);
+		raw = (u64 *)(iommu->ppr_log + head);
+
+		/*
+		 * Hardware bug: Interrupt may arrive before the entry is
+		 * written to memory. If this happens we need to wait for the
+		 * entry to arrive.
+		 */
+		for (i = 0; i < LOOP_TIMEOUT; ++i) {
+			if (PPR_REQ_TYPE(raw[0]) != 0)
+				break;
+			udelay(1);
+		}
+
+		/* Avoid memcpy function-call overhead */
+		entry[0] = raw[0];
+		entry[1] = raw[1];
 
-		/* Update and refresh ring-buffer state*/
+		/*
+		 * To detect the hardware bug we need to clear the entry
+		 * back to zero.
+		 */
+		raw[0] = raw[1] = 0UL;
+
+		/* Update head pointer of hardware ring-buffer */
 		head = (head + PPR_ENTRY_SIZE) % PPR_LOG_SIZE;
 		writel(head, iommu->mmio_base + MMIO_PPR_HEAD_OFFSET);
+
+		/*
+		 * Release iommu->lock because ppr-handling might need to
+		 * re-aquire it
+		 */
+		spin_unlock_irqrestore(&iommu->lock, flags);
+
+		/* Handle PPR entry */
+		iommu_handle_ppr_entry(iommu, entry);
+
+		spin_lock_irqsave(&iommu->lock, flags);
+
+		/* Refresh ring-buffer information */
+		head = readl(iommu->mmio_base + MMIO_PPR_HEAD_OFFSET);
 		tail = readl(iommu->mmio_base + MMIO_PPR_TAIL_OFFSET);
 	}
 
-	/* enable ppr interrupts again */
-	writel(MMIO_STATUS_PPR_INT_MASK, iommu->mmio_base + MMIO_STATUS_OFFSET);
-
 	spin_unlock_irqrestore(&iommu->lock, flags);
 }
 
-- 
1.7.9.5


