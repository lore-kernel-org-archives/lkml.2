Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934696Ab0KQMIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 07:08:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47966 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934118Ab0KQMIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 07:08:04 -0500
Date: Wed, 17 Nov 2010 13:07:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: [patch] trace: Add user-space event tracing/injection
Message-ID: <20101117120740.GA24972@elte.hu>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
 <4CE38C53.8090606@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE38C53.8090606@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@kernel.org> wrote:

> (Trimming CC for sanity.)

[ Added back Linus (in case he wants to object to the new prctl()) and lkml. ]

> On 11/16/10 11:04 PM, Thomas Gleixner wrote:
> >'trace' is our shot at improving the situation: it aims at providing a
> >simple to use and straightforward tracing tool based on the perf
> >infrastructure and on the well-known perf profiling workflow:
> >
> >    trace record firefox          # trace firefox and all child tasks,
> >                                    put it into trace.data
> >
> >    trace summary                 # show quick overview of the trace,
> >                                    based on trace.data
> >
> >    trace report                  # detailed traces, based on trace.data
> 
> Nice work guys!
> 
> Does this concept lend itself to tracing latencies in userspace applications that 
> run in virtual machines (e.g. the Java kind)? I'm of course interested in this 
> because of Jato [1] where bunch of interesting things can cause jitter: JIT 
> compilation, GC, kernel, and the actual application doing something (in either 
> native code or JIT'd code). It's important to be able to measure where "slowness" 
> to desktop applications and certain class of server applications comes from to be 
> able to improve things.

Makes quite a bit of sense.

How about the attached patch? It works fine with the simple testcase included in the 
changelog. There's a common-sense limit on the message size - but otherwise it adds 
support for apps to generate a free-form string trace event.

Thanks,

	Ingo

---------------------------------->
Subject: trace: Add user-space event tracing/injection
From: Ingo Molnar <mingo@elte.hu>
Date: Wed Nov 17 10:11:53 CET 2010

This feature (suggested by Darren Hart and Pekka Engberg) allows user-space
programs to print trace events in a very simple and self-contained way:

 #include <sys/prctl.h>
 #include <string.h>

 #define PR_TASK_PERF_USER_TRACE 35

 int main(void)
 {
         char *msg = "Hello World!\n";

         prctl(PR_TASK_PERF_USER_TRACE, msg, strlen(msg));

         return 0;
 }

These show up in 'trace' output as:

 $ trace report
 #
 # trace events of 'sleep 1':
 #
        testit/ 6006 ( 0.002 ms): <"Hello World!">
        testit/ 6006 ( 0.002 ms): <"Hello World!">

Suggested-by: Darren Hart <dvhart@linux.intel.com>
Suggested-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/prctl.h       |    2 ++
 include/trace/events/user.h |   32 ++++++++++++++++++++++++++++++++
 kernel/sys.c                |   23 +++++++++++++++++++++++
 kernel/trace/trace_events.c |   34 +++++++++++-----------------------
 tools/perf/builtin-trace.c  |   41 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 109 insertions(+), 23 deletions(-)

Index: linux/include/linux/prctl.h
===================================================================
--- linux.orig/include/linux/prctl.h
+++ linux/include/linux/prctl.h
@@ -102,4 +102,6 @@
 
 #define PR_MCE_KILL_GET 34
 
+#define PR_TASK_PERF_USER_TRACE			35
+
 #endif /* _LINUX_PRCTL_H */
Index: linux/include/trace/events/user.h
===================================================================
--- /dev/null
+++ linux/include/trace/events/user.h
@@ -0,0 +1,32 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM user
+
+#if !defined(_TRACE_USER_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_USER_H_
+
+#include <linux/tracepoint.h>
+#include <linux/ftrace.h>
+
+TRACE_EVENT(user,
+
+	TP_PROTO(const char *message),
+
+	TP_ARGS(message),
+
+	TP_STRUCT__entry(
+		__string(	message, message);
+	),
+
+	TP_fast_assign(
+		__assign_str(message, message);
+	),
+
+	TP_printk("user %s", __get_str(message))
+);
+
+#undef NO_DEV
+
+#endif /* _TRACE_USER_H_ */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
Index: linux/kernel/sys.c
===================================================================
--- linux.orig/kernel/sys.c
+++ linux/kernel/sys.c
@@ -47,6 +47,11 @@
 #include <asm/io.h>
 #include <asm/unistd.h>
 
+#define MAX_USER_TRACE_SIZE 128
+
+#define CREATE_TRACE_POINTS
+#include <trace/events/user.h>
+
 #ifndef SET_UNALIGN_CTL
 # define SET_UNALIGN_CTL(a,b)	(-EINVAL)
 #endif
@@ -1681,6 +1686,24 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 		case PR_TASK_PERF_EVENTS_ENABLE:
 			error = perf_event_task_enable();
 			break;
+		/*
+		 * Inject a trace event into the current tracing context:
+		 */
+		case PR_TASK_PERF_USER_TRACE:
+		{
+			void __user *uevent_ptr = (void *)arg2;
+			char kstring[MAX_USER_TRACE_SIZE+1];
+			unsigned long uevent_len = arg3;
+
+			if (uevent_len > MAX_USER_TRACE_SIZE)
+				return -EINVAL;
+			if (copy_from_user(kstring, uevent_ptr, uevent_len))
+				return -EFAULT;
+			kstring[uevent_len] = 0;
+
+			trace_user(kstring);
+			return 0;
+		}
 		case PR_GET_TIMERSLACK:
 			error = current->timer_slack_ns;
 			break;
Index: linux/kernel/trace/trace_events.c
===================================================================
--- linux.orig/kernel/trace/trace_events.c
+++ linux/kernel/trace/trace_events.c
@@ -989,8 +989,7 @@ static struct dentry *event_trace_events
 
 	d_events = debugfs_create_dir("events", d_tracer);
 	if (!d_events)
-		pr_warning("Could not create debugfs "
-			   "'events' directory\n");
+		pr_warning("Could not create debugfs 'events' directory\n");
 
 	return d_events;
 }
