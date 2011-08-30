Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab1H3PLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 11:11:50 -0400
Received: from smtp-out.google.com ([74.125.121.67]:53521 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab1H3PLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 11:11:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:from:to:cc:subject:date:message-id:x-mailer:
	in-reply-to:references:x-system-of-record;
	b=SjHkAMpAHe6Xg7mssVljaFmwm0lSDOHtRmabVoA0BKs9qFUVD95AUXeROjYgSOfD1
	NGQ7Hawq/iP0ICxLCko+w==
From: Michal Nazarewicz <mnazarewicz@google.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: Felipe Balbi <balbi@ti.com>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Dave Young" <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv5.1 1/4] usb: Provide usb_speed_string() function
Date: Tue, 30 Aug 2011 17:11:19 +0200
Message-Id: <00b7a9d47d736f9c3980dd06630c7e2f9bce85b8.1314716882.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <20110826183450.GA32142@kroah.com>
References: <20110826183450.GA32142@kroah.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

In a few places in the kernel, the code prints
a human-readable USB device speed (eg. "high speed").
This involves a switch statement sometimes wrapped
around in ({ ... }) block leading to code repetition.

To mitigate this issue, this commit introduces
usb_speed_string() function, which returns
a human-readable name of provided speed.

It also changes a few places switch was used to use
this new function.  This changes a bit the way the
speed is printed in few instances at the same time
standardising it.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/Kconfig                 |    5 +++
 drivers/usb/Makefile                |    2 +
 drivers/usb/core/hub.c              |   27 ++++++------------
 drivers/usb/gadget/amd5536udc.c     |    9 +----
 drivers/usb/gadget/atmel_usba_udc.c |    9 ++---
 drivers/usb/gadget/composite.c      |   22 ++------------
 drivers/usb/gadget/file_storage.c   |   15 ++-------
 drivers/usb/gadget/fsl_udc_core.c   |   53 ++++++++++++----------------------
 drivers/usb/gadget/gmidi.c          |   11 +------
 drivers/usb/gadget/langwell_udc.c   |   50 +++++++++++---------------------
 drivers/usb/gadget/net2272.c        |    4 +-
 drivers/usb/gadget/net2280.c        |    4 +--
 drivers/usb/gadget/printer.c        |   14 ++-------
 drivers/usb/gadget/s3c-hsotg.c      |    8 +----
 drivers/usb/gadget/udc-core.c       |   19 +-----------
 drivers/usb/misc/usbtest.c          |   21 +------------
 drivers/usb/usb-common.c            |   35 +++++++++++++++++++++++
 include/linux/usb/ch9.h             |   12 ++++++++
 18 files changed, 125 insertions(+), 195 deletions(-)
 create mode 100644 drivers/usb/usb-common.c

diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index 2651852..97c4cc7 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -12,6 +12,11 @@ menuconfig USB_SUPPORT
 
 if USB_SUPPORT
 
+config USB_COMMON
+	tristate
+	default y
+	depends on USB || USB_GADGET
+
 # Host-side USB depends on having a host controller
 # NOTE:  dummy_hcd is always an option, but it's ignored here ...
 # NOTE:  SL-811 option should be board-specific ...
diff --git a/drivers/usb/Makefile b/drivers/usb/Makefile
index 969b0a5..75eca76 100644
--- a/drivers/usb/Makefile
+++ b/drivers/usb/Makefile
@@ -53,3 +53,5 @@ obj-$(CONFIG_USB_MUSB_HDRC)	+= musb/
 obj-$(CONFIG_USB_RENESAS_USBHS)	+= renesas_usbhs/
 obj-$(CONFIG_USB_OTG_UTILS)	+= otg/
 obj-$(CONFIG_USB_GADGET)	+= gadget/
+
+obj-$(CONFIG_USB_COMMON)	+= usb-common.o
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 338f91f..3edc01b 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2793,7 +2793,7 @@ hub_port_init (struct usb_hub *hub, struct usb_device *udev, int port1,
 	int			i, j, retval;
 	unsigned		delay = HUB_SHORT_RESET_TIME;
 	enum usb_device_speed	oldspeed = udev->speed;
-	char 			*speed, *type;
+	const char		*speed;
 	int			devnum = udev->devnum;
 
 	/* root hub ports have a slightly longer reset period
@@ -2853,25 +2853,16 @@ hub_port_init (struct usb_hub *hub, struct usb_device *udev, int port1,
 	default:
 		goto fail;
 	}
- 
-	type = "";
-	switch (udev->speed) {
-	case USB_SPEED_LOW:	speed = "low";	break;
-	case USB_SPEED_FULL:	speed = "full";	break;
-	case USB_SPEED_HIGH:	speed = "high";	break;
-	case USB_SPEED_SUPER:
-				speed = "super";
-				break;
-	case USB_SPEED_WIRELESS:
-				speed = "variable";
-				type = "Wireless ";
-				break;
-	default: 		speed = "?";	break;
-	}
+
+	if (udev->speed == USB_SPEED_WIRELESS)
+		speed = "variable speed Wireless";
+	else
+		speed = usb_speed_string(udev->speed);
+
 	if (udev->speed != USB_SPEED_SUPER)
 		dev_info(&udev->dev,
-				"%s %s speed %sUSB device number %d using %s\n",
-				(udev->config) ? "reset" : "new", speed, type,
+				"%s %s USB device number %d using %s\n",
+				(udev->config) ? "reset" : "new", speed,
 				devnum, udev->bus->controller->driver->name);
 
 	/* Set up TT records, if needed  */
diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index d65d839..16eb8e2 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -3014,13 +3014,8 @@ __acquires(dev->lock)
 
 		/* link up all endpoints */
 		udc_setup_endpoints(dev);
-		if (dev->gadget.speed == USB_SPEED_HIGH) {
-			dev_info(&dev->pdev->dev, "Connect: speed = %s\n",
-				"high");
-		} else if (dev->gadget.speed == USB_SPEED_FULL) {
-			dev_info(&dev->pdev->dev, "Connect: speed = %s\n",
-				"full");
-		}
+		dev_info(&dev->pdev->dev, "Connect: %s\n",
+			 usb_speed_string(dev->gadget.speed));
 
 		/* init ep 0 */
 		activate_control_endpoints(dev);
diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
index 722c468..271a9d8 100644
--- a/drivers/usb/gadget/atmel_usba_udc.c
+++ b/drivers/usb/gadget/atmel_usba_udc.c
@@ -1718,13 +1718,12 @@ static irqreturn_t usba_udc_irq(int irq, void *devid)
 			spin_lock(&udc->lock);
 		}
 
-		if (status & USBA_HIGH_SPEED) {
-			DBG(DBG_BUS, "High-speed bus reset detected\n");
+		if (status & USBA_HIGH_SPEED)
 			udc->gadget.speed = USB_SPEED_HIGH;
-		} else {
-			DBG(DBG_BUS, "Full-speed bus reset detected\n");
+		else
 			udc->gadget.speed = USB_SPEED_FULL;
-		}
+		DBG(DBG_BUS, "%s bus reset detected\n",
+		    usb_speed_string(udc->gadget.speed));
 
 		ep0 = &usba_ep[0];
 		ep0->desc = &usba_ep0_desc;
diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 8065464..b539d8f 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -626,25 +626,9 @@ static int set_config(struct usb_composite_dev *cdev,
 		result = 0;
 	}
 
-	INFO(cdev, "%s speed config #%d: %s\n",
-		({ char *speed;
-		switch (gadget->speed) {
-		case USB_SPEED_LOW:
-			speed = "low";
-			break;
-		case USB_SPEED_FULL:
-			speed = "full";
-			break;
-		case USB_SPEED_HIGH:
-			speed = "high";
-			break;
-		case USB_SPEED_SUPER:
-			speed = "super";
-			break;
-		default:
-			speed = "?";
-			break;
-		} ; speed; }), number, c ? c->label : "unconfigured");
+	INFO(cdev, "%s config #%d: %s\n",
+	     usb_speed_string(gadget->speed),
+	     number, c ? c->label : "unconfigured");
 
 	if (!c)
 		goto done;
diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index 39ece40..4ac8084 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -2862,17 +2862,10 @@ static int do_set_config(struct fsg_dev *fsg, u8 new_config)
 		fsg->config = new_config;
 		if ((rc = do_set_interface(fsg, 0)) != 0)
 			fsg->config = 0;	// Reset on errors
-		else {
-			char *speed;
-
-			switch (fsg->gadget->speed) {
-			case USB_SPEED_LOW:	speed = "low";	break;
-			case USB_SPEED_FULL:	speed = "full";	break;
-			case USB_SPEED_HIGH:	speed = "high";	break;
-			default: 		speed = "?";	break;
-			}
-			INFO(fsg, "%s speed config #%d\n", speed, fsg->config);
-		}
+		else
+			INFO(fsg, "%s config #%d\n",
+			     usb_speed_string(fsg->gadget->speed),
+			     fsg->config);
 	}
 	return rc;
 }
diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index d699350..b2c44e1 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -1715,34 +1715,31 @@ static void dtd_complete_irq(struct fsl_udc *udc)
 	}
 }
 
+static inline enum usb_device_speed portscx_device_speed(u32 reg)
+{
+	switch (speed & PORTSCX_PORT_SPEED_MASK) {
+	case PORTSCX_PORT_SPEED_HIGH:
+		return USB_SPEED_HIGH;
+	case PORTSCX_PORT_SPEED_FULL:
+		return USB_SPEED_FULL;
+	case PORTSCX_PORT_SPEED_LOW:
+		return USB_SPEED_LOW;
+	default:
+		return USB_SPEED_UNKNOWN;
+	}
+}
+
 /* Process a port change interrupt */
 static void port_change_irq(struct fsl_udc *udc)
 {
-	u32 speed;
-
 	if (udc->bus_reset)
 		udc->bus_reset = 0;
 
 	/* Bus resetting is finished */
-	if (!(fsl_readl(&dr_regs->portsc1) & PORTSCX_PORT_RESET)) {
+	if (!(fsl_readl(&dr_regs->portsc1) & PORTSCX_PORT_RESET))
 		/* Get the speed */
-		speed = (fsl_readl(&dr_regs->portsc1)
-				& PORTSCX_PORT_SPEED_MASK);
-		switch (speed) {
-		case PORTSCX_PORT_SPEED_HIGH:
-			udc->gadget.speed = USB_SPEED_HIGH;
-			break;
-		case PORTSCX_PORT_SPEED_FULL:
-			udc->gadget.speed = USB_SPEED_FULL;
-			break;
-		case PORTSCX_PORT_SPEED_LOW:
-			udc->gadget.speed = USB_SPEED_LOW;
-			break;
-		default:
-			udc->gadget.speed = USB_SPEED_UNKNOWN;
-			break;
-		}
-	}
+		udc->gadget.speed =
+			portscx_device_speed(fsl_readl(&dr_regs->portsc1));
 
 	/* Update USB state */
 	if (!udc->resume_state)
@@ -2167,20 +2164,8 @@ static int fsl_proc_read(char *page, char **start, off_t off, int count,
 			default:
 				s = "None"; break;
 			}
-			s;} ), ( {
-			char *s;
-			switch (tmp_reg & PORTSCX_PORT_SPEED_UNDEF) {
-			case PORTSCX_PORT_SPEED_FULL:
-				s = "Full Speed"; break;
-			case PORTSCX_PORT_SPEED_LOW:
-				s = "Low Speed"; break;
-			case PORTSCX_PORT_SPEED_HIGH:
-				s = "High Speed"; break;
-			default:
-				s = "Undefined"; break;
-			}
-			s;
-		} ),
+			s;} ),
+		usb_speed_string(portscx_device_speed(tmp_reg)),
 		(tmp_reg & PORTSCX_PHY_LOW_POWER_SPD) ?
 		"Normal PHY mode" : "Low power mode",
 		(tmp_reg & PORTSCX_PORT_RESET) ? "In Reset" :
diff --git a/drivers/usb/gadget/gmidi.c b/drivers/usb/gadget/gmidi.c
index 8b9220e..893b967 100644
--- a/drivers/usb/gadget/gmidi.c
+++ b/drivers/usb/gadget/gmidi.c
@@ -640,17 +640,8 @@ gmidi_set_config(struct gmidi_device *dev, unsigned number, gfp_t gfp_flags)
 	if (result) {
 		gmidi_reset_config(dev);
 	} else {
-		char *speed;
-
-		switch (gadget->speed) {
-		case USB_SPEED_LOW:	speed = "low"; break;
-		case USB_SPEED_FULL:	speed = "full"; break;
-		case USB_SPEED_HIGH:	speed = "high"; break;
-		default:		speed = "?"; break;
-		}
-
 		dev->config = number;
-		INFO(dev, "%s speed\n", speed);
+		INFO(dev, "%s speed\n", usb_speed_string(gadget->speed));
 	}
 	return result;
 }
diff --git a/drivers/usb/gadget/langwell_udc.c b/drivers/usb/gadget/langwell_udc.c
index 5bf9942..9c37a9e 100644
--- a/drivers/usb/gadget/langwell_udc.c
+++ b/drivers/usb/gadget/langwell_udc.c
@@ -1700,20 +1700,7 @@ static ssize_t show_langwell_udc(struct device *_dev,
 		"BmAttributes: %d\n\n",
 		LPM_PTS(tmp_reg),
 		(tmp_reg & LPM_STS) ? 1 : 0,
-		({
-			char	*s;
-			switch (LPM_PSPD(tmp_reg)) {
-			case LPM_SPEED_FULL:
-				s = "Full Speed"; break;
-			case LPM_SPEED_LOW:
-				s = "Low Speed"; break;
-			case LPM_SPEED_HIGH:
-				s = "High Speed"; break;
-			default:
-				s = "Unknown Speed"; break;
-			}
-			s;
-		}),
+		usb_speed_string(lpm_device_speed(tmp_reg)),
 		(tmp_reg & LPM_PFSC) ? "Force Full Speed" : "Not Force",
 		(tmp_reg & LPM_PHCD) ? "Disabled" : "Enabled",
 		LPM_BA(tmp_reg));
