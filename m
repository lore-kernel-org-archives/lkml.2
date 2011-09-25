Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab1IYOk4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 10:40:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54659 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895Ab1IYOkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 10:40:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: tom.leiming@gmail.com, mingo@redhat.com, rostedt@goodmis.org
Subject: Re: [RFC PATCH 1/2] PM/runtime: introduce trace points for tracing rpm_* functions
Date: Sun, 25 Sep 2011 16:43:05 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: stern@rowland.harvard.edu, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com
References: <1316664701-15273-1-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1316664701-15273-1-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201109251643.05553.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 22, 2011, tom.leiming@gmail.com wrote:
> From: Ming Lei <tom.leiming@gmail.com>
> 
> This patch introduces 3 trace points to prepare for tracing
> rpm_idle/rpm_suspend/rpm_resume functions, so we can use these
> trace points to replace the current dev_dbg().
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>

I like the patches and would like to push them for 3.2, but I need to
know if the tracing people are OK with them.  Steven, Ingo?

Thanks,
Rafael


> ---
>  include/trace/events/rpm.h |   98 ++++++++++++++++++++++++++++++++++++++++++++
>  kernel/trace/Makefile      |    1 +
>  kernel/trace/rpm-traces.c  |   21 +++++++++
>  3 files changed, 120 insertions(+), 0 deletions(-)
>  create mode 100644 include/trace/events/rpm.h
>  create mode 100644 kernel/trace/rpm-traces.c
> 
> diff --git a/include/trace/events/rpm.h b/include/trace/events/rpm.h
> new file mode 100644
> index 0000000..ecd40bb
> --- /dev/null
> +++ b/include/trace/events/rpm.h
> @@ -0,0 +1,98 @@
> +
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM rpm
> +
> +#if !defined(_TRACE_RUNTIME_POWER_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_RUNTIME_POWER_H
> +
> +#include <linux/ktime.h>
> +#include <linux/tracepoint.h>
> +#include <linux/device.h>
> +
> +/*
> + * The rpm_internal events are used for tracing some important
> + * runtime pm internal functions.
> + */
> +DECLARE_EVENT_CLASS(rpm_internal,
> +
> +	TP_PROTO(struct device *dev, int flags),
> +
> +	TP_ARGS(dev, flags),
> +
> +	TP_STRUCT__entry(
> +		__field(        const char *,   name            )
> +		__field(        int,            flags           )
> +		__field(        int ,   	usage_count	)
> +		__field(        int ,   	disable_depth   )
> +		__field(        int ,   	runtime_auto	)
> +		__field(        int ,   	request_pending	)
> +		__field(        int ,   	irq_safe	)
> +		__field(        int ,   	child_count 	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->name = dev_name(dev);
> +		__entry->flags = flags;
> +		__entry->usage_count = atomic_read(
> +			&dev->power.usage_count);
> +		__entry->disable_depth = dev->power.disable_depth;
> +		__entry->runtime_auto = dev->power.runtime_auto;
> +		__entry->request_pending = dev->power.request_pending;
> +		__entry->irq_safe = dev->power.irq_safe;
> +		__entry->child_count = atomic_read(
> +			&dev->power.child_count);
> +	),
> +
> +	TP_printk("%s flags-%x cnt-%-2d dep-%-2d auto-%-1d p-%-1d"
> +			" irq-%-1d child-%d",
> +			__entry->name, __entry->flags,
> +			__entry->usage_count,
> +			__entry->disable_depth,
> +			__entry->runtime_auto,
> +			__entry->request_pending,
> +			__entry->irq_safe,
> +			__entry->child_count
> +		 )
> +);
> +DEFINE_EVENT(rpm_internal, rpm_suspend,
> +
> +	TP_PROTO(struct device *dev, int flags),
> +
> +	TP_ARGS(dev, flags)
> +);
> +DEFINE_EVENT(rpm_internal, rpm_resume,
> +
> +	TP_PROTO(struct device *dev, int flags),
> +
> +	TP_ARGS(dev, flags)
> +);
> +DEFINE_EVENT(rpm_internal, rpm_idle,
> +
> +	TP_PROTO(struct device *dev, int flags),
> +
> +	TP_ARGS(dev, flags)
> +);
> +
> +TRACE_EVENT(rpm_return_int,
> +	TP_PROTO(struct device *dev, const char *func, int ret),
> +	TP_ARGS(dev, func, ret),
> +
> +	TP_STRUCT__entry(
> +		__field(	const char *,		name		)
> +		__field(	const char *,		func		)
> +		__field(	int,			ret		)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->name = dev_name(dev);
> +		__entry->ret = ret;
> +		__entry->func = func;
> +	),
> +
> +	TP_printk("%s:%s ret=%d", __entry->func, __entry->name, __entry->ret)
> +);
> +
> +#endif /* _TRACE_RUNTIME_POWER_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> index 761c510..56bdab5 100644
> --- a/kernel/trace/Makefile
> +++ b/kernel/trace/Makefile
> @@ -53,6 +53,7 @@ endif
>  obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
>  obj-$(CONFIG_KPROBE_EVENT) += trace_kprobe.o
>  obj-$(CONFIG_TRACEPOINTS) += power-traces.o
> +obj-$(CONFIG_TRACEPOINTS) += rpm-traces.o
>  ifeq ($(CONFIG_TRACING),y)
>  obj-$(CONFIG_KGDB_KDB) += trace_kdb.o
>  endif
> diff --git a/kernel/trace/rpm-traces.c b/kernel/trace/rpm-traces.c
> new file mode 100644
> index 0000000..998949e
> --- /dev/null
> +++ b/kernel/trace/rpm-traces.c
> @@ -0,0 +1,21 @@
> +/*
> + * Power trace points
> + *
> + * Copyright (C) 2009 Ming Lei <tom.leiming@gmail.com>
> + */
> +
> +#include <linux/string.h>
> +#include <linux/types.h>
> +#include <linux/workqueue.h>
> +#include <linux/sched.h>
> +#include <linux/module.h>
> +#include <linux/usb.h>
> +
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/rpm.h>
> +
> +EXPORT_TRACEPOINT_SYMBOL_GPL(rpm_return_int);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(rpm_idle);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(rpm_suspend);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(rpm_resume);
> +
> 

