Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab2I1Dpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 23:45:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64566 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676Ab2I1Dpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 23:45:44 -0400
Date: Thu, 27 Sep 2012 20:42:50 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: mathieu.poirier@linaro.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 02/57] power: ab8500_bm: Don't clear the CCMuxOffset bit
Message-ID: <20120928034250.GQ5040@lizard>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
 <1348589574-25655-3-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1348589574-25655-3-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 10:11:59AM -0600, mathieu.poirier@linaro.org wrote:
> From: Kalle Komierowski <karl.komierowski@stericsson.com>
> 
> The CCMuxOffset bit is not kept set, this will force the columb counter
> of the AB8500 to use the measure offset calibration.
> This should increase the accuracy of the fuel gauge.
> 
> Signed-off-by: Kalle Komierowski <karl.komierowski@stericsson.com>
> Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
> ---
>  drivers/power/ab8500_fg.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
> index bf02225..af792a8 100644
> --- a/drivers/power/ab8500_fg.c
> +++ b/drivers/power/ab8500_fg.c
> @@ -485,8 +485,9 @@ static int ab8500_fg_coulomb_counter(struct ab8500_fg *di, bool enable)
>  		di->flags.fg_enabled = true;
>  	} else {
>  		/* Clear any pending read requests */
> -		ret = abx500_set_register_interruptible(di->dev,
> -			AB8500_GAS_GAUGE, AB8500_GASG_CC_CTRL_REG, 0);
> +		ret = abx500_mask_and_set_register_interruptible(di->dev,
> +			AB8500_GAS_GAUGE, AB8500_GASG_CC_CTRL_REG,
> +			(RESET_ACCU | READ_REQ), 0);
>  		if (ret)
>  			goto cc_err;
>  
> @@ -1404,8 +1405,7 @@ static void ab8500_fg_algorithm_discharging(struct ab8500_fg *di)
>  		sleep_time = di->bat->fg_params->init_timer;
>  
>  		/* Discard the first [x] seconds */
> -		if (di->init_cnt >
> -			di->bat->fg_params->init_discard_time) {
> +		if (di->init_cnt > di->bat->fg_params->init_discard_time) {

This change is OK, but it's cosmetic, and desires its own patch (you can
combine all cosmetic changes, which does not change the logic, into one
patch).

>  			ab8500_fg_calc_cap_discharge_voltage(di, true);
>  
>  			ab8500_fg_check_capacity_limits(di, true);
> -- 
> 1.7.5.4
