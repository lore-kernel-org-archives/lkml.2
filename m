Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab1ECTxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 15:53:18 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:38898 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab1ECTxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 15:53:16 -0400
Subject: [PATCH 05/16] cciss: factor out irq request code
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Date: Tue, 03 May 2011 14:53:16 -0500
Message-ID: <20110503195315.5154.98193.stgit@beardog.cce.hp.com>
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
 drivers/block/cciss.c |   41 +++++++++++++++++++++++++----------------
 1 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 55ca1f4..63fe05a 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4719,6 +4719,28 @@ static void cciss_free_cmd_pool(ctlr_info_t *h)
 			h->errinfo_pool, h->errinfo_pool_dhandle);
 }
 
+static int cciss_request_irq(ctlr_info_t *h,
+	irqreturn_t (*msixhandler)(int, void *),
+	irqreturn_t (*intxhandler)(int, void *))
+{
+	if (h->msix_vector || h->msi_vector) {
+		if (!request_irq(h->intr[PERF_MODE_INT], msixhandler,
+				IRQF_DISABLED, h->devname, h))
+			return 0;
+		dev_err(&h->pdev->dev, "Unable to get msi irq %d"
+			" for %s\n", h->intr[PERF_MODE_INT],
+			h->devname);
+		return -1;
+	}
+
+	if (!request_irq(h->intr[PERF_MODE_INT], intxhandler,
+			IRQF_DISABLED, h->devname, h))
+		return 0;
+	dev_err(&h->pdev->dev, "Unable to get irq %d for %s\n",
+		h->intr[PERF_MODE_INT], h->devname);
+	return -1;
+}
+
 /*
  *  This is it.  Find all the controllers and register them.  I really hate
  *  stealing all these major device numbers.
@@ -4789,22 +4811,9 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 
 	/* make sure the board interrupts are off */
 	h->access.set_intr_mask(h, CCISS_INTR_OFF);
-	if (h->msi_vector || h->msix_vector) {
-		if (request_irq(h->intr[PERF_MODE_INT],
-				do_cciss_msix_intr,
-				IRQF_DISABLED, h->devname, h)) {
-			dev_err(&h->pdev->dev, "Unable to get irq %d for %s\n",
-			       h->intr[PERF_MODE_INT], h->devname);
-			goto clean2;
-		}
-	} else {
-		if (request_irq(h->intr[PERF_MODE_INT], do_cciss_intx,
-				IRQF_DISABLED, h->devname, h)) {
-			dev_err(&h->pdev->dev, "Unable to get irq %d for %s\n",
-			       h->intr[PERF_MODE_INT], h->devname);
-			goto clean2;
-		}
-	}
+	rc = cciss_request_irq(h, do_cciss_msix_intr, do_cciss_intx);
+	if (rc)
+		goto clean2;
 
 	dev_info(&h->pdev->dev, "%s: <0x%x> at PCI %s IRQ %d%s using DAC\n",
 	       h->devname, pdev->device, pci_name(pdev),

