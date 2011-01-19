Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab1ASLnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 06:43:11 -0500
Received: from canuck.infradead.org ([134.117.69.58]:34419 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab1ASLnK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 06:43:10 -0500
Subject: Re: [PATCH] sched: Notify hrtimer users of switches to NOHZ mode
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, tglx <tglx@linutronix.de>
In-Reply-To: <1295419594-13085-1-git-send-email-sboyd@codeaurora.org>
References: <1295419594-13085-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 19 Jan 2011 12:43:40 +0100
Message-ID: <1295437420.28776.4.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-18 at 22:46 -0800, Stephen Boyd wrote:
> When NOHZ=y and high res timers are disabled (via cmdline or
> Kconfig) tick_nohz_switch_to_nohz() will notify the user about
> switching into NOHZ mode. Nothing is printed for the case where
> HIGH_RES_TIMERS=y. Fix this for the HIGH_RES_TIMERS=y case by
> duplicating the printk from the low res NOHZ path in the high res
> NOHZ path.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
> 
> This confused me since I was thinking 'dmesg | grep -i NOHZ' would
> tell me if NOHZ was enabled, but if I have hrtimers there is
> nothing. If we don't do this we should probably remove the original
> printk.

I'm not quite sure we want _more_ dmesg chatter, how about you look at
the output of:

grep -e "^cpu" -e "nohz" /proc/timer_list

instead?

>  kernel/time/tick-sched.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 3e216e0..6c012c5 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -795,8 +795,11 @@ void tick_setup_sched_timer(void)
>  	}
>  
>  #ifdef CONFIG_NO_HZ
> -	if (tick_nohz_enabled)
> +	if (tick_nohz_enabled) {
>  		ts->nohz_mode = NOHZ_MODE_HIGHRES;
> +		pr_info("Switched to NOHz mode on CPU #%d\n",
> +				smp_processor_id());
> +	}
>  #endif
>  }
>  #endif /* HIGH_RES_TIMERS */


