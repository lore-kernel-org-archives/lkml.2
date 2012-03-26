Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933284Ab2CZSjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:39:37 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:62501 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933015Ab2CZSjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:39:33 -0400
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Cc: David Sharp <dhsharp@google.com>, Justin Teravest <teravest@google.com>,
        Laurent Chavey <chavey@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Michael Davidson <md@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 6/6] trace: get rid of the enabled_*_syscalls bitmaps
Date: Mon, 26 Mar 2012 11:39:28 -0700
Message-Id: <1332787168-20457-7-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332787168-20457-1-git-send-email-vnagarnaik@google.com>
References: <1332787168-20457-1-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Davidson <md@google.com>

Get rid of the enabled_*_syscalls bitmaps.

Since there is a separate event for each possible system call entry
and exit the bitmaps are unnecessary because the information that
we need already exists in the ftrace_event_call struct.

The "enabled" field indicates that the event is enabled for regular
system call tracing and a "perf_refcount" value greater than zero
indicates that the perf_event is enabled.

The motivation for this change is to avoid the need to create yet
another set of bitmaps for 32 bit system call numbers when support
for tracing those system calls is added.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 kernel/trace/trace_syscalls.c |   96 ++++++++++------------------------------
 1 files changed, 24 insertions(+), 72 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index b757eba..f3fcd13 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -16,8 +16,6 @@
 static DEFINE_MUTEX(syscall_trace_lock);
 static int sys_refcount_enter;
 static int sys_refcount_exit;
-static DECLARE_BITMAP(enabled_enter_syscalls, NR_syscalls);
-static DECLARE_BITMAP(enabled_exit_syscalls, NR_syscalls);
 
 static int syscall_enter_register(struct ftrace_event_call *event,
 				 enum trace_reg type);
@@ -323,13 +321,14 @@ void ftrace_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	syscall_nr = syscall_get_nr(current, regs);
 	if (syscall_nr < 0)
 		return;
-	if (!test_bit(syscall_nr, enabled_enter_syscalls))
-		return;
 
 	sys_data = syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
 		return;
 
