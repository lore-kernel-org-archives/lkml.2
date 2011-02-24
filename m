Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab1BXLiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 06:38:00 -0500
Received: from webbox4.loswebos.de ([213.187.93.205]:49498 "EHLO
	webbox4.loswebos.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab1BXLh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 06:37:59 -0500
Date: Thu, 24 Feb 2011 12:37:56 +0100
From: Marc Koschewski <marc@osknowledge.org>
To: Chuanxiao Dong <chuanxiao.dong@intel.com>
Cc: linux-mmc@vger.kernel.org, cjb@laptop.org, adrian.hunter@nokia.com,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1]mmc: fix division by zero when calculate mmc erase
 time
Message-ID: <20110224113756.GB7260@marc.osknowledge.org>
References: <20110224111801.GA7169@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110224111801.GA7169@intel.com>
X-PGP-Fingerprint: D514 7DC1 B5F5 8989 083E 38C9 5ECF E5BD 3430 ABF5
X-PGP-Key: http://www.kosik.org/pubkey.asc
X-Blog: http://www.kosik.org/blog/
X-Operating-System: Linux marc 2.6.37-ck2-dezzy
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Chuanxiao Dong <chuanxiao.dong@intel.com> [2011-02-24 19:18:01 +0800]:

> Since if clock gating feature is enabled, the clock frequency may be zero when
> host clock is gated. In such scenario, mmc_set_mmc_erase_timeout() may have a
> division by zero bug.
> 
> So this patch used mmc_host_clk_rate() to fix this.
> 
> Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
> ---
>  drivers/mmc/core/core.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 34a7e8c..12d0eb8 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -1201,8 +1201,14 @@ static void mmc_set_mmc_erase_timeout(struct mmc_card *card,
>  		 * less but not that much less, so fudge it by multiplying by 2.
>  		 */
>  		timeout_clks <<= 1;
> -		timeout_us += (timeout_clks * 1000) /
> -			      (card->host->ios.clock / 1000);
> +
> +		/*
> +		 * at this moment, host controller maybe clock gated, so make
> +		 * sure we can get a correct host clock freq.
> +		 */
> +		if (mmc_host_clk_rate(card->host))
> +			timeout_us += (timeout_clks * 1000) /
> +				      (mmc_host_clk_rate(card->host) / 1000);

Why don't you just reuse mmc_host_clk_rate()'s result instead of calling it twice?

Cheers,
Marc

>  
>  		erase_timeout = timeout_us / 1000;
>  
> -- 
> 1.6.6.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

-- 
Marc Koschewski
