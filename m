Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab2DCFiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 01:38:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59525 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab2DCFiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 01:38:23 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Mike Miller <mike.miller@hp.com>,
        iss_storagedev@hp.com
Subject: [PATCH] cciss: cleanup bitops usage
Date: Tue,  3 Apr 2012 14:38:51 +0900
Message-Id: <1333431534-4595-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Remove unnecessary correction of bit and address
- Use BITS_TO_LONGS macro to calculate bitmap size
- Use bitmap_zero()

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mike Miller <mike.miller@hp.com>
Cc: iss_storagedev@hp.com
---
 drivers/block/cciss.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index b0f553b..bda6d12 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -41,6 +41,7 @@
 #include <linux/spinlock.h>
 #include <linux/compat.h>
 #include <linux/mutex.h>
+#include <linux/bitmap.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
@@ -978,8 +979,7 @@ static CommandList_struct *cmd_alloc(ctlr_info_t *h)
 		i = find_first_zero_bit(h->cmd_pool_bits, h->nr_cmds);
 		if (i == h->nr_cmds)
 			return NULL;
-	} while (test_and_set_bit(i & (BITS_PER_LONG - 1),
-		  h->cmd_pool_bits + (i / BITS_PER_LONG)) != 0);
+	} while (test_and_set_bit(i, h->cmd_pool_bits) != 0);
 	c = h->cmd_pool + i;
 	memset(c, 0, sizeof(CommandList_struct));
 	cmd_dma_handle = h->cmd_pool_dhandle + i * sizeof(CommandList_struct);
@@ -1046,8 +1046,7 @@ static void cmd_free(ctlr_info_t *h, CommandList_struct *c)
 	int i;
 
 	i = c - h->cmd_pool;
-	clear_bit(i & (BITS_PER_LONG - 1),
-		  h->cmd_pool_bits + (i / BITS_PER_LONG));
+	clear_bit(i, h->cmd_pool_bits);
 	h->nr_frees++;
 }
 
@@ -4812,8 +4811,7 @@ static __devinit int cciss_init_reset_devices(struct pci_dev *pdev)
 
 static __devinit int cciss_allocate_cmd_pool(ctlr_info_t *h)
 {
-	h->cmd_pool_bits = kmalloc(
-		DIV_ROUND_UP(h->nr_cmds, BITS_PER_LONG) *
+	h->cmd_pool_bits = kmalloc(BITS_TO_LONGS(h->nr_cmds) *
 		sizeof(unsigned long), GFP_KERNEL);
 	h->cmd_pool = pci_alloc_consistent(h->pdev,
 		h->nr_cmds * sizeof(CommandList_struct),
@@ -5068,9 +5066,7 @@ reinit_after_soft_reset:
 	pci_set_drvdata(pdev, h);
 	/* command and error info recs zeroed out before
 	   they are used */
-	memset(h->cmd_pool_bits, 0,
-	       DIV_ROUND_UP(h->nr_cmds, BITS_PER_LONG)
-			* sizeof(unsigned long));
+	bitmap_zero(h->cmd_pool_bits, h->nr_cmds);
 
 	h->num_luns = 0;
 	h->highest_lun = -1;
-- 
1.7.4.4

