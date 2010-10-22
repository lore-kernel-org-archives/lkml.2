Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932851Ab0JVTVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:21:11 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:25105 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932848Ab0JVTVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:21:07 -0400
Subject: [PATCH 2/5] cciss: fix board status waiting code
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, smcameron@yahoo.com,
        linux-kernel@vger.kernel.org, mike.miller@hp.com, thenzl@redhat.com
Date: Fri, 22 Oct 2010 14:21:07 -0500
Message-ID: <20101022192107.25567.24172.stgit@beardog.cce.hp.com>
In-Reply-To: <20101022191738.25567.43468.stgit@beardog.cce.hp.com>
References: <20101022191738.25567.43468.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

After a reset, we should first wait for the board to become "not ready",
and then wait for it to become "ready", instead of immediately
waiting for it to become "ready", and do this waiting *after*
restoring PCI config space registers.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   43 +++++++++++++++++++++++++++++++++++--------
 drivers/block/cciss.h |    4 ++++
 2 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index dea1f2a..a9e9db4 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3966,18 +3966,31 @@ static int __devinit cciss_pci_find_memory_BAR(struct pci_dev *pdev,
 	return -ENODEV;
 }
 
-static int __devinit cciss_wait_for_board_ready(ctlr_info_t *h)
+static int __devinit cciss_wait_for_board_state(struct pci_dev *pdev,
+	void __iomem *vaddr, int wait_for_ready)
+#define BOARD_READY 1
+#define BOARD_NOT_READY 0
 {
-	int i;
+	int i, iterations;
 	u32 scratchpad;
 
-	for (i = 0; i < CCISS_BOARD_READY_ITERATIONS; i++) {
-		scratchpad = readl(h->vaddr + SA5_SCRATCHPAD_OFFSET);
-		if (scratchpad == CCISS_FIRMWARE_READY)
-			return 0;
+	if (wait_for_ready)
+		iterations = CCISS_BOARD_READY_ITERATIONS;
+	else
+		iterations = CCISS_BOARD_NOT_READY_ITERATIONS;
+
+	for (i = 0; i < iterations; i++) {
+		scratchpad = readl(vaddr + SA5_SCRATCHPAD_OFFSET);
+		if (wait_for_ready) {
+			if (scratchpad == CCISS_FIRMWARE_READY)
+				return 0;
+		} else {
+			if (scratchpad != CCISS_FIRMWARE_READY)
+				return 0;
+		}
 		msleep(CCISS_BOARD_READY_POLL_INTERVAL_MSECS);
 	}
-	dev_warn(&h->pdev->dev, "board not ready, timed out.\n");
+	dev_warn(&pdev->dev, "board not ready, timed out.\n");
 	return -ENODEV;
 }
 
@@ -4143,7 +4156,7 @@ static int __devinit cciss_pci_init(ctlr_info_t *h)
 		err = -ENOMEM;
 		goto err_out_free_res;
 	}
-	err = cciss_wait_for_board_ready(h);
+	err = cciss_wait_for_board_state(h->pdev, h->vaddr, BOARD_READY);
 	if (err)
 		goto err_out_free_res;
 	err = cciss_find_cfgtables(h);
@@ -4488,6 +4501,20 @@ static __devinit int cciss_kdump_hard_reset_controller(struct pci_dev *pdev)
 	   need a little pause here */
 	msleep(CCISS_POST_RESET_PAUSE_MSECS);
 
+	/* Wait for board to become not ready, then ready. */
+	dev_info(&pdev->dev, "Waiting for board to become ready.\n");
+	rc = cciss_wait_for_board_state(pdev, vaddr, BOARD_NOT_READY);
+	if (rc) /* Don't bail, might be E500, etc. which can't be reset */
+		dev_warn(&pdev->dev,
+			"failed waiting for board to become not ready\n");
+	rc = cciss_wait_for_board_state(pdev, vaddr, BOARD_READY);
+	if (rc) {
+		dev_warn(&pdev->dev,
+			"failed waiting for board to become ready\n");
+		goto unmap_cfgtable;
+	}
+	dev_info(&pdev->dev, "board ready.\n");
+
 	/* Controller should be in simple mode at this point.  If it's not,
 	 * It means we're on one of those controllers which doesn't support
 	 * the doorbell reset method and on which the PCI power management reset
diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index ae340ff..4b8933d 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -200,10 +200,14 @@ struct ctlr_info
  * the above.
  */
 #define CCISS_BOARD_READY_WAIT_SECS (120)
+#define CCISS_BOARD_NOT_READY_WAIT_SECS (10)
 #define CCISS_BOARD_READY_POLL_INTERVAL_MSECS (100)
 #define CCISS_BOARD_READY_ITERATIONS \
 	((CCISS_BOARD_READY_WAIT_SECS * 1000) / \
 		CCISS_BOARD_READY_POLL_INTERVAL_MSECS)
+#define CCISS_BOARD_NOT_READY_ITERATIONS \
+	((CCISS_BOARD_NOT_READY_WAIT_SECS * 1000) / \
+		CCISS_BOARD_READY_POLL_INTERVAL_MSECS)
 #define CCISS_POST_RESET_PAUSE_MSECS (3000)
 #define CCISS_POST_RESET_NOOP_INTERVAL_MSECS (1000)
 #define CCISS_POST_RESET_NOOP_RETRIES (12)

