Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966393Ab0GSSlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:41:17 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:44156 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966380Ab0GSSlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:41:03 -0400
Subject: [PATCH 22/26] cciss: forbid hard reset of 640x boards
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Mon, 19 Jul 2010 13:46:33 -0500
Message-ID: <20100719184633.7908.96341.stgit@beardog.cce.hp.com>
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

cciss: forbid hard reset of 640x boards
The 6402/6404 are two PCI devices -- two Smart Array controllers
-- that fit into one slot.  It is possible to reset them independently,
however, they share a battery backed cache module.  One of the pair
controls the cache and the 2nd one access the cache through the first
one.  If you reset the one controlling the cache, the other one will
not be a happy camper.  So we just forbid resetting this conjoined
mess.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 6d4c4f2..2abe6df 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4495,6 +4495,7 @@ static __devinit int cciss_kdump_hard_reset_controller(struct pci_dev *pdev)
 	int rc, i;
 	CfgTable_struct __iomem *cfgtable;
 	bool use_doorbell;
+	u32 board_id;
 
 	/* For controllers as old a the p600, this is very nearly
 	 * the same thing as
@@ -4517,6 +4518,19 @@ static __devinit int cciss_kdump_hard_reset_controller(struct pci_dev *pdev)
 	 * using the doorbell register.
 	 */
 
+	/* Exclude 640x boards.  These are two pci devices in one slot
+	 * which share a battery backed cache module.  One controls the
+	 * cache, the other accesses the cache through the one that controls
+	 * it.  If we reset the one controlling the cache, the other will
+	 * likely not be happy.  Just forbid resetting this conjoined mess.
+	 */
+	cciss_lookup_board_id(pdev, &board_id);
+	if (board_id == 0x409C0E11 || board_id == 0x409D0E11) {
+		dev_warn(&pdev->dev, "Cannot reset Smart Array 640x "
+				"due to shared cache module.");
+		return -ENODEV;
+	}
+
 	for (i = 0; i < 32; i++)
 		pci_read_config_word(pdev, 2*i, &saved_config_space[i]);
 
@@ -4600,7 +4614,8 @@ static __devinit int cciss_init_reset_devices(struct pci_dev *pdev)
 
 	/* -ENOTSUPP here means we cannot reset the controller
 	 * but it's already (and still) up and running in
-	 * "performant mode".
+	 * "performant mode".  Or, it might be 640x, which can't reset
+	 * due to concerns about shared bbwc between 6402/6404 pair.
 	 */
 	if (rc == -ENOTSUPP)
 		return 0; /* just try to do the kdump anyhow. */

