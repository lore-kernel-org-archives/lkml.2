Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab1DNHfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 03:35:46 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22366 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab1DNHfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 03:35:44 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6315"; a="85722562"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Sebastian Andrzej Siewior'" <bigeasy@linutronix.de>
Cc: <gregkh@suse.de>, <linux-arm-msm@vger.kernel.org>, <balbi@ti.com>,
        <ablay@codeaurora.org>,
        "'open list:USB GADGET/PERIPH...'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1300867498-20997-1-git-send-email-tlinder@codeaurora.org> <20110411175917.GE4018@linutronix.de>
In-Reply-To: <20110411175917.GE4018@linutronix.de>
Subject: RE: [PATCH 5/5 v5] usb:gadget: Add SuperSpeed support to the Gadget Framework
Date: Thu, 14 Apr 2011 10:36:42 +0300
Message-ID: <002a01cbfa76$b5567c20$20037460$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acv4ci1KKBVxYAJXQdGuPcESRz/JbwCAFe5g
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

> >+/* Default endpoint companion descriptor */
> >+static struct usb_ss_ep_comp_descriptor default_ep_comp_desc = {
> >+		.bDescriptorType = USB_DT_SS_ENDPOINT_COMP,
> >+		.bLength = 0x06,
> sizeof() ?
> 
> >+		.bMaxBurst = 0, /* the default is we don't support bursting
> */
> >+		.bmAttributes = 0, /* 2^0 streams supported */
> >+		.wBytesPerInterval = 0,
> It is already 0 :) It makes sense to set to 0 if you want to point out
> something specific.


Just wanted all the values to be visible/specified. When reading the code
one can forget that wBytesPerInterval field is a part of this descriptor.
Since these are default values I thought that this "reminder" is better.

> >+	ss_cap->bLength = USB_DT_USB_SS_CAP_SIZE;
> >+	ss_cap->bDescriptorType = USB_DT_DEVICE_CAPABILITY;
> >+	ss_cap->bDevCapabilityType = USB_SS_CAP_TYPE;
> >+	ss_cap->bmAttributes = 0; /* LTM is not supported yet */
> 
> Who's fault is it? Isn't this always supported by the SS-udc?


I didn't find anything in the USB30 Spec that mentions that LTM support is
required from all SS-UDCs. 
We're working on a SS-UDC at the moment and we decide that LTM support will
be added later on. 
My guess is that when we do add this support we'll add some sort of a cb
from the UDC to set this value according to.

> >@@ -903,18 +1162,28 @@ composite_setup(struct usb_gadget *gadget,
> const struct usb_ctrlrequest *ctrl)
> > 		case USB_DT_DEVICE:
> > 			cdev->desc.bNumConfigurations =
> > 				count_configs(cdev, USB_DT_DEVICE);
> >+			cdev->desc.bMaxPacketSize0 =
> >+				cdev->gadget->ep0->maxpacket;
> >+			if (gadget->speed >= USB_SPEED_SUPER)
> there is something after super speed?

Not at the moment but I believe might be in the future :-)

> >@@ -1107,8 +1441,11 @@ composite_unbind(struct usb_gadget *gadget)
> > 				DBG(cdev, "unbind function '%s'/%p\n",
> > 						f->name, f);
> > 				f->unbind(c, f);
> >-				/* may free memory for "f" */
> > 			}
> >+			/* Free memory allocated for ss descriptors */
> >+			if (f->ss_desc_allocated && f->ss_descriptors)
> 
> check for  f->ss_descriptors is not required since kfree(null) is fine.
> However this does no fly. f->unbind() will free the memmory of f. So
> moving the comment does not delay the de-allocation :)
> The comment is should probably use "will" instead of "may" since all
> gadgets I checked do this.
> The conditional allocation/free of the ss descriptor is kind of nasty.
> Wouldn't it be better to add create_ss_descriptors() for every gadget
> driver that needs it? This isn't that much. And in unbind you could
> always free all three of them using one function like
> free_all_descritpors().

You're right in your observation that the above is not the best way to
handle this. I've re-designed this a bit in the next version. 
We don't want to create ss descriptors for all of the gadget drivers
automatically. First of all because this way all of the gadget drivers will
be forced to operate over SS connection if such is available. The purpose of
the  function->ss_not_capable flag was to allow a gadget driver to force
HS/LS connection even if SS is available. 
Anyway this two flags (ss_not_capable and ss_desc_allocated) were replaced
by another flag (function->generate_ss_desc) that should be set to true by
any gadget driver that wishes ss descriptors to be automatically generated
for it.
We discussed this with Felipe and came to a conclusion that this function
(create_ss_descriptors()) will be taken out to a different patch that won't
be merged into the mainline, just posted on the mailing list to help
developers in early stages of their work. 
In the long run the better approach is that each gadget driver that wishes
to operate in ss connection speed should provide his own ss descriptors with
values that are suitable for it.


Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum




