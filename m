Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab0KKUC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 15:02:57 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:56341 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab0KKUC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 15:02:56 -0500
Subject: Re: [RFC-PATCH] clocksource: update lpj if clocksource has been
 changed.
From: john stultz <johnstul@us.ibm.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com, Thomas Gleixner <tglx@linutronix.de>,
        Magnus Damm <damm@opensource.se>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jon Hunter <jon-hunter@ti.com>
In-Reply-To: <1289464582-26898-1-git-send-email-myungjoo.ham@samsung.com>
References: <1289464582-26898-1-git-send-email-myungjoo.ham@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 12:02:41 -0800
Message-ID: <1289505761.2742.24.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 17:36 +0900, MyungJoo Ham wrote:
> With a clocksource change, loops_per_jiffy may have been changed; thus,
> the loops_per_jiffy in each cpu should be updated. Especially after some
> of the cpus were turned off and on, their loops_per_jiffy values are
> updated while the cpus kept on are not. Therefore, in order to make them
> "normalized equally", we need to let the loops_per_jiffy values of
> different cpus be based on the same clocksource.
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

First, Thanks for reporting the issue and submitting the patch!

So the premise is that read_current_timer -> get_cycles ->
clocksource_read on some arches. And then when we select a different
clocksource for timekeeping, this also changes the get_cycles source
breaking delay loops.

The clocksource selected for timekeeping and the counter being used for
get_cycles really shouldn't be explicitly bound. On most systems I don't
think that is the case, so this patch would force needless recalibration
calls on clocksource changes.

Which arch specifically are you seeing the issue on? I suspect there is
be a better way to fix this.

thanks
-john


> ---
>  kernel/time/clocksource.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index c18d7ef..a9d7935 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -30,6 +30,9 @@
>  #include <linux/sched.h> /* for spin_unlock_irq() using preempt_count() m68k */
>  #include <linux/tick.h>
>  #include <linux/kthread.h>
> +#include <linux/delay.h>
> 
>  void timecounter_init(struct timecounter *tc,
>  		      const struct cyclecounter *cc,
> @@ -592,6 +593,9 @@ static inline void clocksource_select(void) { }
>   */
>  static int __init clocksource_done_booting(void)
>  {
> +#ifdef CONFIG_SMP
> +	int cpu;
> +#endif
>  	mutex_lock(&clocksource_mutex);
>  	curr_clocksource = clocksource_default_clock();
>  	mutex_unlock(&clocksource_mutex);
> @@ -606,6 +610,13 @@ static int __init clocksource_done_booting(void)
>  	mutex_lock(&clocksource_mutex);
>  	clocksource_select();
>  	mutex_unlock(&clocksource_mutex);
> +
> +	calibrate_delay();
> +#ifdef CONFIG_SMP
> +	/* loops_per_jiffy may have been changed. */
> +	for_each_online_cpu(cpu)
> +		smp_store_cpu_info(cpu);
> +#endif
>  	return 0;
>  }
>  fs_initcall(clocksource_done_booting);


