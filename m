Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934103Ab2JLOZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 10:25:25 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45720 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932983Ab2JLOZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 10:25:24 -0400
Date: Fri, 12 Oct 2012 10:25:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Henrik Rydberg <rydberg@euromail.se>
cc: Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Peter Stuge <peter@stuge.se>
Subject: Re: REGRESSION: usbdevfs: Use-scatter-gather-lists-for-large-bulk-transfers
In-Reply-To: <20121011213707.GA2187@polaris.bitmath.org>
Message-ID: <Pine.LNX.4.44L0.1210121018390.1605-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2012, Henrik Rydberg wrote:

> From 40b70394747eea51fdd07cc8213dd6afd24b1b30 Mon Sep 17 00:00:00 2001
> From: Henrik Rydberg <rydberg@euromail.se>
> Date: Thu, 11 Oct 2012 23:27:04 +0200
> Subject: [PATCH] usbdevfs: Fix broken scatter-gather transfer
> 
> The recently introduced handling of large bulk transfers is completely
> broken; the same user page is read over and over again. Fixed with
> this patch.
> 
> Cc: stable@kernel.org
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/usb/core/devio.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
> index ebb8a9d..6e58b59 100644
> --- a/drivers/usb/core/devio.c
> +++ b/drivers/usb/core/devio.c
> @@ -1172,6 +1172,7 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
>  	struct usb_ctrlrequest *dr = NULL;
>  	unsigned int u, totlen, isofrmlen;
>  	int i, ret, is_in, num_sgs = 0, ifnum = -1;
> +	void __user *userbuf;
>  	void *buf;
>  
>  	if (uurb->flags & ~(USBDEVFS_URB_ISO_ASAP |
> @@ -1333,6 +1334,7 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
>  		as->urb->num_sgs = num_sgs;
>  		sg_init_table(as->urb->sg, as->urb->num_sgs);
>  
> +		userbuf = uurb->buffer;
>  		totlen = uurb->buffer_length;
>  		for (i = 0; i < as->urb->num_sgs; i++) {
>  			u = (totlen > USB_SG_SIZE) ? USB_SG_SIZE : totlen;
> @@ -1344,11 +1346,12 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
>  			sg_set_buf(&as->urb->sg[i], buf, u);
>  
>  			if (!is_in) {
> -				if (copy_from_user(buf, uurb->buffer, u)) {
> +				if (copy_from_user(buf, userbuf, u)) {
>  					ret = -EFAULT;
>  					goto error;
>  				}
>  			}
> +			userbuf += u;

Instead of introducing a new local variable, why not simply update 
uurb->buffer?  That's what we do elsewhere in the code.

Alan Stern

