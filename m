Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab1DKOOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 10:14:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:36869 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab1DKOOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 10:14:09 -0400
Date: Mon, 11 Apr 2011 16:14:04 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: gregkh@suse.de, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org,
        "open list:USB GADGET/PERIPH..." <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RESEND 3/5 v4] usb: Configure endpoint according to
 gadget speed.
Message-ID: <20110411141404.GC4018@linutronix.de>
References: <1300867445-20911-1-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1300867445-20911-1-git-send-email-tlinder@codeaurora.org>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tatyana Brokhman | 2011-03-23 10:04:04 [+0200]:

>diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
>index c2251c4..fb7e488 100644
>--- a/drivers/usb/gadget/composite.c
>+++ b/drivers/usb/gadget/composite.c
>@@ -74,6 +74,82 @@ MODULE_PARM_DESC(iSerialNumber, "SerialNumber string");
> static char composite_manufacturer[50];
> 
> /*-------------------------------------------------------------------------*/
>+/**
>+ * next_ep_desc() - advance to the next EP descriptor
>+ * @t: currect pointer within descriptor array
>+ *
>+ * Return: next EP descriptor or NULL
>+ *
>+ * Iterate over @t until either EP descriptor found or
>+ * NULL (that indicates end of list) encountered
>+ */
>+static struct usb_descriptor_header**
>+next_ep_desc(struct usb_descriptor_header **t)
>+{
>+	for (; *t; t++) {
>+		if ((*t)->bDescriptorType == USB_DT_ENDPOINT)
>+			return t;
>+	}
>+	return NULL;
>+}
>+
>+/**
>+ * config_ep_by_speed() - configures the given endpoint
>+ * according to gadget speed.
>+ * @g: pointer to the gadget
>+ * @f: usb function
>+ * @_ep: the endpoint to configure
>+ *
>+ * Return: error code, 0 on success
>+ *
>+ * This function chooses the right descriptors for a given
>+ * endpoint according to gadget speed and saves in in the
                                                 ^it

>+ * endpoint desc field. If the endpoint already has a descriptor
>+ * assigned to it - overwrites it with currently corresponding
>+ * descriptor. The endpoint maxpacket field is updated according
>+ * to the choosen descriptor.
>+ * Note: the supplied function should hold all the descriptors
>+ * for supported speeds
>+ */
>+int config_ep_by_speed(struct usb_gadget *g,
>+			struct usb_function *f,
>+			struct usb_ep *_ep)
>+{
>+	struct usb_endpoint_descriptor *chosen_desc = NULL;
>+	struct usb_descriptor_header **speed_desc = NULL;
>+
>+	struct usb_descriptor_header **d_spd; /* cursor for speed desc */
>+
>+	if (!g || !f || !_ep)
>+		return -EIO;
>+
>+	/* select desired speed */
>+	switch (g->speed) {
>+	case USB_SPEED_HIGH:
>+		if (gadget_is_dualspeed(g)) {
>+			speed_desc = f->hs_descriptors;
>+			break;
>+		}
>+		/* else: fall through */
>+	default:
>+		speed_desc = f->descriptors;
>+	}
>+	/* find descriptors */
>+	for (d_spd = next_ep_desc(speed_desc); d_spd;
>+	      d_spd = next_ep_desc(d_spd+1)) {

this might look better if you would something like the list_for_each()
macro.

>+		chosen_desc = (struct usb_endpoint_descriptor *)*d_spd;
>+		if (chosen_desc->bEndpointAddress == _ep->bEndpointAddress)
>+			goto ep_found;
>+	}
>+	return -EIO;
>+
>+ep_found:
>+	/* commit results */
>+	_ep->maxpacket = le16_to_cpu(chosen_desc->wMaxPacketSize);
>+	_ep->desc = chosen_desc;
>+
>+	return 0;
>+}
> 
> /**
>  * usb_add_function() - add a function to a configuration
>diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
>index 3d29a7d..b0c78cd 100644
>--- a/include/linux/usb/composite.h
>+++ b/include/linux/usb/composite.h
>@@ -138,6 +138,27 @@ int usb_function_activate(struct usb_function *);
> int usb_interface_id(struct usb_configuration *, struct usb_function *);
> 
> /**
>+ * config_ep_by_speed() - configures the given endpoint
>+ * according to gadget speed.
>+ * @g: pointer to the gadget
>+ * @f: usb function
>+ * @_ep: the endpoint to configure
>+ *
>+ * Return: error code, 0 on success
>+ *
>+ * This function chooses the right descriptors for a given
>+ * endpoint according to gadget speed and saves in in the
>+ * endpoint desc field. If the endpoint already has a descriptor
>+ * assigned to it - overwrites it with currently corresponding
>+ * descriptor. The endpoint maxpacket field is updated according
>+ * to the choosen descriptor.
>+ * Note: the supplied function should hold all the descriptors
>+ * for supported speeds
>+ */

You have the same comment (including the same typo) here and in the .c.
Please use only on (in the .c file) as they will go async.

>+int config_ep_by_speed(struct usb_gadget *g, struct usb_function *f,
>+			struct usb_ep *_ep);
>+
>+/**
>  * ep_choose - select descriptor endpoint at current device speed
>  * @g: gadget, connected and running at some speed
>  * @hs: descriptor to use for high speed operation
>diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
>index 500ae91..0387aba 100644
>--- a/include/linux/usb/gadget.h
>+++ b/include/linux/usb/gadget.h
>@@ -132,6 +132,8 @@ struct usb_ep_ops {
>  *	value can sometimes be reduced (hardware allowing), according to
>  *      the endpoint descriptor used to configure the endpoint.
>  * @driver_data:for use by the gadget driver.
>+ * @bEndpointAddress: used to identify the endpoint when finding
>+ *	descriptor that matches connection speed
>  * @desc: endpoint descriptor.  This pointer is set before the endpoint is
>  *	enabled and remains valid until the endpoint is disabled.
>  *

Sebastian
