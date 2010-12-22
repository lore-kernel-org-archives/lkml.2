Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab0LVOAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 09:00:10 -0500
Received: from smtp-out.google.com ([74.125.121.67]:45994 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab0LVOAI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 09:00:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vf7V+fQPWa0ifZPxt5W+2i1cbi7fMiWBkvBxSLcvjQ0pg1i6svZYBFrWHCpi/r8wHH
         7lki5H2sojpKP6/ujeKg==
MIME-Version: 1.0
In-Reply-To: <1293009621.2170.72.camel@laptop>
References: <1292980144-28796-1-git-send-email-venki@google.com>
	<1292980144-28796-6-git-send-email-venki@google.com>
	<1293009621.2170.72.camel@laptop>
Date: Wed, 22 Dec 2010 05:59:57 -0800
Message-ID: <AANLkTimhtoMLSo1W421+EpXiSphcfJ_6z8=usrF4M3FH@mail.gmail.com>
Subject: Re: [PATCH 5/5] Account ksoftirqd time as cpustat softirq -v2
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Shaun Ruffell <sruffell@digium.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 1:20 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-12-21 at 17:09 -0800, Venkatesh Pallipadi wrote:
>> softirq time in ksoftirqd context is not accounted in ns granularity
>> per cpu softirq stats, as we want that to be a part of ksoftirqd
>> exec_runtime.
>>
>> Accounting them as softirq on /proc/stat separately.
>>
>> Tested-by: Shaun Ruffell <sruffell@digium.com>
>> Signed-off-by: Venkatesh Pallipadi <venki@google.com>
>> ---
>>  kernel/sched.c |    8 ++++++++
>>  1 files changed, 8 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index 193b1d0..4ff6d1a 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -3819,6 +3819,14 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
>>               cpustat->irq = cputime64_add(cpustat->irq, tmp);
>>       } else if (irqtime_account_si_update()) {
>>               cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
>> +     } else if (this_cpu_ksoftirqd() == p) {
>> +             /*
>> +              * ksoftirqd time do not get accounted in cpu_softirq_time.
>> +              * So, we have to handle it separately here.
>> +              * Also, p->stime needs to be updated for ksoftirqd.
>> +              */
>> +             __account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
>> +                                     &cpustat->softirq);
>>       } else if (user_tick) {
>>               account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
>>       } else if (p == rq->idle) {
>
> So you add the ksoftirqd runtime as softirq time in the /proc/stat
> output?
>
> That seems dubious...
>

Yes. Thats similar to what we do today. As long as we are in softirq,
whether bottomhalf or ksoftirqd, we account the tick as softirq time
in /proc/stat.
I thought it also makes sense from user perspective. They want to know
how much time are we currently spending serving softirqs and hardirqs.
It is better to get that information at one place, instead of say look
at /proc/stat and add percpu ksoftirqd time to it. I mean,
user/administrator does not have to care whether ksoftirqd is involved
or not to know how much time was spend serving softirqs.

Thanks,
Venki
