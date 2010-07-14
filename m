Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab0GNLb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 07:31:59 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:40328 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751945Ab0GNLb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 07:31:57 -0400
Date: Wed, 14 Jul 2010 13:31:55 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 1/3] usb/gadget: Remove dead CONFIG_USB_LANGWELL_OTG
Message-ID: <4dd884f3ca70240035a8810d430e35ccf7d54ac3.1279104996.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1279104996.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1279104996.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_USB_LANGWELL_OTG doesn't exist in Kconfig, therefore removing all
references for it from the source code.

Because CONFIG_USB_LANGWELL_OTG can't be selected, OTG_TRANSRECEIVER
can't be selected either, so all references to this can be removed also.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 drivers/usb/gadget/langwell_udc.c |   84 +------------------------------------
 drivers/usb/gadget/langwell_udc.h |    5 --
 2 files changed, 1 insertions(+), 88 deletions(-)

diff --git a/drivers/usb/gadget/langwell_udc.c b/drivers/usb/gadget/langwell_udc.c
index a391351..b2dfbc7 100644
--- a/drivers/usb/gadget/langwell_udc.c
+++ b/drivers/usb/gadget/langwell_udc.c
@@ -21,11 +21,6 @@
 /* #undef	DEBUG */
 /* #undef	VERBOSE */
 
-#if defined(CONFIG_USB_LANGWELL_OTG)
-#define	OTG_TRANSCEIVER
-#endif
-
-
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
@@ -2251,10 +2246,6 @@ static void handle_setup_packet(struct langwell_udc *dev,
 				break;
 			else if (setup->bRequest == USB_DEVICE_B_HNP_ENABLE) {
 				dev->gadget.b_hnp_enable = 1;
-#ifdef	OTG_TRANSCEIVER
-				if (!dev->lotg->otg.default_a)
-					dev->lotg->hsm.b_hnp_enable = 1;
-#endif
 			} else if (setup->bRequest == USB_DEVICE_A_HNP_SUPPORT)
 				dev->gadget.a_hnp_support = 1;
 			else if (setup->bRequest ==
@@ -2685,12 +2676,6 @@ static void handle_usb_reset(struct langwell_udc *dev)
 		dev->usb_state = USB_STATE_ATTACHED;
 	}
 
-#ifdef	OTG_TRANSCEIVER
-	/* refer to USB OTG 6.6.2.3 b_hnp_en is cleared */
-	if (!dev->lotg->otg.default_a)
-		dev->lotg->hsm.b_hnp_enable = 0;
-#endif
-
 	VDBG(dev, "<--- %s()\n", __func__);
 }
 
@@ -2704,29 +2689,6 @@ static void handle_bus_suspend(struct langwell_udc *dev)
 	dev->resume_state = dev->usb_state;
 	dev->usb_state = USB_STATE_SUSPENDED;
 
