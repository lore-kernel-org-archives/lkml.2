Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab1EQUHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 16:07:33 -0400
Received: from smtp-out.google.com ([74.125.121.67]:22037 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217Ab1EQUHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 16:07:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=JW3XOVyMvGGOENax1qUF9NKyHeGIT3MBkYDgCBQcndbLSdhVea6VUrrdqmfmO5TadT
         B/seP7nRrzz32okvJrCw==
MIME-Version: 1.0
In-Reply-To: <1305655283.5456.753.camel@gandalf.stny.rr.com>
References: <1304467520-31530-1-git-send-email-vnagarnaik@google.com>
 <1305059241-7629-1-git-send-email-vnagarnaik@google.com> <1305655283.5456.753.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Tue, 17 May 2011 13:06:59 -0700
Message-ID: <BANLkTi=dXC=e6v7Zm5K9Gb=155XHDZpxyw@mail.gmail.com>
Subject: Re: [PATCH v2] trace: Schedule a delayed work to call wakeup()
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 11:01 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2011-05-10 at 13:27 -0700, Vaibhav Nagarnaik wrote:
>> The patch schedules a delayed work after 2 ms once an event commit calls
>> to wake up the trace wait_queue. This removes the delay caused by
>> contention on spin lock in wakeup() and amortizes the wakeup() calls
>> scheduled over the 2 ms period.
>>
>> In the following example, the script enables the sys_enter_getuid and
>> sys_exit_getuid tracepoints and runs the getuid_microbench in parallel
>> with the given number of processes. The output clearly shows the latency
>> increase caused by contentions.
>>
>
> Have you taken a look at irq_work() instead of delayed work? This would
> probably allow us to call the wakeup version for all events.
>
> See kernel/perf_events.c for details.
>
> -- Steve
>

I looked at irq_work() as used in perf_event.c and changed the ftrace
wakeup logic to that. I found that the latencies are still bad and don't
scale very well. Mostly because the contention moved to irq_work_queue
and in the irq work handler.

The reason to have delayed work is to have the wakeups amortize over
different calls and it is easier because all the events have a common
wakeup logic.

Also, when you talk about having a wakeup version for events, do you see
different wakeup handlers depending on the event? I can see that perf
has struct irq_work as part of the event structure, but every event has
the same wakeup handler.


Vaibhav Nagarnaik
