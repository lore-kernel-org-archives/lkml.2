Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab1CJCop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 21:44:45 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44383 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab1CJCoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 21:44:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VTawkh3NaQhBKB3tAusVyYEWK3wWVtj7ys5QmXfaGA83A5JdDHUm5iX1xF9zBiieqX
         9s9eBLbZnes1ci2OuTbUz2hWaUJq0JTuKERmlCGHk5H8KKVxMxSheLX4U16Lmw2gD9jQ
         Bm832fnd60GyQDodqra1wklkgskQiN7d+jerc=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH next 4/6] staging: crystalhd: fix memory leaks
Date: Thu, 10 Mar 2011 05:43:06 +0300
Message-Id: <1299724988-25351-4-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1299724988-25351-1-git-send-email-a.beregalov@gmail.com>
References: <1299724988-25351-1-git-send-email-a.beregalov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free resources before exit.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/crystalhd/crystalhd_hw.c  |    1 +
 drivers/staging/crystalhd/crystalhd_lnx.c |   18 +++++++++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/crystalhd/crystalhd_hw.c b/drivers/staging/crystalhd/crystalhd_hw.c
index 153ddbf..13a514d 100644
--- a/drivers/staging/crystalhd/crystalhd_hw.c
+++ b/drivers/staging/crystalhd/crystalhd_hw.c
@@ -1965,6 +1965,7 @@ enum BC_STATUS crystalhd_hw_setup_dma_rings(struct crystalhd_hw *hw)
 		} else {
 			BCMLOG_ERR("Insufficient Memory For RX\n");
 			crystalhd_hw_free_dma_rings(hw);
+			kfree(rpkt);
 			return BC_STS_INSUFF_RES;
 		}
 		rpkt->desc_mem.pdma_desc_start = mem;
diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index 719e70b..2b47ef9 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -561,7 +561,7 @@ static int __devinit chd_dec_pci_probe(struct pci_dev *pdev,
 	rc = pci_enable_device(pdev);
 	if (rc) {
 		BCMLOG_ERR("Failed to enable PCI device\n");
-		return rc;
+		goto err;
 	}
 
 	snprintf(pinfo->name, 31, "crystalhd_pci_e:%d:%d:%d",
@@ -572,7 +572,8 @@ static int __devinit chd_dec_pci_probe(struct pci_dev *pdev,
 	if (rc) {
 		BCMLOG_ERR("Failed to setup memory regions.\n");
 		pci_disable_device(pdev);
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto err;
 	}
 
 	pinfo->present	= 1;
@@ -587,7 +588,8 @@ static int __devinit chd_dec_pci_probe(struct pci_dev *pdev,
 	if (rc) {
 		BCMLOG_ERR("_enable_int err:%d\n", rc);
 		pci_disable_device(pdev);
-		return -ENODEV;
+		rc = -ENODEV;
+		goto err;
 	}
 
 	/* Set dma mask... */
@@ -600,14 +602,16 @@ static int __devinit chd_dec_pci_probe(struct pci_dev *pdev,
 	} else {
 		BCMLOG_ERR("Unabled to setup DMA %d\n", rc);
 		pci_disable_device(pdev);
-		return -ENODEV;
+		rc = -ENODEV;
+		goto err;
 	}
 
 	sts = crystalhd_setup_cmd_context(&pinfo->cmds, pinfo);
 	if (sts != BC_STS_SUCCESS) {
 		BCMLOG_ERR("cmd setup :%d\n", sts);
 		pci_disable_device(pdev);
-		return -ENODEV;
+		rc = -ENODEV;
+		goto err;
 	}
 
 	pci_set_master(pdev);
@@ -617,6 +621,10 @@ static int __devinit chd_dec_pci_probe(struct pci_dev *pdev,
 	g_adp_info = pinfo;
 
 	return 0;
+
+err:
+	kfree(pinfo);
+	return rc;
 }
 
 #ifdef CONFIG_PM
-- 
1.7.4.1

