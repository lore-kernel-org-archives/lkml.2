Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab1ECTxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 15:53:15 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:38872 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab1ECTxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 15:53:11 -0400
Subject: [PATCH 04/16] cciss: factor out scatterlist allocation functions
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Date: Tue, 03 May 2011 14:53:10 -0500
Message-ID: <20110503195310.5154.52073.stgit@beardog.cce.hp.com>
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
 drivers/block/cciss.c |   55 +++++++++++++++++++++++++++++++------------------
 1 files changed, 35 insertions(+), 20 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 152cb40..55ca1f4 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4673,6 +4673,39 @@ static __devinit int cciss_allocate_cmd_pool(ctlr_info_t *h)
 	return 0;
 }
 
+static __devinit int cciss_allocate_scatterlists(ctlr_info_t *h)
+{
+	int i;
+
+	/* zero it, so that on free we need not know how many were alloc'ed */
+	h->scatter_list = kzalloc(h->max_commands *
+				sizeof(struct scatterlist *), GFP_KERNEL);
+	if (!h->scatter_list)
+		return -ENOMEM;
+
+	for (i = 0; i < h->nr_cmds; i++) {
+		h->scatter_list[i] = kmalloc(sizeof(struct scatterlist) *
+						h->maxsgentries, GFP_KERNEL);
+		if (h->scatter_list[i] == NULL) {
+			dev_err(&h->pdev->dev, "could not allocate "
+				"s/g lists\n");
+			return -ENOMEM;
+		}
+	}
+	return 0;
+}
+
+static void cciss_free_scatterlists(ctlr_info_t *h)
+{
+	int i;
+
+	if (h->scatter_list) {
+		for (i = 0; i < h->nr_cmds; i++)
+			kfree(h->scatter_list[i]);
+		kfree(h->scatter_list);
+	}
+}
+
 static void cciss_free_cmd_pool(ctlr_info_t *h)
 {
 	kfree(h->cmd_pool_bits);
@@ -4696,7 +4729,6 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 {
 	int i;
 	int j = 0;
-	int k = 0;
 	int rc;
 	int dac, return_code;
 	InquiryData_struct *inq_buff;
@@ -4781,23 +4813,9 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	if (cciss_allocate_cmd_pool(h))
 		goto clean4;
 
-	/* Need space for temp scatter list */
-	h->scatter_list = kmalloc(h->max_commands *
-						sizeof(struct scatterlist *),
-						GFP_KERNEL);
-	if (!h->scatter_list)
+	if (cciss_allocate_scatterlists(h))
 		goto clean4;
 
-	for (k = 0; k < h->nr_cmds; k++) {
-		h->scatter_list[k] = kmalloc(sizeof(struct scatterlist) *
-							h->maxsgentries,
-							GFP_KERNEL);
-		if (h->scatter_list[k] == NULL) {
-			dev_err(&h->pdev->dev,
-				"could not allocate s/g lists\n");
-			goto clean4;
-		}
-	}
 	h->cmd_sg_list = cciss_allocate_sg_chain_blocks(h,
 		h->chainsize, h->nr_cmds);
 	if (!h->cmd_sg_list && h->chainsize > 0)
@@ -4856,10 +4874,7 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 
 clean4:
 	cciss_free_cmd_pool(h);
-	/* Free up sg elements */
-	for (k-- ; k >= 0; k--)
-		kfree(h->scatter_list[k]);
-	kfree(h->scatter_list);
+	cciss_free_scatterlists(h);
 	cciss_free_sg_chain_blocks(h->cmd_sg_list, h->nr_cmds);
 	free_irq(h->intr[PERF_MODE_INT], h);
 clean2:

