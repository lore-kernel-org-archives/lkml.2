Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab2LPQLq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 11:11:46 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59801 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab2LPQLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 11:11:45 -0500
Message-ID: <50CDF2A2.3090405@gmail.com>
Date: Sun, 16 Dec 2012 17:11:14 +0100
From: Francesco Lavra <francescolavra.fl@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: rjw@sisk.pl, jwerner@chromium.org, linux-pm@vger.kernel.org,
        deepthi@linux.vnet.ibm.com, g.trinabh@gmail.com,
        linaro-dev@lists.linaro.org, len.brown@intel.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        snanda@chromium.org
Subject: Re: [PATCH 2/2][V2] cpuidle - optimize the select function for the
 'menu' governor
References: <1355493455-30665-1-git-send-email-daniel.lezcano@linaro.org> <1355493455-30665-3-git-send-email-daniel.lezcano@linaro.org>
In-Reply-To: <1355493455-30665-3-git-send-email-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 12/14/2012 02:57 PM, Daniel Lezcano wrote:
> As the power is backward sorted in the states array and we are looking for
> the state consuming the little power as possible, instead of looking from
> the beginning of the array, we look from the end. That should save us some
> iterations in the loop each time we select a state at idle time.
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> ---
>  drivers/cpuidle/governors/menu.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
> index fe343a0..05b8998 100644
> --- a/drivers/cpuidle/governors/menu.c
> +++ b/drivers/cpuidle/governors/menu.c
> @@ -367,24 +367,24 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
>  	 * Find the idle state with the lowest power while satisfying
>  	 * our constraints.
>  	 */
> -	for (i = CPUIDLE_DRIVER_STATE_START; i < drv->state_count; i++) {
> +	for (i = drv->state_count - 1; i >= CPUIDLE_DRIVER_STATE_START; i--) {
>  		struct cpuidle_state *s = &drv->states[i];
>  		struct cpuidle_state_usage *su = &dev->states_usage[i];
>  
>  		if (s->disabled || su->disable)
>  			continue;
> -		if (s->target_residency > data->predicted_us) {
> -			low_predicted = 1;
> -			continue;
> -		}
>  		if (s->exit_latency > latency_req)
>  			continue;
> +		if (s->target_residency > data->predicted_us)
> +			continue;
>  		if (s->exit_latency * multiplier > data->predicted_us)
>  			continue;
>  
> +		low_predicted = i - CPUIDLE_DRIVER_STATE_START;

You are altering the semantics of low_predicted, which is supposed to be
non-zero when the deepest C-state has not been chosen because its target
residency is more than the predicted residency.
It seems to me that the if block where target_residency is compared with
the predicted residency should be left as is.

>  		data->last_state_idx = i;
>  		data->exit_us = s->exit_latency;
> -	}
> +		break;
> +       }
>  
>  	/* not deepest C-state chosen for low predicted residency */
>  	if (low_predicted) {

--
Francesco
