Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab1LMMkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 07:40:36 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47675 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab1LMMkf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 07:40:35 -0500
MIME-Version: 1.0
In-Reply-To: <1323695116.13285.14.camel@twins>
References: <20111210135925.GA14593@linux.vnet.ibm.com> <1323695116.13285.14.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Tue, 13 Dec 2011 04:40:03 -0800
Message-ID: <CAPM31RKR8dvtSmMmV7xO5FnBgY62=fQugXYANNGYMOiAE6iQbg@mail.gmail.com>
Subject: Re: [PATCH tip] sched/trivial: Remove cfs bandwidth period check in tg_set_cfs_period()
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 5:05 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Sat, 2011-12-10 at 19:29 +0530, Kamalesh Babulal wrote:
>> sched: Remove cfs bandwidth period check in tg_set_cfs_period()
>>
>> Remove cfs bandwidth period check from tg_set_cfs_period.
>> Invalid bandwidth period's lower/upper limits are denoted
>> by min_cfs_quota_period/max_cfs_quota_period repsectively,
>> and are checked against valid period in tg_set_cfs_bandwidth().
>>
>> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
>> --
>>  kernel/sched/core.c |    3 ---
>>  1 files changed, 0 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 3c5b21e..57cf3ab 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -7689,9 +7689,6 @@ int tg_set_cfs_period(struct task_group *tg, long cfs_period_us)
>>         period = (u64)cfs_period_us * NSEC_PER_USEC;
>>         quota = tg->cfs_bandwidth.quota;
>>
>> -       if (period <= 0)
>> -               return -EINVAL;
>> -
>>         return tg_set_cfs_bandwidth(tg, period, quota);
>>  }
>
> There's a number of funnies here... it checks an unsigned value for <=
> 0, which suggests it wanted to check cfs_period_us, which is a signed
> value.

Yup it wanted to check cfs_period0us -- although as Kamelesh points
out, it can be omitted.

>
> tg_set_cfs_bandwidth() has the same problem, at that point everything is
> unsigned and all below zero checks will fail.
>
> Please reconsider things and see if this patch is still the right one.

It's OK though since period is always strictly unsigned so any -ve
becomes larger than the max allowed period and it spits out -EINVAL as
appropriate.

So Kamelesh's patch above is good as is.

Acked-by: Paul Turner <pjt@google.com>
