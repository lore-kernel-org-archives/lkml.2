Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab2B1AjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 19:39:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51021 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab2B1AjS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 19:39:18 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of myungjoo.ham@gmail.com designates 10.50.88.161 as permitted sender) smtp.mail=myungjoo.ham@gmail.com; dkim=pass header.i=myungjoo.ham@gmail.com
MIME-Version: 1.0
In-Reply-To: <201202260047.16127.rjw@sisk.pl>
References: <CAJ0PZbSODSJvV-_Gje9Hm9Ek22Z9m+PAcsf071OCmAOtsnKzyg@mail.gmail.com>
	<1329897815-15871-3-git-send-email-myungjoo.ham@samsung.com>
	<20120225113005.GC16932@elf.ucw.cz>
	<201202260047.16127.rjw@sisk.pl>
Date: Tue, 28 Feb 2012 09:39:17 +0900
Message-ID: <CAJ0PZbTP5t9krrPi83EP5qziWbLkW4GtJpMQKM2OznzzNZd3GQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] CPUfreq ondemand: handle QoS request on DVFS
 response latency
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Dave Jones <davej@redhat.com>, Len Brown <len.brown@intel.com>,
        Kevin Hilman <khilman@ti.com>, Jean Pihet <j-pihet@ti.com>,
        markgross <markgross@thegnar.org>, kyungmin.park@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 26, 2012 at 8:47 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday, February 25, 2012, Pavel Machek wrote:
