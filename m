Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab1LZEHA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 23:07:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57505 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab1LZEGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 23:06:50 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH] usb/gadget/pch_udc: Fix ether gadget connect/disconnect issue
Date: Mon, 26 Dec 2011 13:04:43 +0900
Message-Id: <1324872283-12813-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ISSUE:
After a USB cable is connect/disconnected, the system rarely freeze.
CAUSE:
Since the USB device controller cannot know to disconnect the USB cable, 
when it is used without detecting VBUS by GPIO, the UDC driver does not 
notify to USB Gadget.
Since USB Gadget cannot know to disconnect, a false setting occurred 
when the USB cable is connected/disconnect repeatedly.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/usb/gadget/pch_udc.c |  115 ++++++++++++++++++++++++++++++++++++++----
 1 files changed, 105 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
index 5048a0c..454028d 100644
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -311,6 +311,8 @@ struct pch_udc_ep {
  * @registered:		driver regsitered with system
  * @suspended:		driver in suspended state
  * @connected:		gadget driver associated
+ * @pullup:		required pullup state
+ * @vbus_session:	required vbus_session state
  * @set_cfg_not_acked:	pending acknowledgement 4 setup
  * @waiting_zlp_ack:	pending acknowledgement 4 ZLP
  * @data_requests:	DMA pool for data requests
@@ -337,6 +339,8 @@ struct pch_udc_dev {
 			registered:1,
 			suspended:1,
 			connected:1,
+			pullup:1,
+			vbus_session:1,
 			set_cfg_not_acked:1,
 			waiting_zlp_ack:1;
 	struct pci_pool		*data_requests;
@@ -554,6 +558,29 @@ static void pch_udc_clear_disconnect(struct pch_udc_dev *dev)
 }
 
 /**
+ * pch_udc_reconnect() - This API initializes usb device controller,
+ *						and clear the disconnect status.
+ * @dev:		Reference to pch_udc_regs structure
+ */
+static void pch_udc_init(struct pch_udc_dev *dev);
+static void pch_udc_reconnect(struct pch_udc_dev *dev)
+{
+	pch_udc_init(dev);
+
+	/* enable device interrupts */
+	/* pch_udc_enable_interrupts() */
+	pch_udc_bit_clr(dev, UDC_DEVIRQMSK_ADDR,
+			UDC_DEVINT_UR | UDC_DEVINT_ENUM);
+
+	/* Clear the disconnect */
+	pch_udc_bit_set(dev, UDC_DEVCTL_ADDR, UDC_DEVCTL_RES);
+	pch_udc_bit_clr(dev, UDC_DEVCTL_ADDR, UDC_DEVCTL_SD);
+	mdelay(1);
+	/* Resume USB signalling */
+	pch_udc_bit_clr(dev, UDC_DEVCTL_ADDR, UDC_DEVCTL_RES);
+}
+
+/**
  * pch_udc_vbus_session() - set or clearr the disconnect status.
  * @dev:	Reference to pch_udc_regs structure
  * @is_active:	Parameter specifying the action
@@ -563,10 +590,23 @@ static void pch_udc_clear_disconnect(struct pch_udc_dev *dev)
 static inline void pch_udc_vbus_session(struct pch_udc_dev *dev,
 					  int is_active)
 {
-	if (is_active)
-		pch_udc_clear_disconnect(dev);
-	else
+	if (is_active) {
+		if (dev->pullup == 1) {
+			if (dev->vbus_session == 1)
+				pch_udc_clear_disconnect(dev);
+			else
+				pch_udc_reconnect(dev);
+		}
+		dev->vbus_session = 1;
+	} else {
+		if (dev->driver && dev->driver->disconnect) {
+			spin_unlock(&dev->lock);
+			dev->driver->disconnect(&dev->gadget);
+			spin_lock(&dev->lock);
+		}
 		pch_udc_set_disconnect(dev);
+		dev->vbus_session = 0;
+	}
 }
 
 /**
@@ -1126,7 +1166,23 @@ static int pch_udc_pcd_pullup(struct usb_gadget *gadget, int is_on)
 	if (!gadget)
 		return -EINVAL;
 	dev = container_of(gadget, struct pch_udc_dev, gadget);
-	pch_udc_vbus_session(dev, is_on);
+	if (is_on) {
+		if (dev->pullup == 1) {
+			pch_udc_clear_disconnect(dev);
+		} else {
+			pch_udc_reconnect(dev);
+			dev->pullup = 1;
+		}
+	} else {
+		if (dev->driver && dev->driver->disconnect) {
+			spin_unlock(&dev->lock);
+			dev->driver->disconnect(&dev->gadget);
+			spin_lock(&dev->lock);
+		}
+		pch_udc_set_disconnect(dev);
+		dev->pullup = 0;
+	}
+
 	return 0;
 }
 
@@ -2335,8 +2391,11 @@ static void pch_udc_svc_ur_interrupt(struct pch_udc_dev *dev)
 		/* Complete request queue */
 		empty_req_queue(ep);
 	}
