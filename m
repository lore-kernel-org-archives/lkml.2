Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab0DVLtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 07:49:46 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:57021 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029Ab0DVLtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 07:49:45 -0400
Date: Thu, 22 Apr 2010 14:47:50 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Amit Kucheria <amit.kucheria@canonical.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
       Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] arm: mxc: utilise usecount field in clock operations
Message-ID: <20100422114747.GB14819@jasper.tkos.co.il>
References: <b9f250fee8e5300e859b2afc234868ba7632f619.1271864861.git.amit.kucheria@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9f250fee8e5300e859b2afc234868ba7632f619.1271864861.git.amit.kucheria@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

On Wed, Apr 21, 2010 at 09:37:31PM +0300, Amit Kucheria wrote:
> clk->usecount can be used by platform code to check if a clock is active or
> not.
> 
> Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
> ---
>  arch/arm/plat-mxc/clock.c |   37 ++++++++++++++++++++++++-------------
>  1 files changed, 24 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm/plat-mxc/clock.c b/arch/arm/plat-mxc/clock.c
> index 323ff8c..c791f38 100644
> --- a/arch/arm/plat-mxc/clock.c
> +++ b/arch/arm/plat-mxc/clock.c

[snip]

> @@ -160,17 +161,27 @@ EXPORT_SYMBOL(clk_set_rate);
>  int clk_set_parent(struct clk *clk, struct clk *parent)
>  {
>  	int ret = -EINVAL;
> +	struct clk *prev_parent = clk->parent;
>  
>  	if (clk == NULL || IS_ERR(clk) || parent == NULL ||
>  	    IS_ERR(parent) || clk->set_parent == NULL)
>  		return ret;
>  
> +	if (clk->usecount != 0) {
> +		clk_enable(parent);
> +	}

Unnecessary braces here. See chapter 3 of Documentation/CodingStyle.

> +
>  	mutex_lock(&clocks_mutex);
>  	ret = clk->set_parent(clk, parent);
> -	if (ret == 0)
> +	if (ret == 0) {
>  		clk->parent = parent;
> +	}

Ditto

>  	mutex_unlock(&clocks_mutex);
>  
> +	if (clk->usecount != 0) {
> +		clk_disable(prev_parent);
> +	}

Ditto

> +
>  	return ret;
>  }
>  EXPORT_SYMBOL(clk_set_parent);
> -- 

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
