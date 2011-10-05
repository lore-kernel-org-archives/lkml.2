Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934590Ab1JEMLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 08:11:53 -0400
Received: from mx2.parallels.com ([64.131.90.16]:45396 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934503Ab1JEMLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 08:11:51 -0400
Message-ID: <4E8C4963.5030803@parallels.com>
Date: Wed, 5 Oct 2011 16:11:15 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <jbottomley@parallels.com>
Subject: Re: [PATCH 04/10] Display /proc/stat information per cgroup
References: <1317583287-18300-1-git-send-email-glommer@parallels.com>  <1317583287-18300-5-git-send-email-glommer@parallels.com> <1317805495.6766.5.camel@twins>
In-Reply-To: <1317805495.6766.5.camel@twins>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2011 01:04 PM, Peter Zijlstra wrote:
> On Sun, 2011-10-02 at 23:21 +0400, Glauber Costa wrote:
>> @@ -3868,10 +3897,14 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
>>    */
>>   void account_steal_time(cputime_t cputime)
>>   {
>> -       u64 *cpustat = kstat_this_cpu->cpustat;
>> +       struct kernel_stat *kstat;
>>          u64 cputime64 = cputime_to_cputime64(cputime);
>> -
>> -       cpustat[STEAL] += cputime64;
>> +#ifdef CONFIG_CGROUP_SCHED
>> +       kstat = this_cpu_ptr(root_task_group.cpustat);
>> +#else
>> +       kstat = __get_cpu_var(kstat);
>> +#endif
>> +       kstat->cpustat[STEAL] += cputime64;
>>   }
>
>> @@ -9111,17 +9179,28 @@ int cpu_cgroup_proc_stat(struct seq_file *p)
>>          jif = boottime.tv_sec;
>>
>>          for_each_possible_cpu(i) {
>> -               user += kstat_this_cpu->cpustat[USER];
>> -               nice += kstat_this_cpu->cpustat[NICE];
>> -               system += kstat_this_cpu->cpustat[SYSTEM];
>> -               idle += kstat_this_cpu->cpustat[IDLE];
>> +               struct kernel_stat *kstat, *idle_kstat;
>> +#ifdef CONFIG_CGROUP_SCHED
>> +               kstat = per_cpu_ptr(tg->cpustat, i);
>> +               idle_kstat = per_cpu_ptr(root_task_group.cpustat, i);
>> +#else
>> +               kstat = per_cpu(kstat, i);
>> +               idle_kstat = kstat;
>> +#endif
>> +
>> +               user += kstat->cpustat[USER];
>> +               nice += kstat->cpustat[NICE];
>> +               system += kstat->cpustat[SYSTEM];
>
> That if-deffery just begs to be killed by some helper function. Both
> variants appear multiple times I think.
Okay, I will clean this up for next submission.

