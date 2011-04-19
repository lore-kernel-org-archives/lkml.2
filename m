Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384Ab1DSOXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 10:23:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41231 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab1DSOXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 10:23:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=kcWguZDaiMpKrN1buGUXT269RacTjBrVJyGTGU4J3upgHlTQl+QO8SGPElfbwheZza
         poChevjPmgtjAcr8vWkosKAIIe53aXk4GaNXVpPNShvbP0UuC8zIkp1yayKfshTEm6sb
         CEjU1lSalIgyE4eobzsHowApCZRBcllSzVCoE=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: gregkh@suse.de, "Roger Quadros" <roger.quadros@nokia.com>
Cc: stern@rowland.harvard.edu, m-sonasath@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] usb: gadget: composite: Allow function drivers to
 defer setup responses
References: <1303220033-5274-1-git-send-email-roger.quadros@nokia.com>
 <1303220033-5274-2-git-send-email-roger.quadros@nokia.com>
Date: Tue, 19 Apr 2011 16:23:41 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vt6vlrdf3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <1303220033-5274-2-git-send-email-roger.quadros@nokia.com>
User-Agent: Opera Mail/11.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Apr 2011 15:33:52 +0200, Roger Quadros  
<roger.quadros@nokia.com> wrote:
> @@ -895,6 +904,14 @@ composite_setup(struct usb_gadget *gadget, const  
> struct usb_ctrlrequest *ctrl)
>  		if (w_value && !f->set_alt)
>  			break;
>  		value = f->set_alt(f, w_index, w_value);
> +		if (value == USB_GADGET_DELAYED_STATUS) {
> +			DBG(cdev,
> +			 "%s: interface %d (%s) requested delayed status\n",
> +					__func__, intf, f->name);
> +			cdev->delayed_status++;

Do we need it to be a counter? Won't simple flag do?

> +			DBG(cdev, "delayed_status count %d\n",
> +					cdev->delayed_status);
> +		}
>  		break;
>  	case USB_REQ_GET_INTERFACE:
>  		if (ctrl->bRequestType != (USB_DIR_IN|USB_RECIP_INTERFACE))

> @@ -1289,3 +1310,41 @@ void usb_composite_unregister(struct  
> usb_composite_driver *driver)
>  		return;
>  	usb_gadget_unregister_driver(&composite_driver);
>  }
> +
> +/**
> + * usb_composite_setup_continue() - Continue the delayed setup transfer
> + * @cdev: the composite device who's setup transfer was delayed
> + *
> + * This function must be called by the USB function driver to continue
> + * with the setup transfer's data/status phase in case it had requested  
> to
> + * delay the status phase. A USB function's setup handler (e.g.  
> set_alt())
> + * can request the composite framework to delay the setup request's  
> status phase
> + * by returning USB_GADGET_DELAYED_STATUS.
> + */
> +void usb_composite_setup_continue(struct usb_composite_dev *cdev)
> +{
> +	int			value;
> +	struct usb_request	*req = cdev->req;
> +	unsigned long		flags;
> +
> +	DBG(cdev, "%s\n", __func__);
> +	spin_lock_irqsave(&cdev->lock, flags);
> +
> +	if (cdev->delayed_status == 0) {
> +		WARN(cdev, "%s: Unexpected call\n", __func__);
> +
> +	} else if (--cdev->delayed_status == 0) {
> +		DBG(cdev, "%s: Completing delayed status\n", __func__);
> +		req->length = 0;
> +		req->zero = 1;
> +		value = usb_ep_queue(cdev->gadget->ep0, req, GFP_ATOMIC);
> +		if (value < 0) {
> +			DBG(cdev, "ep_queue --> %d\n", value);
> +			req->status = 0;
> +			composite_setup_complete(cdev->gadget->ep0, req);
> +		}
> +	}
> +
> +	spin_unlock_irqrestore(&cdev->lock, flags);
> +}

It's just my opinion but I dislike how it looks almost identical to the end
of composite_setup.  I would rather make it more general (take value as
argument for instance) and let composite_setup() call it.

> diff --git a/include/linux/usb/composite.h @@ -37,6 +37,15 @@
>  #include <linux/usb/ch9.h>
>  #include <linux/usb/gadget.h>
> +/*
> + * USB function drivers should return USB_GADGET_DELAYED_STATUS if they
> + * wish to delay the status phase of the setup transfer till they are
> + * ready. The composite framework will then delay the data/status phase
> + * of the setup transfer till all the function drivers that requested  
> for
> + * USB_GADGET_DELAYED_STAUS, invoke usb_composite_setup_continue().
> + *
> + */
> +#define USB_GADGET_DELAYED_STATUS       0x7fff	/* Impossibly large  
> value */

I was wondering if we could change it to something like EDELAYED and put  
it to
<include/linux/errno.h>.  Just thinking, it may be a bad idea.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
