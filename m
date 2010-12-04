Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab0LDCeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 21:34:23 -0500
Received: from smtp-out.google.com ([74.125.121.35]:20502 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab0LDCeV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 21:34:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=KFa35OD8GYFwyxHLbGH7VfqWpTkpQbrEnHmoWDnwwfEu++CxYC8jIKTD4IYjju+O4K
         SdirhbNZIHXktyei2i4Q==
MIME-Version: 1.0
In-Reply-To: <1291427770.16223.15.camel@gandalf.stny.rr.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
 <1291421609-14665-14-git-send-email-dhsharp@google.com> <1291427770.16223.15.camel@gandalf.stny.rr.com>
From: David Sharp <dhsharp@google.com>
Date: Fri, 3 Dec 2010 18:33:58 -0800
Message-ID: <AANLkTimiMtdfXag6bukxDo21uSDzs0nj4YG-35M2ioiP@mail.gmail.com>
Subject: Re: [PATCH 13/15] small_traces: Add config option to shrink trace events.
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mrubin@google.com,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I considered that, and I generally thing it's a good idea. However, I
also want to use this switch to shrink individual tracepoint event
structures.

eg: sched switch is a high frequency event and it is 68 bytes (60
after these patches)

Can you suggest a syntax for TRACE_EVENT, DECLARE_EVENT_CLASS, etc,
that could express the two versions and produce the right code?

I'm worried about adding even further complexity to the TRACE_EVENT
macros. I could add TRACE_EVENT_SMALL that takes two versions of
TP_STRUCT__entry, TP_fast_assign, and TP_printk each, but then this
will need to be permuted with your TP_CONDITIONAL patches as well.

Thanks,
d#

On Fri, Dec 3, 2010 at 5:56 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> [ Added Frederic on Cc ]
>
> I rather have this as a run time option than a compile time.
>
> You could use two different trace event structures. The normal one and a
> "compact" one. Add to the "trace_options" and when it is set the traces
> are compact.
>
> -- Steve
>
>
> On Fri, 2010-12-03 at 16:13 -0800, David Sharp wrote:
>> This option will remove several fields from trace events to reduce the
>> payload size. Under heavy load, events can be produced faster than they
>> can possibly be written to disk or sent on the network. Shrinking the
>> payload size will enable fitting more traces in the ring buffer, which
>> therefore enables tracing for longer periods, at the cost of losing some
>> relatively unimportant details.
>>
>> Google-Bug-Id: 3224547
>>
>> Signed-off-by: David Sharp <dhsharp@google.com>
>> ---
>>  kernel/trace/Kconfig |   12 ++++++++++++
>>  1 files changed, 12 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
>> index ea37e2f..9c24fe5 100644
>> --- a/kernel/trace/Kconfig
>> +++ b/kernel/trace/Kconfig
>> @@ -403,6 +403,18 @@ config FUNCTION_PROFILER
>>
>>         If in doubt, say N.
>>
>> +config SMALL_TRACES
>> +     bool "Shrink trace events"
>> +     default n
>> +     help
>> +       Minimize the size of trace events. Omits fields from trace event
>> +       header like preempt_count, and lock_depth. Chooses smaller
>> +       alternative event structures. Shrinking the payload size enables
>> +       fitting more traces in the ring buffer, which enables tracing for
>> +       longer periods when the buffer can not be read as fast as it is
>> +       filled, at the cost of losing some details.
>> +
>> +
>>  config FTRACE_MCOUNT_RECORD
>>       def_bool y
>>       depends on DYNAMIC_FTRACE
>
>
>
