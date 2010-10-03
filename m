Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab0JCT7b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 15:59:31 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:52092 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab0JCT72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 15:59:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Nr/ZYmyyyq2kGLOapHjJ7ob+rWw9teTeqZ03ZbEA3CstFekRl44VEXdfj79NKaa0oB
         JDfbFaiNBsmeQK5wqbRrIVCOs3RuD9Rfbzhmj/VpTC5RKpqk+ecK+DJcgBJd192pdh9a
         1usqQBEh929TK/oIjP2G1P9meHUvKpfXnleg0=
From: Rahul Ruikar <rahul.ruikar@gmail.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Dan Carpenter <error27@gmail.com>,
        nm127@freemail.hu
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rahul Ruikar <rahul.ruikar@gmail.com>
Subject: [RESEND/PATCH] usb: gadget: goku_udc: Fix error path
Date: Mon,  4 Oct 2010 01:29:00 +0530
Message-Id: <1286135940-2364-1-git-send-email-rahul.ruikar@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

call put_device() when device_register() fails.

Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
---
 drivers/usb/gadget/goku_udc.c |   12 ++++++++++--
 drivers/usb/gadget/goku_udc.h |    3 ++-
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/goku_udc.c b/drivers/usb/gadget/goku_udc.c
index 1088d08..bb70125 100644
--- a/drivers/usb/gadget/goku_udc.c
+++ b/drivers/usb/gadget/goku_udc.c
@@ -1744,7 +1744,10 @@ static void goku_remove(struct pci_dev *pdev)
 				pci_resource_len (pdev, 0));
 	if (dev->enabled)
 		pci_disable_device(pdev);
-	device_unregister(&dev->gadget.dev);
+	if (dev->reg_status == 2)
+		device_unregister(&dev->gadget.dev);
+	else if (dev->reg_status == 1)
+		put_device(&dev->gadget.dev);
 
 	pci_set_drvdata(pdev, NULL);
 	dev->regs = NULL;
@@ -1847,8 +1850,13 @@ static int goku_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* done */
 	the_controller = dev;
 	retval = device_register(&dev->gadget.dev);
-	if (retval == 0)
+	if (retval != 0) {
+		dev->reg_status = 2;
+		goto done;
+	} else {
+		dev->reg_status = 1;
 		return 0;
+	}
 
 done:
 	if (dev)
diff --git a/drivers/usb/gadget/goku_udc.h b/drivers/usb/gadget/goku_udc.h
index 566cb23..64f2bfb 100644
--- a/drivers/usb/gadget/goku_udc.h
+++ b/drivers/usb/gadget/goku_udc.h
@@ -251,7 +251,8 @@ struct goku_udc {
 					got_region:1,
 					req_config:1,
 					configured:1,
-					enabled:1;
+					enabled:1,
+					reg_status:2;
 
 	/* pci state used to access those endpoints */
 	struct pci_dev			*pdev;
-- 
1.7.2.3

