Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab0C2KwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 06:52:08 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:35145 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168Ab0C2KwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 06:52:07 -0400
Date: Mon, 29 Mar 2010 12:52:04 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Peter Korsgaard <jacmet@sunsite.dk>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] USB: gadget: f_mass_storage: per function descriptors copy
Message-ID: <20100329105204.GG29222@cmpxchg.org>
References: <01616584180153ae03d983b6971f5a1b8097419e.1269631274.git.mina86@mina86.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01616584180153ae03d983b6971f5a1b8097419e.1269631274.git.mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 12:18:43PM +0200, Michal Nazarewicz wrote:
> Mass Storage Function (MSF) used the same descriptors for each
> usb_function instance (meaning usb_function::descriptors of different
> functions pointed to the same static area (the same was true for
> usb_function::hs_descriptors)).
> 
> This would leads to problems if MSF were used in several USB
> configurations with different interface and/or endpoint numbers.
> Descriptors for all configurations would have interface/endpoint
> numbers overwritten by the values valid for the last configuration.
> 
> This patch adds code that copies the descriptors each time MSF is
> added to USB configuration (that is for each usb_function).
> 
> Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/usb/gadget/f_mass_storage.c |   32 ++++++++++++++++++++++++++------
>  1 files changed, 26 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
> index f4911c0..9fccdc3 100644
> --- a/drivers/usb/gadget/f_mass_storage.c
> +++ b/drivers/usb/gadget/f_mass_storage.c
> @@ -2906,6 +2906,8 @@ static void fsg_unbind(struct usb_configuration *c, struct usb_function *f)
>  
>  	DBG(fsg, "unbind\n");
>  	fsg_common_put(fsg->common);
> +	usb_free_descriptors(fsg->function.descriptors);
> +	usb_free_descriptors(fsg->function.hs_descriptors);
>  	kfree(fsg);
>  }
>  
> @@ -2946,7 +2948,13 @@ static int __init fsg_bind(struct usb_configuration *c, struct usb_function *f)
>  			fsg_fs_bulk_in_desc.bEndpointAddress;
>  		fsg_hs_bulk_out_desc.bEndpointAddress =
>  			fsg_fs_bulk_out_desc.bEndpointAddress;
> -		f->hs_descriptors = fsg_hs_function;
> +		f->hs_descriptors = usb_copy_descriptors(fsg_hs_function);
> +		/* We don't care if we could not copy the high speed
> +		 * descriptor.  If we are out of memory we'll stick to
> +		 * full speed only.  Ie. it is an error that we cannot
> +		 * copy hs descriptors but not a fatal one. */
> +		/* if (unlikely(!f->hs_descriptors))
> +			return -ENOMEM; */

I would much prefer to fail here and handle reloading a module in userspace
over having a gadget operate on varying speeds, depending on a transient
situation at module loading time that is not transparent to the user of an
embedded device in the field for example.
