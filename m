Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab1AGPMR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:12:17 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58806 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab1AGPMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:12:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ihbOjkhGsnO47nVvAoZ7mczy6VT3T7bXsJX3ueRwStzfkfa4xdfTe0PIvG5L1aqWZJ
         mAY7gm+nbe6QnIdhOwXeyDTFvv5QJ7+Z8G4dxYTiufHzTPUgW241BLOFm7yqGvlULr7q
         ACS8GWMrh0R1dv4mJSjqdHxtcPAAFxb3b0FNU=
Date: Fri, 7 Jan 2011 16:12:10 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Amit Kucheria <amit.kucheria@linaro.org>
Subject: Re: [PATCH] tracing, perf : add cpu hotplug trace events
Message-ID: <20110107151200.GB1736@nowhere>
References: <AANLkTimsR3=BKSF8EyASu4_T_vTznw4yEqmxPS8gOQCy@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimsR3=BKSF8EyASu4_T_vTznw4yEqmxPS8gOQCy@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 10:50:36AM +0100, Vincent Guittot wrote:
> Please find below a proposal for adding new trace events for cpu
> hotplug.The goal is to measure the latency of each part (kernel,
> architecture and platform) and also to trace the cpu hotplug activity
> with other power events. I have tested these traces events on an arm
> platform
> 
> Comments are welcome.
> 
> Date: Wed, 15 Dec 2010 11:22:21 +0100
> Subject: [PATCH] hotplug tracepoint
> 
> this patch adds new events for cpu hotplug tracing
> * plug/unplug sequence
> * architecture and machine latency measurements
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
> include/trace/events/hotplug.h |   71 ++++++++++++++++++++++++++++++++++++++++
> 1 files changed, 71 insertions(+), 0 deletions(-)
> create mode 100644 include/trace/events/hotplug.h
> 
> diff --git a/include/trace/events/hotplug.h b/include/trace/events/hotplug.h
> new file mode 100644
> index 0000000..51c86ab
> --- /dev/null
> +++ b/include/trace/events/hotplug.h
> @@ -0,0 +1,71 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM hotplug
> +
> +#if !defined(_TRACE_HOTPLUG_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_HOTPLUG_H
> +
> +#include <linux/ktime.h>
> +#include <linux/tracepoint.h>
> +
> +#ifndef _TRACE_HOTPLUG_ENUM_
> +#define _TRACE_HOTPLUG_ENUM_
> +enum hotplug_type {
> + HOTPLUG_UNPLUG = 0,
> + HOTPLUG_PLUG = 1
> +};
> +
> +enum hotplug_step {
> + HOTPLUG_KERNEL = 0,
> + HOTPLUG_ARCH = 1,
> + HOTPLUG_MACH = 2
> +};
> +#endif
> +
> +TRACE_EVENT(hotplug_start,

hotplug is way too generic.

cpu_hotplug may be?

> +
> + TP_PROTO(unsigned int type, unsigned int step, unsigned int cpuid),

I feel a bit uncomfortable with these opaque type and step.

What about splitting the events:

	cpu_down_start
	cpu_down_end

	cpu_up_start
	cpu_up_end

This ways they are much more self-explanatory.

I also feel uncomfortable about exposing arch step details in core
tracepoints.

But if we consider the following sequence:

	cpu_down() {
		__cpu_disable() {
			platform_cpu_disable();
		}
	}

Then exposing start/end of cpu_disable() makes sense, by way of:

	cpu_arch_disable_start
        cpu_arch_disable_end

        cpu_arch_enable_start
        cpu_arch_enable_end


	cpu_arch_die_start
        cpu_arch_die_end

        cpu_arch_die_start
        cpu_arch_die_end

Because they are arch events that you can retrieve everywhere, the tracepoints
are still called from the code code.

Now for the machine part, it's very highly arch specific, most notably for arm
so I wonder if it would make more sense to keep that seperate into arch
tracepoints.

How does that all look? I hope I'm not overengineering.

Creating such series of similar tracepoints is quite easy and quick using
DECLARE_EVENT_CLASS and DEFINE_EVENT.

> +
> + TP_ARGS(type, step, cpuid),
> +
> + TP_STRUCT__entry(
> + __field(u32, type)
> + __field(u32, step)
> + __field(u32, cpuid)
> + ),

And please use a proper indentation for trace_events.
You can have a look at the examples in include/trace/events/
