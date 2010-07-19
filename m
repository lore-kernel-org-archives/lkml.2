Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966372Ab0GSSk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:40:56 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:44048 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966343Ab0GSSkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:40:46 -0400
Subject: [PATCH 19/26] cciss: factor out cciss_reset_devices()
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Mon, 19 Jul 2010 13:46:17 -0500
Message-ID: <20100719184617.7908.11800.stgit@beardog.cce.hp.com>
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

cciss: factor out cciss_reset_devices()

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   51 ++++++++++++++++++++++++++++++-------------------
 drivers/block/cciss.h |    3 +++
 2 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 3cd8397..f49dcd7 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4486,6 +4486,34 @@ static __devinit int cciss_hard_reset_controller(struct pci_dev *pdev)
 	return 0;
 }
 
+static __devinit int cciss_init_reset_devices(struct pci_dev *pdev)
+{
+	int i;
+
+	if (!reset_devices)
+		return 0;
+
+	/* Reset the controller with a PCI power-cycle */
+	if (cciss_hard_reset_controller(pdev) || cciss_reset_msi(pdev))
+		return -ENODEV;
+
+	/* Some devices (notably the HP Smart Array 5i Controller)
+	   need a little pause here */
+	msleep(CCISS_POST_RESET_PAUSE_MSECS);
+
+	/* Now try to get the controller to respond to a no-op */
+	for (i = 0; i < CCISS_POST_RESET_NOOP_RETRIES; i++) {
+		if (cciss_noop(pdev) == 0)
+			break;
+		else
+			dev_warn(&pdev->dev, "no-op failed%s\n",
+				(i < CCISS_POST_RESET_NOOP_RETRIES - 1 ?
+					"; re-trying" : ""));
+		msleep(CCISS_POST_RESET_NOOP_INTERVAL_MSECS);
+	}
+	return 0;
+}
+
 /*
  *  This is it.  Find all the controllers and register them.  I really hate
  *  stealing all these major device numbers.
@@ -4501,26 +4529,9 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	int dac, return_code;
 	InquiryData_struct *inq_buff;
 
-	if (reset_devices) {
-		/* Reset the controller with a PCI power-cycle */
-		if (cciss_hard_reset_controller(pdev) || cciss_reset_msi(pdev))
-			return -ENODEV;
-
-		/* Now try to get the controller to respond to a no-op. Some
-		   devices (notably the HP Smart Array 5i Controller) need
-		   up to 30 seconds to respond. */
-		for (i=0; i<30; i++) {
-			if (cciss_noop(pdev) == 0)
-				break;
-
-			schedule_timeout_uninterruptible(HZ);
-		}
-		if (i == 30) {
-			printk(KERN_ERR "cciss: controller seems dead\n");
-			return -EBUSY;
-		}
-	}
-
+	rc = cciss_init_reset_devices(pdev);
+	if (rc)
+		return rc;
 	i = alloc_cciss_hba();
 	if (i < 0)
 		return -1;
diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index c2ef9dd..4290b7f 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -204,6 +204,9 @@ struct ctlr_info
 #define CCISS_BOARD_READY_ITERATIONS \
 	((CCISS_BOARD_READY_WAIT_SECS * 1000) / \
 		CCISS_BOARD_READY_POLL_INTERVAL_MSECS)
+#define CCISS_POST_RESET_PAUSE_MSECS (3000)
+#define CCISS_POST_RESET_NOOP_INTERVAL_MSECS (1000)
+#define CCISS_POST_RESET_NOOP_RETRIES (12)
 
 /* 
 	Send the command to the hardware 

