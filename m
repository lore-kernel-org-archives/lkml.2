Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964930Ab2CAUPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:15:31 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:29654 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757405Ab2CAUP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:15:26 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/AFkCnsIEH5k+xS+2Awz6X
Date: Thu, 1 Mar 2012 12:15:18 -0800
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: linux-next: manual merge of the arm-soc tree with the gpio tree
Message-ID: <20120301201518.GB18901@atomide.com>
References: <20120301164001.77a063ceed2deaf37cf68e3c@canb.auug.org.au>
 <201203011228.33983.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201203011228.33983.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [120301 03:57]:
> On Thursday 01 March 2012, Stephen Rothwell wrote:
> > Today's linux-next merge of the arm-soc tree got conflicts in
> > arch/arm/mach-omap1/gpio16xx.c between commit ab985f0f7c2c ("gpio/omap:
> > cleanup omap_gpio_mod_init function") from the gpio tree and commit
> > 63325ff235de ("ARM: OMAP1: Move 16xx GPIO system clock to platform init
> > code") from the arm-soc tree.
> > 
> > OK, I can't decide which is correct here - the former adds this code
> > inside the loop (even though it seems to not depend on anything in the
> > loop) and the latter adds it before.  I have used the former (but am
> > happy to be corrected).  And both commits remove the code in
> > drivers/gpio/gpio-omap.c.
> 
> Right, having the code outside of the loop seems correct to me, too.
> 
> Grant, I would suggest that I resolve this by merging the the
> omap/gpio/runtime-pm-cleanup branch (f86bcc3) that is in your
> tree into the arm-soc tree as a dependency for the omap1 stuff,
> with the resolution below.

For gpio16xx.c the resolution is to use the version from ab985f0f7c2c,
so below looks good to me.

Regards,

Tony


> --- a/arch/arm/mach-omap1/gpio16xx.c
> +++ b/arch/arm/mach-omap1/gpio16xx.c
> @@@ -218,17 -225,34 +225,34 @@@ static int __init omap16xx_gpio_init(vo
>   	if (!cpu_is_omap16xx())
>   		return -EINVAL;
>   
>  +	/*
>  +	 * Enable system clock for GPIO module.
>  +	 * The CAM_CLK_CTRL *is* really the right place.
>  +	 */
>  +	omap_writel(omap_readl(ULPD_CAM_CLK_CTRL) | 0x04,
>  +					ULPD_CAM_CLK_CTRL);
>  +
> - 	for (i = 0; i < ARRAY_SIZE(omap16xx_gpio_dev); i++)
> - 		platform_device_register(omap16xx_gpio_dev[i]);
> + 	for (i = 0; i < ARRAY_SIZE(omap16xx_gpio_dev); i++) {
> + 		pdev = omap16xx_gpio_dev[i];
> + 		pdata = pdev->dev.platform_data;
> + 
> + 		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> + 		if (unlikely(!res)) {
> + 			dev_err(&pdev->dev, "Invalid mem resource.\n");
> + 			return -ENODEV;
> + 		}
>   
> - 	gpio_bank_count = ARRAY_SIZE(omap16xx_gpio_dev);
> + 		base = ioremap(res->start, resource_size(res));
> + 		if (unlikely(!base)) {
> + 			dev_err(&pdev->dev, "ioremap failed.\n");
> + 			return -ENOMEM;
> + 		}
> + 
> + 		__raw_writel(SYSCONFIG_WORD, base + OMAP1610_GPIO_SYSCONFIG);
> + 		iounmap(base);
> + 
>  -		/*
>  -		 * Enable system clock for GPIO module.
>  -		 * The CAM_CLK_CTRL *is* really the right place.
>  -		 */
>  -		omap_writel(omap_readl(ULPD_CAM_CLK_CTRL) | 0x04,
>  -					ULPD_CAM_CLK_CTRL);
>  -
> + 		platform_device_register(omap16xx_gpio_dev[i]);
> + 	}
>   
>   	return 0;
>   }
