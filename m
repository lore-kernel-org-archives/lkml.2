Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab1HZX4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 19:56:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754057Ab1HZX4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 19:56:51 -0400
Date: Fri, 26 Aug 2011 16:56:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jack Steiner <steiner@sgi.com>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Reduce clock calibration time during slave cpu
 startup
Message-Id: <20110826165634.398b0d2e.akpm@linux-foundation.org>
In-Reply-To: <20110727135730.GA17717@sgi.com>
References: <20110727135730.GA17717@sgi.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jul 2011 08:57:31 -0500
Jack Steiner <steiner@sgi.com> wrote:

> Reduce the startup time for slave cpus.
> 
> This patch adds hooks for an arch-specific function for clock calibration.
> These hooks are used on x86. They assume all cores in a physical socket
> run at the same core speed. If a newly started cpu has the same phys_proc_id
> as a core already active, use the already-calculated value of loops_per_jiffy.
> 
> This patch reduces the time required to start slave cpus on a 4096 cpu
> system from:
> 	465 sec  OLD
> 	 62 sec NEW

Eight minutes is just stupid.

100ms/cpu is just stupid too.  What's the CPU doing?  Spinning around
counting ticks?  That's parallelizable.

> This reduces boot time on a 4096p system by almost 7 minutes.  Nice...
> 
> 
> Signed-off-by: Jack Steiner <steiner@sgi.com>
> 
> 
> ---
> Note: patch assumes that all multi-core x86 processor sockets have the same
> clock frequency for all cores. AFAIK, this is true & will continue
> to be true for a long time. Have I overlooked anything???

Well, Andi thinks this may become untrue relatively soon.  Then what do
we do?

>  /*
> + * Check if another cpu is in the same socket and has already been calibrated.
> + * If found, use the previous value. This assumes all cores in the same physical
> + * socket have the same core frequency.
> + */
> +unsigned long __cpuinit calibrate_delay_is_known(void)
> +{
> +	int i, cpu = smp_processor_id();
> +
> +	for_each_online_cpu(i)
> +		if (cpu_data(i).phys_proc_id == cpu_data(cpu).phys_proc_id)

This will always match when `i' reaches `cpu'.  Or is this cpu not
online at this time?

> +			return cpu_data(i).loops_per_jiffy;
> +	return 0;
> +}
> +
> +/*
>   * Activate a secondary processor.
>   */
>  notrace static void __cpuinit start_secondary(void *unused)
> Index: linux/init/calibrate.c
> ===================================================================
> --- linux.orig/init/calibrate.c	2011-07-26 08:01:15.571979739 -0500
> +++ linux/init/calibrate.c	2011-07-27 08:39:35.691983745 -0500
> @@ -243,6 +243,20 @@ recalibrate:
>  	return lpj;
>  }
>  
> +/*
> + * Check if cpu calibration delay is already known. For example,
> + * some processors with multi-core sockets may have all sockets
> + * use the same core frequency. It is not necessary to calibrate
> + * each core.
> + *
> + * Architectures should override this function if a faster calibration
> + * method is available.
> + */
> +unsigned long __attribute__((weak)) __cpuinit calibrate_delay_is_known(void)

__weak

> +{
> +	return 0;
> +}
> +
>  void __cpuinit calibrate_delay(void)
>  {
>  	unsigned long lpj;
> @@ -257,6 +271,8 @@ void __cpuinit calibrate_delay(void)
>  		lpj = lpj_fine;
>  		pr_info("Calibrating delay loop (skipped), "
>  			"value calculated using timer frequency.. ");
> +	} else if ((lpj = calibrate_delay_is_known())) {
> +		;
>  	} else if ((lpj = calibrate_delay_direct()) != 0) {
>  		if (!printed)
>  			pr_info("Calibrating delay using timer "
