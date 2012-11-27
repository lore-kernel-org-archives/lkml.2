Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab2K0OzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 09:55:12 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45749 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab2K0OzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 09:55:10 -0500
MIME-Version: 1.0
In-Reply-To: <1354024743.6276.79.camel@gandalf.local.home>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
	<ad25c731a6ca1bd1269555245952f05c856a9759.1352196505.git.viresh.kumar@linaro.org>
	<1354022770.6276.63.camel@gandalf.local.home>
	<CAKohpok5toHdxxjBU+bPJwkZt9Sv-QGY8o8X6HErza1WT-DWOA@mail.gmail.com>
	<1354024743.6276.79.camel@gandalf.local.home>
Date: Tue, 27 Nov 2012 15:55:08 +0100
Message-ID: <CAKfTPtD6T8oTHFeB82NFDOt6anAL=23vaShsDws0c7812=GkFQ@mail.gmail.com>
Subject: Re: [PATCH V2 Resend 3/4] workqueue: Schedule work on non-idle cpu
 instead of current one
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, pjt@google.com,
        paul.mckenney@linaro.org, tglx@linutronix.de, tj@kernel.org,
        suresh.b.siddha@intel.com, venki@google.com, mingo@redhat.com,
        peterz@infradead.org, Arvind.Chauhan@arm.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 November 2012 14:59, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2012-11-27 at 19:18 +0530, Viresh Kumar wrote:
>> On 27 November 2012 18:56, Steven Rostedt <rostedt@goodmis.org> wrote:
>> > A couple of things. The sched_select_cpu() is not cheap. It has a double
>> > loop of domains/cpus looking for a non idle cpu. If we have 1024 CPUs,
>> > and we are CPU 1023 and all other CPUs happen to be idle, we could be
>> > searching 1023 CPUs before we come up with our own.
>>
>> Not sure if you missed the first check sched_select_cpu()
>>
>> +int sched_select_cpu(unsigned int sd_flags)
>> +{
>> +       /* If Current cpu isn't idle, don't migrate anything */
>> +       if (!idle_cpu(cpu))
>> +               return cpu;
>>
>> We aren't going to search if we aren't idle.
>
> OK, we are idle, but CPU 1022 isn't. We still need a large search. But,
> heh we are idle we can spin. But then why go through this in the first
> place ;-)

By migrating it now, it will create its activity and wake up on the
right CPU next time.

If migrating on any CPUs seems a bit risky, we could restrict the
migration on a CPU on the same node. We can pass such contraints on
sched_select_cpu

>
>
>>
>> > Also, I really don't like this as a default behavior. It seems that this
>> > solution is for a very special case, and this can become very intrusive
>> > for the normal case.
>>
>> We tried with an KCONFIG option for it, which Tejun rejected.
>
> Yeah, I saw that. I don't like adding KCONFIG options either. Best is to
> get something working that doesn't add any regressions. If you can get
> this to work without making *any* regressions in the normal case than
> I'm totally fine with that. But if this adds any issues with the normal
> case, then it's a show stopper.
>
>>
>> > To be honest, I'm uncomfortable with this approach. It seems to be
>> > fighting a symptom and not the disease. I'd rather find a way to keep
>> > work from being queued on wrong CPU. If it is a timer, find a way to
>> > move the timer. If it is something else, lets work to fix that. Doing
>> > searches of possibly all CPUs (unlikely, but it is there), just seems
>> > wrong to me.
>>
>> As Vincent pointed out, on big LITTLE systems we just don't want to
>> serve works on big cores. That would be wasting too much of power.
>> Specially if we are going to wake up big cores.
>>
>> It would be difficult to control the source driver (which queues work) to
>> little cores. We thought, if somebody wanted to queue work on current
>> cpu then they must use queue_work_on().
>
> As Tejun has mentioned earlier, is there any assumptions anywhere that
> expects an unbounded work queue to not migrate? Where per cpu variables
> might be used. Tejun had a good idea of forcing this to migrate the work
> *every* time. To not let a work queue run on the same CPU that it was
> queued on. If it can survive that, then it is probably OK. Maybe add a
> config option that forces this? That way, anyone can test that this
> isn't an issue.
>
> -- Steve
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