@@ -1014,15 +1013,13 @@ event_subsystem_dir(const char *name, st
 	/* need to create new entry */
 	system = kmalloc(sizeof(*system), GFP_KERNEL);
 	if (!system) {
-		pr_warning("No memory to create event subsystem %s\n",
-			   name);
+		pr_warning("No memory to create event subsystem %s\n", name);
 		return d_events;
 	}
 
 	system->entry = debugfs_create_dir(name, d_events);
 	if (!system->entry) {
-		pr_warning("Could not create event subsystem %s\n",
-			   name);
+		pr_warning("Could not create event subsystem %s\n", name);
 		kfree(system);
 		return d_events;
 	}
@@ -1041,8 +1038,7 @@ event_subsystem_dir(const char *name, st
 
 	system->filter = kzalloc(sizeof(struct event_filter), GFP_KERNEL);
 	if (!system->filter) {
-		pr_warning("Could not allocate filter for subsystem "
-			   "'%s'\n", name);
+		pr_warning("Could not allocate filter for subsystem '%s'\n", name);
 		return system->entry;
 	}
 
@@ -1051,8 +1047,7 @@ event_subsystem_dir(const char *name, st
 	if (!entry) {
 		kfree(system->filter);
 		system->filter = NULL;
-		pr_warning("Could not create debugfs "
-			   "'%s/filter' entry\n", name);
+		pr_warning("Could not create debugfs '%s/filter' entry\n", name);
 	}
 
 	trace_create_file("enable", 0644, system->entry,
@@ -1081,19 +1076,16 @@ event_create_dir(struct ftrace_event_cal
 
 	call->dir = debugfs_create_dir(call->name, d_events);
 	if (!call->dir) {
-		pr_warning("Could not create debugfs "
-			   "'%s' directory\n", call->name);
+		pr_warning("Could not create debugfs '%s' directory\n", call->name);
 		return -1;
 	}
 
 	if (call->class->reg)
-		trace_create_file("enable", 0644, call->dir, call,
-				  enable);
+		trace_create_file("enable", 0644, call->dir, call, enable);
 
 #ifdef CONFIG_PERF_EVENTS
 	if (call->event.type && call->class->reg)
-		trace_create_file("id", 0444, call->dir, call,
-		 		  id);
+		trace_create_file("id", 0444, call->dir, call, id);
 #endif
 
 	/*
@@ -1104,16 +1096,12 @@ event_create_dir(struct ftrace_event_cal
 	if (list_empty(head)) {
 		ret = call->class->define_fields(call);
 		if (ret < 0) {
-			pr_warning("Could not initialize trace point"
-				   " events/%s\n", call->name);
+			pr_warning("Could not initialize trace point events/%s\n", call->name);
 			return ret;
 		}
 	}
-	trace_create_file("filter", 0644, call->dir, call,
-			  filter);
-
-	trace_create_file("format", 0444, call->dir, call,
-			  format);
+	trace_create_file("filter", 0644, call->dir, call, filter);
+	trace_create_file("format", 0444, call->dir, call, format);
 
 	return 0;
 }
Index: linux/tools/perf/builtin-trace.c
===================================================================
--- linux.orig/tools/perf/builtin-trace.c
+++ linux/tools/perf/builtin-trace.c
@@ -719,6 +719,44 @@ static void vfs_getname(void *data,
 	}
 }
 
+static void user_event(void *data,
+			struct event *event __used,
+			int cpu __used,
+			u64 timestamp __used,
+			struct thread *thread __used)
+{
+	struct thread_data *tdata = get_thread_data(thread);
+	unsigned int i;
+	char *message;
+	u64 t = 0;
+
+	if (!tdata->enabled)
+		return;
+	if (time_filtered(timestamp))
+		return;
+	if (cpu_filtered(cpu))
+		return;
+	if (tdata->entry_time) {
+		t = timestamp - tdata->entry_time;
+		if (filter_duration(t))
+			return;
+	} else if (duration_filter)
+		return;
+
+	print_entry_head(thread, timestamp, t, cpu);
+	message = strdup(raw_field_ptr(event, "message", data));
+
+	/* Sanitize the string a bit before printing it: */
+	for (i = 0; i < strlen(message); i++) {
+		if (message[i] == '\n')
+			message[i] = ' ';
+	}
+
+	color_fprintf(stdout, PERF_COLOR_GREEN, "<\"%s\">\n", message);
+
+	free(message);
+}
+
 static int pagefault_preprocess_sample(const event_t *self,
 				       struct addr_location *al,
 				       struct sample_data *data,
@@ -1036,6 +1074,8 @@ process_raw_event(event_t *self, void *d
 		pagefault_exit(data, event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "vfs_getname"))
 		vfs_getname(data, event, cpu, timestamp, thread);
+	if (!strcmp(event->name, "user"))
+		user_event(data, event, cpu, timestamp, thread);
 
 	if (!scheduler_events && !scheduler_all_events)
 		return;
@@ -1226,6 +1266,7 @@ static const char *record_args[] = {
 	"-e", "sched:sched_stat_sleep:r",
 	"-e", "sched:sched_stat_iowait:r",
 	"-e", "sched:sched_stat_runtime:r",
+	"-e", "user:user:r",
 };
 
 static int __cmd_record(int argc, const char **argv)

