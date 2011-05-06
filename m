Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab1EFUU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 16:20:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54647 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392Ab1EFUUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 16:20:55 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=UZYI7n2t75YA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=QyXUC8HyAAAA:8 a=KprvwOr0OoX29dIBteQA:9 a=Ldm_36VrNXLqVPPiywEA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
From: Steven Rostedt <rostedt@goodmis.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4DC45537.6070609@linux.intel.com>
References: <4DC45537.6070609@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 06 May 2011 16:20:52 -0400
Message-ID: <1304713252.25414.2532.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-06 at 13:08 -0700, Arjan van de Ven wrote:
> From c2db3ab8cff0d1cfb9582fc149df2794978a332e Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Thu, 5 May 2011 23:55:18 -0400
> Subject: [PATCH] Regression: partial revert "tracing: Remove lock_depth 
> from event entry"
> 
> This patch partially reverts commit 
> e6e1e2593592a8f6f6380496655d8c6f67431266.
> That commit changed the structure layout of the trace structure, which in
> turn broke PowerTOP (1.9x generation) quite badly.
> 
> I appreciate not wanting to expose the variable in question, and 
> PowerTOP was
> not using it, so I've replaced the variable with just a padding field....
> ... that way if in the future a new field is needed it can just use this 
> padding
> variable.
> 

I strongly NACK this!

We can not be locked down in the format of the trace events.

THAT'S WHY I EXPORTED THE FORMATS IN THE FIRST PLACE

User tools that do not parse the formats, are broken. Look at this
patch. It adds nothing but padding, wasted space in the ring buffer.
Why??? Because a tool read raw binary data without using the correct
means to extract it. I already have a user space library that does the
work for you. Perf currently uses it (although, an older version of it,
and it is hardcoded into perf).

Sure, perhaps event names should not be modfied, nor should some fields
without true reason. But come on, lockdepth?  This was added by Frederic
to help with the BKL removal. I think he only used it for a very short
time. It probably should have never been there in the first place. But I
do not want to waste 4 bytes of the ring buffer for every event because
of a broken tool.

Note, coming soon, we will probably be removing preempt count, flags,
and even the pid. What then? Is this broken tool going to prevent us
from moving forward?

I could understand this if we did not give you the means to parse the
data. But we did. It's been there as long as the trace events
themselves.

The format of the event format files are the ABI, not the raw data of
the events themselves.

-- Steve

> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>   include/linux/ftrace_event.h |    1 +
>   kernel/trace/trace.c         |    1 +
>   kernel/trace/trace_events.c  |    1 +
>   3 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 22b32af1..b5a550a 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -37,6 +37,7 @@ struct trace_entry {
>       unsigned char        flags;
>       unsigned char        preempt_count;
>       int            pid;
> +    int            padding;
>   };
> 
>   #define FTRACE_MAX_EVENT                        \
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index d38c16a..1cb49be 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1110,6 +1110,7 @@ tracing_generic_entry_update(struct trace_entry 
> *entry, unsigned long flags,
> 
>       entry->preempt_count        = pc & 0xff;
>       entry->pid            = (tsk) ? tsk->pid : 0;
> +    entry->padding            = 0;
>       entry->flags =
>   #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
>           (irqs_disabled_flags(flags) ? TRACE_FLAG_IRQS_OFF : 0) |
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index e88f74f..2fe1103 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -116,6 +116,7 @@ static int trace_define_common_fields(void)
>       __common_field(unsigned char, flags);
>       __common_field(unsigned char, preempt_count);
>       __common_field(int, pid);
> +    __common_field(int, padding);
> 
>       return ret;
>   }


