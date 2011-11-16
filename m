Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab1KPLc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 06:32:26 -0500
Received: from mx2.parallels.com ([64.131.90.16]:33246 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755918Ab1KPLcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 06:32:25 -0500
Message-ID: <4EC39F27.7010202@parallels.com>
Date: Wed, 16 Nov 2011 09:31:51 -0200
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <a.p.zijlstra@chello.nl>, <jbottomley@parallels.com>,
        <cgroups@vger.kernel.org>
Subject: Re: [PATCH 1/4] Change cpustat fields to an array.
References: <1321372757-1581-1-git-send-email-glommer@parallels.com> <1321372757-1581-2-git-send-email-glommer@parallels.com> <4EC35115.9040209@google.com> <4EC39DA9.4030602@parallels.com>
In-Reply-To: <4EC39DA9.4030602@parallels.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.130.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I missed the other comments in this patch.

Here it goes:

On 11/16/2011 09:25 AM, Glauber Costa wrote:
>>> for_each_possible_cpu(i) {
>>> - user = cputime64_add(user, kstat_cpu(i).cpustat.user);
>>> - nice = cputime64_add(nice, kstat_cpu(i).cpustat.nice);
>>> - system = cputime64_add(system, kstat_cpu(i).cpustat.system);
>>> - idle = cputime64_add(idle, get_idle_time(i));
>>> - iowait = cputime64_add(iowait, get_iowait_time(i));
>>> - irq = cputime64_add(irq, kstat_cpu(i).cpustat.irq);
>>> - softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
>>> - steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
>>> - guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
>>> - guest_nice = cputime64_add(guest_nice,
>>> - kstat_cpu(i).cpustat.guest_nice);
>>> - sum += kstat_cpu_irqs_sum(i);
>>> - sum += arch_irq_stat_cpu(i);
>>> + user += kstat_cpu(i).cpustat[USER];
>>
>> Half the time cputime64_add is preserved, half the time this patch
>> converts it to a naked '+='. Admittedly no one seems to usefully define
>> cputime64_add but why the conversion / inconsistency?
>
> Because at least in this patchset of mine, cputime conversion is not a
> goal, but a side effect. I wanted cpustat to be an array of u64, so I
> converted users. There are some places in the code that still uses
> cputime64 for other variables, and those I kept untouched.
>
> That's to make the patch focused. The other variables can be easily
> converted if we see value on it.
Outside of sched.c I did miss some. Those I can chase and convert.

>>> +enum cpu_usage_stat {
>>> + USER,
>>> + NICE,
>>> + SYSTEM,
>>> + SOFTIRQ,
>>> + IRQ,
>>> + IDLE,
>>> + IOWAIT,
>>> + STEAL,
>>> + GUEST,
>>> + GUEST_NICE,
>>> + NR_STATS,
>>> };
>>
>> I suspect we want a more descriptive prefix here, e.g. CPUTIME_USER

Ok.

>>>
>>> /* Add user time to cpustat. */
>>> tmp = cputime_to_cputime64(cputime);
>>> +
>>> if (TASK_NICE(p)> 0)
>>
>> We now that these are actually fields this could be:
>> field = TASK_NICE(p) > 0 ? CPUTIME_NICE : CPUTIME_USER;

Yes, absolutely.

>>> @@ -3925,9 +3926,9 @@ static void account_guest_time(struct
>>> task_struct *p, cputime_t cputime,
>>> */
>>> static inline
>>> void __account_system_time(struct task_struct *p, cputime_t cputime,
>>> - cputime_t cputime_scaled, cputime64_t *target_cputime64)
>>> + cputime_t cputime_scaled, u64 *target_cputime64)
>>
>> Having cpustat be an array means we can drop the pointer here and pass
>> the id.

And that's precisely what I do on a later patch, with account_field. I 
can move that code here if you prefer.

