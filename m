Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab1EXKDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 06:03:19 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31173 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576Ab1EXKDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 06:03:14 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6355"; a="93037332"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org, Tatyana Brokhman <tlinder@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH/RESEND v13 6/8] usb: Add streams support to the gadget framework
Date: Tue, 24 May 2011 13:02:03 +0300
Message-Id: <1306231330-11158-7-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1306231330-11158-1-git-send-email-tlinder@codeaurora.org>
References: <1306231330-11158-1-git-send-email-tlinder@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch defines necessary fields to support streaming for USB3.0.
It implements a new function (usb_ep_autoconfig_ss) to be used instead of
the existing usb_ep_autoconfig when working in SS mode and there is a
need to search for an endpoint according to the number of required
streams.

Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

---
 drivers/usb/gadget/epautoconf.c |  125 +++++++++++++++++++++++++++++++--------
 include/linux/usb/gadget.h      |   10 +++
 2 files changed, 110 insertions(+), 25 deletions(-)

diff --git a/drivers/usb/gadget/epautoconf.c b/drivers/usb/gadget/epautoconf.c
index b9e0b6d..7aa2ed0 100644
--- a/drivers/usb/gadget/epautoconf.c
+++ b/drivers/usb/gadget/epautoconf.c
@@ -63,13 +63,16 @@ static int
 ep_matches (
 	struct usb_gadget		*gadget,
 	struct usb_ep			*ep,
-	struct usb_endpoint_descriptor	*desc
+	struct usb_endpoint_descriptor	*desc,
+	struct usb_ss_ep_comp_descriptor *ep_comp
 )
 {
 	u8		type;
 	const char	*tmp;
 	u16		max;
 
+	int		num_req_streams = 0;
+
 	/* endpoint already claimed? */
 	if (NULL != ep->driver_data)
 		return 0;
@@ -129,6 +132,22 @@ ep_matches (
 	}
 
 	/*
+	 * Get the number of required streams from the EP companion
+	 * descriptor and see if the EP matches it
+	 */
+	if (usb_endpoint_xfer_bulk(desc)) {
+		if (ep_comp) {
+			num_req_streams = ep_comp->bmAttributes & 0x1f;
+			if (num_req_streams > ep->max_streams)
+				return 0;
+			/* Update the ep_comp descriptor if needed */
+			if (num_req_streams != ep->max_streams)
+				ep_comp->bmAttributes = ep->max_streams;
+		}
+
+	}
+
+	/*
 	 * If the protocol driver hasn't yet decided on wMaxPacketSize
 	 * and wants to know the maximum possible, provide the info.
 	 */
@@ -209,38 +228,53 @@ find_ep (struct usb_gadget *gadget, const char *name)
 }
 
 /**
- * usb_ep_autoconfig - choose an endpoint matching the descriptor
+ * usb_ep_autoconfig_ss() - choose an endpoint matching the ep
+ * descriptor and ep companion descriptor
  * @gadget: The device to which the endpoint must belong.
  * @desc: Endpoint descriptor, with endpoint direction and transfer mode
- *	initialized.  For periodic transfers, the maximum packet
- *	size must also be initialized.  This is modified on success.
+ *    initialized.  For periodic transfers, the maximum packet
+ *    size must also be initialized.  This is modified on
+ *    success.
+ * @ep_comp: Endpoint companion descriptor, with the required
+ *    number of streams. Will be modified when the chosen EP
+ *    supports a different number of streams.
  *
- * By choosing an endpoint to use with the specified descriptor, this
- * routine simplifies writing gadget drivers that work with multiple
- * USB device controllers.  The endpoint would be passed later to
- * usb_ep_enable(), along with some descriptor.
+ * This routine replaces the usb_ep_autoconfig when needed
+ * superspeed enhancments. If such enhancemnets are required,
+ * the FD should call usb_ep_autoconfig_ss directly and provide
+ * the additional ep_comp parameter.
+ *
+ * By choosing an endpoint to use with the specified descriptor,
+ * this routine simplifies writing gadget drivers that work with
+ * multiple USB device controllers.  The endpoint would be
+ * passed later to usb_ep_enable(), along with some descriptor.
  *
  * That second descriptor won't always be the same as the first one.
  * For example, isochronous endpoints can be autoconfigured for high
  * bandwidth, and then used in several lower bandwidth altsettings.
  * Also, high and full speed descriptors will be different.
  *
- * Be sure to examine and test the results of autoconfiguration on your
- * hardware.  This code may not make the best choices about how to use the
- * USB controller, and it can't know all the restrictions that may apply.
- * Some combinations of driver and hardware won't be able to autoconfigure.
+ * Be sure to examine and test the results of autoconfiguration
+ * on your hardware.  This code may not make the best choices
+ * about how to use the USB controller, and it can't know all
+ * the restrictions that may apply. Some combinations of driver
+ * and hardware won't be able to autoconfigure.
  *
  * On success, this returns an un-claimed usb_ep, and modifies the endpoint
  * descriptor bEndpointAddress.  For bulk endpoints, the wMaxPacket value
- * is initialized as if the endpoint were used at full speed.  To prevent
- * the endpoint from being returned by a later autoconfig call, claim it
- * by assigning ep->driver_data to some non-null value.
+ * is initialized as if the endpoint were used at full speed and
+ * the bmAttribute field in the ep companion descriptor is
+ * updated with the assigned number of streams if it is
+ * different from the original value. To prevent the endpoint
+ * from being returned by a later autoconfig call, claim it by
+ * assigning ep->driver_data to some non-null value.
  *
  * On failure, this returns a null endpoint descriptor.
  */
