Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab1FOB0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 21:26:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508Ab1FOB0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 21:26:40 -0400
Message-ID: <4DF80A40.9040201@redhat.com>
Date: Tue, 14 Jun 2011 22:26:24 -0300
From: Glauber Costa <glommer@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH 6/7] KVM-GST: adjust scheduler cpu power
References: <1308007897-17013-1-git-send-email-glommer@redhat.com>	 <1308007897-17013-7-git-send-email-glommer@redhat.com> <1308048147.19856.14.camel@twins>
In-Reply-To: <1308048147.19856.14.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2011 07:42 AM, Peter Zijlstra wrote:
> On Mon, 2011-06-13 at 19:31 -0400, Glauber Costa wrote:
>> @@ -1981,12 +1987,29 @@ static void update_rq_clock_task(struct rq
>> *rq, s64 delta)
>>
>>          rq->prev_irq_time += irq_delta;
>>          delta -= irq_delta;
>> +#endif
>> +#ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
>> +       if (static_branch((&paravirt_steal_rq_enabled))) {
>
> Why is that a different variable from the touch_steal_time() one?

because they track different things, touch_steal_time() and 
update_rq_clock() are
called from different places at different situations.

If we advance prev_steal_time in touch_steal_time(), and later on call 
update_rq_clock_task(), we won't discount the time already flushed from 
the rq_clock. Conversely, if we call update_rq_clock_task(), and only 
then arrive at touch_steal_time, we won't account steal time properly.

update_rq_clock_task() is called whenever update_rq_clock() is called.
touch_steal_time is called every tick. If there is a causal relation 
between them that would allow us to track it in a single location, I 
fail to realize.

>> +
>> +               steal = paravirt_steal_clock(cpu_of(rq));
>> +               steal -= rq->prev_steal_time_acc;
>> +
>> +               rq->prev_steal_time_acc += steal;
>
> You have this addition in the wrong place, when you clip:

I begin by disagreeing
>> +               if (steal>  delta)
>> +                       steal = delta;
>
> you just lost your steal delta, so the addition to prev_steal_time_acc
> needs to be after the clip.
Unlike irq time, steal time can be extremely huge. Just think of a 
virtual machine that got interrupted for a very long time. We'd have 
steal >> delta, leading to steal == delta for a big number of iterations.
That would affect cpu power for an extended period of time, not
reflecting present situation, just the past. So I like to think of delta
as a hard cap for steal time.

Obviously, I am open to debate.
>
>> +               delta -= steal;
>> +       }
>> +#endif
>> +
>>          rq->clock_task += delta;
>>
>> -       if (irq_delta&&  sched_feat(NONIRQ_POWER))
>> -               sched_rt_avg_update(rq, irq_delta);
>> +       if ((irq_delta + steal)&&  sched_feat(NONTASK_POWER))
>> +               sched_rt_avg_update(rq, irq_delta + steal);
>>   }

