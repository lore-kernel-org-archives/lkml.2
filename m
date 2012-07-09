Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab2GIHmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 03:42:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50409 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab2GIHmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 03:42:08 -0400
Date: Mon, 9 Jul 2012 09:41:58 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hw_random: mxc-rnga: Adapt clocks to new i.mx clock
 framework
Message-ID: <20120709074158.GS30009@pengutronix.de>
References: <1341606020-26449-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341606020-26449-1-git-send-email-fabio.estevam@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:36:53 up 15 days, 22:48, 42 users,  load average: 0.23, 0.48,
 0.59
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 05:20:19PM -0300, Fabio Estevam wrote:
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Herbert Xu <herbert@gondor.apana.org.au> 
> Cc: <linux-kernel@vger.kernel.org>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/char/hw_random/mxc-rnga.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/char/hw_random/mxc-rnga.c b/drivers/char/hw_random/mxc-rnga.c
> index 85074de..c49c0b8 100644
> --- a/drivers/char/hw_random/mxc-rnga.c
> +++ b/drivers/char/hw_random/mxc-rnga.c
> @@ -152,14 +152,14 @@ static int __init mxc_rnga_probe(struct platform_device *pdev)
>  	if (rng_dev)
>  		return -EBUSY;
>  
> -	clk = clk_get(&pdev->dev, "rng");
> +	clk = clk_get(&pdev->dev, NULL);
>  	if (IS_ERR(clk)) {
>  		dev_err(&pdev->dev, "Could not get rng_clk!\n");
>  		err = PTR_ERR(clk);
>  		goto out;
>  	}
>  
> -	clk_enable(clk);
> +	clk_prepare_enable(clk);
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!res) {
> @@ -201,7 +201,7 @@ err_ioremap:
>  	release_mem_region(res->start, resource_size(res));
>  
>  err_region:
> -	clk_disable(clk);
> +	clk_disable_unprepare(clk);
>  	clk_put(clk);
>  
>  out:
> @@ -212,7 +212,7 @@ static int __exit mxc_rnga_remove(struct platform_device *pdev)
>  {
>  	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	void __iomem *rng_base = (void __iomem *)mxc_rnga.priv;
> -	struct clk *clk = clk_get(&pdev->dev, "rng");
> +	struct clk *clk = clk_get(&pdev->dev, NULL);

Uhh, that's a driver bug that should be fixed. Although right now there
is no reference counting for clocks, the driver should keep the clk
internally instead of simply calling clk_get whenever it needs access to
a clk.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
