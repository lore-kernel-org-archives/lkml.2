Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768Ab2DTPHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 11:07:31 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:24243 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932653Ab2DTPH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 11:07:27 -0400
Subject: [PATCH 13/17] hpsa: factor out hpsa_free_irqs_and_disable_msix
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        matthew.gates@hp.com, stephenmcameron@gmail.com, thenzl@redhat.com,
        akpm@linux-foundation.org, mikem@beardog.cce.hp.com
Date: Fri, 20 Apr 2012 10:07:27 -0500
Message-ID: <20120420150727.10596.81269.stgit@beardog.cce.hp.com>
In-Reply-To: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
References: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
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
 drivers/scsi/hpsa.c |   30 ++++++++++++++++--------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 1ec912b..2e01583 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4485,15 +4485,23 @@ static void free_irqs(struct ctlr_info *h)
 		free_irq(h->intr[i], &h->q[i]);
 }
 
-static void hpsa_undo_allocations_after_kdump_soft_reset(struct ctlr_info *h)
+static void hpsa_free_irqs_and_disable_msix(struct ctlr_info *h)
 {
 	free_irqs(h);
-#ifdef CONFIG_PCI_MSI
-	if (h->msix_vector)
-		pci_disable_msix(h->pdev);
-	else if (h->msi_vector)
-		pci_disable_msi(h->pdev);
-#endif /* CONFIG_PCI_MSI */
+	if (!IS_ENABLED(PCI_MSI))
+		return;
+	if (h->msix_vector) {
+		if (h->pdev->msix_enabled)
+			pci_disable_msix(h->pdev);
+	} else if (h->msi_vector) {
+		if (h->pdev->msi_enabled)
+			pci_disable_msi(h->pdev);
+	}
+}
+
+static void hpsa_undo_allocations_after_kdump_soft_reset(struct ctlr_info *h)
+{
+	hpsa_free_irqs_and_disable_msix(h);
 	hpsa_free_sg_chain_blocks(h);
 	hpsa_free_cmd_pool(h);
 	kfree(h->blockFetchTable);
@@ -4848,13 +4856,7 @@ static void hpsa_shutdown(struct pci_dev *pdev)
 	 */
 	hpsa_flush_cache(h);
 	h->access.set_intr_mask(h, HPSA_INTR_OFF);
-	free_irqs(h);
-#ifdef CONFIG_PCI_MSI
-	if (h->msix_vector)
-		pci_disable_msix(h->pdev);
-	else if (h->msi_vector)
-		pci_disable_msi(h->pdev);
-#endif				/* CONFIG_PCI_MSI */
+	hpsa_free_irqs_and_disable_msix(h);
 }
 
 static void __devexit hpsa_free_device_info(struct ctlr_info *h)

