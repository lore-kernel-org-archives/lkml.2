Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab0LGEnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 23:43:19 -0500
Received: from kroah.org ([198.145.64.141]:41168 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060Ab0LGEnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 23:43:04 -0500
Date: Mon, 6 Dec 2010 20:43:58 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bob Liu <lliubbo@gmail.com>, Mike Frysinger <vapier@gentoo.org>,
        Felipe Balbi <balbi@ti.com>, Hema Kalliguddi <hemahk@ti.com>
Subject: Re: linux-next: manual merge of the usb tree with Linus'  tree
Message-ID: <20101207044358.GB29457@kroah.com>
References: <20101206124718.12e49789.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101206124718.12e49789.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 06, 2010 at 12:47:18PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/musb/blackfin.c between commit
> 1e393c6eece048052d4131ec4dad3b98e35a98e2 ("USB: musb: blackfin: pm: make
> it work") from Linus' tree and commit
> ea65df57c2eea803535a071752efb030c46a11f5 ("usb: musb: remove board_data
> parameter from musb_platform_init()") from the usb tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Thanks.  Felipe, does this patch look correct?  I should probably merge
the next -rc release into my USB tree to handle this type of thing.

thanks,

greg k-h

> diff --cc drivers/usb/musb/blackfin.c
> index fcb5206,e8cbcc5..0000000
> --- a/drivers/usb/musb/blackfin.c
> +++ b/drivers/usb/musb/blackfin.c
> @@@ -360,33 -380,6 +360,33 @@@ static void musb_platform_reg_init(stru
>   				EP2_RX_ENA | EP3_RX_ENA | EP4_RX_ENA |
>   				EP5_RX_ENA | EP6_RX_ENA | EP7_RX_ENA);
>   	SSYNC();
>  +}
>  +
> - int __init musb_platform_init(struct musb *musb, void *board_data)
> ++int __init musb_platform_init(struct musb *musb)
>  +{
>  +
>  +	/*
>  +	 * Rev 1.0 BF549 EZ-KITs require PE7 to be high for both DEVICE
>  +	 * and OTG HOST modes, while rev 1.1 and greater require PE7 to
>  +	 * be low for DEVICE mode and high for HOST mode. We set it high
>  +	 * here because we are in host mode
>  +	 */
>  +
>  +	if (gpio_request(musb->config->gpio_vrsel, "USB_VRSEL")) {
>  +		printk(KERN_ERR "Failed ro request USB_VRSEL GPIO_%d\n",
>  +			musb->config->gpio_vrsel);
>  +		return -ENODEV;
>  +	}
>  +	gpio_direction_output(musb->config->gpio_vrsel, 0);
>  +
>  +	usb_nop_xceiv_register();
>  +	musb->xceiv = otg_get_transceiver();
>  +	if (!musb->xceiv) {
>  +		gpio_free(musb->config->gpio_vrsel);
>  +		return -ENODEV;
>  +	}
>  +
>  +	musb_platform_reg_init(musb);
>   
>   	if (is_host_enabled(musb)) {
>   		musb->board_set_vbus = bfin_set_vbus;
