Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938191Ab0CPRsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:48:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938085Ab0CPRrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:47:02 -0400
Date: Tue, 16 Mar 2010 13:46:26 -0400
From: Jason Baron <jbaron@redhat.com>
To: fweisbec@gmail.com, mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       hpa@zytor.com, tglx@linutronix.de, mhiramat@redhat.com,
       heiko.carstens@de.ibm.com, benh@kernel.crashing.org,
       davem@davemloft.net, lethal@linux-sh.org, schwidefsky@de.ibm.com,
       brueckner@linux.vnet.ibm.com, tony.luck@intel.com
Message-Id: <3678fa7f02e57d93e851a49305e772e84a80a967.1268749695.git.jbaron@redhat.com>
In-Reply-To: <cover.1268749695.git.jbaron@redhat.com>
References: <cover.1268749695.git.jbaron@redhat.com>
Subject: [PATCH 04/14] tracing: remove syscall bitmaps in preparation for compat support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for compat syscall tracing support, let's store the enabled
syscalls, with the struct syscall_metadata itself. That way we don't duplicate
enabled information when the compat table points to an entry in the regular
syscall table. Also, allows us to remove the bitmap data structures completely.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/syscalls.h      |    8 +++++++
 include/trace/syscall.h       |    4 +++
 kernel/trace/trace_syscalls.c |   42 +++++++++++++++++++---------------------
 3 files changed, 32 insertions(+), 22 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 8126f23..e601985 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -185,6 +185,10 @@ struct perf_event_attr;
 		.nb_args 	= nb,				\
 		.types		= types_##sname,		\
 		.args		= args_##sname,			\
+		.ftrace_enter	= 0,				\
+		.ftrace_exit	= 0,				\
+		.perf_enter	= 0,				\
+		.perf_exit	= 0,				\
 		.enter_event	= &event_enter_##sname,		\
 		.exit_event	= &event_exit_##sname,		\
 	};
@@ -198,6 +202,10 @@ struct perf_event_attr;
 	  __syscall_meta__##sname = {				\
 		.name 		= "sys_"#sname,			\
 		.nb_args 	= 0,				\
