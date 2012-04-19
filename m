Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964827Ab2DSVlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:41:22 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38471 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964782Ab2DSVNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:13:41 -0400
Message-Id: <20120419210614.621241654@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:06:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 41/59] usb: gadget: pch_udc: Fix usb/gadget/pch_udc: Fix ether gadget connect/disconnect issue
In-Reply-To: <20120419210623.GA12156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoya MORINAGA <tomoya.rohm@gmail.com>

commit 1c575d2d2e3ff2a7cb3c2e2165064199cfd8ad32 upstream.

ISSUE:
After a USB cable is connect/disconnected, the system rarely freezes.

CAUSE:
Since the USB device controller cannot know to disconnect the USB cable, when
it is used without detecting VBUS by GPIO, the UDC driver does not notify to
USB Gadget.

Since USB Gadget cannot know to disconnect, a false setting occurred when the
USB cable is connected/disconnect repeatedly.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/pch_udc.c |   70 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 66 insertions(+), 4 deletions(-)

--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -320,6 +320,7 @@ struct pch_udc_ep {
  * @registered:		driver regsitered with system
  * @suspended:		driver in suspended state
  * @connected:		gadget driver associated
+ * @vbus_session:	required vbus_session state
  * @set_cfg_not_acked:	pending acknowledgement 4 setup
  * @waiting_zlp_ack:	pending acknowledgement 4 ZLP
  * @data_requests:	DMA pool for data requests
@@ -346,6 +347,7 @@ struct pch_udc_dev {
 			registered:1,
 			suspended:1,
 			connected:1,
+			vbus_session:1,
 			set_cfg_not_acked:1,
 			waiting_zlp_ack:1;
 	struct pci_pool		*data_requests;
@@ -562,6 +564,31 @@ static void pch_udc_clear_disconnect(str
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
+			UDC_DEVINT_UR | UDC_DEVINT_US |
+			UDC_DEVINT_ENUM |
+			UDC_DEVINT_SI | UDC_DEVINT_SC);
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
@@ -571,10 +598,18 @@ static void pch_udc_clear_disconnect(str
 static inline void pch_udc_vbus_session(struct pch_udc_dev *dev,
 					  int is_active)
 {
-	if (is_active)
-		pch_udc_clear_disconnect(dev);
-	else
+	if (is_active) {
+		pch_udc_reconnect(dev);
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
@@ -1134,7 +1169,17 @@ static int pch_udc_pcd_pullup(struct usb
 	if (!gadget)
 		return -EINVAL;
 	dev = container_of(gadget, struct pch_udc_dev, gadget);
-	pch_udc_vbus_session(dev, is_on);
+	if (is_on) {
+		pch_udc_reconnect(dev);
+	} else {
+		if (dev->driver && dev->driver->disconnect) {
+			spin_unlock(&dev->lock);
+			dev->driver->disconnect(&dev->gadget);
+			spin_lock(&dev->lock);
+		}
+		pch_udc_set_disconnect(dev);
+	}
+
 	return 0;
 }
 
@@ -2485,6 +2530,15 @@ static void pch_udc_dev_isr(struct pch_u
 			dev->driver->suspend(&dev->gadget);
 			spin_lock(&dev->lock);
 		}
+
+		if (dev->vbus_session == 0) {
+			if (dev->driver && dev->driver->disconnect) {
+				spin_unlock(&dev->lock);
+				dev->driver->disconnect(&dev->gadget);
+				spin_lock(&dev->lock);
+			}
+			pch_udc_reconnect(dev);
+		}
 		dev_dbg(&dev->pdev->dev, "USB_SUSPEND\n");
 	}
 	/* Clear the SOF interrupt, if enabled */
@@ -2512,6 +2566,14 @@ static irqreturn_t pch_udc_isr(int irq,
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


