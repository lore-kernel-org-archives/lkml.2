Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab0IFGfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 02:35:00 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42391 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab0IFGe6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 02:34:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dR99sJdEPXdbaybDBUxIU7XMteSedG3xX/TpCnsEFhGAeY0FhyTYvzHYHS2C6tSlAM
         xvTH+BGzv+GeL5KOmXriM+ASXKCfii5bPMP/Bt0TLlYL5oDE8rH1jvbT2emwymBBg4LN
         349m2Bk4VavDdCXyMuJ1qPVzejmKUg+liR5pw=
MIME-Version: 1.0
In-Reply-To: <1281365803.5390.2.camel@localhost.localdomain>
References: <AANLkTinNr28LM6NfsmbbmmV28mCzUugTTSI_Bq6N9-8C@mail.gmail.com>
	<1281002322.1923.1708.camel@laptop>
	<AANLkTi=Tyh2cBtffOthiYcu=+ZHWW8FfSeFwLUq84Q3y@mail.gmail.com>
	<1281365803.5390.2.camel@localhost.localdomain>
Date: Mon, 6 Sep 2010 12:04:55 +0530
Message-ID: <AANLkTimH45_46HiKWOudAS0zxTHjHyrsuxWoyFF1cdFv@mail.gmail.com>
Subject: Re: clock drift in set_task_cpu()
From: Jack Daniel <wanders.thirst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, pjohn@mvista.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Mon, Aug 9, 2010 at 8:26 PM, Philby John <pjohn@mvista.com> wrote:
> On Mon, 2010-08-09 at 18:47 +0530, Jack Daniel wrote:
>> On Thu, Aug 5, 2010 at 3:28 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Wed, 2010-07-21 at 17:10 +0530, Jack Daniel wrote:
>> >> On a Xeon 55xx with 8 CPU's, I found out the new_rq->clock value is
>> >> sometimes larger than old_rq->clock and so clock_offset tends to warp
>> >> around leading to incorrect values.
>> >
>> > What values get incorrect, do you observe vruntime funnies or only the
>> > schedstat values?
>>
>> Just the schedstat values, did not observe anything wrong with vruntime.
>>
>> >
>> >>  You have very correctly noted in
>> >> the commit header that all functions that access set_task_cpu() must
>> >> do so after a call to sched_clock_remote(), in this case the function
>> >> is sched_fork(). I validated by adding update_rq_clock(old_rq); into
>> >> set_task_cpu() and that seems to fix the issue.
>> >
>> > Ah, so the problem is that task_fork_fair() does the task placement
>> > without updated rq clocks? In which case I think we should at least do
>> > an update_rq_clock(rq) in there (see the below patch).
>>
>> Yes, this is indeed the problem and your patch seems to fix the issue.
>>
>> >
>> >> But I noticed that
>> >> since CONFIG_HAVE_UNSTABLE_SCHED_CLOCK is already set, if
>> >> (sched_clock_stable)  in sched_clock_cpu() will yield to true and the
>> >> flow never gets to sched_clock_remote() or sched_clock_local().
>> >
>> > sched_clock_stable being true implies the clock is stable across cores
>> > and thus it shouldn't matter. Or are you saying you're seeing it being
>> > set and still have issues?
>> >
>>
>> Please ignore these comments, initial debugging set me on the wrong
>> foot, to suggest that TSC is unstable.
>>
>> > diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
>> > index 9910e1b..f816e74 100644
>> > --- a/kernel/sched_fair.c
>> > +++ b/kernel/sched_fair.c
>> > @@ -3751,6 +3751,8 @@ static void task_fork_fair(struct task_struct *p)
>> >
>> >        raw_spin_lock_irqsave(&rq->lock, flags);
>> >
>> > +       update_rq_clock(rq);
>>
>> As you rightly pointed out above, updating the clocks in
>> task_fork_fair() will rightly fix the issue. Can get rid of rest of
>> the update_rq_clock() functions as they (like you said), are expensive
>> and I tested commenting them out.
>
> >From 1bc695bc2ac6c941724953b29f6c18196a474b8f Mon Sep 17 00:00:00 2001
> From: Philby John <pjohn@mvista.com>
> Date: Mon, 9 Aug 2010 18:19:08 +0530
> Subject: [PATCH] sched: ensure rq->clock get sync'ed when migrating tasks
>
> In sched_fork() when we do task placement in ->task_fork_fair()
> ensure we update_rq_clock() so we work with current time. This has
> been noted and verified on an Intel Greencity (Xeon 55xx)
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Philby John <pjohn@mvista.com>
> ---
>  kernel/sched_fair.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 806d1b2..48bc31c 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -3751,7 +3751,7 @@ static void task_fork_fair(struct task_struct *p)
>        unsigned long flags;
>
>        raw_spin_lock_irqsave(&rq->lock, flags);
> -
> +       update_rq_clock(rq);
>        if (unlikely(task_cpu(p) != this_cpu))
>                __set_task_cpu(p, this_cpu);
>

Any chance that you will be pulling in this fix ?

Regards,
Jack
