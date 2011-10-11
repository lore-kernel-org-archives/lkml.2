Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab1JKRjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:39:05 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52681 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148Ab1JKRjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:39:01 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] libata: reduce ata_pci_[sff,bmdma]_init_one() size
Date: Tue, 11 Oct 2011 19:22:16 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110111922.16501.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] libata: reduce ata_pci_[sff,bmdma]_init_one() size

Turn both helpers (which are used only during LLDs initialization
time and thus are not performance sensitive) into wrappers around
the new ata_pci_init_one() function, this cuts 20 LOC and saves
~1.1k of the output code size (x86-64):

 text    data     bss     dec     hex filename
  21392       0      19   21411    53a3 drivers/ata/libata-sff.o.before
  20256       0      19   20275    4f33 drivers/ata/libata-sff.o.after

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
earlier references:
https://lkml.org/lkml/2011/2/9/150

 drivers/ata/libata-sff.c |  111 +++++++++++++++++++----------------------------
 1 file changed, 46 insertions(+), 65 deletions(-)

Index: b/drivers/ata/libata-sff.c
===================================================================
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2507,31 +2507,10 @@ static const struct ata_port_info *ata_s
 	return NULL;
 }
 
-/**
- *	ata_pci_sff_init_one - Initialize/register PIO-only PCI IDE controller
- *	@pdev: Controller to be initialized
- *	@ppi: array of port_info, must be enough for two ports
- *	@sht: scsi_host_template to use when registering the host
- *	@host_priv: host private_data
- *	@hflag: host flags
- *
- *	This is a helper function which can be called from a driver's
- *	xxx_init_one() probe function if the hardware uses traditional
- *	IDE taskfile registers and is PIO only.
- *
- *	ASSUMPTION:
- *	Nobody makes a single channel controller that appears solely as
- *	the secondary legacy port on PCI.
- *
- *	LOCKING:
- *	Inherited from PCI layer (may sleep).
- *
- *	RETURNS:
- *	Zero on success, negative on errno-based value on error.
- */
-int ata_pci_sff_init_one(struct pci_dev *pdev,
-		 const struct ata_port_info * const *ppi,
-		 struct scsi_host_template *sht, void *host_priv, int hflag)
+static int ata_pci_init_one(struct pci_dev *pdev,
+		const struct ata_port_info * const *ppi,
+		struct scsi_host_template *sht, void *host_priv,
+		int hflags, bool bmdma)
 {
 	struct device *dev = &pdev->dev;
 	const struct ata_port_info *pi;
@@ -2553,14 +2532,22 @@ int ata_pci_sff_init_one(struct pci_dev
 	if (rc)
 		goto out;
 
-	/* prepare and activate SFF host */
-	rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
+	if (bmdma)
+		/* prepare and activate BMDMA host */
+		rc = ata_pci_bmdma_prepare_host(pdev, ppi, &host);
+	else
+		/* prepare and activate SFF host */
+		rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
 	if (rc)
 		goto out;
 	host->private_data = host_priv;
-	host->flags |= hflag;
+	host->flags |= hflags;
 
-	rc = ata_pci_sff_activate_host(host, ata_sff_interrupt, sht);
+	if (bmdma) {
+		pci_set_master(pdev);
+		rc = ata_pci_sff_activate_host(host, ata_bmdma_interrupt, sht);
+	} else
+		rc = ata_pci_sff_activate_host(host, ata_sff_interrupt, sht);
 out:
 	if (rc == 0)
 		devres_remove_group(&pdev->dev, NULL);
@@ -2569,6 +2556,35 @@ out:
 
 	return rc;
 }
+
+/**
+ *	ata_pci_sff_init_one - Initialize/register PIO-only PCI IDE controller
+ *	@pdev: Controller to be initialized
+ *	@ppi: array of port_info, must be enough for two ports
+ *	@sht: scsi_host_template to use when registering the host
+ *	@host_priv: host private_data
+ *	@hflag: host flags
+ *
+ *	This is a helper function which can be called from a driver's
+ *	xxx_init_one() probe function if the hardware uses traditional
+ *	IDE taskfile registers and is PIO only.
+ *
+ *	ASSUMPTION:
+ *	Nobody makes a single channel controller that appears solely as
+ *	the secondary legacy port on PCI.
+ *
+ *	LOCKING:
+ *	Inherited from PCI layer (may sleep).
+ *
+ *	RETURNS:
+ *	Zero on success, negative on errno-based value on error.
+ */
+int ata_pci_sff_init_one(struct pci_dev *pdev,
+		 const struct ata_port_info * const *ppi,
+		 struct scsi_host_template *sht, void *host_priv, int hflag)
+{
+	return ata_pci_init_one(pdev, ppi, sht, host_priv, hflag, 0);
+}
 EXPORT_SYMBOL_GPL(ata_pci_sff_init_one);
 
 #endif /* CONFIG_PCI */
@@ -3286,42 +3302,7 @@ int ata_pci_bmdma_init_one(struct pci_de
 			   struct scsi_host_template *sht, void *host_priv,
 			   int hflags)
 {
-	struct device *dev = &pdev->dev;
-	const struct ata_port_info *pi;
-	struct ata_host *host = NULL;
-	int rc;
-
-	DPRINTK("ENTER\n");
-
-	pi = ata_sff_find_valid_pi(ppi);
-	if (!pi) {
-		dev_err(&pdev->dev, "no valid port_info specified\n");
-		return -EINVAL;
-	}
-
-	if (!devres_open_group(dev, NULL, GFP_KERNEL))
-		return -ENOMEM;
-
-	rc = pcim_enable_device(pdev);
-	if (rc)
-		goto out;
-
-	/* prepare and activate BMDMA host */
-	rc = ata_pci_bmdma_prepare_host(pdev, ppi, &host);
-	if (rc)
-		goto out;
-	host->private_data = host_priv;
-	host->flags |= hflags;
-
-	pci_set_master(pdev);
-	rc = ata_pci_sff_activate_host(host, ata_bmdma_interrupt, sht);
- out:
-	if (rc == 0)
-		devres_remove_group(&pdev->dev, NULL);
-	else
-		devres_release_group(&pdev->dev, NULL);
-
-	return rc;
+	return ata_pci_init_one(pdev, ppi, sht, host_priv, hflags, 1);
 }
 EXPORT_SYMBOL_GPL(ata_pci_bmdma_init_one);
 
