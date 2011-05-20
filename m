Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935278Ab1ETQtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 12:49:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:45014 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935006Ab1ETQta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 12:49:30 -0400
Date: Fri, 20 May 2011 18:49:24 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org, linux-arm-msm@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v11 4/7] usb:gadget: Add SuperSpeed support to the
 Gadget Framework
Message-ID: <20110520164924.GC31929@linutronix.de>
References: <1305805417-31750-1-git-send-email-tlinder@codeaurora.org>
 <1305805417-31750-5-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1305805417-31750-5-git-send-email-tlinder@codeaurora.org>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tatyana Brokhman | 2011-05-19 14:43:29 [+0300]:

>diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
>index cfba1ee..bd811ac 100644
>--- a/drivers/usb/gadget/composite.c
>+++ b/drivers/usb/gadget/composite.c
>@@ -136,6 +139,13 @@ int config_ep_by_speed(struct usb_gadget *g,
> 
> 	/* select desired speed */
> 	switch (g->speed) {
>+	case USB_SPEED_SUPER:
>+		if (gadget_is_superspeed(g)) {
>+			speed_desc = f->ss_descriptors;
>+			want_comp_desc = 1;
>+			break;
>+		}
>+		/* else: Fall trough */
> 	case USB_SPEED_HIGH:
> 		if (gadget_is_dualspeed(g)) {
> 			speed_desc = f->hs_descriptors;
>@@ -157,7 +167,35 @@ ep_found:
> 	/* commit results */
> 	_ep->maxpacket = le16_to_cpu(chosen_desc->wMaxPacketSize);
> 	_ep->desc = chosen_desc;
>-
>+	_ep->comp_desc = NULL;
>+	_ep->maxburst = 0;
>+	_ep->mult = 0;
>+	if (want_comp_desc) {

    if (!want_comp_desc)
        return 0;

I have one ident level less :)

>+		/*
>+		 * Companion descriptor should follow EP descriptor
>+		 * USB 3.0 spec, #9.6.7
>+		 */
>+		comp_desc = (struct usb_ss_ep_comp_descriptor *)*(++d_spd);
>+		if (!comp_desc ||
>+		    (comp_desc->bDescriptorType != USB_DT_SS_ENDPOINT_COMP))
>+			return -EIO;
>+		_ep->comp_desc = comp_desc;
>+		if (g->speed == USB_SPEED_SUPER) {
>+			switch (usb_endpoint_type(_ep->desc)) {
>+			case USB_ENDPOINT_XFER_BULK:
>+			case USB_ENDPOINT_XFER_INT:
>+				_ep->maxburst = comp_desc->bMaxBurst;
>+				break;
>+			case USB_ENDPOINT_XFER_ISOC:
>+				/* mult: bits 1:0 of bmAttributes */
>+				_ep->mult = comp_desc->bmAttributes & 0x3;
>+				break;
>+			default:
>+				/* Do nothing for control endpoints */
>+				break;
>+			}
>+		}
>+	}
> 	return 0;
> }
> 
>@@ -435,6 +496,73 @@ static int count_configs(struct usb_composite_dev *cdev, unsigned type)
> 	return count;
> }
> 
>+/**
>+ * bos_desc() - prepares the BOS descriptor.
>+ * @cdev: pointer to usb_composite device to generate the bos
>+ *	descriptor for
>+ *
>+ * This function generates the BOS (Binary Device Object)
>+ * descriptor and its device capabilities descriptors. The BOS
>+ * descriptor should be supported by a SuperSpeed device.
>+ */
>+static int bos_desc(struct usb_composite_dev *cdev)
>+{
>+	struct usb_ext_cap_descriptor	*usb_ext;
>+	struct usb_ss_cap_descriptor	*ss_cap;
>+	struct usb_dcd_config_params	dcd_config_params;
>+	struct usb_bos_descriptor	*bos = cdev->req->buf;
>+
>+	bos->bLength = USB_DT_BOS_SIZE;
>+	bos->bDescriptorType = USB_DT_BOS;
>+
>+	bos->wTotalLength = cpu_to_le16(USB_DT_BOS_SIZE);
>+	bos->bNumDeviceCaps = 0;
>+
>+	/*
>+	 * A SuperSpeed device shall include the USB2.0 extension descriptor
>+	 * and shall support LPM when operating in USB2.0 HS mode.
>+	 */
>+	usb_ext = (struct usb_ext_cap_descriptor *)
cdev->req->buf is (void *) so you can skip that cast.

>+			(cdev->req->buf+bos->wTotalLength);
a space between + please. bos->wTotalLength is le16 so you can't simply
do that way.

What about something like 

  usb_ext = (struct usb_ext_cap_descriptor *)(bos + 1)

?

>+	bos->bNumDeviceCaps++;
>+	le16_add_cpu(&(bos->wTotalLength), USB_DT_USB_EXT_CAP_SIZE);
the () around bos->wTotalLength aren't required.

>+	usb_ext->bLength = USB_DT_USB_EXT_CAP_SIZE;
>+	usb_ext->bDescriptorType = USB_DT_DEVICE_CAPABILITY;
>+	usb_ext->bDevCapabilityType = USB_CAP_TYPE_EXT;
>+	usb_ext->bmAttributes = cpu_to_le32(USB_LPM_SUPPORT);
>+
>+	/*
>+	 * The Superspeed USB Capability descriptor shall be implemented by all
>+	 * SuperSpeed devices.
>+	 */
>+	ss_cap = (struct usb_ss_cap_descriptor *)
>+		(cdev->req->buf+bos->wTotalLength);
Same here.

>+	bos->bNumDeviceCaps++;
>+	le16_add_cpu(&(bos->wTotalLength), USB_DT_USB_SS_CAP_SIZE);
and here.

>+	ss_cap->bLength = USB_DT_USB_SS_CAP_SIZE;
>+	ss_cap->bDescriptorType = USB_DT_DEVICE_CAPABILITY;
>+	ss_cap->bDevCapabilityType = USB_SS_CAP_TYPE;
>+	ss_cap->bmAttributes = 0; /* LTM is not supported yet */
>+	ss_cap->wSpeedSupported = cpu_to_le16(USB_LOW_SPEED_OPERATION |
>+				USB_FULL_SPEED_OPERATION |
>+				USB_HIGH_SPEED_OPERATION |
>+				USB_5GBPS_OPERATION);
>+	ss_cap->bFunctionalitySupport = USB_LOW_SPEED_OPERATION;
>+
>+	/* Get Controller configuration */
>+	if (cdev->gadget->ops->get_config_params)
>+		cdev->gadget->ops->get_config_params(&dcd_config_params);
>+	else {
>+		dcd_config_params.bU1devExitLat = USB_DEFULT_U1_DEV_EXIT_LAT;
>+		dcd_config_params.bU2DevExitLat =
>+			cpu_to_le16(USB_DEFULT_U2_DEV_EXIT_LAT);
>+	}
>+	ss_cap->bU1devExitLat = dcd_config_params.bU1devExitLat;
>+	ss_cap->bU2DevExitLat = dcd_config_params.bU2DevExitLat;
>+
>+	return bos->wTotalLength;

return le16_to_cpu(bos->wTotalLength);

>+}
>+
> static void device_qual(struct usb_composite_dev *cdev)
> {
> 	struct usb_qualifier_descriptor	*qual = cdev->req->buf;
>@@ -478,20 +606,26 @@ static int set_config(struct usb_composite_dev *cdev,
> 	unsigned		power = gadget_is_otg(gadget) ? 8 : 100;
> 	int			tmp;
> 
>-	if (cdev->config)
>-		reset_config(cdev);
>-
> 	if (number) {
> 		list_for_each_entry(c, &cdev->configs, list) {
> 			if (c->bConfigurationValue == number) {
>+				/*
>+				 * Need to disable the FDs of the previous
>+				 * configuration
>+				 */

The comment is kind of obvious :) You are changing the behavioud here:
The old code removed the current configuration if the new one was not
available while the new one does not. According to ch9.4.7 that is the
right thing to do. So you might add something of this to the comment :)

>+				if (cdev->config)
>+					reset_config(cdev);
> 				result = 0;
> 				break;
> 			}
> 		}
> 		if (result < 0)
> 			goto done;
>-	} else
>+	} else { /* Zero configuration value - need to reset the config */
>+		if (cdev->config)
>+			reset_config(cdev);
> 		result = 0;
>+	}
> 
> 	INFO(cdev, "%s speed config #%d: %s\n",
> 		({ char *speed;
>@@ -499,6 +633,9 @@ static int set_config(struct usb_composite_dev *cdev,
> 		case USB_SPEED_LOW:	speed = "low"; break;
> 		case USB_SPEED_FULL:	speed = "full"; break;
> 		case USB_SPEED_HIGH:	speed = "high"; break;
>+		case USB_SPEED_SUPER:
>+			speed = "super";
>+			break;

This is not my favorite style either but please do it the way the other
three are done.

> 		default:		speed = "?"; break;
> 		} ; speed; }), number, c ? c->label : "unconfigured");
> 

Sebastian
