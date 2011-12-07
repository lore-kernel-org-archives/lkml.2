Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab1LGDaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 22:30:19 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63531 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab1LGDaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 22:30:18 -0500
Date: Wed, 7 Dec 2011 11:14:12 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] nohz: Remove ts->inidle checks before restarting the tick
Message-ID: <20111207031412.GA9166@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1323181843-12144-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1323181843-12144-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 03:30:43PM +0100, Frederic Weisbecker wrote:
> ts->inidle is set by tick_nohz_stop_sched_tick(1) and unset
> by tick_nohz_restart_sched_tick(). These two calls are assumed
> to be always paired. This means that by the time we call
> tick_nohz_restart_sched_tick(), ts->inidle is supposed to
> be always set to 1.
> 
> Remove the checks for ts->inidle in tick_nohz_restart_sched_tick().
> This simplifies a bit the code and improves its debuggability
> (ie: ensure the call is paired with a tick_nohz_stop_sched_tick() call).
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>

Thanks,
Yong


> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/time/tick-sched.c |   12 +++++++-----
>  1 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 4042064..0f7c5e5 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -529,20 +529,22 @@ void tick_nohz_restart_sched_tick(void)
>  	ktime_t now;
>  
>  	local_irq_disable();
> -	if (ts->idle_active || (ts->inidle && ts->tick_stopped))
> +
> +	WARN_ON_ONCE(!ts->inidle);
> +
> +	ts->inidle = 0;
> +
> +	if (ts->idle_active || ts->tick_stopped)
>  		now = ktime_get();
>  
>  	if (ts->idle_active)
>  		tick_nohz_stop_idle(cpu, now);
>  
> -	if (!ts->inidle || !ts->tick_stopped) {
> -		ts->inidle = 0;
> +	if (!ts->tick_stopped) {
>  		local_irq_enable();
>  		return;
>  	}
>  
> -	ts->inidle = 0;
> -
>  	rcu_exit_nohz();
>  
>  	/* Update jiffies first */
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Only stand for myself
