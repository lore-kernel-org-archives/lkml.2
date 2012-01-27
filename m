Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab2A0RUZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 12:20:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328Ab2A0RUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 12:20:24 -0500
Date: Fri, 27 Jan 2012 18:20:12 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: Re: [PATCH 2/7] ftrace: Add enable/disable ftrace_ops control
 interface
Message-ID: <20120127172012.GE10601@m.brq.redhat.com>
References: <1325495060-6402-1-git-send-email-jolsa@redhat.com>
 <1326912275-26405-1-git-send-email-jolsa@redhat.com>
 <1326912275-26405-3-git-send-email-jolsa@redhat.com>
 <20120120170232.GF18056@somewhere>
 <1327533221.22710.74.camel@gandalf.stny.rr.com>
 <20120126023726.GI20878@somewhere>
 <20120127103714.GA6294@m.brq.redhat.com>
 <20120127164045.GA3391@somewhere>
 <20120127165416.GD10601@m.brq.redhat.com>
 <20120127170202.GB3391@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120127170202.GB3391@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 06:02:04PM +0100, Frederic Weisbecker wrote:
> On Fri, Jan 27, 2012 at 05:54:16PM +0100, Jiri Olsa wrote:
> > On Fri, Jan 27, 2012 at 05:40:49PM +0100, Frederic Weisbecker wrote:
> > > On Fri, Jan 27, 2012 at 11:37:14AM +0100, Jiri Olsa wrote:
> > > > On Thu, Jan 26, 2012 at 03:37:29AM +0100, Frederic Weisbecker wrote:
> > > > > On Wed, Jan 25, 2012 at 06:13:41PM -0500, Steven Rostedt wrote:
> > > > > > On Fri, 2012-01-20 at 18:02 +0100, Frederic Weisbecker wrote:
> > > > > > >  
> > > > > > > > +/**
> > > > > > > > + * ftrace_function_enable - enable controlled ftrace_ops on given cpu
> > > > > > > > + *
> > > > > > > > + * This function enables tracing on given cpu by decreasing
> > > > > > > > + * the per cpu control variable.
> > > > > > > > + * It must be called with preemption disabled and only on
> > > > > > > > + * ftrace_ops registered with FTRACE_OPS_FL_CONTROL.
> > > > > > > > + */
> > > > > > > > +static inline void ftrace_function_enable(struct ftrace_ops *ops, int cpu)
> > > > > > > > +{
> > > > > > > > +	atomic_t *disabled;
> > > > > > > > +
> > > > > > > > +	if (WARN_ON_ONCE(!(ops->flags & FTRACE_OPS_FL_CONTROL) ||
> > > > > > > > +			 !preempt_count()))
> > > > > > > > +		return;
> > > > > > > > +
> > > > > > > > +	disabled = per_cpu_ptr(ops->disabled, cpu);
> > > > > > > > +	atomic_dec(disabled);
> > > > > > > > +}
> > > > > > > 
> > > > > > > As you're using this for the local CPU exclusively, I suggest you rather
> > > > > > > rename it to "ftrace_function_{dis,en}able_cpu(struct ftrace_ops *ops)"
> > > > > > 
> > > > > > I wonder if "ftrace_function_local_{dis,en}able(ops)" would be better?
> > > > > > That would match something like local_irq_disable/enable.
> > > > > 
> > > > > Good idea.
> > > > > 
> > > > > > 
> > > > > > > and use __get_cpu_var() that does the preempt check for you.
> > > > 
> > > > I haven't found preempt check this_cpu_ptr path.. not sure I missed it..
> > > > so I'm keeping the implicit preemt check.
> > > 
> > > #ifdef CONFIG_DEBUG_PREEMPT
> > > #define my_cpu_offset per_cpu_offset(smp_processor_id())
> > > #else
> > > #define my_cpu_offset __my_cpu_offset
> > > #endif
> > > 
> > > #ifdef CONFIG_DEBUG_PREEMPT
> > > #define this_cpu_ptr(ptr) SHIFT_PERCPU_PTR(ptr, my_cpu_offset)
> > > #else
> > > #define this_cpu_ptr(ptr) __this_cpu_ptr(ptr)
> > > #endif
> > > 
> > > And smp_processor_id() has a preemption check.
> > 
> > yay.. ok :) so this one is triggered only if there's CONFIG_DEBUG_PREEMPT
> > option enabled.. seems to me it'd better to keep the implicit check anyway.
> > 
> > jirka
> 
> 
> This is a debugging option deemed to lower runtime debugging checks in
> production.
> 
> Is there a good reason to keep the check on every case?

