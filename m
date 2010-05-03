Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546Ab0ECOlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 10:41:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57441 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465Ab0ECOlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 10:41:14 -0400
X-Authority-Analysis: v=1.1 cv=elpKMhBbP+pQyLZqL930WohJ6E0KICKd8OrLrcMNK78= c=1 sm=0 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=9GSaAerw8hG0zXmBTpMA:9 a=ylCiACQ30IIVRyfFsDQA:7 a=lamOiykTcJfC4Dpifw0uaSOZHvMA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: perf, ftrace and MCEs
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20100501181212.GA25352@liondog.tnic>
References: <20100501181212.GA25352@liondog.tnic>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 03 May 2010 10:41:12 -0400
Message-ID: <1272897672.9739.218.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-01 at 20:12 +0200, Borislav Petkov wrote:
> Hi,
> 
> so I finally had some spare time to stare at perf/ftrace code and ponder
> on how to use those facilities for MCE collecting and reporting. Btw, I
> have to say, it took me quite a while to understand what goes where - my
> suggestion to anyone who tries to understand how perf/ftrace works is
> to do make <file.i> where there is at least one trace_XXX emit record
> function call and start untangling code paths from there.
> 
> So anyway, here are some questions I had, I just as well may've missed
> something so please correct me if I'm wrong:
> 
> 1. Since machine checks can happen at any time, we need to have the
> MCE tracepoint (trace_mce_record() in <include/trace/events/mce.h>)
> always enabled. This, in turn, means that we need the ftrace/perf
> infrastructure always compiled in (lockless ring buffer, perf_event.c
> stuff) on any x86 system so that MCEs can be handled at anytime. Is this
> going to be ok to be enabled on _all_ machines, hmmm... I dunno, maybe
> only a subset of those facilites at least.

I'm not exactly sure what you goal is, but if you need to do something
directly, you can bypass ftrace and perf. All trace events can be
connected by anything even when ftrace and perf are not enabled.

That is, you need to connect to the tracepoint and write you own
callback. This can be done pretty much at anytime during boot up. To see
how to connect to a trace point, you can look at
register_trace_sched_switch() in kernel/trace/ftrace.c. This registers a
callback to the trace_sched_switch() trace point in sched.c.

> 
> 2. Tangential to 1., we need that "thin" software layer prepared for
> decoding and reporting them as early as possible. event_trace_init() is
> an fs_initcall and executed too late, IMHO. The ->perf_event_enable in
> the ftrace_event_call is enabled even later on the perf init path over
> the sys_perf_even_open which is at userspace time. In our case, this is
> going be executed by the error logging and decoding daemon I guess.
> 
> 3. Since we want to listen for MCEs all the time, the concept of
> enabling and disabling those events does not apply in the sense of
> performance profiling. IOW, MCEs need to be able to be logged to the
> ring buffer at any time. I guess this is easily done - we simply enable
> MCE events at the earliest moment possible and disable them on shutdown;
> done.

This looks like a good reason to have your own handler. More than one
callback may be registered to a tracepoint, so you do not need to worry
about having other handlers affect your code.

-- Steve

> 
> So yeah, some food for thought but what do you guys think?
> 
> Thanks.
> 


