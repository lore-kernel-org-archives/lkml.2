Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316Ab2BJNjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 08:39:17 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:42053 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab2BJNjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 08:39:12 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 3/6] sep: Add interfaces for the new functions
To: greg@kroah.com, linux-kernel@vger.kernel.org, mark.a.allyn@intel.com
Date: Fri, 10 Feb 2012 13:52:55 +0000
Message-ID: <20120210135253.12442.95497.stgit@bob.linux.org.uk>
In-Reply-To: <20120210134929.12442.59041.stgit@bob.linux.org.uk>
References: <20120210134929.12442.59041.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark A. Allyn <mark.a.allyn@intel.com>

[This is picked out of the differences between the upstream driver and
 the staging driver. I'm resolving the differences as a series of updates -AC]

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/sep/sep_main.c |   60 +++++++++++++++++++++++++++++++++-------
 1 files changed, 49 insertions(+), 11 deletions(-)


diff --git a/drivers/staging/sep/sep_main.c b/drivers/staging/sep/sep_main.c
index 7d7cb48..1fcabca 100644
--- a/drivers/staging/sep/sep_main.c
+++ b/drivers/staging/sep/sep_main.c
@@ -3067,9 +3067,13 @@ static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 	switch (cmd) {
 	case SEP_IOCSENDSEPCOMMAND:
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] SEP_IOCSENDSEPCOMMAND start\n",
+			current->pid);
 		if (1 == test_bit(SEP_LEGACY_SENDMSG_DONE_OFFSET,
 				  &call_status->status)) {
-			dev_dbg(&sep->pdev->dev, "[PID%d] send msg already done\n",
+			dev_warn(&sep->pdev->dev,
+				"[PID%d] send msg already done\n",
 				current->pid);
 			error = -EPROTO;
 			goto end_function;
@@ -3079,37 +3083,71 @@ static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (!error)
 			set_bit(SEP_LEGACY_SENDMSG_DONE_OFFSET,
 				&call_status->status);
-		dev_dbg(&sep->pdev->dev, "[PID%d] SEP_IOCSENDSEPCOMMAND end\n",
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] SEP_IOCSENDSEPCOMMAND end\n",
 			current->pid);
 		break;
 	case SEP_IOCENDTRANSACTION:
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] SEP_IOCENDTRANSACTION start\n",
+			current->pid);
 		error = sep_end_transaction_handler(sep, dma_ctx, call_status,
-			my_queue_elem);
-		dev_dbg(&sep->pdev->dev, "[PID%d] SEP_IOCENDTRANSACTION end\n",
+						    my_queue_elem);
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] SEP_IOCENDTRANSACTION end\n",
 			current->pid);
 		break;
 	case SEP_IOCPREPAREDCB:
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] SEP_IOCPREPAREDCB start\n",
+			current->pid);
+	case SEP_IOCPREPAREDCB_SECURE_DMA:
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] SEP_IOCPREPAREDCB_SECURE_DMA start\n",
+			current->pid);
 		if (1 == test_bit(SEP_LEGACY_SENDMSG_DONE_OFFSET,
 				  &call_status->status)) {
-			dev_dbg(&sep->pdev->dev,
-				"[PID%d] dcb preparation needed before send msg\n",
+			dev_warn(&sep->pdev->dev,
+				"[PID%d] dcb prep needed before send msg\n",
 				current->pid);
 			error = -EPROTO;
 			goto end_function;
 		}
 
 		if (!arg) {
-			dev_dbg(&sep->pdev->dev,
-				"[PID%d] dcb prep null arg\n", current->pid);
-			error = -EINVAL;
+			dev_warn(&sep->pdev->dev,
+				"[PID%d] dcb null arg\n", current->pid);
+			error = EINVAL;
 			goto end_function;
 		}
 
-		error = sep_prepare_dcb_handler(sep, arg, false, dma_ctx);
-		dev_dbg(&sep->pdev->dev, "[PID%d] SEP_IOCPREPAREDCB end\n",
+		if (cmd == SEP_IOCPREPAREDCB) {
+			/* No secure dma */
+			dev_dbg(&sep->pdev->dev,
+				"[PID%d] SEP_IOCPREPAREDCB (no secure_dma)\n",
+				current->pid);
+
+			error = sep_prepare_dcb_handler(sep, arg, false,
+				dma_ctx);
+		} else {
+			/* Secure dma */
+			dev_dbg(&sep->pdev->dev,
+				"[PID%d] SEP_IOC_POC (with secure_dma)\n",
+				current->pid);
+
+			error = sep_prepare_dcb_handler(sep, arg, true,
+				dma_ctx);
+		}
+		dev_dbg(&sep->pdev->dev, "[PID%d] dcb's end\n",
 			current->pid);
 		break;
 	case SEP_IOCFREEDCB:
+		dev_dbg(&sep->pdev->dev, "[PID%d] SEP_IOCFREEDCB start\n",
+			current->pid);
+	case SEP_IOCFREEDCB_SECURE_DMA:
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] SEP_IOCFREEDCB_SECURE_DMA start\n",
+			current->pid);
 		error = sep_free_dcb_handler(sep, dma_ctx);
 		dev_dbg(&sep->pdev->dev, "[PID%d] SEP_IOCFREEDCB end\n",
 			current->pid);

