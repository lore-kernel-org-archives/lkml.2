Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab1FVIjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 04:39:52 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19528 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab1FVIju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 04:39:50 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6384"; a="99096697"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: balbi@ti.com
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ablay@codeaurora.org, Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC/PATCH v2 2/2] usb:g_zero: bulk in/out unittest support
Date: Wed, 22 Jun 2011 11:39:01 +0300
Message-Id: <1308731945-7601-3-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1308731945-7601-1-git-send-email-tlinder@codeaurora.org>
References: <1308731945-7601-1-git-send-email-tlinder@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds a new vendor specific request to be handled by the
g_zero module in it's sourcesink configuration. The purpose if this
request is to update the length of the BULK transfer to a given value.
The bRequest value of the new control request is 0x5e.
It is used by the user-space Unit testing application for bulk in/out
tests.

The sourcesink_setup function was moved to be ->setup() of the function
and not the configuration.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

---
 drivers/usb/gadget/f_sourcesink.c |  145 +++++++++++++++++++------------------
 1 files changed, 75 insertions(+), 70 deletions(-)

diff --git a/drivers/usb/gadget/f_sourcesink.c b/drivers/usb/gadget/f_sourcesink.c
index caf2f95..ff8840d 100644
--- a/drivers/usb/gadget/f_sourcesink.c
+++ b/drivers/usb/gadget/f_sourcesink.c
@@ -385,6 +385,80 @@ fail:
 	return result;
 }
 
+static int sourcesink_setup(struct usb_function *f,
+			    const struct usb_ctrlrequest *ctrl)
+{
+	struct f_sourcesink		*ss = func_to_ss(f);
+	struct usb_composite_dev	*cdev = f->config->cdev;
+	struct usb_request		*req = f->config->cdev->req;
+	int				retval = -EOPNOTSUPP;
+	u16				w_index = le16_to_cpu(ctrl->wIndex);
+	u16				w_value = le16_to_cpu(ctrl->wValue);
+	u16				w_length = le16_to_cpu(ctrl->wLength);
+
+	switch (ctrl->bRequest) {
+	/*
+	 * These are the same vendor-specific requests supported by
+	 * Intel's USB 2.0 compliance test devices.  We exceed that
+	 * device spec by allowing multiple-packet requests.
+	 *
+	 * NOTE:  the Control-OUT data stays in req->buf ... better
+	 * would be copying it into a scratch buffer, so that other
+	 * requests may safely intervene.
+	 */
+	case 0x5b:	/* control WRITE test -- fill the buffer */
+		if (ctrl->bRequestType != (USB_DIR_OUT|USB_TYPE_VENDOR))
+			goto unknown;
+		if (w_value || w_index)
+			break;
+		/* just read that many bytes into the buffer */
+		if (w_length > req->length)
+			break;
+		retval = w_length;
+		break;
+	case 0x5c:	/* control READ test -- return the buffer */
+		if (ctrl->bRequestType != (USB_DIR_IN|USB_TYPE_VENDOR))
+			goto unknown;
+		if (w_value || w_index)
+			break;
+		/* expect those bytes are still in the buffer; send back */
+		if (w_length > req->length)
+			break;
+		retval = w_length;
+		break;
+
+	case 0x5e:
+		/*
+		 * Change bulk ep buffer size. buflen is the length of
+		 * the BULK transfer (req->length=buflen). Defined in g_zero.h
+		 */
+		disable_source_sink(ss);
+		buflen = w_value;
+		retval = enable_source_sink(cdev, ss);
+		break;
+	default:
+unknown:
+		VDBG(cdev, "unknown control req%02x.%02x v%04x i%04x l%d\n",
+		     ctrl->bRequestType, ctrl->bRequest,
+		     w_value, w_index, w_length);
+	}
+
+	/* respond with data transfer or status phase? */
+	if (retval >= 0) {
+		VDBG(cdev, "source/sink req%02x.%02x v%04x i%04x l%d\n",
+		     ctrl->bRequestType, ctrl->bRequest,
+		     w_value, w_index, w_length);
+		req->zero = 0;
+		req->length = retval;
+		retval = usb_ep_queue(cdev->gadget->ep0, req, GFP_ATOMIC);
+		if (retval < 0)
+			ERROR(cdev, "source/sinkc response, err %d\n", retval);
+	}
+
+	/* device either stalls (value < 0) or reports success */
+	return retval;
+}
+
 static int sourcesink_set_alt(struct usb_function *f,
 		unsigned intf, unsigned alt)
 {
@@ -421,6 +495,7 @@ static int __init sourcesink_bind_config(struct usb_configuration *c)
 	ss->function.unbind = sourcesink_unbind;
 	ss->function.set_alt = sourcesink_set_alt;
 	ss->function.disable = sourcesink_disable;
+	ss->function.setup = sourcesink_setup;
 
 	status = usb_add_function(c, &ss->function);
 	if (status)
@@ -428,79 +503,9 @@ static int __init sourcesink_bind_config(struct usb_configuration *c)
 	return status;
 }
 
