Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab0JEQ4P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 12:56:15 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44574 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab0JEQ4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 12:56:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=FyTT/n+tO3FUBzASLDGb8paEmnSp+llLup5AsOXMRnlOQy8kf2iga1lp4PHONEVduw
         V8XuGiPoAplUWdfJ/DnrvxmRClTGIF5CqA3HokEP8e3sa7Kl4tIPHCoceP1rIG+586UK
         mr3e/G36xJQFQ0e7ypDAu/8o/tdvVGPBpcaUY=
Date: Tue, 5 Oct 2010 18:55:34 +0200
From: Dan Carpenter <error27@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Rahul Ruikar <rahul.ruikar@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>, nm127@freemail.hu,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: gadget: goku_udc: Fix error path
Message-ID: <20101005165534.GJ5692@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Greg KH <gregkh@suse.de>, Rahul Ruikar <rahul.ruikar@gmail.com>,
	David Brownell <dbrownell@users.sourceforge.net>, nm127@freemail.hu,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1286135940-2364-1-git-send-email-rahul.ruikar@gmail.com> <20101004122214.GA5692@bicker> <20101005132005.GB3548@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101005132005.GB3548@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is based on an initial patch by Rahul Ruikar.

The goku_remove() function can be called before device_register() so it
can call device_unregister() improperly.  Also if the call to 
device_register() fails we need to call put_device().

As I was changing the error handling in goku_probe(), I noticed that
the label was "done" but actually if the function succeeds we return
earlier.  I renamed the error path to "err" instead of "done."

Reported-by: Rahul Ruikar <rahul.ruikar@gmail.com>
Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/usb/gadget/goku_udc.c b/drivers/usb/gadget/goku_udc.c
index 1088d08..7232018 100644
--- a/drivers/usb/gadget/goku_udc.c
+++ b/drivers/usb/gadget/goku_udc.c
@@ -1744,7 +1744,8 @@ static void goku_remove(struct pci_dev *pdev)
 				pci_resource_len (pdev, 0));
 	if (dev->enabled)
 		pci_disable_device(pdev);
-	device_unregister(&dev->gadget.dev);
+	if (dev->registered)
+		device_unregister(&dev->gadget.dev);
 
 	pci_set_drvdata(pdev, NULL);
 	dev->regs = NULL;
@@ -1774,7 +1775,7 @@ static int goku_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!pdev->irq) {
 		printk(KERN_ERR "Check PCI %s IRQ setup!\n", pci_name(pdev));
 		retval = -ENODEV;
-		goto done;
+		goto err;
 	}
 
 	/* alloc, and start init */
@@ -1782,7 +1783,7 @@ static int goku_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (dev == NULL){
 		pr_debug("enomem %s\n", pci_name(pdev));
 		retval = -ENOMEM;
-		goto done;
+		goto err;
 	}
 
 	spin_lock_init(&dev->lock);
@@ -1800,7 +1801,7 @@ static int goku_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	retval = pci_enable_device(pdev);
 	if (retval < 0) {
 		DBG(dev, "can't enable, %d\n", retval);
-		goto done;
+		goto err;
 	}
 	dev->enabled = 1;
 
@@ -1809,7 +1810,7 @@ static int goku_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!request_mem_region(resource, len, driver_name)) {
 		DBG(dev, "controller already in use\n");
 		retval = -EBUSY;
-		goto done;
+		goto err;
 	}
 	dev->got_region = 1;
 
@@ -1817,7 +1818,7 @@ static int goku_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (base == NULL) {
 		DBG(dev, "can't map memory\n");
 		retval = -EFAULT;
-		goto done;
+		goto err;
 	}
 	dev->regs = (struct goku_udc_regs __iomem *) base;
 
@@ -1833,7 +1834,7 @@ static int goku_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			driver_name, dev) != 0) {
 		DBG(dev, "request interrupt %d failed\n", pdev->irq);
 		retval = -EBUSY;
-		goto done;
+		goto err;
 	}
 	dev->got_irq = 1;
 	if (use_dma)
@@ -1844,13 +1845,16 @@ static int goku_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	create_proc_read_entry(proc_node_name, 0, NULL, udc_proc_read, dev);
 #endif
 
-	/* done */
 	the_controller = dev;
 	retval = device_register(&dev->gadget.dev);
-	if (retval == 0)
-		return 0;
+	if (retval) {
+		put_device(&dev->gadget.dev);
+		goto err;
+	}
+	dev->registered = 1;
+	return 0;
 
-done:
+err:
 	if (dev)
 		goku_remove (pdev);
 	return retval;
