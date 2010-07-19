Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966342Ab0GSSo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:44:58 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:26532 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965267Ab0GSSjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:39:54 -0400
Subject: [PATCH 09/26] cciss: fix leak of ioremapped memory
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Mon, 19 Jul 2010 13:45:26 -0500
Message-ID: <20100719184526.7908.43912.stgit@beardog.cce.hp.com>
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

cciss: fix leak of ioremapped memory
in cciss_pci_init error path.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index c297d31..b702471 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4114,6 +4114,10 @@ static int __devinit cciss_pci_init(ctlr_info_t *c)
 	if (err)
 		goto err_out_free_res;
 	c->vaddr = remap_pci_mem(c->paddr, 0x250);
+	if (!c->vaddr) {
+		err = -ENOMEM;
+		goto err_out_free_res;
+	}
 	err = cciss_wait_for_board_ready(c);
 	if (err)
 		goto err_out_free_res;
@@ -4198,6 +4202,12 @@ err_out_free_res:
 	 * Deliberately omit pci_disable_device(): it does something nasty to
 	 * Smart Array controllers that pci_enable_device does not undo
 	 */
+	if (c->transtable)
+		iounmap(c->transtable);
+	if (c->cfgtable)
+		iounmap(c->cfgtable);
+	if (c->vaddr)
+		iounmap(c->vaddr);
 	pci_release_regions(c->pdev);
 	return err;
 }
@@ -4745,6 +4755,8 @@ static void __devexit cciss_remove_one(struct pci_dev *pdev)
 		pci_disable_msi(hba[i]->pdev);
 #endif				/* CONFIG_PCI_MSI */
 
+	iounmap(hba[i]->transtable);
+	iounmap(hba[i]->cfgtable);
 	iounmap(hba[i]->vaddr);
 
 	pci_free_consistent(hba[i]->pdev, hba[i]->nr_cmds * sizeof(CommandList_struct),

