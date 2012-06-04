Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab2FDINA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 04:13:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:6785 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753838Ab2FDIM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 04:12:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="151216387"
Message-ID: <4FCC6E14.4010603@intel.com>
Date: Mon, 04 Jun 2012 11:13:08 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Torne (Richard Coles)" <torne@google.com>
CC: cjb@laptop.org, linus.walleij@linaro.org, jh80.chung@samsung.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        ben@decadent.org.uk
Subject: Re: [PATCH V3] MMC: core: cap MMC card timeouts at UINT_MAX
References: <CAEV-rjehr=zWTetxoBCwx0FR5ZzOqZxOTFHAuv1+3u+K=YqAAw@mail.gmail.com> <1338556815-26487-1-git-send-email-torne@google.com>
In-Reply-To: <1338556815-26487-1-git-send-email-torne@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/12 16:20, Torne (Richard Coles) wrote:
> From: "Torne (Richard Coles)" <torne@google.com>
> 
> MMC CSD info can specify very large, ridiculous timeouts, big enough to
> overflow timeout_ns. This can result in the card timing out on every
> operation because the wrapped timeout value is far too small.
> 
> Fix the overflow by capping the result at UINT_MAX.  Cards specifying
> longer timeouts are almost certainly insane, and host controllers
> generally cannot support timeouts that long in any case.
> 
> Signed-off-by: Torne (Richard Coles) <torne@google.com>
> ---
>  drivers/mmc/core/core.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 0b6141d..74ec3d4 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -512,7 +512,16 @@ void mmc_set_data_timeout(struct mmc_data *data, const struct mmc_card *card)
>  	if (data->flags & MMC_DATA_WRITE)
>  		mult <<= card->csd.r2w_factor;
>  
> -	data->timeout_ns = card->csd.tacc_ns * mult;
> +	/*
> +	 * The timeout in nanoseconds may overflow with some cards. Cap it at
> +	 * UINT_MAX to avoid the overflow; host controllers cannot generally
> +	 * generate timeouts that long anyway.
> +	 */
> +	if (card->csd.tacc_ns <= UINT_MAX / mult)
> +		data->timeout_ns = card->csd.tacc_ns * mult;
> +	else
> +		data->timeout_ns = UINT_MAX;
> +
>  	data->timeout_clks = card->csd.tacc_clks * mult;
>  
>  	/*

Acked-by: Adrian Hunter <adrian.hunter@intel.com>
