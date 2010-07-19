Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965739Ab0GSSkG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:40:06 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:26040 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965636Ab0GSSkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:40:00 -0400
Subject: [PATCH 10/26] cciss: factor out cciss_find_board_params
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Mon, 19 Jul 2010 13:45:31 -0500
Message-ID: <20100719184531.7908.8575.stgit@beardog.cce.hp.com>
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

cciss: factor out cciss_find_board_params

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   52 ++++++++++++++++++++++++-------------------------
 1 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index b702471..97feb50 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4072,6 +4072,30 @@ static int __devinit cciss_find_cfgtables(ctlr_info_t *h)
 	return 0;
 }
 
+/* Interrogate the hardware for some limits:
+ * max commands, max SG elements without chaining, and with chaining,
+ * SG chain block size, etc.
+ */
+static void __devinit cciss_find_board_params(ctlr_info_t *h)
+{
+	h->max_commands = readl(&(h->cfgtable->MaxPerformantModeCommands));
+	h->nr_cmds = h->max_commands - 4; /* Allow room for some ioctls */
+	h->maxsgentries = readl(&(h->cfgtable->MaxSGElements));
+	/*
+	 * Limit in-command s/g elements to 32 save dma'able memory.
+	 * Howvever spec says if 0, use 31
+	 */
+	h->max_cmd_sgentries = 31;
+	if (h->maxsgentries > 512) {
+		h->max_cmd_sgentries = 32;
+		h->chainsize = h->maxsgentries - h->max_cmd_sgentries + 1;
+		h->maxsgentries--; /* save one for chain pointer */
+	} else {
+		h->maxsgentries = 31; /* default to traditional values */
+		h->chainsize = 0;
+	}
+}
+
 static int __devinit cciss_pci_init(ctlr_info_t *c)
 {
 	int prod_index, err;
@@ -4127,34 +4151,8 @@ static int __devinit cciss_pci_init(ctlr_info_t *c)
 #ifdef CCISS_DEBUG
 	print_cfg_table(c->cfgtable);
 #endif				/* CCISS_DEBUG */
+	cciss_find_board_params(c);
 
-	/* Some controllers support Zero Memory Raid (ZMR).
-	 * When configured in ZMR mode the number of supported
-	 * commands drops to 64. So instead of just setting an
-	 * arbitrary value we make the driver a little smarter.
-	 * We read the config table to tell us how many commands
-	 * are supported on the controller then subtract 4 to
-	 * leave a little room for ioctl calls.
-	 */
-	c->max_commands = readl(&(c->cfgtable->MaxPerformantModeCommands));
-	c->maxsgentries = readl(&(c->cfgtable->MaxSGElements));
-
-	/*
-	 * Limit native command to 32 s/g elements to save dma'able memory.
-	 * Howvever spec says if 0, use 31
-	 */
-
-	c->max_cmd_sgentries = 31;
-	if (c->maxsgentries > 512) {
-		c->max_cmd_sgentries = 32;
-		c->chainsize = c->maxsgentries - c->max_cmd_sgentries + 1;
-		c->maxsgentries -= 1;   /* account for chain pointer */
-	} else {
-		c->maxsgentries = 31;   /* Default to traditional value */
-		c->chainsize = 0;       /* traditional */
-	}
-
-	c->nr_cmds = c->max_commands - 4;
 	if ((readb(&c->cfgtable->Signature[0]) != 'C') ||
 	    (readb(&c->cfgtable->Signature[1]) != 'I') ||
 	    (readb(&c->cfgtable->Signature[2]) != 'S') ||

