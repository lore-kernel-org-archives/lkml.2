Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965239Ab0GSSjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:39:33 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:11400 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936551Ab0GSSj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:39:29 -0400
Subject: [PATCH 04/26] cciss: factor out cciss_board_disabled
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Mon, 19 Jul 2010 13:45:00 -0500
Message-ID: <20100719184500.7908.48285.stgit@beardog.cce.hp.com>
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

cciss: factor out cciss_board_disabled

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index d4167c2..808d2a5 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4002,9 +4002,16 @@ static int __devinit cciss_lookup_board_id(struct pci_dev *pdev, u32 *board_id)
 	return -ENODEV;
 }
 
+static inline bool cciss_board_disabled(ctlr_info_t *h)
+{
+	u16 command;
+
+	(void) pci_read_config_word(h->pdev, PCI_COMMAND, &command);
+	return ((command & PCI_COMMAND_MEMORY) == 0);
+}
+
 static int __devinit cciss_pci_init(ctlr_info_t *c)
 {
-	ushort command;
 	__u32 scratchpad = 0;
 	__u64 cfg_offset;
 	__u32 cfg_base_addr;
@@ -4018,15 +4025,11 @@ static int __devinit cciss_pci_init(ctlr_info_t *c)
 	c->product_name = products[prod_index].product_name;
 	c->access = *(products[prod_index].access);
 
-	/* check to see if controller has been disabled */
-	/* BEFORE trying to enable it */
-	(void)pci_read_config_word(c->pdev, PCI_COMMAND, &command);
-	if (!(command & 0x02)) {
+	if (cciss_board_disabled(c)) {
 		printk(KERN_WARNING
 		       "cciss: controller appears to be disabled\n");
 		return -ENODEV;
 	}
-
 	err = pci_enable_device(c->pdev);
 	if (err) {
 		printk(KERN_ERR "cciss: Unable to Enable PCI device\n");

