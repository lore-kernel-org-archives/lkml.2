Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab0JERjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 13:39:25 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59411 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab0JERjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 13:39:23 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6127"; a="56795230"
Subject: Re: [PATCH 3/3] [ARM] Implement a timer based __delay() loop
From: Daniel Walker <dwalker@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Colin Cross <ccross@android.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
In-Reply-To: <1285644827-6846-4-git-send-email-sboyd@codeaurora.org>
References: <1285644827-6846-1-git-send-email-sboyd@codeaurora.org>
	 <1285644827-6846-4-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 10:38:57 -0700
Message-ID: <1286300338.18791.26.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-27 at 20:33 -0700, Stephen Boyd wrote:
> udelay() can be incorrect on SMP machines that scale their CPU
> frequencies independently of one another (as pointed out here
> http://article.gmane.org/gmane.linux.kernel/977567). The delay
> loop can either be too fast or too slow depending on which CPU the
> loops_per_jiffy counter is calibrated on and which CPU the delay
> loop is running on. udelay() can also be incorrect if the
> CPU frequency switches during the __delay() loop, causing the loop
> to either terminate too early, or too late. 
> 
> We'd rather not fix udelay() by forcing it to run on one CPU or
> take the penalty of a rather large loops_per_jiffy being used in
> udelay() when the CPU is actually running slower. Instead we
> solve the problem by making __delay() into a timer based loop
> which should be unaffected by CPU frequency scaling. Therefore,
> implement a timer based __delay() loop which can be used in place
> of the current register based __delay() if a machine so chooses.
> 
> The kernel is already prepared for a timer based approach
> (evident by the read_current_timer() function). If an arch
> implements read_current_timer(), calibrate_delay() will use a
> timer based function, calibrate_delay_direct(), to calculate
> loops_per_jiffy (in which case loops_per_jiffy should really be
> renamed to timer_ticks_per_jiffy). Since the loops_per_jiffy will
> be based on timer ticks, __delay() should be implemented as a
> loop around read_current_timer().
> 
> Doing this makes the expensive loops_per_jiffy calculation go
> away (saving ~150ms on boot time on my machine) and fixes
> udelay() by making it safe in the face of independently scaling
> CPUs. The only prerequisite is that read_current_timer() is
> monotonically increasing across calls (and doesn't overflow
> within ~2000us).
> 
> There is a downside to this approach though. BogoMIPS is no
> longer "accurate" in that it reflects the BogoMIPS of the timer
> and not the CPU. On most SoC's the timer isn't running anywhere
> near as fast as the CPU so BogoMIPS will be ridiculously low (my
> timer runs at 4.8 MHz and thus my BogoMIPS is 9.6 compared to my
> CPU's 800). This shouldn't be too much of a concern though since
> BogoMIPS are bogus anyway (hence the name).
> 
> This loop is pretty much a copy of AVR's version made more generic.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Reviewed-by: Saravana Kannan <skannan@codeaurora.org>
> ---
>  arch/arm/include/asm/delay.h |    1 +
>  arch/arm/lib/delay.c         |   18 ++++++++++++++++++
>  2 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/include/asm/delay.h b/arch/arm/include/asm/delay.h
> index 7c732b5..5c6b9a3 100644
> --- a/arch/arm/include/asm/delay.h
> +++ b/arch/arm/include/asm/delay.h
> @@ -41,6 +41,7 @@ extern void __const_udelay(unsigned long);
>  	  __udelay(n))
>  
>  extern void set_delay_fn(void (*fn)(unsigned long));
> +extern void read_current_timer_delay_loop(unsigned long loops);
>  
>  #endif /* defined(_ARM_DELAY_H) */
>  
> diff --git a/arch/arm/lib/delay.c b/arch/arm/lib/delay.c
> index b307fcc..59fdf64 100644
> --- a/arch/arm/lib/delay.c
> +++ b/arch/arm/lib/delay.c
> @@ -5,6 +5,7 @@
>   *  Copyright (c) 2010, Code Aurora Forum. All rights reserved.
>   *  Copyright (C) 1993 Linus Torvalds
>   *  Copyright (C) 1997 Martin Mares <mj@atrey.karlin.mff.cuni.cz>
> + *  Copyright (C) 2005-2006 Atmel Corporation
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -12,6 +13,7 @@
>   */
>  #include <linux/module.h>
>  #include <linux/delay.h>
> +#include <linux/timex.h>
>  
>  /*
>   * Oh, if only we had a cycle counter...
> @@ -26,6 +28,22 @@ void delay_loop(unsigned long loops)
>  	);
>  }
>  
> +#ifdef ARCH_HAS_READ_CURRENT_TIMER
> +/*
> + * Assuming read_current_timer() is monotonically increasing
> + * across calls.

You should add more comments here. You assuming that it's monotonic over
a 2000us (2ms) period .. I'm not sure this is a good assumption this
timer may not be monotonically increasing all the time, what happens
then?

> +void read_current_timer_delay_loop(unsigned long loops)
> +{
> +	unsigned long bclock, now;
> +
> +	read_current_timer(&bclock);
> +	do {
> +		read_current_timer(&now);
> +	} while ((now - bclock) < loops);

Have you looked at time_before()/time_after() ?

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

