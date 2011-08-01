Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab1HABIY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 21:08:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:41795 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059Ab1HABIS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 21:08:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,297,1309762800"; 
   d="scan'208";a="34064828"
From: "Yung, Winson W" <winson.w.yung@intel.com>
To: Venkatesh Pallipadi <venki@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
        "Kanigeri, Hari K" <hari.k.kanigeri@intel.com>
Date: Sun, 31 Jul 2011 19:08:07 -0600
Subject: RE: [PATCH] [RFC] ondemand governor: dynamic cpufreq scaling with
 different CPUs
Thread-Topic: [PATCH] [RFC] ondemand governor: dynamic cpufreq scaling with
 different CPUs
Thread-Index: AcxOD/X7LyNz7JosR6+bQmb+zyGVGAB0ge6Q
Message-ID: <CAC4B8726E86A142B27A9E9A2F2F124701921EF878@rrsmsx505.amr.corp.intel.com>
References: <CAC4B8726E86A142B27A9E9A2F2F12470191AAD4C3@rrsmsx505.amr.corp.intel.com>
 <CABeCy1Zvt2rv6r5ea2Pum+2gCDYJS-A3-00_0U2+ZcWV_kip4A@mail.gmail.com>
In-Reply-To: <CABeCy1Zvt2rv6r5ea2Pum+2gCDYJS-A3-00_0U2+ZcWV_kip4A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Venki for the comment, here is my thoughts on the change:

Correct me if I am wrong, it is probably true on PC that hw (bios) coordination mode for p-state is better over sw coordination mode, however on smartphone/tablet devices, there is no BIOS, so sw coordination mode is the only choice.

I am not sure I can simplify the change inside do_dbs_timer per your comment, dbs_info is per cpu, how are other CPUs suppose to see cpu change without getting that CPU's dbs_info? That's why I store the cpu and dbs_timer interval info inside policy which shared by all CPUs.

Having said that, how to handle cpu hotplug is something that my patch didn't do. If I offline one cpu and then online it again, it will no longer participate do_dbs_timer call. The code to add it back to dbs_timer cpus list and use the same shared policy is somewhat complicated. I am hoping to get some better idea on this from the community.  

BTW, this delayed work queue problem should exist in both ondemand and conservative governors.

/Winson

