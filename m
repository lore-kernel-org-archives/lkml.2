Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118Ab0FOThv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 15:37:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754779Ab0FOThu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 15:37:50 -0400
Date: Tue, 15 Jun 2010 12:37:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: tytso@mit.edu, Salman <sqazi@google.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tytso@google.com,
       torvalds@linux-foundation.org, walken@google.com,
       Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be
 reused immediately.
Message-Id: <20100615123705.232f1cf2.akpm@linux-foundation.org>
In-Reply-To: <1276612552.2077.7725.camel@twins>
References: <AANLkTinlnb-HsDia4X2qgRjkTL_Z5CfVKYHRFwREoyIn@mail.gmail.com>
	<20100611224902.5039.60134.stgit@bumblebee1.mtv.corp.google.com>
	<20100614165851.6bdfe485.akpm@linux-foundation.org>
	<20100615005619.GI6666@thunk.org>
	<20100614185556.afdc5304.akpm@linux-foundation.org>
	<1276612552.2077.7725.camel@twins>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jun 2010 16:35:52 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> > I suspect sched_clock.c might be generating fair amounts of code which
> > UP builds don't need. 
> 
> Only sched_clock_remote() and its caller, something like the below, not
> much code..
> 
> UP machines can still have utterly sucky TSC, although the
> inter-cpu-drift thing isn't much of an issue ;-)
> 
> ---
>  kernel/sched_clock.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
> index 52f1a14..7ff5b56 100644
> --- a/kernel/sched_clock.c
> +++ b/kernel/sched_clock.c
> @@ -170,6 +170,7 @@ again:
>  	return clock;
>  }
>  
> +#ifdef CONFIG_SMP
>  static u64 sched_clock_remote(struct sched_clock_data *scd)
>  {
>  	struct sched_clock_data *my_scd = this_scd();
> @@ -205,6 +206,7 @@ again:
>  
>  	return val;
>  }
> +#endif
>  
>  /*
>   * Similar to cpu_clock(), but requires local IRQs to be disabled.
> @@ -226,9 +228,11 @@ u64 sched_clock_cpu(int cpu)
>  
>  	scd = cpu_sdc(cpu);
>  
> +#ifdef CONFIG_SMP
>  	if (cpu != smp_processor_id())
>  		clock = sched_clock_remote(scd);
>  	else
> +#endif
>  		clock = sched_clock_local(scd);
>  
>  	return clock;

hm, OK, I was actually looking at sched_clock_local() at the time.  Can
clocks go backwards on UP hardware?  What breaks if we do #define
sched_clock_local sched_clock?

I've mentioned this before, but sched_clock.c is really opaque - it
would be a formidable task for anyone to get in there and work on the
code if they hadn't already been working on it for years.
