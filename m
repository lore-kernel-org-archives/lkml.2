Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab2JOIfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 04:35:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53907 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845Ab2JOIfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 04:35:40 -0400
Date: Mon, 15 Oct 2012 10:35:34 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, tglx@linutronix.de, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Robin.Randhawa@arm.com
Subject: Re: [PATCH] cpufreq: timer: Move tick-sched specific code outside of
 cpufreq governors
Message-ID: <20121015083533.GB29356@dhcp22.suse.cz>
References: <10f0412be71dec50a3e57732c1f2aa5b94fe1df8.1350288504.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10f0412be71dec50a3e57732c1f2aa5b94fe1df8.1350288504.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 15-10-12 13:41:20, Viresh Kumar wrote:
> Multiple cpufreq governers have defined similar get_cpu_idle_time_***()
> routines. These routines must be moved to some common place, so that all
> governors can use them.
> 
> So moving them to tick-sched.c, which seems to be a better place for keeping
> these routines.

I do agree that this code duplication should be removed but tick-sched.c
is not a right place IMO. Who, apart from governors, should use those
"common" functions?
Having a generic get_cpu_idle_time, which in fact includes iowait time
as well is definitely not good. It is confusing and it doesn't match
get_cpu_idle_time_us.
I would suggest moving the common functionality into drivers/cpufreq/
(e.g. cpufreq_common.c).

> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/cpufreq_conservative.c | 34 ---------------------------------
>  drivers/cpufreq/cpufreq_ondemand.c     | 34 ---------------------------------
>  include/linux/tick.h                   |  3 +++
>  kernel/time/tick-sched.c               | 35 ++++++++++++++++++++++++++++++++++
>  4 files changed, 38 insertions(+), 68 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
> index a152af7..181abad 100644
> --- a/drivers/cpufreq/cpufreq_conservative.c
> +++ b/drivers/cpufreq/cpufreq_conservative.c
> @@ -95,40 +95,6 @@ static struct dbs_tuners {
>  	.freq_step = 5,
>  };
>  
> -static inline u64 get_cpu_idle_time_jiffy(unsigned int cpu, u64 *wall)
> -{
> -	u64 idle_time;
> -	u64 cur_wall_time;
> -	u64 busy_time;
> -
> -	cur_wall_time = jiffies64_to_cputime64(get_jiffies_64());
> -
> -	busy_time  = kcpustat_cpu(cpu).cpustat[CPUTIME_USER];
> -	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_SYSTEM];
> -	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_IRQ];
> -	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_SOFTIRQ];
> -	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_STEAL];
> -	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_NICE];
> -
> -	idle_time = cur_wall_time - busy_time;
> -	if (wall)
> -		*wall = jiffies_to_usecs(cur_wall_time);
> -
> -	return jiffies_to_usecs(idle_time);
> -}
> -
> -static inline cputime64_t get_cpu_idle_time(unsigned int cpu, cputime64_t *wall)
> -{
> -	u64 idle_time = get_cpu_idle_time_us(cpu, NULL);
> -
> -	if (idle_time == -1ULL)
> -		return get_cpu_idle_time_jiffy(cpu, wall);
> -	else
> -		idle_time += get_cpu_iowait_time_us(cpu, wall);
> -
> -	return idle_time;
> -}
> -
>  /* keep track of frequency transitions */
>  static int
>  dbs_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
> diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> index 396322f..d7f774b 100644
> --- a/drivers/cpufreq/cpufreq_ondemand.c
> +++ b/drivers/cpufreq/cpufreq_ondemand.c
> @@ -119,40 +119,6 @@ static struct dbs_tuners {
>  	.powersave_bias = 0,
>  };
>  
> -static inline u64 get_cpu_idle_time_jiffy(unsigned int cpu, u64 *wall)
> -{
> -	u64 idle_time;
> -	u64 cur_wall_time;
> -	u64 busy_time;
> -
> -	cur_wall_time = jiffies64_to_cputime64(get_jiffies_64());
> -
> -	busy_time  = kcpustat_cpu(cpu).cpustat[CPUTIME_USER];
> -	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_SYSTEM];
> -	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_IRQ];
> -	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_SOFTIRQ];
> -	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_STEAL];
> -	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_NICE];
> -
> -	idle_time = cur_wall_time - busy_time;
> -	if (wall)
> -		*wall = jiffies_to_usecs(cur_wall_time);
> -
> -	return jiffies_to_usecs(idle_time);
> -}
> -
> -static inline cputime64_t get_cpu_idle_time(unsigned int cpu, cputime64_t *wall)
> -{
> -	u64 idle_time = get_cpu_idle_time_us(cpu, NULL);
> -
> -	if (idle_time == -1ULL)
> -		return get_cpu_idle_time_jiffy(cpu, wall);
> -	else
> -		idle_time += get_cpu_iowait_time_us(cpu, wall);
> -
> -	return idle_time;
> -}
> -
>  static inline cputime64_t get_cpu_iowait_time(unsigned int cpu, cputime64_t *wall)
>  {
>  	u64 iowait_time = get_cpu_iowait_time_us(cpu, wall);
> diff --git a/include/linux/tick.h b/include/linux/tick.h
> index f37fceb..79ca824 100644
> --- a/include/linux/tick.h
> +++ b/include/linux/tick.h
> @@ -6,6 +6,7 @@
>  #ifndef _LINUX_TICK_H
>  #define _LINUX_TICK_H
>  
> +#include <asm/cputime.h>
>  #include <linux/clockchips.h>
>  #include <linux/irqflags.h>
>  
> @@ -142,4 +143,6 @@ static inline u64 get_cpu_idle_time_us(int cpu, u64 *unused) { return -1; }
>  static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }
>  # endif /* !NO_HZ */
>  
> +cputime64_t get_cpu_idle_time(unsigned int cpu, cputime64_t *wall);
> +
>  #endif
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index a402608..b458402 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -271,6 +271,41 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
>  }
>  EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);
>  
> +static inline u64 get_cpu_idle_time_jiffy(unsigned int cpu, u64 *wall)
> +{
> +	u64 idle_time;
> +	u64 cur_wall_time;
> +	u64 busy_time;
> +
> +	cur_wall_time = jiffies64_to_cputime64(get_jiffies_64());
> +
> +	busy_time = kcpustat_cpu(cpu).cpustat[CPUTIME_USER];
> +	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_SYSTEM];
> +	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_IRQ];
> +	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_SOFTIRQ];
> +	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_STEAL];
> +	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_NICE];
> +
> +	idle_time = cur_wall_time - busy_time;
> +	if (wall)
> +		*wall = jiffies_to_usecs(cur_wall_time);
> +
> +	return jiffies_to_usecs(idle_time);
> +}
> +
> +cputime64_t get_cpu_idle_time(unsigned int cpu, cputime64_t *wall)
> +{
> +	u64 idle_time = get_cpu_idle_time_us(cpu, NULL);
> +
> +	if (idle_time == -1ULL)
> +		return get_cpu_idle_time_jiffy(cpu, wall);
> +	else
> +		idle_time += get_cpu_iowait_time_us(cpu, wall);
> +
> +	return idle_time;
> +}
> +EXPORT_SYMBOL_GPL(get_cpu_idle_time);
> +
>  static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
>  					 ktime_t now, int cpu)
>  {
> -- 
> 1.7.12.rc2.18.g61b472e
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs
