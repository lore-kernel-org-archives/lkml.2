Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab0HaOQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 10:16:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43734 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932128Ab0HaOQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 10:16:30 -0400
Date: Tue, 31 Aug 2010 10:16:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Simon Arlott <simon@fire.lp0.eu>
cc: Greg KH <greg@kroah.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] USB: output an error message when the pipe type doesn't
 match the endpoint type
In-Reply-To: <4C7C279C.507@simon.arlott.org.uk>
Message-ID: <Pine.LNX.4.44L0.1008311014330.1538-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Aug 2010, Simon Arlott wrote:

> Commit f661c6f8c67bd55e93348f160d590ff9edf08904 adds a check of the pipe type if
> CONFIG_USB_DEBUG is enabled, but it doesn't output anything if this scenario
> occurs.
> 
> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> ---
>  drivers/usb/core/urb.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/core/urb.c b/drivers/usb/core/urb.c
> index 419e6b3..c14fc08 100644
> --- a/drivers/usb/core/urb.c
> +++ b/drivers/usb/core/urb.c
> @@ -401,8 +401,11 @@ int usb_submit_urb(struct urb *urb, gfp_t mem_flags)
>  	};
>  
>  	/* Check that the pipe's type matches the endpoint's type */
> -	if (usb_pipetype(urb->pipe) != pipetypes[xfertype])
> +	if (usb_pipetype(urb->pipe) != pipetypes[xfertype]) {
> +		dev_err(&dev->dev, "BOGUS urb xfer, pipe %x != type %x\n",
> +			usb_pipetype(urb->pipe), pipetypes[xfertype]);
>  		return -EPIPE;		/* The most suitable error code :-) */
> +	}
>  
>  	/* enforce simple/standard policy */
>  	allowed = (URB_NO_TRANSFER_DMA_MAP | URB_NO_INTERRUPT | URB_DIR_MASK |

This is okay with me.  If you're serious about not changing the
behavior merely because debugging is enabled, you could move this test
out of the debug-only region and possibly change the dev_err to
dev_dbg.  However doing so might break some devices that are currently
working.

Alan Stern

