Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab1ECTxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 15:53:08 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:38843 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab1ECTxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 15:53:06 -0400
Subject: [PATCH 03/16] cciss: factor out command pool allocation functions
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Date: Tue, 03 May 2011 14:53:05 -0500
Message-ID: <20110503195305.5154.73383.stgit@beardog.cce.hp.com>
In-Reply-To: <20110503194919.5154.78352.stgit@beardog.cce.hp.com>
References: <20110503194919.5154.78352.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   67 ++++++++++++++++++++++++++-----------------------
 1 files changed, 36 insertions(+), 31 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index ed6aa83..152cb40 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4653,6 +4653,39 @@ static __devinit int cciss_init_reset_devices(struct pci_dev *pdev)
 	return 0;
 }
 
+static __devinit int cciss_allocate_cmd_pool(ctlr_info_t *h)
+{
+	h->cmd_pool_bits = kmalloc(
+		DIV_ROUND_UP(h->nr_cmds, BITS_PER_LONG) *
+		sizeof(unsigned long), GFP_KERNEL);
+	h->cmd_pool = pci_alloc_consistent(h->pdev,
+		h->nr_cmds * sizeof(CommandList_struct),
+		&(h->cmd_pool_dhandle));
+	h->errinfo_pool = pci_alloc_consistent(h->pdev,
+		h->nr_cmds * sizeof(ErrorInfo_struct),
+		&(h->errinfo_pool_dhandle));
+	if ((h->cmd_pool_bits == NULL)
+		|| (h->cmd_pool == NULL)
+		|| (h->errinfo_pool == NULL)) {
+		dev_err(&h->pdev->dev, "out of memory");
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static void cciss_free_cmd_pool(ctlr_info_t *h)
+{
+	kfree(h->cmd_pool_bits);
+	if (h->cmd_pool)
+		pci_free_consistent(h->pdev,
+			h->nr_cmds * sizeof(CommandList_struct),
+			h->cmd_pool, h->cmd_pool_dhandle);
+	if (h->errinfo_pool)
+		pci_free_consistent(h->pdev,
+			h->nr_cmds * sizeof(ErrorInfo_struct),
+			h->errinfo_pool, h->errinfo_pool_dhandle);
+}
+
 /*
  *  This is it.  Find all the controllers and register them.  I really hate
  *  stealing all these major device numbers.
@@ -4745,23 +4778,8 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	       h->devname, pdev->device, pci_name(pdev),
 	       h->intr[PERF_MODE_INT], dac ? "" : " not");
 
-	h->cmd_pool_bits =
-	    kmalloc(DIV_ROUND_UP(h->nr_cmds, BITS_PER_LONG)
-			* sizeof(unsigned long), GFP_KERNEL);
-	h->cmd_pool = (CommandList_struct *)
-	    pci_alloc_consistent(h->pdev,
-		    h->nr_cmds * sizeof(CommandList_struct),
-		    &(h->cmd_pool_dhandle));
-	h->errinfo_pool = (ErrorInfo_struct *)
-	    pci_alloc_consistent(h->pdev,
-		    h->nr_cmds * sizeof(ErrorInfo_struct),
-		    &(h->errinfo_pool_dhandle));
-	if ((h->cmd_pool_bits == NULL)
-	    || (h->cmd_pool == NULL)
-	    || (h->errinfo_pool == NULL)) {
-		dev_err(&h->pdev->dev, "out of memory");
+	if (cciss_allocate_cmd_pool(h))
 		goto clean4;
-	}
 
 	/* Need space for temp scatter list */
 	h->scatter_list = kmalloc(h->max_commands *
@@ -4837,21 +4855,12 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	return 1;
 
 clean4:
-	kfree(h->cmd_pool_bits);
+	cciss_free_cmd_pool(h);
 	/* Free up sg elements */
 	for (k-- ; k >= 0; k--)
 		kfree(h->scatter_list[k]);
 	kfree(h->scatter_list);
 	cciss_free_sg_chain_blocks(h->cmd_sg_list, h->nr_cmds);
-	if (h->cmd_pool)
-		pci_free_consistent(h->pdev,
-				    h->nr_cmds * sizeof(CommandList_struct),
-				    h->cmd_pool, h->cmd_pool_dhandle);
-	if (h->errinfo_pool)
-		pci_free_consistent(h->pdev,
-				    h->nr_cmds * sizeof(ErrorInfo_struct),
-				    h->errinfo_pool,
-				    h->errinfo_pool_dhandle);
 	free_irq(h->intr[PERF_MODE_INT], h);
 clean2:
 	unregister_blkdev(h->major, h->devname);
@@ -4949,11 +4958,7 @@ static void __devexit cciss_remove_one(struct pci_dev *pdev)
 	iounmap(h->cfgtable);
 	iounmap(h->vaddr);
 
-	pci_free_consistent(h->pdev, h->nr_cmds * sizeof(CommandList_struct),
-			    h->cmd_pool, h->cmd_pool_dhandle);
-	pci_free_consistent(h->pdev, h->nr_cmds * sizeof(ErrorInfo_struct),
-			    h->errinfo_pool, h->errinfo_pool_dhandle);
-	kfree(h->cmd_pool_bits);
+	cciss_free_cmd_pool(h);
 	/* Free up sg elements */
 	for (j = 0; j < h->nr_cmds; j++)
 		kfree(h->scatter_list[j]);

