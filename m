Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab1I0UEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 16:04:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59795 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084Ab1I0UEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 16:04:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: tom.leiming@gmail.com, rostedt@goodmis.org
Subject: Re: [PATCH v1 1/2] PM/runtime: introduce trace points for tracing rpm_* functions
Date: Tue, 27 Sep 2011 22:06:33 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: stern@rowland.harvard.edu, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, fweisbec@gmail.com,
        Ming Lei <ming.lei@canonical.com>
References: <1317118338-4040-1-git-send-email-tom.leiming@gmail.com> <1317118338-4040-2-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1317118338-4040-2-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201109272206.34176.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 27, 2011, tom.leiming@gmail.com wrote:
> From: Ming Lei <ming.lei@canonical.com>
> 
> This patch introduces 3 trace points to prepare for tracing
> rpm_idle/rpm_suspend/rpm_resume functions, so we can use these
> trace points to replace the current dev_dbg().
> 
> Cc: Steven Rostedt rostedt@goodmis.org
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
> v1: takes Steven's suggestions
> 	- use __assign_str to dump device name to trace buffer
> 	- pass _THIS_IP_ to trace_rpm_return_int

Steven, do the patches look good to you now?

Rafael


> ---
>  include/trace/events/rpm.h |   99 ++++++++++++++++++++++++++++++++++++++++++++
>  kernel/trace/Makefile      |    1 +
>  kernel/trace/rpm-traces.c  |   21 +++++++++
>  3 files changed, 121 insertions(+), 0 deletions(-)
>  create mode 100644 include/trace/events/rpm.h
>  create mode 100644 kernel/trace/rpm-traces.c
> 
> diff --git a/include/trace/events/rpm.h b/include/trace/events/rpm.h
> new file mode 100644
> index 0000000..36805d9
> --- /dev/null
> +++ b/include/trace/events/rpm.h
> @@ -0,0 +1,99 @@
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
> +		__string(       name,		dev_name(dev)	)
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
> +		__assign_str(name, dev_name(dev));
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
> +			__get_str(name), __entry->flags,
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
> +	TP_PROTO(struct device *dev, unsigned long ip, int ret),
> +	TP_ARGS(dev, ip, ret),
> +
> +	TP_STRUCT__entry(
> +		__string(       name,		dev_name(dev))
> +		__field(	unsigned long,		ip	)
> +		__field(	int,			ret	)
> +	),
> +
> +	TP_fast_assign(
> +		__assign_str(name, dev_name(dev));
> +		__entry->ip = ip;
> +		__entry->ret = ret;
> +	),
> +
> +	TP_printk("%pS:%s ret=%d", __entry->ip, __get_str(name),
> +		__entry->ret)
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
> + * Copyright (C) 2009 Ming Lei <ming.lei@canonical.com>
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

