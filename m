Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab0HCPnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 11:43:19 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56537 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010Ab0HCPnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 11:43:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pzTAQCObLgrvqi5rdpVGoMy9HKmjSHhRJTnI5SylCZcoczdUJu4zwbOxf0v/YVVKwG
         9eKh5GiX7ZA87RbDxGKuOuN0dhAp9Zcjm1bhgDDBxAb3LXADJh+aSugRvTtyURP1Bhp+
         u9IiCNtDqwFtZN+e2D2Kv90oVuorv8QYYrMCg=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Divy Le Ray <divy@chelsio.com>, "David S. Miller" <davem@davemloft.net>,
        Roland Dreier <rolandd@cisco.com>,
        Steve Wise <swise@opengridcomputing.com>,
        Ben Hutchings <ben@decadent.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/11] cxgb3: do not use PCI resources before pci_enable_device()
Date: Tue,  3 Aug 2010 19:43:11 +0400
Message-Id: <1280850192-5408-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQ and resource[] may not have correct values until
after PCI hotplug setup occurs at pci_enable_device() time.

The semantic match that finds this problem is as follows:

// <smpl>
@@
identifier x;
identifier request ~= "pci_request.*|pci_resource.*";
@@

(
* x->irq
|
* x->resource
|
* request(x, ...)
)
 ...
*pci_enable_device(x)
// </smpl>

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/net/cxgb3/cxgb3_main.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/cxgb3/cxgb3_main.c b/drivers/net/cxgb3/cxgb3_main.c
index 066fd5b..ad19585 100644
--- a/drivers/net/cxgb3/cxgb3_main.c
+++ b/drivers/net/cxgb3/cxgb3_main.c
@@ -3198,17 +3198,17 @@ static int __devinit init_one(struct pci_dev *pdev,
 		}
 	}
 
-	err = pci_request_regions(pdev, DRV_NAME);
+	err = pci_enable_device(pdev);
 	if (err) {
-		/* Just info, some other driver may have claimed the device. */
-		dev_info(&pdev->dev, "cannot obtain PCI resources\n");
-		return err;
+		dev_err(&pdev->dev, "cannot enable PCI device\n");
+		goto out;
 	}
 
-	err = pci_enable_device(pdev);
+	err = pci_request_regions(pdev, DRV_NAME);
 	if (err) {
-		dev_err(&pdev->dev, "cannot enable PCI device\n");
-		goto out_release_regions;
+		/* Just info, some other driver may have claimed the device. */
+		dev_info(&pdev->dev, "cannot obtain PCI resources\n");
+		goto out_disable_device;
 	}
 
 	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
@@ -3217,11 +3217,11 @@ static int __devinit init_one(struct pci_dev *pdev,
 		if (err) {
 			dev_err(&pdev->dev, "unable to obtain 64-bit DMA for "
 			       "coherent allocations\n");
-			goto out_disable_device;
+			goto out_release_regions;
 		}
 	} else if ((err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) != 0) {
 		dev_err(&pdev->dev, "no usable DMA configuration\n");
-		goto out_disable_device;
+		goto out_release_regions;
 	}
 
 	pci_set_master(pdev);
@@ -3234,7 +3234,7 @@ static int __devinit init_one(struct pci_dev *pdev,
 	adapter = kzalloc(sizeof(*adapter), GFP_KERNEL);
 	if (!adapter) {
 		err = -ENOMEM;
-		goto out_disable_device;
+		goto out_release_regions;
 	}
 
 	adapter->nofail_skb =
@@ -3370,11 +3370,12 @@ out_free_dev:
 out_free_adapter:
 	kfree(adapter);
 
-out_disable_device:
-	pci_disable_device(pdev);
 out_release_regions:
 	pci_release_regions(pdev);
+out_disable_device:
+	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
+out:
 	return err;
 }
 
-- 
1.7.0.4

