Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab2KUN5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 08:57:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138Ab2KUN5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 08:57:53 -0500
Date: Wed, 21 Nov 2012 08:57:49 -0500
From: Don Zickus <dzickus@redhat.com>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: akpm@linux-foundation.org, mingo@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: using u64 in get_sample_period()
Message-ID: <20121121135749.GS1871@redhat.com>
References: <1353495367.15558.1690.camel@cliu38-desktop-build>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353495367.15558.1690.camel@cliu38-desktop-build>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 06:56:07PM +0800, Chuansheng Liu wrote:
> 
> In get_sample_period(), unsigned long is not enough:
> watchdog_thresh * 2 * (NSEC_PER_SEC / 5)
> 
> case1: watchdog_thresh is 10 by default,
> the sample value will be: 0xEE6B 2800
> 
> case2: set watchdog_thresh is 20,
> the sample value will be: 0x1 DCD6 5000
> 
> >From case2, we need use u64 to express the sample period.
> Otherwise, Changing the threshold thru proc often can
> not be successful.

I guess I should have tested 32-bit more. :-) Good catch.

Acked-by: Don Zickus <dzickus@redhat.com>

> 
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> ---
>  kernel/watchdog.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 9d4c8d5..dd4b80a 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -116,7 +116,7 @@ static unsigned long get_timestamp(int this_cpu)
>  	return cpu_clock(this_cpu) >> 30LL;  /* 2^30 ~= 10^9 */
>  }
>  
> -static unsigned long get_sample_period(void)
> +static u64 get_sample_period(void)
>  {
>  	/*
>  	 * convert watchdog_thresh from seconds to ns
> @@ -125,7 +125,7 @@ static unsigned long get_sample_period(void)
>  	 * and hard thresholds) to increment before the
>  	 * hardlockup detector generates a warning
>  	 */
> -	return get_softlockup_thresh() * (NSEC_PER_SEC / 5);
> +	return get_softlockup_thresh() * ((u64)NSEC_PER_SEC / 5);
>  }
>  
>  /* Commands for resetting the watchdog */
> -- 
> 1.7.0.4
> 
> 
> 
