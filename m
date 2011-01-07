Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab1AGJWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 04:22:03 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42609 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab1AGJV6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 04:21:58 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTimsR3=BKSF8EyASu4_T_vTznw4yEqmxPS8gOQCy@mail.gmail.com>
References: <AANLkTimsR3=BKSF8EyASu4_T_vTznw4yEqmxPS8gOQCy@mail.gmail.com>
Date: Fri, 7 Jan 2011 14:51:57 +0530
X-Google-Sender-Auth: S77Cr0HY8bkMQ57FODVx9593KLI
Message-ID: <AANLkTik0i5xeNG_+tgdfWRjC1cQAbm+-0fDNGih5KfRx@mail.gmail.com>
Subject: Re: [PATCH] tracing, perf : add cpu hotplug trace events
From: Amit Kucheria <amit.kucheria@linaro.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        rostedt@goodmis.org, fweisbec@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vincent,

Adding Steve Rostedt and Frederic Weisbecker to CC list as maintainers
of the trace subsystem

Also, a sample patch against your SoC on how you plan to use this
might be useful. You can mark the patch as RFC for now.

More comments below.

On Tue, Jan 4, 2011 at 3:20 PM, Vincent Guittot
<vincent.guittot@linaro.org> wrote:
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
> include/trace/events/hotplug.h |   71 ++++++++++++++++++++++++++++++++++++++++
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

s/HOTPLUG_KERNEL/HOTPLUG_CORE/  ?

Comments regarding what these mean would be nice. ARM has core, arch
and machine level configuration, but x86, for example might not use
machine at all.

> +
> +TRACE_EVENT(hotplug_start,
> +
> + TP_PROTO(unsigned int type, unsigned int step, unsigned int cpuid),
> +
> + TP_ARGS(type, step, cpuid),
> +
> + TP_STRUCT__entry(
> + __field(u32, type)
> + __field(u32, step)
> + __field(u32, cpuid)
> + ),
> +
> + TP_fast_assign(
> + __entry->type = type;
> + __entry->step = step;
> + __entry->cpuid = cpuid;
> + ),
> +
> + TP_printk("type=%lu step=%lu cpuid=%lu", (unsigned long)__entry->type,
> + (unsigned long)__entry->step, (unsigned long)__entry->cpuid)
> +);
> +
> +TRACE_EVENT(hotplug_end,
> +
> + TP_PROTO(unsigned int type, unsigned int step, unsigned int cpuid),
> +
> + TP_ARGS(type, step, cpuid),
> +
> + TP_STRUCT__entry(
> + __field(u32, type)
> + __field(u32, step)
> + __field(u32, cpuid)
> + ),
> +
> + TP_fast_assign(
> + __entry->type = type;
> + __entry->step = step;
> + __entry->cpuid = cpuid;
> + ),
> +
> + TP_printk("type=%lu step=%lu cpuid=%lu", (unsigned long)__entry->type,
> + (unsigned long)__entry->step, (unsigned long)__entry->cpuid)
> +);
> +
> +#endif /* _TRACE_HOTPLUG_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> --
> 1.7.0.4
