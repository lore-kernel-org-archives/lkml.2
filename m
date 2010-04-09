Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab0DIUui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 16:50:38 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:39052 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab0DIUuf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 16:50:35 -0400
MIME-Version: 1.0
In-Reply-To: <201004091147.32505.trenn@suse.de>
References: <1270603319-28907-1-git-send-email-mike@android.com>
	 <201004091147.32505.trenn@suse.de>
Date: Fri, 9 Apr 2010 13:50:33 -0700
Message-ID: <k2m8bb80c381004091350oa2dd702bk2e9647453c59d645@mail.gmail.com>
Subject: Re: [PATCH] sched: cpuacct: Track cpuusage for CPU frequencies
From: Mike Chan <mike@android.com>
To: Thomas Renninger <trenn@suse.de>
Cc: menage@google.com, balbir@linux.vnet.ibm.com, dwalker@fifo99.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/4/9 Thomas Renninger <trenn@suse.de>:
> On Wednesday 07 April 2010 03:21:59 Mike Chan wrote:
>> New file: cpuacct.cpufreq when CONFIG_CPU_FREQ_STATS is enabled.
>>
>> cpuacct.cpufreq reports the CPU time (nanoseconds) spent at each CPU frequency
>>
>> Maximum number of frequencies supported is 32. As future architectures are
>> added that support more than 32 frequency levels, CPUFREQ_TABLE_MAX in sched.c
>> needs to be updated.
> Why is accounting of each frequency needed?

The intent is to track time spent at each cpu frequency to measure
power consumption. Userspace can figure out the mapping between
frequency and power consumption. This is also a useful indication of
what kind of hw performance userspace apps need (does Chrome really
need 1ghz?).

Paul Menage had suggested an integral earlier in my [RFC] patch. I
wasn't completely against the idea but it had a few shortcomings that
I couldn't think of decent solutions for. You would have to either
pre-define power consumption for the cpu frequences per-arch or board
file. Or have a way to calculate.

> pcc-cpufreq driver can do every frequency in a range and supports hundreds of
> different frequencies, thus it does not depend on CPU_FREQ_TABLE.
> Would the average frequency be enough to track/account?

Humm, this is a tricky case we haven't yet run into for ARM. Average
frequency might not be too useful because power is not linear with
speed. We could possibly have buckets for speeds (hi/lo).

> This would avoid the static interface of listing each available freq.
> It would also count "boosted" frequency case which is avail on most recent
> X86 cpus.
>
>> Signed-off-by: Mike Chan <mike@android.com>
>> ---
>>  Documentation/cgroups/cpuacct.txt |    3 +
>>  kernel/sched.c                    |  112 +++++++++++++++++++++++++++++++++++++
>>  2 files changed, 115 insertions(+), 0 deletions(-)
> ...
>>  static int cpuacct_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
>> @@ -9031,6 +9132,17 @@ static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
>>
>>       for (; ca; ca = ca->parent) {
>>               u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
>> +#ifdef CONFIG_CPU_FREQ_STAT
>> +             struct cpufreq_table *cpufreq_table =
>> +                     per_cpu_ptr(ca->cpufreq_table, cpu);
>> +
>> +             if (cpufreq_index > CPUFREQ_TABLE_MAX)
>> +                     printk_once(KERN_WARNING "cpuacct_charge: "
>> +                                     "cpufreq_index: %d exceeds max table "
>> +                                     "size\n", cpufreq_index);
>> +             else
>> +                     cpufreq_table->freq[cpufreq_index] += cputime;
>> +#endif
> Can the frequency change somewhere in the middle between cpuacct_charge is
> called?
> What guarantees that the task run at cpufreq_table->freq[cpufreq_index]
> all the time?
>

Ah, good catch, it doesn't. What we can do is register a callback for
a cpu frequency transition notifier. I can fix this up in a v2.

-- Mike

>     Thomas
>
>>               *cpuusage += cputime;
>>       }
>>
>> --
>
