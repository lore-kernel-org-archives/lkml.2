Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab1DDXL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 19:11:27 -0400
Received: from smtp-out.google.com ([216.239.44.51]:62460 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab1DDXLY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 19:11:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=qII0AfRybQLcSawWQbzI7xCIXo3KHFeCqdC6I/01tGdjSCfHHWqGHiIztCOqYR9q9x
         xom4wjl9OTYy+2e8NHhA==
MIME-Version: 1.0
In-Reply-To: <4D9182F0.2020404@jp.fujitsu.com>
References: <20110323030326.789836913@google.com> <20110323030448.853861319@google.com>
 <4D9182F0.2020404@jp.fujitsu.com>
From: Paul Turner <pjt@google.com>
Date: Mon, 4 Apr 2011 16:10:52 -0700
Message-ID: <BANLkTinnZV1EspftqcteVYBRn3KYjZs-TA@mail.gmail.com>
Subject: Re: [patch 02/15] sched: validate CFS quota hierarchies
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 11:57 PM, Hidetoshi Seto
<seto.hidetoshi@jp.fujitsu.com> wrote:
> (2011/03/23 12:03), Paul Turner wrote:
>> @@ -9251,7 +9255,13 @@ static int tg_set_cfs_bandwidth(struct t
>>       if (period > max_cfs_quota_period)
>>               return -EINVAL;
>>
>> -     mutex_lock(&mutex);
>> +     mutex_lock(&cfs_constraints_mutex);
>> +     if (sysctl_sched_cfs_bandwidth_consistent) {
>> +             ret = __cfs_schedulable(tg, period, quota);
>
> At this point:
>  period => scale in ns unit
>  quota  => scale in ns unit, or RUNTIME_INF
>
> And both are unsigned. But...

Ack.. I had accounted for this at one point but I obviously churned it out.

Good catch, thanks!


>
>> @@ -9339,6 +9350,108 @@ static int cpu_cfs_period_write_u64(stru
>>       return tg_set_cfs_period(cgroup_tg(cgrp), cfs_period_us);
>>  }
>>
>> +
>> +struct cfs_schedulable_data {
>> +     struct task_group *tg;
>> +     u64 period, quota;
>> +};
>> +
>> +/*
>> + * normalize group quota/period to be quota/max_period
>> + * note: units are usecs
>> + */
>> +static u64 normalize_cfs_quota(struct task_group *tg,
>> +                            struct cfs_schedulable_data *d)
>> +{
>> +     u64 quota, period;
>> +     struct load_weight lw;
>> +
>> +     if (tg == d->tg) {
>> +             period = d->period;
>> +             quota = d->quota;
>> +     } else {
>> +             period = tg_get_cfs_period(tg);
>> +             quota = tg_get_cfs_quota(tg);
>> +     }
>
> ... at this point:
>  period => scale in us unit
>  quota  => scale in us unit, or -1
> Moreover:
>  d->period => (scale in ns unit) / NSEC_PER_USEC
>  d->quota  => (scale in ns unit, or RUNTIME_INF) / NSEC_PER_USEC
>
> Therefore, ...
>
>> +
>> +     if (quota == RUNTIME_INF)
>> +             return RUNTIME_INF;
>
> This check doesn't work properly.

Right.  Fixed, sorry for the delayed response -- was out last week.

>
> I found this problem because I could not get child group back to be
> unconstrained:
>
> [root@localhost group0]# cat cpu.cfs_*
> 500000
> 500000
> [root@localhost group0]# cat sub0/cpu.cfs_*
> 500000
> 100000
> [root@localhost group0]# cat sub1/cpu.cfs_*
> 500000
> 100000
> [root@localhost group0]# echo -1 > sub1/cpu.cfs_quota_us
> bash: echo: write error: Invalid argument
>
> I confirmed that this write error is removed by the following
> change.  I'm looking forward to seeing your V6 soon.
>
> Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
>
>
> Thanks,
> H.Seto
>
> ---
>  kernel/sched.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 6d764b5..c8f9820 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -9467,8 +9467,8 @@ static u64 normalize_cfs_quota(struct task_group *tg,
>                period = d->period;
>                quota = d->quota;
>        } else {
> -               period = tg_get_cfs_period(tg);
> -               quota = tg_get_cfs_quota(tg);
> +               period = ktime_to_ns(tg_cfs_bandwidth(tg)->period);
> +               quota = tg_cfs_bandwidth(tg)->quota;
>        }
>
>        if (quota == RUNTIME_INF)
> @@ -9515,8 +9515,8 @@ static int __cfs_schedulable(struct task_group *tg, u64 period, u64 quota)
>        int ret;
>        struct cfs_schedulable_data data = {
>                .tg = tg,
> -               .period = period / NSEC_PER_USEC,
> -               .quota = quota / NSEC_PER_USEC,
> +               .period = period,
> +               .quota = quota,
>        };
>
>        if (!sysctl_sched_cfs_bandwidth_consistent)
> --
> 1.7.4
>
>
