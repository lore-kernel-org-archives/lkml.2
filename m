Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab2BCH1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 02:27:42 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63421 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282Ab2BCH1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 02:27:41 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 1/3 v2] pch_udc: Detecting VBUS through GPIO
Date: Fri,  3 Feb 2012 16:35:26 +0900
Message-Id: <1328254526-9447-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Problem:
 In USB Suspend, pch_udc handles 'disconnect'.

Root cause:
 The current pch_udc is not monitoring VBUS.
 When USB cable is disconnected, USB Device Controller generates
 an interrupt of USB Suspend.
 pch_udc cannot distinguish it is USB Suspend or disconnect.
 Therefore, pch_udc handles 'disconnect' after an interrupt of
 USB Suspend happend.

Solution:
 VBUS is detected through GPIO.
 After an interrupt produced USB Suspend, if VBUS is Low,
 pch_udc handles 'disconnect'.
 If VBUS is High, pch_udc handles 'suspend'.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
v2: add changelog (v1 doesn't include any changelog.)
---
 drivers/usb/gadget/pch_udc.c |  145 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 142 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
index 01ff48d..d77211c 100644
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -15,6 +15,13 @@
 #include <linux/interrupt.h>
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
+#include <linux/gpio.h>
+
+/* GPIO port for VBUS detecting */
+static int vbus_gpio_port = -1;		/* GPIO port number (-1:Not used) */
+
+#define PCH_VBUS_PERIOD		3000	/* VBUS polling period (msec) */
+#define PCH_VBUS_INTERVAL	10	/* VBUS polling interval (msec) */
 
 /* Address offset of Registers */
 #define UDC_EP_REG_SHIFT	0x20	/* Offset to next EP */
@@ -296,6 +303,17 @@ struct pch_udc_ep {
 };
 
 /**
+ * struct pch_vbus_gpio_data - Structure holding GPIO informaton
+ *					for detecting VBUS
+ * @port:		gpio port number
+ * @irq_work_fall	Structure for WorkQueue
+ */
+struct pch_vbus_gpio_data {
+	int			port;
+	struct work_struct	irq_work_fall;
+};
+
+/**
  * struct pch_udc_dev - Structure holding complete information
  *			of the PCH USB device
  * @gadget:		gadget driver data
@@ -323,6 +341,7 @@ struct pch_udc_ep {
  * @base_addr:		for mapped device memory
  * @irq:		IRQ line for the device
  * @cfg_data:		current cfg, intf, and alt in use
+ * @vbus_gpio:		GPIO informaton for detecting VBUS
  */
 struct pch_udc_dev {
 	struct usb_gadget		gadget;
@@ -349,7 +368,8 @@ struct pch_udc_dev {
 	unsigned long			phys_addr;
 	void __iomem			*base_addr;
 	unsigned			irq;
-	struct pch_udc_cfg_data	cfg_data;
+	struct pch_udc_cfg_data		cfg_data;
+	struct pch_vbus_gpio_data	vbus_gpio;
 };
 
 #define PCH_UDC_PCI_BAR			1
@@ -1226,6 +1246,115 @@ static const struct usb_gadget_ops pch_udc_ops = {
 };
 
 /**
+ * pch_vbus_gpio_get_value() - This API gets value of GPIO port as VBUS status.
+ * @dev:	Reference to the driver structure
+ *
+ * Return value:
+ *	1: VBUS is high
+ *	0: VBUS is low
+ *     -1: It is not enable to detect VBUS using GPIO
+ */
+static int pch_vbus_gpio_get_value(struct pch_udc_dev *dev)
+{
+	int vbus = 0;
+
+	if (dev->vbus_gpio.port)
+		vbus = gpio_get_value(dev->vbus_gpio.port) ? 1 : 0;
+	else
+		vbus = -1;
+
+	return vbus;
+}
+
+/**
+ * pch_vbus_gpio_work_fall() - This API keeps watch on VBUS becoming Low.
+ *                             If VBUS is Low, disconnect is processed
+ * @irq_work:	Structure for WorkQueue
+ *
+ */
+static void pch_vbus_gpio_work_fall(struct work_struct *irq_work)
+{
+	struct pch_vbus_gpio_data *vbus_gpio = container_of(irq_work,
+		struct pch_vbus_gpio_data, irq_work_fall);
+	struct pch_udc_dev *dev =
+		container_of(vbus_gpio, struct pch_udc_dev, vbus_gpio);
+	int vbus_saved = -1;
+	int vbus;
+	int count;
+
+	if (!dev->vbus_gpio.port)
+		return;
+
+	for (count = 0; count < (PCH_VBUS_PERIOD / PCH_VBUS_INTERVAL);
+		count++) {
+		vbus = pch_vbus_gpio_get_value(dev);
+
+		if ((vbus_saved == vbus) && (vbus == 0)) {
+			dev_dbg(&dev->pdev->dev, "VBUS fell");
+			if (dev->driver
+				&& dev->driver->disconnect) {
+				dev->driver->disconnect(
+					&dev->gadget);
+			}
+			pch_udc_reconnect(dev);
+			dev_dbg(&dev->pdev->dev, "VBUS fell");
+			return;
+		}
+		vbus_saved = vbus;
+		mdelay(PCH_VBUS_INTERVAL);
+	}
+}
+
+/**
+ * pch_vbus_gpio_init() - This API initializes GPIO port detecting VBUS.
+ * @dev:	Reference to the driver structure
+ * @vbus_gpio	Number of GPIO port to detect gpio
+ *
+ * Return codes:
+ *	0: Success
+ *	-EINVAL: GPIO port is invalid or can't be initialized.
+ */
+static int pch_vbus_gpio_init(struct pch_udc_dev *dev, int vbus_gpio_port)
+{
+	int err;
+
+	dev->vbus_gpio.port = 0;
+
+	if (vbus_gpio_port <= -1)
+		return -EINVAL;
+
+	err = gpio_is_valid(vbus_gpio_port);
+	if (!err) {
+		pr_err("%s: gpio port %d is invalid\n",
+			__func__, vbus_gpio_port);
+		return -EINVAL;
+	}
+
+	err = gpio_request(vbus_gpio_port, "pch_vbus");
+	if (err) {
+		pr_err("%s: can't request gpio port %d, err: %d\n",
+			__func__, vbus_gpio_port, err);
+		return -EINVAL;
+	}
+
+	dev->vbus_gpio.port = vbus_gpio_port;
+	gpio_direction_input(vbus_gpio_port);
+	INIT_WORK(&dev->vbus_gpio.irq_work_fall, pch_vbus_gpio_work_fall);
+
+	return 0;
+}
+
+/**
+ * pch_vbus_gpio_free() - This API frees resources of GPIO port
+ * @dev:	Reference to the driver structure
+ */
+static void pch_vbus_gpio_free(struct pch_udc_dev *dev)
+{
+	if (dev->vbus_gpio.port)
+		gpio_free(dev->vbus_gpio.port);
+}
+
+/**
  * complete_req() - This API is invoked from the driver when processing
  *			of a request is complete
  * @ep:		Reference to the endpoint structure
@@ -2510,6 +2639,8 @@ static void pch_udc_svc_cfg_interrupt(struct pch_udc_dev *dev)
  */
 static void pch_udc_dev_isr(struct pch_udc_dev *dev, u32 dev_intr)
 {
+	int vbus;
+
 	/* USB Reset Interrupt */
 	if (dev_intr & UDC_DEVINT_UR) {
 		pch_udc_svc_ur_interrupt(dev);
@@ -2535,14 +2666,19 @@ static void pch_udc_dev_isr(struct pch_udc_dev *dev, u32 dev_intr)
 			spin_lock(&dev->lock);
 		}
 
-		if (dev->vbus_session == 0) {
+		vbus = pch_vbus_gpio_get_value(dev);
+		if ((dev->vbus_session == 0)
+			&& (vbus != 1)) {
 			if (dev->driver && dev->driver->disconnect) {
 				spin_unlock(&dev->lock);
 				dev->driver->disconnect(&dev->gadget);
 				spin_lock(&dev->lock);
 			}
 			pch_udc_reconnect(dev);
-		}
+		} else if ((dev->vbus_session == 0)
+			&& (vbus == 1))
+			schedule_work(&dev->vbus_gpio.irq_work_fall);
+
 		dev_dbg(&dev->pdev->dev, "USB_SUSPEND\n");
 	}
 	/* Clear the SOF interrupt, if enabled */
@@ -2704,6 +2840,7 @@ static int pch_udc_pcd_init(struct pch_udc_dev *dev)
 {
 	pch_udc_init(dev);
 	pch_udc_pcd_reinit(dev);
+	pch_vbus_gpio_init(dev, vbus_gpio_port);
 	return 0;
 }
 
@@ -2882,6 +3019,8 @@ static void pch_udc_remove(struct pci_dev *pdev)
 				 UDC_EP0OUT_BUFF_SIZE * 4, DMA_FROM_DEVICE);
 	kfree(dev->ep0out_buf);
 
+	pch_vbus_gpio_free(dev);
+
 	pch_udc_exit(dev);
 
 	if (dev->irq_registered)
-- 
1.7.7.6

