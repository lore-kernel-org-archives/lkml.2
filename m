Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab2KNGu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:50:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43371 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab2KNGuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 01:50:54 -0500
Date: Tue, 13 Nov 2012 22:50:41 -0800
From: tip-bot for Vaibhav Nagarnaik <vnagarnaik@google.com>
Message-ID: <tip-6f86ab9fcaef122abb837819139eadac1a0ca966@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, vnagarnaik@google.com, hpa@zytor.com,
        mingo@kernel.org, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, vnagarnaik@google.com,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1339112785-21806-2-git-send-email-vnagarnaik@google.com>
References: <1339112785-21806-2-git-send-email-vnagarnaik@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Cleanup unnecessary function declarations
Git-Commit-ID: 6f86ab9fcaef122abb837819139eadac1a0ca966
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 22:50:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6f86ab9fcaef122abb837819139eadac1a0ca966
Gitweb:     http://git.kernel.org/tip/6f86ab9fcaef122abb837819139eadac1a0ca966
Author:     Vaibhav Nagarnaik <vnagarnaik@google.com>
AuthorDate: Thu, 7 Jun 2012 16:46:25 -0700
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 31 Oct 2012 16:45:34 -0400

tracing: Cleanup unnecessary function declarations

The functions defined in include/trace/syscalls.h are not used directly
since struct ftrace_event_class was introduced. Remove them from the
header file and rearrange the ftrace_event_class declarations in
trace_syscalls.c.

Link: http://lkml.kernel.org/r/1339112785-21806-2-git-send-email-vnagarnaik@google.com

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/syscall.h       |   21 --------------
 kernel/trace/trace_syscalls.c |   61 +++++++++++++++++++---------------------
 2 files changed, 29 insertions(+), 53 deletions(-)

diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 0c95796..84bc419 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -31,25 +31,4 @@ struct syscall_metadata {
 	struct ftrace_event_call *exit_event;
 };
 
-#ifdef CONFIG_FTRACE_SYSCALLS
-extern unsigned long arch_syscall_addr(int nr);
-extern int init_syscall_trace(struct ftrace_event_call *call);
-
-extern int reg_event_syscall_enter(struct ftrace_event_call *call);
-extern void unreg_event_syscall_enter(struct ftrace_event_call *call);
-extern int reg_event_syscall_exit(struct ftrace_event_call *call);
-extern void unreg_event_syscall_exit(struct ftrace_event_call *call);
-enum print_line_t print_syscall_enter(struct trace_iterator *iter, int flags,
-				      struct trace_event *event);
-enum print_line_t print_syscall_exit(struct trace_iterator *iter, int flags,
-				     struct trace_event *event);
-#endif
-
-#ifdef CONFIG_PERF_EVENTS
-int perf_sysenter_enable(struct ftrace_event_call *call);
-void perf_sysenter_disable(struct ftrace_event_call *call);
-int perf_sysexit_enable(struct ftrace_event_call *call);
-void perf_sysexit_disable(struct ftrace_event_call *call);
-#endif
-
 #endif /* _TRACE_SYSCALL_H */
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 2485a7d..7609dd6 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -21,9 +21,6 @@ static int syscall_enter_register(struct ftrace_event_call *event,
 static int syscall_exit_register(struct ftrace_event_call *event,
 				 enum trace_reg type, void *data);
 
-static int syscall_enter_define_fields(struct ftrace_event_call *call);
-static int syscall_exit_define_fields(struct ftrace_event_call *call);
-
 static struct list_head *
 syscall_get_enter_fields(struct ftrace_event_call *call)
 {
@@ -32,30 +29,6 @@ syscall_get_enter_fields(struct ftrace_event_call *call)
 	return &entry->enter_fields;
 }
 
-struct trace_event_functions enter_syscall_print_funcs = {
-	.trace		= print_syscall_enter,
-};
-
-struct trace_event_functions exit_syscall_print_funcs = {
-	.trace		= print_syscall_exit,
-};
-
-struct ftrace_event_class event_class_syscall_enter = {
-	.system		= "syscalls",
-	.reg		= syscall_enter_register,
-	.define_fields	= syscall_enter_define_fields,
-	.get_fields	= syscall_get_enter_fields,
-	.raw_init	= init_syscall_trace,
-};
-
-struct ftrace_event_class event_class_syscall_exit = {
-	.system		= "syscalls",
-	.reg		= syscall_exit_register,
-	.define_fields	= syscall_exit_define_fields,
-	.fields		= LIST_HEAD_INIT(event_class_syscall_exit.fields),
-	.raw_init	= init_syscall_trace,
-};
-
 extern struct syscall_metadata *__start_syscalls_metadata[];
 extern struct syscall_metadata *__stop_syscalls_metadata[];
 
@@ -432,7 +405,7 @@ void unreg_event_syscall_exit(struct ftrace_event_call *call)
 	mutex_unlock(&syscall_trace_lock);
 }
 
-int init_syscall_trace(struct ftrace_event_call *call)
+static int init_syscall_trace(struct ftrace_event_call *call)
 {
 	int id;
 	int num;
@@ -457,6 +430,30 @@ int init_syscall_trace(struct ftrace_event_call *call)
 	return id;
 }
 
+struct trace_event_functions enter_syscall_print_funcs = {
+	.trace		= print_syscall_enter,
+};
+
+struct trace_event_functions exit_syscall_print_funcs = {
+	.trace		= print_syscall_exit,
+};
+
+struct ftrace_event_class event_class_syscall_enter = {
+	.system		= "syscalls",
+	.reg		= syscall_enter_register,
+	.define_fields	= syscall_enter_define_fields,
+	.get_fields	= syscall_get_enter_fields,
+	.raw_init	= init_syscall_trace,
+};
+
+struct ftrace_event_class event_class_syscall_exit = {
+	.system		= "syscalls",
+	.reg		= syscall_exit_register,
+	.define_fields	= syscall_exit_define_fields,
+	.fields		= LIST_HEAD_INIT(event_class_syscall_exit.fields),
+	.raw_init	= init_syscall_trace,
+};
+
 unsigned long __init __weak arch_syscall_addr(int nr)
 {
 	return (unsigned long)sys_call_table[nr];
@@ -537,7 +534,7 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head, NULL);
 }
 
-int perf_sysenter_enable(struct ftrace_event_call *call)
+static int perf_sysenter_enable(struct ftrace_event_call *call)
 {
 	int ret = 0;
 	int num;
@@ -558,7 +555,7 @@ int perf_sysenter_enable(struct ftrace_event_call *call)
 	return ret;
 }
 
-void perf_sysenter_disable(struct ftrace_event_call *call)
+static void perf_sysenter_disable(struct ftrace_event_call *call)
 {
 	int num;
 
@@ -615,7 +612,7 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head, NULL);
 }
 
-int perf_sysexit_enable(struct ftrace_event_call *call)
+static int perf_sysexit_enable(struct ftrace_event_call *call)
 {
 	int ret = 0;
 	int num;
@@ -636,7 +633,7 @@ int perf_sysexit_enable(struct ftrace_event_call *call)
 	return ret;
 }
 
-void perf_sysexit_disable(struct ftrace_event_call *call)
+static void perf_sysexit_disable(struct ftrace_event_call *call)
 {
 	int num;
 
