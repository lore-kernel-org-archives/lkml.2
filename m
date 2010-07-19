Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966347Ab0GSSkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:40:47 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:10986 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966333Ab0GSSkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:40:37 -0400
Subject: [PATCH 17/26] cciss: factor out cciss_enter_performant_mode
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Mon, 19 Jul 2010 13:46:07 -0500
Message-ID: <20100719184607.7908.63244.stgit@beardog.cce.hp.com>
In-Reply-To: <20100719184141.7908.26971.stgit@beardog.cce.hp.com>
References: <20100719184141.7908.26971.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: factor out cciss_enter_performant_mode

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   98 ++++++++++++++++++++++++++++++-------------------
 1 files changed, 59 insertions(+), 39 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index ee7cfde..17e420c 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3830,54 +3830,36 @@ static void __devinit cciss_wait_for_mode_change_ack(ctlr_info_t *h)
 	}
 }
 
-static void __devinit cciss_put_controller_into_performant_mode(ctlr_info_t *h)
+static __devinit void cciss_enter_performant_mode(ctlr_info_t *h)
 {
-	__u32 trans_support;
+	/* This is a bit complicated.  There are 8 registers on
+	 * the controller which we write to to tell it 8 different
+	 * sizes of commands which there may be.  It's a way of
+	 * reducing the DMA done to fetch each command.  Encoded into
+	 * each command's tag are 3 bits which communicate to the controller
+	 * which of the eight sizes that command fits within.  The size of
+	 * each command depends on how many scatter gather entries there are.
+	 * Each SG entry requires 16 bytes.  The eight registers are programmed
+	 * with the number of 16-byte blocks a command of that size requires.
+	 * The smallest command possible requires 5 such 16 byte blocks.
+	 * the largest command possible requires MAXSGENTRIES + 4 16-byte
+	 * blocks.  Note, this only extends to the SG entries contained
+	 * within the command block, and does not extend to chained blocks
+	 * of SG elements.   bft[] contains the eight values we write to
+	 * the registers.  They are not evenly distributed, but have more
+	 * sizes for small commands, and fewer sizes for larger commands.
+	 */
 	__u32 trans_offset;
+	int bft[8] = { 5, 6, 8, 10, 12, 20, 28, MAXSGENTRIES + 4};
 			/*
 			 *  5 = 1 s/g entry or 4k
 			 *  6 = 2 s/g entry or 8k
 			 *  8 = 4 s/g entry or 16k
 			 * 10 = 6 s/g entry or 24k
 			 */
-	int bft[8] = { 5, 6, 8, 10, 12, 20, 28, MAXSGENTRIES + 4};
 	unsigned long register_value;
-
 	BUILD_BUG_ON(28 > MAXSGENTRIES + 4);
 
-	dev_dbg(&h->pdev->dev, "Trying to put board into Performant mode\n");
-	/* Attempt to put controller into performant mode if supported */
-	/* Does board support performant mode? */
-	trans_support = readl(&(h->cfgtable->TransportSupport));
-	if (!(trans_support & PERFORMANT_MODE))
-		return;
-
-	printk(KERN_WARNING "cciss%d: Placing controller into "
-				"performant mode\n", h->ctlr);
-	/* Performant mode demands commands on a 32 byte boundary
-	 * pci_alloc_consistent aligns on page boundarys already.
-	 * Just need to check if divisible by 32
-	 */
-	if ((sizeof(CommandList_struct) % 32) != 0) {
-		printk(KERN_WARNING "%s %d %s\n",
-			"cciss info: command size[",
-			(int)sizeof(CommandList_struct),
-			"] not divisible by 32, no performant mode..\n");
-		return;
-	}
-
-	/* Performant mode ring buffer and supporting data structures */
-	h->reply_pool = (__u64 *)pci_alloc_consistent(
-		h->pdev, h->max_commands * sizeof(__u64),
-		&(h->reply_pool_dhandle));
-
-	/* Need a block fetch table for performant mode */
-	h->blockFetchTable = kmalloc(((h->maxsgentries+1) *
-		sizeof(__u32)), GFP_KERNEL);
-
-	if ((h->reply_pool == NULL) || (h->blockFetchTable == NULL))
-		goto clean_up;
-
 	h->reply_pool_wraparound = 1; /* spec: init to 1 */
 
 	/* Controller spec: zero out this buffer. */
@@ -3906,18 +3888,56 @@ static void __devinit cciss_put_controller_into_performant_mode(ctlr_info_t *h)
 	writel(CFGTBL_Trans_Performant,
 			&(h->cfgtable->HostWrite.TransportRequest));
 
-	h->transMethod = CFGTBL_Trans_Performant;
 	writel(CFGTBL_ChangeReq, h->vaddr + SA5_DOORBELL);
 	cciss_wait_for_mode_change_ack(h);
 	register_value = readl(&(h->cfgtable->TransportActive));
-	if (!(register_value & CFGTBL_Trans_Performant)) {
+	if (!(register_value & CFGTBL_Trans_Performant))
 		printk(KERN_WARNING "cciss: unable to get board into"
 					" performant mode\n");
+}
+
+static void __devinit cciss_put_controller_into_performant_mode(ctlr_info_t *h)
+{
+	__u32 trans_support;
+
+	dev_dbg(&h->pdev->dev, "Trying to put board into Performant mode\n");
+	/* Attempt to put controller into performant mode if supported */
+	/* Does board support performant mode? */
+	trans_support = readl(&(h->cfgtable->TransportSupport));
+	if (!(trans_support & PERFORMANT_MODE))
+		return;
+
+	printk(KERN_WARNING "cciss%d: Placing controller into "
+				"performant mode\n", h->ctlr);
+	/* Performant mode demands commands on a 32 byte boundary
+	 * pci_alloc_consistent aligns on page boundarys already.
+	 * Just need to check if divisible by 32
+	 */
+	if ((sizeof(CommandList_struct) % 32) != 0) {
+		printk(KERN_WARNING "%s %d %s\n",
+			"cciss info: command size[",
+			(int)sizeof(CommandList_struct),
+			"] not divisible by 32, no performant mode..\n");
 		return;
 	}
 
+	/* Performant mode ring buffer and supporting data structures */
+	h->reply_pool = (__u64 *)pci_alloc_consistent(
+		h->pdev, h->max_commands * sizeof(__u64),
+		&(h->reply_pool_dhandle));
+
+	/* Need a block fetch table for performant mode */
+	h->blockFetchTable = kmalloc(((h->maxsgentries+1) *
+		sizeof(__u32)), GFP_KERNEL);
+
+	if ((h->reply_pool == NULL) || (h->blockFetchTable == NULL))
+		goto clean_up;
+
+	cciss_enter_performant_mode(h);
+
 	/* Change the access methods to the performant access methods */
 	h->access = SA5_performant_access;
+	h->transMethod = CFGTBL_Trans_Performant;
 
 	return;
 clean_up:

