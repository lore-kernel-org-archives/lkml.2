Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab1EIKFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 06:05:34 -0400
Received: from smtp.nokia.com ([147.243.128.24]:65490 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab1EIKFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 06:05:33 -0400
From: Roger Quadros <roger.quadros@nokia.com>
To: gregkh@suse.de
Cc: stern@rowland.harvard.edu, mina86@mina86.com, m-sonasath@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] usb: gadget: composite: Allow function drivers to pause control transfers
Date: Mon,  9 May 2011 13:08:06 +0300
Message-Id: <1304935687-5428-2-git-send-email-roger.quadros@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1304935687-5428-1-git-send-email-roger.quadros@nokia.com>
References: <1304935687-5428-1-git-send-email-roger.quadros@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some USB function drivers (e.g. f_mass_storage.c) need to delay or defer the
data/status stages of standard control requests like SET_CONFIGURATION or
SET_INTERFACE till they are done with their bookkeeping and are actually ready
for accepting new commands to their interface.

They can now achieve this functionality by returning USB_GADGET_DELAYED_STATUS
in their setup handlers (e.g. set_alt()). The composite framework will then
defer completion of the control transfer by not completing the data/status stages.

This ensures that the host does not send new packets to the interface till the
function driver is ready to take them.

When the function driver that requested for USB_GADGET_DELAYED_STATUS is done
with its bookkeeping, it should signal the composite framework to continue with
the data/status stages of the control transfer. It can do so by invoking
the new API usb_composite_setup_continue(). This is where the control transfer's
data/status stages are completed and host can initiate new transfers.

The DELAYED_STATUS mechanism is currently only supported if the expected data phase
is 0 bytes (i.e. w_length == 0). Since SET_CONFIGURATION and SET_INTERFACE are the
only cases that will use this mechanism, this is not a limitation.

Signed-off-by: Roger Quadros <roger.quadros@nokia.com>
---
 drivers/usb/gadget/composite.c |   62 +++++++++++++++++++++++++++++++++++++++-
 include/linux/usb/composite.h  |   16 +++++++++-
 2 files changed, 76 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 82314ed..5cbb1a4 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -461,12 +461,23 @@ static int set_config(struct usb_composite_dev *cdev,
 			reset_config(cdev);
 			goto done;
 		}
+
+		if (result == USB_GADGET_DELAYED_STATUS) {
+			DBG(cdev,
+			 "%s: interface %d (%s) requested delayed status\n",
+					__func__, tmp, f->name);
+			cdev->delayed_status++;
+			DBG(cdev, "delayed_status count %d\n",
+					cdev->delayed_status);
+		}
 	}
 
 	/* when we return, be sure our power usage is valid */
 	power = c->bMaxPower ? (2 * c->bMaxPower) : CONFIG_USB_GADGET_VBUS_DRAW;
 done:
 	usb_gadget_vbus_draw(gadget, power);
+	if (result >= 0 && cdev->delayed_status)
+		result = USB_GADGET_DELAYED_STATUS;
 	return result;
 }
 
@@ -895,6 +906,14 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 		if (w_value && !f->set_alt)
 			break;
 		value = f->set_alt(f, w_index, w_value);
+		if (value == USB_GADGET_DELAYED_STATUS) {
+			DBG(cdev,
+			 "%s: interface %d (%s) requested delayed status\n",
+					__func__, intf, f->name);
+			cdev->delayed_status++;
+			DBG(cdev, "delayed_status count %d\n",
+					cdev->delayed_status);
+		}
 		break;
 	case USB_REQ_GET_INTERFACE:
 		if (ctrl->bRequestType != (USB_DIR_IN|USB_RECIP_INTERFACE))
@@ -958,7 +977,7 @@ unknown:
 	}
 
 	/* respond with data transfer before status phase? */
-	if (value >= 0) {
+	if (value >= 0 && value != USB_GADGET_DELAYED_STATUS) {
 		req->length = value;
 		req->zero = value < w_length;
 		value = usb_ep_queue(gadget->ep0, req, GFP_ATOMIC);
@@ -967,6 +986,10 @@ unknown:
 			req->status = 0;
 			composite_setup_complete(gadget->ep0, req);
 		}
+	} else if (value == USB_GADGET_DELAYED_STATUS && w_length != 0) {
+		WARN(cdev,
+			"%s: Delayed status not supported for w_length != 0",
+			__func__);
 	}
 
 done:
@@ -1289,3 +1312,40 @@ void usb_composite_unregister(struct usb_composite_driver *driver)
 		return;
 	usb_gadget_unregister_driver(&composite_driver);
 }
+
+/**
+ * usb_composite_setup_continue() - Continue with the control transfer
+ * @cdev: the composite device who's control transfer was kept waiting
+ *
+ * This function must be called by the USB function driver to continue
+ * with the control transfer's data/status stage in case it had requested to
+ * delay the data/status stages. A USB function's setup handler (e.g. set_alt())
+ * can request the composite framework to delay the setup request's data/status
+ * stages by returning USB_GADGET_DELAYED_STATUS.
+ */
+void usb_composite_setup_continue(struct usb_composite_dev *cdev)
+{
+	int			value;
+	struct usb_request	*req = cdev->req;
+	unsigned long		flags;
+
+	DBG(cdev, "%s\n", __func__);
+	spin_lock_irqsave(&cdev->lock, flags);
+
+	if (cdev->delayed_status == 0) {
+		WARN(cdev, "%s: Unexpected call\n", __func__);
+
+	} else if (--cdev->delayed_status == 0) {
+		DBG(cdev, "%s: Completing delayed status\n", __func__);
+		req->length = 0;
+		value = usb_ep_queue(cdev->gadget->ep0, req, GFP_ATOMIC);
+		if (value < 0) {
+			DBG(cdev, "ep_queue --> %d\n", value);
+			req->status = 0;
+			composite_setup_complete(cdev->gadget->ep0, req);
+		}
+	}
+
+	spin_unlock_irqrestore(&cdev->lock, flags);
+}
+
diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
index 882a084..b78cba4 100644
--- a/include/linux/usb/composite.h
+++ b/include/linux/usb/composite.h
@@ -37,6 +37,14 @@
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
 
+/*
+ * USB function drivers should return USB_GADGET_DELAYED_STATUS if they
+ * wish to delay the data/status stages of the control transfer till they
+ * are ready. The control transfer will then be kept from completing till
+ * all the function drivers that requested for USB_GADGET_DELAYED_STAUS
+ * invoke usb_composite_setup_continue().
+ */
+#define USB_GADGET_DELAYED_STATUS       0x7fff	/* Impossibly large value */
 
 struct usb_configuration;
 
@@ -285,6 +293,7 @@ struct usb_composite_driver {
 extern int usb_composite_probe(struct usb_composite_driver *driver,
 			       int (*bind)(struct usb_composite_dev *cdev));
 extern void usb_composite_unregister(struct usb_composite_driver *driver);
+extern void usb_composite_setup_continue(struct usb_composite_dev *cdev);
 
 
 /**
@@ -342,7 +351,12 @@ struct usb_composite_dev {
 	 */
 	unsigned			deactivations;
 
-	/* protects at least deactivation count */
+	/* the composite driver won't complete the control transfer's
+	 * data/status stages till delayed_status is zero.
+	 */
+	int				delayed_status;
+
+	/* protects deactivations and delayed_status counts*/
 	spinlock_t			lock;
 };
 
-- 
1.6.0.4

