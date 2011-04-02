Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab1DBAH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 20:07:26 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:45135 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab1DBAHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 20:07:25 -0400
Date: Fri, 01 Apr 2011 20:07:04 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Tero Kristo <tero.kristo@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] cpuidle: menu: fixed wrapping timers at 4.294 seconds
In-reply-to: <1298560763-441-1-git-send-email-tero.kristo@nokia.com>
Message-id: <alpine.LFD.2.02.1104012006370.3461@x980>
References: <1298560763-441-1-git-send-email-tero.kristo@nokia.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied to idle-test

thanks,
Len Brown, Intel Open Source Technology Center

ps. please cc linux-pm on cpuidle pathces

On Thu, 24 Feb 2011, Tero Kristo wrote:

> Cpuidle menu governor is using u32 as a temporary datatype for storing
> nanosecond values which wrap around at 4.294 seconds. This causes errors
> in predicted sleep times resulting in higher than should be C state
> selection and increased power consumption. This also breaks cpuidle
> state residency statistics.
> 
> Signed-off-by: Tero Kristo <tero.kristo@nokia.com>
> ---
>  drivers/cpuidle/governors/menu.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
> index f508690..c47f3d0 100644
> --- a/drivers/cpuidle/governors/menu.c
> +++ b/drivers/cpuidle/governors/menu.c
> @@ -237,6 +237,7 @@ static int menu_select(struct cpuidle_device *dev)
>  	unsigned int power_usage = -1;
>  	int i;
>  	int multiplier;
> +	struct timespec t;
>  
>  	if (data->needs_update) {
>  		menu_update(dev);
> @@ -251,8 +252,9 @@ static int menu_select(struct cpuidle_device *dev)
>  		return 0;
>  
>  	/* determine the expected residency time, round up */
> +	t = ktime_to_timespec(tick_nohz_get_sleep_length());
>  	data->expected_us =
> -	    DIV_ROUND_UP((u32)ktime_to_ns(tick_nohz_get_sleep_length()), 1000);
> +		t.tv_sec * USEC_PER_SEC + t.tv_nsec / NSEC_PER_USEC;
>  
>  
>  	data->bucket = which_bucket(data->expected_us);
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
