Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab0JCNti (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 09:49:38 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39374 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab0JCNth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 09:49:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Y+i0djcCfAt3SaDk8KC5dSxSi0WfbHkOGAdBhibE4YjldT9cUZxV/lXmbNEBzWvgSS
         3bervZsMBwr4qRGgFPdBJgWDZwbEArXA8c2n6eeaN534erVKk08LIqqdd8JMW71OulbK
         k7LPi569+7gzYw6yVTd49uxGTSAJym8gpD+4U=
From: Rahul Ruikar <rahul.ruikar@gmail.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rahul Ruikar <rahul.ruikar@gmail.com>
Subject: [PATCH] usb: gadget: langwell_udc: Fix error path
Date: Sun,  3 Oct 2010 19:19:10 +0530
Message-Id: <1286113750-2607-1-git-send-email-rahul.ruikar@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- call device_unregister() only when device_register() is sucess.
- call put_device() when device_register() fails.

Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
---
 drivers/usb/gadget/langwell_udc.c |   18 ++++++++++++++----
 drivers/usb/gadget/langwell_udc.h |    4 +++-
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/langwell_udc.c b/drivers/usb/gadget/langwell_udc.c
index c2d2a20..2b5ae16 100644
--- a/drivers/usb/gadget/langwell_udc.c
+++ b/drivers/usb/gadget/langwell_udc.c
@@ -2952,8 +2952,13 @@ static void langwell_udc_remove(struct pci_dev *pdev)
 	INFO(dev, "unbind\n");
 	DBG(dev, "<--- %s()\n", __func__);
 
-	device_unregister(&dev->gadget.dev);
-	device_remove_file(&pdev->dev, &dev_attr_langwell_udc);
+	if (dev->dev_reg_status == 2)
+		device_unregister(&dev->gadget.dev);
+	else if (dev->dev_reg_status == 1)
+		put_device(&dev->gadget.dev);
+
+	if (dev->dev_create_file)
+		device_remove_file(&pdev->dev, &dev_attr_langwell_udc);
 
 #ifndef	OTG_TRANSCEIVER
 	pci_set_drvdata(pdev, NULL);
@@ -3190,12 +3195,17 @@ static int langwell_udc_probe(struct pci_dev *pdev,
 	the_controller = dev;
 
 	retval = device_register(&dev->gadget.dev);
-	if (retval)
+	if (retval) {
+		dev_reg_status = 1;
 		goto error;
+	}
+	dev_reg_status = 2;
 
 	retval = device_create_file(&pdev->dev, &dev_attr_langwell_udc);
-	if (retval)
+	if (retval) {
+		dev_create_file = 1;
 		goto error;
+	}
 
 	VDBG(dev, "<--- %s()\n", __func__);
 	return 0;
diff --git a/drivers/usb/gadget/langwell_udc.h b/drivers/usb/gadget/langwell_udc.h
index 9719934..cc5d9b6 100644
--- a/drivers/usb/gadget/langwell_udc.h
+++ b/drivers/usb/gadget/langwell_udc.h
@@ -199,7 +199,9 @@ struct langwell_udc {
 				vbus_active:1,
 				suspended:1,
 				stopped:1,
-				lpm:1;	/* LPM capability */
+				lpm:1,	/* LPM capability */
+				dev_reg_status:2,
+				dev_create_file:1;
 
 	/* pci state used to access those endpoints */
 	struct pci_dev		*pdev;
-- 
1.7.2.3

