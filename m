Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab0HITwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 15:52:11 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61728 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab0HITwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 15:52:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=UzREtsl/1RgTjghsbk+mHKxu76pt9HBE3YEJXDYm/7xThB+k89WyFt8rX/frEpaXdI
         BPpeyNNaHDcTgrZCJvEcU4bIiEPCjbMmnqqnA66Epm/239OdUZDbUCZ3qqPJ7srl4VJz
         R3eImZ6ii12tcjHAJpC46n/1sW+CoLN4tZTjM=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Mike McCormack <mikem@ring3k.org>,
        Jeff Mahoney <jeffm@suse.com>, Julia Lawall <julia@diku.dk>,
        Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/18 v2] staging: rtl8187e: call disable_pci_device() if pci_probe() failed
Date: Mon,  9 Aug 2010 23:51:59 +0400
Message-Id: <1281383522-14518-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver should call disable_pci_device() if it returns from pci_probe()
with error.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/rtl8192e/r8192E_core.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8192e/r8192E_core.c b/drivers/staging/rtl8192e/r8192E_core.c
index 17a806f..2334ccd 100644
--- a/drivers/staging/rtl8192e/r8192E_core.c
+++ b/drivers/staging/rtl8192e/r8192E_core.c
@@ -6325,6 +6325,7 @@ static int __devinit rtl8192_pci_probe(struct pci_dev *pdev,
 	struct net_device *dev = NULL;
 	struct r8192_priv *priv= NULL;
 	u8 unit = 0;
+	int ret = -ENODEV;
 
 #ifdef CONFIG_RTL8192_IO_MAP
 	unsigned long pio_start, pio_len, pio_flags;
@@ -6344,8 +6345,10 @@ static int __devinit rtl8192_pci_probe(struct pci_dev *pdev,
 	pci_set_dma_mask(pdev, 0xffffff00ULL);
 	pci_set_consistent_dma_mask(pdev,0xffffff00ULL);
 	dev = alloc_ieee80211(sizeof(struct r8192_priv));
-	if (!dev)
-		return -ENOMEM;
+	if (!dev) {
+		ret = -ENOMEM;
+		goto fail_free;
+	}
 
 	pci_set_drvdata(pdev, dev);
 	SET_NETDEV_DEV(dev, &pdev->dev);
@@ -6494,11 +6497,12 @@ fail:
 		free_ieee80211(dev);
 	}
 
+fail_free:
 	pci_disable_device(pdev);
 
 	DMESG("wlan driver load failed\n");
 	pci_set_drvdata(pdev, NULL);
-	return -ENODEV;
+	return ret;
 
 }
 
-- 
1.7.0.4

