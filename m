Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933691Ab2JLJHL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 05:07:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44732 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933514Ab2JLJHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 05:07:04 -0400
From: "NickCheng" <nick.cheng@areca.com.tw>
To: <linux-scsi@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <jejb@kernel.org>
Subject: [PATCH 3/5]  arcmsr: Support MSI and MSI-X
Date: Fri, 12 Oct 2012 17:08:13 +0800
Message-ID: <51AB90FF0F4F41EAAC9746FCE4EC08C1@arecaaebe11fae>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac2hXXYG8W24nt0/Q/6mWt8IlNnnHQ==
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Cheng <nick.cheng@areca.com.tw>

Support MSI or MSI-X for whole series of RAID controllers. Meanwhile correct the register access as iowrite32/ioread32 
Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>
---
diff -uprN a//drivers/scsi/arcmsr/arcmsr_hba.c b//drivers/scsi/arcmsr/arcmsr_hba.c
--- a//drivers/scsi/arcmsr/arcmsr_hba.c	2012-10-12 16:34:58.219955247 +0800
+++ b//drivers/scsi/arcmsr/arcmsr_hba.c	2012-10-12 16:35:16.267955072 +0800
@@ -805,8 +805,9 @@ static int arcmsr_probe(struct pci_dev *
 {
 	struct Scsi_Host *host;
 	struct AdapterControlBlock *acb;
-	uint8_t bus,dev_fun;
-	int error;
+	uint8_t bus, dev_fun;
+	struct msix_entry entries[ARCMST_NUM_MSIX_VECTORS];
+	int error, i, j;
 	error = pci_enable_device(pdev);
 	if (error) {
 		return -ENODEV;
@@ -871,10 +872,46 @@ static int arcmsr_probe(struct pci_dev *
 	if (error) {
 		goto RAID_controller_stop;
 	}
-	error = request_irq(pdev->irq, arcmsr_do_interrupt,
-		IRQF_SHARED, "arcmsr", acb);
-	if (error) {
-		goto scsi_host_remove;
+	if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {
+		if (!pci_enable_msix(pdev, entries, ARCMST_NUM_MSIX_VECTORS)) {
+			for (i = 0; i < ARCMST_NUM_MSIX_VECTORS; i++) {
+				entries[i].entry = i;
+				if (request_irq(entries[i].vector,
+					arcmsr_do_interrupt, 0, "arcmsr",
+					acb)) {
+					for (j = 0 ; j < i ; j++)
+						free_irq(entries[i].vector,
+						acb);
+					goto scsi_host_remove;
+				}
+				acb->entries[i] = entries[i];
+			}
+			acb->acb_flags |= ACB_F_MSIX_ENABLED;
+		} else {
+			if (request_irq(pdev->irq, arcmsr_do_interrupt,
+				IRQF_SHARED, "arcmsr", acb)) {
+				printk("arcmsr%d: request_irq =%d failed!\n",
+					acb->host->host_no, pdev->irq);
+				goto scsi_host_remove;
+			}
+		}
+	} else if (pci_find_capability(pdev, PCI_CAP_ID_MSI)) {
+		if (!pci_enable_msi(pdev)) {
+			acb->acb_flags |= ACB_F_MSI_ENABLED;
+		}
+		if (request_irq(pdev->irq, arcmsr_do_interrupt,
+			IRQF_SHARED, "arcmsr", acb)) {
+			printk("arcmsr%d: request_irq =%d failed!\n",
+				acb->host->host_no, pdev->irq);
+			goto scsi_host_remove;
+		}
+	} else {
+		if (request_irq(pdev->irq, arcmsr_do_interrupt,
+			IRQF_SHARED, "arcmsr", acb)) {
+			printk("arcmsr%d: request_irq =%d failed!\n",
+				acb->host->host_no, pdev->irq);
+			goto scsi_host_remove;
+		}
 	}
 	host->irq = pdev->irq;
     	scsi_scan_host(host);
@@ -895,6 +932,11 @@ static int arcmsr_probe(struct pci_dev *
 	return 0;
 out_free_sysfs:
 scsi_host_remove:
+	if (acb->acb_flags & ACB_F_MSI_ENABLED) {
+		pci_disable_msi(pdev);
+	} else if (acb->acb_flags & ACB_F_MSIX_ENABLED) {
+		pci_disable_msix(pdev);
+	}
 	scsi_remove_host(host);
 RAID_controller_stop:
 	arcmsr_stop_adapter_bgrb(acb);

