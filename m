Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab1BGH7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 02:59:41 -0500
Received: from adelie.canonical.com ([91.189.90.139]:45329 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab1BGH7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 02:59:38 -0500
Date: Mon, 7 Feb 2011 09:59:33 +0200
From: Amit Kucheria <amit.kucheria@canonical.com>
To: Julia Lawall <julia@diku.dk>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, kernel-janitors@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/w1/masters/omap_hdq.c: Add missing clk_put
Message-ID: <20110207075933.GA2723@matterhorn.lan>
Mail-Followup-To: Julia Lawall <julia@diku.dk>,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	kernel-janitors@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
References: <1296754667-18049-1-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1296754667-18049-1-git-send-email-julia@diku.dk>
X-URL: http://www.verdurent.com/
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 Feb 03, Julia Lawall wrote:
> This code makes two calls to clk_get, then test both return values
> and fails if either failed.  The problem is that in the first inner if,
> where the first call to clk_get has failed, it don't know if the second
> call has failed as well.  So it don't know whether clk_get should be called
> on the result of the second call.  Of course, it would be possible to test
> that value again.  A simpler solution is just to test the result of calling
> clk_get directly after each call.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r@
> position p1,p2;
> expression e;
> statement S;
> @@
> 
> e = clk_get@p1(...)
> ...
> if@p2 (IS_ERR(e)) S
> 
> @@
> expression e;
> statement S;
> identifier l;
> position r.p1, p2 != r.p2;
> @@
> 
> *e = clk_get@p1(...)
> ... when != clk_put(e)
> *if@p2 (...)
> {
>   ... when != clk_put(e)
> * return ...;
> }// </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Makes the code easier to read.

Acked-by: Amit Kucheria <amit.kucheria@canonical.com>

> ---
>  drivers/w1/masters/omap_hdq.c |   28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/w1/masters/omap_hdq.c b/drivers/w1/masters/omap_hdq.c
> index 3a7e9ff..38e96ab 100644
> --- a/drivers/w1/masters/omap_hdq.c
> +++ b/drivers/w1/masters/omap_hdq.c
> @@ -593,19 +593,17 @@ static int __devinit omap_hdq_probe(struct platform_device *pdev)
>  
>  	/* get interface & functional clock objects */
>  	hdq_data->hdq_ick = clk_get(&pdev->dev, "ick");
> -	hdq_data->hdq_fck = clk_get(&pdev->dev, "fck");
> +	if (IS_ERR(hdq_data->hdq_ick)) {
> +		dev_dbg(&pdev->dev, "Can't get HDQ ick clock object\n");
> +		ret = PTR_ERR(hdq_data->hdq_ick);
> +		goto err_ick;
> +	}
>  
> -	if (IS_ERR(hdq_data->hdq_ick) || IS_ERR(hdq_data->hdq_fck)) {
> -		dev_dbg(&pdev->dev, "Can't get HDQ clock objects\n");
> -		if (IS_ERR(hdq_data->hdq_ick)) {
> -			ret = PTR_ERR(hdq_data->hdq_ick);
> -			goto err_clk;
> -		}
> -		if (IS_ERR(hdq_data->hdq_fck)) {
> -			ret = PTR_ERR(hdq_data->hdq_fck);
> -			clk_put(hdq_data->hdq_ick);
> -			goto err_clk;
> -		}
> +	hdq_data->hdq_fck = clk_get(&pdev->dev, "fck");
> +	if (IS_ERR(hdq_data->hdq_fck)) {
> +		dev_dbg(&pdev->dev, "Can't get HDQ fck clock object\n");
> +		ret = PTR_ERR(hdq_data->hdq_fck);
> +		goto err_fck;
>  	}
>  
>  	hdq_data->hdq_usecount = 0;
> @@ -665,10 +663,12 @@ err_fnclk:
>  	clk_disable(hdq_data->hdq_ick);
>  
>  err_intfclk:
> -	clk_put(hdq_data->hdq_ick);
>  	clk_put(hdq_data->hdq_fck);
>  
> -err_clk:
> +err_fck:
> +	clk_put(hdq_data->hdq_ick);
> +
> +err_ick:
>  	iounmap(hdq_data->hdq_base);
>  
>  err_ioremap:
> 

-- 
----------------------------------------------------------------------
Amit Kucheria, Kernel Engineer || amit.kucheria@canonical.com
----------------------------------------------------------------------
