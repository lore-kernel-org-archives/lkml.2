Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab1DJPJM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 11:09:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:55193 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764Ab1DJPJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 11:09:09 -0400
Date: Sun, 10 Apr 2011 08:09:06 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, linux-arm-msm@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: Re: [trivial PATCH 1/2] treewide: Fix iomap resource size
 miscalculations
In-Reply-To: <c4422b4a8ee132d3adac95fd86237c61b2f8b364.1300909446.git.joe@perches.com>
Message-ID: <alpine.LNX.2.00.1104081939360.6392@deuxcents.site>
References: <cover.1300909445.git.joe@perches.com> <c4422b4a8ee132d3adac95fd86237c61b2f8b364.1300909446.git.joe@perches.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Mar 2011, Joe Perches wrote:

> Convert off-by-1 r->end - r->start to resource_size(r)
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/arm/mach-ux500/mbox-db5500.c |    6 ++----
>  arch/mips/rb532/gpio.c            |    2 +-
>  drivers/video/msm/mddi.c          |    2 +-
>  drivers/watchdog/bcm63xx_wdt.c    |    2 +-
>  4 files changed, 5 insertions(+), 7 deletions(-)

Applied, thanks

> 
> diff --git a/arch/arm/mach-ux500/mbox-db5500.c b/arch/arm/mach-ux500/mbox-db5500.c
> index a4ffb9f..2b2d51c 100644
> --- a/arch/arm/mach-ux500/mbox-db5500.c
> +++ b/arch/arm/mach-ux500/mbox-db5500.c
> @@ -416,8 +416,7 @@ struct mbox *mbox_setup(u8 mbox_id, mbox_recv_cb_t *mbox_cb, void *priv)
>  	dev_dbg(&(mbox->pdev->dev),
>  		"Resource name: %s start: 0x%X, end: 0x%X\n",
>  		resource->name, resource->start, resource->end);
> -	mbox->virtbase_peer =
> -		ioremap(resource->start, resource->end - resource->start);
> +	mbox->virtbase_peer = ioremap(resource->start, resource_size(resource));
>  	if (!mbox->virtbase_peer) {
>  		dev_err(&(mbox->pdev->dev), "Unable to ioremap peer mbox\n");
>  		mbox = NULL;
> @@ -440,8 +439,7 @@ struct mbox *mbox_setup(u8 mbox_id, mbox_recv_cb_t *mbox_cb, void *priv)
>  	dev_dbg(&(mbox->pdev->dev),
>  		"Resource name: %s start: 0x%X, end: 0x%X\n",
>  		resource->name, resource->start, resource->end);
> -	mbox->virtbase_local =
> -		ioremap(resource->start, resource->end - resource->start);
> +	mbox->virtbase_local = ioremap(resource->start, resource_size(resource));
>  	if (!mbox->virtbase_local) {
>  		dev_err(&(mbox->pdev->dev), "Unable to ioremap local mbox\n");
>  		mbox = NULL;
> diff --git a/arch/mips/rb532/gpio.c b/arch/mips/rb532/gpio.c
> index 37de05d..6c47dfe 100644
> --- a/arch/mips/rb532/gpio.c
> +++ b/arch/mips/rb532/gpio.c
> @@ -185,7 +185,7 @@ int __init rb532_gpio_init(void)
>  	struct resource *r;
>  
>  	r = rb532_gpio_reg0_res;
> -	rb532_gpio_chip->regbase = ioremap_nocache(r->start, r->end - r->start);
> +	rb532_gpio_chip->regbase = ioremap_nocache(r->start, resource_size(r));
>  
>  	if (!rb532_gpio_chip->regbase) {
>  		printk(KERN_ERR "rb532: cannot remap GPIO register 0\n");
> diff --git a/drivers/video/msm/mddi.c b/drivers/video/msm/mddi.c
> index b66d86a..178b072 100644
> --- a/drivers/video/msm/mddi.c
> +++ b/drivers/video/msm/mddi.c
> @@ -679,7 +679,7 @@ static int __devinit mddi_probe(struct platform_device *pdev)
>  		printk(KERN_ERR "mddi: no associated mem resource!\n");
>  		return -ENOMEM;
>  	}
> -	mddi->base = ioremap(resource->start, resource->end - resource->start);
> +	mddi->base = ioremap(resource->start, resource_size(resource));
>  	if (!mddi->base) {
>  		printk(KERN_ERR "mddi: failed to remap base!\n");
>  		ret = -EINVAL;
> diff --git a/drivers/watchdog/bcm63xx_wdt.c b/drivers/watchdog/bcm63xx_wdt.c
> index 3c5045a..5064e83 100644
> --- a/drivers/watchdog/bcm63xx_wdt.c
> +++ b/drivers/watchdog/bcm63xx_wdt.c
> @@ -248,7 +248,7 @@ static int __devinit bcm63xx_wdt_probe(struct platform_device *pdev)
>  		return -ENODEV;
>  	}
>  
> -	bcm63xx_wdt_device.regs = ioremap_nocache(r->start, r->end - r->start);
> +	bcm63xx_wdt_device.regs = ioremap_nocache(r->start, resource_size(r));
>  	if (!bcm63xx_wdt_device.regs) {
>  		dev_err(&pdev->dev, "failed to remap I/O resources\n");
>  		return -ENXIO;
> -- 
> 1.7.4.2.g597a6.dirty
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

