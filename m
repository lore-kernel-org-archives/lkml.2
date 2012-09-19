Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab2ISFJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 01:09:37 -0400
Received: from void.printf.net ([89.145.121.20]:55370 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754646Ab2ISFJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 01:09:33 -0400
From: Chris Ball <cjb@laptop.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 7/13] drivers/mmc/host/mmci.c: use clk_prepare_enable and clk_disable_unprepare
References: <1345996865-32082-1-git-send-email-Julia.Lawall@lip6.fr>
	<1345996865-32082-8-git-send-email-Julia.Lawall@lip6.fr>
Date: Wed, 19 Sep 2012 01:09:54 -0400
In-Reply-To: <1345996865-32082-8-git-send-email-Julia.Lawall@lip6.fr> (Julia
	Lawall's message of "Sun, 26 Aug 2012 18:00:59 +0200")
Message-ID: <m3lig6k38d.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

On Sun, Aug 26 2012, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Clk_prepare_enable and clk_disable_unprepare combine clk_prepare and
> clk_enable, and clk_disable and clk_unprepare.  They make the code more
> concise, and ensure that clk_unprepare is called when clk_enable fails.
>
> A simplified version of the semantic patch that introduces calls to these
> functions is as follows: (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@
> expression e;
> @@
>
> - clk_prepare(e);
> - clk_enable(e);
> + clk_prepare_enable(e);
>
> @@
> expression e;
> @@
>
> - clk_disable(e);
> - clk_unprepare(e);
> + clk_disable_unprepare(e);
> // </smpl>
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> ---
>  drivers/mmc/host/mmci.c |   13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
> index 50ff19a..edc3e9b 100644
> --- a/drivers/mmc/host/mmci.c
> +++ b/drivers/mmc/host/mmci.c
> @@ -1309,14 +1309,10 @@ static int __devinit mmci_probe(struct amba_device *dev,
>  		goto host_free;
>  	}
>  
> -	ret = clk_prepare(host->clk);
> +	ret = clk_prepare_enable(host->clk);
>  	if (ret)
>  		goto clk_free;
>  
> -	ret = clk_enable(host->clk);
> -	if (ret)
> -		goto clk_unprep;
> -
>  	host->plat = plat;
>  	host->variant = variant;
>  	host->mclk = clk_get_rate(host->clk);
> @@ -1515,9 +1511,7 @@ static int __devinit mmci_probe(struct amba_device *dev,
>   err_gpio_cd:
>  	iounmap(host->base);
>   clk_disable:
> -	clk_disable(host->clk);
> - clk_unprep:
> -	clk_unprepare(host->clk);
> +	clk_disable_unprepare(host->clk);
>   clk_free:
>  	clk_put(host->clk);
>   host_free:
> @@ -1564,8 +1558,7 @@ static int __devexit mmci_remove(struct amba_device *dev)
>  			gpio_free(host->gpio_cd);
>  
>  		iounmap(host->base);
> -		clk_disable(host->clk);
> -		clk_unprepare(host->clk);
> +		clk_disable_unprepare(host->clk);
>  		clk_put(host->clk);
>  
>  		if (host->vcc)

Thanks, pushed to mmc-next for 3.7.

(I merged v1 instead of v2 because I don't see any whitespace problems
with it, and I liked the verbosity in the original commit message.)

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