+	if (!(sys_data->enter_event->flags & TRACE_EVENT_FL_ENABLED))
+		return;
+
 	size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
 
 	event = trace_current_buffer_lock_reserve(&buffer,
@@ -357,13 +356,14 @@ void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	syscall_nr = syscall_get_nr(current, regs);
 	if (syscall_nr < 0)
 		return;
-	if (!test_bit(syscall_nr, enabled_exit_syscalls))
-		return;
 
 	sys_data = syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
 		return;
 
+	if (!(sys_data->exit_event->flags & TRACE_EVENT_FL_ENABLED))
+		return;
+
 	event = trace_current_buffer_lock_reserve(&buffer,
 			sys_data->exit_event->event.type, sizeof(*entry), 0, 0);
 	if (!event)
@@ -381,32 +381,19 @@ void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 int reg_event_syscall_enter(struct ftrace_event_call *call)
 {
 	int ret = 0;
-	int num;
 
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
-		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
-	if (!sys_refcount_enter)
-		ret = register_trace_sys_enter(ftrace_syscall_enter, NULL);
-	if (!ret) {
-		set_bit(num, enabled_enter_syscalls);
+	if (sys_refcount_enter ||
+	    (ret = register_trace_sys_enter(ftrace_syscall_enter, NULL)) == 0)
 		sys_refcount_enter++;
-	}
 	mutex_unlock(&syscall_trace_lock);
 	return ret;
 }
 
 void unreg_event_syscall_enter(struct ftrace_event_call *call)
 {
-	int num;
-
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
-		return;
 	mutex_lock(&syscall_trace_lock);
 	sys_refcount_enter--;
-	clear_bit(num, enabled_enter_syscalls);
 	if (!sys_refcount_enter)
 		unregister_trace_sys_enter(ftrace_syscall_enter, NULL);
 	mutex_unlock(&syscall_trace_lock);
@@ -415,32 +402,19 @@ void unreg_event_syscall_enter(struct ftrace_event_call *call)
 int reg_event_syscall_exit(struct ftrace_event_call *call)
 {
 	int ret = 0;
-	int num;
 
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
-		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
-	if (!sys_refcount_exit)
-		ret = register_trace_sys_exit(ftrace_syscall_exit, NULL);
-	if (!ret) {
-		set_bit(num, enabled_exit_syscalls);
+	if (sys_refcount_exit ||
+	    (ret = register_trace_sys_exit(ftrace_syscall_exit, NULL)) == 0)
 		sys_refcount_exit++;
-	}
 	mutex_unlock(&syscall_trace_lock);
 	return ret;
 }
 
 void unreg_event_syscall_exit(struct ftrace_event_call *call)
 {
-	int num;
-
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
-		return;
 	mutex_lock(&syscall_trace_lock);
 	sys_refcount_exit--;
-	clear_bit(num, enabled_exit_syscalls);
 	if (!sys_refcount_exit)
 		unregister_trace_sys_exit(ftrace_syscall_exit, NULL);
 	mutex_unlock(&syscall_trace_lock);
@@ -530,8 +504,6 @@ void trace_sys_exit_handler(struct pt_regs *regs, long ret)
 
 #ifdef CONFIG_PERF_EVENTS
 
-static DECLARE_BITMAP(enabled_perf_enter_syscalls, NR_syscalls);
-static DECLARE_BITMAP(enabled_perf_exit_syscalls, NR_syscalls);
 static int sys_perf_refcount_enter;
 static int sys_perf_refcount_exit;
 
@@ -545,13 +517,13 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	int size;
 
 	syscall_nr = syscall_get_nr(current, regs);
-	if (!test_bit(syscall_nr, enabled_perf_enter_syscalls))
-		return;
-
 	sys_data = syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
 		return;
 
+	if (sys_data->enter_event->perf_refcount < 1)
+		return;
+
 	/* get the size after alignment with the u32 buffer size field */
 	size = sizeof(unsigned long) * sys_data->nb_args + sizeof(*rec);
 	size = ALIGN(size + sizeof(u32), sizeof(u64));
@@ -577,33 +549,23 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 int perf_sysenter_enable(struct ftrace_event_call *call)
 {
 	int ret = 0;
-	int num;
-
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
 
 	mutex_lock(&syscall_trace_lock);
-	if (!sys_perf_refcount_enter)
-		ret = register_trace_sys_enter(perf_syscall_enter, NULL);
+	if (sys_perf_refcount_enter ||
+	    (ret = register_trace_sys_enter(perf_syscall_enter, NULL)) == 0)
+		sys_perf_refcount_enter++;
+	mutex_unlock(&syscall_trace_lock);
 	if (ret) {
 		pr_info("event trace: Could not activate"
 				"syscall entry trace point");
-	} else {
-		set_bit(num, enabled_perf_enter_syscalls);
-		sys_perf_refcount_enter++;
 	}
-	mutex_unlock(&syscall_trace_lock);
 	return ret;
 }
 
 void perf_sysenter_disable(struct ftrace_event_call *call)
 {
-	int num;
-
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-
 	mutex_lock(&syscall_trace_lock);
 	sys_perf_refcount_enter--;
-	clear_bit(num, enabled_perf_enter_syscalls);
 	if (!sys_perf_refcount_enter)
 		unregister_trace_sys_enter(perf_syscall_enter, NULL);
 	mutex_unlock(&syscall_trace_lock);
@@ -619,13 +581,13 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	int size;
 
 	syscall_nr = syscall_get_nr(current, regs);
-	if (!test_bit(syscall_nr, enabled_perf_exit_syscalls))
-		return;
-
 	sys_data = syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
 		return;
 
+	if (sys_data->exit_event->perf_refcount < 1)
+		return;
+
 	/* We can probably do that at build time */
 	size = ALIGN(sizeof(*rec) + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
@@ -653,33 +615,23 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 int perf_sysexit_enable(struct ftrace_event_call *call)
 {
 	int ret = 0;
-	int num;
-
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
 
 	mutex_lock(&syscall_trace_lock);
-	if (!sys_perf_refcount_exit)
-		ret = register_trace_sys_exit(perf_syscall_exit, NULL);
+	if (sys_perf_refcount_exit ||
+	    (ret = register_trace_sys_exit(perf_syscall_exit, NULL)) == 0)
+		sys_perf_refcount_exit++;
+	mutex_unlock(&syscall_trace_lock);
 	if (ret) {
 		pr_info("event trace: Could not activate"
 				"syscall exit trace point");
-	} else {
-		set_bit(num, enabled_perf_exit_syscalls);
-		sys_perf_refcount_exit++;
 	}
-	mutex_unlock(&syscall_trace_lock);
 	return ret;
 }
 
 void perf_sysexit_disable(struct ftrace_event_call *call)
 {
-	int num;
-
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-
 	mutex_lock(&syscall_trace_lock);
 	sys_perf_refcount_exit--;
-	clear_bit(num, enabled_perf_exit_syscalls);
 	if (!sys_perf_refcount_exit)
 		unregister_trace_sys_exit(perf_syscall_exit, NULL);
 	mutex_unlock(&syscall_trace_lock);
-- 
1.7.7.3

