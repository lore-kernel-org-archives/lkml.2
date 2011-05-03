Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab1ECT7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 15:59:30 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:38110 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab1ECT71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 15:59:27 -0400
X-Greylist: delayed 349 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 May 2011 15:59:26 EDT
Subject: [PATCH 08/16] hpsa: factor out irq request code
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        smcameron@yahoo.com, thenzl@redhat.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com
Date: Tue, 03 May 2011 14:59:25 -0500
Message-ID: <20110503195925.5478.17662.stgit@beardog.cce.hp.com>
In-Reply-To: <20110503195750.5478.54853.stgit@beardog.cce.hp.com>
References: <20110503195750.5478.54853.stgit@beardog.cce.hp.com>
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
 drivers/scsi/hpsa.c |   32 +++++++++++++++++++++-----------
 1 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 7336f3c..97db2e5 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3881,6 +3881,26 @@ static void hpsa_free_cmd_pool(struct ctlr_info *h)
 			    h->errinfo_pool_dhandle);
 }
 
+static int hpsa_request_irq(struct ctlr_info *h,
+	irqreturn_t (*msixhandler)(int, void *),
+	irqreturn_t (*intxhandler)(int, void *))
+{
+	int rc;
+
+	if (h->msix_vector || h->msi_vector)
+		rc = request_irq(h->intr[h->intr_mode], msixhandler,
+				IRQF_DISABLED, h->devname, h);
+	else
+		rc = request_irq(h->intr[h->intr_mode], intxhandler,
+				IRQF_DISABLED, h->devname, h);
+	if (rc) {
+		dev_err(&h->pdev->dev, "unable to get irq %d for %s\n",
+		       h->intr[h->intr_mode], h->devname);
+		return -ENODEV;
+	}
+	return 0;
+}
+
 static int __devinit hpsa_init_one(struct pci_dev *pdev,
 				    const struct pci_device_id *ent)
 {
@@ -3936,18 +3956,8 @@ static int __devinit hpsa_init_one(struct pci_dev *pdev,
 	/* make sure the board interrupts are off */
 	h->access.set_intr_mask(h, HPSA_INTR_OFF);
 
-	if (h->msix_vector || h->msi_vector)
-		rc = request_irq(h->intr[h->intr_mode], do_hpsa_intr_msi,
-				IRQF_DISABLED, h->devname, h);
-	else
-		rc = request_irq(h->intr[h->intr_mode], do_hpsa_intr_intx,
-				IRQF_DISABLED, h->devname, h);
-	if (rc) {
-		dev_err(&pdev->dev, "unable to get irq %d for %s\n",
-		       h->intr[h->intr_mode], h->devname);
+	if (hpsa_request_irq(h, do_hpsa_intr_msi, do_hpsa_intr_intx))
 		goto clean2;
-	}
-
 	dev_info(&pdev->dev, "%s: <0x%x> at IRQ %d%s using DAC\n",
 	       h->devname, pdev->device,
 	       h->intr[h->intr_mode], dac ? "" : " not");

