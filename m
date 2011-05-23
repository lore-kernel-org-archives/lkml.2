Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab1EWMbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 08:31:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:38527 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab1EWMbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 08:31:46 -0400
Date: Mon, 23 May 2011 14:31:36 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Mike Frysinger <vapier@gentoo.org>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        balbi@ti.com, ablay@codeaurora.org,
        open list <linux-kernel@vger.kernel.org>,
        Tatyana Brokhman <tlinder@codeaurora.org>
Subject: Re: [PATCH v12 4/8] usb:gadget: Add SuperSpeed support to the
 Gadget Framework
Message-ID: <20110523123135.GA10785@linutronix.de>
References: <1306132882-9668-1-git-send-email-tlinder@codeaurora.org>
 <1306132882-9668-5-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1306132882-9668-5-git-send-email-tlinder@codeaurora.org>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tatyana Brokhman | 2011-05-23 09:41:13 [+0300]:
>diff --git a/drivers/usb/gadget/composite.c
>b/drivers/usb/gadget/composite.c
>index 1c6bd66..7738302 100644
>--- a/drivers/usb/gadget/composite.c
>+++ b/drivers/usb/gadget/composite.c
>@@ -1015,6 +1175,62 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
> 		*((u8 *)req->buf) = value;
> 		value = min(w_length, (u16) 1);
> 		break;
>+
>+	/*
>+	 * USB 3.0 additions:
>+	 * Function driver should handle get_status request. If such cb
>+	 * wasn't supplied we respond with default value = 0
>+	 * Note: function driver should supply such cb only for the first
>+	 * interface of the function
>+	 */
>+	case USB_REQ_GET_STATUS:
>+		if (!gadget_is_superspeed(gadget))
>+			goto unknown;
>+		if (ctrl->bRequestType != (USB_DIR_IN | USB_RECIP_INTERFACE))
>+			goto unknown;
>+		value = 2;	/* This is the length of the get_status reply */
>+		*((__le16 *)req->buf) = 0;

Mike please correct me if I'm wrong bug this looks like a case for
put_unaligned_le16().
Is someone actually using gadget support on blackfin? I'm asking because
config_buf() (same file, upstream) is using req->buf to build the
descriptors in place and one element is le16 which should be affected.

>+		if (!cdev->config || intf >= MAX_CONFIG_INTERFACES)
>+			break;
>+		f = cdev->config->interface[intf];
>+		if (!f)
>+			break;
>+		status = f->get_status ? f->get_status(f) : 0;
>+		if (status < 0)
>+			break;
>+		*((__le16 *)req->buf) = cpu_to_le16(status & 0x0000ffff);
and here.

>+		break;

Sebastian