none I guess, apart from me feeling better.. ;)
attached new version without the preemt_count check int the WARN_ON_ONCE

thanks,
jirka


---
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index f33fb3b..d95df4b 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -31,16 +31,32 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 
 typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip);
 
+/*
+ * FTRACE_OPS_FL_* bits denote the state of ftrace_ops struct and are
+ * set in the flags member.
+ *
+ * ENABLED - set/unset when ftrace_ops is registered/unregistered
+ * GLOBAL  - set manualy by ftrace_ops user to denote the ftrace_ops
+ *           is part of the global tracers sharing the same filter
+ *           via set_ftrace_* debugfs files.
+ * DYNAMIC - set when ftrace_ops is registered to denote dynamically
+ *           allocated ftrace_ops which need special care
+ * CONTROL - set manualy by ftrace_ops user to denote the ftrace_ops
+ *           could be controled by following calls:
+ *           ftrace_function_enable, ftrace_function_disable
+ */
 enum {
 	FTRACE_OPS_FL_ENABLED		= 1 << 0,
 	FTRACE_OPS_FL_GLOBAL		= 1 << 1,
 	FTRACE_OPS_FL_DYNAMIC		= 1 << 2,
+	FTRACE_OPS_FL_CONTROL		= 1 << 3,
 };
 
 struct ftrace_ops {
 	ftrace_func_t			func;
 	struct ftrace_ops		*next;
 	unsigned long			flags;
+	int __percpu			*disabled;
 #ifdef CONFIG_DYNAMIC_FTRACE
 	struct ftrace_hash		*notrace_hash;
 	struct ftrace_hash		*filter_hash;
@@ -97,6 +113,52 @@ int register_ftrace_function(struct ftrace_ops *ops);
 int unregister_ftrace_function(struct ftrace_ops *ops);
 void clear_ftrace_function(void);
 
+/**
+ * ftrace_function_local_enable - enable controlled ftrace_ops on current cpu
+ *
+ * This function enables tracing on current cpu by decreasing
+ * the per cpu control variable.
+ * It must be called with preemption disabled and only on
+ * ftrace_ops registered with FTRACE_OPS_FL_CONTROL.
+ */
+static inline void ftrace_function_local_enable(struct ftrace_ops *ops)
+{
+	if (WARN_ON_ONCE(!(ops->flags & FTRACE_OPS_FL_CONTROL)))
+		return;
+
+	(*this_cpu_ptr(ops->disabled))--;
+}
+
+/**
+ * ftrace_function_local_disable - enable controlled ftrace_ops on current cpu
+ *
+ * This function enables tracing on current cpu by decreasing
+ * the per cpu control variable.
+ * It must be called with preemption disabled and only on
+ * ftrace_ops registered with FTRACE_OPS_FL_CONTROL.
+ */
+static inline void ftrace_function_local_disable(struct ftrace_ops *ops)
+{
+	if (WARN_ON_ONCE(!(ops->flags & FTRACE_OPS_FL_CONTROL)))
+		return;
+
+	(*this_cpu_ptr(ops->disabled))++;
+}
+
+/**
+ * ftrace_function_local_disabled - returns ftrace_ops disabled value
+ *                                  on current cpu
+ *
+ * This function returns value of ftrace_ops::disabled on current cpu.
+ * It must be called with preemption disabled and only on
+ * ftrace_ops registered with FTRACE_OPS_FL_CONTROL.
+ */
+static inline int ftrace_function_local_disabled(struct ftrace_ops *ops)
+{
+	WARN_ON_ONCE(!(ops->flags & FTRACE_OPS_FL_CONTROL));
+	return *this_cpu_ptr(ops->disabled);
+}
+
 extern void ftrace_stub(unsigned long a0, unsigned long a1);
 
 #else /* !CONFIG_FUNCTION_TRACER */
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index e2e0597..c8d2af2 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -62,6 +62,8 @@
 #define FTRACE_HASH_DEFAULT_BITS 10
 #define FTRACE_HASH_MAX_BITS 12
 
+#define FL_GLOBAL_CONTROL_MASK (FTRACE_OPS_FL_GLOBAL | FTRACE_OPS_FL_CONTROL)
+
 /* ftrace_enabled is a method to turn ftrace on or off */
 int ftrace_enabled __read_mostly;
 static int last_ftrace_enabled;
@@ -89,12 +91,14 @@ static struct ftrace_ops ftrace_list_end __read_mostly = {
 };
 
 static struct ftrace_ops *ftrace_global_list __read_mostly = &ftrace_list_end;
+static struct ftrace_ops *ftrace_control_list __read_mostly = &ftrace_list_end;
 static struct ftrace_ops *ftrace_ops_list __read_mostly = &ftrace_list_end;
 ftrace_func_t ftrace_trace_function __read_mostly = ftrace_stub;
 static ftrace_func_t __ftrace_trace_function_delay __read_mostly = ftrace_stub;
 ftrace_func_t __ftrace_trace_function __read_mostly = ftrace_stub;
 ftrace_func_t ftrace_pid_function __read_mostly = ftrace_stub;
 static struct ftrace_ops global_ops;
+static struct ftrace_ops control_ops;
 
 static void
 ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip);
@@ -168,6 +172,32 @@ static void ftrace_test_stop_func(unsigned long ip, unsigned long parent_ip)
 }
 #endif
 
+static void control_ops_disable_all(struct ftrace_ops *ops)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		*per_cpu_ptr(ops->disabled, cpu) = 1;
+}
+
+static int control_ops_alloc(struct ftrace_ops *ops)
+{
+	int __percpu *disabled;
+
+	disabled = alloc_percpu(int);
+	if (!disabled)
+		return -ENOMEM;
+
+	ops->disabled = disabled;
+	control_ops_disable_all(ops);
+	return 0;
+}
+
+static void control_ops_free(struct ftrace_ops *ops)
+{
+	free_percpu(ops->disabled);
+}
+
 static void update_global_ops(void)
 {
 	ftrace_func_t func;
@@ -259,6 +289,26 @@ static int remove_ftrace_ops(struct ftrace_ops **list, struct ftrace_ops *ops)
 	return 0;
 }
 
+static void add_ftrace_list_ops(struct ftrace_ops **list,
+				struct ftrace_ops *main_ops,
+				struct ftrace_ops *ops)
+{
+	int first = *list == &ftrace_list_end;
+	add_ftrace_ops(list, ops);
+	if (first)
+		add_ftrace_ops(&ftrace_ops_list, main_ops);
+}
+
+static int remove_ftrace_list_ops(struct ftrace_ops **list,
+				  struct ftrace_ops *main_ops,
+				  struct ftrace_ops *ops)
+{
+	int ret = remove_ftrace_ops(list, ops);
+	if (!ret && *list == &ftrace_list_end)
+		ret = remove_ftrace_ops(&ftrace_ops_list, main_ops);
+	return ret;
+}
+
 static int __register_ftrace_function(struct ftrace_ops *ops)
 {
 	if (ftrace_disabled)
@@ -270,15 +320,20 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
 	if (WARN_ON(ops->flags & FTRACE_OPS_FL_ENABLED))
 		return -EBUSY;
 
+	/* We don't support both control and global flags set. */
+	if ((ops->flags & FL_GLOBAL_CONTROL_MASK) == FL_GLOBAL_CONTROL_MASK)
+		return -EINVAL;
+
 	if (!core_kernel_data((unsigned long)ops))
 		ops->flags |= FTRACE_OPS_FL_DYNAMIC;
 
 	if (ops->flags & FTRACE_OPS_FL_GLOBAL) {
-		int first = ftrace_global_list == &ftrace_list_end;
-		add_ftrace_ops(&ftrace_global_list, ops);
+		add_ftrace_list_ops(&ftrace_global_list, &global_ops, ops);
 		ops->flags |= FTRACE_OPS_FL_ENABLED;
-		if (first)
-			add_ftrace_ops(&ftrace_ops_list, &global_ops);
+	} else if (ops->flags & FTRACE_OPS_FL_CONTROL) {
+		if (control_ops_alloc(ops))
+			return -ENOMEM;
+		add_ftrace_list_ops(&ftrace_control_list, &control_ops, ops);
 	} else
 		add_ftrace_ops(&ftrace_ops_list, ops);
 
@@ -302,11 +357,23 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 		return -EINVAL;
 
 	if (ops->flags & FTRACE_OPS_FL_GLOBAL) {
-		ret = remove_ftrace_ops(&ftrace_global_list, ops);
-		if (!ret && ftrace_global_list == &ftrace_list_end)
-			ret = remove_ftrace_ops(&ftrace_ops_list, &global_ops);
+		ret = remove_ftrace_list_ops(&ftrace_global_list,
+					     &global_ops, ops);
 		if (!ret)
 			ops->flags &= ~FTRACE_OPS_FL_ENABLED;
+	} else if (ops->flags & FTRACE_OPS_FL_CONTROL) {
+		ret = remove_ftrace_list_ops(&ftrace_control_list,
+					     &control_ops, ops);
+		if (!ret) {
+			/*
+			 * The ftrace_ops is now removed from the list,
+			 * so there'll be no new users. We must ensure
+			 * all current users are done before we free
+			 * the control data.
+			 */
+			synchronize_sched();
+			control_ops_free(ops);
+		}
 	} else
 		ret = remove_ftrace_ops(&ftrace_ops_list, ops);
 
@@ -3874,6 +3941,36 @@ ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip)
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 static void
+ftrace_ops_control_func(unsigned long ip, unsigned long parent_ip)
+{
+	struct ftrace_ops *op;
+
+	if (unlikely(trace_recursion_test(TRACE_CONTROL_BIT)))
+		return;
+
+	/*
+	 * Some of the ops may be dynamically allocated,
+	 * they must be freed after a synchronize_sched().
+	 */
+	preempt_disable_notrace();
+	trace_recursion_set(TRACE_CONTROL_BIT);
+	op = rcu_dereference_raw(ftrace_control_list);
+	while (op != &ftrace_list_end) {
+		if (!ftrace_function_local_disabled(op) &&
+		    ftrace_ops_test(op, ip))
+			op->func(ip, parent_ip);
+
+		op = rcu_dereference_raw(op->next);
+	};
+	trace_recursion_clear(TRACE_CONTROL_BIT);
+	preempt_enable_notrace();
+}
+
+static struct ftrace_ops control_ops = {
+	.func = ftrace_ops_control_func,
+};
+
+static void
 ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip)
 {
 	struct ftrace_ops *op;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index b93ecba..55c6ea0 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -288,6 +288,8 @@ struct tracer {
 /* for function tracing recursion */
 #define TRACE_INTERNAL_BIT		(1<<11)
 #define TRACE_GLOBAL_BIT		(1<<12)
+#define TRACE_CONTROL_BIT		(1<<13)
+
 /*
  * Abuse of the trace_recursion.
  * As we need a way to maintain state if we are tracing the function
