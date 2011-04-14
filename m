Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759158Ab1DNRj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:39:57 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52781 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758856Ab1DNRjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:39:55 -0400
Date: Thu, 14 Apr 2011 13:39:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tatyana Brokhman <tlinder@codeaurora.org>
cc: gregkh@suse.de, <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        <balbi@ti.com>, Maya Erez <merez@codeaurora.org>,
        "open list:USB GADGET/PERIPH..." <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH v6 1/5] usb: Add streams support to the gadget
 framework
In-Reply-To: <1302788149-27926-1-git-send-email-tlinder@codeaurora.org>
Message-ID: <Pine.LNX.4.44L0.1104141331410.2487-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Apr 2011, Tatyana Brokhman wrote:

> This patch defines necessary fields to support streaming for USB3.0.
> It implements a new function (usb_ep_autoconfig_ss) to be used instead of
> the existing usb_ep_autoconfig when working in SS mode and there is a
> need to search for an endpoint according to the number of required
> streams.

Suggestions for some small improvements...

> --- a/include/linux/usb/gadget.h
> +++ b/include/linux/usb/gadget.h
> @@ -34,6 +34,8 @@ struct usb_ep;
>   *     by adding a zero length packet as needed;
>   * @short_not_ok: When reading data, makes short packets be
>   *     treated as errors (queue stops advancing till cleanup).
> + * @reserved: reserved bits
> + * @stream_id: the stream id

If you move stream_id to the start of the bitfields then you won't need 
to reserve any bits.

Also, the comment should explain a little more.  For example:

 * @stream_id: The stream id, when USB-3.0 bulk streams are being used.

> @@ -131,6 +136,8 @@ struct usb_ep_ops {
>   * @maxpacket:The maximum packet size used on this endpoint.  The initial
>   *	value can sometimes be reduced (hardware allowing), according to
>   *      the endpoint descriptor used to configure the endpoint.
> + * @num_supported_strms:The number of maximum streams supported
> + *	by this EP (0 - 16, actual number is 2^n)

Ugh!  Call this max_streams instead.  The comment should say "maximum 
number of streams", not "number of maximum streams".

>   * @mult: multiplier, 'mult' value for SS Isoc EPs
>   * @maxburst: the maximum number of bursts supported by this EP (for usb3)
>   * @driver_data:for use by the gadget driver.
> @@ -152,6 +159,7 @@ struct usb_ep {
>  	const struct usb_ep_ops	*ops;
>  	struct list_head	ep_list;
>  	unsigned		maxpacket:16;
> +	int			num_supported_strms;

You might also want to make this a 16-bit unsigned field, instead of 
sticking an integer between two bitfields.

>  	unsigned				mult:2;
>  	unsigned				pad:1;
>  	unsigned				maxburst:4;

Alan Stern