-static int sourcesink_setup(struct usb_configuration *c,
-		const struct usb_ctrlrequest *ctrl)
-{
-	struct usb_request	*req = c->cdev->req;
-	int			value = -EOPNOTSUPP;
-	u16			w_index = le16_to_cpu(ctrl->wIndex);
-	u16			w_value = le16_to_cpu(ctrl->wValue);
-	u16			w_length = le16_to_cpu(ctrl->wLength);
-
-	/* composite driver infrastructure handles everything except
-	 * the two control test requests.
-	 */
-	switch (ctrl->bRequest) {
-
-	/*
-	 * These are the same vendor-specific requests supported by
-	 * Intel's USB 2.0 compliance test devices.  We exceed that
-	 * device spec by allowing multiple-packet requests.
-	 *
-	 * NOTE:  the Control-OUT data stays in req->buf ... better
-	 * would be copying it into a scratch buffer, so that other
-	 * requests may safely intervene.
-	 */
-	case 0x5b:	/* control WRITE test -- fill the buffer */
-		if (ctrl->bRequestType != (USB_DIR_OUT|USB_TYPE_VENDOR))
-			goto unknown;
-		if (w_value || w_index)
-			break;
-		/* just read that many bytes into the buffer */
-		if (w_length > req->length)
-			break;
-		value = w_length;
-		break;
-	case 0x5c:	/* control READ test -- return the buffer */
-		if (ctrl->bRequestType != (USB_DIR_IN|USB_TYPE_VENDOR))
-			goto unknown;
-		if (w_value || w_index)
-			break;
-		/* expect those bytes are still in the buffer; send back */
-		if (w_length > req->length)
-			break;
-		value = w_length;
-		break;
-
-	default:
-unknown:
-		VDBG(c->cdev,
-			"unknown control req%02x.%02x v%04x i%04x l%d\n",
-			ctrl->bRequestType, ctrl->bRequest,
-			w_value, w_index, w_length);
-	}
-
-	/* respond with data transfer or status phase? */
-	if (value >= 0) {
-		VDBG(c->cdev, "source/sink req%02x.%02x v%04x i%04x l%d\n",
-			ctrl->bRequestType, ctrl->bRequest,
-			w_value, w_index, w_length);
-		req->zero = 0;
-		req->length = value;
-		value = usb_ep_queue(c->cdev->gadget->ep0, req, GFP_ATOMIC);
-		if (value < 0)
-			ERROR(c->cdev, "source/sinkc response, err %d\n",
-					value);
-	}
-
-	/* device either stalls (value < 0) or reports success */
-	return value;
-}
-
 static struct usb_configuration sourcesink_driver = {
 	.label		= "source/sink",
 	.strings	= sourcesink_strings,
-	.setup		= sourcesink_setup,
 	.bConfigurationValue = 3,
 	.bmAttributes	= USB_CONFIG_ATT_SELFPOWER,
 	/* .iConfiguration = DYNAMIC */
-- 
1.7.0.4

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