+		.ftrace_enter	= 0,				\
+		.ftrace_exit	= 0,				\
+		.perf_enter	= 0,				\
+		.perf_exit	= 0,				\
 		.enter_event	= &event_enter__##sname,	\
 		.exit_event	= &event_exit__##sname,		\
 	};							\
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 0387100..8f5ac38 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -25,6 +25,10 @@ struct syscall_metadata {
 	int		nb_args;
 	const char	**types;
 	const char	**args;
+	char		ftrace_enter;
+	char		ftrace_exit;
+	char		perf_enter;
+	char		perf_exit;
 
 	struct ftrace_event_call *enter_event;
 	struct ftrace_event_call *exit_event;
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index cba47d7..9cb814b 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -11,8 +11,6 @@
 static DEFINE_MUTEX(syscall_trace_lock);
 static int sys_refcount_enter;
 static int sys_refcount_exit;
-static DECLARE_BITMAP(enabled_enter_syscalls, NR_syscalls);
-static DECLARE_BITMAP(enabled_exit_syscalls, NR_syscalls);
 
 extern unsigned long __start_syscalls_metadata[];
 extern unsigned long __stop_syscalls_metadata[];
@@ -254,13 +252,14 @@ void ftrace_syscall_enter(struct pt_regs *regs, long id)
 	syscall_nr = syscall_get_nr(current, regs);
 	if (syscall_nr < 0)
 		return;
-	if (!test_bit(syscall_nr, enabled_enter_syscalls))
-		return;
 
 	sys_data = syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
 		return;
 
+	if (!sys_data->ftrace_enter)
+		return;
+
 	size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
 
 	event = trace_current_buffer_lock_reserve(&buffer,
@@ -288,13 +287,14 @@ void ftrace_syscall_exit(struct pt_regs *regs, long ret)
 	syscall_nr = syscall_get_nr(current, regs);
 	if (syscall_nr < 0)
 		return;
-	if (!test_bit(syscall_nr, enabled_exit_syscalls))
-		return;
 
 	sys_data = syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
 		return;
 
+	if (!sys_data->ftrace_exit)
+		return;
+
 	event = trace_current_buffer_lock_reserve(&buffer,
 			sys_data->exit_event->id, sizeof(*entry), 0, 0);
 	if (!event)
@@ -321,7 +321,7 @@ int reg_event_syscall_enter(struct ftrace_event_call *call)
 	if (!sys_refcount_enter)
 		ret = register_trace_sys_enter(ftrace_syscall_enter);
 	if (!ret) {
-		set_bit(num, enabled_enter_syscalls);
+		((struct syscall_metadata *)call->data)->ftrace_enter = 1;
 		sys_refcount_enter++;
 	}
 	mutex_unlock(&syscall_trace_lock);
@@ -337,7 +337,7 @@ void unreg_event_syscall_enter(struct ftrace_event_call *call)
 		return;
 	mutex_lock(&syscall_trace_lock);
 	sys_refcount_enter--;
-	clear_bit(num, enabled_enter_syscalls);
+	((struct syscall_metadata *)call->data)->ftrace_enter = 0;
 	if (!sys_refcount_enter)
 		unregister_trace_sys_enter(ftrace_syscall_enter);
 	mutex_unlock(&syscall_trace_lock);
@@ -355,7 +355,7 @@ int reg_event_syscall_exit(struct ftrace_event_call *call)
 	if (!sys_refcount_exit)
 		ret = register_trace_sys_exit(ftrace_syscall_exit);
 	if (!ret) {
-		set_bit(num, enabled_exit_syscalls);
+		((struct syscall_metadata *)call->data)->ftrace_exit = 1;
 		sys_refcount_exit++;
 	}
 	mutex_unlock(&syscall_trace_lock);
@@ -371,7 +371,7 @@ void unreg_event_syscall_exit(struct ftrace_event_call *call)
 		return;
 	mutex_lock(&syscall_trace_lock);
 	sys_refcount_exit--;
-	clear_bit(num, enabled_exit_syscalls);
+	((struct syscall_metadata *)call->data)->ftrace_exit = 0;
 	if (!sys_refcount_exit)
 		unregister_trace_sys_exit(ftrace_syscall_exit);
 	mutex_unlock(&syscall_trace_lock);
@@ -428,8 +428,6 @@ core_initcall(init_ftrace_syscalls);
 
 #ifdef CONFIG_PERF_EVENTS
 
-static DECLARE_BITMAP(enabled_prof_enter_syscalls, NR_syscalls);
-static DECLARE_BITMAP(enabled_prof_exit_syscalls, NR_syscalls);
 static int sys_prof_refcount_enter;
 static int sys_prof_refcount_exit;
 
@@ -443,13 +441,13 @@ static void prof_syscall_enter(struct pt_regs *regs, long id)
 	int size;
 
 	syscall_nr = syscall_get_nr(current, regs);
-	if (!test_bit(syscall_nr, enabled_prof_enter_syscalls))
-		return;
-
 	sys_data = syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
 		return;
 
+	if (!sys_data->perf_enter)
+		return;
+
 	/* get the size after alignment with the u32 buffer size field */
 	size = sizeof(unsigned long) * sys_data->nb_args + sizeof(*rec);
 	size = ALIGN(size + sizeof(u32), sizeof(u64));
@@ -484,7 +482,7 @@ int prof_sysenter_enable(struct ftrace_event_call *call)
 		pr_info("event trace: Could not activate"
 				"syscall entry trace point");
 	} else {
-		set_bit(num, enabled_prof_enter_syscalls);
+		((struct syscall_metadata *)call->data)->perf_enter = 1;
 		sys_prof_refcount_enter++;
 	}
 	mutex_unlock(&syscall_trace_lock);
@@ -499,7 +497,7 @@ void prof_sysenter_disable(struct ftrace_event_call *call)
 
 	mutex_lock(&syscall_trace_lock);
 	sys_prof_refcount_enter--;
-	clear_bit(num, enabled_prof_enter_syscalls);
+	((struct syscall_metadata *)call->data)->perf_enter = 0;
 	if (!sys_prof_refcount_enter)
 		unregister_trace_sys_enter(prof_syscall_enter);
 	mutex_unlock(&syscall_trace_lock);
@@ -515,13 +513,13 @@ static void prof_syscall_exit(struct pt_regs *regs, long ret)
 	int size;
 
 	syscall_nr = syscall_get_nr(current, regs);
-	if (!test_bit(syscall_nr, enabled_prof_exit_syscalls))
-		return;
-
 	sys_data = syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
 		return;
 
+	if (!sys_data->perf_exit)
+		return;
+
 	/* We can probably do that at build time */
 	size = ALIGN(sizeof(*rec) + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
@@ -559,7 +557,7 @@ int prof_sysexit_enable(struct ftrace_event_call *call)
 		pr_info("event trace: Could not activate"
 				"syscall exit trace point");
 	} else {
-		set_bit(num, enabled_prof_exit_syscalls);
+		((struct syscall_metadata *)call->data)->perf_exit = 1;
 		sys_prof_refcount_exit++;
 	}
 	mutex_unlock(&syscall_trace_lock);
@@ -574,7 +572,7 @@ void prof_sysexit_disable(struct ftrace_event_call *call)
 
 	mutex_lock(&syscall_trace_lock);
 	sys_prof_refcount_exit--;
-	clear_bit(num, enabled_prof_exit_syscalls);
+	((struct syscall_metadata *)call->data)->perf_exit = 0;
 	if (!sys_prof_refcount_exit)
 		unregister_trace_sys_exit(prof_syscall_exit);
 	mutex_unlock(&syscall_trace_lock);
-- 
1.6.5.1