-#ifdef	OTG_TRANSCEIVER
-	if (dev->lotg->otg.default_a) {
-		if (dev->lotg->hsm.b_bus_suspend_vld == 1) {
-			dev->lotg->hsm.b_bus_suspend = 1;
-			/* notify transceiver the state changes */
-			if (spin_trylock(&dev->lotg->wq_lock)) {
-				langwell_update_transceiver();
-				spin_unlock(&dev->lotg->wq_lock);
-			}
-		}
-		dev->lotg->hsm.b_bus_suspend_vld++;
-	} else {
-		if (!dev->lotg->hsm.a_bus_suspend) {
-			dev->lotg->hsm.a_bus_suspend = 1;
-			/* notify transceiver the state changes */
-			if (spin_trylock(&dev->lotg->wq_lock)) {
-				langwell_update_transceiver();
-				spin_unlock(&dev->lotg->wq_lock);
-			}
-		}
-	}
-#endif
-
 	/* report suspend to the driver */
 	if (dev->driver) {
 		if (dev->driver->suspend) {
@@ -2761,11 +2723,6 @@ static void handle_bus_resume(struct langwell_udc *dev)
 	devlc &= ~LPM_PHCD;
 	writel(devlc, &dev->op_regs->devlc);
 
-#ifdef	OTG_TRANSCEIVER
-	if (dev->lotg->otg.default_a == 0)
-		dev->lotg->hsm.a_bus_suspend = 0;
-#endif
-
 	/* report resume to the driver */
 	if (dev->driver) {
 		if (dev->driver->resume) {
@@ -2929,7 +2886,6 @@ static void langwell_udc_remove(struct pci_dev *pdev)
 	if (dev->got_irq)
 		free_irq(pdev->irq, dev);
 
-#ifndef	OTG_TRANSCEIVER
 	if (dev->cap_regs)
 		iounmap(dev->cap_regs);
 
@@ -2939,13 +2895,6 @@ static void langwell_udc_remove(struct pci_dev *pdev)
 
 	if (dev->enabled)
 		pci_disable_device(pdev);
-#else
-	if (dev->transceiver) {
-		otg_put_transceiver(dev->transceiver);
-		dev->transceiver = NULL;
-		dev->lotg = NULL;
-	}
-#endif
 
 	dev->cap_regs = NULL;
 
@@ -2955,9 +2904,7 @@ static void langwell_udc_remove(struct pci_dev *pdev)
 	device_unregister(&dev->gadget.dev);
 	device_remove_file(&pdev->dev, &dev_attr_langwell_udc);
 
-#ifndef	OTG_TRANSCEIVER
 	pci_set_drvdata(pdev, NULL);
-#endif
 
 	/* free dev, wait for the release() finished */
 	wait_for_completion(&done);
@@ -2974,9 +2921,7 @@ static int langwell_udc_probe(struct pci_dev *pdev,
 		const struct pci_device_id *id)
 {
 	struct langwell_udc	*dev;
-#ifndef	OTG_TRANSCEIVER
 	unsigned long		resource, len;
-#endif
 	void			__iomem *base = NULL;
 	size_t			size;
 	int			retval;
@@ -2999,16 +2944,6 @@ static int langwell_udc_probe(struct pci_dev *pdev,
 	dev->pdev = pdev;
 	DBG(dev, "---> %s()\n", __func__);
 
-#ifdef	OTG_TRANSCEIVER
-	/* PCI device is already enabled by otg_transceiver driver */
-	dev->enabled = 1;
-
-	/* mem region and register base */
-	dev->region = 1;
-	dev->transceiver = otg_get_transceiver();
-	dev->lotg = otg_to_langwell(dev->transceiver);
-	base = dev->lotg->regs;
-#else
 	pci_set_drvdata(pdev, dev);
 
 	/* now all the pci goodies ... */
@@ -3029,7 +2964,7 @@ static int langwell_udc_probe(struct pci_dev *pdev,
 	dev->region = 1;
 
 	base = ioremap_nocache(resource, len);
-#endif
+
 	if (base == NULL) {
 		ERROR(dev, "can't map memory\n");
 		retval = -EFAULT;
@@ -3049,7 +2984,6 @@ static int langwell_udc_probe(struct pci_dev *pdev,
 		goto error;
 	}
 
-#ifndef	OTG_TRANSCEIVER
 	INFO(dev, "irq %d, io mem: 0x%08lx, len: 0x%08lx, pci mem 0x%p\n",
 			pdev->irq, resource, len, base);
 	/* enables bus-mastering for device dev */
@@ -3062,7 +2996,6 @@ static int langwell_udc_probe(struct pci_dev *pdev,
 		goto error;
 	}
 	dev->got_irq = 1;
-#endif
 
 	/* set stopped bit */
 	dev->stopped = 1;
@@ -3131,10 +3064,8 @@ static int langwell_udc_probe(struct pci_dev *pdev,
 	dev->ep0_dir = USB_DIR_OUT;
 	dev->remote_wakeup = 0;	/* default to 0 on reset */
 
-#ifndef	OTG_TRANSCEIVER
 	/* reset device controller */
 	langwell_udc_reset(dev);
-#endif
 
 	/* initialize gadget structure */
 	dev->gadget.ops = &langwell_ops;	/* usb_gadget_ops */
@@ -3142,9 +3073,6 @@ static int langwell_udc_probe(struct pci_dev *pdev,
 	INIT_LIST_HEAD(&dev->gadget.ep_list);	/* ep_list */
 	dev->gadget.speed = USB_SPEED_UNKNOWN;	/* speed */
 	dev->gadget.is_dualspeed = 1;		/* support dual speed */
-#ifdef	OTG_TRANSCEIVER
-	dev->gadget.is_otg = 1;			/* support otg mode */
-#endif
 
 	/* the "gadget" abstracts/virtualizes the controller */
 	dev_set_name(&dev->gadget.dev, "gadget");
@@ -3156,10 +3084,8 @@ static int langwell_udc_probe(struct pci_dev *pdev,
 	/* controller endpoints reinit */
 	eps_reinit(dev);
 
-#ifndef	OTG_TRANSCEIVER
 	/* reset ep0 dQH and endptctrl */
 	ep0_reset(dev);
-#endif
 
 	/* create dTD dma_pool resource */
 	dev->dtd_pool = dma_pool_create("langwell_dtd",
@@ -3351,22 +3277,14 @@ MODULE_LICENSE("GPL");
 
 static int __init init(void)
 {
-#ifdef	OTG_TRANSCEIVER
-	return langwell_register_peripheral(&langwell_pci_driver);
-#else
 	return pci_register_driver(&langwell_pci_driver);
-#endif
 }
 module_init(init);
 
 
 static void __exit cleanup(void)
 {
-#ifdef	OTG_TRANSCEIVER
-	return langwell_unregister_peripheral(&langwell_pci_driver);
-#else
 	pci_unregister_driver(&langwell_pci_driver);
-#endif
 }
 module_exit(cleanup);
 
diff --git a/drivers/usb/gadget/langwell_udc.h b/drivers/usb/gadget/langwell_udc.h
index 9719934..26d5edb 100644
--- a/drivers/usb/gadget/langwell_udc.h
+++ b/drivers/usb/gadget/langwell_udc.h
@@ -19,11 +19,6 @@
 
 #include <linux/usb/langwell_udc.h>
 
-#if defined(CONFIG_USB_LANGWELL_OTG)
-#include <linux/usb/langwell_otg.h>
-#endif
-
-
 /*-------------------------------------------------------------------------*/
 
 /* driver data structures and utilities */
-- 
1.7.0.4

