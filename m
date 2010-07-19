Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965388Ab0GSSjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:39:49 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:26432 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965320Ab0GSSjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:39:39 -0400
Subject: [PATCH 06/26] cciss: factor out cciss_find_memory_BAR()
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Mon, 19 Jul 2010 13:45:10 -0500
Message-ID: <20100719184510.7908.93329.stgit@beardog.cce.hp.com>
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

cciss: factor out cciss_find_memory_BAR()

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   37 +++++++++++++++++++------------------
 1 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index bb22a80..9c9c79c 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4009,6 +4009,23 @@ static inline bool cciss_board_disabled(ctlr_info_t *h)
 	return ((command & PCI_COMMAND_MEMORY) == 0);
 }
 
+static int __devinit cciss_pci_find_memory_BAR(struct pci_dev *pdev,
+	unsigned long *memory_bar)
+{
+	int i;
+
+	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++)
+		if (pci_resource_flags(pdev, i) & IORESOURCE_MEM) {
+			/* addressing mode bits already removed */
+			*memory_bar = pci_resource_start(pdev, i);
+			dev_dbg(&pdev->dev, "memory BAR = %lx\n",
+				*memory_bar);
+			return 0;
+		}
+	dev_warn(&pdev->dev, "no memory BAR found\n");
+	return -ENODEV;
+}
+
 static int __devinit cciss_pci_init(ctlr_info_t *c)
 {
 	__u32 scratchpad = 0;
@@ -4052,25 +4069,9 @@ static int __devinit cciss_pci_init(ctlr_info_t *c)
  * else we use the IO-APIC interrupt assigned to us by system ROM.
  */
 	cciss_interrupt_mode(c);
-
-	/* find the memory BAR */
-	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
-		if (pci_resource_flags(c->pdev, i) & IORESOURCE_MEM)
-			break;
-	}
-	if (i == DEVICE_COUNT_RESOURCE) {
-		printk(KERN_WARNING "cciss: No memory BAR found\n");
-		err = -ENODEV;
+	err = cciss_pci_find_memory_BAR(c->pdev, &c->paddr);
+	if (err)
 		goto err_out_free_res;
-	}
-
-	c->paddr = pci_resource_start(c->pdev, i); /* addressing mode bits
-						 * already removed
-						 */
-
-#ifdef CCISS_DEBUG
-	printk("address 0 = %lx\n", c->paddr);
-#endif				/* CCISS_DEBUG */
 	c->vaddr = remap_pci_mem(c->paddr, 0x250);
 
 	/* Wait for the board to become ready.  (PCI hotplug needs this.)

