Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab0JZRfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 13:35:21 -0400
Received: from smtp-out.google.com ([216.239.44.51]:1948 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932520Ab0JZRfS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 13:35:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kTauLENHsepYVPQNlYAEaGfc+q8uXqPG2bA/Hy/UwFEIOyrXe2l8xfjPgY4bfTys72
         lTUUcoaIFlVuZKIN0IWw==
MIME-Version: 1.0
In-Reply-To: <1288086618.15336.125.camel@twins>
References: <1288045817-3135-1-git-send-email-venki@google.com>
	<1288045817-3135-7-git-send-email-venki@google.com>
	<1288085632.15336.111.camel@twins>
	<1288086618.15336.125.camel@twins>
Date: Tue, 26 Oct 2010 10:35:15 -0700
Message-ID: <AANLkTikrxE7J38M+r=s_M-TAAFyL8-bGxpyZBwZdChA+@mail.gmail.com>
Subject: Re: [PATCH 6/6] Account ksoftirqd time as cpustat softirq -v1
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 2:50 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-10-26 at 11:33 +0200, Peter Zijlstra wrote:
>> On Mon, 2010-10-25 at 15:30 -0700, Venkatesh Pallipadi wrote:
>> > softirq time in ksoftirqd context is not accounted in ns granularity
>> > per cpu softirq stats, as we want that to be a part of ksoftirqd
>> > exec_runtime.
>> >
>> > Accounting them as softirq on /proc/stat separately.
>> >
>> > Tested-by: Shaun Ruffell <sruffell@digium.com>
>> >
>> > Signed-off-by: Venkatesh Pallipadi <venki@google.com>
>> > ---
>> >  kernel/sched.c |    8 ++++++++
>> >  1 files changed, 8 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/kernel/sched.c b/kernel/sched.c
>> > index 49f6f61..0955050 100644
>> > --- a/kernel/sched.c
>> > +++ b/kernel/sched.c
>> > @@ -3617,6 +3617,14 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
>> >             cpustat->irq = cputime64_add(cpustat->irq, tmp);
>> >     } else if (irqtime_account_si_update()) {
>> >             cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
>> > +   } else if (this_cpu_ksoftirqd() == p) {
>> > +           /*
>> > +            * ksoftirqd time do not get accounted in cpu_softirq_time.
>> > +            * So, we have to handle it separately here.
>> > +            * Also, p->stime needs to be updated for ksoftirqd.
>> > +            */
>> > +           __account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
>> > +                                   &cpustat->softirq);
>> >     } else if (user_tick) {
>> >             account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
>> >     } else if (p == rq->idle) {
>>
>>
>> I'm somewhat confused by this patch.. This is significantly different
>> from the thing proposed last time around, which was to use:
>>
>>   cpustat->softirq + this_cpu_ksoftirqd()->se.sum_exec_runtime
>>

Previous version I was using sum_exec_runtime and later I was also
checking whether the current task is ksoftirqd before charging. So, in
effect that was stricter change which would only account when there is
folding and current happens to be ksoftirqd. The second check was
required as we are also accounting ksoftirqd->stime and I didn't want
to do that when current is not ksoftirqd.

>> The above looses the fine grained aspect of the accounting and simply
>> charges a whole jiffy if the current process happens to be ksoftirqd.
>

Yes. This leaves ksoftirqd with coarse granularity as before.

> Btw, both these solutions can cause si + us + ni + sy > 100%, are we ok
> with that?

The current if/else if/.../else/ logic gets called every tick and
charges that tick to what it thinks is the most appropriate bucket.
So, it should not be greater than 100%. ksoftirqd gets accounted only
softirq tick and not as system and thats how it has been currently.

Thanks,
Venki
