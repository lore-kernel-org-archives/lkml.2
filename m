Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956Ab2LUI67 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 03:58:59 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:37406 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab2LUI6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 03:58:53 -0500
MIME-Version: 1.0
In-Reply-To: <20121221054712.GA2933@danjae>
References: <1355319092-30980-1-git-send-email-vincent.guittot@linaro.org>
	<1355319092-30980-4-git-send-email-vincent.guittot@linaro.org>
	<50C93AC1.1060202@intel.com>
	<CAKfTPtB9iz1ePsS+juQVRhuWREYB1duGWRJT7ya8XBXPhC-mkw@mail.gmail.com>
	<20121221054712.GA2933@danjae>
Date: Fri, 21 Dec 2012 09:53:48 +0100
Message-ID: <CAKfTPtBs28LqUL908U7=ae82+mAV7ba1bj1Kt9PnizdLTo3EwA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/6] sched: pack small tasks
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Alex Shi <alex.shi@intel.com>, len.brown@intel.com, tony.luck@intel.com,
        linux@arm.linux.org.uk, peterz@infradead.org, arjan@linux.intel.com,
        linux-kernel@vger.kernel.org, cmetcalf@tilera.com,
        viresh.kumar@linaro.org, preeti@linux.vnet.ibm.com,
        linaro-dev@lists.linaro.org, tglx@linutronix.de,
        chander.kashyap@linaro.org, pjt@google.com, mingo@kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 December 2012 06:47, Namhyung Kim <namhyung@kernel.org> wrote:
> Hi Vincent,
>
> On Thu, Dec 13, 2012 at 11:11:11AM +0100, Vincent Guittot wrote:
>> On 13 December 2012 03:17, Alex Shi <alex.shi@intel.com> wrote:
>> > On 12/12/2012 09:31 PM, Vincent Guittot wrote:
>> >> +static bool is_buddy_busy(int cpu)
>> >> +{
>> >> +     struct rq *rq = cpu_rq(cpu);
>> >> +
>> >> +     /*
>> >> +      * A busy buddy is a CPU with a high load or a small load with a lot of
>> >> +      * running tasks.
>> >> +      */
>> >> +     return ((rq->avg.runnable_avg_sum << rq->nr_running) >
>> >
>> > If nr_running a bit big, rq->avg.runnable_avg_sum << rq->nr_running is
>> > zero. you will get the wrong decision.
>>
>> yes, I'm going to do that like below instead:
>> return (rq->avg.runnable_avg_sum > (rq->avg.runnable_avg_period >>
>> rq->nr_running));
>
> Doesn't it consider nr_running too much?  It seems current is_buddy_busy
> returns false on a cpu that has 1 task runs 40% cputime, but returns true
> on a cpu that has 3 tasks runs 10% cputime each or for 2 tasks of 15%
> cputime each, right?

Yes it's right.
>
> I don't know what is correct, but just guessing that in a cpu's point
> of view it'd be busier if it has a higher runnable_avg_sum than a
> higher nr_running IMHO.

The nr_running is used to point out how many tasks are running
simultaneously and the potential scheduling latency of adding

>
>
>>
>> >
>> >> +                     rq->avg.runnable_avg_period);
>> >> +}
>> >> +
>> >> +static bool is_light_task(struct task_struct *p)
>> >> +{
>> >> +     /* A light task runs less than 25% in average */
>> >> +     return ((p->se.avg.runnable_avg_sum << 1) <
>> >> +                     p->se.avg.runnable_avg_period);
>> >
>> > 25% may not suitable for big machine.
>>
>> Threshold is always an issue, which threshold should be suitable for
>> big machine ?
>>
>> I'm wondering if i should use the imbalance_pct value for computing
>> the threshold
>
> Anyway, I wonder how 'sum << 1' computes 25%.  Shouldn't it be << 2 ?

The 1st version of the patch was using << 2 but I received a comment
saying that it was may be not enough aggressive so I have updated the
formula with << 1 but forgot to update the comment. I will align
comment and formula in the next version.
Thanks for pointing this

Vincent

>
> Thanks,
> Namhyung
