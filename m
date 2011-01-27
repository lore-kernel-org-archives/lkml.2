Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab1A0Q12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 11:27:28 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:40667 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751375Ab1A0Q10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 11:27:26 -0500
Date: Thu, 27 Jan 2011 11:27:25 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tatyana Brokhman <tlinder@codeaurora.org>
cc: gregkh@suse.de, <linux-arm-msm@vger.kernel.org>,
        "open list:USB GADGET/PERIPH..." <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 1/5] usb: Adding SuperSpeed support to dummy_hcd
In-Reply-To: <1296133918-31099-1-git-send-email-tlinder@codeaurora.org>
Message-ID: <Pine.LNX.4.44L0.1101271116470.2090-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011, Tatyana Brokhman wrote:

> This patch adds SS support to the dummy hcd module. It may be used to test
> SS device when no (SS) HW is available.
> USB 3.0 hub includes 2 hubs - HS and SS ones.
> This patch adds support for a SS hub in the dummy_hcd module. Thus, when
> dummy_hcd enabled it will register 2 root hubs (SS and HS).

Getting there.  A few spots could still use some attention.

Also, you might try running this patch through checkpatch.pl and fixing 
any complaints it makes.


> @@ -343,7 +431,13 @@ dummy_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
>  	dum = ep_to_dummy (ep);
>  	if (!dum->driver || !is_enabled (dum))
>  		return -ESHUTDOWN;
> -	max = le16_to_cpu(desc->wMaxPacketSize) & 0x3ff;
> +	max = le16_to_cpu(desc->wMaxPacketSize) ;
> +	/*
> +	 * For HS/FS devices only bits 0..9 of the wMaxPacketSize represent the
> +	 * maximum packet size
> +	 */
> +	if (dum->gadget.speed < USB_SPEED_SUPER)
> +		max &= 0x3ff;

Strictly speaking, both the old and the new code are wrong.  For all
devices, regardless of speed, we should say:

	max = le16_to_cpu(desc->wMaxPacketSize) & 0x7ff;

In other words, the speed is contained in bits 0..10 (not 0..9).


> @@ -1352,6 +1559,10 @@ static void dummy_timer (unsigned long _dum)
>  	case USB_SPEED_HIGH:
>  		total = 512/*bytes*/ * 13/*packets*/ * 8/*uframes*/;
>  		break;
> +	case USB_SPEED_SUPER:
> +		/* 400MBps = 400*(2^20)/1000 bytes per milisec */
> +		total = (400 << 20) / 1000;
> +		break;

Ugh.  For one thing, SuperSpeed runs at 500 million bytes/s, not 400
million.  For another, 400 << 20 isn't equal to 400 million.

Don't try to be too clever.  Realizing that this is only an 
approximation anyway, just say:

		/* Bus speed is 500000 bytes/ms, so use a little less */
		total = 490000;

Alan Stern

