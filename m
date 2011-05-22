Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab1EVHTF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 03:19:05 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8966 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab1EVHS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 03:18:58 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6353"; a="92601441"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Sebastian Andrzej Siewior'" <bigeasy@linutronix.de>
Cc: <greg@kroah.com>, <linux-usb@vger.kernel.org>, <balbi@ti.com>,
        <ablay@codeaurora.org>, <linux-arm-msm@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1305805417-31750-1-git-send-email-tlinder@codeaurora.org> <1305805417-31750-5-git-send-email-tlinder@codeaurora.org> <20110520164924.GC31929@linutronix.de>
In-Reply-To: <20110520164924.GC31929@linutronix.de>
Subject: RE: [PATCH v11 4/7] usb:gadget: Add SuperSpeed support to the Gadget Framework
Date: Sun, 22 May 2011 10:20:42 +0300
Message-ID: <002401cc1850$c4cd7030$4e685090$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcwXDdfV4OyUe18gR/S0ZucMjIuSlgBQfGNg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian

> >@@ -157,7 +167,35 @@ ep_found:
> > 	/* commit results */
> > 	_ep->maxpacket = le16_to_cpu(chosen_desc->wMaxPacketSize);
> > 	_ep->desc = chosen_desc;
> >-
> >+	_ep->comp_desc = NULL;
> >+	_ep->maxburst = 0;
> >+	_ep->mult = 0;
> >+	if (want_comp_desc) {
> 
>     if (!want_comp_desc)
>         return 0;
> 
> I have one ident level less :)
Done :)

> >+/**
> >+ * bos_desc() - prepares the BOS descriptor.
> >+ * @cdev: pointer to usb_composite device to generate the bos
> >+ *	descriptor for
> >+ *
> >+ * This function generates the BOS (Binary Device Object)
> >+ * descriptor and its device capabilities descriptors. The BOS
> >+ * descriptor should be supported by a SuperSpeed device.
> >+ */
> >+static int bos_desc(struct usb_composite_dev *cdev)
> >+{
> >+	struct usb_ext_cap_descriptor	*usb_ext;
> >+	struct usb_ss_cap_descriptor	*ss_cap;
> >+	struct usb_dcd_config_params	dcd_config_params;
> >+	struct usb_bos_descriptor	*bos = cdev->req->buf;
> >+
> >+	bos->bLength = USB_DT_BOS_SIZE;
> >+	bos->bDescriptorType = USB_DT_BOS;
> >+
> >+	bos->wTotalLength = cpu_to_le16(USB_DT_BOS_SIZE);
> >+	bos->bNumDeviceCaps = 0;
> >+
> >+	/*
> >+	 * A SuperSpeed device shall include the USB2.0 extension
> descriptor
> >+	 * and shall support LPM when operating in USB2.0 HS mode.
> >+	 */
> >+	usb_ext = (struct usb_ext_cap_descriptor *)
> cdev->req->buf is (void *) so you can skip that cast.
> 
> >+			(cdev->req->buf+bos->wTotalLength);
> a space between + please. bos->wTotalLength is le16 so you can't simply
> do that way.
> 
> What about something like
> 
>   usb_ext = (struct usb_ext_cap_descriptor *)(bos + 1)
> 
> ?

Added the spaces and the le16_to_cpu(bos->wTotalLength). 
It seems clearer to me to leave it as 
	usb_ext = cdev->req->buf + le16_to_cpu(bos->wTotalLength);
if that's ok with you.

> >@@ -499,6 +633,9 @@ static int set_config(struct usb_composite_dev
> *cdev,
> > 		case USB_SPEED_LOW:	speed = "low"; break;
> > 		case USB_SPEED_FULL:	speed = "full"; break;
> > 		case USB_SPEED_HIGH:	speed = "high"; break;
> >+		case USB_SPEED_SUPER:
> >+			speed = "super";
> >+			break;
> 
> This is not my favorite style either but please do it the way the other
> three are done.

Well here is the dilemma: if I do it the other tree were done - I get
checkpatch error. 
You're right, adding this the way it's above doesn't look too good but when
I fixed the other three I was asked not to do so in this patch, which also
makes sense since it has nothing to do with SS support...
So what do I do? Submit with a checkpatch error?


Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum




