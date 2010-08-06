Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965744Ab0HFTx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:53:27 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40042 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965695Ab0HFTxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:53:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=UtE+CIw6RRssexOmqLG0U1DozSDqy+mgilhJgvkqbtwDnIvC3ZwsaNkt7HnNEGW926
         AaMn0YzQ6hAZmgIKaTym8BQDXmf9n2LqorYrd9PCjLY1+aliSDlIZHsAq4ucUdfx75EI
         Xo021wvNq/kH/JNM+iww00k2D05K7G4h5HFX8=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Mike McCormack <mikem@ring3k.org>,
        Jeff Mahoney <jeffm@suse.com>, Julia Lawall <julia@diku.dk>,
        Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/18] staging: rtl8187e: call disable_pci_device() if pci_probe() failed
Date: Fri,  6 Aug 2010 23:53:09 +0400
Message-Id: <1281124392-13877-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver should call disable_pci_device() if it returns from pci_probe()
with error. Also it must not be called if request_*_region() fails as
it means that somebody uses device resources and rules the device.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/rtl8192e/r8192E_core.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8192e/r8192E_core.c b/drivers/staging/rtl8192e/r8192E_core.c
index 17a806f..7ea2959 100644
--- a/drivers/staging/rtl8192e/r8192E_core.c
+++ b/drivers/staging/rtl8192e/r8192E_core.c
@@ -6325,6 +6325,8 @@ static int __devinit rtl8192_pci_probe(struct pci_dev *pdev,
 	struct net_device *dev = NULL;
 	struct r8192_priv *priv= NULL;
 	u8 unit = 0;
+	int ret = -ENODEV;
+	int pci_dev_busy = 0;
 
 #ifdef CONFIG_RTL8192_IO_MAP
 	unsigned long pio_start, pio_len, pio_flags;
@@ -6344,8 +6346,10 @@ static int __devinit rtl8192_pci_probe(struct pci_dev *pdev,
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
@@ -6373,6 +6377,7 @@ static int __devinit rtl8192_pci_probe(struct pci_dev *pdev,
 	//DMESG("IO space @ 0x%08lx", pio_start );
 	if( ! request_region( pio_start, pio_len, RTL819xE_MODULE_NAME ) ){
 		RT_TRACE(COMP_ERR,"request_region failed!");
+		pci_dev_busy = 1;
 		goto fail;
 	}
 
@@ -6393,6 +6398,7 @@ static int __devinit rtl8192_pci_probe(struct pci_dev *pdev,
 	//DMESG("Memory mapped space @ 0x%08lx ", pmem_start);
 	if( ! request_mem_region(pmem_start, pmem_len, RTL819xE_MODULE_NAME)) {
 		RT_TRACE(COMP_ERR,"request_mem_region failed!");
+		pci_dev_busy = 1;
 		goto fail;
 	}
 
@@ -6494,11 +6500,13 @@ fail:
 		free_ieee80211(dev);
 	}
 
-	pci_disable_device(pdev);
+fail_free:
+	if (!pci_dev_busy)
+		pci_disable_device(pdev);
 
 	DMESG("wlan driver load failed\n");
 	pci_set_drvdata(pdev, NULL);
-	return -ENODEV;
+	return ret;
 
 }
 
-- 
1.7.0.4

