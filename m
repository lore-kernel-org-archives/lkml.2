Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab0DVOhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 10:37:46 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40986 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288Ab0DVOhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 10:37:45 -0400
Date: Thu, 22 Apr 2010 16:37:44 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Amit Kucheria <amit.kucheria@canonical.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
       Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: mxc: utilise usecount field in clock operations
Message-ID: <20100422143744.GC32348@pengutronix.de>
References: <b9f250fee8e5300e859b2afc234868ba7632f619.1271864861.git.amit.kucheria@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b9f250fee8e5300e859b2afc234868ba7632f619.1271864861.git.amit.kucheria@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
> @@ -50,15 +50,15 @@ static DEFINE_MUTEX(clocks_mutex);
>  
>  static void __clk_disable(struct clk *clk)
>  {
> -	if (clk == NULL || IS_ERR(clk))
> +	if (clk == NULL || IS_ERR(clk) || !clk->usecount)
>  		return;
>  
> -	__clk_disable(clk->parent);
> -	__clk_disable(clk->secondary);
> -
> -	WARN_ON(!clk->usecount);
> -	if (!(--clk->usecount) && clk->disable)
> -		clk->disable(clk);
> +	if (!(--clk->usecount)) {
> +		if (clk->disable)
> +			clk->disable(clk);
> +		__clk_disable(clk->parent);
> +		__clk_disable(clk->secondary);
> +	}
>  }
This removes the WARN_ON if the clock is already off.  Is this intended?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
