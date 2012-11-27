Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab2K0WBL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 17:01:11 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:34648 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754355Ab2K0WBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 17:01:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-pm@vger.kernel.org
Cc: Fabio Baltieri <fabio.baltieri@linaro.org>, cpufreq@vger.kernel.org,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] cpufreq: handle SW coordinated CPUs
Date: Tue, 27 Nov 2012 23:05:52 +0100
Message-ID: <1723557.AFJjisZlEm@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc7; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1353947996-26723-2-git-send-email-fabio.baltieri@linaro.org>
References: <1353947996-26723-1-git-send-email-fabio.baltieri@linaro.org> <1353947996-26723-2-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 26, 2012 05:39:52 PM Fabio Baltieri wrote:
> From: Rickard Andersson <rickard.andersson@stericsson.com>
> 
> This patch fixes a bug that occurred when we had load on a secondary CPU
> and the primary CPU was sleeping. Only one sampling timer was spawned
> and it was spawned as a deferred timer on the primary CPU, so when a
> secondary CPU had a change in load this was not detected by the cpufreq
> governor (both ondemand and conservative).
> 
> This patch make sure that deferred timers are run on all CPUs in the
> case of software controlled CPUs that run on the same frequency.
> 
> Signed-off-by: Rickard Andersson <rickard.andersson@stericsson.com>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> ---
>  drivers/cpufreq/cpufreq_conservative.c |  3 +-
>  drivers/cpufreq/cpufreq_governor.c     | 52 ++++++++++++++++++++++++++++++----
>  drivers/cpufreq/cpufreq_governor.h     |  1 +
>  drivers/cpufreq/cpufreq_ondemand.c     |  3 +-
>  4 files changed, 51 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
> index 64ef737..b9d7f14 100644
> --- a/drivers/cpufreq/cpufreq_conservative.c
> +++ b/drivers/cpufreq/cpufreq_conservative.c
> @@ -122,7 +122,8 @@ static void cs_dbs_timer(struct work_struct *work)
>  
>  	dbs_check_cpu(&cs_dbs_data, cpu);
>  
> -	schedule_delayed_work_on(cpu, &dbs_info->cdbs.work, delay);
> +	schedule_delayed_work_on(smp_processor_id(), &dbs_info->cdbs.work,
> +			delay);
>  	mutex_unlock(&dbs_info->cdbs.timer_mutex);
>  }
>  
> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> index 6c5f1d3..a00f02d 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -161,13 +161,31 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>  }
>  EXPORT_SYMBOL_GPL(dbs_check_cpu);
>  
> +bool dbs_sw_coordinated_cpus(struct cpu_dbs_common_info *cdbs)
> +{
> +	struct cpufreq_policy *policy = cdbs->cur_policy;
> +
> +	return cpumask_weight(policy->cpus) > 1;
> +}
> +EXPORT_SYMBOL_GPL(dbs_sw_coordinated_cpus);
> +
>  static inline void dbs_timer_init(struct dbs_data *dbs_data,
> -		struct cpu_dbs_common_info *cdbs, unsigned int sampling_rate)
> +				  struct cpu_dbs_common_info *cdbs,
> +				  unsigned int sampling_rate,
> +				  int cpu)
>  {
>  	int delay = delay_for_sampling_rate(sampling_rate);
> +	struct cpu_dbs_common_info *cdbs_local = dbs_data->get_cpu_cdbs(cpu);
> +	struct od_cpu_dbs_info_s *od_dbs_info;
> +
> +	cancel_delayed_work_sync(&cdbs_local->work);
> +
> +	if (dbs_data->governor == GOV_ONDEMAND) {
> +		od_dbs_info = dbs_data->get_cpu_dbs_info_s(cpu);
> +		od_dbs_info->sample_type = OD_NORMAL_SAMPLE;
> +	}

The patch looks good in general except for the special case above.

Why exactly is it necessary?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
