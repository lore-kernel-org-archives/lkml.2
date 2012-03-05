Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab2CEWpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 17:45:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57591 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476Ab2CEWpu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 17:45:50 -0500
MIME-Version: 1.0
In-Reply-To: <4F551ABE.5080605@nasza-klasa.pl>
References: <CAK=uwuy80LaNdQ4P49i+bGUXFvxf1zB=oKqNBTdAyvFc+mOTyw@mail.gmail.com>
 <4F465F6E.9070605@nasza-klasa.pl> <1330517195.11248.148.camel@twins>
 <1330532667.11248.153.camel@twins> <1330534998.11248.158.camel@twins> <4F551ABE.5080605@nasza-klasa.pl>
From: Aman Gupta <aman@tmm1.net>
Date: Mon, 5 Mar 2012 14:45:29 -0800
X-Google-Sender-Auth: psaKEy8S2eHyxFTD4nRcz3czSwQ
Message-ID: <CAK=uwuxvzGwes4ffy9EXVReG95U3HQaKmPPKgFnHzo_MwaO_NA@mail.gmail.com>
Subject: Re: Inconsistent load average on tickless kernels
To: =?UTF-8?B?TGVzxYJhdyBLb3BlxIc=?= <leslaw.kopec@nasza-klasa.pl>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Chase Douglas <chase.douglas@canonical.com>,
        Damien Wyart <damien.wyart@free.fr>, Kyle McMartin <kyle@redhat.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Jonathan Nieder <jrnieder@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 11:57 AM, Lesław Kopeć
<leslaw.kopec@nasza-klasa.pl> wrote:
> On 29.02.2012 13:06, Peter Zijlstra wrote:
>
>> Missing here is a kernel build with CONFIG_NO_HZ but booted with
>> nohz=off; this would be an interesting data point because it includes
>> all the funny code but still ticks are the right frequency.
>
> You've asked for it and you got it. I have rebooted some servers with
> nohz=off parameter set on kernels complied with CONFIG_NO_HZ=y. They're
> the ones listed below with 'off' suffix.
>
> On 29.02.2012 17:24, Peter Zijlstra wrote:
>
>> Hrmm, this suggests we age too hard with nohz code.. in your test case
>> is there significant idle time? That is, suppose you run each cpu at 30%
>> what is the period of you load? Running 3s out of 10s is significantly
>> different from running .3ms out of 1ms.
>
> It's definitely more similar to the second case - very frequent, but
> short bursts of activity. A single process does a tiny bit of
> computation mixed with a fair amount of network activity on each
> request. There are 80 such processes which are responsible for majority
> of system load.
>
> On 29.02.2012 18:03, Peter Zijlstra wrote:
>
>>> The only thing I could find is that on nohz we can confuse the per-rq
>>> sample period, does the below make a difference?
>>
>> Uhm, something like so that is..
>>
>> ---
>>  kernel/sched/core.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index d7c4322..44f61df 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -2380,7 +2380,8 @@ static void calc_load_account_active(struct rq *this_rq)
>>       if (delta)
>>               atomic_long_add(delta, &calc_load_tasks);
>>
>> -     this_rq->calc_load_update += LOAD_FREQ;
>> +     while (!time_before(jiffies, this_rq->calc_load_update))
>> +             this_rq->calc_load_update += LOAD_FREQ;
>>  }
>>
>>  /*
>>
>
> I have compiled another batch of kernels with this patch applied
> (they're the ones with 'patch0' suffix). The only difference was the
> patch had to go to kernel/sched.c, but that's what you get when not
> using the latest sources. Anyway, here are the results accompanied by a
> pretty picture [1]:
>
>                                        std     off     patch0
> 2.6.32.55-no-hz                         0.76    0.91    -
> 2.6.32.55-no-hz-74f5187ac8              6.41    9.40    4.93
> 2.6.32.55-no-hz-0f004f5a69              0.78    0.92    0.90
> 2.6.37-rc5-no-hz-0f004f5a69             0.95    0.92    0.86
> 2.6.37-rc5-no-hz-pre-0f004f5a69         9.16    10.47   8.02
>
> It seems that the patch didn't help much on kernels with 0f004f5a69
> applied. The ones with just 74f5187ac8 are reporting a more plausible
> values, but slightly lower than the ones without patch0. Am I right to
> assume that the correct load values are the ones produced by kernels
> complied with CONFIG_NO_HZ=n? Should they be the baseline?
>
> I can run additional tests if you have other leads to follow. Is there a
> particular kernel version I should focus on? If not I will continue
> to use the current bundle. I'm also planning to give the latest stable
> release a spin.

I can confirm these results on 3.2.8. Booting with nohz=off makes no
difference. Applying the patch to kernel/sched.c made no noticeable
difference either.

  Aman

>
>
> [1] http://img835.imageshack.us/img835/2204/kernelload.png
>
> --
> Lesław Kopeć
>