>> On Wed 2012-02-22 17:03:35, MyungJoo Ham wrote:
>> > With QoS class, DVFS_RESPONSE_LATENCY, users (device drivers and
>> > userspace processes) may express the desired maximum response latency
>> > from DVFS mechanisms such as CPUfreq's ondemand governors. Based on such
>> > QoS requests, the ondemand governor may flexibly adjust sampling rate
>> > accordingly unless it goes below the min_sampling_rate.
>> >
>> > The benefit of having DVFS_RESPONSE_LATENCY is to have faster response
>> > from user inputs (mouse clicks, keyboard inputs, touchscreen touches,
>> > and others) without increasing frequency unconditionally. Because some
>> > input events may not require any performance increases, increasing the
>> > frequency unconditionally for inputs may simply consume too much energy.
>> > Adjusting sampling rate based on user inputs enabled to increase
>> > frequency with less latency if it requires and not to increase frequency
>> > if it does not require.
>> >
>> > Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
>> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> >
>> > --
>> > This patch depends on the patch
>> > "PM / QoS: Introduce new classes: DMA-Throughput and DVFS-Latency".
>> > and the patch
>> > "CPUfreq ondemand: update sampling rate without waiting for next
>> > sampling"
>> > ---
>> >  drivers/cpufreq/cpufreq_ondemand.c |  108 ++++++++++++++++++++++++++++++++----
>> >  1 files changed, 96 insertions(+), 12 deletions(-)
>> >
>> > diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
>> > index 2d66649..b9188f1 100644
>> > --- a/drivers/cpufreq/cpufreq_ondemand.c
>> > +++ b/drivers/cpufreq/cpufreq_ondemand.c
>> > @@ -22,6 +22,7 @@
>> >  #include <linux/tick.h>
>> >  #include <linux/ktime.h>
>> >  #include <linux/sched.h>
>> > +#include <linux/pm_qos.h>
>> >
>> >  /*
>> >   * dbs is used in this file as a shortform for demandbased switching
>> > @@ -93,6 +94,7 @@ struct cpu_dbs_info_s {
>> >      * when user is changing the governor or limits.
>> >      */
>> >     struct mutex timer_mutex;
>> > +   bool activated; /* dbs_timer_init is in effect */
>> >  };
>> >  static DEFINE_PER_CPU(struct cpu_dbs_info_s, od_cpu_dbs_info);
>> >
>> > @@ -111,6 +113,8 @@ static struct dbs_tuners {
>> >     unsigned int sampling_down_factor;
>> >     unsigned int powersave_bias;
>> >     unsigned int io_is_busy;
>> > +   struct notifier_block dvfs_lat_qos_db;
>> > +   unsigned int dvfs_lat_qos_wants;
>> >  } dbs_tuners_ins = {
>> >     .up_threshold = DEF_FREQUENCY_UP_THRESHOLD,
>> >     .sampling_down_factor = DEF_SAMPLING_DOWN_FACTOR,
>> > @@ -164,6 +168,23 @@ static inline cputime64_t get_cpu_iowait_time(unsigned int cpu, cputime64_t *wal
>> >  }
>> >
>> >  /*
>> > + * Find right sampling rate based on sampling_rate and
>> > + * QoS requests on dvfs latency.
>> > + */
>> > +static unsigned int effective_sampling_rate(void)
>> > +{
>> > +   unsigned int effective;
>> > +
>> > +   if (dbs_tuners_ins.dvfs_lat_qos_wants)
>> > +           effective = min(dbs_tuners_ins.dvfs_lat_qos_wants,
>> > +                           dbs_tuners_ins.sampling_rate);
>> > +   else
>> > +           effective = dbs_tuners_ins.sampling_rate;
>> > +
>> > +   return max(effective, min_sampling_rate);
>> > +}
>> > +
>> > +/*
>> >   * Find right freq to be set now with powersave_bias on.
>> >   * Returns the freq_hi to be used right now and will set freq_hi_jiffies,
>> >   * freq_lo, and freq_lo_jiffies in percpu area for averaging freqs.
>> > @@ -207,7 +228,7 @@ static unsigned int powersave_bias_target(struct cpufreq_policy *policy,
>> >             dbs_info->freq_lo_jiffies = 0;
>> >             return freq_lo;
>> >     }
>> > -   jiffies_total = usecs_to_jiffies(dbs_tuners_ins.sampling_rate);
>> > +   jiffies_total = usecs_to_jiffies(effective_sampling_rate());
>> >     jiffies_hi = (freq_avg - freq_lo) * jiffies_total;
>> >     jiffies_hi += ((freq_hi - freq_lo) / 2);
>> >     jiffies_hi /= (freq_hi - freq_lo);
>> > @@ -259,7 +280,8 @@ show_one(powersave_bias, powersave_bias);
>> >
>> >  /**
>> >   * update_sampling_rate - update sampling rate effective immediately if needed.
>> > - * @new_rate: new sampling rate
>> > + * @new_rate: new sampling rate. if it is 0, regard sampling rate is not
>> > + *         changed and assume that qos request value is changed.
>> >   *
>> >   * If new rate is smaller than the old, simply updaing
>> >   * dbs_tuners_int.sampling_rate might not be appropriate. For example,
>> > @@ -273,9 +295,13 @@ show_one(powersave_bias, powersave_bias);
>> >  static void update_sampling_rate(unsigned int new_rate)
>> >  {
>> >     int cpu;
>> > +   unsigned int effective;
>> > +
>> > +
>> > +   if (new_rate)
>> > +           dbs_tuners_ins.sampling_rate = max(new_rate, min_sampling_rate);
>> >
>> > -   dbs_tuners_ins.sampling_rate = new_rate
>> > -                                = max(new_rate, min_sampling_rate);
>> > +   effective = effective_sampling_rate();
>> >
>> >     for_each_online_cpu(cpu) {
>> >             struct cpufreq_policy *policy;
>> > @@ -283,21 +309,31 @@ static void update_sampling_rate(unsigned int new_rate)
>> >             struct timer_list *timer;
>> >             unsigned long appointed_at;
>> >
>> > +           /*
>> > +            * mutex_destory(&dbs_info->timer_mutex) should not happen
>> > +            * in this context.
>> > +            */
>> > +           mutex_lock(&dbs_mutex);
>> > +
>> >             policy = cpufreq_cpu_get(cpu);
>> >             if (!policy)
>> > -                   continue;
>> > +                   goto next;
>> >             dbs_info = &per_cpu(od_cpu_dbs_info, policy->cpu);
>> >             cpufreq_cpu_put(policy);
>> >
>> > +           /* timer_mutex destroyed or will be destoyed soon */
>> > +           if (!dbs_info->activated)
>> > +                   goto next;
>> > +
>> >             mutex_lock(&dbs_info->timer_mutex);
>> >
>> >             if (!delayed_work_pending(&dbs_info->work))
>> > -                   goto next;
>> > +                   goto next_timer_mutex;
>> >
>> >             timer = &dbs_info->work.timer;
>> >             appointed_at = timer->expires;
>> >
>> > -           if (time_before(jiffies + usecs_to_jiffies(new_rate),
>> > +           if (time_before(jiffies + usecs_to_jiffies(effective),
>> >                             appointed_at)) {
>> >
>> >                     mutex_unlock(&dbs_info->timer_mutex);
>> > @@ -305,12 +341,15 @@ static void update_sampling_rate(unsigned int new_rate)
>> >                     mutex_lock(&dbs_info->timer_mutex);
>> >
>> >                     schedule_delayed_work_on(dbs_info->cpu, &dbs_info->work,
>> > -                                            usecs_to_jiffies(new_rate));
>> > +                                            usecs_to_jiffies(effective));
>> >
>> >             }
>> > -next:
>> > +next_timer_mutex:
>> >             mutex_unlock(&dbs_info->timer_mutex);
>> > +next:
>> > +           mutex_unlock(&dbs_mutex);
>> >     }
>> > +
>> >  }
>>
>> I don't think gotos are helpful here. Can you use normal program
>> structure or move it to subroutine...?
>
> I agree with Pavel that gotos don't make that code particularly clear.
>
> Thanks,
> Rafael

Ok, I'll let it use a normal if/then/else structure there.

Thanks.


Cheers!
MyungJoo.

-- 
MyungJoo Ham, Ph.D.
System S/W Lab, S/W Center, Samsung Electronics
