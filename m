Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729Ab2BYXzG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 18:55:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42402 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab2BYXzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 18:55:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [RFC PATCH 1/2] CPUfreq ondemand: update sampling rate without waiting for next sampling
Date: Sun, 26 Feb 2012 00:59:02 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Dave Jones <davej@redhat.com>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Kevin Hilman <khilman@ti.com>, Jean Pihet <j-pihet@ti.com>,
        markgross <markgross@thegnar.org>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
References: <CAJ0PZbSODSJvV-_Gje9Hm9Ek22Z9m+PAcsf071OCmAOtsnKzyg@mail.gmail.com> <1329897815-15871-1-git-send-email-myungjoo.ham@samsung.com> <1329897815-15871-2-git-send-email-myungjoo.ham@samsung.com>
In-Reply-To: <1329897815-15871-2-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201202260059.02347.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 22, 2012, MyungJoo Ham wrote:
> When a new sampling rate is shorter than the current one, (e.g., 1 sec
> --> 10 ms) regardless how short the new one is, the current ondemand
> mechanism wait for the previously set timer to be expired.
> 
> For example, if the user has just expressed that the sampling rate
> should be 10 ms from now and the previous was 1000 ms, the new rate may
> become effective 999 ms later, which could be not acceptable for the
> user if the user has intended to speed up sampling because the system is
> expected to react to CPU load fluctuation quickly from __now__.
> 
> In order to address this issue, we need to cancel the previously set
> timer (schedule_delayed_work) and reset the timer if resetting timer is
> expected to trigger the delayed_work ealier.
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/cpufreq/cpufreq_ondemand.c |   58 +++++++++++++++++++++++++++++++++++-
>  1 files changed, 57 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> index c3e0652..2d66649 100644
> --- a/drivers/cpufreq/cpufreq_ondemand.c
> +++ b/drivers/cpufreq/cpufreq_ondemand.c
> @@ -257,6 +257,62 @@ show_one(sampling_down_factor, sampling_down_factor);
>  show_one(ignore_nice_load, ignore_nice);
>  show_one(powersave_bias, powersave_bias);
>  
> +/**
> + * update_sampling_rate - update sampling rate effective immediately if needed.
> + * @new_rate: new sampling rate
> + *
> + * If new rate is smaller than the old, simply updaing
> + * dbs_tuners_int.sampling_rate might not be appropriate. For example,
> + * if the original sampling_rate was 1 second and the requested new sampling
> + * rate is 10 ms because the user needs immediate reaction from ondemand
> + * governor, but not sure if higher frequency will be required or not,
> + * then, the governor may change the sampling rate too late; up to 1 second
> + * later. Thus, if we are reducing the sampling rate, we need to make the
> + * new value effective immediately.
> + */
> +static void update_sampling_rate(unsigned int new_rate)
> +{
> +	int cpu;
> +
> +	dbs_tuners_ins.sampling_rate = new_rate
> +				     = max(new_rate, min_sampling_rate);
> +
> +	for_each_online_cpu(cpu) {
> +		struct cpufreq_policy *policy;
> +		struct cpu_dbs_info_s *dbs_info;
> +		struct timer_list *timer;
> +		unsigned long appointed_at;
> +
> +		policy = cpufreq_cpu_get(cpu);
> +		if (!policy)
> +			continue;
> +		dbs_info = &per_cpu(od_cpu_dbs_info, policy->cpu);
> +		cpufreq_cpu_put(policy);
> +
> +		mutex_lock(&dbs_info->timer_mutex);
> +
> +		if (!delayed_work_pending(&dbs_info->work))
> +			goto next;
> +

What about doing

			mutex_unlock(&dbs_info->timer_mutex);
			continue;

here instead of the jump?


> +		timer = &dbs_info->work.timer;
> +		appointed_at = timer->expires;
> +

I would do

		next_sampling = jiffies + usecs_to_jiffies(new_rate);

and compare that with timer->expires.  Then, the if () below would look better.
Or perhaps use new_rate_jiffies = usecs_to_jiffies(new_rate) and use that here
and below?

> +		if (time_before(jiffies + usecs_to_jiffies(new_rate),
> +				appointed_at)) {
> +
> +			mutex_unlock(&dbs_info->timer_mutex);

I'm not sure if this isn't going to be racy.  Have you verified that?

> +			cancel_delayed_work_sync(&dbs_info->work);
> +			mutex_lock(&dbs_info->timer_mutex);
> +
> +			schedule_delayed_work_on(dbs_info->cpu, &dbs_info->work,
> +						 usecs_to_jiffies(new_rate));
> +
> +		}
> +next:
> +		mutex_unlock(&dbs_info->timer_mutex);
> +	}
> +}
> +
>  static ssize_t store_sampling_rate(struct kobject *a, struct attribute *b,
>  				   const char *buf, size_t count)
>  {
> @@ -265,7 +321,7 @@ static ssize_t store_sampling_rate(struct kobject *a, struct attribute *b,
>  	ret = sscanf(buf, "%u", &input);
>  	if (ret != 1)
>  		return -EINVAL;
> -	dbs_tuners_ins.sampling_rate = max(input, min_sampling_rate);
> +	update_sampling_rate(input);
>  	return count;
>  }

Thanks,
Rafael
