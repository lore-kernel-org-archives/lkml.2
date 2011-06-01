Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274Ab1FARUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:20:22 -0400
Received: from waste.org ([173.11.57.241]:41951 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758056Ab1FARUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:20:21 -0400
Subject: Re: [PATCH 1/10] drivers/char/hw_random/omap-rng.c: add missing
 clk_put
From: Matt Mackall <mpm@selenic.com>
To: Julia Lawall <julia@diku.dk>
Cc: Deepak Saxena <dsaxena@plexity.net>, kernel-janitors@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1306948213-20767-1-git-send-email-julia@diku.dk>
References: <1306948213-20767-1-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 12:20:14 -0500
Message-ID: <1306948814.4204.572.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-01 at 19:10 +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Convert a return to a jump to an existing label that calls clk_put.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r exists@
> expression e1,e2;
> statement S;
> @@
> 
> e1 = clk_get@p1(...);
> ... when != e1 = e2
>     when != clk_put(e1)
>     when any
> if (...) { ... when != clk_put(e1)
>                when != if (...) { ... clk_put(e1) ... }
> * return@p3 ...;
>  } else S
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

That's impressive.

Signed-off-by: Matt Mackall <mpm@selenic.com>

> ---
>  drivers/char/hw_random/omap-rng.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
> index 2cc755a..b757fac 100644
> --- a/drivers/char/hw_random/omap-rng.c
> +++ b/drivers/char/hw_random/omap-rng.c
> @@ -113,8 +113,10 @@ static int __devinit omap_rng_probe(struct platform_device *pdev)
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  
> -	if (!res)
> -		return -ENOENT;
> +	if (!res) {
> +		ret = -ENOENT;
> +		goto err_region;
> +	}
>  
>  	if (!request_mem_region(res->start, resource_size(res), pdev->name)) {
>  		ret = -EBUSY;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Mathematics is the supreme nostalgia of our time.


