Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab0F2PG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 11:06:28 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61352 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab0F2PG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 11:06:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NT2ciNGnHnG2RBnrmT4YC9WmCprpV67GaRXmkYXpyvDrNiU4loC6BF+dY+NyjXvqA0
         KaGH/iWWI5WTVvpyUg4JiTnQE/cr3Mrn9f3NQ+QY8MyrPb7xgkVXzh0mqJC62QHIP8Xm
         /fE0vyuXx6M4WdB0ttGXS64aUaRjnKXZTY9Uc=
Date: Tue, 29 Jun 2010 17:06:38 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 10/11] perf: Shrink hw_perf_event
Message-ID: <20100629150635.GH5318@nowhere>
References: <20100624142804.431553874@chello.nl> <20100624143407.051462971@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624143407.051462971@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 04:28:14PM +0200, Peter Zijlstra wrote:
> Use hw_perf_event::period_left instead of hw_perf_event::remaning and
> win back 8 bytes.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>



> ---
>  include/linux/perf_event.h |    1 -
>  kernel/perf_event.c        |   13 ++++++-------
>  2 files changed, 6 insertions(+), 8 deletions(-)
> 
> Index: linux-2.6/include/linux/perf_event.h
> ===================================================================
> --- linux-2.6.orig/include/linux/perf_event.h
> +++ linux-2.6/include/linux/perf_event.h
> @@ -529,7 +529,6 @@ struct hw_perf_event {
>  			int		last_cpu;
>  		};
>  		struct { /* software */
> -			s64		remaining;
>  			struct hrtimer	hrtimer;
>  		};
>  #ifdef CONFIG_HAVE_HW_BREAKPOINT
> Index: linux-2.6/kernel/perf_event.c
> ===================================================================
> --- linux-2.6.orig/kernel/perf_event.c
> +++ linux-2.6/kernel/perf_event.c
> @@ -4590,14 +4590,13 @@ static void perf_swevent_start_hrtimer(s
>  	hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
>  	hwc->hrtimer.function = perf_swevent_hrtimer;
>  	if (hwc->sample_period) {
> -		u64 period;
> +		s64 period = local64_read(&hwc->period_left);
>  
> -		if (hwc->remaining) {
> -			if (hwc->remaining < 0)
> +		if (period) {
> +			if (period < 0)
>  				period = 10000;
> -			else
> -				period = hwc->remaining;
> -			hwc->remaining = 0;
> +
> +			local64_set(&hwc->period_left, 0);
>  		} else {
>  			period = max_t(u64, 10000, hwc->sample_period);
>  		}
> @@ -4613,7 +4612,7 @@ static void perf_swevent_cancel_hrtimer(
>  
>  	if (hwc->sample_period) {
>  		ktime_t remaining = hrtimer_get_remaining(&hwc->hrtimer);
> -		hwc->remaining = ktime_to_ns(remaining);
> +		local64_set(&hwc->period_left, ktime_to_ns(remaining));
>  
>  		hrtimer_cancel(&hwc->hrtimer);
>  	}
> 
> 

