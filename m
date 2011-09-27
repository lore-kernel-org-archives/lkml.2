Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479Ab1I0BLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 21:11:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42373 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab1I0BLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 21:11:36 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=gtOWHpAUYCwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8 a=BJyQ-Pcy2LdPclnIuEQA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [RFC PATCH 1/2] PM/runtime: introduce trace points for tracing
 rpm_* functions
From: Steven Rostedt <rostedt@goodmis.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: rjw@sisk.pl, stern@rowland.harvard.edu,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, fweisbec@gmail.com
Date: Mon, 26 Sep 2011 21:11:32 -0400
In-Reply-To: <CACVXFVPQokm21c+do5+DaOvUAme2LaNiwrNw_Tm66KuOxPb1jA@mail.gmail.com>
References: <1316664701-15273-1-git-send-email-tom.leiming@gmail.com>
	 <1317044445.26514.5.camel@gandalf.stny.rr.com>
	 <CACVXFVPQokm21c+do5+DaOvUAme2LaNiwrNw_Tm66KuOxPb1jA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317085894.26514.26.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-27 at 08:53 +0800, Ming Lei wrote:
> Hi,
> 
> On Mon, Sep 26, 2011 at 9:40 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Thu, 2011-09-22 at 12:11 +0800, tom.leiming@gmail.com wrote:
> >> From: Ming Lei <tom.leiming@gmail.com>
> >>
> >> This patch introduces 3 trace points to prepare for tracing
> >> rpm_idle/rpm_suspend/rpm_resume functions, so we can use these
> >> trace points to replace the current dev_dbg().
> >>
> >> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> >> ---
> >>  include/trace/events/rpm.h |   98 ++++++++++++++++++++++++++++++++++++++++++++
> >>  kernel/trace/Makefile      |    1 +
> >>  kernel/trace/rpm-traces.c  |   21 +++++++++
> >>  3 files changed, 120 insertions(+), 0 deletions(-)
> >>  create mode 100644 include/trace/events/rpm.h
> >>  create mode 100644 kernel/trace/rpm-traces.c
> >>
> >> diff --git a/include/trace/events/rpm.h b/include/trace/events/rpm.h
> >> new file mode 100644
> >> index 0000000..ecd40bb
> >> --- /dev/null
> >> +++ b/include/trace/events/rpm.h
> >> @@ -0,0 +1,98 @@
> >> +
> >> +#undef TRACE_SYSTEM
> >> +#define TRACE_SYSTEM rpm
> >> +
> >> +#if !defined(_TRACE_RUNTIME_POWER_H) || defined(TRACE_HEADER_MULTI_READ)
> >> +#define _TRACE_RUNTIME_POWER_H
> >> +
> >> +#include <linux/ktime.h>
> >> +#include <linux/tracepoint.h>
> >> +#include <linux/device.h>
> >> +
> >> +/*
> >> + * The rpm_internal events are used for tracing some important
> >> + * runtime pm internal functions.
> >> + */
> >> +DECLARE_EVENT_CLASS(rpm_internal,
> >> +
> >> +     TP_PROTO(struct device *dev, int flags),
> >> +
> >> +     TP_ARGS(dev, flags),
> >> +
> >> +     TP_STRUCT__entry(
> >> +             __field(        const char *,   name            )
> >> +             __field(        int,            flags           )
> >> +             __field(        int ,           usage_count     )
> >> +             __field(        int ,           disable_depth   )
> >> +             __field(        int ,           runtime_auto    )
> >> +             __field(        int ,           request_pending )
> >> +             __field(        int ,           irq_safe        )
> >> +             __field(        int ,           child_count     )
> >> +     ),
> >> +
> >> +     TP_fast_assign(
> >> +             __entry->name = dev_name(dev);
> >
> > Don't use pointers, you must copy the name here. Otherwise, if the trace
> > is read after the device has left, you will be referencing a invalid
> > pointer and possible crash the kernel.
> 
> Yes, you right, but __get_str() may introduce some extra loading, could
> it be changed to below just like what dev_printk does?
> 
>                    __entry->name = dev ? dev_name(dev) : NULL;

Doesn't help. You just stored a pointer into the buffer. Now if the
device's module is removed, when you go and read the buffer you will be
reading a string that no longer exists.

Not to mention, this will never work with tools such as perf or
trace-cmd, that will just get a pointer address and will try to read a
string that points inside the kernel.


> 
> >
> > We have ways to express dynamic string fields. Use them.
> >
> >> +             __entry->flags = flags;
> >> +             __entry->usage_count = atomic_read(
> >> +                     &dev->power.usage_count);
> >> +             __entry->disable_depth = dev->power.disable_depth;
> >> +             __entry->runtime_auto = dev->power.runtime_auto;
> >> +             __entry->request_pending = dev->power.request_pending;
> >> +             __entry->irq_safe = dev->power.irq_safe;
> >> +             __entry->child_count = atomic_read(
> >> +                     &dev->power.child_count);
> >> +     ),
> >> +
> >> +     TP_printk("%s flags-%x cnt-%-2d dep-%-2d auto-%-1d p-%-1d"
> >> +                     " irq-%-1d child-%d",
> >> +                     __entry->name, __entry->flags,
> >> +                     __entry->usage_count,
> >> +                     __entry->disable_depth,
> >> +                     __entry->runtime_auto,
> >> +                     __entry->request_pending,
> >> +                     __entry->irq_safe,
> >> +                     __entry->child_count
> >> +              )
> >> +);
> >> +DEFINE_EVENT(rpm_internal, rpm_suspend,
> >> +
> >> +     TP_PROTO(struct device *dev, int flags),
> >> +
> >> +     TP_ARGS(dev, flags)
> >> +);
> >> +DEFINE_EVENT(rpm_internal, rpm_resume,
> >> +
> >> +     TP_PROTO(struct device *dev, int flags),
> >> +
> >> +     TP_ARGS(dev, flags)
> >> +);
> >> +DEFINE_EVENT(rpm_internal, rpm_idle,
> >> +
> >> +     TP_PROTO(struct device *dev, int flags),
> >> +
> >> +     TP_ARGS(dev, flags)
> >> +);
> >> +
> >> +TRACE_EVENT(rpm_return_int,
> >> +     TP_PROTO(struct device *dev, const char *func, int ret),
> >> +     TP_ARGS(dev, func, ret),
> >> +
> >> +     TP_STRUCT__entry(
> >> +             __field(        const char *,           name            )
> >> +             __field(        const char *,           func            )
> >> +             __field(        int,                    ret             )
> >> +     ),
> >> +
> >> +     TP_fast_assign(
> >> +             __entry->name = dev_name(dev);
> >
> > Same here.
> >
> >> +             __entry->ret = ret;
> >> +             __entry->func = func;
> >
> > And here. But as this is just __func__, you could use %pS and save the
> > pointer to the function. This is acceptable as kallsyms will will used
> > to find the function, and instead pass in __THIS_IP__ to the tracepoint.
> 
> IMO, __func__ is better than %pS here because %pS will dump some
> offset info (such as runtime_suspend+0x0/0x158), but which is
> not needed in this case.( we just need to make return value to match the
> previous function name, such as below)

This will only work with reading the trace data
from /debug/tracing/trace, but not from any tools. The pS *will* work
with the tools as the tools load the kallsyms data, and is smart enough
to figure this pointer out.

-- Steve

> 
>           rpm_suspend: omap_hsmmc.0 flags=9
>           ...
>           rpm_return_int: rpm_suspend:omap_hsmmc.0 ret=0
> 
> >
> > -- Steve
> >
> >
> >> +     ),
> >> +
> >> +     TP_printk("%s:%s ret=%d", __entry->func, __entry->name, __entry->ret)
> >> +);
> >> +
> >> +#endif /* _TRACE_RUNTIME_POWER_H */
> >> +
> >> +/* This part must be outside protection */
> >> +#include <trace/define_trace.h>
> >> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> >> index 761c510..56bdab5 100644
> >> --- a/kernel/trace/Makefile
> >> +++ b/kernel/trace/Makefile
> >> @@ -53,6 +53,7 @@ endif
> >>  obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
> >>  obj-$(CONFIG_KPROBE_EVENT) += trace_kprobe.o
> >>  obj-$(CONFIG_TRACEPOINTS) += power-traces.o
> >> +obj-$(CONFIG_TRACEPOINTS) += rpm-traces.o
> >>  ifeq ($(CONFIG_TRACING),y)
> >>  obj-$(CONFIG_KGDB_KDB) += trace_kdb.o
> >>  endif
> >> diff --git a/kernel/trace/rpm-traces.c b/kernel/trace/rpm-traces.c
> >> new file mode 100644
> >> index 0000000..998949e
> >> --- /dev/null
> >> +++ b/kernel/trace/rpm-traces.c
> >> @@ -0,0 +1,21 @@
> >> +/*
> >> + * Power trace points
> >> + *
> >> + * Copyright (C) 2009 Ming Lei <tom.leiming@gmail.com>
> >> + */
> >> +
> >> +#include <linux/string.h>
> >> +#include <linux/types.h>
> >> +#include <linux/workqueue.h>
> >> +#include <linux/sched.h>
> >> +#include <linux/module.h>
> >> +#include <linux/usb.h>
> >> +
> >> +#define CREATE_TRACE_POINTS
> >> +#include <trace/events/rpm.h>
> >> +
> >> +EXPORT_TRACEPOINT_SYMBOL_GPL(rpm_return_int);
> >> +EXPORT_TRACEPOINT_SYMBOL_GPL(rpm_idle);
> >> +EXPORT_TRACEPOINT_SYMBOL_GPL(rpm_suspend);
> >> +EXPORT_TRACEPOINT_SYMBOL_GPL(rpm_resume);
> >> +
> >
> >
> >
> 
> 
> thanks,


