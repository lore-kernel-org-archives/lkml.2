Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab2BLOvF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 09:51:05 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:51350 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330Ab2BLOvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 09:51:02 -0500
Message-ID: <4F37D1C4.2080706@linux.vnet.ibm.com>
Date: Sun, 12 Feb 2012 20:20:44 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 3/3] PM / Sleep: Drop suspend_stats_update()
References: <201202120003.20879.rjw@sisk.pl> <201202120006.05601.rjw@sisk.pl>
In-Reply-To: <201202120006.05601.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12021205-3568-0000-0000-00000132EC0E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2012 04:36 AM, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Since suspend_stats_update() is only called from pm_suspend(),
> move its code directly into that function and remove the static
> inline definition from include/linux/suspend.h.  Clean up
> pm_suspend() in the process.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---


Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

>  include/linux/suspend.h |   16 ----------------
>  kernel/power/suspend.c  |   18 ++++++++++++------
>  2 files changed, 12 insertions(+), 22 deletions(-)
> 
> Index: linux/include/linux/suspend.h
> ===================================================================
> --- linux.orig/include/linux/suspend.h
> +++ linux/include/linux/suspend.h
> @@ -95,22 +95,6 @@ static inline void dpm_save_failed_step(
>  }
> 
>  /**
> - * suspend_stats_update - Update success/failure statistics of suspend-to-ram
> - *
> - * @error: Value returned by enter_state() function
> - */
> -static inline void suspend_stats_update(int error)
> -{
> -	if (error) {
> -		suspend_stats.fail++;
> -		dpm_save_failed_errno(error);
> -	} else {
> -		suspend_stats.success++;
> -	}
> -}
> -
> -
> -/**
>   * struct platform_suspend_ops - Callbacks for managing platform dependent
>   *	system sleep states.
>   *
> Index: linux/kernel/power/suspend.c
> ===================================================================
> --- linux.orig/kernel/power/suspend.c
> +++ linux/kernel/power/suspend.c
> @@ -316,12 +316,18 @@ static int enter_state(suspend_state_t s
>   */
>  int pm_suspend(suspend_state_t state)
>  {
> -	int ret;
> -	if (state > PM_SUSPEND_ON && state < PM_SUSPEND_MAX) {
> -		ret = enter_state(state);
> -		suspend_stats_update(ret);
> -		return ret;
> +	int error;
> +
> +	if (state <= PM_SUSPEND_ON || state >= PM_SUSPEND_MAX)
> +		return -EINVAL;
> +
> +	error = enter_state(state);
> +	if (error) {
> +		suspend_stats.fail++;
> +		dpm_save_failed_errno(error);
> +	} else {
> +		suspend_stats.success++;
>  	}
> -	return -EINVAL;
> +	return error;
>  }
>  EXPORT_SYMBOL(pm_suspend);
> 