-	if (dev->driver && dev->driver->disconnect)
+	if (dev->driver && dev->driver->disconnect) {
+		spin_unlock(&dev->lock);
 		dev->driver->disconnect(&dev->gadget);
+		spin_lock(&dev->lock);
+	}
 }
 
 /**
@@ -2371,6 +2430,11 @@ static void pch_udc_svc_enum_interrupt(struct pch_udc_dev *dev)
 	pch_udc_set_dma(dev, DMA_DIR_TX);
 	pch_udc_set_dma(dev, DMA_DIR_RX);
 	pch_udc_ep_set_rrdy(&(dev->ep[UDC_EP0OUT_IDX]));
+
+	/* enable device interrupts */
+	pch_udc_enable_interrupts(dev, UDC_DEVINT_UR | UDC_DEVINT_US |
+					UDC_DEVINT_ES | UDC_DEVINT_ENUM |
+					UDC_DEVINT_SI | UDC_DEVINT_SC);
 }
 
 /**
@@ -2460,11 +2524,15 @@ static void pch_udc_svc_cfg_interrupt(struct pch_udc_dev *dev)
 static void pch_udc_dev_isr(struct pch_udc_dev *dev, u32 dev_intr)
 {
 	/* USB Reset Interrupt */
-	if (dev_intr & UDC_DEVINT_UR)
+	if (dev_intr & UDC_DEVINT_UR) {
 		pch_udc_svc_ur_interrupt(dev);
+		dev_dbg(&dev->pdev->dev, "USB_RESET\n");
+	}
 	/* Enumeration Done Interrupt */
-	if (dev_intr & UDC_DEVINT_ENUM)
+	if (dev_intr & UDC_DEVINT_ENUM) {
 		pch_udc_svc_enum_interrupt(dev);
+		dev_dbg(&dev->pdev->dev, "USB_ENUM\n");
+	}
 	/* Set Interface Interrupt */
 	if (dev_intr & UDC_DEVINT_SI)
 		pch_udc_svc_intf_interrupt(dev);
@@ -2472,8 +2540,25 @@ static void pch_udc_dev_isr(struct pch_udc_dev *dev, u32 dev_intr)
 	if (dev_intr & UDC_DEVINT_SC)
 		pch_udc_svc_cfg_interrupt(dev);
 	/* USB Suspend interrupt */
-	if (dev_intr & UDC_DEVINT_US)
+	if (dev_intr & UDC_DEVINT_US) {
+		if (dev->gadget.speed != USB_SPEED_UNKNOWN
+			&& dev->driver
+			&& dev->driver->suspend) {
+			spin_unlock(&dev->lock);
+			dev->driver->suspend(&dev->gadget);
+			spin_lock(&dev->lock);
+		}
+
+		if ((dev->vbus_session == 0) && (dev->pullup == 1)) {
+			if (dev->driver && dev->driver->disconnect) {
+				spin_unlock(&dev->lock);
+				dev->driver->disconnect(&dev->gadget);
+				spin_lock(&dev->lock);
+			}
+			pch_udc_reconnect(dev);
+		}
 		dev_dbg(&dev->pdev->dev, "USB_SUSPEND\n");
+	}
 	/* Clear the SOF interrupt, if enabled */
 	if (dev_intr & UDC_DEVINT_SOF)
 		dev_dbg(&dev->pdev->dev, "SOF\n");
@@ -2499,6 +2584,14 @@ static irqreturn_t pch_udc_isr(int irq, void *pdev)
 	dev_intr = pch_udc_read_device_interrupts(dev);
 	ep_intr = pch_udc_read_ep_interrupts(dev);
 
+	/* For a hot plug, this find that the controller is hung up. */
+	if (dev_intr == ep_intr)
+		if (dev_intr == pch_udc_readl(dev, UDC_DEVCFG_ADDR)) {
+			dev_dbg(&dev->pdev->dev, "UDC: Hung up\n");
+			/* The controller is reset */
+			pch_udc_writel(dev, UDC_SRST, UDC_SRST_ADDR);
+			return IRQ_HANDLED;
+		}
 	if (dev_intr)
 		/* Clear device interrupts */
 		pch_udc_write_device_interrupts(dev, dev_intr);
@@ -2725,7 +2818,7 @@ static int pch_udc_start(struct usb_gadget_driver *driver,
 	pch_udc_setup_ep0(dev);
 
 	/* clear SD */
-	pch_udc_clear_disconnect(dev);
+	pch_udc_pcd_pullup(&dev->gadget, 1);
 
 	dev->connected = 1;
 	return 0;
@@ -2912,8 +3005,10 @@ static int pch_udc_probe(struct pci_dev *pdev,
 	}
 	pch_udc = dev;
 	/* initialize the hardware */
-	if (pch_udc_pcd_init(dev))
+	if (pch_udc_pcd_init(dev)) {
+		retval = -ENODEV;
 		goto finished;
+	}
 	if (request_irq(pdev->irq, pch_udc_isr, IRQF_SHARED, KBUILD_MODNAME,
 			dev)) {
 		dev_err(&pdev->dev, "%s: request_irq(%d) fail\n", __func__,
-- 
1.7.4.4

