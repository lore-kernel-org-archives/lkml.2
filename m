Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab1D1DK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 23:10:27 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:57418 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab1D1DK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 23:10:26 -0400
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: kees.cook@canonical.com, eparis@redhat.com, agl@chromium.org,
        mingo@elte.hu, jmorris@namei.org, rostedt@goodmis.org,
        Will Drewry <wad@chromium.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 2/7] tracing: split out syscall_trace_enter construction
Date: Wed, 27 Apr 2011 22:08:46 -0500
Message-Id: <1303960136-14298-1-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf appears to be the primary consumer of the CONFIG_FTRACE_SYSCALLS
infrastructure.  As such, many of the helpers that target perf can be
split into a perf-focused helper and a generic CONFIG_FTRACE_SYSCALLS
consumer interface.

This change splits out syscall_trace_enter construction from
perf_syscall_enter for current into two helpers:
- ftrace_syscall_enter_state
- ftrace_syscall_enter_state_size

And adds another helper for completeness:
- ftrace_syscall_exit_state_size

These helpers allow for shared code between perf ftrace events and
any other consumers of CONFIG_FTRACE_SYSCALLS events.  The proposed
seccomp_filter patches use this code.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 include/trace/syscall.h       |    4 ++
 kernel/trace/trace_syscalls.c |   96 +++++++++++++++++++++++++++++++++++------
 2 files changed, 86 insertions(+), 14 deletions(-)

diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 31966a4..242ae04 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -41,6 +41,10 @@ extern int reg_event_syscall_exit(struct ftrace_event_call *call);
 extern void unreg_event_syscall_exit(struct ftrace_event_call *call);
 extern int
 ftrace_format_syscall(struct ftrace_event_call *call, struct trace_seq *s);
+extern int ftrace_syscall_enter_state(u8 *buf, size_t available,
+				      struct trace_entry **entry);
+extern size_t ftrace_syscall_enter_state_size(int nb_args);
+extern size_t ftrace_syscall_exit_state_size(void);
 enum print_line_t print_syscall_enter(struct trace_iterator *iter, int flags,
 				      struct trace_event *event);
 enum print_line_t print_syscall_exit(struct trace_iterator *iter, int flags,
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index ee7b5a0..f37f120 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -95,7 +95,7 @@ find_syscall_meta(unsigned long syscall)
 	return NULL;
 }
 
-static struct syscall_metadata *syscall_nr_to_meta(int nr)
+struct syscall_metadata *syscall_nr_to_meta(int nr)
 {
 	if (!syscalls_metadata || nr >= NR_syscalls || nr < 0)
 		return NULL;
@@ -498,7 +498,7 @@ static int sys_perf_refcount_exit;
 static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 {
 	struct syscall_metadata *sys_data;
-	struct syscall_trace_enter *rec;
+	void *buf;
 	struct hlist_head *head;
 	int syscall_nr;
 	int rctx;
@@ -513,25 +513,22 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 		return;
 
 	/* get the size after alignment with the u32 buffer size field */
-	size = sizeof(unsigned long) * sys_data->nb_args + sizeof(*rec);
-	size = ALIGN(size + sizeof(u32), sizeof(u64));
-	size -= sizeof(u32);
+	size = ftrace_syscall_enter_state_size(sys_data->nb_args);
 
 	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
 		      "perf buffer not large enough"))
 		return;
 
-	rec = (struct syscall_trace_enter *)perf_trace_buf_prepare(size,
-				sys_data->enter_event->event.type, regs, &rctx);
-	if (!rec)
+	buf = perf_trace_buf_prepare(size, sys_data->enter_event->event.type,
+				     regs, &rctx);
+	if (!buf)
 		return;
 
-	rec->nr = syscall_nr;
-	syscall_get_arguments(current, regs, 0, sys_data->nb_args,
-			       (unsigned long *)&rec->args);
+	/* The only error conditions in this helper are handled above. */
+	ftrace_syscall_enter_state(buf, size, NULL);
 
 	head = this_cpu_ptr(sys_data->enter_event->perf_events);
-	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head);
+	perf_trace_buf_submit(buf, size, rctx, 0, 1, regs, head);
 }
 
 int perf_sysenter_enable(struct ftrace_event_call *call)
@@ -587,8 +584,7 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 		return;
 
 	/* We can probably do that at build time */
-	size = ALIGN(sizeof(*rec) + sizeof(u32), sizeof(u64));
-	size -= sizeof(u32);
+	size = ftrace_syscall_exit_state_size();
 
 	/*
 	 * Impossible, but be paranoid with the future
@@ -688,3 +684,75 @@ static int syscall_exit_register(struct ftrace_event_call *event,
 	}
 	return 0;
 }
+
+/* ftrace_syscall_enter_state_size - returns the state size required.
+ *
+ * @nb_args: number of system call args expected.
+ *           a negative value implies the maximum allowed.
+ */
+size_t ftrace_syscall_enter_state_size(int nb_args)
+{
+	/* syscall_get_arguments only supports up to 6 arguments. */
+	int arg_count = (nb_args >= 0 ? nb_args : 6);
+	size_t size = (sizeof(unsigned long) * arg_count) +
+		      sizeof(struct syscall_trace_enter);
+	size = ALIGN(size + sizeof(u32), sizeof(u64));
+	size -= sizeof(u32);
+	return size;
+}
+EXPORT_SYMBOL_GPL(ftrace_syscall_enter_state_size);
+
+size_t ftrace_syscall_exit_state_size(void)
+{
+	return ALIGN(sizeof(struct syscall_trace_exit) + sizeof(u32),
+		     sizeof(u64)) - sizeof(u32);
+}
+EXPORT_SYMBOL_GPL(ftrace_syscall_exit_state_size);
+
+/* ftrace_syscall_enter_state - build state for filter matching
+ *
+ * @buf: buffer to populate with current task state for matching
+ * @available: size available for use in the buffer.
+ * @entry: optional pointer to the trace_entry member of the state.
+ *
+ * Returns 0 on success and non-zero otherwise.
+ * If @entry is NULL, it will be ignored.
+ */
+int ftrace_syscall_enter_state(u8 *buf, size_t available,
+			       struct trace_entry **entry)
+{
+	struct syscall_trace_enter *sys_enter;
+	struct syscall_metadata *sys_data;
+	int size;
+	int syscall_nr;
+	struct pt_regs *regs = task_pt_regs(current);
+
+	syscall_nr = syscall_get_nr(current, regs);
+	if (syscall_nr < 0)
+		return -EINVAL;
+
+	sys_data = syscall_nr_to_meta(syscall_nr);
+	if (!sys_data)
+		return -EINVAL;
+
+	/* Determine the actual size needed. */
+	size = sizeof(unsigned long) * sys_data->nb_args +
+	       sizeof(struct syscall_trace_enter);
+	size = ALIGN(size + sizeof(u32), sizeof(u64));
+	size -= sizeof(u32);
+
+	BUG_ON(size > available);
+	sys_enter = (struct syscall_trace_enter *)buf;
+
+	/* Populating the struct trace_sys_enter is left to the caller, but
+	 * a pointer is returned to encourage opacity.
+	 */
+	if (entry)
+		*entry = &sys_enter->ent;
+
+	sys_enter->nr = syscall_nr;
+	syscall_get_arguments(current, regs, 0, sys_data->nb_args,
+			      sys_enter->args);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ftrace_syscall_enter_state);
-- 
1.7.0.4

