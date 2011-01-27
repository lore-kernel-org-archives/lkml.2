Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab1A0NNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 08:13:33 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27772 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab1A0NNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 08:13:31 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6238"; a="71972470"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: gregkh@suse.de
Cc: linux-arm-msm@vger.kernel.org, Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-usb@vger.kernel.org (open list:USB GADGET/PERIPH...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH/RESEND v4 3/5] usb: Configure endpoint according to gadget speed.
Date: Thu, 27 Jan 2011 15:13:17 +0200
Message-Id: <1296133998-31591-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add config_ep_by_speed() to configure the endpoint according to the gadget
speed. Using this function will spare the FDs from handling the endpoint
chosen descriptor.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
---
 drivers/usb/gadget/composite.c  |   76 +++++++++++++++++++++++++++++++++++++++
 drivers/usb/gadget/epautoconf.c |    1 +
 include/linux/usb/composite.h   |   21 +++++++++++
 include/linux/usb/gadget.h      |    3 ++
 4 files changed, 101 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index f6ff845..efb6d9c 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -74,6 +74,82 @@ MODULE_PARM_DESC(iSerialNumber, "SerialNumber string");
 static char composite_manufacturer[50];
 
 /*-------------------------------------------------------------------------*/
+/**
+ * next_ep_desc() - advance to the next EP descriptor
+ * @t: currect pointer within descriptor array
+ *
+ * Return: next EP descriptor or NULL
+ *
+ * Iterate over @t until either EP descriptor found or
+ * NULL (that indicates end of list) encountered
+ */
+static struct usb_descriptor_header**
+next_ep_desc(struct usb_descriptor_header **t)
+{
+	for (; *t; t++) {
+		if ((*t)->bDescriptorType == USB_DT_ENDPOINT)
+			return t;
+	}
+	return NULL;
+}
+
+/**
+ * config_ep_by_speed() - configures the given endpoint
+ * according to gadget speed.
+ * @g: pointer to the gadget
+ * @f: usb function
+ * @_ep: the endpoint to configure
+ *
+ * Return: error code, 0 on success
+ *
+ * This function chooses the right descriptors for a given
+ * endpoint according to gadget speed and saves in in the
+ * endpoint desc field. If the endpoint already has a descriptor
+ * assigned to it - overwrites it with currently corresponding
+ * descriptor. The endpoint maxpacket field is updated according
+ * to the choosen descriptor.
+ * Note: the supplied function should hold all the descriptors
+ * for supported speeds
+ */
+int config_ep_by_speed(struct usb_gadget *g,
+			struct usb_function *f,
+			struct usb_ep *_ep)
+{
+	struct usb_endpoint_descriptor *chosen_desc = NULL;
+	struct usb_descriptor_header **speed_desc = NULL;
+
+	struct usb_descriptor_header **d_spd; /* cursor for speed desc */
+
+	if (!g || !f || !_ep)
+		return -EIO;
+
+	/* select desired speed */
+	switch (g->speed) {
+	case USB_SPEED_HIGH:
+		if (gadget_is_dualspeed(g)) {
+			speed_desc = f->hs_descriptors;
+			break;
+		}
+		/* else: fall through */
+	default:
+		speed_desc = f->descriptors;
+	}
+	/* find descriptors */
+	for (d_spd = next_ep_desc(speed_desc); d_spd;
+	      d_spd = next_ep_desc(d_spd+1)) {
+		chosen_desc = (struct usb_endpoint_descriptor *)*d_spd;
+		if (chosen_desc->bEndpointAddress == _ep->bEndpointAddress)
+			goto ep_found;
+	}
+	return -EIO;
+
+ep_found:
+	/* commit results */
+	_ep->maxpacket = le16_to_cpu(chosen_desc->wMaxPacketSize);
+	_ep->desc = chosen_desc;
+
+	return 0;
+}
 
 /**
  * usb_add_function() - add a function to a configuration
diff --git a/drivers/usb/gadget/epautoconf.c b/drivers/usb/gadget/epautoconf.c
index 8a83248..84ce0fa 100644
--- a/drivers/usb/gadget/epautoconf.c
+++ b/drivers/usb/gadget/epautoconf.c
@@ -184,6 +184,7 @@ ep_matches (
 			size = 64;
 		desc->wMaxPacketSize = cpu_to_le16(size);
 	}
+	ep->bEndpointAddress = desc->bEndpointAddress;
 	return 1;
 }
 
diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
index 3d29a7d..b0c78cd 100644
--- a/include/linux/usb/composite.h
+++ b/include/linux/usb/composite.h
@@ -138,6 +138,27 @@ int usb_function_activate(struct usb_function *);
 int usb_interface_id(struct usb_configuration *, struct usb_function *);
 
 /**
+ * config_ep_by_speed() - configures the given endpoint
+ * according to gadget speed.
+ * @g: pointer to the gadget
+ * @f: usb function
+ * @_ep: the endpoint to configure
+ *
+ * Return: error code, 0 on success
+ *
+ * This function chooses the right descriptors for a given
+ * endpoint according to gadget speed and saves in in the
+ * endpoint desc field. If the endpoint already has a descriptor
+ * assigned to it - overwrites it with currently corresponding
+ * descriptor. The endpoint maxpacket field is updated according
+ * to the choosen descriptor.
+ * Note: the supplied function should hold all the descriptors
+ * for supported speeds
+ */
+int config_ep_by_speed(struct usb_gadget *g, struct usb_function *f,
+			struct usb_ep *_ep);
+
+/**
  * ep_choose - select descriptor endpoint at current device speed
  * @g: gadget, connected and running at some speed
  * @hs: descriptor to use for high speed operation
diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index 500ae91..0387aba 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -132,6 +132,8 @@ struct usb_ep_ops {
  *	value can sometimes be reduced (hardware allowing), according to
  *      the endpoint descriptor used to configure the endpoint.
  * @driver_data:for use by the gadget driver.
+ * @bEndpointAddress: used to identify the endpoint when finding
+ *	descriptor that matches connection speed
  * @desc: endpoint descriptor.  This pointer is set before the endpoint is
  *	enabled and remains valid until the endpoint is disabled.
  *
@@ -146,6 +148,7 @@ struct usb_ep {
 	const struct usb_ep_ops	*ops;
 	struct list_head	ep_list;
 	unsigned		maxpacket:16;
+	u8				bEndpointAddress;
 	const struct usb_endpoint_descriptor	*desc;
 };
 
-- 
1.6.3.3

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
