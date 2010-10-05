Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab0JESVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 14:21:17 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56772 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab0JESVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 14:21:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=IkB1zqzORS0EXcJPSZ1fqzFCHapKJkb8TzTFq3ZaGA2Du6IgRgLytx0anG8Hl+14j6
         JbDjZ5bHCxjPI9yEbmEJFQQ5yajR4HM1YyR7wM5OmsmavYW+NVZNE32WPNLCjXvodF9S
         Si0jiQZabB/PofwhVtnvmFCm4+TThqgV4jw2Y=
From: Rahul Ruikar <rahul.ruikar@gmail.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rahul Ruikar <rahul.ruikar@gmail.com>
Subject: [PATCH] usb: gadget: langwell_udc: Fix error path
Date: Tue,  5 Oct 2010 23:50:00 +0530
Message-Id: <1286302800-2715-1-git-send-email-rahul.ruikar@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for following cases
- Call device_unregister() only when device_register() is success.
- Call put_device() when device_register() fails.
- Call device_remove_file() only when device_create_file() is success.

Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
---
 drivers/usb/gadget/langwell_udc.c |   14 +++++++++++---
 drivers/usb/gadget/langwell_udc.h |    4 +++-
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/langwell_udc.c b/drivers/usb/gadget/langwell_udc.c
index c2d2a20..6a57bd6 100644
--- a/drivers/usb/gadget/langwell_udc.c
+++ b/drivers/usb/gadget/langwell_udc.c
@@ -2952,8 +2952,11 @@ static void langwell_udc_remove(struct pci_dev *pdev)
 	INFO(dev, "unbind\n");
 	DBG(dev, "<--- %s()\n", __func__);
 
-	device_unregister(&dev->gadget.dev);
-	device_remove_file(&pdev->dev, &dev_attr_langwell_udc);
+	if (dev->reg_status)
+		device_unregister(&dev->gadget.dev);
+
+	if (dev->file_create)
+		device_remove_file(&pdev->dev, &dev_attr_langwell_udc);
 
 #ifndef	OTG_TRANSCEIVER
 	pci_set_drvdata(pdev, NULL);
@@ -3190,13 +3193,18 @@ static int langwell_udc_probe(struct pci_dev *pdev,
 	the_controller = dev;
 
 	retval = device_register(&dev->gadget.dev);
-	if (retval)
+	if (retval) {
+		put_device(&dev->gadget.dev);
 		goto error;
+	}
+	dev->reg_status = 1;
 
 	retval = device_create_file(&pdev->dev, &dev_attr_langwell_udc);
 	if (retval)
 		goto error;
 
+	dev->file_create = 1;
+
 	VDBG(dev, "<--- %s()\n", __func__);
 	return 0;
 
diff --git a/drivers/usb/gadget/langwell_udc.h b/drivers/usb/gadget/langwell_udc.h
index 9719934..b212a70 100644
--- a/drivers/usb/gadget/langwell_udc.h
+++ b/drivers/usb/gadget/langwell_udc.h
@@ -199,7 +199,9 @@ struct langwell_udc {
 				vbus_active:1,
 				suspended:1,
 				stopped:1,
-				lpm:1;	/* LPM capability */
+				lpm:1,	/* LPM capability */
+				reg_status:1,
+				file_create:1;
 
 	/* pci state used to access those endpoints */
 	struct pci_dev		*pdev;
-- 
1.7.2.3