>-----Original Message-----
>From: Venkatesh Pallipadi [mailto:venki@google.com]
>Sent: Friday, July 29, 2011 9:53 AM
>To: Yung, Winson W
>Cc: linux-kernel@vger.kernel.org; Van De Ven, Arjan
>Subject: Re: [PATCH] [RFC] ondemand governor: dynamic cpufreq scaling
>with different CPUs
>
>On Tue, Jul 26, 2011 at 10:22 AM, Yung, Winson W
><winson.w.yung@intel.com> wrote:
>>
>> with using delayed work queue inside ondemand governor, I came to
>> realize that there are certain scenarios the governor may not
>> re-adjust cpu frequency swiftly for some duration. Here is a
>> brief description of the problem:
>>
>> Currently when ondemand governor starts, it will create kthreads
>> for each CPU, something like kondemand/0, kondemand/1 and so on.
>> I found from ftrace that kondemand/0 is the only kthread that
>> handles all the CPU frequency dynamic cpu frequency scaling, other
>> kthread such as kondemand/1 is never used. I also confirmed this
>> by debugging through the kernel code.
>
>This is not universally true. You are seeing this because the platform
>is using SOFTWARE_COORDINATION mode for P-states. Most optimal in
>terms of overhead is HARDWARE_COORDINATION mode, and this used to be
>the recommended mode for platforms. And HW coordination is the
>(atleast used to be) the more common mode across platforms.
>Not sure whether this platform has SW coordination as a feature or bug?
>
>>
>> So if there is no timer fired on CPU-0 (i.e. CPU-0 in C6), hence
>> no deferrable timers will ever fired by kondemand/0 to sample all
>> CPU workload. Since it is the only kthread doing the CPU freqency
>> scaling for all CPUs, it is possible to enter in the situation
>> where CPU frequency scaling will stop working for some duration
>> until CPU-0 becomes not idle again.
>
>Yes. This will be a problem.
>But, I am not sure whether the added complexity with the change below
>to support the sub-optimal mode here. But, if we have a huge number of
>platforms that are using software coordination, then there may not be
>much of a choice here :(
>
>>
>> Signed-off-by: Hari K Kanigeri <hari.kkanigeri@intel.com>
>> ---
>>  drivers/cpufreq/cpufreq_ondemand.c |   93
>+++++++++++++++++++++++++++++++----
>>  include/linux/cpufreq.h            |    3 +
>>  2 files changed, 85 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/cpufreq/cpufreq_ondemand.c
>b/drivers/cpufreq/cpufreq_ondemand.c
>> index 891360e..b4f4f9d 100644
>> --- a/drivers/cpufreq/cpufreq_ondemand.c
>> +++ b/drivers/cpufreq/cpufreq_ondemand.c
>> @@ -541,6 +541,9 @@ static void dbs_check_cpu(struct cpu_dbs_info_s
>*this_dbs_info)
>>
>>  static void do_dbs_timer(struct work_struct *work)
>>  {
>> +       u64 old_time, new_do_dbs_time;
>> +       u64 saved_last_time;
>> +
>>        struct cpu_dbs_info_s *dbs_info =
>>                container_of(work, struct cpu_dbs_info_s, work.work);
>>        unsigned int cpu = dbs_info->cpu;
>> @@ -548,6 +551,41 @@ static void do_dbs_timer(struct work_struct *work)
>>
>>        int delay;
>>
>> +       new_do_dbs_time = get_jiffies_64();
>> +
>> +       /* Save a copy of last_do_dbs_time do_dbs_timer */
>> +
>> +       saved_last_time = atomic64_read(
>> +               &dbs_info->cur_policy->last_do_dbs_time);
>> +
>> +       /* If the last time do_dbs_timer ran is less than */
>> +       /* 'delay' delta from current time, one of other  */
>> +       /* CPUs is still handling cpufreq governoring for */
>> +       /* for all CPUs. */
>> +
>> +       if ((new_do_dbs_time - saved_last_time) <
>> +               dbs_info->cur_policy->last_delay) {
>> +
>> +               /* If do_dbs_time ran not long ago */
>> +               /* (delta is less than last_delay) */
>> +               /* then bail out because there is  */
>> +               /* no need to run so frequently.   */
>> +               goto do_exit;
>> +       }
>> +
>> +       old_time = atomic64_cmpxchg(&dbs_info->cur_policy-
>>last_do_dbs_time,
>> +                                       saved_last_time,
>new_do_dbs_time);
>> +
>> +       /* If old_time is not equal to saved_last_time, */
>> +       /* it means another CPU is calling do_dbs_time. */
>> +
>> +       if (old_time != saved_last_time)
>> +               goto do_exit;
>> +
>> +       /* Switch cpu saved in the policy */
>> +       if (dbs_info->cur_policy->cpu != cpu)
>> +               dbs_info->cur_policy->cpu = cpu;
>> +
>
>
>This seems somewhat complicated way to do this.. One simpler way could
>be to have a new atomic element in dbs_info that stores the current
>CPU among policy->cpus doing dbs_timers. By default it will be
>policy->cpu and when it goes idle it changes the variable to -1, so
>that any other CPU can nominate itself (using atomic cmpxchg). If it
>is still -1, then policy->cpu does the check anyway.
>
>>        mutex_lock(&dbs_info->timer_mutex);
>>
>>        /* Common NORMAL_SAMPLE setup */
>> @@ -559,6 +597,7 @@ static void do_dbs_timer(struct work_struct *work)
>>                        /* Setup timer for SUB_SAMPLE */
>>                        dbs_info->sample_type = DBS_SUB_SAMPLE;
>>                        delay = dbs_info->freq_hi_jiffies;
>> +                       dbs_info->cur_policy->last_delay = delay;
>>                } else {
>>                        /* We want all CPUs to do sampling nearly on
>>                         * same jiffy
>> @@ -566,14 +605,18 @@ static void do_dbs_timer(struct work_struct
>*work)
>>                        delay =
>usecs_to_jiffies(dbs_tuners_ins.sampling_rate
>>                                * dbs_info->rate_mult);
>>
>> -                       if (num_online_cpus() > 1)
>> +                       if (num_online_cpus() > 1) {
>>                                delay -= jiffies % delay;
>> +                               dbs_info->cur_policy->last_delay =
>delay;
>> +                       }
>>                }
>>        } else {
>>                __cpufreq_driver_target(dbs_info->cur_policy,
>>                        dbs_info->freq_lo, CPUFREQ_RELATION_H);
>>                delay = dbs_info->freq_lo_jiffies;
>> +               dbs_info->cur_policy->last_delay = delay;
>>        }
>> +do_exit:
>>        schedule_delayed_work_on(cpu, &dbs_info->work, delay);
>>        mutex_unlock(&dbs_info->timer_mutex);
>>  }
>> @@ -648,10 +691,12 @@ static int cpufreq_governor_dbs(struct
>cpufreq_policy *policy,
>>                                j_dbs_info->prev_cpu_nice =
>>                                                kstat_cpu(j).cpustat.ni
>ce;
>>                        }
>> +
>> +                       j_dbs_info->cpu = j;
>> +                       j_dbs_info->rate_mult = 1;
>> +                       ondemand_powersave_bias_init_cpu(j);
>>                }
>> -               this_dbs_info->cpu = cpu;
>> -               this_dbs_info->rate_mult = 1;
>> -               ondemand_powersave_bias_init_cpu(cpu);
>> +
>>                /*
>>                 * Start the timerschedule work, when this governor
>>                 * is used for first time
>> @@ -680,32 +725,58 @@ static int cpufreq_governor_dbs(struct
>cpufreq_policy *policy,
>>                }
>>                mutex_unlock(&dbs_mutex);
>>
>> -               mutex_init(&this_dbs_info->timer_mutex);
>> -               dbs_timer_init(this_dbs_info);
>> +               for_each_cpu(j, policy->cpus) {
>> +                       struct cpu_dbs_info_s *j_dbs_info;
>> +                       j_dbs_info = &per_cpu(od_cpu_dbs_info, j);
>> +                       mutex_init(&j_dbs_info->timer_mutex);
>> +                       dbs_timer_init(j_dbs_info);
>> +               }
>>                break;
>>
>>        case CPUFREQ_GOV_STOP:
>> -               dbs_timer_exit(this_dbs_info);
>> +               for_each_cpu(j, policy->cpus) {
>> +                       struct cpu_dbs_info_s *j_dbs_info;
>> +                       j_dbs_info = &per_cpu(od_cpu_dbs_info, j);
>> +                       dbs_timer_exit(j_dbs_info);
>> +               }
>>
>>                mutex_lock(&dbs_mutex);
>> -               mutex_destroy(&this_dbs_info->timer_mutex);
>> +
>> +               for_each_cpu(j, policy->cpus) {
>> +                       struct cpu_dbs_info_s *j_dbs_info;
>> +                       j_dbs_info = &per_cpu(od_cpu_dbs_info, j);
>> +                       mutex_destroy(&j_dbs_info->timer_mutex);
>> +               }
>> +
>>                dbs_enable--;
>>                mutex_unlock(&dbs_mutex);
>>                if (!dbs_enable)
>>                        sysfs_remove_group(cpufreq_global_kobject,
>>                                           &dbs_attr_group);
>> -
>>                break;
>>
>>        case CPUFREQ_GOV_LIMITS:
>> -               mutex_lock(&this_dbs_info->timer_mutex);
>> +               /* Since ondemand governor is no longer running on the
>*/
>> +               /* same CPU anymore,need to mutex_lock all timer_mutex
>*/
>> +               /* before calling __cpufreq_driver_target. */
>> +               for_each_cpu(j, policy->cpus) {
>> +                       struct cpu_dbs_info_s *j_dbs_info;
>> +                       j_dbs_info = &per_cpu(od_cpu_dbs_info, j);
>> +                       mutex_lock(&j_dbs_info->timer_mutex);
>
>Not sure why we need a lock on all policy->cpus mutexes here. Could as
>well be all policy->cpus use policy->cpu's mutex. No?
>
>
>> +               }
>> +
>>                if (policy->max < this_dbs_info->cur_policy->cur)
>>                        __cpufreq_driver_target(this_dbs_info-
>>cur_policy,
>>                                policy->max, CPUFREQ_RELATION_H);
>>                else if (policy->min > this_dbs_info->cur_policy->cur)
>>                        __cpufreq_driver_target(this_dbs_info-
>>cur_policy,
>>                                policy->min, CPUFREQ_RELATION_L);
>> -               mutex_unlock(&this_dbs_info->timer_mutex);
>> +
>> +               for_each_cpu(j, policy->cpus) {
>> +                       struct cpu_dbs_info_s *j_dbs_info;
>> +                       j_dbs_info = &per_cpu(od_cpu_dbs_info, j);
>> +                       mutex_unlock(&j_dbs_info->timer_mutex);
>> +               }
>>                break;
>>        }
>>        return 0;
>> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
>> index 11be48e..2295a35 100644
>> --- a/include/linux/cpufreq.h
>> +++ b/include/linux/cpufreq.h
>> @@ -106,6 +106,9 @@ struct cpufreq_policy {
>>
>>        struct kobject          kobj;
>>        struct completion       kobj_unregister;
>> +
>> +       atomic64_t              last_do_dbs_tim;
>> +       int                     last_delay;
>>  };
>>
>>  #define CPUFREQ_ADJUST         (0)
>> --
>> 1.7.1
>>
