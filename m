Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286Ab1FARUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:20:50 -0400
Received: from waste.org ([173.11.57.241]:42073 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758537Ab1FARUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:20:49 -0400
Subject: Re: [PATCH 6/10] drivers/char/hw_random/nomadik-rng.c: add missing
 clk_put
From: Matt Mackall <mpm@selenic.com>
To: Julia Lawall <julia@diku.dk>
Cc: kernel-janitors@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1306948213-20767-6-git-send-email-julia@diku.dk>
References: <1306948213-20767-6-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 12:20:46 -0500
Message-ID: <1306948846.4204.573.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-01 at 19:10 +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Jump to the end of the function for the clk_disable and clk_put rather than
> returning directly.
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

This one also looks good to me.

Signed-off-by: Matt Mackall <mpm@selenic.com>

> ---
>  drivers/char/hw_random/nomadik-rng.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/hw_random/nomadik-rng.c b/drivers/char/hw_random/nomadik-rng.c
> index dd1d143..52e08ca 100644
> --- a/drivers/char/hw_random/nomadik-rng.c
> +++ b/drivers/char/hw_random/nomadik-rng.c
> @@ -55,7 +55,7 @@ static int nmk_rng_probe(struct amba_device *dev, const struct amba_id *id)
>  
>  	ret = amba_request_regions(dev, dev->dev.init_name);
>  	if (ret)
> -		return ret;
> +		goto out_clk;
>  	ret = -ENOMEM;
>  	base = ioremap(dev->res.start, resource_size(&dev->res));
>  	if (!base)
> @@ -70,6 +70,7 @@ out_unmap:
>  	iounmap(base);
>  out_release:
>  	amba_release_regions(dev);
> +out_clk:
>  	clk_disable(rng_clk);
>  	clk_put(rng_clk);
>  	return ret;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Mathematics is the supreme nostalgia of our time.


