Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab2FNHww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 03:52:52 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:42077 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab2FNHwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 03:52:50 -0400
X-AuditID: 9c93016f-b7bd9ae000000ea6-d2-4fd9984fc452
From: Namhyung Kim <namhyung@kernel.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: lenb@kernel.org, linux-pm@lists.linux-foundation.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org
Subject: Re: [RFC 1/4] cpuidle: define the enter function in the driver structure
References: <1339171365-4098-1-git-send-email-daniel.lezcano@linaro.org>
Date: Thu, 14 Jun 2012 16:49:58 +0900
In-Reply-To: <1339171365-4098-1-git-send-email-daniel.lezcano@linaro.org>
	(Daniel Lezcano's message of "Fri, 8 Jun 2012 18:02:42 +0200")
Message-ID: <87r4ti49jt.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri,  8 Jun 2012 18:02:42 +0200, Daniel Lezcano wrote:
> We have the state index passed as parameter to the 'enter' function.
> Most of the drivers assign their 'enter' functions several times in
> the cpuidle_state structure, as we have the index, we can delegate
> to the driver to handle their own callback array.
>
> That will have the benefit of removing multiple lines of code in the
> different drivers.
>
> In order to smoothly modify the driver, the 'enter' function are in
> the driver structure and in the cpuidle state structure. That will
> let the time to modify the different drivers one by one.
> So the 'cpuidle_enter' function checks if the 'enter' callback is
> assigned in the driver structure and use it, otherwise it invokes
> the 'enter' assigned to the cpuidle_state.
>
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> ---
>  drivers/cpuidle/cpuidle.c |    4 +++-
>  include/linux/cpuidle.h   |    1 +
>  2 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index d90519c..155dee7 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -46,7 +46,9 @@ static inline int cpuidle_enter(struct cpuidle_device *dev,
>  				struct cpuidle_driver *drv, int index)
>  {
>  	struct cpuidle_state *target_state = &drv->states[index];
> -	return target_state->enter(dev, drv, index);
> +
> +	return drv->enter(dev, drv, index) ? drv->enter(dev, drv, index) :

Do you mean:
	       drv->enter ? drv->enter(dev, drv, index) :
?

Thanks,
Namhyung


> +		target_state->enter(dev, drv, index);
>  }
>  
>  static inline int cpuidle_enter_tk(struct cpuidle_device *dev,
> diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
> index 6c26a3d..d82e169 100644
> --- a/include/linux/cpuidle.h
> +++ b/include/linux/cpuidle.h
> @@ -130,6 +130,7 @@ struct cpuidle_driver {
>  	struct cpuidle_state	states[CPUIDLE_STATE_MAX];
>  	int			state_count;
>  	int			safe_state_index;
> +	int (*enter)(struct cpuidle_device *, struct cpuidle_driver *, int);
>  };
>  
>  #ifdef CONFIG_CPU_IDLE
