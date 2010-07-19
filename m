Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965539Ab0GSSjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:39:53 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:25986 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965267Ab0GSSjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:39:44 -0400
Subject: [PATCH 07/26] cciss: factor out cciss_wait_for_board_ready()
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Mon, 19 Jul 2010 13:45:15 -0500
Message-ID: <20100719184515.7908.55471.stgit@beardog.cce.hp.com>
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

cciss: factor out cciss_wait_for_board_ready()

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   32 +++++++++++++++++---------------
 drivers/block/cciss.h |   15 +++++++++++++++
 2 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 9c9c79c..286c81d 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4026,9 +4026,23 @@ static int __devinit cciss_pci_find_memory_BAR(struct pci_dev *pdev,
 	return -ENODEV;
 }
 
+static int __devinit cciss_wait_for_board_ready(ctlr_info_t *h)
+{
+	int i;
+	u32 scratchpad;
+
+	for (i = 0; i < CCISS_BOARD_READY_ITERATIONS; i++) {
+		scratchpad = readl(h->vaddr + SA5_SCRATCHPAD_OFFSET);
+		if (scratchpad == CCISS_FIRMWARE_READY)
+			return 0;
+		msleep(CCISS_BOARD_READY_POLL_INTERVAL_MSECS);
+	}
+	dev_warn(&h->pdev->dev, "board not ready, timed out.\n");
+	return -ENODEV;
+}
+
 static int __devinit cciss_pci_init(ctlr_info_t *c)
 {
-	__u32 scratchpad = 0;
 	__u64 cfg_offset;
 	__u32 cfg_base_addr;
 	__u64 cfg_base_addr_index;
@@ -4073,21 +4087,9 @@ static int __devinit cciss_pci_init(ctlr_info_t *c)
 	if (err)
 		goto err_out_free_res;
 	c->vaddr = remap_pci_mem(c->paddr, 0x250);
-
-	/* Wait for the board to become ready.  (PCI hotplug needs this.)
-	 * We poll for up to 120 secs, once per 100ms. */
-	for (i = 0; i < 1200; i++) {
-		scratchpad = readl(c->vaddr + SA5_SCRATCHPAD_OFFSET);
-		if (scratchpad == CCISS_FIRMWARE_READY)
-			break;
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(msecs_to_jiffies(100));	/* wait 100ms */
-	}
-	if (scratchpad != CCISS_FIRMWARE_READY) {
-		printk(KERN_WARNING "cciss: Board not ready.  Timed out.\n");
-		err = -ENODEV;
+	err = cciss_wait_for_board_ready(c);
+	if (err)
 		goto err_out_free_res;
-	}
 
 	/* get the address index number */
 	cfg_base_addr = readl(c->vaddr + SA5_CTCFG_OFFSET);
diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index 8a9f5b5..c2ef9dd 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -190,6 +190,21 @@ struct ctlr_info
 
 #define CCISS_INTR_ON 	1 
 #define CCISS_INTR_OFF	0
+
+
+/* CCISS_BOARD_READY_WAIT_SECS is how long to wait for a board
+ * to become ready, in seconds, before giving up on it.
+ * CCISS_BOARD_READY_POLL_INTERVAL_MSECS * is how long to wait
+ * between polling the board to see if it is ready, in
+ * milliseconds.  CCISS_BOARD_READY_ITERATIONS is derived
+ * the above.
+ */
+#define CCISS_BOARD_READY_WAIT_SECS (120)
+#define CCISS_BOARD_READY_POLL_INTERVAL_MSECS (100)
+#define CCISS_BOARD_READY_ITERATIONS \
+	((CCISS_BOARD_READY_WAIT_SECS * 1000) / \
+		CCISS_BOARD_READY_POLL_INTERVAL_MSECS)
+
 /* 
 	Send the command to the hardware 
 */

