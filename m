Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab2IMIhN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 04:37:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52851 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab2IMIhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 04:37:09 -0400
MIME-Version: 1.0
In-Reply-To: <1347522994.6821.67.camel@marge.simpson.net>
References: <1347509486-8688-1-git-send-email-vincent.guittot@linaro.org>
	<1347518991.6821.45.camel@marge.simpson.net>
	<CAKfTPtBQ7Y1xGOe9NZw8AhNbOzGgkVMgYyXjVa1d308kdG6bfQ@mail.gmail.com>
	<1347521382.6821.61.camel@marge.simpson.net>
	<CAKfTPtCvg1qxUv02-dO9qD2HiFzS_bA2Gr0mrN=8LEA3eXA7Bg@mail.gmail.com>
	<1347522994.6821.67.camel@marge.simpson.net>
Date: Thu, 13 Sep 2012 10:37:08 +0200
Message-ID: <CAKfTPtCoYjiZphPqyYtmEN-jR=hbAUMLbWSkD9BoWRiVkmE=3Q@mail.gmail.com>
Subject: Re: [RFC] sched: nohz_idle_balance
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, peterz@infradead.org, mingo@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrong button make me removed others guys from the thread.

Sorry for this mistake.

On 13 September 2012 09:56, Mike Galbraith <efault@gmx.de> wrote:
> On Thu, 2012-09-13 at 09:44 +0200, Vincent Guittot wrote:
>> On 13 September 2012 09:29, Mike Galbraith <efault@gmx.de> wrote:
>> > On Thu, 2012-09-13 at 08:59 +0200, Vincent Guittot wrote:
>> >> On 13 September 2012 08:49, Mike Galbraith <efault@gmx.de> wrote:
>> >> > On Thu, 2012-09-13 at 06:11 +0200, Vincent Guittot wrote:
>> >> >> On tickless system, one CPU runs load balance for all idle CPUs.
>> >> >> The cpu_load of this CPU is updated before starting the load balance
>> >> >> of each other idle CPUs. We should instead update the cpu_load of the balance_cpu.
>> >> >>
>> >> >> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> >> >> ---
>> >> >>  kernel/sched/fair.c |   11 ++++++-----
>> >> >>  1 file changed, 6 insertions(+), 5 deletions(-)
>> >> >>
>> >> >> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> >> >> index 1ca4fe4..9ae3a5b 100644
>> >> >> --- a/kernel/sched/fair.c
>> >> >> +++ b/kernel/sched/fair.c
>> >> >> @@ -4794,14 +4794,15 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
>> >> >>               if (need_resched())
>> >> >>                       break;
>> >> >>
>> >> >> -             raw_spin_lock_irq(&this_rq->lock);
>> >> >> -             update_rq_clock(this_rq);
>> >> >> -             update_idle_cpu_load(this_rq);
>> >> >> -             raw_spin_unlock_irq(&this_rq->lock);
>> >> >> +             rq = cpu_rq(balance_cpu);
>> >> >> +
>> >> >> +             raw_spin_lock_irq(&rq->lock);
>> >> >> +             update_rq_clock(rq);
>> >> >> +             update_idle_cpu_load(rq);
>> >> >> +             raw_spin_unlock_irq(&rq->lock);
>> >> >>
>> >> >>               rebalance_domains(balance_cpu, CPU_IDLE);
>> >> >>
>> >> >> -             rq = cpu_rq(balance_cpu);
>> >> >>               if (time_after(this_rq->next_balance, rq->next_balance))
>> >> >>                       this_rq->next_balance = rq->next_balance;
>> >> >>       }
>> >> >
>> >> > Ew, banging locks and updating clocks to what good end?
>> >>
>> >> The goal is to update the cpu_load table of the CPU before starting
>> >> the load balance. Other wise we will use outdated value in the load
>> >> balance sequence
>> >
>> > If there's load to distribute, seems it should all work out fine without
>> > doing that.  What harm is being done that makes this worth while?
>>
>> this_load and avg_load can be wrong and make an idle CPU set as
>> balanced compared to the busy one
>
> I think you need to present numbers showing benefit.  Crawling all over
> a mostly idle (4096p?) box is decidedly bad thing to do.

Yep, let me prepare some figures

You should also notice that you are already crawling all over the idle
processor in rebalance_domains

Vincent

>
> -Mike
>
