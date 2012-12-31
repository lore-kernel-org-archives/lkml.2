Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712Ab2LaS4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 13:56:40 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:50709 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab2LaS4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 13:56:38 -0500
From: Devendra Naga <devendra.aaru@gmail.com>
To: "Hans J. Koch" <hjk@hansjkoch.de>, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH] uio: sercos3: use devm_kzalloc
Date: Mon, 31 Dec 2012 13:56:29 -0500
Message-Id: <1356980189-19749-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use devm_kzalloc and no need of free's at error path and unload

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---

Please apply this after

changeid: 1fb4ec94e7e955a1e26bf81f2634e5be2fa5f1d5
[PATCH] uio: uio_sercos3: use module_pci_driver macro

sorry for sending as patch should be patch 2/2.

 drivers/uio/uio_sercos3.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/uio/uio_sercos3.c b/drivers/uio/uio_sercos3.c
index 5419832..c0d758a 100644
--- a/drivers/uio/uio_sercos3.c
+++ b/drivers/uio/uio_sercos3.c
@@ -123,16 +123,16 @@ static int sercos3_pci_probe(struct pci_dev *dev,
 	struct sercos3_priv *priv;
 	int i;
 
-	info = kzalloc(sizeof(struct uio_info), GFP_KERNEL);
+	info = devm_kzalloc(&dev->dev, sizeof(struct uio_info), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
 
-	priv = kzalloc(sizeof(struct sercos3_priv), GFP_KERNEL);
+	priv = devm_kzalloc(&dev->dev, sizeof(struct sercos3_priv), GFP_KERNEL);
 	if (!priv)
-		goto out_free;
+		return -ENOMEM;
 
 	if (pci_enable_device(dev))
-		goto out_free_priv;
+		goto out;
 
 	if (pci_request_regions(dev, "sercos3"))
 		goto out_disable;
@@ -173,10 +173,7 @@ out_unmap:
 	pci_release_regions(dev);
 out_disable:
 	pci_disable_device(dev);
-out_free_priv:
-	kfree(priv);
-out_free:
-	kfree(info);
+out:
 	return -ENODEV;
 }
 
@@ -193,8 +190,6 @@ static void sercos3_pci_remove(struct pci_dev *dev)
 		if (info->mem[i].internal_addr)
 			iounmap(info->mem[i].internal_addr);
 	}
-	kfree(info->priv);
-	kfree(info);
 }
 
 static struct pci_device_id sercos3_pci_ids[] = {
-- 
1.7.10.4

