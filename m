Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab1DSNbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 09:31:34 -0400
Received: from smtp.nokia.com ([147.243.128.26]:62402 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593Ab1DSNbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 09:31:33 -0400
From: Roger Quadros <roger.quadros@nokia.com>
To: gregkh@suse.de
Cc: stern@rowland.harvard.edu, mina86@mina86.com, m-sonasath@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] usb: gadget: composite: Allow function drivers to defer setup responses
Date: Tue, 19 Apr 2011 16:33:52 +0300
Message-Id: <1303220033-5274-2-git-send-email-roger.quadros@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1303220033-5274-1-git-send-email-roger.quadros@nokia.com>
References: <1303220033-5274-1-git-send-email-roger.quadros@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some USB function drivers (e.g. f_mass_storage.c) need to delay or defer the
status phase of standard control requests like SET_CONFIGURATION or
SET_INTERFACE till they are done with their bookkeeping and are actually ready
for accepting new commands to their interface.

They can now achieve this functionality by returning USB_GADGET_DELAYED_STATUS
in their setup handlers (e.g. set_alt()). The composite framework will then
defer completion of the setup transfer by not sending the Data/Status response.

This ensures that the host does not send new packets to the interface till the
function driver is ready to take them.

When the function driver that requested for USB_GADGET_DELAYED_STATUS is done
with its bookkeeping, it should signal the composite framework to continue with
the Data/Status phase of the setup transfer. It can do so by invoking
the new API usb_composite_setup_continue(). This is where the setup transfer's
data/status phases are completed and host can send new transfers.

The DELAYED_STATUS mechanism is currently only supported if the expected data phase
is 0 bytes (i.e. w_length == 0). Since SET_CONFIGURATION and SET_INTERFACE are the
only cases that will use this mechanism, this is not a limitation as such.

Signed-off-by: Roger Quadros <roger.quadros@nokia.com>
---
 drivers/usb/gadget/composite.c |   61 +++++++++++++++++++++++++++++++++++++++-
 include/linux/usb/composite.h  |   17 ++++++++++-
 2 files changed, 76 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 1ba4bef..43be36e 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -461,6 +461,15 @@ static int set_config(struct usb_composite_dev *cdev,
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
@@ -895,6 +904,14 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
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
@@ -958,7 +975,7 @@ unknown:
 	}
 
 	/* respond with data transfer before status phase? */
-	if (value >= 0) {
+	if (value >= 0 && value != USB_GADGET_DELAYED_STATUS) {
 		req->length = value;
 		req->zero = value < w_length;
 		value = usb_ep_queue(gadget->ep0, req, GFP_ATOMIC);
@@ -967,6 +984,10 @@ unknown:
 			req->status = 0;
 			composite_setup_complete(gadget->ep0, req);
 		}
+	} else if (value == USB_GADGET_DELAYED_STATUS && w_length != 0) {
+		WARN(cdev,
+			"%s: Delayed status not supported for w_length != 0",
+			__func__);
 	}
 
 done:
@@ -1289,3 +1310,41 @@ void usb_composite_unregister(struct usb_composite_driver *driver)
 		return;
 	usb_gadget_unregister_driver(&composite_driver);
 }
+
+/**
+ * usb_composite_setup_continue() - Continue the delayed setup transfer
+ * @cdev: the composite device who's setup transfer was delayed
+ *
+ * This function must be called by the USB function driver to continue
+ * with the setup transfer's data/status phase in case it had requested to
+ * delay the status phase. A USB function's setup handler (e.g. set_alt())
+ * can request the composite framework to delay the setup request's status phase
+ * by returning USB_GADGET_DELAYED_STATUS.
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
+		req->zero = 1;
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
index 3d29a7d..930e860 100644
--- a/include/linux/usb/composite.h
+++ b/include/linux/usb/composite.h
@@ -37,6 +37,15 @@
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
 
+/*
+ * USB function drivers should return USB_GADGET_DELAYED_STATUS if they
+ * wish to delay the status phase of the setup transfer till they are
+ * ready. The composite framework will then delay the data/status phase
+ * of the setup transfer till all the function drivers that requested for
+ * USB_GADGET_DELAYED_STAUS, invoke usb_composite_setup_continue().
+ *
+ */
+#define USB_GADGET_DELAYED_STATUS       0x7fff	/* Impossibly large value */
 
 struct usb_configuration;
 
@@ -285,6 +294,7 @@ struct usb_composite_driver {
 extern int usb_composite_probe(struct usb_composite_driver *driver,
 			       int (*bind)(struct usb_composite_dev *cdev));
 extern void usb_composite_unregister(struct usb_composite_driver *driver);
+extern void usb_composite_setup_continue(struct usb_composite_dev *cdev);
 
 
 /**
@@ -342,7 +352,12 @@ struct usb_composite_dev {
 	 */
 	unsigned			deactivations;
 
-	/* protects at least deactivation count */
+	/* the composite driver won't complete the setup transfer's
+	 * data/status phase till delayed_status is zero.
+	 */
+	int				delayed_status;
+
+	/* protects deactivations and delayed_status counts*/
 	spinlock_t			lock;
 };
 
-- 
1.6.0.4

