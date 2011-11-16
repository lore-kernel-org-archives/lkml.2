Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab1KPLf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 06:35:29 -0500
Received: from mx2.parallels.com ([64.131.90.16]:48258 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755990Ab1KPLf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 06:35:27 -0500
Message-ID: <4EC39FDD.10207@parallels.com>
Date: Wed, 16 Nov 2011 09:34:53 -0200
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <a.p.zijlstra@chello.nl>, <jbottomley@parallels.com>,
        <cgroups@vger.kernel.org>
Subject: Re: [PATCH 2/4] split kernel stat in two
References: <1321372757-1581-1-git-send-email-glommer@parallels.com> <1321372757-1581-3-git-send-email-glommer@parallels.com> <4EC3545C.60602@google.com>
In-Reply-To: <4EC3545C.60602@google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.130.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2011 04:12 AM, Paul Turner wrote:
> On 11/15/2011 07:59 AM, Glauber Costa wrote:
>> In a later patch, we will use cpustat information per-task group.
>> However, some of its fields are naturally global, such as the irq
>> counters. There is no need to impose the task group overhead to them
>> in this case. So better separate them.
>>
>> Signed-off-by: Glauber Costa<glommer@parallels.com>
>> CC: Paul Tuner<pjt@google.com>
>> ---
>> arch/s390/appldata/appldata_os.c | 16 +++++++-------
>> arch/x86/include/asm/i387.h | 2 +-
>> drivers/cpufreq/cpufreq_conservative.c | 20 ++++++++--------
>> drivers/cpufreq/cpufreq_ondemand.c | 20 ++++++++--------
>> drivers/macintosh/rack-meter.c | 6 ++--
>> fs/proc/stat.c | 36 ++++++++++++++++----------------
>> include/linux/kernel_stat.h | 8 ++++++-
>> kernel/sched.c | 18 ++++++++-------
>> 8 files changed, 67 insertions(+), 59 deletions(-)
>>
>> diff --git a/arch/s390/appldata/appldata_os.c
>> b/arch/s390/appldata/appldata_os.c
>> index 3d6b672..695388a 100644
>> --- a/arch/s390/appldata/appldata_os.c
>> +++ b/arch/s390/appldata/appldata_os.c
>> @@ -115,21 +115,21 @@ static void appldata_get_os_data(void *data)
>> j = 0;
>> for_each_online_cpu(i) {
>> os_data->os_cpu[j].per_cpu_user =
>> - cputime_to_jiffies(kstat_cpu(i).cpustat[USER]);
>> + cputime_to_jiffies(kcpustat_cpu(i).cpustat[USER]);
>> os_data->os_cpu[j].per_cpu_nice =
>> - cputime_to_jiffies(kstat_cpu(i).cpustat[NICE]);
>> + cputime_to_jiffies(kcpustat_cpu(i).cpustat[NICE]);
>> os_data->os_cpu[j].per_cpu_system =
>> - cputime_to_jiffies(kstat_cpu(i).cpustat[SYSTEM]);
>> + cputime_to_jiffies(kcpustat_cpu(i).cpustat[SYSTEM]);
>> os_data->os_cpu[j].per_cpu_idle =
>> - cputime_to_jiffies(kstat_cpu(i).cpustat[IDLE]);
>> + cputime_to_jiffies(kcpustat_cpu(i).cpustat[IDLE]);
>> os_data->os_cpu[j].per_cpu_irq =
>> - cputime_to_jiffies(kstat_cpu(i).cpustat[IRQ]);
>> + cputime_to_jiffies(kcpustat_cpu(i).cpustat[IRQ]);
>> os_data->os_cpu[j].per_cpu_softirq =
>> - cputime_to_jiffies(kstat_cpu(i).cpustat[SOFTIRQ]);
>> + cputime_to_jiffies(kcpustat_cpu(i).cpustat[SOFTIRQ]);
>> os_data->os_cpu[j].per_cpu_iowait =
>> - cputime_to_jiffies(kstat_cpu(i).cpustat[IOWAIT]);
>> + cputime_to_jiffies(kcpustat_cpu(i).cpustat[IOWAIT]);
>> os_data->os_cpu[j].per_cpu_steal =
>> - cputime_to_jiffies(kstat_cpu(i).cpustat[STEAL]);
>> + cputime_to_jiffies(kcpustat_cpu(i).cpustat[STEAL]);
>> os_data->os_cpu[j].cpu_id = i;
>> j++;
>> }
>> diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
>> index 56fa4d7..1f1b536 100644
>> --- a/arch/x86/include/asm/i387.h
>> +++ b/arch/x86/include/asm/i387.h
>> @@ -218,7 +218,7 @@ static inline void fpu_fxsave(struct fpu *fpu)
>> #ifdef CONFIG_SMP
>> #define safe_address (__per_cpu_offset[0])
>> #else
>> -#define safe_address (kstat_cpu(0).cpustat[USER])
>> +#define safe_address (__get_cpu_var(kernel_cpustat).cpustat[USER])
>> #endif
>>
>> /*
>> diff --git a/drivers/cpufreq/cpufreq_conservative.c
>> b/drivers/cpufreq/cpufreq_conservative.c
>> index 2ab538f..a3a739f 100644
>> --- a/drivers/cpufreq/cpufreq_conservative.c
>> +++ b/drivers/cpufreq/cpufreq_conservative.c
>> @@ -103,13 +103,13 @@ static inline cputime64_t
>> get_cpu_idle_time_jiffy(unsigned int cpu,
>> cputime64_t busy_time;
>>
>> cur_wall_time = jiffies64_to_cputime64(get_jiffies_64());
>> - busy_time = cputime64_add(kstat_cpu(cpu).cpustat[USER],
>> - kstat_cpu(cpu).cpustat[SYSTEM]);
>> + busy_time = cputime64_add(kcpustat_cpu(cpu).cpustat[USER],
>> + kcpustat_cpu(cpu).cpustat[SYSTEM]);
>>
>> - busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat[IRQ]);
>> - busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat[SOFTIRQ]);
>> - busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat[STEAL]);
>> - busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat[NICE]);
>> + busy_time = cputime64_add(busy_time, kcpustat_cpu(cpu).cpustat[IRQ]);
>> + busy_time = cputime64_add(busy_time,
>> kcpustat_cpu(cpu).cpustat[SOFTIRQ]);
>> + busy_time = cputime64_add(busy_time, kcpustat_cpu(cpu).cpustat[STEAL]);
>> + busy_time = cputime64_add(busy_time, kcpustat_cpu(cpu).cpustat[NICE]);
>>
>
> This clobbers almost *all* the same lines as the last patch. There has
> to be a more readable way of structuring these 2 patches.

Yes, there is: Merging them in the same patch. But I preferred to keep 
them logically separated. One of them brings index access, the other, 
changes the macro name. I think this is more important than the eventual 
clobber, but let me know your preference.

>> -struct kernel_stat {
>> +struct kernel_cpustat {
>> u64 cpustat[NR_STATS];
>> +};
>> +
>> +struct kernel_stat {
>> #ifndef CONFIG_GENERIC_HARDIRQS
>> unsigned int irqs[NR_IRQS];
>> #endif
>> @@ -40,10 +43,13 @@ struct kernel_stat {
>> };
>>
>> DECLARE_PER_CPU(struct kernel_stat, kstat);
>> +DECLARE_PER_CPU(struct kernel_cpustat, kernel_cpustat);
>>
>> /* Must have preemption disabled for this to be meaningful. */
>> #define kstat_this_cpu (&__get_cpu_var(kstat))
>> +#define kcpustat_this_cpu (&__get_cpu_var(kernel_cpustat))
>> #define kstat_cpu(cpu) per_cpu(kstat, cpu)
>> +#define kcpustat_cpu(cpu) per_cpu(kernel_cpustat, cpu)
>>
>> extern unsigned long long nr_context_switches(void);
>>
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index 7ac5aa6..efdd4d8 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -2158,7 +2158,7 @@ static void update_rq_clock_task(struct rq *rq,
>> s64 delta)
>> #ifdef CONFIG_IRQ_TIME_ACCOUNTING
>> static int irqtime_account_hi_update(void)
>> {
>> - u64 *cpustat = kstat_this_cpu->cpustat;
>> + u64 *cpustat = kcpustat_this_cpu->cpustat;
>> unsigned long flags;
>> u64 latest_ns;
>> int ret = 0;
>> @@ -2173,7 +2173,7 @@ static int irqtime_account_hi_update(void)
>>
>> static int irqtime_account_si_update(void)
>> {
>> - u64 *cpustat = kstat_this_cpu->cpustat;
>> + u64 *cpustat = kcpustat_this_cpu->cpustat;
>> unsigned long flags;
>> u64 latest_ns;
>> int ret = 0;
>> @@ -3803,8 +3803,10 @@ unlock:
>> #endif
>>
>> DEFINE_PER_CPU(struct kernel_stat, kstat);
>> +DEFINE_PER_CPU(struct kernel_cpustat, kernel_cpustat);
>>
>> EXPORT_PER_CPU_SYMBOL(kstat);
>> +EXPORT_PER_CPU_SYMBOL(kernel_cpustat);
>
> This would want a big fat comment explaining the difference.
>
Fair.


