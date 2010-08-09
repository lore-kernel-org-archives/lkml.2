Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab0HINRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 09:17:07 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48888 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab0HINRF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 09:17:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GU7C2c6CM/lSGLLKbf4wwW/UxHsMgOAq+uO37Or3v23XjxGQtgbtcl6hsF3IuIMn1w
         hQ9Genhu+RUkW3A+YG0a8qrZj7y6qswg5u+5bAiipEuUx+vy8xIsFhg3lqBmWhvXKKBw
         5U/IQJSEUeWXBWUTJ0f2mk9xSIkRfanVF0JTM=
MIME-Version: 1.0
In-Reply-To: <1281002322.1923.1708.camel@laptop>
References: <AANLkTinNr28LM6NfsmbbmmV28mCzUugTTSI_Bq6N9-8C@mail.gmail.com>
	<1281002322.1923.1708.camel@laptop>
Date: Mon, 9 Aug 2010 18:47:01 +0530
Message-ID: <AANLkTi=Tyh2cBtffOthiYcu=+ZHWW8FfSeFwLUq84Q3y@mail.gmail.com>
Subject: Re: clock drift in set_task_cpu()
From: Jack Daniel <wanders.thirst@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 3:28 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-07-21 at 17:10 +0530, Jack Daniel wrote:
>> On a Xeon 55xx with 8 CPU's, I found out the new_rq->clock value is
>> sometimes larger than old_rq->clock and so clock_offset tends to warp
>> around leading to incorrect values.
>
> What values get incorrect, do you observe vruntime funnies or only the
> schedstat values?

Just the schedstat values, did not observe anything wrong with vruntime.

>
>>  You have very correctly noted in
>> the commit header that all functions that access set_task_cpu() must
>> do so after a call to sched_clock_remote(), in this case the function
>> is sched_fork(). I validated by adding update_rq_clock(old_rq); into
>> set_task_cpu() and that seems to fix the issue.
>
> Ah, so the problem is that task_fork_fair() does the task placement
> without updated rq clocks? In which case I think we should at least do
> an update_rq_clock(rq) in there (see the below patch).

Yes, this is indeed the problem and your patch seems to fix the issue.

>
>> But I noticed that
>> since CONFIG_HAVE_UNSTABLE_SCHED_CLOCK is already set, if
>> (sched_clock_stable)  in sched_clock_cpu() will yield to true and the
>> flow never gets to sched_clock_remote() or sched_clock_local().
>
> sched_clock_stable being true implies the clock is stable across cores
> and thus it shouldn't matter. Or are you saying you're seeing it being
> set and still have issues?
>

Please ignore these comments, initial debugging set me on the wrong
foot, to suggest that TSC is unstable.

> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 9910e1b..f816e74 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -3751,6 +3751,8 @@ static void task_fork_fair(struct task_struct *p)
>
>        raw_spin_lock_irqsave(&rq->lock, flags);
>
> +       update_rq_clock(rq);

As you rightly pointed out above, updating the clocks in
task_fork_fair() will rightly fix the issue. Can get rid of rest of
the update_rq_clock() functions as they (like you said), are expensive
and I tested commenting them out.

Thanks,
Jack
