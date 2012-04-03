Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab2DCFic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 01:38:32 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:63720 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab2DCFia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 01:38:30 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        iss_storagedev@hp.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH] hpsa: cleanup bitops usage
Date: Tue,  3 Apr 2012 14:38:53 +0900
Message-Id: <1333431534-4595-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1333431534-4595-1-git-send-email-akinobu.mita@gmail.com>
References: <1333431534-4595-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Remove unnecessary correction of bit and address
- Use BITS_TO_LONGS macro to calculate bitmap size

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: iss_storagedev@hp.com
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/hpsa.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 500e20d..ddbf5fe 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2351,9 +2351,7 @@ static struct CommandList *cmd_alloc(struct ctlr_info *h)
 		i = find_first_zero_bit(h->cmd_pool_bits, h->nr_cmds);
 		if (i == h->nr_cmds)
 			return NULL;
-	} while (test_and_set_bit
-		 (i & (BITS_PER_LONG - 1),
-		  h->cmd_pool_bits + (i / BITS_PER_LONG)) != 0);
+	} while (test_and_set_bit(i, h->cmd_pool_bits) != 0);
 	c = h->cmd_pool + i;
 	memset(c, 0, sizeof(*c));
 	cmd_dma_handle = h->cmd_pool_dhandle
@@ -2420,8 +2418,7 @@ static void cmd_free(struct ctlr_info *h, struct CommandList *c)
 	int i;
 
 	i = c - h->cmd_pool;
-	clear_bit(i & (BITS_PER_LONG - 1),
-		  h->cmd_pool_bits + (i / BITS_PER_LONG));
+	clear_bit(i, h->cmd_pool_bits);
 	h->nr_frees++;
 }
 
@@ -4045,8 +4042,7 @@ static __devinit int hpsa_init_reset_devices(struct pci_dev *pdev)
 
 static __devinit int hpsa_allocate_cmd_pool(struct ctlr_info *h)
 {
-	h->cmd_pool_bits = kzalloc(
-		DIV_ROUND_UP(h->nr_cmds, BITS_PER_LONG) *
+	h->cmd_pool_bits = kzalloc(BITS_TO_LONGS(h->nr_cmds) *
 		sizeof(unsigned long), GFP_KERNEL);
 	h->cmd_pool = pci_alloc_consistent(h->pdev,
 		    h->nr_cmds * sizeof(*h->cmd_pool),
-- 
1.7.4.4

