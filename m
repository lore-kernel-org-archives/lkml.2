Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab0GaRjH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 13:39:07 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64898 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab0GaRjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 13:39:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=xGRhlpOjD0qfZGBfajJhewMDgVnfXh1PQMBzFg1vpB8BJIhhxay2qMXsc7FF/CzLvi
         pJe4W3w0LwCs5KDLGboGvAWNlNb8Lht1SistJpThfQflrY5wigADs/cZ0ehcTkrK1dx3
         pU3wCFHkpwkPvdiSHVB2gN03TtK4/aE2vgxBA=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Dan Carpenter <error27@gmail.com>,
        =?UTF-8?q?N=C3=A9meth=20M=C3=A1rton?= <nm127@freemail.hu>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] usb: goku_udc: fix error path
Date: Sat, 31 Jul 2010 21:38:44 +0400
Message-Id: <1280597924-8445-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

create_proc_read_entry() may fail, if so return -ENOMEM.
Also call pci_set_drvdata() a bit earlier as private data is used in
cleanup code.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/usb/gadget/goku_udc.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/goku_udc.c b/drivers/usb/gadget/goku_udc.c
index 1088d08..d62e214 100644
--- a/drivers/usb/gadget/goku_udc.c
+++ b/drivers/usb/gadget/goku_udc.c
@@ -1784,6 +1784,7 @@ static int goku_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		retval = -ENOMEM;
 		goto done;
 	}
+	pci_set_drvdata(pdev, dev);
 
 	spin_lock_init(&dev->lock);
 	dev->pdev = pdev;
@@ -1821,7 +1822,6 @@ static int goku_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 	dev->regs = (struct goku_udc_regs __iomem *) base;
 
-	pci_set_drvdata(pdev, dev);
 	INFO(dev, "%s\n", driver_desc);
 	INFO(dev, "version: " DRIVER_VERSION " %s\n", dmastr());
 	INFO(dev, "irq %d, pci mem %p\n", pdev->irq, base);
@@ -1841,7 +1841,11 @@ static int goku_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 
 #ifdef CONFIG_USB_GADGET_DEBUG_FILES
-	create_proc_read_entry(proc_node_name, 0, NULL, udc_proc_read, dev);
+	if (create_proc_read_entry(proc_node_name, 0, NULL,
+			    udc_proc_read, dev) == NULL) {
+		retval = -ENOMEM;
+		goto done;
+	}
 #endif
 
 	/* done */
-- 
1.7.0.4

