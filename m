Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab1ITMiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 08:38:24 -0400
Received: from mx2.parallels.com ([64.131.90.16]:55410 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003Ab1ITMiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 08:38:24 -0400
Message-ID: <4E78890D.1000607@parallels.com>
Date: Tue, 20 Sep 2011 09:37:33 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, <xemul@parallels.com>,
        <paul@paulmenage.org>, <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <mingo@elte.hu>, <jbottomley@parallels.com>
Subject: Re: [PATCH 8/9] per-cgroup boot time
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>  <1316030695-19826-9-git-send-email-glommer@parallels.com> <1316510746.11841.18.camel@twins>
In-Reply-To: <1316510746.11841.18.camel@twins>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.134.226]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2011 06:25 AM, Peter Zijlstra wrote:
> On Wed, 2011-09-14 at 17:04 -0300, Glauber Costa wrote:
>> Record the time in which the cgroup was created. This can be
>> used to provide a more accurate boottime information in
>> cpuacct.proc.stat.
>>
>> Signed-off-by: Glauber Costa<glommer@parallels.com>
>> ---
>>   kernel/sched.c |    8 +++++++-
>>   1 files changed, 7 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index 4611c54..8f254d0 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -9120,6 +9120,7 @@ struct cpuacct {
>>   	/* cpuusage holds pointer to a u64-type object on every cpu */
>>   	u64 __percpu *cpuusage;
>>   	u64 __percpu *cpustat;
>> +	struct timespec start_time;
>>   };
>>
>>   struct cgroup_subsys cpuacct_subsys;
>> @@ -9172,6 +9173,8 @@ static struct cgroup_subsys_state *cpuacct_create(
>>   		acct[CPUACCT_STAT_IDLE] = kstat_cpu(i).cpustat.idle;
>>   		acct[CPUACCT_STAT_IOWAIT] = kstat_cpu(i).cpustat.iowait;
>>   	}
>> +
>> +	get_monotonic_boottime(&ca->start_time);
>>   	return&ca->css;
>>
>>   out_free_usage:
>> @@ -9316,13 +9319,16 @@ static int cpuacct_proc_stat(struct cgroup *cgrp, struct cftype *cft,
>>   	unsigned int per_softirq_sums[NR_SOFTIRQS] = {0};
>>   	struct timespec boottime;
>>   	struct cpuacct *ca = cgroup_ca(cgrp);
>> +	struct timespec ts;
>>   	u64 *cpustat;
>>
>>   	user = nice = system = idle = iowait =
>>   		irq = softirq = steal = cputime64_zero;
>>   	guest = guest_nice = cputime64_zero;
>>   	getboottime(&boottime);
>> -	jif = boottime.tv_sec;
>> +	getboottime(&boottime);
>> +	ts = timespec_add(boottime, ca->start_time);
>> +	jif = ts.tv_sec;
>>
>>   	for_each_possible_cpu(i) {
>>   		cpustat = per_cpu_ptr(ca->cpustat, i);
>
>
> I'm confused, what does it do? You take a boot time timestamp at cgroup
> creation, add that to all boot-time readings and print the result. How
> does that make sense? Subtracting the start_time, maybe, that would make
> the cgroup creation time 0, adding, not so much.

Boot time represent at which times the machine was booted. In this 
context, at which time the container/cgroup was created. So it have to 
be an addition.... don't really understand your question
