Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab0KNGYl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 01:24:41 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56233 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab0KNGYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 01:24:40 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6166"; a="62623330"
From: Maya Erez <merez@codeaurora.org>
To: linux-usb@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Maya Erez <merez@codeaurora.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Mike Frysinger <vapier@gentoo.org>, Cliff Cai <cliff.cai@analog.com>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Fabien Chouteau <fabien.chouteau@barco.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [RFC/PATCH] usb: Add streams support to epautoconf.
Date: Sun, 14 Nov 2010 08:23:20 +0200
Message-Id: <1289715812-29000-1-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Add the capability to search for an EP with a required number of streams.
- Add a gadget_op to allow DCDs to use a proprietary search algorithm
for required and minimum number of streams.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/usb/gadget/epautoconf.c |  141 ++++++++++++++++++++++++++++++++-------
 include/linux/usb/gadget.h      |   14 ++++-
 2 files changed, 129 insertions(+), 26 deletions(-)

diff --git a/drivers/usb/gadget/epautoconf.c b/drivers/usb/gadget/epautoconf.c
index 8a83248..bbac2fb 100644
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
@@ -128,6 +131,22 @@ ep_matches (
 		}
 	}

+
+	/* Get the number of required streams from the EP companion
+	 * descriptor and see if the EP matches it
+	 */
+	if (USB_ENDPOINT_XFER_BULK == type) {
+		if (ep_comp) {
+			num_req_streams = ep_comp->bmAttributes & 0x1f;
+			if (num_req_streams > ep->num_supported_strms)
+				return 0;
+			/* Update the ep_comp descriptor if needed */
+			if (num_req_streams != ep->num_supported_strms)
+				ep_comp->bmAttributes = ep->num_supported_strms;
+		}
+
+	}
+
 	/* endpoint maxpacket size is an input parameter, except for bulk
 	 * where it's an output parameter representing the full speed limit.
 	 * the usb spec fixes high speed bulk maxpacket at 512 bytes.
@@ -200,43 +219,74 @@ find_ep (struct usb_gadget *gadget, const char *name)
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
+ * @min_num_of_req_strms: A minimum number of streams that allow
+ *    the FD to be functional
  *
- * By choosing an endpoint to use with the specified descriptor, this
- * routine simplifies writing gadget drivers that work with multiple
- * USB device controllers.  The endpoint would be passed later to
- * usb_ep_enable(), along with some descriptor.
+ * This routine replaces the usb_ep_autoconfig when needed
+ * superspeed enhancments. If such enhancemnets are required,
+ * the FD should call usb_ep_autoconfig_ss directly and provide
+ * the additional ep_comp and min_num_of_req_strms parameters.
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
+ * To allow controller special algorithms, we added a new gadget
+ * op for assigning an ep.
+ *
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
+	struct usb_ss_ep_comp_descriptor *ep_comp,
+	int min_num_of_req_strms
 )
 {
 	struct usb_ep	*ep;
 	u8		type;

+	/* Call the controller specific function for assigning an EP
+	 * if it is defined
+	 */
+	if (gadget->ops->ep_assign) {
+		struct usb_ep *assigned_ep = NULL;
+		gadget->ops->ep_assign(gadget, desc, ep_comp,
+				    min_num_of_req_strms, &assigned_ep);
+		return assigned_ep;
+	}
+
 	type = desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK;

 	/* First, apply chip-specific "best usage" knowledge.
@@ -245,23 +295,24 @@ struct usb_ep *usb_ep_autoconfig (
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

@@ -280,14 +331,14 @@ struct usb_ep *usb_ep_autoconfig (
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

@@ -296,6 +347,46 @@ struct usb_ep *usb_ep_autoconfig (
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
+	return usb_ep_autoconfig_ss(gadget, desc, NULL, 0);
+}
+
+
+/**
  * usb_ep_autoconfig_reset - reset endpoint autoconfig state
  * @gadget: device for which autoconfig state will be reset
  *
diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index d3ef42d..bfbd32f 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -419,7 +419,7 @@ static inline void usb_ep_fifo_flush(struct usb_ep *ep)
 struct usb_gadget;

 /* the rest of the api to the controller hardware: device operations,
- * which don't involve endpoints (or i/o).
+ * which don't involve i/o.
  */
 struct usb_gadget_ops {
 	int	(*get_frame)(struct usb_gadget *);
@@ -430,6 +430,12 @@ struct usb_gadget_ops {
 	int	(*pullup) (struct usb_gadget *, int is_on);
 	int	(*ioctl)(struct usb_gadget *,
 				unsigned code, unsigned long param);
+	int	(*ep_assign) (struct usb_gadget *,
+		struct usb_endpoint_descriptor	*,
+		struct usb_ss_ep_comp_descriptor *,
+		int min_num_of_req_strms,
+		struct usb_ep **returned_ep);
+
 };

 /**
@@ -896,6 +902,12 @@ static inline void usb_free_descriptors(struct usb_descriptor_header **v)
 extern struct usb_ep *usb_ep_autoconfig(struct usb_gadget *,
 			struct usb_endpoint_descriptor *) __devinit;

+
+extern struct usb_ep *usb_ep_autoconfig_ss(struct usb_gadget *,
+			struct usb_endpoint_descriptor *,
+			struct usb_ss_ep_comp_descriptor *,
+			int min_num_of_req_strms) __devinit;
+
 extern void usb_ep_autoconfig_reset(struct usb_gadget *) __devinit;

 #endif /* __LINUX_USB_GADGET_H */
--
1.6.3.3
--
Seny by a Consultant for Qualcomm innovation center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
