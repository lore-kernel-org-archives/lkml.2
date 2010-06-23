Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab0FWKMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:12:40 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:59767 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab0FWKES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:04:18 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Jason Baron <jbaron@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 08/40] tracing: remove syscall bitmaps in preparation for compat support
Date: Wed, 23 Jun 2010 20:02:49 +1000
Message-Id: <1277287401-28571-9-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

In preparation for compat syscall tracing support, let's store the enabled
syscalls, with the struct syscall_metadata itself. That way we don't duplicate
enabled information when the compat table points to an entry in the regular
syscall table. Also, allows us to remove the bitmap data structures completely.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 include/linux/syscalls.h      |    8 +++++++
 include/trace/syscall.h       |    4 +++
 kernel/trace/trace_syscalls.c |   42 +++++++++++++++++++---------------------
 3 files changed, 32 insertions(+), 22 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 86f082b..755d05b 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -163,6 +163,10 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 		.nb_args 	= nb,				\
 		.types		= types_##sname,		\
 		.args		= args_##sname,			\
+		.ftrace_enter	= 0,				\
+		.ftrace_exit	= 0,				\
+		.perf_enter	= 0,				\
+		.perf_exit	= 0,				\
 		.enter_event	= &event_enter_##sname,		\
 		.exit_event	= &event_exit_##sname,		\
 		.enter_fields	= LIST_HEAD_INIT(__syscall_meta_##sname.enter_fields), \
@@ -179,6 +183,10 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 		.name 		= "sys_"#sname,			\
 		.syscall_nr	= -1,	/* Filled in at boot */	\
 		.nb_args 	= 0,				\
+		.ftrace_enter	= 0,				\
+		.ftrace_exit	= 0,				\
+		.perf_enter	= 0,				\
+		.perf_exit	= 0,				\
 		.enter_event	= &event_enter__##sname,	\
 		.exit_event	= &event_exit__##sname,		\
 		.enter_fields	= LIST_HEAD_INIT(__syscall_meta__##sname.enter_fields), \
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 257e089..75f3dce 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -27,6 +27,10 @@ struct syscall_metadata {
 	const char	**args;
 	struct list_head enter_fields;
 	struct list_head exit_fields;
+	char		ftrace_enter;
+	char		ftrace_exit;
+	char		perf_enter;
+	char		perf_exit;
 
 	struct ftrace_event_call *enter_event;
 	struct ftrace_event_call *exit_event;
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 18f27bb..f5ddb9c 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -12,8 +12,6 @@
 static DEFINE_MUTEX(syscall_trace_lock);
 static int sys_refcount_enter;
 static int sys_refcount_exit;
-static DECLARE_BITMAP(enabled_enter_syscalls, NR_syscalls);
-static DECLARE_BITMAP(enabled_exit_syscalls, NR_syscalls);
 
 static int syscall_enter_register(struct ftrace_event_call *event,
 				 enum trace_reg type);
@@ -299,13 +297,14 @@ void ftrace_syscall_enter(void *ignore, struct pt_regs *regs, long id)
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
@@ -333,13 +332,14 @@ void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
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
 			sys_data->exit_event->event.type, sizeof(*entry), 0, 0);
 	if (!event)
@@ -366,7 +366,7 @@ int reg_event_syscall_enter(struct ftrace_event_call *call)
 	if (!sys_refcount_enter)
 		ret = register_trace_sys_enter(ftrace_syscall_enter, NULL);
 	if (!ret) {
-		set_bit(num, enabled_enter_syscalls);
+		((struct syscall_metadata *)call->data)->ftrace_enter = 1;
 		sys_refcount_enter++;
 	}
 	mutex_unlock(&syscall_trace_lock);
@@ -382,7 +382,7 @@ void unreg_event_syscall_enter(struct ftrace_event_call *call)
 		return;
 	mutex_lock(&syscall_trace_lock);
 	sys_refcount_enter--;
-	clear_bit(num, enabled_enter_syscalls);
+	((struct syscall_metadata *)call->data)->ftrace_enter = 0;
 	if (!sys_refcount_enter)
 		unregister_trace_sys_enter(ftrace_syscall_enter, NULL);
 	mutex_unlock(&syscall_trace_lock);
@@ -400,7 +400,7 @@ int reg_event_syscall_exit(struct ftrace_event_call *call)
 	if (!sys_refcount_exit)
 		ret = register_trace_sys_exit(ftrace_syscall_exit, NULL);
 	if (!ret) {
-		set_bit(num, enabled_exit_syscalls);
+		((struct syscall_metadata *)call->data)->ftrace_exit = 1;
 		sys_refcount_exit++;
 	}
 	mutex_unlock(&syscall_trace_lock);
@@ -416,7 +416,7 @@ void unreg_event_syscall_exit(struct ftrace_event_call *call)
 		return;
 	mutex_lock(&syscall_trace_lock);
 	sys_refcount_exit--;
-	clear_bit(num, enabled_exit_syscalls);
+	((struct syscall_metadata *)call->data)->ftrace_exit = 0;
 	if (!sys_refcount_exit)
 		unregister_trace_sys_exit(ftrace_syscall_exit, NULL);
 	mutex_unlock(&syscall_trace_lock);
@@ -492,8 +492,6 @@ core_initcall(init_ftrace_syscalls);
 
 #ifdef CONFIG_PERF_EVENTS
 
-static DECLARE_BITMAP(enabled_perf_enter_syscalls, NR_syscalls);
-static DECLARE_BITMAP(enabled_perf_exit_syscalls, NR_syscalls);
 static int sys_perf_refcount_enter;
 static int sys_perf_refcount_exit;
 
@@ -507,13 +505,13 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	int size;
 
 	syscall_nr = syscall_get_nr(current, regs);
-	if (!test_bit(syscall_nr, enabled_perf_enter_syscalls))
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
@@ -550,7 +548,7 @@ int perf_sysenter_enable(struct ftrace_event_call *call)
 		pr_info("event trace: Could not activate"
 				"syscall entry trace point");
 	} else {
-		set_bit(num, enabled_perf_enter_syscalls);
+		((struct syscall_metadata *)call->data)->perf_enter = 1;
 		sys_perf_refcount_enter++;
 	}
 	mutex_unlock(&syscall_trace_lock);
@@ -565,7 +563,7 @@ void perf_sysenter_disable(struct ftrace_event_call *call)
 
 	mutex_lock(&syscall_trace_lock);
 	sys_perf_refcount_enter--;
-	clear_bit(num, enabled_perf_enter_syscalls);
+	((struct syscall_metadata *)call->data)->perf_enter = 0;
 	if (!sys_perf_refcount_enter)
 		unregister_trace_sys_enter(perf_syscall_enter, NULL);
 	mutex_unlock(&syscall_trace_lock);
@@ -581,13 +579,13 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	int size;
 
 	syscall_nr = syscall_get_nr(current, regs);
-	if (!test_bit(syscall_nr, enabled_perf_exit_syscalls))
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
@@ -626,7 +624,7 @@ int perf_sysexit_enable(struct ftrace_event_call *call)
 		pr_info("event trace: Could not activate"
 				"syscall exit trace point");
 	} else {
-		set_bit(num, enabled_perf_exit_syscalls);
+		((struct syscall_metadata *)call->data)->perf_exit = 1;
 		sys_perf_refcount_exit++;
 	}
 	mutex_unlock(&syscall_trace_lock);
@@ -641,7 +639,7 @@ void perf_sysexit_disable(struct ftrace_event_call *call)
 
 	mutex_lock(&syscall_trace_lock);
 	sys_perf_refcount_exit--;
-	clear_bit(num, enabled_perf_exit_syscalls);
+	((struct syscall_metadata *)call->data)->perf_exit = 0;
 	if (!sys_perf_refcount_exit)
 		unregister_trace_sys_exit(perf_syscall_exit, NULL);
 	mutex_unlock(&syscall_trace_lock);
-- 
1.7.1