@@ -2657,12 +2644,24 @@ done:
 	dev_vdbg(&dev->pdev->dev, "<--- %s()\n", __func__);
 }
 
+static inline enum usb_device_speed lpm_device_speed(u32 reg)
+{
+	switch (LPM_PSPD(reg)) {
+	case LPM_SPEED_HIGH:
+		return USB_SPEED_HIGH;
+	case LPM_SPEED_FULL:
+		return USB_SPEED_FULL;
+	case LPM_SPEED_LOW:
+		return USB_SPEED_LOW;
+	default:
+		return USB_SPEED_UNKNOWN;
+	}
+}
 
 /* port change detect interrupt handler */
 static void handle_port_change(struct langwell_udc *dev)
 {
 	u32	portsc1, devlc;
-	u32	speed;
 
 	dev_vdbg(&dev->pdev->dev, "---> %s()\n", __func__);
 
@@ -2677,24 +2676,9 @@ static void handle_port_change(struct langwell_udc *dev)
 	/* bus reset is finished */
 	if (!(portsc1 & PORTS_PR)) {
 		/* get the speed */
-		speed = LPM_PSPD(devlc);
-		switch (speed) {
-		case LPM_SPEED_HIGH:
-			dev->gadget.speed = USB_SPEED_HIGH;
-			break;
-		case LPM_SPEED_FULL:
-			dev->gadget.speed = USB_SPEED_FULL;
-			break;
-		case LPM_SPEED_LOW:
-			dev->gadget.speed = USB_SPEED_LOW;
-			break;
-		default:
-			dev->gadget.speed = USB_SPEED_UNKNOWN;
-			break;
-		}
-		dev_vdbg(&dev->pdev->dev,
-				"speed = %d, dev->gadget.speed = %d\n",
-				speed, dev->gadget.speed);
+		dev->gadget.speed = lpm_device_speed(devlc);
+		dev_vdbg(&dev->pdev->dev, "dev->gadget.speed = %d\n",
+			dev->gadget.speed);
 	}
 
 	/* LPM L0 to L1 */
diff --git a/drivers/usb/gadget/net2272.c b/drivers/usb/gadget/net2272.c
index 6fef1c0..08a4a36 100644
--- a/drivers/usb/gadget/net2272.c
+++ b/drivers/usb/gadget/net2272.c
@@ -1764,8 +1764,8 @@ net2272_handle_stat0_irqs(struct net2272 *dev, u8 stat)
 				dev->gadget.speed = USB_SPEED_HIGH;
 			else
 				dev->gadget.speed = USB_SPEED_FULL;
-			dev_dbg(dev->dev, "%s speed\n",
-				(dev->gadget.speed == USB_SPEED_HIGH) ? "high" : "full");
+			dev_dbg(dev->dev, "%s\n",
+				usb_speed_string(dev->gadget.speed));
 		}
 
 		ep = &dev->ep[0];
diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index 8d3673f..cbed585 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -2266,9 +2266,7 @@ static void handle_stat0_irqs (struct net2280 *dev, u32 stat)
 			else
 				dev->gadget.speed = USB_SPEED_FULL;
 			net2280_led_speed (dev, dev->gadget.speed);
-			DEBUG (dev, "%s speed\n",
-				(dev->gadget.speed == USB_SPEED_HIGH)
-					? "high" : "full");
+			DEBUG(dev, "%s\n", usb_speed_string(dev->gadget.speed));
 		}
 
 		ep = &dev->ep [0];
diff --git a/drivers/usb/gadget/printer.c b/drivers/usb/gadget/printer.c
index a341dde..78fc14b 100644
--- a/drivers/usb/gadget/printer.c
+++ b/drivers/usb/gadget/printer.c
@@ -971,23 +971,15 @@ printer_set_config(struct printer_dev *dev, unsigned number)
 		usb_gadget_vbus_draw(dev->gadget,
 				dev->gadget->is_otg ? 8 : 100);
 	} else {
-		char *speed;
 		unsigned power;
 
 		power = 2 * config_desc.bMaxPower;
 		usb_gadget_vbus_draw(dev->gadget, power);
 
-		switch (gadget->speed) {
-		case USB_SPEED_FULL:	speed = "full"; break;
-#ifdef CONFIG_USB_GADGET_DUALSPEED
-		case USB_SPEED_HIGH:	speed = "high"; break;
-#endif
-		default:		speed = "?"; break;
-		}
-
 		dev->config = number;
-		INFO(dev, "%s speed config #%d: %d mA, %s\n",
-				speed, number, power, driver_desc);
+		INFO(dev, "%s config #%d: %d mA, %s\n",
+		     usb_speed_string(gadget->speed),
+		     number, power, driver_desc);
 	}
 	return result;
 }
diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index 39b134d..a552453 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -1951,30 +1951,26 @@ static void s3c_hsotg_irq_enumdone(struct s3c_hsotg *hsotg)
 	case S3C_DSTS_EnumSpd_FS:
 	case S3C_DSTS_EnumSpd_FS48:
 		hsotg->gadget.speed = USB_SPEED_FULL;
-		dev_info(hsotg->dev, "new device is full-speed\n");
-
 		ep0_mps = EP0_MPS_LIMIT;
 		ep_mps = 64;
 		break;
 
 	case S3C_DSTS_EnumSpd_HS:
-		dev_info(hsotg->dev, "new device is high-speed\n");
 		hsotg->gadget.speed = USB_SPEED_HIGH;
-
 		ep0_mps = EP0_MPS_LIMIT;
 		ep_mps = 512;
 		break;
 
 	case S3C_DSTS_EnumSpd_LS:
 		hsotg->gadget.speed = USB_SPEED_LOW;
-		dev_info(hsotg->dev, "new device is low-speed\n");
-
 		/* note, we don't actually support LS in this driver at the
 		 * moment, and the documentation seems to imply that it isn't
 		 * supported by the PHYs on some of the devices.
 		 */
 		break;
 	}
+	dev_info(hsotg->dev, "new device is %s\n",
+		 usb_speed_string(hsotg->gadget.speed));
 
 	/* we should now know the maximum packet size for an
 	 * endpoint, so set the endpoints to a default value. */
diff --git a/drivers/usb/gadget/udc-core.c b/drivers/usb/gadget/udc-core.c
index 05ba472..5e77a46 100644
--- a/drivers/usb/gadget/udc-core.c
+++ b/drivers/usb/gadget/udc-core.c
@@ -375,23 +375,8 @@ static ssize_t usb_udc_speed_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct usb_udc		*udc = container_of(dev, struct usb_udc, dev);
-	struct usb_gadget	*gadget = udc->gadget;
-
-	switch (gadget->speed) {
-	case USB_SPEED_LOW:
-		return snprintf(buf, PAGE_SIZE, "low-speed\n");
-	case USB_SPEED_FULL:
-		return snprintf(buf, PAGE_SIZE, "full-speed\n");
-	case USB_SPEED_HIGH:
-		return snprintf(buf, PAGE_SIZE, "high-speed\n");
-	case USB_SPEED_WIRELESS:
-		return snprintf(buf, PAGE_SIZE, "wireless\n");
-	case USB_SPEED_SUPER:
-		return snprintf(buf, PAGE_SIZE, "super-speed\n");
-	case USB_SPEED_UNKNOWN:	/* FALLTHROUGH */
-	default:
-		return snprintf(buf, PAGE_SIZE, "UNKNOWN\n");
-	}
+	return snprintf(buf, PAGE_SIZE, "%s\n",
+			usb_speed_string(udc->gadget->speed));
 }
 static DEVICE_ATTR(speed, S_IRUSR, usb_udc_speed_show, NULL);
 
diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
index 930962f..bd6d008 100644
--- a/drivers/usb/misc/usbtest.c
+++ b/drivers/usb/misc/usbtest.c
@@ -2300,25 +2300,8 @@ usbtest_probe(struct usb_interface *intf, const struct usb_device_id *id)
 
 	usb_set_intfdata(intf, dev);
 	dev_info(&intf->dev, "%s\n", info->name);
-	dev_info(&intf->dev, "%s speed {control%s%s%s%s%s} tests%s\n",
-			({ char *tmp;
-			switch (udev->speed) {
-			case USB_SPEED_LOW:
-				tmp = "low";
-				break;
-			case USB_SPEED_FULL:
-				tmp = "full";
-				break;
-			case USB_SPEED_HIGH:
-				tmp = "high";
-				break;
-			case USB_SPEED_SUPER:
-				tmp = "super";
-				break;
-			default:
-				tmp = "unknown";
-				break;
-			}; tmp; }),
+	dev_info(&intf->dev, "%s {control%s%s%s%s%s} tests%s\n",
+			usb_speed_string(udev->speed),
 			info->ctrl_out ? " in/out" : "",
 			rtest, wtest,
 			irtest, iwtest,
diff --git a/drivers/usb/usb-common.c b/drivers/usb/usb-common.c
new file mode 100644
index 0000000..d29503e
--- /dev/null
+++ b/drivers/usb/usb-common.c
@@ -0,0 +1,35 @@
+/*
+ * Provides code common for host and device side USB.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2.
+ *
+ * If either host side (ie. CONFIG_USB=y) or device side USB stack
+ * (ie. CONFIG_USB_GADGET=y) is compiled in the kernel, this module is
+ * compiled-in as well.  Otherwise, if either of the two stacks is
+ * compiled as module, this file is compiled as module as well.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/usb/ch9.h>
+
+const char *usb_speed_string(enum usb_device_speed speed)
+{
+	static const char *const names[] = {
+		[USB_SPEED_UNKNOWN] = "UNKNOWN",
+		[USB_SPEED_LOW] = "low-speed",
+		[USB_SPEED_FULL] = "full-speed",
+		[USB_SPEED_HIGH] = "high-speed",
+		[USB_SPEED_WIRELESS] = "wireless",
+		[USB_SPEED_SUPER] = "super-speed",
+	};
+
+	if (speed < 0 || speed >= ARRAY_SIZE(names))
+		speed = USB_SPEED_UNKNOWN;
+	return names[speed];
+}
+EXPORT_SYMBOL_GPL(usb_speed_string);
+
+MODULE_LICENSE("GPL");
diff --git a/include/linux/usb/ch9.h b/include/linux/usb/ch9.h
index 1ded281..f32a64e 100644
--- a/include/linux/usb/ch9.h
+++ b/include/linux/usb/ch9.h
@@ -868,6 +868,18 @@ enum usb_device_speed {
 	USB_SPEED_SUPER,			/* usb 3.0 */
 };
 
+#ifdef __KERNEL__
+
+/**
+ * usb_speed_string() - Returns human readable-name of the speed.
+ * @speed: The speed to return human-readable name for.  If it's not
+ *   any of the speeds defined in usb_device_speed enum, string for
+ *   USB_SPEED_UNKNOWN will be returned.
+ */
+extern const char *usb_speed_string(enum usb_device_speed speed);
+
+#endif
+
 enum usb_device_state {
 	/* NOTATTACHED isn't in the USB spec, and this state acts
 	 * the same as ATTACHED ... but it's clearer this way.
-- 
1.7.3.1

