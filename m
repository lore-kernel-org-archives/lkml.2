Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab1EQNEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 09:04:47 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41702 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab1EQNEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 09:04:44 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6348"; a="91800641"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org, Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH/RESEND v10 2/7] usb: Configure endpoint according to gadget speed.
Date: Tue, 17 May 2011 16:03:16 +0300
Message-Id: <1305637403-3832-3-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1305637403-3832-1-git-send-email-tlinder@codeaurora.org>
References: <1305637403-3832-1-git-send-email-tlinder@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add config_ep_by_speed() to configure the endpoint according to the gadget
speed. Using this function will spare the FDs from handling the endpoint
chosen descriptor.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

---
 drivers/usb/gadget/composite.c  |   86 +++++++++++++++++++++++++++++++++++++++
 drivers/usb/gadget/epautoconf.c |    1 +
 include/linux/usb/composite.h   |   21 +++++++++
 include/linux/usb/gadget.h      |    3 +
 4 files changed, 111 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 5cbb1a4..5780f35 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -27,6 +27,7 @@
 #include <linux/utsname.h>
 
 #include <linux/usb/composite.h>
+#include <linux/byteorder/generic.h>
 
 
 /*
@@ -74,6 +75,91 @@ MODULE_PARM_DESC(iSerialNumber, "SerialNumber string");
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
+/*
+ * for_each_ep_desc()- iterate over endpoint descriptors in the
+ *		descriptors list
+ * @start:	pointer within descriptor array.
+ * @ep_desc:	endpoint descriptor to use as the loop cursor
+ */
+#define for_each_ep_desc(start, ep_desc) \
+	for (ep_desc = next_ep_desc(start); \
+	      ep_desc; ep_desc = next_ep_desc(ep_desc+1))
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
+ * endpoint according to gadget speed and saves it in the
+ * endpoint desc field. If the endpoint already has a descriptor
+ * assigned to it - overwrites it with currently corresponding
+ * descriptor. The endpoint maxpacket field is updated according
+ * to the chosen descriptor.
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
+	for_each_ep_desc(speed_desc, d_spd) {
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
index 9b7360f..de3461a 100644
--- a/drivers/usb/gadget/epautoconf.c
+++ b/drivers/usb/gadget/epautoconf.c
@@ -191,6 +191,7 @@ ep_matches (
 			size = 64;
 		desc->wMaxPacketSize = cpu_to_le16(size);
 	}
+	ep->bEndpointAddress = desc->bEndpointAddress;
 	return 1;
 }
 
diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
index b78cba4..324fbc7 100644
--- a/include/linux/usb/composite.h
+++ b/include/linux/usb/composite.h
@@ -146,6 +146,27 @@ int usb_function_activate(struct usb_function *);
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
+ * endpoint according to gadget speed and saves it in the
+ * endpoint desc field. If the endpoint already has a descriptor
+ * assigned to it - overwrites it with currently corresponding
+ * descriptor. The endpoint maxpacket field is updated according
+ * to the chosen descriptor.
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
index 5c4c30c..7d1188a 100644
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
1.7.3.3

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
