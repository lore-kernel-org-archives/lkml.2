Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966416Ab0GSSoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:44:08 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:11748 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965813Ab0GSSkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:40:15 -0400
Subject: [PATCH 13/26] cciss: factor out cciss_p600_dma_prefetch_quirk()
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Mon, 19 Jul 2010 13:45:46 -0500
Message-ID: <20100719184546.7908.30204.stgit@beardog.cce.hp.com>
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

cciss: factor out cciss_p600_dma_prefetch_quirk()

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   37 +++++++++++++++++++------------------
 1 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index b4264bc..e1c2bf1 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4120,6 +4120,24 @@ static inline void cciss_enable_scsi_prefetch(ctlr_info_t *h)
 #endif
 }
 
+/* Disable DMA prefetch for the P600.  Otherwise an ASIC bug may result
+ * in a prefetch beyond physical memory.
+ */
+static inline void cciss_p600_dma_prefetch_quirk(ctlr_info_t *h)
+{
+	u32 dma_prefetch;
+	__u32 dma_refetch;
+
+	if (h->board_id != 0x3225103C)
+		return;
+	dma_prefetch = readl(h->vaddr + I2O_DMA1_CFG);
+	dma_prefetch |= 0x8000;
+	writel(dma_prefetch, h->vaddr + I2O_DMA1_CFG);
+	pci_read_config_dword(h->pdev, PCI_COMMAND_PARITY, &dma_refetch);
+	dma_refetch |= 0x1;
+	pci_write_config_dword(h->pdev, PCI_COMMAND_PARITY, dma_refetch);
+}
+
 static int __devinit cciss_pci_init(ctlr_info_t *c)
 {
 	int prod_index, err;
@@ -4182,24 +4200,7 @@ static int __devinit cciss_pci_init(ctlr_info_t *c)
 		goto err_out_free_res;
 	}
 	cciss_enable_scsi_prefetch(c);
-	/* Disabling DMA prefetch and refetch for the P600.
-	 * An ASIC bug may result in accesses to invalid memory addresses.
-	 * We've disabled prefetch for some time now. Testing with XEN
-	 * kernels revealed a bug in the refetch if dom0 resides on a P600.
-	 */
-	if (c->board_id == 0x3225103C) {
-		__u32 dma_prefetch;
-		__u32 dma_refetch;
-		dma_prefetch = readl(c->vaddr + I2O_DMA1_CFG);
-		dma_prefetch |= 0x8000;
-		writel(dma_prefetch, c->vaddr + I2O_DMA1_CFG);
-		pci_read_config_dword(c->pdev, PCI_COMMAND_PARITY,
-			&dma_refetch);
-		dma_refetch |= 0x1;
-		pci_write_config_dword(c->pdev, PCI_COMMAND_PARITY,
-			dma_refetch);
-	}
-
+	cciss_p600_dma_prefetch_quirk(c);
 #ifdef CCISS_DEBUG
 	printk(KERN_WARNING "Trying to put board into Performant mode\n");
 #endif				/* CCISS_DEBUG */

