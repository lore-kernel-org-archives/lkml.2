Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab0KWGkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 01:40:07 -0500
Received: from mga03.intel.com ([143.182.124.21]:35390 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab0KWGkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 01:40:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,241,1288594800"; 
   d="scan'208";a="352097553"
Subject: Re: [RFC][PATCH] perf: Tracepoint collection support
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, tglx <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, fweisbec <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, paulus <paulus@samba.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTimyvB5tkHuYyitT_UA3sg0-TY+g6L040ncZQxnr@mail.gmail.com>
References: <1290445737.2072.338.camel@laptop>
	 <AANLkTimyvB5tkHuYyitT_UA3sg0-TY+g6L040ncZQxnr@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Nov 2010 14:41:05 +0800
Message-ID: <1290494465.2405.42.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Peter Zijlstra <peterz@infradead.org>
> Date: Tue, Nov 23, 2010 at 1:08 AM
> 
> Due to popular request this implements a tracepoint collection event
> { .type = PERF_TYPE_TRACEPOINT, .config = ~0ULL }. by default it
> contains no tracepoints, but tracepoints can be added using:
>  ioctl(fd, PERF_EVENT_IOC_ADD_TP, tp_id);
> 
> In order to provide a dense ID space for tracepoints replace the
> tracepoint ID generation with an IDR tree.
> 
> Furthermore, replace the whole trace-event <-> perf infrastructure with
> multiple IDR trees.
> 
> We keep an IDR tree per perf_event, this tree collects all the
> tracepoints the perf_event is interested in and stores the corresponding
> 'node'. This tree manages the node life-time.
> 
> Then we keep an IDR tree per task and per CPU. Both of these trees are
> accumulation trees, they're the union of all events of that particular
> task/CPU. It stores a list of 'node's.
> 
> Then, when a trace-event happens, we look for it in both the CPU tree as
> well as the current task tree. For both, if present we iterate the node
> list and deliver the event to the corresponding perf_events.
> 
> We manage the IDR trees on perf_event creation/destruction and
> ioctl(ADD_TP) time. This mean that pmu::{add,remove} are empty ops, the
> per-task stat is taken care of in the per-task tree after all.
> 
> The patch is lightly tested and wants some serious testing/review before
> merging.
> 
> Also, it has a number of open points, like the breakpoint much it
> suffers from the pmu::event_init() vs context-attach inversion, and the
> whole fancy inherited context avoid switch logic needs a fix.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/ftrace_event.h    |    9
>  include/linux/perf_event.h      |    9
>  include/linux/sched.h           |    9
>  include/trace/ftrace.h          |    4
>  kernel/perf_event.c             |  389 ++++++++++++++++++++++++++++++++++++++--
>  kernel/trace/trace_event_perf.c |   95 ++++-----
>  kernel/trace/trace_kprobe.c     |   10 -
>  kernel/trace/trace_output.c     |   77 +------
>  kernel/trace/trace_syscalls.c   |    8
>  9 files changed, 459 insertions(+), 151 deletions(-)
> 
> Index: linux-2.6/include/linux/ftrace_event.h
> ===================================================================
> --- linux-2.6.orig/include/linux/ftrace_event.h
> +++ linux-2.6/include/linux/ftrace_event.h
> @@ -87,7 +87,6 @@ struct trace_event_functions {
>  };
> 
>  struct trace_event {
> -       struct hlist_node               node;
>        struct list_head                list;

Cool patch!

ftrace_event_list/trace_event::list can be deleted now.

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index cba21d3..f3c03ac 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -87,7 +87,6 @@ struct trace_event_functions {
 };
 
 struct trace_event {
-	struct list_head		list;
 	int				type;
 	struct trace_event_functions	*funcs;
 };
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 8f30dd3..7803022 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -664,8 +664,6 @@ struct trace_event *ftrace_find_event(int type)
 	return idr_find(&trace_type_idr, type);
 }
 
-static LIST_HEAD(ftrace_event_list);
-
 void trace_event_read_lock(void)
 {
 	down_read(&trace_event_mutex);
@@ -703,10 +701,7 @@ int register_ftrace_event(struct trace_event *event)
 	if (WARN_ON(!event->funcs))
 		goto out;
 
-	INIT_LIST_HEAD(&event->list);
-
 	if (!event->type) {
-		struct list_head *list = NULL;
 		int type, err;
 
 		err = idr_pre_get(&trace_type_idr, GFP_KERNEL);
@@ -723,10 +718,6 @@ int register_ftrace_event(struct trace_event *event)
 		}
 
 		event->type = type;
-		list = &ftrace_event_list;
-
-		list_add_tail(&event->list, list);
-
 	} else if (event->type > __TRACE_LAST_TYPE) {
 		printk(KERN_WARNING "Need to add type to trace.h\n");
 		WARN_ON(1);
@@ -760,7 +751,6 @@ EXPORT_SYMBOL_GPL(register_ftrace_event);
 int __unregister_ftrace_event(struct trace_event *event)
 {
 	idr_remove(&trace_type_idr, event->type);
-	list_del(&event->list);
 	return 0;
 }
 

Thanks,
Lin Ming

