Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568Ab1GNXBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 19:01:42 -0400
Received: from smtp-out.google.com ([216.239.44.51]:59206 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503Ab1GNXBk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 19:01:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=Q/TTi95jOwNKmK74wyOCDRH7c9yCgrCDb9khOxRfaZsJZ7wlAGeVuQiX6QzMxYW8Y
	c1GYcfl/DnCJO6Xde8JBA==
MIME-Version: 1.0
In-Reply-To: <20110714220944.GE26786@somewhere.redhat.com>
References: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
 <1310679495-29104-4-git-send-email-vnagarnaik@google.com> <20110714220944.GE26786@somewhere.redhat.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Thu, 14 Jul 2011 16:01:08 -0700
Message-ID: <CAL26m8+0kwrENFkvpr3ihaLyOdKrbUoCX6C1Ywsoy8YGr=EQsQ@mail.gmail.com>
Subject: Re: [PATCH 3/6] trace: Add tracepoints to IRQ work run handler
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 3:09 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Thu, Jul 14, 2011 at 02:38:12PM -0700, Vaibhav Nagarnaik wrote:
>> This is a part of overall effort to trace all the interrupts happening
>> in a system to figure out what time is spent in kernel space versus user
>> space.
>>
>> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
>> ---
>>  include/trace/events/irq.h |   44 ++++++++++++++++++++++++++++++++++++++++++++
>>  kernel/irq_work.c          |    4 ++++
>>  2 files changed, 48 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
>> index e6e72e0..d8fab89 100644
>> --- a/include/trace/events/irq.h
>> +++ b/include/trace/events/irq.h
>> @@ -295,6 +295,50 @@ DEFINE_EVENT(timer_interrupt, timer_nohz_exit,
>>       TP_ARGS(ignore)
>>  );
>>
>> +DECLARE_EVENT_CLASS(irq_work,
>> +
>> +     TP_PROTO(unsigned int ignore),
>> +
>> +     TP_ARGS(ignore),
>> +
>> +     TP_STRUCT__entry(
>> +             __field(        unsigned int,   ignore  )
>> +     ),
>> +
>> +     TP_fast_assign(
>> +             __entry->ignore = ignore;
>> +     ),
>> +
>> +     TP_printk("%u", __entry->ignore)
>> +);
>> +
>> +/**
>> + * irq_work_run_entry - called immediately after entering the irq work
>> + * handler
>> + *
>> + * When used in combination with the irq_work_run_exit tracepoint
>> + * we can determine the irq work handler runtime.
>> + */
>> +DEFINE_EVENT(irq_work, irq_work_run_entry,
>> +
>> +     TP_PROTO(unsigned int ignore),
>> +
>> +     TP_ARGS(ignore)
>> +);
>> +
>> +/**
>> + * irq_work_run_exit - called just before the irq work handler returns
>> + *
>> + * When used in combination with the irq_work_run_entry tracepoint
>> + * we can determine the irq work handler runtime.
>> + */
>> +DEFINE_EVENT(irq_work, irq_work_run_exit,
>> +
>> +     TP_PROTO(unsigned int ignore),
>> +
>> +     TP_ARGS(ignore)
>> +);
>> +
>>  #endif /*  _TRACE_IRQ_H */
>>
>>  /* This part must be outside protection */
>> diff --git a/kernel/irq_work.c b/kernel/irq_work.c
>> index c58fa7d..7e78122 100644
>> --- a/kernel/irq_work.c
>> +++ b/kernel/irq_work.c
>> @@ -9,6 +9,7 @@
>>  #include <linux/module.h>
>>  #include <linux/irq_work.h>
>>  #include <linux/hardirq.h>
>> +#include <trace/events/irq.h>
>>
>>  /*
>>   * An entry can be in one of four states:
>> @@ -125,6 +126,8 @@ void irq_work_run(void)
>>       if (this_cpu_read(irq_work_list) == NULL)
>>               return;
>
> If you don't want to miss any of these interrupts, I suggest you
> call trace_irq_work_run_entry(0) before the above check.
>
> Also I'm adding Peter who maintains this.

Thanks for the catch. I will update it.

>
>>
>> +     trace_irq_work_run_entry(0);
>> +
>>       BUG_ON(!in_irq());
>>       BUG_ON(!irqs_disabled());
>>
>> @@ -149,6 +152,7 @@ void irq_work_run(void)
>>                             next_flags(NULL, IRQ_WORK_BUSY),
>>                             NULL);
>>       }
>> +     trace_irq_work_run_exit(0);
>>  }
>>  EXPORT_SYMBOL_GPL(irq_work_run);
>>
>> --
>> 1.7.3.1
>>
>



Vaibhav Nagarnaik
