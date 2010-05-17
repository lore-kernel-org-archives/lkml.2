Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab0EQWcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:32:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50786 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035Ab0EQWcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:32:13 -0400
Date: Tue, 18 May 2010 00:31:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] tracing/core changes for v2.6.35
Message-ID: <20100517223128.GA22449@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0014]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-core-for-linus

 Thanks,

	Ingo

------------------>
Borislav Petkov (1):
      ring-buffer: Wrap open-coded WARN_ONCE

Chase Douglas (2):
      tracing: Add documentation for trace commands mod, traceon/traceoff
      tracing: Show sample std dev in function profiling

David Miller (1):
      ring-buffer: Make non-consuming read less expensive with lots of cpus.

Frederic Weisbecker (1):
      tracing: Dump either the oops's cpu source or all cpus buffers

Jiri Olsa (3):
      tracing: Add ftrace events for graph tracer
      tracing: Have graph flags passed in to ouput functions
      tracing: Add graph output support for irqsoff tracer

Lai Jiangshan (1):
      tracing: Fix uninitialized variable of tracing/trace output

Li Zefan (4):
      tracing: Convert some signal events to DEFINE_TRACE
      tracing: Update comments
      tracing: Remove side effect from module tracepoints that caused a GPF
      tracing: Make the documentation clear on trace_event boot option

Steven Rostedt (8):
      tracing: Fix compile error in module tracepoints when MODULE_UNLOAD not set
      ring-buffer: Add place holder recording of dropped events
      tracing: Show the lost events in the trace_pipe output
      ring-buffer: Add lost event count to end of sub buffer
      ring-buffer: Make benchmark handle missed events
      tracing: Fix sleep time function profiling
      tracing: Convert nop macros to static inlines
      tracing: Fix tracepoint.h DECLARE_TRACE() to allow more than one header

Thiago Farina (1):
      tracing: Fix "integer as NULL pointer" warning.


 Documentation/kernel-parameters.txt  |    6 +-
 Documentation/trace/events.txt       |    3 +-
 Documentation/trace/ftrace.txt       |   50 ++++++-
 drivers/char/sysrq.c                 |    2 +-
 drivers/oprofile/cpu_buffer.c        |    4 +-
 include/linux/ftrace.h               |   49 ++++--
 include/linux/ftrace_event.h         |    1 +
 include/linux/kernel.h               |   11 +-
 include/linux/module.h               |    6 +-
 include/linux/ring_buffer.h          |   10 +-
 include/linux/tracepoint.h           |  114 ++++++++-------
 include/trace/define_trace.h         |    5 +
 include/trace/events/module.h        |   18 ++-
 include/trace/events/napi.h          |   10 +-
 include/trace/events/signal.h        |   52 +++----
 include/trace/ftrace.h               |   33 +++--
 kernel/module.c                      |    8 +-
 kernel/trace/ftrace.c                |   30 ++++-
 kernel/trace/ring_buffer.c           |  179 +++++++++++++++++++---
 kernel/trace/ring_buffer_benchmark.c |    5 +-
 kernel/trace/trace.c                 |  127 ++++++++++++-----
 kernel/trace/trace.h                 |   27 +++-
 kernel/trace/trace_functions_graph.c |  169 ++++++++++++++--------
 kernel/trace/trace_irqsoff.c         |  271 ++++++++++++++++++++++++++++++++--
 kernel/trace/trace_output.c          |    2 +-
 kernel/trace/trace_selftest.c        |    7 +-
 26 files changed, 909 insertions(+), 290 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 839b21b..907010c 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -784,8 +784,12 @@ and is between 256 and 4096 characters. It is defined in the file
 			as early as possible in order to facilitate early
 			boot debugging.
 
-	ftrace_dump_on_oops
+	ftrace_dump_on_oops[=orig_cpu]
 			[FTRACE] will dump the trace buffers on oops.
+			If no parameter is passed, ftrace will dump
+			buffers of all CPUs, but if you pass orig_cpu, it will
+			dump only the buffer of the CPU that triggered the
+			oops.
 
 	ftrace_filter=[function-list]
 			[FTRACE] Limit the functions traced by the function
diff --git a/Documentation/trace/events.txt b/Documentation/trace/events.txt
index 02ac6ed..778ddf3 100644
--- a/Documentation/trace/events.txt
+++ b/Documentation/trace/events.txt
@@ -90,7 +90,8 @@ In order to facilitate early boot debugging, use boot option:
 
 	trace_event=[event-list]
 
-The format of this boot option is the same as described in section 2.1.
+event-list is a comma separated list of events. See section 2.1 for event
+format.
 
 3. Defining an event-enabled tracepoint
 =======================================
diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 03485bf..557c1ed 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -155,6 +155,9 @@ of ftrace. Here is a list of some of the key files:
 	to be traced. Echoing names of functions into this file
 	will limit the trace to only those functions.
 
+	This interface also allows for commands to be used. See the
+	"Filter commands" section for more details.
+
   set_ftrace_notrace:
 
 	This has an effect opposite to that of
@@ -1337,12 +1340,14 @@ ftrace_dump_on_oops must be set. To set ftrace_dump_on_oops, one
 can either use the sysctl function or set it via the proc system
 interface.
 
-  sysctl kernel.ftrace_dump_on_oops=1
+  sysctl kernel.ftrace_dump_on_oops=n
 
 or
 
-  echo 1 > /proc/sys/kernel/ftrace_dump_on_oops
+  echo n > /proc/sys/kernel/ftrace_dump_on_oops
 
+If n = 1, ftrace will dump buffers of all CPUs, if n = 2 ftrace will
+only dump the buffer of the CPU that triggered the oops.
 
 Here's an example of such a dump after a null pointer
 dereference in a kernel module:
@@ -1822,6 +1827,47 @@ this special filter via:
  echo > set_graph_function
 
 
+Filter commands
+---------------
+
+A few commands are supported by the set_ftrace_filter interface.
+Trace commands have the following format:
+
+<function>:<command>:<parameter>
+
+The following commands are supported:
+
+- mod
+  This command enables function filtering per module. The
+  parameter defines the module. For example, if only the write*
+  functions in the ext3 module are desired, run:
+
+   echo 'write*:mod:ext3' > set_ftrace_filter
+
+  This command interacts with the filter in the same way as
+  filtering based on function names. Thus, adding more functions
+  in a different module is accomplished by appending (>>) to the
+  filter file. Remove specific module functions by prepending
+  '!':
+
+   echo '!writeback*:mod:ext3' >> set_ftrace_filter
+
+- traceon/traceoff
+  These commands turn tracing on and off when the specified
+  functions are hit. The parameter determines how many times the
+  tracing system is turned on and off. If unspecified, there is
+  no limit. For example, to disable tracing when a schedule bug
+  is hit the first 5 times, run:
+
+   echo '__schedule_bug:traceoff:5' > set_ftrace_filter
+
+  These commands are cumulative whether or not they are appended
+  to set_ftrace_filter. To remove a command, prepend it by '!'
+  and drop the parameter:
+
+   echo '!__schedule_bug:traceoff' > set_ftrace_filter
+
+
 trace_pipe
 ----------
 
diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index 59de252..d4e8b21 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -289,7 +289,7 @@ static struct sysrq_key_op sysrq_showstate_blocked_op = {
 
 static void sysrq_ftrace_dump(int key, struct tty_struct *tty)
 {
-	ftrace_dump();
+	ftrace_dump(DUMP_ALL);
 }
 static struct sysrq_key_op sysrq_ftrace_dump_op = {
 	.handler	= sysrq_ftrace_dump,
diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index 166b67e..7581dbe 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -186,14 +186,14 @@ int op_cpu_buffer_write_commit(struct op_entry *entry)
 struct op_sample *op_cpu_buffer_read_entry(struct op_entry *entry, int cpu)
 {
 	struct ring_buffer_event *e;
-	e = ring_buffer_consume(op_ring_buffer_read, cpu, NULL);
+	e = ring_buffer_consume(op_ring_buffer_read, cpu, NULL, NULL);
 	if (e)
 		goto event;
 	if (ring_buffer_swap_cpu(op_ring_buffer_read,
 				 op_ring_buffer_write,
 				 cpu))
 		return NULL;
-	e = ring_buffer_consume(op_ring_buffer_read, cpu, NULL);
+	e = ring_buffer_consume(op_ring_buffer_read, cpu, NULL, NULL);
 	if (e)
 		goto event;
 	return NULL;
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 01e6ade..e0ae83b 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -82,9 +82,13 @@ void clear_ftrace_function(void);
 extern void ftrace_stub(unsigned long a0, unsigned long a1);
 
 #else /* !CONFIG_FUNCTION_TRACER */
-# define register_ftrace_function(ops) do { } while (0)
-# define unregister_ftrace_function(ops) do { } while (0)
-# define clear_ftrace_function(ops) do { } while (0)
+/*
+ * (un)register_ftrace_function must be a macro since the ops parameter
+ * must not be evaluated.
+ */
+#define register_ftrace_function(ops) ({ 0; })
+#define unregister_ftrace_function(ops) ({ 0; })
+static inline void clear_ftrace_function(void) { }
 static inline void ftrace_kill(void) { }
 static inline void ftrace_stop(void) { }
 static inline void ftrace_start(void) { }
@@ -237,11 +241,13 @@ extern int skip_trace(unsigned long ip);
 extern void ftrace_disable_daemon(void);
 extern void ftrace_enable_daemon(void);
 #else
-# define skip_trace(ip)				({ 0; })
-# define ftrace_force_update()			({ 0; })
-# define ftrace_set_filter(buf, len, reset)	do { } while (0)
-# define ftrace_disable_daemon()		do { } while (0)
-# define ftrace_enable_daemon()			do { } while (0)
+static inline int skip_trace(unsigned long ip) { return 0; }
+static inline int ftrace_force_update(void) { return 0; }
+static inline void ftrace_set_filter(unsigned char *buf, int len, int reset)
+{
+}
+static inline void ftrace_disable_daemon(void) { }
+static inline void ftrace_enable_daemon(void) { }
 static inline void ftrace_release_mod(struct module *mod) {}
 static inline int register_ftrace_command(struct ftrace_func_command *cmd)
 {
@@ -314,16 +320,16 @@ static inline void __ftrace_enabled_restore(int enabled)
   extern void time_hardirqs_on(unsigned long a0, unsigned long a1);
   extern void time_hardirqs_off(unsigned long a0, unsigned long a1);
 #else
-# define time_hardirqs_on(a0, a1)		do { } while (0)
-# define time_hardirqs_off(a0, a1)		do { } while (0)
+  static inline void time_hardirqs_on(unsigned long a0, unsigned long a1) { }
+  static inline void time_hardirqs_off(unsigned long a0, unsigned long a1) { }
 #endif
 
 #ifdef CONFIG_PREEMPT_TRACER
   extern void trace_preempt_on(unsigned long a0, unsigned long a1);
   extern void trace_preempt_off(unsigned long a0, unsigned long a1);
 #else
-# define trace_preempt_on(a0, a1)		do { } while (0)
-# define trace_preempt_off(a0, a1)		do { } while (0)
+  static inline void trace_preempt_on(unsigned long a0, unsigned long a1) { }
+  static inline void trace_preempt_off(unsigned long a0, unsigned long a1) { }
 #endif
 
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
@@ -352,6 +358,10 @@ struct ftrace_graph_ret {
 	int depth;
 };
 
+/* Type of the callback handlers for tracing function graph*/
+typedef void (*trace_func_graph_ret_t)(struct ftrace_graph_ret *); /* return */
+typedef int (*trace_func_graph_ent_t)(struct ftrace_graph_ent *); /* entry */
+
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
 /* for init task */
@@ -400,10 +410,6 @@ extern char __irqentry_text_end[];
 
 #define FTRACE_RETFUNC_DEPTH 50
 #define FTRACE_RETSTACK_ALLOC_SIZE 32
-/* Type of the callback handlers for tracing function graph*/
-typedef void (*trace_func_graph_ret_t)(struct ftrace_graph_ret *); /* return */
-typedef int (*trace_func_graph_ent_t)(struct ftrace_graph_ent *); /* entry */
-
 extern int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 				trace_func_graph_ent_t entryfunc);
 
@@ -441,6 +447,13 @@ static inline void unpause_graph_tracing(void)
 static inline void ftrace_graph_init_task(struct task_struct *t) { }
 static inline void ftrace_graph_exit_task(struct task_struct *t) { }
 
+static inline int register_ftrace_graph(trace_func_graph_ret_t retfunc,
+			  trace_func_graph_ent_t entryfunc)
+{
+	return -1;
+}
+static inline void unregister_ftrace_graph(void) { }
+
 static inline int task_curr_ret_stack(struct task_struct *tsk)
 {
 	return -1;
@@ -492,7 +505,9 @@ static inline int test_tsk_trace_graph(struct task_struct *tsk)
 	return tsk->trace & TSK_TRACE_FL_GRAPH;
 }
 
-extern int ftrace_dump_on_oops;
+enum ftrace_dump_mode;
+
+extern enum ftrace_dump_mode ftrace_dump_on_oops;
 
 #ifdef CONFIG_PREEMPT
 #define INIT_TRACE_RECURSION		.trace_recursion = 0,
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index c0f4b36..39e71b0 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -58,6 +58,7 @@ struct trace_iterator {
 	/* The below is zeroed out in pipe_read */
 	struct trace_seq	seq;
 	struct trace_entry	*ent;
+	unsigned long		lost_events;
 	int			leftover;
 	int			cpu;
 	u64			ts;
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 9365227..9fb1c12 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -490,6 +490,13 @@ static inline void tracing_off(void) { }
 static inline void tracing_off_permanent(void) { }
 static inline int tracing_is_on(void) { return 0; }
 #endif
+
+enum ftrace_dump_mode {
+	DUMP_NONE,
+	DUMP_ALL,
+	DUMP_ORIG,
+};
+
 #ifdef CONFIG_TRACING
 extern void tracing_start(void);
 extern void tracing_stop(void);
@@ -571,7 +578,7 @@ __ftrace_vbprintk(unsigned long ip, const char *fmt, va_list ap);
 extern int
 __ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap);
 
-extern void ftrace_dump(void);
+extern void ftrace_dump(enum ftrace_dump_mode oops_dump_mode);
 #else
 static inline void
 ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3) { }
@@ -592,7 +599,7 @@ ftrace_vprintk(const char *fmt, va_list ap)
 {
 	return 0;
 }
-static inline void ftrace_dump(void) { }
+static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
 #endif /* CONFIG_TRACING */
 
 /*
diff --git a/include/linux/module.h b/include/linux/module.h
index 515d53a..6914fca 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -465,8 +465,7 @@ static inline void __module_get(struct module *module)
 	if (module) {
 		preempt_disable();
 		__this_cpu_inc(module->refptr->incs);
-		trace_module_get(module, _THIS_IP_,
-				 __this_cpu_read(module->refptr->incs));
+		trace_module_get(module, _THIS_IP_);
 		preempt_enable();
 	}
 }
@@ -480,8 +479,7 @@ static inline int try_module_get(struct module *module)
 
 		if (likely(module_is_live(module))) {
 			__this_cpu_inc(module->refptr->incs);
-			trace_module_get(module, _THIS_IP_,
-				__this_cpu_read(module->refptr->incs));
+			trace_module_get(module, _THIS_IP_);
 		} else
 			ret = 0;
 
diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 5fcc31e..25b4f68 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -120,12 +120,16 @@ int ring_buffer_write(struct ring_buffer *buffer,
 		      unsigned long length, void *data);
 
 struct ring_buffer_event *
-ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts);
+ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts,
+		 unsigned long *lost_events);
 struct ring_buffer_event *
-ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts);
+ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts,
+		    unsigned long *lost_events);
 
 struct ring_buffer_iter *
-ring_buffer_read_start(struct ring_buffer *buffer, int cpu);
+ring_buffer_read_prepare(struct ring_buffer *buffer, int cpu);
+void ring_buffer_read_prepare_sync(void);
+void ring_buffer_read_start(struct ring_buffer_iter *iter);
 void ring_buffer_read_finish(struct ring_buffer_iter *iter);
 
 struct ring_buffer_event *
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 78b4bd3..1d85f9a 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -33,6 +33,65 @@ struct tracepoint {
 					 * Keep in sync with vmlinux.lds.h.
 					 */
 
+/*
+ * Connect a probe to a tracepoint.
+ * Internal API, should not be used directly.
+ */
+extern int tracepoint_probe_register(const char *name, void *probe);
+
+/*
+ * Disconnect a probe from a tracepoint.
+ * Internal API, should not be used directly.
+ */
+extern int tracepoint_probe_unregister(const char *name, void *probe);
+
+extern int tracepoint_probe_register_noupdate(const char *name, void *probe);
+extern int tracepoint_probe_unregister_noupdate(const char *name, void *probe);
+extern void tracepoint_probe_update_all(void);
+
+struct tracepoint_iter {
+	struct module *module;
+	struct tracepoint *tracepoint;
+};
+
+extern void tracepoint_iter_start(struct tracepoint_iter *iter);
+extern void tracepoint_iter_next(struct tracepoint_iter *iter);
+extern void tracepoint_iter_stop(struct tracepoint_iter *iter);
+extern void tracepoint_iter_reset(struct tracepoint_iter *iter);
+extern int tracepoint_get_iter_range(struct tracepoint **tracepoint,
+	struct tracepoint *begin, struct tracepoint *end);
+
+/*
+ * tracepoint_synchronize_unregister must be called between the last tracepoint
+ * probe unregistration and the end of module exit to make sure there is no
+ * caller executing a probe when it is freed.
+ */
+static inline void tracepoint_synchronize_unregister(void)
+{
+	synchronize_sched();
+}
+
+#define PARAMS(args...) args
+
+#ifdef CONFIG_TRACEPOINTS
+extern void tracepoint_update_probe_range(struct tracepoint *begin,
+	struct tracepoint *end);
+#else
+static inline void tracepoint_update_probe_range(struct tracepoint *begin,
+	struct tracepoint *end)
+{ }
+#endif /* CONFIG_TRACEPOINTS */
+
+#endif /* _LINUX_TRACEPOINT_H */
+
+/*
+ * Note: we keep the TRACE_EVENT and DECLARE_TRACE outside the include
+ *  file ifdef protection.
+ *  This is due to the way trace events work. If a file includes two
+ *  trace event headers under one "CREATE_TRACE_POINTS" the first include
+ *  will override the TRACE_EVENT and break the second include.
+ */
+
 #ifndef DECLARE_TRACE
 
 #define TP_PROTO(args...)	args
@@ -96,9 +155,6 @@ struct tracepoint {
 #define EXPORT_TRACEPOINT_SYMBOL(name)					\
 	EXPORT_SYMBOL(__tracepoint_##name)
 
-extern void tracepoint_update_probe_range(struct tracepoint *begin,
-	struct tracepoint *end);
-
 #else /* !CONFIG_TRACEPOINTS */
 #define DECLARE_TRACE(name, proto, args)				\
 	static inline void _do_trace_##name(struct tracepoint *tp, proto) \
@@ -119,61 +175,9 @@ extern void tracepoint_update_probe_range(struct tracepoint *begin,
 #define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
 #define EXPORT_TRACEPOINT_SYMBOL(name)
 
-static inline void tracepoint_update_probe_range(struct tracepoint *begin,
-	struct tracepoint *end)
-{ }
 #endif /* CONFIG_TRACEPOINTS */
 #endif /* DECLARE_TRACE */
 
-/*
- * Connect a probe to a tracepoint.
- * Internal API, should not be used directly.
- */
-extern int tracepoint_probe_register(const char *name, void *probe);
-
-/*
- * Disconnect a probe from a tracepoint.
- * Internal API, should not be used directly.
- */
-extern int tracepoint_probe_unregister(const char *name, void *probe);
-
-extern int tracepoint_probe_register_noupdate(const char *name, void *probe);
-extern int tracepoint_probe_unregister_noupdate(const char *name, void *probe);
-extern void tracepoint_probe_update_all(void);
-
-struct tracepoint_iter {
-	struct module *module;
-	struct tracepoint *tracepoint;
-};
-
-extern void tracepoint_iter_start(struct tracepoint_iter *iter);
-extern void tracepoint_iter_next(struct tracepoint_iter *iter);
-extern void tracepoint_iter_stop(struct tracepoint_iter *iter);
-extern void tracepoint_iter_reset(struct tracepoint_iter *iter);
-extern int tracepoint_get_iter_range(struct tracepoint **tracepoint,
-	struct tracepoint *begin, struct tracepoint *end);
-
-/*
- * tracepoint_synchronize_unregister must be called between the last tracepoint
- * probe unregistration and the end of module exit to make sure there is no
- * caller executing a probe when it is freed.
- */
-static inline void tracepoint_synchronize_unregister(void)
-{
-	synchronize_sched();
-}
-
-#define PARAMS(args...) args
-
-#endif /* _LINUX_TRACEPOINT_H */
-
-/*
- * Note: we keep the TRACE_EVENT outside the include file ifdef protection.
- *  This is due to the way trace events work. If a file includes two
- *  trace event headers under one "CREATE_TRACE_POINTS" the first include
- *  will override the TRACE_EVENT and break the second include.
- */
-
 #ifndef TRACE_EVENT
 /*
  * For use with the TRACE_EVENT macro:
diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index 5acfb1e..1dfab54 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -65,6 +65,10 @@
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
+/* Make all open coded DECLARE_TRACE nops */
+#undef DECLARE_TRACE
+#define DECLARE_TRACE(name, proto, args)
+
 #ifdef CONFIG_EVENT_TRACING
 #include <trace/ftrace.h>
 #endif
@@ -75,6 +79,7 @@
 #undef DEFINE_EVENT
 #undef DEFINE_EVENT_PRINT
 #undef TRACE_HEADER_MULTI_READ
+#undef DECLARE_TRACE
 
 /* Only undef what we defined in this file */
 #ifdef UNDEF_TRACE_INCLUDE_FILE
diff --git a/include/trace/events/module.h b/include/trace/events/module.h
index 4b0f48b..c7bb2f0 100644
--- a/include/trace/events/module.h
+++ b/include/trace/events/module.h
@@ -51,11 +51,14 @@ TRACE_EVENT(module_free,
 	TP_printk("%s", __get_str(name))
 );
 
+#ifdef CONFIG_MODULE_UNLOAD
+/* trace_module_get/put are only used if CONFIG_MODULE_UNLOAD is defined */
+
 DECLARE_EVENT_CLASS(module_refcnt,
 
-	TP_PROTO(struct module *mod, unsigned long ip, int refcnt),
+	TP_PROTO(struct module *mod, unsigned long ip),
 
-	TP_ARGS(mod, ip, refcnt),
+	TP_ARGS(mod, ip),
 
 	TP_STRUCT__entry(
 		__field(	unsigned long,	ip		)
@@ -65,7 +68,7 @@ DECLARE_EVENT_CLASS(module_refcnt,
 
 	TP_fast_assign(
 		__entry->ip	= ip;
-		__entry->refcnt	= refcnt;
+		__entry->refcnt	= __this_cpu_read(mod->refptr->incs) + __this_cpu_read(mod->refptr->decs);
 		__assign_str(name, mod->name);
 	),
 
@@ -75,17 +78,18 @@ DECLARE_EVENT_CLASS(module_refcnt,
 
 DEFINE_EVENT(module_refcnt, module_get,
 
-	TP_PROTO(struct module *mod, unsigned long ip, int refcnt),
+	TP_PROTO(struct module *mod, unsigned long ip),
 
-	TP_ARGS(mod, ip, refcnt)
+	TP_ARGS(mod, ip)
 );
 
 DEFINE_EVENT(module_refcnt, module_put,
 
-	TP_PROTO(struct module *mod, unsigned long ip, int refcnt),
+	TP_PROTO(struct module *mod, unsigned long ip),
 
-	TP_ARGS(mod, ip, refcnt)
+	TP_ARGS(mod, ip)
 );
+#endif /* CONFIG_MODULE_UNLOAD */
 
 TRACE_EVENT(module_request,
 
diff --git a/include/trace/events/napi.h b/include/trace/events/napi.h
index a8989c4..188deca 100644
--- a/include/trace/events/napi.h
+++ b/include/trace/events/napi.h
@@ -1,4 +1,7 @@
-#ifndef _TRACE_NAPI_H_
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM napi
+
+#if !defined(_TRACE_NAPI_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_NAPI_H_
 
 #include <linux/netdevice.h>
@@ -8,4 +11,7 @@ DECLARE_TRACE(napi_poll,
 	TP_PROTO(struct napi_struct *napi),
 	TP_ARGS(napi));
 
-#endif
+#endif /* _TRACE_NAPI_H_ */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/include/trace/events/signal.h b/include/trace/events/signal.h
index a510b75..814566c 100644
--- a/include/trace/events/signal.h
+++ b/include/trace/events/signal.h
@@ -100,18 +100,7 @@ TRACE_EVENT(signal_deliver,
 		  __entry->sa_handler, __entry->sa_flags)
 );
 
-/**
- * signal_overflow_fail - called when signal queue is overflow
- * @sig: signal number
- * @group: signal to process group or not (bool)
- * @info: pointer to struct siginfo
- *
- * Kernel fails to generate 'sig' signal with 'info' siginfo, because
- * siginfo queue is overflow, and the signal is dropped.
- * 'group' is not 0 if the signal will be sent to a process group.
- * 'sig' is always one of RT signals.
- */
-TRACE_EVENT(signal_overflow_fail,
+DECLARE_EVENT_CLASS(signal_queue_overflow,
 
 	TP_PROTO(int sig, int group, struct siginfo *info),
 
@@ -135,6 +124,24 @@ TRACE_EVENT(signal_overflow_fail,
 );
 
 /**
+ * signal_overflow_fail - called when signal queue is overflow
+ * @sig: signal number
+ * @group: signal to process group or not (bool)
+ * @info: pointer to struct siginfo
+ *
+ * Kernel fails to generate 'sig' signal with 'info' siginfo, because
+ * siginfo queue is overflow, and the signal is dropped.
+ * 'group' is not 0 if the signal will be sent to a process group.
+ * 'sig' is always one of RT signals.
+ */
+DEFINE_EVENT(signal_queue_overflow, signal_overflow_fail,
+
+	TP_PROTO(int sig, int group, struct siginfo *info),
+
+	TP_ARGS(sig, group, info)
+);
+
+/**
  * signal_lose_info - called when siginfo is lost
  * @sig: signal number
  * @group: signal to process group or not (bool)
@@ -145,28 +152,13 @@ TRACE_EVENT(signal_overflow_fail,
  * 'group' is not 0 if the signal will be sent to a process group.
  * 'sig' is always one of non-RT signals.
  */
-TRACE_EVENT(signal_lose_info,
+DEFINE_EVENT(signal_queue_overflow, signal_lose_info,
 
 	TP_PROTO(int sig, int group, struct siginfo *info),
 
-	TP_ARGS(sig, group, info),
-
-	TP_STRUCT__entry(
-		__field(	int,	sig	)
-		__field(	int,	group	)
-		__field(	int,	errno	)
-		__field(	int,	code	)
-	),
-
-	TP_fast_assign(
-		__entry->sig	= sig;
-		__entry->group	= group;
-		TP_STORE_SIGINFO(__entry, info);
-	),
-
-	TP_printk("sig=%d group=%d errno=%d code=%d",
-		  __entry->sig, __entry->group, __entry->errno, __entry->code)
+	TP_ARGS(sig, group, info)
 );
+
 #endif /* _TRACE_SIGNAL_H */
 
 /* This part must be outside protection */
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index ea6f9d4..75dd778 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -154,9 +154,11 @@
  *
  *	field = (typeof(field))entry;
  *
- *	p = get_cpu_var(ftrace_event_seq);
+ *	p = &get_cpu_var(ftrace_event_seq);
  *	trace_seq_init(p);
- *	ret = trace_seq_printf(s, <TP_printk> "\n");
+ *	ret = trace_seq_printf(s, "%s: ", <call>);
+ *	if (ret)
+ *		ret = trace_seq_printf(s, <TP_printk> "\n");
  *	put_cpu();
  *	if (!ret)
  *		return TRACE_TYPE_PARTIAL_LINE;
@@ -450,38 +452,38 @@ perf_trace_disable_##name(struct ftrace_event_call *unused)		\
  *
  * static void ftrace_raw_event_<call>(proto)
  * {
+ *	struct ftrace_data_offsets_<call> __maybe_unused __data_offsets;
  *	struct ring_buffer_event *event;
  *	struct ftrace_raw_<call> *entry; <-- defined in stage 1
  *	struct ring_buffer *buffer;
  *	unsigned long irq_flags;
+ *	int __data_size;
  *	int pc;
  *
  *	local_save_flags(irq_flags);
  *	pc = preempt_count();
  *
+ *	__data_size = ftrace_get_offsets_<call>(&__data_offsets, args);
+ *
  *	event = trace_current_buffer_lock_reserve(&buffer,
  *				  event_<call>.id,
- *				  sizeof(struct ftrace_raw_<call>),
+ *				  sizeof(*entry) + __data_size,
  *				  irq_flags, pc);
  *	if (!event)
  *		return;
  *	entry	= ring_buffer_event_data(event);
  *
- *	<assign>;  <-- Here we assign the entries by the __field and
- *			__array macros.
+ *	{ <assign>; }  <-- Here we assign the entries by the __field and
+ *			   __array macros.
  *
- *	trace_current_buffer_unlock_commit(buffer, event, irq_flags, pc);
+ *	if (!filter_current_check_discard(buffer, event_call, entry, event))
+ *		trace_current_buffer_unlock_commit(buffer,
+ *						   event, irq_flags, pc);
  * }
  *
  * static int ftrace_raw_reg_event_<call>(struct ftrace_event_call *unused)
  * {
- *	int ret;
- *
- *	ret = register_trace_<call>(ftrace_raw_event_<call>);
- *	if (!ret)
- *		pr_info("event trace: Could not activate trace point "
- *			"probe to <call>");
- *	return ret;
+ *	return register_trace_<call>(ftrace_raw_event_<call>);
  * }
  *
  * static void ftrace_unreg_event_<call>(struct ftrace_event_call *unused)
@@ -493,6 +495,8 @@ perf_trace_disable_##name(struct ftrace_event_call *unused)		\
  *	.trace			= ftrace_raw_output_<call>, <-- stage 2
  * };
  *
+ * static const char print_fmt_<call>[] = <TP_printk>;
+ *
  * static struct ftrace_event_call __used
  * __attribute__((__aligned__(4)))
  * __attribute__((section("_ftrace_events"))) event_<call> = {
@@ -501,6 +505,8 @@ perf_trace_disable_##name(struct ftrace_event_call *unused)		\
  *	.raw_init		= trace_event_raw_init,
  *	.regfunc		= ftrace_reg_event_<call>,
  *	.unregfunc		= ftrace_unreg_event_<call>,
+ *	.print_fmt		= print_fmt_<call>,
+ *	.define_fields		= ftrace_define_fields_<call>,
  * }
  *
  */
@@ -569,7 +575,6 @@ ftrace_raw_event_id_##call(struct ftrace_event_call *event_call,	\
 		return;							\
 	entry	= ring_buffer_event_data(event);			\
 									\
-									\
 	tstruct								\
 									\
 	{ assign; }							\
diff --git a/kernel/module.c b/kernel/module.c
index 1016b75..b8a1e31 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -59,8 +59,6 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/module.h>
 
-EXPORT_TRACEPOINT_SYMBOL(module_get);
-
 #if 0
 #define DEBUGP printk
 #else
@@ -515,6 +513,9 @@ MODINFO_ATTR(srcversion);
 static char last_unloaded_module[MODULE_NAME_LEN+1];
 
 #ifdef CONFIG_MODULE_UNLOAD
+
+EXPORT_TRACEPOINT_SYMBOL(module_get);
+
 /* Init the unload section of the module. */
 static void module_unload_init(struct module *mod)
 {
@@ -867,8 +868,7 @@ void module_put(struct module *module)
 		smp_wmb(); /* see comment in module_refcount */
 		__this_cpu_inc(module->refptr->decs);
 
-		trace_module_put(module, _RET_IP_,
-				 __this_cpu_read(module->refptr->decs));
+		trace_module_put(module, _RET_IP_);
 		/* Maybe they're waiting for us to drop reference? */
 		if (unlikely(!module_is_live(module)))
 			wake_up_process(module->waiter);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 2404b59..8c9c293 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -264,6 +264,7 @@ struct ftrace_profile {
 	unsigned long			counter;
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	unsigned long long		time;
+	unsigned long long		time_squared;
 #endif
 };
 
@@ -366,9 +367,9 @@ static int function_stat_headers(struct seq_file *m)
 {
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	seq_printf(m, "  Function                               "
-		   "Hit    Time            Avg\n"
+		   "Hit    Time            Avg             s^2\n"
 		      "  --------                               "
-		   "---    ----            ---\n");
+		   "---    ----            ---             ---\n");
 #else
 	seq_printf(m, "  Function                               Hit\n"
 		      "  --------                               ---\n");
@@ -384,6 +385,7 @@ static int function_stat_show(struct seq_file *m, void *v)
 	static DEFINE_MUTEX(mutex);
 	static struct trace_seq s;
 	unsigned long long avg;
+	unsigned long long stddev;
 #endif
 
 	kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
@@ -394,11 +396,25 @@ static int function_stat_show(struct seq_file *m, void *v)
 	avg = rec->time;
 	do_div(avg, rec->counter);
 
+	/* Sample standard deviation (s^2) */
+	if (rec->counter <= 1)
+		stddev = 0;
+	else {
+		stddev = rec->time_squared - rec->counter * avg * avg;
+		/*
+		 * Divide only 1000 for ns^2 -> us^2 conversion.
+		 * trace_print_graph_duration will divide 1000 again.
+		 */
+		do_div(stddev, (rec->counter - 1) * 1000);
+	}
+
 	mutex_lock(&mutex);
 	trace_seq_init(&s);
 	trace_print_graph_duration(rec->time, &s);
 	trace_seq_puts(&s, "    ");
 	trace_print_graph_duration(avg, &s);
+	trace_seq_puts(&s, "    ");
+	trace_print_graph_duration(stddev, &s);
 	trace_print_seq(m, &s);
 	mutex_unlock(&mutex);
 #endif
@@ -650,6 +666,10 @@ static void profile_graph_return(struct ftrace_graph_ret *trace)
 	if (!stat->hash || !ftrace_profile_enabled)
 		goto out;
 
+	/* If the calltime was zero'd ignore it */
+	if (!trace->calltime)
+		goto out;
+
 	calltime = trace->rettime - trace->calltime;
 
 	if (!(trace_flags & TRACE_ITER_GRAPH_TIME)) {
@@ -668,8 +688,10 @@ static void profile_graph_return(struct ftrace_graph_ret *trace)
 	}
 
 	rec = ftrace_find_profiled_func(stat, trace->func);
-	if (rec)
+	if (rec) {
 		rec->time += calltime;
+		rec->time_squared += calltime * calltime;
+	}
 
  out:
 	local_irq_restore(flags);
@@ -3339,11 +3361,11 @@ void unregister_ftrace_graph(void)
 		goto out;
 
 	ftrace_graph_active--;
-	unregister_trace_sched_switch(ftrace_graph_probe_sched_switch);
 	ftrace_graph_return = (trace_func_graph_ret_t)ftrace_stub;
 	ftrace_graph_entry = ftrace_graph_entry_stub;
 	ftrace_shutdown(FTRACE_STOP_FUNC_RET);
 	unregister_pm_notifier(&ftrace_suspend_notifier);
+	unregister_trace_sched_switch(ftrace_graph_probe_sched_switch);
 
  out:
 	mutex_unlock(&ftrace_lock);
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 41ca394..7f6059c 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -319,6 +319,11 @@ EXPORT_SYMBOL_GPL(ring_buffer_event_data);
 #define TS_MASK		((1ULL << TS_SHIFT) - 1)
 #define TS_DELTA_TEST	(~TS_MASK)
 
+/* Flag when events were overwritten */
+#define RB_MISSED_EVENTS	(1 << 31)
+/* Missed count stored at end */
+#define RB_MISSED_STORED	(1 << 30)
+
 struct buffer_data_page {
 	u64		 time_stamp;	/* page time stamp */
 	local_t		 commit;	/* write committed index */
@@ -338,6 +343,7 @@ struct buffer_page {
 	local_t		 write;		/* index for next write */
 	unsigned	 read;		/* index for next read */
 	local_t		 entries;	/* entries on this page */
+	unsigned long	 real_end;	/* real end of data */
 	struct buffer_data_page *page;	/* Actual data page */
 };
 
@@ -417,6 +423,12 @@ int ring_buffer_print_page_header(struct trace_seq *s)
 			       (unsigned int)sizeof(field.commit),
 			       (unsigned int)is_signed_type(long));
 
+	ret = trace_seq_printf(s, "\tfield: int overwrite;\t"
+			       "offset:%u;\tsize:%u;\tsigned:%u;\n",
+			       (unsigned int)offsetof(typeof(field), commit),
+			       1,
+			       (unsigned int)is_signed_type(long));
+
 	ret = trace_seq_printf(s, "\tfield: char data;\t"
 			       "offset:%u;\tsize:%u;\tsigned:%u;\n",
 			       (unsigned int)offsetof(typeof(field), data),
@@ -440,6 +452,8 @@ struct ring_buffer_per_cpu {
 	struct buffer_page		*tail_page;	/* write to tail */
 	struct buffer_page		*commit_page;	/* committed pages */
 	struct buffer_page		*reader_page;
+	unsigned long			lost_events;
+	unsigned long			last_overrun;
 	local_t				commit_overrun;
 	local_t				overrun;
 	local_t				entries;
@@ -1762,6 +1776,13 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
 	kmemcheck_annotate_bitfield(event, bitfield);
 
 	/*
+	 * Save the original length to the meta data.
+	 * This will be used by the reader to add lost event
+	 * counter.
+	 */
+	tail_page->real_end = tail;
+
+	/*
 	 * If this event is bigger than the minimum size, then
 	 * we need to be careful that we don't subtract the
 	 * write counter enough to allow another writer to slip
@@ -1979,17 +2000,13 @@ rb_add_time_stamp(struct ring_buffer_per_cpu *cpu_buffer,
 		  u64 *ts, u64 *delta)
 {
 	struct ring_buffer_event *event;
-	static int once;
 	int ret;
 
-	if (unlikely(*delta > (1ULL << 59) && !once++)) {
-		printk(KERN_WARNING "Delta way too big! %llu"
-		       " ts=%llu write stamp = %llu\n",
-		       (unsigned long long)*delta,
-		       (unsigned long long)*ts,
-		       (unsigned long long)cpu_buffer->write_stamp);
-		WARN_ON(1);
-	}
+	WARN_ONCE(*delta > (1ULL << 59),
+		  KERN_WARNING "Delta way too big! %llu ts=%llu write stamp = %llu\n",
+		  (unsigned long long)*delta,
+		  (unsigned long long)*ts,
+		  (unsigned long long)cpu_buffer->write_stamp);
 
 	/*
 	 * The delta is too big, we to add a
@@ -2838,6 +2855,7 @@ static struct buffer_page *
 rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	struct buffer_page *reader = NULL;
+	unsigned long overwrite;
 	unsigned long flags;
 	int nr_loops = 0;
 	int ret;
@@ -2879,6 +2897,7 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	local_set(&cpu_buffer->reader_page->write, 0);
 	local_set(&cpu_buffer->reader_page->entries, 0);
 	local_set(&cpu_buffer->reader_page->page->commit, 0);
+	cpu_buffer->reader_page->real_end = 0;
 
  spin:
 	/*
@@ -2899,6 +2918,18 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	rb_set_list_to_head(cpu_buffer, &cpu_buffer->reader_page->list);
 
 	/*
+	 * We want to make sure we read the overruns after we set up our
+	 * pointers to the next object. The writer side does a
+	 * cmpxchg to cross pages which acts as the mb on the writer
+	 * side. Note, the reader will constantly fail the swap
+	 * while the writer is updating the pointers, so this
+	 * guarantees that the overwrite recorded here is the one we
+	 * want to compare with the last_overrun.
+	 */
+	smp_mb();
+	overwrite = local_read(&(cpu_buffer->overrun));
+
+	/*
 	 * Here's the tricky part.
 	 *
 	 * We need to move the pointer past the header page.
@@ -2929,6 +2960,11 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	cpu_buffer->reader_page = reader;
 	rb_reset_reader_page(cpu_buffer);
 
+	if (overwrite != cpu_buffer->last_overrun) {
+		cpu_buffer->lost_events = overwrite - cpu_buffer->last_overrun;
+		cpu_buffer->last_overrun = overwrite;
+	}
+
 	goto again;
 
  out:
@@ -3005,8 +3041,14 @@ static void rb_advance_iter(struct ring_buffer_iter *iter)
 		rb_advance_iter(iter);
 }
 
+static int rb_lost_events(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	return cpu_buffer->lost_events;
+}
+
 static struct ring_buffer_event *
-rb_buffer_peek(struct ring_buffer_per_cpu *cpu_buffer, u64 *ts)
+rb_buffer_peek(struct ring_buffer_per_cpu *cpu_buffer, u64 *ts,
+	       unsigned long *lost_events)
 {
 	struct ring_buffer_event *event;
 	struct buffer_page *reader;
@@ -3058,6 +3100,8 @@ rb_buffer_peek(struct ring_buffer_per_cpu *cpu_buffer, u64 *ts)
 			ring_buffer_normalize_time_stamp(cpu_buffer->buffer,
 							 cpu_buffer->cpu, ts);
 		}
+		if (lost_events)
+			*lost_events = rb_lost_events(cpu_buffer);
 		return event;
 
 	default:
@@ -3168,12 +3212,14 @@ static inline int rb_ok_to_lock(void)
  * @buffer: The ring buffer to read
  * @cpu: The cpu to peak at
  * @ts: The timestamp counter of this event.
+ * @lost_events: a variable to store if events were lost (may be NULL)
  *
  * This will return the event that will be read next, but does
  * not consume the data.
  */
 struct ring_buffer_event *
-ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
+ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts,
+		 unsigned long *lost_events)
 {
 	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
 	struct ring_buffer_event *event;
@@ -3188,7 +3234,7 @@ ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 	local_irq_save(flags);
 	if (dolock)
 		spin_lock(&cpu_buffer->reader_lock);
-	event = rb_buffer_peek(cpu_buffer, ts);
+	event = rb_buffer_peek(cpu_buffer, ts, lost_events);
 	if (event && event->type_len == RINGBUF_TYPE_PADDING)
 		rb_advance_reader(cpu_buffer);
 	if (dolock)
@@ -3230,13 +3276,17 @@ ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 /**
  * ring_buffer_consume - return an event and consume it
  * @buffer: The ring buffer to get the next event from
+ * @cpu: the cpu to read the buffer from
+ * @ts: a variable to store the timestamp (may be NULL)
+ * @lost_events: a variable to store if events were lost (may be NULL)
  *
  * Returns the next event in the ring buffer, and that event is consumed.
  * Meaning, that sequential reads will keep returning a different event,
  * and eventually empty the ring buffer if the producer is slower.
  */
 struct ring_buffer_event *
-ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
+ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts,
+		    unsigned long *lost_events)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event = NULL;
@@ -3257,9 +3307,11 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
 	if (dolock)
 		spin_lock(&cpu_buffer->reader_lock);
 
-	event = rb_buffer_peek(cpu_buffer, ts);
-	if (event)
+	event = rb_buffer_peek(cpu_buffer, ts, lost_events);
+	if (event) {
+		cpu_buffer->lost_events = 0;
 		rb_advance_reader(cpu_buffer);
+	}
 
 	if (dolock)
 		spin_unlock(&cpu_buffer->reader_lock);
@@ -3276,23 +3328,30 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
 EXPORT_SYMBOL_GPL(ring_buffer_consume);
 
 /**
- * ring_buffer_read_start - start a non consuming read of the buffer
+ * ring_buffer_read_prepare - Prepare for a non consuming read of the buffer
  * @buffer: The ring buffer to read from
  * @cpu: The cpu buffer to iterate over
  *
- * This starts up an iteration through the buffer. It also disables
- * the recording to the buffer until the reading is finished.
- * This prevents the reading from being corrupted. This is not
- * a consuming read, so a producer is not expected.
+ * This performs the initial preparations necessary to iterate
+ * through the buffer.  Memory is allocated, buffer recording
+ * is disabled, and the iterator pointer is returned to the caller.
  *
- * Must be paired with ring_buffer_finish.
+ * Disabling buffer recordng prevents the reading from being
+ * corrupted. This is not a consuming read, so a producer is not
+ * expected.
+ *
+ * After a sequence of ring_buffer_read_prepare calls, the user is
+ * expected to make at least one call to ring_buffer_prepare_sync.
+ * Afterwards, ring_buffer_read_start is invoked to get things going
+ * for real.
+ *
+ * This overall must be paired with ring_buffer_finish.
  */
 struct ring_buffer_iter *
-ring_buffer_read_start(struct ring_buffer *buffer, int cpu)
+ring_buffer_read_prepare(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_iter *iter;
-	unsigned long flags;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return NULL;
@@ -3306,15 +3365,52 @@ ring_buffer_read_start(struct ring_buffer *buffer, int cpu)
 	iter->cpu_buffer = cpu_buffer;
 
 	atomic_inc(&cpu_buffer->record_disabled);
+
+	return iter;
+}
+EXPORT_SYMBOL_GPL(ring_buffer_read_prepare);
+
+/**
+ * ring_buffer_read_prepare_sync - Synchronize a set of prepare calls
+ *
+ * All previously invoked ring_buffer_read_prepare calls to prepare
+ * iterators will be synchronized.  Afterwards, read_buffer_read_start
+ * calls on those iterators are allowed.
+ */
+void
+ring_buffer_read_prepare_sync(void)
+{
 	synchronize_sched();
+}
+EXPORT_SYMBOL_GPL(ring_buffer_read_prepare_sync);
+
+/**
+ * ring_buffer_read_start - start a non consuming read of the buffer
+ * @iter: The iterator returned by ring_buffer_read_prepare
+ *
+ * This finalizes the startup of an iteration through the buffer.
+ * The iterator comes from a call to ring_buffer_read_prepare and
+ * an intervening ring_buffer_read_prepare_sync must have been
+ * performed.
+ *
+ * Must be paired with ring_buffer_finish.
+ */
+void
+ring_buffer_read_start(struct ring_buffer_iter *iter)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	unsigned long flags;
+
+	if (!iter)
+		return;
+
+	cpu_buffer = iter->cpu_buffer;
 
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 	arch_spin_lock(&cpu_buffer->lock);
 	rb_iter_reset(iter);
 	arch_spin_unlock(&cpu_buffer->lock);
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
-
-	return iter;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_read_start);
 
@@ -3408,6 +3504,9 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 	cpu_buffer->write_stamp = 0;
 	cpu_buffer->read_stamp = 0;
 
+	cpu_buffer->lost_events = 0;
+	cpu_buffer->last_overrun = 0;
+
 	rb_head_page_activate(cpu_buffer);
 }
 
@@ -3683,6 +3782,7 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 	struct ring_buffer_event *event;
 	struct buffer_data_page *bpage;
 	struct buffer_page *reader;
+	unsigned long missed_events;
 	unsigned long flags;
 	unsigned int commit;
 	unsigned int read;
@@ -3719,6 +3819,9 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 	read = reader->read;
 	commit = rb_page_commit(reader);
 
+	/* Check if any events were dropped */
+	missed_events = cpu_buffer->lost_events;
+
 	/*
 	 * If this page has been partially read or
 	 * if len is not big enough to read the rest of the page or
@@ -3779,9 +3882,35 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 		local_set(&reader->entries, 0);
 		reader->read = 0;
 		*data_page = bpage;
+
+		/*
+		 * Use the real_end for the data size,
+		 * This gives us a chance to store the lost events
+		 * on the page.
+		 */
+		if (reader->real_end)
+			local_set(&bpage->commit, reader->real_end);
 	}
 	ret = read;
 
+	cpu_buffer->lost_events = 0;
+	/*
+	 * Set a flag in the commit field if we lost events
+	 */
+	if (missed_events) {
+		commit = local_read(&bpage->commit);
+
+		/* If there is room at the end of the page to save the
+		 * missed events, then record it there.
+		 */
+		if (BUF_PAGE_SIZE - commit >= sizeof(missed_events)) {
+			memcpy(&bpage->data[commit], &missed_events,
+			       sizeof(missed_events));
+			local_add(RB_MISSED_STORED, &bpage->commit);
+		}
+		local_add(RB_MISSED_EVENTS, &bpage->commit);
+	}
+
  out_unlock:
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index df74c79..302f8a6 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -81,7 +81,7 @@ static enum event_status read_event(int cpu)
 	int *entry;
 	u64 ts;
 
-	event = ring_buffer_consume(buffer, cpu, &ts);
+	event = ring_buffer_consume(buffer, cpu, &ts, NULL);
 	if (!event)
 		return EVENT_DROPPED;
 
@@ -113,7 +113,8 @@ static enum event_status read_page(int cpu)
 	ret = ring_buffer_read_page(buffer, &bpage, PAGE_SIZE, cpu, 1);
 	if (ret >= 0) {
 		rpage = bpage;
-		commit = local_read(&rpage->commit);
+		/* The commit may have missed event flags set, clear them */
+		commit = local_read(&rpage->commit) & 0xfffff;
 		for (i = 0; i < commit && !kill_test; i += inc) {
 
 			if (i >= (PAGE_SIZE - offsetof(struct rb_page, data))) {
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 44f916a..756d728 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -117,9 +117,12 @@ static cpumask_var_t __read_mostly	tracing_buffer_mask;
  *
  * It is default off, but you can enable it with either specifying
  * "ftrace_dump_on_oops" in the kernel command line, or setting
- * /proc/sys/kernel/ftrace_dump_on_oops to true.
+ * /proc/sys/kernel/ftrace_dump_on_oops
+ * Set 1 if you want to dump buffers of all CPUs
+ * Set 2 if you want to dump the buffer of the CPU that triggered oops
  */
-int ftrace_dump_on_oops;
+
+enum ftrace_dump_mode ftrace_dump_on_oops;
 
 static int tracing_set_tracer(const char *buf);
 
@@ -139,8 +142,17 @@ __setup("ftrace=", set_cmdline_ftrace);
 
 static int __init set_ftrace_dump_on_oops(char *str)
 {
-	ftrace_dump_on_oops = 1;
-	return 1;
+	if (*str++ != '=' || !*str) {
+		ftrace_dump_on_oops = DUMP_ALL;
+		return 1;
+	}
+
+	if (!strcmp("orig_cpu", str)) {
+		ftrace_dump_on_oops = DUMP_ORIG;
+                return 1;
+        }
+
+        return 0;
 }
 __setup("ftrace_dump_on_oops", set_ftrace_dump_on_oops);
 
@@ -1545,7 +1557,8 @@ static void trace_iterator_increment(struct trace_iterator *iter)
 }
 
 static struct trace_entry *
-peek_next_entry(struct trace_iterator *iter, int cpu, u64 *ts)
+peek_next_entry(struct trace_iterator *iter, int cpu, u64 *ts,
+		unsigned long *lost_events)
 {
 	struct ring_buffer_event *event;
 	struct ring_buffer_iter *buf_iter = iter->buffer_iter[cpu];
@@ -1556,7 +1569,8 @@ peek_next_entry(struct trace_iterator *iter, int cpu, u64 *ts)
 	if (buf_iter)
 		event = ring_buffer_iter_peek(buf_iter, ts);
 	else
-		event = ring_buffer_peek(iter->tr->buffer, cpu, ts);
+		event = ring_buffer_peek(iter->tr->buffer, cpu, ts,
+					 lost_events);
 
 	ftrace_enable_cpu();
 
@@ -1564,10 +1578,12 @@ peek_next_entry(struct trace_iterator *iter, int cpu, u64 *ts)
 }
 
 static struct trace_entry *
-__find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts)
+__find_next_entry(struct trace_iterator *iter, int *ent_cpu,
+		  unsigned long *missing_events, u64 *ent_ts)
 {
 	struct ring_buffer *buffer = iter->tr->buffer;
 	struct trace_entry *ent, *next = NULL;
+	unsigned long lost_events = 0, next_lost = 0;
 	int cpu_file = iter->cpu_file;
 	u64 next_ts = 0, ts;
 	int next_cpu = -1;
@@ -1580,7 +1596,7 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts)
 	if (cpu_file > TRACE_PIPE_ALL_CPU) {
 		if (ring_buffer_empty_cpu(buffer, cpu_file))
 			return NULL;
-		ent = peek_next_entry(iter, cpu_file, ent_ts);
+		ent = peek_next_entry(iter, cpu_file, ent_ts, missing_events);
 		if (ent_cpu)
 			*ent_cpu = cpu_file;
 
@@ -1592,7 +1608,7 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts)
 		if (ring_buffer_empty_cpu(buffer, cpu))
 			continue;
 
-		ent = peek_next_entry(iter, cpu, &ts);
+		ent = peek_next_entry(iter, cpu, &ts, &lost_events);
 
 		/*
 		 * Pick the entry with the smallest timestamp:
@@ -1601,6 +1617,7 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts)
 			next = ent;
 			next_cpu = cpu;
 			next_ts = ts;
+			next_lost = lost_events;
 		}
 	}
 
@@ -1610,6 +1627,9 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts)
 	if (ent_ts)
 		*ent_ts = next_ts;
 
+	if (missing_events)
+		*missing_events = next_lost;
+
 	return next;
 }
 
@@ -1617,13 +1637,14 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts)
 struct trace_entry *trace_find_next_entry(struct trace_iterator *iter,
 					  int *ent_cpu, u64 *ent_ts)
 {
-	return __find_next_entry(iter, ent_cpu, ent_ts);
+	return __find_next_entry(iter, ent_cpu, NULL, ent_ts);
 }
 
 /* Find the next real entry, and increment the iterator to the next entry */
 static void *find_next_entry_inc(struct trace_iterator *iter)
 {
-	iter->ent = __find_next_entry(iter, &iter->cpu, &iter->ts);
+	iter->ent = __find_next_entry(iter, &iter->cpu,
+				      &iter->lost_events, &iter->ts);
 
 	if (iter->ent)
 		trace_iterator_increment(iter);
@@ -1635,7 +1656,8 @@ static void trace_consume(struct trace_iterator *iter)
 {
 	/* Don't allow ftrace to trace into the ring buffers */
 	ftrace_disable_cpu();
-	ring_buffer_consume(iter->tr->buffer, iter->cpu, &iter->ts);
+	ring_buffer_consume(iter->tr->buffer, iter->cpu, &iter->ts,
+			    &iter->lost_events);
 	ftrace_enable_cpu();
 }
 
@@ -1786,7 +1808,7 @@ static void print_func_help_header(struct seq_file *m)
 }
 
 
-static void
+void
 print_trace_header(struct seq_file *m, struct trace_iterator *iter)
 {
 	unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
@@ -1995,7 +2017,7 @@ static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
 	return event ? event->binary(iter, 0) : TRACE_TYPE_HANDLED;
 }
 
-static int trace_empty(struct trace_iterator *iter)
+int trace_empty(struct trace_iterator *iter)
 {
 	int cpu;
 
@@ -2030,6 +2052,10 @@ static enum print_line_t print_trace_line(struct trace_iterator *iter)
 {
 	enum print_line_t ret;
 
+	if (iter->lost_events)
+		trace_seq_printf(&iter->seq, "CPU:%d [LOST %lu EVENTS]\n",
+				 iter->cpu, iter->lost_events);
+
 	if (iter->trace && iter->trace->print_line) {
 		ret = iter->trace->print_line(iter);
 		if (ret != TRACE_TYPE_UNHANDLED)
@@ -2058,6 +2084,23 @@ static enum print_line_t print_trace_line(struct trace_iterator *iter)
 	return print_trace_fmt(iter);
 }
 
+void trace_default_header(struct seq_file *m)
+{
+	struct trace_iterator *iter = m->private;
+
+	if (iter->iter_flags & TRACE_FILE_LAT_FMT) {
+		/* print nothing if the buffers are empty */
+		if (trace_empty(iter))
+			return;
+		print_trace_header(m, iter);
+		if (!(trace_flags & TRACE_ITER_VERBOSE))
+			print_lat_help_header(m);
+	} else {
+		if (!(trace_flags & TRACE_ITER_VERBOSE))
+			print_func_help_header(m);
+	}
+}
+
 static int s_show(struct seq_file *m, void *v)
 {
 	struct trace_iterator *iter = v;
@@ -2070,17 +2113,9 @@ static int s_show(struct seq_file *m, void *v)
 		}
 		if (iter->trace && iter->trace->print_header)
 			iter->trace->print_header(m);
-		else if (iter->iter_flags & TRACE_FILE_LAT_FMT) {
-			/* print nothing if the buffers are empty */
-			if (trace_empty(iter))
-				return 0;
-			print_trace_header(m, iter);
-			if (!(trace_flags & TRACE_ITER_VERBOSE))
-				print_lat_help_header(m);
-		} else {
-			if (!(trace_flags & TRACE_ITER_VERBOSE))
-				print_func_help_header(m);
-		}
+		else
+			trace_default_header(m);
+
 	} else if (iter->leftover) {
 		/*
 		 * If we filled the seq_file buffer earlier, we
@@ -2166,15 +2201,20 @@ __tracing_open(struct inode *inode, struct file *file)
 
 	if (iter->cpu_file == TRACE_PIPE_ALL_CPU) {
 		for_each_tracing_cpu(cpu) {
-
 			iter->buffer_iter[cpu] =
-				ring_buffer_read_start(iter->tr->buffer, cpu);
+				ring_buffer_read_prepare(iter->tr->buffer, cpu);
+		}
+		ring_buffer_read_prepare_sync();
+		for_each_tracing_cpu(cpu) {
+			ring_buffer_read_start(iter->buffer_iter[cpu]);
 			tracing_iter_reset(iter, cpu);
 		}
 	} else {
 		cpu = iter->cpu_file;
 		iter->buffer_iter[cpu] =
-				ring_buffer_read_start(iter->tr->buffer, cpu);
+			ring_buffer_read_prepare(iter->tr->buffer, cpu);
+		ring_buffer_read_prepare_sync();
+		ring_buffer_read_start(iter->buffer_iter[cpu]);
 		tracing_iter_reset(iter, cpu);
 	}
 
@@ -4324,7 +4364,7 @@ static int trace_panic_handler(struct notifier_block *this,
 			       unsigned long event, void *unused)
 {
 	if (ftrace_dump_on_oops)
-		ftrace_dump();
+		ftrace_dump(ftrace_dump_on_oops);
 	return NOTIFY_OK;
 }
 
@@ -4341,7 +4381,7 @@ static int trace_die_handler(struct notifier_block *self,
 	switch (val) {
 	case DIE_OOPS:
 		if (ftrace_dump_on_oops)
-			ftrace_dump();
+			ftrace_dump(ftrace_dump_on_oops);
 		break;
 	default:
 		break;
@@ -4382,7 +4422,8 @@ trace_printk_seq(struct trace_seq *s)
 	trace_seq_init(s);
 }
 
-static void __ftrace_dump(bool disable_tracing)
+static void
+__ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
 {
 	static arch_spinlock_t ftrace_dump_lock =
 		(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
@@ -4415,12 +4456,25 @@ static void __ftrace_dump(bool disable_tracing)
 	/* don't look at user memory in panic mode */
 	trace_flags &= ~TRACE_ITER_SYM_USEROBJ;
 
-	printk(KERN_TRACE "Dumping ftrace buffer:\n");
-
 	/* Simulate the iterator */
 	iter.tr = &global_trace;
 	iter.trace = current_trace;
-	iter.cpu_file = TRACE_PIPE_ALL_CPU;
+
+	switch (oops_dump_mode) {
+	case DUMP_ALL:
+		iter.cpu_file = TRACE_PIPE_ALL_CPU;
+		break;
+	case DUMP_ORIG:
+		iter.cpu_file = raw_smp_processor_id();
+		break;
+	case DUMP_NONE:
+		goto out_enable;
+	default:
+		printk(KERN_TRACE "Bad dumping mode, switching to all CPUs dump\n");
+		iter.cpu_file = TRACE_PIPE_ALL_CPU;
+	}
+
+	printk(KERN_TRACE "Dumping ftrace buffer:\n");
 
 	/*
 	 * We need to stop all tracing on all CPUS to read the
@@ -4459,6 +4513,7 @@ static void __ftrace_dump(bool disable_tracing)
 	else
 		printk(KERN_TRACE "---------------------------------\n");
 
+ out_enable:
 	/* Re-enable tracing if requested */
 	if (!disable_tracing) {
 		trace_flags |= old_userobj;
@@ -4475,9 +4530,9 @@ static void __ftrace_dump(bool disable_tracing)
 }
 
 /* By default: disable tracing after the dump */
-void ftrace_dump(void)
+void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
 {
-	__ftrace_dump(true);
+	__ftrace_dump(true, oops_dump_mode);
 }
 
 __init static int tracer_alloc_buffers(void)
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 2825ef2..911e986 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -378,6 +378,9 @@ void trace_function(struct trace_array *tr,
 		    unsigned long ip,
 		    unsigned long parent_ip,
 		    unsigned long flags, int pc);
+void trace_default_header(struct seq_file *m);
+void print_trace_header(struct seq_file *m, struct trace_iterator *iter);
+int trace_empty(struct trace_iterator *iter);
 
 void trace_graph_return(struct ftrace_graph_ret *trace);
 int trace_graph_entry(struct ftrace_graph_ent *trace);
@@ -491,9 +494,29 @@ extern int trace_clock_id;
 
 /* Standard output formatting function used for function return traces */
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-extern enum print_line_t print_graph_function(struct trace_iterator *iter);
+
+/* Flag options */
+#define TRACE_GRAPH_PRINT_OVERRUN       0x1
+#define TRACE_GRAPH_PRINT_CPU           0x2
+#define TRACE_GRAPH_PRINT_OVERHEAD      0x4
+#define TRACE_GRAPH_PRINT_PROC          0x8
+#define TRACE_GRAPH_PRINT_DURATION      0x10
+#define TRACE_GRAPH_PRINT_ABS_TIME      0x20
+
+extern enum print_line_t
+print_graph_function_flags(struct trace_iterator *iter, u32 flags);
+extern void print_graph_headers_flags(struct seq_file *s, u32 flags);
 extern enum print_line_t
 trace_print_graph_duration(unsigned long long duration, struct trace_seq *s);
+extern void graph_trace_open(struct trace_iterator *iter);
+extern void graph_trace_close(struct trace_iterator *iter);
+extern int __trace_graph_entry(struct trace_array *tr,
+			       struct ftrace_graph_ent *trace,
+			       unsigned long flags, int pc);
+extern void __trace_graph_return(struct trace_array *tr,
+				 struct ftrace_graph_ret *trace,
+				 unsigned long flags, int pc);
+
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 /* TODO: make this variable */
@@ -524,7 +547,7 @@ static inline int ftrace_graph_addr(unsigned long addr)
 #endif /* CONFIG_DYNAMIC_FTRACE */
 #else /* CONFIG_FUNCTION_GRAPH_TRACER */
 static inline enum print_line_t
-print_graph_function(struct trace_iterator *iter)
+print_graph_function_flags(struct trace_iterator *iter, u32 flags)
 {
 	return TRACE_TYPE_UNHANDLED;
 }
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 9aed1a5..dd11c83 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -40,7 +40,7 @@ struct fgraph_data {
 #define TRACE_GRAPH_PRINT_OVERHEAD	0x4
 #define TRACE_GRAPH_PRINT_PROC		0x8
 #define TRACE_GRAPH_PRINT_DURATION	0x10
-#define TRACE_GRAPH_PRINT_ABS_TIME	0X20
+#define TRACE_GRAPH_PRINT_ABS_TIME	0x20
 
 static struct tracer_opt trace_opts[] = {
 	/* Display overruns? (for self-debug purpose) */
@@ -179,7 +179,7 @@ unsigned long ftrace_return_to_handler(unsigned long frame_pointer)
 	return ret;
 }
 
-static int __trace_graph_entry(struct trace_array *tr,
+int __trace_graph_entry(struct trace_array *tr,
 				struct ftrace_graph_ent *trace,
 				unsigned long flags,
 				int pc)
@@ -246,7 +246,7 @@ int trace_graph_thresh_entry(struct ftrace_graph_ent *trace)
 		return trace_graph_entry(trace);
 }
 
-static void __trace_graph_return(struct trace_array *tr,
+void __trace_graph_return(struct trace_array *tr,
 				struct ftrace_graph_ret *trace,
 				unsigned long flags,
 				int pc)
@@ -490,9 +490,10 @@ get_return_for_leaf(struct trace_iterator *iter,
 			 * We need to consume the current entry to see
 			 * the next one.
 			 */
-			ring_buffer_consume(iter->tr->buffer, iter->cpu, NULL);
+			ring_buffer_consume(iter->tr->buffer, iter->cpu,
+					    NULL, NULL);
 			event = ring_buffer_peek(iter->tr->buffer, iter->cpu,
-						 NULL);
+						 NULL, NULL);
 		}
 
 		if (!event)
@@ -526,17 +527,18 @@ get_return_for_leaf(struct trace_iterator *iter,
 
 /* Signal a overhead of time execution to the output */
 static int
-print_graph_overhead(unsigned long long duration, struct trace_seq *s)
+print_graph_overhead(unsigned long long duration, struct trace_seq *s,
+		     u32 flags)
 {
 	/* If duration disappear, we don't need anything */
-	if (!(tracer_flags.val & TRACE_GRAPH_PRINT_DURATION))
+	if (!(flags & TRACE_GRAPH_PRINT_DURATION))
 		return 1;
 
 	/* Non nested entry or return */
 	if (duration == -1)
 		return trace_seq_printf(s, "  ");
 
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_OVERHEAD) {
+	if (flags & TRACE_GRAPH_PRINT_OVERHEAD) {
 		/* Duration exceeded 100 msecs */
 		if (duration > 100000ULL)
 			return trace_seq_printf(s, "! ");
@@ -562,7 +564,7 @@ static int print_graph_abs_time(u64 t, struct trace_seq *s)
 
 static enum print_line_t
 print_graph_irq(struct trace_iterator *iter, unsigned long addr,
-		enum trace_type type, int cpu, pid_t pid)
+		enum trace_type type, int cpu, pid_t pid, u32 flags)
 {
 	int ret;
 	struct trace_seq *s = &iter->seq;
@@ -572,21 +574,21 @@ print_graph_irq(struct trace_iterator *iter, unsigned long addr,
 		return TRACE_TYPE_UNHANDLED;
 
 	/* Absolute time */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_ABS_TIME) {
+	if (flags & TRACE_GRAPH_PRINT_ABS_TIME) {
 		ret = print_graph_abs_time(iter->ts, s);
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
 	/* Cpu */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU) {
+	if (flags & TRACE_GRAPH_PRINT_CPU) {
 		ret = print_graph_cpu(s, cpu);
 		if (ret == TRACE_TYPE_PARTIAL_LINE)
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
 	/* Proc */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC) {
+	if (flags & TRACE_GRAPH_PRINT_PROC) {
 		ret = print_graph_proc(s, pid);
 		if (ret == TRACE_TYPE_PARTIAL_LINE)
 			return TRACE_TYPE_PARTIAL_LINE;
@@ -596,7 +598,7 @@ print_graph_irq(struct trace_iterator *iter, unsigned long addr,
 	}
 
 	/* No overhead */
-	ret = print_graph_overhead(-1, s);
+	ret = print_graph_overhead(-1, s, flags);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
@@ -609,7 +611,7 @@ print_graph_irq(struct trace_iterator *iter, unsigned long addr,
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* Don't close the duration column if haven't one */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_DURATION)
+	if (flags & TRACE_GRAPH_PRINT_DURATION)
 		trace_seq_printf(s, " |");
 	ret = trace_seq_printf(s, "\n");
 
@@ -679,7 +681,8 @@ print_graph_duration(unsigned long long duration, struct trace_seq *s)
 static enum print_line_t
 print_graph_entry_leaf(struct trace_iterator *iter,
 		struct ftrace_graph_ent_entry *entry,
-		struct ftrace_graph_ret_entry *ret_entry, struct trace_seq *s)
+		struct ftrace_graph_ret_entry *ret_entry,
+		struct trace_seq *s, u32 flags)
 {
 	struct fgraph_data *data = iter->private;
 	struct ftrace_graph_ret *graph_ret;
@@ -711,12 +714,12 @@ print_graph_entry_leaf(struct trace_iterator *iter,
 	}
 
 	/* Overhead */
-	ret = print_graph_overhead(duration, s);
+	ret = print_graph_overhead(duration, s, flags);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* Duration */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_DURATION) {
+	if (flags & TRACE_GRAPH_PRINT_DURATION) {
 		ret = print_graph_duration(duration, s);
 		if (ret == TRACE_TYPE_PARTIAL_LINE)
 			return TRACE_TYPE_PARTIAL_LINE;
@@ -739,7 +742,7 @@ print_graph_entry_leaf(struct trace_iterator *iter,
 static enum print_line_t
 print_graph_entry_nested(struct trace_iterator *iter,
 			 struct ftrace_graph_ent_entry *entry,
-			 struct trace_seq *s, int cpu)
+			 struct trace_seq *s, int cpu, u32 flags)
 {
 	struct ftrace_graph_ent *call = &entry->graph_ent;
 	struct fgraph_data *data = iter->private;
@@ -759,12 +762,12 @@ print_graph_entry_nested(struct trace_iterator *iter,
 	}
 
 	/* No overhead */
-	ret = print_graph_overhead(-1, s);
+	ret = print_graph_overhead(-1, s, flags);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* No time */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_DURATION) {
+	if (flags & TRACE_GRAPH_PRINT_DURATION) {
 		ret = trace_seq_printf(s, "            |  ");
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
@@ -790,7 +793,7 @@ print_graph_entry_nested(struct trace_iterator *iter,
 
 static enum print_line_t
 print_graph_prologue(struct trace_iterator *iter, struct trace_seq *s,
-		     int type, unsigned long addr)
+		     int type, unsigned long addr, u32 flags)
 {
 	struct fgraph_data *data = iter->private;
 	struct trace_entry *ent = iter->ent;
@@ -803,27 +806,27 @@ print_graph_prologue(struct trace_iterator *iter, struct trace_seq *s,
 
 	if (type) {
 		/* Interrupt */
-		ret = print_graph_irq(iter, addr, type, cpu, ent->pid);
+		ret = print_graph_irq(iter, addr, type, cpu, ent->pid, flags);
 		if (ret == TRACE_TYPE_PARTIAL_LINE)
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
 	/* Absolute time */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_ABS_TIME) {
+	if (flags & TRACE_GRAPH_PRINT_ABS_TIME) {
 		ret = print_graph_abs_time(iter->ts, s);
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
 	/* Cpu */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU) {
+	if (flags & TRACE_GRAPH_PRINT_CPU) {
 		ret = print_graph_cpu(s, cpu);
 		if (ret == TRACE_TYPE_PARTIAL_LINE)
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
 	/* Proc */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC) {
+	if (flags & TRACE_GRAPH_PRINT_PROC) {
 		ret = print_graph_proc(s, ent->pid);
 		if (ret == TRACE_TYPE_PARTIAL_LINE)
 			return TRACE_TYPE_PARTIAL_LINE;
@@ -845,7 +848,7 @@ print_graph_prologue(struct trace_iterator *iter, struct trace_seq *s,
 
 static enum print_line_t
 print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
-			struct trace_iterator *iter)
+			struct trace_iterator *iter, u32 flags)
 {
 	struct fgraph_data *data = iter->private;
 	struct ftrace_graph_ent *call = &field->graph_ent;
@@ -853,14 +856,14 @@ print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
 	static enum print_line_t ret;
 	int cpu = iter->cpu;
 
-	if (print_graph_prologue(iter, s, TRACE_GRAPH_ENT, call->func))
+	if (print_graph_prologue(iter, s, TRACE_GRAPH_ENT, call->func, flags))
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	leaf_ret = get_return_for_leaf(iter, field);
 	if (leaf_ret)
-		ret = print_graph_entry_leaf(iter, field, leaf_ret, s);
+		ret = print_graph_entry_leaf(iter, field, leaf_ret, s, flags);
 	else
-		ret = print_graph_entry_nested(iter, field, s, cpu);
+		ret = print_graph_entry_nested(iter, field, s, cpu, flags);
 
 	if (data) {
 		/*
@@ -879,7 +882,8 @@ print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
 
 static enum print_line_t
 print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
-		   struct trace_entry *ent, struct trace_iterator *iter)
+		   struct trace_entry *ent, struct trace_iterator *iter,
+		   u32 flags)
 {
 	unsigned long long duration = trace->rettime - trace->calltime;
 	struct fgraph_data *data = iter->private;
@@ -909,16 +913,16 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 		}
 	}
 
-	if (print_graph_prologue(iter, s, 0, 0))
+	if (print_graph_prologue(iter, s, 0, 0, flags))
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* Overhead */
-	ret = print_graph_overhead(duration, s);
+	ret = print_graph_overhead(duration, s, flags);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* Duration */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_DURATION) {
+	if (flags & TRACE_GRAPH_PRINT_DURATION) {
 		ret = print_graph_duration(duration, s);
 		if (ret == TRACE_TYPE_PARTIAL_LINE)
 			return TRACE_TYPE_PARTIAL_LINE;
@@ -948,14 +952,15 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 	}
 
 	/* Overrun */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_OVERRUN) {
+	if (flags & TRACE_GRAPH_PRINT_OVERRUN) {
 		ret = trace_seq_printf(s, " (Overruns: %lu)\n",
 					trace->overrun);
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
-	ret = print_graph_irq(iter, trace->func, TRACE_GRAPH_RET, cpu, pid);
+	ret = print_graph_irq(iter, trace->func, TRACE_GRAPH_RET,
+			      cpu, pid, flags);
 	if (ret == TRACE_TYPE_PARTIAL_LINE)
 		return TRACE_TYPE_PARTIAL_LINE;
 
@@ -963,8 +968,8 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 }
 
 static enum print_line_t
-print_graph_comment(struct trace_seq *s,  struct trace_entry *ent,
-		    struct trace_iterator *iter)
+print_graph_comment(struct trace_seq *s, struct trace_entry *ent,
+		    struct trace_iterator *iter, u32 flags)
 {
 	unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
 	struct fgraph_data *data = iter->private;
@@ -976,16 +981,16 @@ print_graph_comment(struct trace_seq *s,  struct trace_entry *ent,
 	if (data)
 		depth = per_cpu_ptr(data->cpu_data, iter->cpu)->depth;
 
-	if (print_graph_prologue(iter, s, 0, 0))
+	if (print_graph_prologue(iter, s, 0, 0, flags))
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* No overhead */
-	ret = print_graph_overhead(-1, s);
+	ret = print_graph_overhead(-1, s, flags);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* No time */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_DURATION) {
+	if (flags & TRACE_GRAPH_PRINT_DURATION) {
 		ret = trace_seq_printf(s, "            |  ");
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
@@ -1040,7 +1045,7 @@ print_graph_comment(struct trace_seq *s,  struct trace_entry *ent,
 
 
 enum print_line_t
-print_graph_function(struct trace_iterator *iter)
+print_graph_function_flags(struct trace_iterator *iter, u32 flags)
 {
 	struct ftrace_graph_ent_entry *field;
 	struct fgraph_data *data = iter->private;
@@ -1061,7 +1066,7 @@ print_graph_function(struct trace_iterator *iter)
 	if (data && data->failed) {
 		field = &data->ent;
 		iter->cpu = data->cpu;
-		ret = print_graph_entry(field, s, iter);
+		ret = print_graph_entry(field, s, iter, flags);
 		if (ret == TRACE_TYPE_HANDLED && iter->cpu != cpu) {
 			per_cpu_ptr(data->cpu_data, iter->cpu)->ignore = 1;
 			ret = TRACE_TYPE_NO_CONSUME;
@@ -1081,32 +1086,49 @@ print_graph_function(struct trace_iterator *iter)
 		struct ftrace_graph_ent_entry saved;
 		trace_assign_type(field, entry);
 		saved = *field;
-		return print_graph_entry(&saved, s, iter);
+		return print_graph_entry(&saved, s, iter, flags);
 	}
 	case TRACE_GRAPH_RET: {
 		struct ftrace_graph_ret_entry *field;
 		trace_assign_type(field, entry);
-		return print_graph_return(&field->ret, s, entry, iter);
+		return print_graph_return(&field->ret, s, entry, iter, flags);
 	}
+	case TRACE_STACK:
+	case TRACE_FN:
+		/* dont trace stack and functions as comments */
+		return TRACE_TYPE_UNHANDLED;
+
 	default:
-		return print_graph_comment(s, entry, iter);
+		return print_graph_comment(s, entry, iter, flags);
 	}
 
 	return TRACE_TYPE_HANDLED;
 }
 
-static void print_lat_header(struct seq_file *s)
+static enum print_line_t
+print_graph_function(struct trace_iterator *iter)
+{
+	return print_graph_function_flags(iter, tracer_flags.val);
+}
+
+static enum print_line_t
+print_graph_function_event(struct trace_iterator *iter, int flags)
+{
+	return print_graph_function(iter);
+}
+
+static void print_lat_header(struct seq_file *s, u32 flags)
 {
 	static const char spaces[] = "                "	/* 16 spaces */
 		"    "					/* 4 spaces */
 		"                 ";			/* 17 spaces */
 	int size = 0;
 
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_ABS_TIME)
+	if (flags & TRACE_GRAPH_PRINT_ABS_TIME)
 		size += 16;
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU)
+	if (flags & TRACE_GRAPH_PRINT_CPU)
 		size += 4;
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC)
+	if (flags & TRACE_GRAPH_PRINT_PROC)
 		size += 17;
 
 	seq_printf(s, "#%.*s  _-----=> irqs-off        \n", size, spaces);
@@ -1117,43 +1139,48 @@ static void print_lat_header(struct seq_file *s)
 	seq_printf(s, "#%.*s|||| /                     \n", size, spaces);
 }
 
-static void print_graph_headers(struct seq_file *s)
+void print_graph_headers_flags(struct seq_file *s, u32 flags)
 {
 	int lat = trace_flags & TRACE_ITER_LATENCY_FMT;
 
 	if (lat)
-		print_lat_header(s);
+		print_lat_header(s, flags);
 
 	/* 1st line */
 	seq_printf(s, "#");
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_ABS_TIME)
+	if (flags & TRACE_GRAPH_PRINT_ABS_TIME)
 		seq_printf(s, "     TIME       ");
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU)
+	if (flags & TRACE_GRAPH_PRINT_CPU)
 		seq_printf(s, " CPU");
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC)
+	if (flags & TRACE_GRAPH_PRINT_PROC)
 		seq_printf(s, "  TASK/PID       ");
 	if (lat)
 		seq_printf(s, "|||||");
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_DURATION)
+	if (flags & TRACE_GRAPH_PRINT_DURATION)
 		seq_printf(s, "  DURATION   ");
 	seq_printf(s, "               FUNCTION CALLS\n");
 
 	/* 2nd line */
 	seq_printf(s, "#");
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_ABS_TIME)
+	if (flags & TRACE_GRAPH_PRINT_ABS_TIME)
 		seq_printf(s, "      |         ");
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU)
+	if (flags & TRACE_GRAPH_PRINT_CPU)
 		seq_printf(s, " |  ");
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC)
+	if (flags & TRACE_GRAPH_PRINT_PROC)
 		seq_printf(s, "   |    |        ");
 	if (lat)
 		seq_printf(s, "|||||");
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_DURATION)
+	if (flags & TRACE_GRAPH_PRINT_DURATION)
 		seq_printf(s, "   |   |      ");
 	seq_printf(s, "               |   |   |   |\n");
 }
 
-static void graph_trace_open(struct trace_iterator *iter)
+void print_graph_headers(struct seq_file *s)
+{
+	print_graph_headers_flags(s, tracer_flags.val);
+}
+
+void graph_trace_open(struct trace_iterator *iter)
 {
 	/* pid and depth on the last trace processed */
 	struct fgraph_data *data;
@@ -1188,7 +1215,7 @@ static void graph_trace_open(struct trace_iterator *iter)
 	pr_warning("function graph tracer: not enough memory\n");
 }
 
-static void graph_trace_close(struct trace_iterator *iter)
+void graph_trace_close(struct trace_iterator *iter)
 {
 	struct fgraph_data *data = iter->private;
 
@@ -1198,6 +1225,16 @@ static void graph_trace_close(struct trace_iterator *iter)
 	}
 }
 
+static struct trace_event graph_trace_entry_event = {
+	.type		= TRACE_GRAPH_ENT,
+	.trace		= print_graph_function_event,
+};
+
+static struct trace_event graph_trace_ret_event = {
+	.type		= TRACE_GRAPH_RET,
+	.trace		= print_graph_function_event,
+};
+
 static struct tracer graph_trace __read_mostly = {
 	.name		= "function_graph",
 	.open		= graph_trace_open,
@@ -1219,6 +1256,16 @@ static __init int init_graph_trace(void)
 {
 	max_bytes_for_cpu = snprintf(NULL, 0, "%d", nr_cpu_ids - 1);
 
+	if (!register_ftrace_event(&graph_trace_entry_event)) {
+		pr_warning("Warning: could not register graph trace events\n");
+		return 1;
+	}
+
+	if (!register_ftrace_event(&graph_trace_ret_event)) {
+		pr_warning("Warning: could not register graph trace events\n");
+		return 1;
+	}
+
 	return register_tracer(&graph_trace);
 }
 
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 2974bc7..6fd486e 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -34,6 +34,9 @@ static int trace_type __read_mostly;
 
 static int save_lat_flag;
 
+static void stop_irqsoff_tracer(struct trace_array *tr, int graph);
+static int start_irqsoff_tracer(struct trace_array *tr, int graph);
+
 #ifdef CONFIG_PREEMPT_TRACER
 static inline int
 preempt_trace(void)
@@ -55,6 +58,23 @@ irq_trace(void)
 # define irq_trace() (0)
 #endif
 
+#define TRACE_DISPLAY_GRAPH	1
+
+static struct tracer_opt trace_opts[] = {
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	/* display latency trace as call graph */
+	{ TRACER_OPT(display-graph, TRACE_DISPLAY_GRAPH) },
+#endif
+	{ } /* Empty entry */
+};
+
+static struct tracer_flags tracer_flags = {
+	.val  = 0,
+	.opts = trace_opts,
+};
+
+#define is_graph() (tracer_flags.val & TRACE_DISPLAY_GRAPH)
+
 /*
  * Sequence count - we record it when starting a measurement and
  * skip the latency if the sequence has changed - some other section
@@ -108,6 +128,202 @@ static struct ftrace_ops trace_ops __read_mostly =
 };
 #endif /* CONFIG_FUNCTION_TRACER */
 
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+static int irqsoff_set_flag(u32 old_flags, u32 bit, int set)
+{
+	int cpu;
+
+	if (!(bit & TRACE_DISPLAY_GRAPH))
+		return -EINVAL;
+
+	if (!(is_graph() ^ set))
+		return 0;
+
+	stop_irqsoff_tracer(irqsoff_trace, !set);
+
+	for_each_possible_cpu(cpu)
+		per_cpu(tracing_cpu, cpu) = 0;
+
+	tracing_max_latency = 0;
+	tracing_reset_online_cpus(irqsoff_trace);
+
+	return start_irqsoff_tracer(irqsoff_trace, set);
+}
+
+static int irqsoff_graph_entry(struct ftrace_graph_ent *trace)
+{
+	struct trace_array *tr = irqsoff_trace;
+	struct trace_array_cpu *data;
+	unsigned long flags;
+	long disabled;
+	int ret;
+	int cpu;
+	int pc;
+
+	cpu = raw_smp_processor_id();
+	if (likely(!per_cpu(tracing_cpu, cpu)))
+		return 0;
+
+	local_save_flags(flags);
+	/* slight chance to get a false positive on tracing_cpu */
+	if (!irqs_disabled_flags(flags))
+		return 0;
+
+	data = tr->data[cpu];
+	disabled = atomic_inc_return(&data->disabled);
+
+	if (likely(disabled == 1)) {
+		pc = preempt_count();
+		ret = __trace_graph_entry(tr, trace, flags, pc);
+	} else
+		ret = 0;
+
+	atomic_dec(&data->disabled);
+	return ret;
+}
+
+static void irqsoff_graph_return(struct ftrace_graph_ret *trace)
+{
+	struct trace_array *tr = irqsoff_trace;
+	struct trace_array_cpu *data;
+	unsigned long flags;
+	long disabled;
+	int cpu;
+	int pc;
+
+	cpu = raw_smp_processor_id();
+	if (likely(!per_cpu(tracing_cpu, cpu)))
+		return;
+
+	local_save_flags(flags);
+	/* slight chance to get a false positive on tracing_cpu */
+	if (!irqs_disabled_flags(flags))
+		return;
+
+	data = tr->data[cpu];
+	disabled = atomic_inc_return(&data->disabled);
+
+	if (likely(disabled == 1)) {
+		pc = preempt_count();
+		__trace_graph_return(tr, trace, flags, pc);
+	}
+
+	atomic_dec(&data->disabled);
+}
+
+static void irqsoff_trace_open(struct trace_iterator *iter)
+{
+	if (is_graph())
+		graph_trace_open(iter);
+
+}
+
+static void irqsoff_trace_close(struct trace_iterator *iter)
+{
+	if (iter->private)
+		graph_trace_close(iter);
+}
+
+#define GRAPH_TRACER_FLAGS (TRACE_GRAPH_PRINT_CPU | \
+			    TRACE_GRAPH_PRINT_PROC)
+
+static enum print_line_t irqsoff_print_line(struct trace_iterator *iter)
+{
+	u32 flags = GRAPH_TRACER_FLAGS;
+
+	if (trace_flags & TRACE_ITER_LATENCY_FMT)
+		flags |= TRACE_GRAPH_PRINT_DURATION;
+	else
+		flags |= TRACE_GRAPH_PRINT_ABS_TIME;
+
+	/*
+	 * In graph mode call the graph tracer output function,
+	 * otherwise go with the TRACE_FN event handler
+	 */
+	if (is_graph())
+		return print_graph_function_flags(iter, flags);
+
+	return TRACE_TYPE_UNHANDLED;
+}
+
+static void irqsoff_print_header(struct seq_file *s)
+{
+	if (is_graph()) {
+		struct trace_iterator *iter = s->private;
+		u32 flags = GRAPH_TRACER_FLAGS;
+
+		if (trace_flags & TRACE_ITER_LATENCY_FMT) {
+			/* print nothing if the buffers are empty */
+			if (trace_empty(iter))
+				return;
+
+			print_trace_header(s, iter);
+			flags |= TRACE_GRAPH_PRINT_DURATION;
+		} else
+			flags |= TRACE_GRAPH_PRINT_ABS_TIME;
+
+		print_graph_headers_flags(s, flags);
+	} else
+		trace_default_header(s);
+}
+
+static void
+trace_graph_function(struct trace_array *tr,
+		 unsigned long ip, unsigned long flags, int pc)
+{
+	u64 time = trace_clock_local();
+	struct ftrace_graph_ent ent = {
+		.func  = ip,
+		.depth = 0,
+	};
+	struct ftrace_graph_ret ret = {
+		.func     = ip,
+		.depth    = 0,
+		.calltime = time,
+		.rettime  = time,
+	};
+
+	__trace_graph_entry(tr, &ent, flags, pc);
+	__trace_graph_return(tr, &ret, flags, pc);
+}
+
+static void
+__trace_function(struct trace_array *tr,
+		 unsigned long ip, unsigned long parent_ip,
+		 unsigned long flags, int pc)
+{
+	if (!is_graph())
+		trace_function(tr, ip, parent_ip, flags, pc);
+	else {
+		trace_graph_function(tr, parent_ip, flags, pc);
+		trace_graph_function(tr, ip, flags, pc);
+	}
+}
+
+#else
+#define __trace_function trace_function
+
+static int irqsoff_set_flag(u32 old_flags, u32 bit, int set)
+{
+	return -EINVAL;
+}
+
+static int irqsoff_graph_entry(struct ftrace_graph_ent *trace)
+{
+	return -1;
+}
+
+static enum print_line_t irqsoff_print_line(struct trace_iterator *iter)
+{
+	return TRACE_TYPE_UNHANDLED;
+}
+
+static void irqsoff_graph_return(struct ftrace_graph_ret *trace) { }
+static void irqsoff_print_header(struct seq_file *s) { }
+static void irqsoff_trace_open(struct trace_iterator *iter) { }
+static void irqsoff_trace_close(struct trace_iterator *iter) { }
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
 /*
  * Should this new latency be reported/recorded?
  */
@@ -150,7 +366,7 @@ check_critical_timing(struct trace_array *tr,
 	if (!report_latency(delta))
 		goto out_unlock;
 
-	trace_function(tr, CALLER_ADDR0, parent_ip, flags, pc);
+	__trace_function(tr, CALLER_ADDR0, parent_ip, flags, pc);
 	/* Skip 5 functions to get to the irq/preempt enable function */
 	__trace_stack(tr, flags, 5, pc);
 
@@ -172,7 +388,7 @@ out_unlock:
 out:
 	data->critical_sequence = max_sequence;
 	data->preempt_timestamp = ftrace_now(cpu);
-	trace_function(tr, CALLER_ADDR0, parent_ip, flags, pc);
+	__trace_function(tr, CALLER_ADDR0, parent_ip, flags, pc);
 }
 
 static inline void
@@ -204,7 +420,7 @@ start_critical_timing(unsigned long ip, unsigned long parent_ip)
 
 	local_save_flags(flags);
 
-	trace_function(tr, ip, parent_ip, flags, preempt_count());
+	__trace_function(tr, ip, parent_ip, flags, preempt_count());
 
 	per_cpu(tracing_cpu, cpu) = 1;
 
@@ -238,7 +454,7 @@ stop_critical_timing(unsigned long ip, unsigned long parent_ip)
 	atomic_inc(&data->disabled);
 
 	local_save_flags(flags);
-	trace_function(tr, ip, parent_ip, flags, preempt_count());
+	__trace_function(tr, ip, parent_ip, flags, preempt_count());
 	check_critical_timing(tr, data, parent_ip ? : ip, cpu);
 	data->critical_start = 0;
 	atomic_dec(&data->disabled);
@@ -347,19 +563,32 @@ void trace_preempt_off(unsigned long a0, unsigned long a1)
 }
 #endif /* CONFIG_PREEMPT_TRACER */
 
-static void start_irqsoff_tracer(struct trace_array *tr)
+static int start_irqsoff_tracer(struct trace_array *tr, int graph)
 {
-	register_ftrace_function(&trace_ops);
-	if (tracing_is_enabled())
+	int ret = 0;
+
+	if (!graph)
+		ret = register_ftrace_function(&trace_ops);
+	else
+		ret = register_ftrace_graph(&irqsoff_graph_return,
+					    &irqsoff_graph_entry);
+
+	if (!ret && tracing_is_enabled())
 		tracer_enabled = 1;
 	else
 		tracer_enabled = 0;
+
+	return ret;
 }
 
-static void stop_irqsoff_tracer(struct trace_array *tr)
+static void stop_irqsoff_tracer(struct trace_array *tr, int graph)
 {
 	tracer_enabled = 0;
-	unregister_ftrace_function(&trace_ops);
+
+	if (!graph)
+		unregister_ftrace_function(&trace_ops);
+	else
+		unregister_ftrace_graph();
 }
 
 static void __irqsoff_tracer_init(struct trace_array *tr)
@@ -372,12 +601,14 @@ static void __irqsoff_tracer_init(struct trace_array *tr)
 	/* make sure that the tracer is visible */
 	smp_wmb();
 	tracing_reset_online_cpus(tr);
-	start_irqsoff_tracer(tr);
+
+	if (start_irqsoff_tracer(tr, is_graph()))
+		printk(KERN_ERR "failed to start irqsoff tracer\n");
 }
 
 static void irqsoff_tracer_reset(struct trace_array *tr)
 {
-	stop_irqsoff_tracer(tr);
+	stop_irqsoff_tracer(tr, is_graph());
 
 	if (!save_lat_flag)
 		trace_flags &= ~TRACE_ITER_LATENCY_FMT;
@@ -409,9 +640,15 @@ static struct tracer irqsoff_tracer __read_mostly =
 	.start		= irqsoff_tracer_start,
 	.stop		= irqsoff_tracer_stop,
 	.print_max	= 1,
+	.print_header   = irqsoff_print_header,
+	.print_line     = irqsoff_print_line,
+	.flags		= &tracer_flags,
+	.set_flag	= irqsoff_set_flag,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_irqsoff,
 #endif
+	.open           = irqsoff_trace_open,
+	.close          = irqsoff_trace_close,
 };
 # define register_irqsoff(trace) register_tracer(&trace)
 #else
@@ -435,9 +672,15 @@ static struct tracer preemptoff_tracer __read_mostly =
 	.start		= irqsoff_tracer_start,
 	.stop		= irqsoff_tracer_stop,
 	.print_max	= 1,
+	.print_header   = irqsoff_print_header,
+	.print_line     = irqsoff_print_line,
+	.flags		= &tracer_flags,
+	.set_flag	= irqsoff_set_flag,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_preemptoff,
 #endif
+	.open		= irqsoff_trace_open,
+	.close		= irqsoff_trace_close,
 };
 # define register_preemptoff(trace) register_tracer(&trace)
 #else
@@ -463,9 +706,15 @@ static struct tracer preemptirqsoff_tracer __read_mostly =
 	.start		= irqsoff_tracer_start,
 	.stop		= irqsoff_tracer_stop,
 	.print_max	= 1,
+	.print_header   = irqsoff_print_header,
+	.print_line     = irqsoff_print_line,
+	.flags		= &tracer_flags,
+	.set_flag	= irqsoff_set_flag,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_preemptirqsoff,
 #endif
+	.open		= irqsoff_trace_open,
+	.close		= irqsoff_trace_close,
 };
 
 # define register_preemptirqsoff(trace) register_tracer(&trace)
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 8e46b33..2404c12 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -253,7 +253,7 @@ void *trace_seq_reserve(struct trace_seq *s, size_t len)
 	void *ret;
 
 	if (s->full)
-		return 0;
+		return NULL;
 
 	if (len > ((PAGE_SIZE - 1) - s->len)) {
 		s->full = 1;
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 81003b4..6a9d36d 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -30,7 +30,7 @@ static int trace_test_buffer_cpu(struct trace_array *tr, int cpu)
 	struct trace_entry *entry;
 	unsigned int loops = 0;
 
-	while ((event = ring_buffer_consume(tr->buffer, cpu, NULL))) {
+	while ((event = ring_buffer_consume(tr->buffer, cpu, NULL, NULL))) {
 		entry = ring_buffer_event_data(event);
 
 		/*
@@ -256,7 +256,8 @@ trace_selftest_startup_function(struct tracer *trace, struct trace_array *tr)
 /* Maximum number of functions to trace before diagnosing a hang */
 #define GRAPH_MAX_FUNC_TEST	100000000
 
-static void __ftrace_dump(bool disable_tracing);
+static void
+__ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode);
 static unsigned int graph_hang_thresh;
 
 /* Wrap the real function entry probe to avoid possible hanging */
@@ -267,7 +268,7 @@ static int trace_graph_entry_watchdog(struct ftrace_graph_ent *trace)
 		ftrace_graph_stop();
 		printk(KERN_WARNING "BUG: Function graph tracer hang!\n");
 		if (ftrace_dump_on_oops)
-			__ftrace_dump(false);
+			__ftrace_dump(false, DUMP_ALL);
 		return 0;
 	}
 
