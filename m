Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771Ab1GKPBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 11:01:14 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53082 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757753Ab1GKPBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 11:01:13 -0400
Date: Mon, 11 Jul 2011 11:01:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jesper Juhl <jj@chaosbits.net>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Andiry Xu <andiry.xu@amd.com>, Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] USB: Avoid NULL pointer dereference in usb_disconnect()
In-Reply-To: <alpine.LNX.2.00.1107111119080.4462@swampdragon.chaosbits.net>
Message-ID: <Pine.LNX.4.44L0.1107111100230.2236-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jul 2011, Jesper Juhl wrote:

> If, in drivers/usb/core/hub.c::usb_disconnect(), 'udev' is NULL, then
> we'll never get to the printing of a debug message and returning from
> the function since we'll have already dereferenced the NULL pointer in
> the bus_to_hcd(udev->bus) call.
> This patch moves the dereference to after the test for NULL, thus
> avoiding that potential crash.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/usb/core/hub.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
>  disclaimer: compile tested only.
> 
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index a428aa0..0a98c76 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -1634,13 +1634,15 @@ void usb_disconnect(struct usb_device **pdev)
>  {
>  	struct usb_device	*udev = *pdev;
>  	int			i;
> -	struct usb_hcd		*hcd = bus_to_hcd(udev->bus);
> +	struct usb_hcd		*hcd;
>  
>  	if (!udev) {
>  		pr_debug ("%s nodev\n", __func__);
>  		return;
>  	}
>  
> +	hcd = bus_to_hcd(udev->bus);
> +
>  	/* mark the device as inactive, so any further urb submissions for
>  	 * this device (and any of its children) will fail immediately.
>  	 * this quiesces everything except pending urbs.

This is okay, but it might be better just to remove the NULL test 
entirely.  Code inspection easily shows that it can never be triggered.

Alan Stern

