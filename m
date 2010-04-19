Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab0DSTtO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 15:49:14 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:48150 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab0DSTtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 15:49:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=lnurk7zcg7UzqjenNhFTKnd2Ahc8qUTaN82qLsN/SdYLzTM8umEXD6jKWCWOva36je
         OyRIf32yn14NE1UsVwxqp/FkoAL4PkRU6kTnKGDtRjZPC8cXq67slH0BIQMxLifb70K+
         Oj+q78kZxKcSZk+BzGRmPazKtF4ygrGVHq4dA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "David S . Miller" <davem@davemloft.net>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [GIT PULL] tracing update
Date: Mon, 19 Apr 2010 21:41:54 +0200
Message-Id: <1271706114-8489-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the tracing/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/core

Thanks,
	Frederic
---

Frederic Weisbecker (1):
      tracing: Dump either the oops's cpu source or all cpus buffers


 Documentation/kernel-parameters.txt |    6 +++-
 Documentation/trace/ftrace.txt      |    6 +++-
 drivers/char/sysrq.c                |    2 +-
 include/linux/ftrace.h              |    4 ++-
 include/linux/kernel.h              |   11 ++++++-
 kernel/trace/trace.c                |   51 ++++++++++++++++++++++++++--------
 6 files changed, 61 insertions(+), 19 deletions(-)

---
commit c7e6b2a29dd63d44c43c1dabe0a14ee4aef967cf
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Sun Apr 18 19:08:41 2010 +0200

    tracing: Dump either the oops's cpu source or all cpus buffers
    
    The ftrace_dump_on_oops kernel parameter, sysctl and sysrq let one
    dump every cpu buffers when an oops or panic happens.
    
    It's nice when you have few cpus but it may take ages if have many,
    plus you miss the real origin of the problem in all the cpu traces.
    
    Sometimes, all you need is to dump the cpu buffer that triggered the
    opps, most of the time it is our main interest.
    
    This patch modifies ftrace_dump_on_oops to handle this choice.
    
    The ftrace_dump_on_oops kernel parameter, when it comes alone, has
    the same behaviour than before. But ftrace_dump_on_oops=orig_cpu
    will only dump the buffer of the cpu that oops'ed.
    
    Similarly, sysctl kernel.ftrace_dump_on_oops=1 and
    echo 1 > /proc/sys/kernel/ftrace_dump_on_oops keep their previous
    behaviour. But setting 2 jumps into cpu origin dump mode.
    
    v2: Fix double setup
    v3: Fix spelling issues reported by Randy Dunlap
    
    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
    Acked-by: David S. Miller <davem@davemloft.net>
    Acked-by: Steven Rostedt <rostedt@goodmis.org>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Cc: Li Zefan <lizf@cn.fujitsu.com>
    Cc: Lai Jiangshan <laijs@cn.fujitsu.com>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e4cbca5..ab67b33 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -789,8 +789,12 @@ and is between 256 and 4096 characters. It is defined in the file
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
diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 03485bf..5201181 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -1337,12 +1337,14 @@ ftrace_dump_on_oops must be set. To set ftrace_dump_on_oops, one
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
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 01e6ade..ea5b1aa 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -492,7 +492,9 @@ static inline int test_tsk_trace_graph(struct task_struct *tsk)
 	return tsk->trace & TSK_TRACE_FL_GRAPH;
 }
 
-extern int ftrace_dump_on_oops;
+enum ftrace_dump_mode;
+
+extern enum ftrace_dump_mode ftrace_dump_on_oops;
 
 #ifdef CONFIG_PREEMPT
 #define INIT_TRACE_RECURSION		.trace_recursion = 0,
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
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index bed83ca..7b516c7 100644
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
 
@@ -4338,7 +4350,7 @@ static int trace_panic_handler(struct notifier_block *this,
 			       unsigned long event, void *unused)
 {
 	if (ftrace_dump_on_oops)
-		ftrace_dump();
+		ftrace_dump(ftrace_dump_on_oops);
 	return NOTIFY_OK;
 }
 
@@ -4355,7 +4367,7 @@ static int trace_die_handler(struct notifier_block *self,
 	switch (val) {
 	case DIE_OOPS:
 		if (ftrace_dump_on_oops)
-			ftrace_dump();
+			ftrace_dump(ftrace_dump_on_oops);
 		break;
 	default:
 		break;
@@ -4396,7 +4408,8 @@ trace_printk_seq(struct trace_seq *s)
 	trace_seq_init(s);
 }
 
-static void __ftrace_dump(bool disable_tracing)
+static void
+__ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
 {
 	static arch_spinlock_t ftrace_dump_lock =
 		(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
@@ -4429,12 +4442,25 @@ static void __ftrace_dump(bool disable_tracing)
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
@@ -4473,6 +4499,7 @@ static void __ftrace_dump(bool disable_tracing)
 	else
 		printk(KERN_TRACE "---------------------------------\n");
 
+ out_enable:
 	/* Re-enable tracing if requested */
 	if (!disable_tracing) {
 		trace_flags |= old_userobj;
@@ -4489,9 +4516,9 @@ static void __ftrace_dump(bool disable_tracing)
 }
 
 /* By default: disable tracing after the dump */
-void ftrace_dump(void)
+void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
 {
-	__ftrace_dump(true);
+	__ftrace_dump(true, oops_dump_mode);
 }
 
 __init static int tracer_alloc_buffers(void)
