Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797Ab1BPBju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:39:50 -0500
Received: from kroah.org ([198.145.64.141]:39023 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757050Ab1BPAUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:20:08 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:33 2011
Message-Id: <20110216001433.043154646@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:12:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dean Nelson <dnelson@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [079/272] e1000: fix return value not set on error
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dean Nelson <dnelson@redhat.com>

commit 19a0b67afd174c4db261d587b5c67704dcd53c17 upstream.

Dean noticed that 'err' wasn't being set when the "goto err_dma"
statement is executed in the following hunk from the commit. It's value
will be zero as a result of a successful call to e1000_init_hw_struct().

This patch changes the error condition to be correctly propagated.

Signed-off-by:  Dean Nelson <dnelson@redhat.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Emil Tantilov <emil.s.tantilov@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/e1000/e1000_main.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -971,11 +971,13 @@ static int __devinit e1000_probe(struct
 		 */
 		dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
 		pci_using_dac = 1;
-	} else if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))) {
-		dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
 	} else {
-		pr_err("No usable DMA config, aborting\n");
-		goto err_dma;
+		err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
+		if (err) {
+			pr_err("No usable DMA config, aborting\n");
+			goto err_dma;
+		}
+		dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
 	}
 
 	netdev->netdev_ops = &e1000_netdev_ops;


