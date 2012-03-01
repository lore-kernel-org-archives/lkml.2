Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966175Ab2CAM3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 07:29:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:65175 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759034Ab2CAM3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 07:29:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the arm-soc tree with the gpio tree
Date: Thu, 1 Mar 2012 12:28:33 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>
References: <20120301164001.77a063ceed2deaf37cf68e3c@canb.auug.org.au>
In-Reply-To: <20120301164001.77a063ceed2deaf37cf68e3c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203011228.33983.arnd@arndb.de>
X-Provags-ID: V02:K0:JcdIe00o2CH9g/EbXzTEjpDacQX5heWU8NhJHCre7FX
 QwSe6uarwxCUJbkn9nX/84/AyUMgjOpN0GZstWDkN3mbfR0+xF
 7IRIlb4JWlycJsPLXpdLSFy6FjtEgEnpTuLXeqv5szgrxXFdo6
 HzFlfMJLBZq/iiJkw9+wGMfy517REA14SUcZurP9ORIUVtX5IY
 /lQ84qTEGbO+jF2IP7H4k8upvN/Q9HJZea4rqLhvoeF+iHQ22Z
 yW5Bn2Pdpk4fGad3SZrPZD0UDZezAPbyQ5g4aNLYYOMcYYFpAC
 tF3CRW0errMV54jRrYxFaQbAywHnnu26dNFefuWTIt+TNtFhV4
 1Fh6wqoCk/4rFM/ZEEW0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 March 2012, Stephen Rothwell wrote:
> Today's linux-next merge of the arm-soc tree got conflicts in
> arch/arm/mach-omap1/gpio16xx.c between commit ab985f0f7c2c ("gpio/omap:
> cleanup omap_gpio_mod_init function") from the gpio tree and commit
> 63325ff235de ("ARM: OMAP1: Move 16xx GPIO system clock to platform init
> code") from the arm-soc tree.
> 
> OK, I can't decide which is correct here - the former adds this code
> inside the loop (even though it seems to not depend on anything in the
> loop) and the latter adds it before.  I have used the former (but am
> happy to be corrected).  And both commits remove the code in
> drivers/gpio/gpio-omap.c.

Right, having the code outside of the loop seems correct to me, too.

Grant, I would suggest that I resolve this by merging the the
omap/gpio/runtime-pm-cleanup branch (f86bcc3) that is in your
tree into the arm-soc tree as a dependency for the omap1 stuff,
with the resolution below.

	Arnd

--- a/arch/arm/mach-omap1/gpio16xx.c
+++ b/arch/arm/mach-omap1/gpio16xx.c
@@@ -218,17 -225,34 +225,34 @@@ static int __init omap16xx_gpio_init(vo
  	if (!cpu_is_omap16xx())
  		return -EINVAL;
  
 +	/*
 +	 * Enable system clock for GPIO module.
 +	 * The CAM_CLK_CTRL *is* really the right place.
 +	 */
 +	omap_writel(omap_readl(ULPD_CAM_CLK_CTRL) | 0x04,
 +					ULPD_CAM_CLK_CTRL);
 +
- 	for (i = 0; i < ARRAY_SIZE(omap16xx_gpio_dev); i++)
- 		platform_device_register(omap16xx_gpio_dev[i]);
+ 	for (i = 0; i < ARRAY_SIZE(omap16xx_gpio_dev); i++) {
+ 		pdev = omap16xx_gpio_dev[i];
+ 		pdata = pdev->dev.platform_data;
+ 
+ 		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+ 		if (unlikely(!res)) {
+ 			dev_err(&pdev->dev, "Invalid mem resource.\n");
+ 			return -ENODEV;
+ 		}
  
- 	gpio_bank_count = ARRAY_SIZE(omap16xx_gpio_dev);
+ 		base = ioremap(res->start, resource_size(res));
+ 		if (unlikely(!base)) {
+ 			dev_err(&pdev->dev, "ioremap failed.\n");
+ 			return -ENOMEM;
+ 		}
+ 
+ 		__raw_writel(SYSCONFIG_WORD, base + OMAP1610_GPIO_SYSCONFIG);
+ 		iounmap(base);
+ 
 -		/*
 -		 * Enable system clock for GPIO module.
 -		 * The CAM_CLK_CTRL *is* really the right place.
 -		 */
 -		omap_writel(omap_readl(ULPD_CAM_CLK_CTRL) | 0x04,
 -					ULPD_CAM_CLK_CTRL);
 -
+ 		platform_device_register(omap16xx_gpio_dev[i]);
+ 	}
  
  	return 0;
  }
