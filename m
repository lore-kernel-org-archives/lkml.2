Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab2KPRk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:40:26 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:56415 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab2KPRkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:40:24 -0500
MIME-Version: 1.0
In-Reply-To: <1353082183.7586.19.camel@gandalf.local.home>
References: <1353032491-16462-1-git-send-email-fweisbec@gmail.com>
	<1353032491-16462-9-git-send-email-fweisbec@gmail.com>
	<1353082183.7586.19.camel@gandalf.local.home>
Date: Fri, 16 Nov 2012 18:33:02 +0100
Message-ID: <CAFTL4hzQ7twJsE_6ou22W1FPZWj+W3hJ95th=2AgXG8SkWB5Dw@mail.gmail.com>
Subject: Re: [PATCH 8/9] irq_work: Make self-IPIs optable
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

2012/11/16 Steven Rostedt <rostedt@goodmis.org>:
> On Fri, 2012-11-16 at 03:21 +0100, Frederic Weisbecker wrote:
>>
>>  /*
>>   * Claim the entry so that no one else will poke at it.
>> @@ -68,14 +59,18 @@ void __weak arch_irq_work_raise(void)
>>   */
>>  static void __irq_work_queue(struct irq_work *work)
>>  {
>> -     bool empty;
>> -
>>       preempt_disable();
>>
>> -     empty = llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
>> -     /* The list was empty, raise self-interrupt to start processing. */
>> -     if (empty)
>> -             arch_irq_work_raise();
>> +     llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
>> +
>> +     /*
>> +      * If the work is flagged as "lazy", just wait for the next tick
>> +      * to run it. Otherwise, or if the tick is stopped, raise the irq work.
>
> Speaking more Greek? ;-)
>
> How about:
>
>         If the work is not "lazy" or the tick is stopped, raise the irq
>         work interrupt (if supported by the arch), otherwise, just wait
>         for the next tick.

Much better :)

>
> Other than that, Acked-by: Steven Rostedt <rostedt@goodmis.org>

Thanks!
