Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934603Ab1JEMXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 08:23:36 -0400
Received: from mx2.parallels.com ([64.131.90.16]:53341 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934310Ab1JEMXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 08:23:35 -0400
Message-ID: <4E8C4C23.8000007@parallels.com>
Date: Wed, 5 Oct 2011 16:22:59 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <jbottomley@parallels.com>, Balbir Singh <bsingharora@gmail.com>,
        Paul Turner <pjt@google.com>
Subject: Re: [PATCH 09/10] provide a version of cpuusage statistics inside
 cpu cgroup
References: <1317583287-18300-1-git-send-email-glommer@parallels.com>  <1317583287-18300-10-git-send-email-glommer@parallels.com> <1317807988.6766.10.camel@twins>
In-Reply-To: <1317807988.6766.10.camel@twins>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2011 01:46 PM, Peter Zijlstra wrote:
> On Sun, 2011-10-02 at 23:21 +0400, Glauber Costa wrote:
>> +/*
>> + * charge this task's execution time to its accounting group.
>> + *
>> + * called with rq->lock held.
>> + */
>> +static void cpuusage_charge(struct task_struct *tsk, u64 cputime)
>> +{
>> +       int cpu;
>> +
>> +#ifdef CONFIG_CGROUP_CPUACCT
>> +       struct cpuacct *ca;
>> +#endif
>> +#ifdef CONFIG_CGROUP_SCHED
>> +       struct task_group *tg;
>> +#endif
>> +       cpu = task_cpu(tsk);
>> +
>> +       rcu_read_lock();
>> +
>> +#ifdef CONFIG_CGROUP_CPUACCT
>> +       ca = task_ca(tsk);
>> +
>> +       if (unlikely(!cpuacct_subsys.active))
>> +               goto no_cpuacct;
>> +
>> +       for (; ca; ca = ca->parent) {
>> +               u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
>> +               *cpuusage += cputime;
>> +       }
>> +no_cpuacct:
>> +#endif
>> +
>> +#ifdef CONFIG_CGROUP_SCHED
>> +       tg = task_group(tsk);
>> +       for (; tg; tg = tg->parent) {
>> +               u64 *cpuusage = per_cpu_ptr(tg->cpuusage, cpu);
>> +               *cpuusage += cputime;
>> +       }
>> +#endif
>> +       rcu_read_unlock();
>> +}
>
> I don't actually think we need to do this. tg->se[cpu]->sum_exec_runtime
> should contain the same information.

Well,

We should at least sum up se and rt_se, right?
Otherwise... I will re-read the code, but from a first sight, I think 
you are right.



