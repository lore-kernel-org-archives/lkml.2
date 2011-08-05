Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab1HEIOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 04:14:51 -0400
Received: from trinity.fluff.org ([89.16.178.74]:56531 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377Ab1HEIOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 04:14:49 -0400
Date: Fri, 5 Aug 2011 09:14:44 +0100
From: Ben Dooks <ben-i2c@fluff.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Colin Cross <ccross@android.com>,
        John Bonesio <bones@secretlab.ca>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: tegra: Add CONFIG_OF guards for device tree bits
Message-ID: <20110805081444.GC19115@trinity.fluff.org>
References: <1312527921.21955.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312527921.21955.2.camel@phoenix>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 03:05:21PM +0800, Axel Lin wrote:
> The device tree bits need to be protected by CONFIG_OF guards.
> This patch fixes below build error with "make tegra_defconfig;make".
> 
>   CC      drivers/i2c/busses/i2c-tegra.o
> drivers/i2c/busses/i2c-tegra.c: In function 'tegra_i2c_probe':
> drivers/i2c/busses/i2c-tegra.c:615: error: implicit declaration of function 'of_get_property'
> drivers/i2c/busses/i2c-tegra.c:616: warning: assignment makes pointer from integer without a cast

It might be worth asking Grant if providing stubs for the of_ calls are
as good idea, I'd like to avoid having #ifdef CONFIG_OF splattered around
the place (it leads to errors).

> make[3]: *** [drivers/i2c/busses/i2c-tegra.o] Error 1
> make[2]: *** [drivers/i2c/busses] Error 2
> make[1]: *** [drivers/i2c] Error 2
> make: *** [drivers] Error 2
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/i2c/busses/i2c-tegra.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
> index 0c6e840..1bfe85e 100644
> --- a/drivers/i2c/busses/i2c-tegra.c
> +++ b/drivers/i2c/busses/i2c-tegra.c
> @@ -548,7 +548,6 @@ static int tegra_i2c_probe(struct platform_device *pdev)
>  	struct resource *iomem;
>  	struct clk *clk;
>  	struct clk *i2c_clk;
> -	const unsigned int *prop;
>  	void *base;
>  	int irq;
>  	int ret = 0;
> @@ -611,11 +610,15 @@ static int tegra_i2c_probe(struct platform_device *pdev)
>  	if (pdata) {
>  		i2c_dev->bus_clk_rate = pdata->bus_clk_rate;
>  
> +#ifdef CONFIG_OF
>  	} else if (i2c_dev->dev->of_node) {    /* if there is a device tree node ... */
> +		const unsigned int *prop;
> +
>  		prop = of_get_property(i2c_dev->dev->of_node,
>  				"clock-frequency", NULL);
>  		if (prop)
>  			i2c_dev->bus_clk_rate = be32_to_cpup(prop);
> +#endif
>  	}
>  
>  	if (pdev->id == 3)
> -- 
> 1.7.4.1
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/

Large Hadron Colada: A large Pina Colada that makes the universe disappear.

