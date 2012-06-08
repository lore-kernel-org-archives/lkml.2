Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762278Ab2FHRdU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 13:33:20 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:55227 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762258Ab2FHRdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 13:33:14 -0400
Message-ID: <4FD23752.6090101@linux.vnet.ibm.com>
Date: Fri, 08 Jun 2012 23:03:06 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [RFC 1/4] cpuidle: define the enter function in the
 driver structure
References: <1339171365-4098-1-git-send-email-daniel.lezcano@linaro.org>
In-Reply-To: <1339171365-4098-1-git-send-email-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12060817-3864-0000-0000-0000033FF625
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 06/08/2012 09:32 PM, Daniel Lezcano wrote:

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


Currently, the backend driver initializes
all the cpuidle states supported on the platform,
and each state can have its own enter routine
which can be unique  This is a clean approach.

By moving the enter routine into the driver,
we are enforcing in having only one enter state.
There is unnecessary overhead involved
in calling a wrapper routine just to
index into the right idle state routine
for many platforms at runtime.


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


Cheers,
Deepthi

