Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759962Ab0JGBoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 21:44:19 -0400
Received: from smtp-out.google.com ([74.125.121.35]:32797 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757279Ab0JGBoS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 21:44:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MrcuPUnkBsQpFBbo1oXj/NlH/IhgSQiNrKklJpcAGfc9ZdH5toIQgV+MzKPOHv6WIm
         elJrV3tKmKZpduWRr7VA==
MIME-Version: 1.0
In-Reply-To: <4CACE200.1050901@verisign.com>
References: <4CACE200.1050901@verisign.com>
Date: Wed, 6 Oct 2010 18:44:14 -0700
Message-ID: <AANLkTint0UDnSwCsuS6eT_P+kwpCALzm2ghLUHW8q9fR@mail.gmail.com>
Subject: Re: [PATCH 1/1] cpufreq: sampling_down_factor to improve ondemand performance
From: Venkatesh Pallipadi <venki@google.com>
To: David C Niemi <dniemi@verisign.com>
Cc: cpufreq-list@vger.kernel.org, Dave Jones <davej@redhat.com>,
        Daniel Hollocher <danielhollocher@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 6, 2010 at 1:54 PM, David C Niemi <dniemi@verisign.com> wrote:
> Adds a new global tunable, sampling_down_factor.  Set to 1 it makes no
> changes from existing behavior, but set to greater than 1 (e.g. 100)
> it acts as a multiplier for the scheduling interval for reevaluating
> load when the CPU is at its top speed due to high load.  This improves
> performance by reducing the overhead of load evaluation and helping
> the CPU stay at its top speed when truly busy, rather than shifting
> back and forth in speed.  This tunable has no effect on behavior at
> lower speeds/lower CPU loads.
>
> This patch is against 2.6.36-rc6.
>
> This patch should help solve kernel bug 19672 "ondemand is slow".
>
> Signed-off-by: David Niemi <dniemi@verisign.com>
> CC: Venkatesh Pallipadi <venki@google.com>
> CC: Dave Jones <davej@redhat.com>
> CC: Daniel Hollocher <danielhollocher@gmail.com>
> CC: <cpufreq-list@vger.kernel.org>
> CC: <linux-kernel@vger.kernel.org>

Acked-by: Venkatesh Pallipadi <venki@google.com>

> ---
> cpufreq_ondemand.c |   42 +++++++++++++++++++++++++++++++++++++++++-
> 1 file changed, 41 insertions(+), 1 deletion(-)
>
> diff --git a/linux-2.6.36-rc6/drivers/cpufreq/cpufreq_ondemand.c.orig b/linux-2.6.36-rc6/drivers/cpufreq/cpufreq_ondemand.c
> index 7b50936..c631f27 100644
> --- a/linux-2.6.36-rc6/drivers/cpufreq/cpufreq_ondemand.c.orig
> +++ b/linux-2.6.36-rc6/drivers/cpufreq/cpufreq_ondemand.c
> @@ -30,6 +30,8 @@
>
>  #define DEF_FREQUENCY_DOWN_DIFFERENTIAL                (10)
>  #define DEF_FREQUENCY_UP_THRESHOLD             (80)
> +#define DEF_SAMPLING_DOWN_FACTOR               (1)
> +#define MAX_SAMPLING_DOWN_FACTOR               (100000)
>  #define MICRO_FREQUENCY_DOWN_DIFFERENTIAL      (3)
>  #define MICRO_FREQUENCY_UP_THRESHOLD           (95)
>  #define MICRO_FREQUENCY_MIN_SAMPLE_RATE                (10000)
> @@ -82,6 +84,7 @@ struct cpu_dbs_info_s {
>        unsigned int freq_lo;
>        unsigned int freq_lo_jiffies;
>        unsigned int freq_hi_jiffies;
> +       unsigned int rate_mult;
>        int cpu;
>        unsigned int sample_type:1;
>        /*
> @@ -108,10 +111,12 @@ static struct dbs_tuners {
>        unsigned int up_threshold;
>        unsigned int down_differential;
>        unsigned int ignore_nice;
> +       unsigned int sampling_down_factor;
>        unsigned int powersave_bias;
>        unsigned int io_is_busy;
>  } dbs_tuners_ins = {
>        .up_threshold = DEF_FREQUENCY_UP_THRESHOLD,
> +       .sampling_down_factor = DEF_SAMPLING_DOWN_FACTOR,
>        .down_differential = DEF_FREQUENCY_DOWN_DIFFERENTIAL,
>        .ignore_nice = 0,
>        .powersave_bias = 0,
> @@ -259,6 +264,7 @@ static ssize_t show_##file_name                                             \
>  show_one(sampling_rate, sampling_rate);
>  show_one(io_is_busy, io_is_busy);
>  show_one(up_threshold, up_threshold);
> +show_one(sampling_down_factor, sampling_down_factor);
>  show_one(ignore_nice_load, ignore_nice);
>  show_one(powersave_bias, powersave_bias);
>
> @@ -340,6 +346,29 @@ static ssize_t store_up_threshold(struct kobject *a, struct attribute *b,
>        return count;
>  }
>
> +static ssize_t store_sampling_down_factor(struct kobject *a,
> +                       struct attribute *b, const char *buf, size_t count)
> +{
> +       unsigned int input, j;
> +       int ret;
> +       ret = sscanf(buf, "%u", &input);
> +
> +       if (ret != 1 || input > MAX_SAMPLING_DOWN_FACTOR || input < 1)
> +               return -EINVAL;
> +       mutex_lock(&dbs_mutex);
> +       dbs_tuners_ins.sampling_down_factor = input;
> +
> +       /* Reset down sampling multiplier in case it was active */
> +       for_each_online_cpu(j) {
> +               struct cpu_dbs_info_s *dbs_info;
> +               dbs_info = &per_cpu(od_cpu_dbs_info, j);
> +               dbs_info->rate_mult = 1;
> +       }
> +       mutex_unlock(&dbs_mutex);
> +
> +       return count;
> +}
> +
>  static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
>                                      const char *buf, size_t count)
>  {
> @@ -401,6 +430,7 @@ static ssize_t store_powersave_bias(struct kobject *a, struct attribute *b,
>  define_one_global_rw(sampling_rate);
>  define_one_global_rw(io_is_busy);
>  define_one_global_rw(up_threshold);
> +define_one_global_rw(sampling_down_factor);
>  define_one_global_rw(ignore_nice_load);
>  define_one_global_rw(powersave_bias);
>
> @@ -409,6 +439,7 @@ static struct attribute *dbs_attributes[] = {
>        &sampling_rate_min.attr,
>        &sampling_rate.attr,
>        &up_threshold.attr,
> +       &sampling_down_factor.attr,
>        &ignore_nice_load.attr,
>        &powersave_bias.attr,
>        &io_is_busy.attr,
> @@ -562,6 +593,10 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
>
>        /* Check for frequency increase */
>        if (max_load_freq > dbs_tuners_ins.up_threshold * policy->cur) {
> +               /* If switching to max speed, apply sampling_down_factor */
> +               if (policy->cur < policy->max)
> +                       this_dbs_info->rate_mult =
> +                               dbs_tuners_ins.sampling_down_factor;
>                dbs_freq_increase(policy, policy->max);
>                return;
>        }
> @@ -584,6 +619,9 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
>                                (dbs_tuners_ins.up_threshold -
>                                 dbs_tuners_ins.down_differential);
>
> +               /* No longer fully busy, reset rate_mult */
> +               this_dbs_info->rate_mult = 1;
> +
>                if (freq_next < policy->min)
>                        freq_next = policy->min;
>
> @@ -607,7 +645,8 @@ static void do_dbs_timer(struct work_struct *work)
>        int sample_type = dbs_info->sample_type;
>
>        /* We want all CPUs to do sampling nearly on same jiffy */
> -       int delay = usecs_to_jiffies(dbs_tuners_ins.sampling_rate);
> +       int delay = usecs_to_jiffies(dbs_tuners_ins.sampling_rate
> +               * dbs_info->rate_mult);
>
>        if (num_online_cpus() > 1)
>                delay -= jiffies % delay;
> @@ -711,6 +750,7 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>                        }
>                }
>                this_dbs_info->cpu = cpu;
> +               this_dbs_info->rate_mult = 1;
>                ondemand_powersave_bias_init_cpu(cpu);
>                /*
>                 * Start the timerschedule work, when this governor
>
>
>
