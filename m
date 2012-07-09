Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab2GIOe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:34:56 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38389 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752349Ab2GIOez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:34:55 -0400
Date: Mon, 9 Jul 2012 10:34:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Venu Byravarasu <vbyravarasu@nvidia.com>
cc: gregkh@linuxfoundation.org, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] usb: host: Fix possible kernel crash
In-Reply-To: <1341830784-24182-1-git-send-email-vbyravarasu@nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1207091028200.1954-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2012, Venu Byravarasu wrote:

> In functions itd_complete &  sitd_complete, a pointer
> by name stream may get dereferenced after freeing it, when
> iso_stream_put is called with stream->refcount = 2.

I don't understand the problem.  Did you actually see this happen or is 
it only theoretical?

> Hence fixing it.
> 
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> ---
> By mistake sent incorrect patch set number as v2 earlier.
> Hence fixing it.
> 
>  drivers/usb/host/ehci-sched.c |   16 ++++++++++------
>  1 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-sched.c b/drivers/usb/host/ehci-sched.c
> index 33182c6..20d0c38 100644
> --- a/drivers/usb/host/ehci-sched.c
> +++ b/drivers/usb/host/ehci-sched.c
> @@ -1715,6 +1715,7 @@ itd_complete (
>  	struct ehci_iso_stream			*stream = itd->stream;
>  	struct usb_device			*dev;
>  	unsigned				retval = false;
> +	u32					stream_ref_count = 0;
>  
>  	/* for each uframe with a packet */
>  	for (uframe = 0; uframe < 8; uframe++) {
> @@ -1783,7 +1784,8 @@ itd_complete (
>  			dev->devpath, stream->bEndpointAddress & 0x0f,
>  			(stream->bEndpointAddress & USB_DIR_IN) ? "in" : "out");
>  	}
> -	iso_stream_put (ehci, stream);
> +	stream_ref_count = stream->refcount;
> +	iso_stream_put(ehci, stream);

This iso_stream_put removes the reference held by the URB.  Before it 
is called, stream->refcount must be >= 3:

	refcount is set to 1 when the stream is created;

	each active URB holds a reference;

	each itd holds a reference.

So after the call, the refcount value must be >= 2 and the stream could 
not have been deallocated.

>  done:
>  	itd->urb = NULL;
> @@ -1797,7 +1799,7 @@ done:
>  		 * Move it to a safe place until a new frame starts.
>  		 */
>  		list_move(&itd->itd_list, &ehci->cached_itd_list);
> -		if (stream->refcount == 2) {
> +		if (stream_ref_count == 3) {

Therefore this seems unnecessary.

>  			/* If iso_stream_put() were called here, stream
>  			 * would be freed.  Instead, just prevent reuse.
>  			 */

Alan Stern

