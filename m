Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab0HITwD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 15:52:03 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61728 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab0HITwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 15:52:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=EjvUi0yyq5RS440ReGxqZd5uoFHuQfdUyRgtICVfPX9TjyZozIm1/Y/9gGSdL64RDj
         pOwdMiiNvF5bKzhKE2C5YOcYUJVVYlQ7hpZ5/r+Y1M4uLdrKuOCj6FkiqyQ1Y+jFj6ZR
         ix+RQlxkwy6Rz3tHl5kAkYb2NfjvPQtGTjBDA=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Joe Perches <joe@perches.com>,
        "Prashant P. Shah" <pshah.mumbai@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 14/18 v2] staging: rtl8187se: call disable_pci_device() if pci_probe() failed
Date: Mon,  9 Aug 2010 23:51:52 +0400
Message-Id: <1281383515-14478-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver should call disable_pci_device() if it returns from pci_probe()
with error.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/rtl8187se/r8180_core.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index ed7457b..70ab008 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -3547,6 +3547,7 @@ static int __devinit rtl8180_pci_probe(struct pci_dev *pdev,
 	struct net_device *dev = NULL;
 	struct r8180_priv *priv = NULL;
 	u8 unit = 0;
+	int ret = -ENODEV;
 
 	unsigned long pmem_start, pmem_len, pmem_flags;
 
@@ -3561,8 +3562,10 @@ static int __devinit rtl8180_pci_probe(struct pci_dev *pdev,
 	pci_set_dma_mask(pdev, 0xffffff00ULL);
 	pci_set_consistent_dma_mask(pdev, 0xffffff00ULL);
 	dev = alloc_ieee80211(sizeof(struct r8180_priv));
-	if (!dev)
-		return -ENOMEM;
+	if (!dev) {
+		ret = -ENOMEM;
+		goto fail_free;
+	}
 	priv = ieee80211_priv(dev);
 	priv->ieee80211 = netdev_priv(dev);
 
@@ -3641,11 +3644,12 @@ fail:
 		free_ieee80211(dev);
 	}
 
+fail_free:
 	pci_disable_device(pdev);
 
 	DMESG("wlan driver load failed\n");
 	pci_set_drvdata(pdev, NULL);
-	return -ENODEV;
+	return ret;
 }
 
 static void __devexit rtl8180_pci_remove(struct pci_dev *pdev)
-- 
1.7.0.4

