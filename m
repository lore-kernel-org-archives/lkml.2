Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965024Ab1KJQM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 11:12:28 -0500
Received: from mail.asbjorn.biz ([217.195.185.3]:47465 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757633Ab1KJQM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 11:12:26 -0500
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Nov 2011 11:12:26 EST
From: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] libata: fix compile error when CONFIG_ATA_BMDMA is not defined
Date: Thu, 10 Nov 2011 16:10:26 +0000
Message-Id: <1320941426-1100-1-git-send-email-asbjorn@asbjorn.biz>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-rc1 and Linus' tree at 5e442a49, fails to compile,
with CONFIG_SFF defined without CONFIG_ATA_BMDMA.

The error was introduced by:
  [ c2036033 ] libata: reduce ata_pci_[sff,bmdma]_init_one() size

Note this patch have only been compile tested.

Signed-off-by: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
---
 drivers/ata/libata-sff.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 63d5327..82b1237 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2533,10 +2533,12 @@ static int ata_pci_init_one(struct pci_dev *pdev,
 	if (rc)
 		goto out;
 
+	#ifdef CONFIG_ATA_BMDMA
 	if (bmdma)
 		/* prepare and activate BMDMA host */
 		rc = ata_pci_bmdma_prepare_host(pdev, ppi, &host);
 	else
+	#endif /* CONFIG_ATA_BMDMA */
 		/* prepare and activate SFF host */
 		rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
 	if (rc)
@@ -2544,10 +2546,12 @@ static int ata_pci_init_one(struct pci_dev *pdev,
 	host->private_data = host_priv;
 	host->flags |= hflags;
 
+	#ifdef CONFIG_ATA_BMDMA
 	if (bmdma) {
 		pci_set_master(pdev);
 		rc = ata_pci_sff_activate_host(host, ata_bmdma_interrupt, sht);
 	} else
+	#endif /* CONFIG_ATA_BMDMA */
 		rc = ata_pci_sff_activate_host(host, ata_sff_interrupt, sht);
 out:
 	if (rc == 0)
-- 
1.7.7.1

