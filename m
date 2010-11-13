Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab0KMB4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 20:56:34 -0500
Received: from smtp-out.google.com ([216.239.44.51]:49329 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab0KMB4c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 20:56:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=qwvXCYcVHWZFuKn8IUoR1ZjfRcy+Ohu9gNQ4yr/Fh/4FVJKbvgO4k008tfEUuC0OK9
         p/S71GT8bn29nARWp0hQ==
MIME-Version: 1.0
In-Reply-To: <20101111130212.GD3992@Krystal>
References: <20101111004612.GB32564@Krystal> <4CDBA251.4010505@hitachi.com> <20101111130212.GD3992@Krystal>
From: David Sharp <dhsharp@google.com>
Date: Fri, 12 Nov 2010 17:56:07 -0800
Message-ID: <AANLkTi=EPQ2dJtrg096AwDGE3VKKeoZAHTMQhmj-ahc5@mail.gmail.com>
Subject: Re: [RFD tracing] Tracing ABI Work Plan
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Michael Rubin <mrubin@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 5:02 AM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
> * Masami Hiramatsu (masami.hiramatsu.pt@hitachi.com) wrote:
>> Hi,
>>
>> (2010/11/11 9:46), Mathieu Desnoyers wrote:
>> > A) New ABI for user-space
>> >
>> > This new ABI will provide the features long-awaited by tracing users. We've
>> > already started this discussion by listing the requirements and acknowledging
>> > them. It is now time to start discussing the ABI. Upon disagreement on answering
>> > a specific requirement, two questions will arise:
>> >
>> > 1. How much trouble it really is to take care of this requirement. If the answer
>> >    is "not much", then we simply take care of it.
>> > 2. If it really is a big deal to take care of a requirement at the ABI level,
>> >    then we will have to discuss the use-cases.
>> >
>> > Once we are on the same page with respect to these requirements, we can come up
>> > with an ABI proposal for:
>> >
>> > - Tracing control
>> > - Trace format
>> >
>> >
>> > B) Internal Instrumentation API
>> >
>> > I propose to standardize the instrumentation mechanisms (Tracepoints, Function
>> > Tracer, Dynamic Probes, System Call Tracing, etc), so they can be used by
>> > Ftrace, Perf, and by the new ABI without requiring to build all three tracer
>> > ABI code-bases in the kernel. This involves modularizing the instrumentation
>> > sources, taking the following aspects into account:
>> >
>> > - They should be stand-alone objects, which can be built without a full tracer
>> >   enabled.
>> > - They should offer a "registration/unregistration" API to tracers, so tracers
>> >   can register a callback along with a private data pointer (this would fit
>> >   with the "multiple concurrent tracing session" requirement).
>> > - They should call these callbacks passing the private data pointer when the
>> >   instrumentation is hit.
>> > - They should provide a mechanism to list the available instrumentation (when it
>> >   makes sense) and active instrumentation. E.g., it makes sense for tracepoints
>> >   to list the available tracepoints, but it only makes sense for dynamic probes
>> >   to list the enabled probes.
>> >
>> > Masami Hiramatsu and Frederic Weisbecker already showed interest in undertaking
>> > this task.
>>
>> Actually, I didn't talked about what API should be provided internally.
>> (Yeah, I know LTTng handler want that. However, there is no "external" handler
>>  _inside_ linux kernel tree)
>
> My target here is not LTTng. My goal is to get the ball rolling for the improved
> ABI. If we make sure all instrumentation sources provide a clean API to Ftrace,
> Perf, and eventually the new ABI, then it makes it easier to transition from one
> ABI to another; we would not have to change the "whole world", but rather just
> to switch to the new ABI when it is deemed ready.
>
>> Instead, I and Frederic talked shortly about something like user interface
>> for events. (so it would be more close to A, about controlling)
>
> Yep, this too makes sense.
>
>> As Thomas said, eventually kernel internal tracer should simply provide
>> "events tracing" functionality. User tools will analyze it and it's not
>> kernel's business. I agree with his opinion.
>
> Right.
>
>> From above viewpoint, currently only trace-events(tracepoint-based events)
>> and dynamic-events (kprobe-based events) are providing same interface for
>> users. And, for example, perf's PMU events or ftrace's mcount events aren't
>> shown up under debugfs/tracing/events. IMHO, all events provided by kernel
>> should be there, so that user tools can read the format and control those
>> events same way.
>
> We should decide if we keep this stuff under /debugfs or move it elsewhere. This
> is part of the ABI after all. Independently of where this ends up, the
> operations we need to perform are:
>
> - For each instrumentation source (tracepoints, function tracing, dynamic
>  probes, PMC, ...)
>  - List available instrumentation
>    - Makes sense for tracepoints and PMC, but function graph tracer and dynamic
>      probes might skip this part.
>  - List activated instrumentation
>  - Control interface
>    - Activate/deactivate instrumentation, on a per trace session basis
>      - Note: the concept of "trace session" is currently inexisting in both
>        perf and ftrace. We'll have to think of something in terms of ABI here.
>      - Note2: each instrumentation source will expects its own sets of
>        parameters to specify the instrumentation to control.
>      - Note3: Handling of instrumentation in dynamically loadable modules
>        (which applies also to dynamic probes) might require that we allow the
>        control interface to activate a tracepoint or dynamic probe for a trace
>        session (e.g. by name) before the instrumentation point is listed as
>        available instrumentation. The goal is to deal with modules dynamically
>        loaded and dynamic instrumentation dynamically added while the trace is
>        being recorded; without requiring any user knowledge about
>        module-specific parameters whatsoever.
>
>> For this purpose, I'd like to expand trace-event/dynamic-event framework to
>> those events. It seems that some PMU events can be treated as trace-events,
>> mcount and other parametric events can be treated as dynamic-events.
>>
>> Anyway, those stuffs can be done without new-ring-buffer-ABI things.
>> I'll just expand dyn-events a bit far from here :-)
>
> Steven wanted to clean up his debugfs event description files, so this would fit
> well with this effort, and is indeed an ABI change. One way to do it is to keep
> the old files around and come up with a new hierarchy for the "cleaned up"
> files, along with the new features you want to add.
>
> Also, we might want to consider moving the debugfs event description files to a
> slightly different format (see my metadata proposal). It expands a bit on the
> current information, and allows us to deal with bitfields much more elegantly.
> However this is also an ABI change.

Along this vein, we'd like to see a version number somewhere in the
interface. Mostly, this should version the ring buffer data headers,
event description format (not content), and control file interface
(enable, filter, etc). I think the text format that comes out of the
"trace" file doesn't necessarily need to be versioned. A simple
major.minor string would be fine.

>
> Thanks,
>
> Mathieu
>
>>
>> Best Regards,
>>
>> --
>> Masami HIRAMATSU
>> 2nd Dept. Linux Technology Center
>> Hitachi, Ltd., Systems Development Laboratory
>> E-mail: masami.hiramatsu.pt@hitachi.com
>
> --
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com
>
