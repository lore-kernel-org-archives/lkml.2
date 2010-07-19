Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965627Ab0GSSj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:39:59 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:26498 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965478Ab0GSSjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:39:49 -0400
Subject: [PATCH 08/26] cciss: factor out cciss_find_cfgtables
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Mon, 19 Jul 2010 13:45:21 -0500
Message-ID: <20100719184521.7908.18837.stgit@beardog.cce.hp.com>
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

cciss: factor out cciss_find_cfgtables

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   68 +++++++++++++++++++++++++------------------------
 1 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 286c81d..c297d31 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4041,13 +4041,40 @@ static int __devinit cciss_wait_for_board_ready(ctlr_info_t *h)
 	return -ENODEV;
 }
 
+static int __devinit cciss_find_cfgtables(ctlr_info_t *h)
+{
+	u64 cfg_offset;
+	u32 cfg_base_addr;
+	u64 cfg_base_addr_index;
+	u32 trans_offset;
+
+	/* get the address index number */
+	cfg_base_addr = readl(h->vaddr + SA5_CTCFG_OFFSET);
+	cfg_base_addr &= (u32) 0x0000ffff;
+	cfg_base_addr_index = find_PCI_BAR_index(h->pdev, cfg_base_addr);
+	if (cfg_base_addr_index == -1) {
+		dev_warn(&h->pdev->dev, "cannot find cfg_base_addr_index\n");
+		return -ENODEV;
+	}
+	cfg_offset = readl(h->vaddr + SA5_CTMEM_OFFSET);
+	h->cfgtable = remap_pci_mem(pci_resource_start(h->pdev,
+			       cfg_base_addr_index) + cfg_offset,
+				sizeof(h->cfgtable));
+	if (!h->cfgtable)
+		return -ENOMEM;
+	/* Find performant mode table. */
+	trans_offset = readl(&(h->cfgtable->TransMethodOffset));
+	h->transtable = remap_pci_mem(pci_resource_start(h->pdev,
+				cfg_base_addr_index)+cfg_offset+trans_offset,
+				sizeof(*h->transtable));
+	if (!h->transtable)
+		return -ENOMEM;
+	return 0;
+}
+
 static int __devinit cciss_pci_init(ctlr_info_t *c)
 {
-	__u64 cfg_offset;
-	__u32 cfg_base_addr;
-	__u64 cfg_base_addr_index;
-	__u32 trans_offset;
-	int i, prod_index, err;
+	int prod_index, err;
 
 	prod_index = cciss_lookup_board_id(c->pdev, &c->board_id);
 	if (prod_index < 0)
@@ -4090,36 +4117,9 @@ static int __devinit cciss_pci_init(ctlr_info_t *c)
 	err = cciss_wait_for_board_ready(c);
 	if (err)
 		goto err_out_free_res;
-
-	/* get the address index number */
-	cfg_base_addr = readl(c->vaddr + SA5_CTCFG_OFFSET);
-	cfg_base_addr &= (__u32) 0x0000ffff;
-#ifdef CCISS_DEBUG
-	printk("cfg base address = %x\n", cfg_base_addr);
-#endif				/* CCISS_DEBUG */
-	cfg_base_addr_index = find_PCI_BAR_index(c->pdev, cfg_base_addr);
-#ifdef CCISS_DEBUG
-	printk("cfg base address index = %llx\n",
-		(unsigned long long)cfg_base_addr_index);
-#endif				/* CCISS_DEBUG */
-	if (cfg_base_addr_index == -1) {
-		printk(KERN_WARNING "cciss: Cannot find cfg_base_addr_index\n");
-		err = -ENODEV;
+	err = cciss_find_cfgtables(c);
+	if (err)
 		goto err_out_free_res;
-	}
-
-	cfg_offset = readl(c->vaddr + SA5_CTMEM_OFFSET);
-#ifdef CCISS_DEBUG
-	printk("cfg offset = %llx\n", (unsigned long long)cfg_offset);
-#endif				/* CCISS_DEBUG */
-	c->cfgtable = remap_pci_mem(pci_resource_start(c->pdev,
-						       cfg_base_addr_index) +
-				    cfg_offset, sizeof(CfgTable_struct));
-	/* Find performant mode table. */
-	trans_offset = readl(&(c->cfgtable->TransMethodOffset));
-	c->transtable = remap_pci_mem(pci_resource_start(c->pdev,
-		cfg_base_addr_index) + cfg_offset+trans_offset,
-		sizeof(*c->transtable));
 #ifdef CCISS_DEBUG
 	print_cfg_table(c->cfgtable);
 #endif				/* CCISS_DEBUG */

