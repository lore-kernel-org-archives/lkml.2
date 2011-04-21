Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab1DUN2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 09:28:00 -0400
Received: from smtp.nokia.com ([147.243.128.24]:27272 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690Ab1DUN17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 09:27:59 -0400
Message-ID: <4DB03169.5090504@nokia.com>
Date: Thu, 21 Apr 2011 16:30:17 +0300
From: Roger Quadros <roger.quadros@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: ext Michal Nazarewicz <mina86@mina86.com>
CC: <gregkh@suse.de>, <stern@rowland.harvard.edu>, <m-sonasath@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] usb: gadget: composite: Allow function drivers to
 defer setup responses
References: <1303220033-5274-1-git-send-email-roger.quadros@nokia.com> <1303220033-5274-2-git-send-email-roger.quadros@nokia.com> <op.vt6vlrdf3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <op.vt6vlrdf3l0zgt@mnazarewicz-glaptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.21.36.144]
X-OriginalArrivalTime: 21 Apr 2011 13:27:48.0569 (UTC) FILETIME=[E829F490:01CC0027]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2011 05:23 PM, ext Michal Nazarewicz wrote:
> On Tue, 19 Apr 2011 15:33:52 +0200, Roger Quadros <roger.quadros@nokia.com> wrote:
>> @@ -895,6 +904,14 @@ composite_setup(struct usb_gadget *gadget, const struct
>> usb_ctrlrequest *ctrl)
>> if (w_value && !f->set_alt)
>> break;
>> value = f->set_alt(f, w_index, w_value);
>> + if (value == USB_GADGET_DELAYED_STATUS) {
>> + DBG(cdev,
>> + "%s: interface %d (%s) requested delayed status\n",
>> + __func__, intf, f->name);
>> + cdev->delayed_status++;
>
> Do we need it to be a counter? Won't simple flag do?

Counter because multiple interfaces could return USB_GADGET_DELAYED_STATUS
and we need to know how many of them call usb_composite_setup_continue() before 
we actually complete the control transfer.

>
>> + DBG(cdev, "delayed_status count %d\n",
>> + cdev->delayed_status);
>> + }
>> break;
>> case USB_REQ_GET_INTERFACE:
>> if (ctrl->bRequestType != (USB_DIR_IN|USB_RECIP_INTERFACE))
>
>> @@ -1289,3 +1310,41 @@ void usb_composite_unregister(struct
>> usb_composite_driver *driver)
>> return;
>> usb_gadget_unregister_driver(&composite_driver);
>> }
>> +
>> +/**
>> + * usb_composite_setup_continue() - Continue the delayed setup transfer
>> + * @cdev: the composite device who's setup transfer was delayed
>> + *
>> + * This function must be called by the USB function driver to continue
>> + * with the setup transfer's data/status phase in case it had requested to
>> + * delay the status phase. A USB function's setup handler (e.g. set_alt())
>> + * can request the composite framework to delay the setup request's status phase
>> + * by returning USB_GADGET_DELAYED_STATUS.
>> + */
>> +void usb_composite_setup_continue(struct usb_composite_dev *cdev)
>> +{
>> + int value;
>> + struct usb_request *req = cdev->req;
>> + unsigned long flags;
>> +
>> + DBG(cdev, "%s\n", __func__);
>> + spin_lock_irqsave(&cdev->lock, flags);
>> +
>> + if (cdev->delayed_status == 0) {
>> + WARN(cdev, "%s: Unexpected call\n", __func__);
>> +
>> + } else if (--cdev->delayed_status == 0) {
>> + DBG(cdev, "%s: Completing delayed status\n", __func__);
>> + req->length = 0;
>> + req->zero = 1;
>> + value = usb_ep_queue(cdev->gadget->ep0, req, GFP_ATOMIC);
>> + if (value < 0) {
>> + DBG(cdev, "ep_queue --> %d\n", value);
>> + req->status = 0;
>> + composite_setup_complete(cdev->gadget->ep0, req);
>> + }
>> + }Data/status stage.
>> +
>> + spin_unlock_irqrestore(&cdev->lock, flags);
>> +}
>
> It's just my opinion but I dislike how it looks almost identical to the end
> of composite_setup. I would rather make it more general (take value as
> argument for instance) and let composite_setup() call it.

Yes that could be done. I'll try to do so in the next iteration.

>
>> diff --git a/include/linux/usb/composite.h @@ -37,6 +37,15 @@
>> #include <linux/usb/ch9.h>
>> #include <linux/usb/gadget.h>
>> +/*
>> + * USB function drivers should return USB_GADGET_DELAYED_STATUS if they
>> + * wish to delay the status phase of the setup transfer till they are
>> + * ready. The composite framework will then delay the data/status phase
>> + * of the setup transfer till all the function drivers that requested for
>> + * USB_GADGET_DELAYED_STAUS, invoke usb_composite_setup_continue().
>> + *
>> + */
>> +#define USB_GADGET_DELAYED_STATUS 0x7fff /* Impossibly large value */
>
> I was wondering if we could change it to something like EDELAYED and put it to
> <include/linux/errno.h>. Just thinking, it may be a bad idea.
>

I would not do it.

Thanks for review.

-- 
regards,
-roger