-struct usb_ep *usb_ep_autoconfig (
+struct usb_ep *usb_ep_autoconfig_ss(
 	struct usb_gadget		*gadget,
-	struct usb_endpoint_descriptor	*desc
+	struct usb_endpoint_descriptor	*desc,
+	struct usb_ss_ep_comp_descriptor *ep_comp
 )
 {
 	struct usb_ep	*ep;
@@ -254,23 +288,24 @@ struct usb_ep *usb_ep_autoconfig (
 	if (gadget_is_net2280 (gadget) && type == USB_ENDPOINT_XFER_INT) {
 		/* ep-e, ep-f are PIO with only 64 byte fifos */
 		ep = find_ep (gadget, "ep-e");
-		if (ep && ep_matches (gadget, ep, desc))
+		if (ep && ep_matches(gadget, ep, desc, ep_comp))
 			return ep;
 		ep = find_ep (gadget, "ep-f");
-		if (ep && ep_matches (gadget, ep, desc))
+		if (ep && ep_matches(gadget, ep, desc, ep_comp))
 			return ep;
 
 	} else if (gadget_is_goku (gadget)) {
 		if (USB_ENDPOINT_XFER_INT == type) {
 			/* single buffering is enough */
-			ep = find_ep (gadget, "ep3-bulk");
-			if (ep && ep_matches (gadget, ep, desc))
+			ep = find_ep(gadget, "ep3-bulk");
+			if (ep && ep_matches(gadget, ep, desc, ep_comp))
 				return ep;
 		} else if (USB_ENDPOINT_XFER_BULK == type
 				&& (USB_DIR_IN & desc->bEndpointAddress)) {
 			/* DMA may be available */
-			ep = find_ep (gadget, "ep2-bulk");
-			if (ep && ep_matches (gadget, ep, desc))
+			ep = find_ep(gadget, "ep2-bulk");
+			if (ep && ep_matches(gadget, ep, desc,
+					      ep_comp))
 				return ep;
 		}
 
@@ -289,14 +324,14 @@ struct usb_ep *usb_ep_autoconfig (
 				ep = find_ep(gadget, "ep2out");
 		} else
 			ep = NULL;
-		if (ep && ep_matches (gadget, ep, desc))
+		if (ep && ep_matches(gadget, ep, desc, ep_comp))
 			return ep;
 #endif
 	}
 
 	/* Second, look at endpoints until an unclaimed one looks usable */
 	list_for_each_entry (ep, &gadget->ep_list, ep_list) {
-		if (ep_matches (gadget, ep, desc))
+		if (ep_matches(gadget, ep, desc, ep_comp))
 			return ep;
 	}
 
@@ -305,6 +340,46 @@ struct usb_ep *usb_ep_autoconfig (
 }
 
 /**
+ * usb_ep_autoconfig() - choose an endpoint matching the
+ * descriptor
+ * @gadget: The device to which the endpoint must belong.
+ * @desc: Endpoint descriptor, with endpoint direction and transfer mode
+ *	initialized.  For periodic transfers, the maximum packet
+ *	size must also be initialized.  This is modified on success.
+ *
+ * By choosing an endpoint to use with the specified descriptor, this
+ * routine simplifies writing gadget drivers that work with multiple
+ * USB device controllers.  The endpoint would be passed later to
+ * usb_ep_enable(), along with some descriptor.
+ *
+ * That second descriptor won't always be the same as the first one.
+ * For example, isochronous endpoints can be autoconfigured for high
+ * bandwidth, and then used in several lower bandwidth altsettings.
+ * Also, high and full speed descriptors will be different.
+ *
+ * Be sure to examine and test the results of autoconfiguration on your
+ * hardware.  This code may not make the best choices about how to use the
+ * USB controller, and it can't know all the restrictions that may apply.
+ * Some combinations of driver and hardware won't be able to autoconfigure.
+ *
+ * On success, this returns an un-claimed usb_ep, and modifies the endpoint
+ * descriptor bEndpointAddress.  For bulk endpoints, the wMaxPacket value
+ * is initialized as if the endpoint were used at full speed.  To prevent
+ * the endpoint from being returned by a later autoconfig call, claim it
+ * by assigning ep->driver_data to some non-null value.
+ *
+ * On failure, this returns a null endpoint descriptor.
+ */
+struct usb_ep *usb_ep_autoconfig(
+	struct usb_gadget		*gadget,
+	struct usb_endpoint_descriptor	*desc
+)
+{
+	return usb_ep_autoconfig_ss(gadget, desc, NULL);
+}
+
+
+/**
  * usb_ep_autoconfig_reset - reset endpoint autoconfig state
  * @gadget: device for which autoconfig state will be reset
  *
diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index d1b4ee8..490fa77 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -27,6 +27,7 @@ struct usb_ep;
  *	field, and the usb controller needs one, it is responsible
  *	for mapping and unmapping the buffer.
  * @length: Length of that data
+ * @stream_id: The stream id, when USB3.0 bulk streams are being used
  * @no_interrupt: If true, hints that no completion irq is needed.
  *	Helpful sometimes with deep request queues that are handled
  *	directly by DMA controllers.
@@ -81,6 +82,7 @@ struct usb_request {
 	unsigned		length;
 	dma_addr_t		dma;
 
+	unsigned		stream_id:16;
 	unsigned		no_interrupt:1;
 	unsigned		zero:1;
 	unsigned		short_not_ok:1;
@@ -131,6 +133,8 @@ struct usb_ep_ops {
  * @maxpacket:The maximum packet size used on this endpoint.  The initial
  *	value can sometimes be reduced (hardware allowing), according to
  *      the endpoint descriptor used to configure the endpoint.
+ * @max_streams: The maximum number of streams supported
+ *	by this EP (0 - 16, actual number is 2^n)
  * @mult: multiplier, 'mult' value for SS Isoc EPs
  * @maxburst: the maximum number of bursts supported by this EP (for usb3)
  * @driver_data:for use by the gadget driver.
@@ -152,6 +156,7 @@ struct usb_ep {
 	const struct usb_ep_ops	*ops;
 	struct list_head	ep_list;
 	unsigned		maxpacket:16;
+	unsigned		max_streams:16;
 	unsigned				mult:2;
 	unsigned				pad:1;
 	unsigned				maxburst:4;
@@ -921,6 +926,11 @@ static inline void usb_free_descriptors(struct usb_descriptor_header **v)
 extern struct usb_ep *usb_ep_autoconfig(struct usb_gadget *,
 			struct usb_endpoint_descriptor *);
 
+
+extern struct usb_ep *usb_ep_autoconfig_ss(struct usb_gadget *,
+			struct usb_endpoint_descriptor *,
+			struct usb_ss_ep_comp_descriptor *);
+
 extern void usb_ep_autoconfig_reset(struct usb_gadget *);
 
 #endif /* __LINUX_USB_GADGET_H */
-- 
1.7.3.3

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
