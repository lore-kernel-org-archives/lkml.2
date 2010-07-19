Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966358Ab0GSSku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:40:50 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:44004 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965904Ab0GSSkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:40:41 -0400
Subject: [PATCH 18/26] cciss: factor out cciss_find_cfg_addrs.
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Mon, 19 Jul 2010 13:46:12 -0500
Message-ID: <20100719184612.7908.34393.stgit@beardog.cce.hp.com>
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

Rationale for this is that I will also need to use this code
in fixing kdump host reset code prior to having the hba structure.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   35 +++++++++++++++++++++++------------
 1 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 17e420c..3cd8397 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4064,29 +4064,40 @@ static int __devinit cciss_wait_for_board_ready(ctlr_info_t *h)
 	return -ENODEV;
 }
 
+static int __devinit cciss_find_cfg_addrs(struct pci_dev *pdev,
+	void __iomem *vaddr, u32 *cfg_base_addr, u64 *cfg_base_addr_index,
+	u64 *cfg_offset)
+{
+	*cfg_base_addr = readl(vaddr + SA5_CTCFG_OFFSET);
+	*cfg_offset = readl(vaddr + SA5_CTMEM_OFFSET);
+	*cfg_base_addr &= (u32) 0x0000ffff;
+	*cfg_base_addr_index = find_PCI_BAR_index(pdev, *cfg_base_addr);
+	if (*cfg_base_addr_index == -1) {
+		dev_warn(&pdev->dev, "cannot find cfg_base_addr_index, "
+			"*cfg_base_addr = 0x%08x\n", *cfg_base_addr);
+		return -ENODEV;
+	}
+	return 0;
+}
+
 static int __devinit cciss_find_cfgtables(ctlr_info_t *h)
 {
 	u64 cfg_offset;
 	u32 cfg_base_addr;
 	u64 cfg_base_addr_index;
 	u32 trans_offset;
+	int rc;
 
-	/* get the address index number */
-	cfg_base_addr = readl(h->vaddr + SA5_CTCFG_OFFSET);
-	cfg_base_addr &= (u32) 0x0000ffff;
-	cfg_base_addr_index = find_PCI_BAR_index(h->pdev, cfg_base_addr);
-	if (cfg_base_addr_index == -1) {
-		dev_warn(&h->pdev->dev, "cannot find cfg_base_addr_index\n");
-		return -ENODEV;
-	}
-	cfg_offset = readl(h->vaddr + SA5_CTMEM_OFFSET);
+	rc = cciss_find_cfg_addrs(h->pdev, h->vaddr, &cfg_base_addr,
+		&cfg_base_addr_index, &cfg_offset);
+	if (rc)
+		return rc;
 	h->cfgtable = remap_pci_mem(pci_resource_start(h->pdev,
-			       cfg_base_addr_index) + cfg_offset,
-				sizeof(h->cfgtable));
+		cfg_base_addr_index) + cfg_offset, sizeof(h->cfgtable));
 	if (!h->cfgtable)
 		return -ENOMEM;
 	/* Find performant mode table. */
-	trans_offset = readl(&(h->cfgtable->TransMethodOffset));
+	trans_offset = readl(&h->cfgtable->TransMethodOffset);
 	h->transtable = remap_pci_mem(pci_resource_start(h->pdev,
 				cfg_base_addr_index)+cfg_offset+trans_offset,
 				sizeof(*h->transtable));

