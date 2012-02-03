Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab2BCHG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 02:06:59 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37443 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab2BCHG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 02:06:56 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 2/3] pch_udc: Detecting VBUS through GPIO with interrupt
Date: Fri,  3 Feb 2012 16:14:18 +0900
Message-Id: <1328253259-9343-2-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1328253259-9343-1-git-send-email-tomoya.rohm@gmail.com>
References: <1328253259-9343-1-git-send-email-tomoya.rohm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Problem:
 pch_udc continues operation even if VBUS becomes Low.
 pch_udc performs D+ pulling up before VBUS becomes High.
 USB device should be controlled according to VBUS state.

Root cause:
 The current pch_udc is not always monitoring VBUS.

Solution:
 The change of VBUS is detected using an interrupt of GPIO.
 If VBUS became Low, pch_udc handles 'disconnect'.
 After VBUS became High, a pull improves D+, and pch_udc
 handles 'connect'.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/usb/gadget/pch_udc.c |   85 ++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 82 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
index d77211c..942fe92 100644
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -306,11 +306,15 @@ struct pch_udc_ep {
  * struct pch_vbus_gpio_data - Structure holding GPIO informaton
  *					for detecting VBUS
  * @port:		gpio port number
+ * @intr:		gpio interrupt number
  * @irq_work_fall	Structure for WorkQueue
+ * @irq_work_rise	Structure for WorkQueue
  */
 struct pch_vbus_gpio_data {
 	int			port;
+	int			intr;
 	struct work_struct	irq_work_fall;
+	struct work_struct	irq_work_rise;
 };
 
 /**
@@ -1296,8 +1300,10 @@ static void pch_vbus_gpio_work_fall(struct work_struct *irq_work)
 				dev->driver->disconnect(
 					&dev->gadget);
 			}
-			pch_udc_reconnect(dev);
-			dev_dbg(&dev->pdev->dev, "VBUS fell");
+			if (dev->vbus_gpio.intr)
+				pch_udc_init(dev);
+			else
+				pch_udc_reconnect(dev);
 			return;
 		}
 		vbus_saved = vbus;
@@ -1306,6 +1312,57 @@ static void pch_vbus_gpio_work_fall(struct work_struct *irq_work)
 }
 
 /**
+ * pch_vbus_gpio_work_rise() - This API checks VBUS is High.
+ *                             If VBUS is High, connect is processed
+ * @irq_work:	Structure for WorkQueue
+ *
+ */
+static void pch_vbus_gpio_work_rise(struct work_struct *irq_work)
+{
+	struct pch_vbus_gpio_data *vbus_gpio = container_of(irq_work,
+		struct pch_vbus_gpio_data, irq_work_rise);
+	struct pch_udc_dev *dev =
+		container_of(vbus_gpio, struct pch_udc_dev, vbus_gpio);
+	int vbus;
+
+	if (!dev->vbus_gpio.port)
+		return;
+
+	mdelay(PCH_VBUS_INTERVAL);
+	vbus = pch_vbus_gpio_get_value(dev);
+
+	if (vbus == 1) {
+		dev_dbg(&dev->pdev->dev, "VBUS rose");
+		pch_udc_reconnect(dev);
+		return;
+	}
+}
+
+/**
+ * pch_vbus_gpio_irq() - IRQ handler for GPIO intrerrupt for changing VBUS
+ * @irq:	Interrupt request number
+ * @dev:	Reference to the device structure
+ *
+ * Return codes:
+ *	0: Success
+ *	-EINVAL: GPIO port is invalid or can't be initialized.
+ */
+static irqreturn_t pch_vbus_gpio_irq(int irq, void *data)
+{
+	struct pch_udc_dev *dev = (struct pch_udc_dev *)data;
+
+	if (!dev->vbus_gpio.port || !dev->vbus_gpio.intr)
+		return IRQ_NONE;
+
+	if (pch_vbus_gpio_get_value(dev))
+		schedule_work(&dev->vbus_gpio.irq_work_rise);
+	else
+		schedule_work(&dev->vbus_gpio.irq_work_fall);
+
+	return IRQ_HANDLED;
+}
+
+/**
  * pch_vbus_gpio_init() - This API initializes GPIO port detecting VBUS.
  * @dev:	Reference to the driver structure
  * @vbus_gpio	Number of GPIO port to detect gpio
@@ -1317,8 +1374,10 @@ static void pch_vbus_gpio_work_fall(struct work_struct *irq_work)
 static int pch_vbus_gpio_init(struct pch_udc_dev *dev, int vbus_gpio_port)
 {
 	int err;
+	int irq_num = 0;
 
 	dev->vbus_gpio.port = 0;
+	dev->vbus_gpio.intr = 0;
 
 	if (vbus_gpio_port <= -1)
 		return -EINVAL;
@@ -1341,6 +1400,21 @@ static int pch_vbus_gpio_init(struct pch_udc_dev *dev, int vbus_gpio_port)
 	gpio_direction_input(vbus_gpio_port);
 	INIT_WORK(&dev->vbus_gpio.irq_work_fall, pch_vbus_gpio_work_fall);
 
+	irq_num = gpio_to_irq(vbus_gpio_port);
+	if (irq_num > 0) {
+		irq_set_irq_type(irq_num, IRQ_TYPE_EDGE_BOTH);
+		err = request_irq(irq_num, pch_vbus_gpio_irq, 0,
+			"vbus_detect", dev);
+		if (!err) {
+			dev->vbus_gpio.intr = irq_num;
+			INIT_WORK(&dev->vbus_gpio.irq_work_rise,
+				pch_vbus_gpio_work_rise);
+		} else {
+			pr_err("%s: can't request irq %d, err: %d\n",
+				__func__, irq_num, err);
+		}
+	}
+
 	return 0;
 }
 
@@ -1350,6 +1424,9 @@ static int pch_vbus_gpio_init(struct pch_udc_dev *dev, int vbus_gpio_port)
  */
 static void pch_vbus_gpio_free(struct pch_udc_dev *dev)
 {
+	if (dev->vbus_gpio.intr)
+		free_irq(dev->vbus_gpio.intr, dev);
+
 	if (dev->vbus_gpio.port)
 		gpio_free(dev->vbus_gpio.port);
 }
@@ -2677,6 +2754,7 @@ static void pch_udc_dev_isr(struct pch_udc_dev *dev, u32 dev_intr)
 			pch_udc_reconnect(dev);
 		} else if ((dev->vbus_session == 0)
 			&& (vbus == 1))
+			&&!dev->vbus_gpio.intr)
 			schedule_work(&dev->vbus_gpio.irq_work_fall);
 
 		dev_dbg(&dev->pdev->dev, "USB_SUSPEND\n");
@@ -2941,7 +3019,8 @@ static int pch_udc_start(struct usb_gadget_driver *driver,
 	pch_udc_setup_ep0(dev);
 
 	/* clear SD */
-	pch_udc_clear_disconnect(dev);
+	if ((pch_vbus_gpio_get_value(dev) != 0) || !dev->vbus_gpio.intr)
+		pch_udc_clear_disconnect(dev);
 
 	dev->connected = 1;
 	return 0;
-- 
1.7.7.6

