Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab2ABIox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 03:44:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42939 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab2ABIon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 03:44:43 -0500
Date: Mon, 2 Jan 2012 01:44:39 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Julia Lawall <julia@diku.dk>
Cc: kernel-janitors@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/6] drivers/gpio/gpio-tegra.c: use
 devm_request_and_ioremap
Message-ID: <20120102084439.GI18381@ponder.secretlab.ca>
References: <1324994491-21828-1-git-send-email-julia@diku.dk>
 <1324994491-21828-2-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324994491-21828-2-git-send-email-julia@diku.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 03:01:26PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>

Merged, thanks.

g.

> 
> Reimplement a call to devm_request_mem_region followed by a call to ioremap
> or ioremap_nocache by a call to devm_request_and_ioremap.
> 
> The semantic patch that makes this transformation is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @nm@
> expression myname;
> identifier i;
> @@
> 
> struct platform_driver i = { .driver = { .name = myname } };
> 
> @@
> expression dev,res,size;
> expression nm.myname;
> @@
> 
> -if (!devm_request_mem_region(dev, res->start, size,
> -                              \(res->name\|dev_name(dev)\|myname\))) {
> -   ...
> -   return ...;
> -}
> ... when != res->start
> (
> -devm_ioremap(dev,res->start,size)
> +devm_request_and_ioremap(dev,res)
> |
> -devm_ioremap_nocache(dev,res->start,size)
> +devm_request_and_ioremap(dev,res)
> )
> ... when any
>     when != res->start
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/gpio/gpio-tegra.c |    9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
> index 61044c8..bdc2937 100644
> --- a/drivers/gpio/gpio-tegra.c
> +++ b/drivers/gpio/gpio-tegra.c
> @@ -361,14 +361,7 @@ static int __devinit tegra_gpio_probe(struct platform_device *pdev)
>  		return -ENODEV;
>  	}
>  
> -	if (!devm_request_mem_region(&pdev->dev, res->start,
> -				     resource_size(res),
> -				     dev_name(&pdev->dev))) {
> -		dev_err(&pdev->dev, "Couldn't request MEM resource\n");
> -		return -ENODEV;
> -	}
> -
> -	regs = devm_ioremap(&pdev->dev, res->start, resource_size(res));
> +	regs = devm_request_and_ioremap(&pdev->dev, res);
>  	if (!regs) {
>  		dev_err(&pdev->dev, "Couldn't ioremap regs\n");
>  		return -ENODEV;
> 
