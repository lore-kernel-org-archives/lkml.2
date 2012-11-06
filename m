Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab2KFOYE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 09:24:04 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43638 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab2KFOYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 09:24:02 -0500
MIME-Version: 1.0
In-Reply-To: <1351520894.8467.76.camel@gandalf.local.home>
References: <1351517296-9173-1-git-send-email-fweisbec@gmail.com>
	<1351517296-9173-8-git-send-email-fweisbec@gmail.com>
	<1351520894.8467.76.camel@gandalf.local.home>
Date: Tue, 6 Nov 2012 15:24:00 +0100
Message-ID: <CAFTL4hxCdUyLUFNqVkiuWMpgjWD9=qL9-viS_m5jUEjE9UBe1w@mail.gmail.com>
Subject: Re: [RFC PATCH 7/9] irq_work: Make self-IPIs optable
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/29 Steven Rostedt <rostedt@goodmis.org>:
> On Mon, 2012-10-29 at 14:28 +0100, Frederic Weisbecker wrote:
>> On irq work initialization, let the user choose to define it
>> as "lazy" or not. "Lazy" means that we don't want to send
>> an IPI (provided the arch can anyway) when we enqueue this
>> work but we rather prefer to wait for the next timer tick
>> to execute our work if possible.
>>
>> This is going to be a benefit for non-urgent enqueuers
>> (like printk in the future) that may prefer not to raise
>> an IPI storm in case of frequent enqueuing on short periods
>> of time.
>>
>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
>> ---
>>  include/linux/irq_work.h |   31 ++++++++++++++++++++++++++
>>  kernel/irq_work.c        |   53 ++++++++++++++++++++++++++++++++-------------
>>  kernel/time/tick-sched.c |    3 +-
>>  3 files changed, 70 insertions(+), 17 deletions(-)
>>
>> diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
>> index b39ea0b..7b60c87 100644
>> --- a/include/linux/irq_work.h
>> +++ b/include/linux/irq_work.h
>> @@ -4,6 +4,20 @@
>>  #include <linux/llist.h>
>>  #include <asm/irq_work.h>
>>
>> +/*
>> + * An entry can be in one of four states:
>> + *
>
> Can you add a comment to what the pointer value is. I know you just
> moved it to the header, but it's still confusing.

Which pointer value?  You mean the flag? You mean the below need more
details or?

>
>> + * free           NULL, 0 -> {claimed}       : free to be used
>> + * claimed   NULL, 3 -> {pending}       : claimed to be enqueued
>> + * pending   next, 3 -> {busy}          : queued, pending callback
>> + * busy      NULL, 2 -> {free, claimed} : callback in progress, can be claimed
>> + */
>> +
>> +#define IRQ_WORK_PENDING     1UL
>> +#define IRQ_WORK_BUSY                2UL
>> +#define IRQ_WORK_FLAGS               3UL
>> +#define IRQ_WORK_LAZY                4UL /* Doesn't want IPI, wait for tick */
[...]
>> @@ -66,10 +56,28 @@ static void __irq_work_queue(struct irq_work *work)
>>       preempt_disable();
>>
>>       empty = llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
>> -     /* The list was empty, raise self-interrupt to start processing. */
>> -     if (empty)
>> +
>> +     /*
>> +      * In any case, raise an IPI if requested and possible in case
>> +      * the queue is empty or it's filled with lazy works.
>> +      */
>> +     if (!(work->flags & IRQ_WORK_LAZY) && arch_irq_work_has_ipi()) {
>>               arch_irq_work_raise();
>
> Doesn't this mean that now if we queue up a bunch of work (say in
> tracing), that we will send out an IPI for each queue? We only want to
> send out an IPI if the list isn't empty. Perhaps we should make two
> lists. One for lazy work and one for immediate work. Then, when adding a
> non-lazy work item, we can check the empty variable for that. No need to
> check the result for the lazy queue. That will be done during tick.

Indeed, if an IPI is pending while we queue another work, we'll raise
another one. I would prefer to avoid the complication of adding
another queue though. Perhaps a per cpu "ipi_pending" flag would be
enough. I'll try something.
