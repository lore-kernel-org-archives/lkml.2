Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621Ab2IKPhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 11:37:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:56564 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483Ab2IKPhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 11:37:42 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: srikar@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Roland McGrath <roland@hack.frob.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        gdb-patches@sourceware.org
Subject: [PATCH 2/2] uprobes: add global breakpoints
Date: Tue, 11 Sep 2012 17:37:23 +0200
Message-Id: <1347377843-16017-2-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347377843-16017-1-git-send-email-bigeasy@linutronix.de>
References: <1347377843-16017-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By setting an uprobe tracepoint, one learns whenever a certain point
within a program is reached / passed. This is recorded and the
application continues.
This patch adds the ability to hold the program once this point has been
reached and the user may attach to the program via ptrace.
Setting up a global breakpoint which is very similar to a uprobe trace
point:

|echo 'g /home/bigeasy/uprobetest/sample:0x0000044d %ip %ax %bx' > uprobe_events

This is exactly what uprobe does except that it starts with the letter
'g' instead of 'p'.

uprobe events have to be enabled before they can be used
|echo 1 > events/uprobes/enable

Before a global breakpoint triggers you need to setup a list of pids
which are excluded from a hit. This is done to avoid a system lockup
once a breakpoint is set on something global like libc's malloc()
function. A pid can be excluded by
| echo e $pid > uprobe_gb_exclude

You need atleast one pid in the exlude list. An entry can be removed by
| echo r $pid > uprobe_gb_exclude

A pid is removed from the list once the task terminates.

Lets assume you execute ./sample and the breakpoint is reached. You will
learn about this event by reading the uprobe_gb_active file:

| cat uprobe_gb_active
|1938

Each pid will be written in one line. The application is frozen and you
see this in ps' output:

|1938 pts/1    D+     0:00 ./sample

You can poll() on uprobe_gb_active and you will be woken up once there is
an entry in this file.

To continue the execution of the task you can write "c" followed by
the pid:
| echo c 1938 > uprobe_gb_active

If you plan to attach it with a gdb, you should first start the gdb via
'gdb -p 1938' and then continue in "trace" mode:
| echo t 1938 > uprobe_gb_active

The task is now hold before the opcode is executed that means the first
opcode gdb will display is the breakpoint (0xcc on x86). You can single
step over the breakpoint which will execute the real opcode.
There is a maximum of 64 tasks which can be in the "global breakpoint
hit" state. Once this limit is passed, no further task will be hold.

Cc: gdb-patches@sourceware.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
rfc..v1:
	- removing pids from the exlude list once a task terminates
	- skip_handler has been switched from int to struct uprobe * to 
	  address Oleg's review comment regading the case where we receive
	  a signal while going back to user space within a uprobe and this
	  signal handler also has uprobe event.
	- Oleg didn't like the modification in ptrace to keep the task
	  going once a a user attached to the task via ptrace. The
	  modification to ptrce_attach() is gone, the user must explicit
	  write "[ct] pid" into uprobe_gb_active where c stands for "normal"
	  continue and t is for tracing (i.e. the gdb/strace is waiting).

 include/linux/uprobes.h     |    7 +
 kernel/events/uprobes.c     |   23 ++-
 kernel/trace/trace_uprobe.c |  422 ++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 447 insertions(+), 5 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index e6f0331..4bebfda 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -63,6 +63,9 @@ enum uprobe_task_state {
 	UTASK_SSTEP,
 	UTASK_SSTEP_ACK,
 	UTASK_SSTEP_TRAPPED,
+	UTASK_TRACE_SLEEP,
+	UTASK_TRACE_WOKEUP_NORMAL,
+	UTASK_TRACE_WOKEUP_TRACED,
 };
 
 /*
@@ -76,6 +79,7 @@ struct uprobe_task {
 
 	unsigned long			xol_vaddr;
 	unsigned long			vaddr;
+	struct uprobe			*skip_handler;
 };
 
 /*
@@ -120,6 +124,9 @@ extern void uprobe_notify_resume(struct pt_regs *regs);
 extern bool uprobe_deny_signal(void);
 extern bool __weak arch_uprobe_skip_sstep(struct arch_uprobe *aup, struct pt_regs *regs);
 extern void uprobe_clear_state(struct mm_struct *mm);
+extern int uprobe_gb_allow_pid(pid_t pid);
+extern void uprobe_gb_remove_active(pid_t pid);
+
 #else /* !CONFIG_UPROBES */
 struct uprobes_state {
 };
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index f9f2fb3..c4cc6eb 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1274,11 +1274,15 @@ void uprobe_free_utask(struct task_struct *t)
 {
 	struct uprobe_task *utask = t->utask;
 
+	uprobe_gb_allow_pid(t->pid);
 	if (!utask)
 		return;
 
 	if (utask->active_uprobe)
 		put_uprobe(utask->active_uprobe);
+	if (utask->skip_handler)
+		put_uprobe(utask->skip_handler);
+	uprobe_gb_remove_active(t->pid);
 
 	xol_free_insn_slot(t);
 	kfree(utask);
@@ -1446,7 +1450,21 @@ static void handle_swbp(struct pt_regs *regs)
 			goto cleanup_ret;
 	}
 	utask->active_uprobe = uprobe;
-	handler_chain(uprobe, regs);
+	if (utask->skip_handler == uprobe) {
+		put_uprobe(uprobe);
+		utask->skip_handler = NULL;
+	} else {
+		handler_chain(uprobe, regs);
+	}
+
+	if (utask->state == UTASK_TRACE_WOKEUP_TRACED) {
+		send_sig(SIGTRAP, current, 0);
+		if (utask->skip_handler)
+			put_uprobe(utask->skip_handler);
+		utask->skip_handler = uprobe;
+		atomic_inc(&uprobe->ref);
+		goto cleanup_ret;
+	}
 	if (uprobe->flags & UPROBE_SKIP_SSTEP && can_skip_sstep(uprobe, regs))
 		goto cleanup_ret;
 
@@ -1461,7 +1479,8 @@ cleanup_ret:
 		utask->active_uprobe = NULL;
 		utask->state = UTASK_RUNNING;
 	}
-	if (!(uprobe->flags & UPROBE_SKIP_SSTEP))
+	if (!(uprobe->flags & UPROBE_SKIP_SSTEP) ||
+			utask->skip_handler == uprobe)
 
 		/*
 		 * cannot singlestep; cannot skip instruction;
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index f3c3811..0c25ee2 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -22,6 +22,8 @@
 #include <linux/uaccess.h>
 #include <linux/uprobes.h>
 #include <linux/namei.h>
+#include <linux/poll.h>
+#include <linux/sort.h>
 
 #include "trace_probe.h"
 
@@ -48,6 +50,7 @@ struct trace_uprobe {
 	unsigned int			flags;	/* For TP_FLAG_* */
 	ssize_t				size;	/* trace entry size */
 	unsigned int			nr_args;
+	bool				is_gb;
 	struct probe_arg		args[];
 };
 
@@ -177,19 +180,24 @@ static int create_trace_uprobe(int argc, char **argv)
 	struct path path;
 	unsigned long offset;
 	bool is_delete;
+	bool is_gb;
 	int i, ret;
 
 	inode = NULL;
 	ret = 0;
 	is_delete = false;
+	is_gb = false;
 	event = NULL;
 	group = NULL;
 
 	/* argc must be >= 1 */
 	if (argv[0][0] == '-')
 		is_delete = true;
+	else if (argv[0][0] == 'g')
+		is_gb = true;
 	else if (argv[0][0] != 'p') {
-		pr_info("Probe definition must be started with 'p' or '-'.\n");
+		pr_info("Probe definition must be started with 'p', 'g' or "
+				"'-'.\n");
 		return -EINVAL;
 	}
 
@@ -277,7 +285,8 @@ static int create_trace_uprobe(int argc, char **argv)
 		if (ptr)
 			*ptr = '\0';
 
-		snprintf(buf, MAX_EVENT_NAME_LEN, "%c_%s_0x%lx", 'p', tail, offset);
+		snprintf(buf, MAX_EVENT_NAME_LEN, "%c_%s_0x%lx",
+				is_gb ? 'g' : 'p', tail, offset);
 		event = buf;
 		kfree(tail);
 	}
@@ -298,6 +307,8 @@ static int create_trace_uprobe(int argc, char **argv)
 		goto error;
 	}
 
+	tu->is_gb = is_gb;
+
 	/* parse arguments */
 	ret = 0;
 	for (i = 0; i < argc && i < MAX_TRACE_ARGS; i++) {
@@ -394,8 +405,12 @@ static int probes_seq_show(struct seq_file *m, void *v)
 {
 	struct trace_uprobe *tu = v;
 	int i;
+	char type = 'p';
+
+	if (tu->is_gb)
+		type = 'g';
 
-	seq_printf(m, "p:%s/%s", tu->call.class->system, tu->call.name);
+	seq_printf(m, "%c:%s/%s", type, tu->call.class->system, tu->call.name);
 	seq_printf(m, " %s:0x%p", tu->filename, (void *)tu->offset);
 
 	for (i = 0; i < tu->nr_args; i++)
@@ -435,6 +450,374 @@ static const struct file_operations uprobe_events_ops = {
 	.write		= probes_write,
 };
 
+static int pidt_cmp(const void *a, const void *b)
+{
+	const pid_t *ap = a;
+	const pid_t *bp = b;
+
+	if (*ap != *bp)
+		return *ap > *bp ? 1 : -1;
+	return 0;
+}
+
+static pid_t *gb_pid_find(pid_t *first, pid_t *last, pid_t pid)
+{
+	if (first == last)
+		return NULL;
+	while (first <= last) {
+		pid_t *mid;
+
+		mid = ((last - first) >> 1) + first;
+
+		if (*mid < pid)
+			first = mid + 1;
+		else if (*mid > pid)
+			last = mid - 1;
+		else
+			return mid;
+	}
+	return NULL;
+}
+
+static loff_t gb_read_reset(struct file *file, loff_t offset, int origin)
+{
+	if (offset != 0)
+		return -EINVAL;
+	if (origin != SEEK_SET)
+		return -EINVAL;
+	file->f_pos = 0;
+	return file->f_pos;
+}
+
+static DEFINE_MUTEX(gb_pid_lock);
+static DEFINE_MUTEX(gb_state_lock);
+
+static ssize_t gb_read(char __user *buffer, size_t count, loff_t *ppos,
+		pid_t *pids, u8 num_pids)
+{
+	char buf[800];
+	int left;
+	size_t wrote = 0;
+	int i;
+	int ret;
+
+	if (*ppos)
+		return 0;
+
+	left = min(sizeof(buf), count);
+
+	mutex_lock(&gb_pid_lock);
+	for (i = 0; (i < num_pids) && (left - wrote) > 0; i++) {
+		wrote += snprintf(&buf[wrote], left - wrote, "%d\n",
+				pids[i]);
+	}
+	mutex_unlock(&gb_pid_lock);
+
+	wrote = min(wrote, count);
+	ret = copy_to_user(buffer, buf, wrote);
+	if (ret)
+		return -EFAULT;
+	/* make sure there are no more reads until lseek() to start */
+	*ppos = 1;
+	return wrote;
+}
+
+static DECLARE_WAIT_QUEUE_HEAD(gb_hit_ev_queue);
+static pid_t active_pids[64];
+static u8 num_active_pids;
+
+static int uprobe_gb_record(void)
+{
+	mutex_lock(&gb_pid_lock);
+	if (WARN_ON_ONCE(num_active_pids > ARRAY_SIZE(active_pids))) {
+		mutex_unlock(&gb_pid_lock);
+		return -ENOSPC;
+	}
+
+	active_pids[num_active_pids] = current->pid;
+	num_active_pids++;
+
+	sort(active_pids, num_active_pids, sizeof(pid_t),
+			pidt_cmp, NULL);
+	mutex_unlock(&gb_pid_lock);
+
+	wake_up_interruptible(&gb_hit_ev_queue);
+	return 0;
+}
+
+static pid_t *gb_active_find(pid_t pid)
+{
+	return gb_pid_find(&active_pids[0],
+			&active_pids[num_active_pids], pid);
+}
+
+void uprobe_gb_remove_active(pid_t pid)
+{
+	pid_t *match;
+	u8 entry;
+
+	mutex_lock(&gb_pid_lock);
+	match = gb_active_find(pid);
+	if (!match) {
+		mutex_unlock(&gb_pid_lock);
+		return;
+	}
+
+	num_active_pids--;
+	entry = match - active_pids;
+	memcpy(&active_pids[entry], &active_pids[entry + 1],
+			(num_active_pids - entry) * sizeof(pid_t));
+	mutex_unlock(&gb_pid_lock);
+	return;
+}
+
+static unsigned int gb_poll(struct file *file, struct poll_table_struct *wait)
+{
+	poll_wait(file, &gb_hit_ev_queue, wait);
+	if (num_active_pids)
+		return POLLIN | POLLRDNORM;
+	return 0;
+}
+
+static ssize_t gb_active_read(struct file *file, char __user *buffer,
+		size_t count, loff_t *ppos)
+{
+	return gb_read(buffer, count, ppos, active_pids, num_active_pids);
+}
+
+static int uprobe_wakeup_task(struct task_struct *t, int traced)
+{
+	struct uprobe_task *utask;
+	int ret = -EINVAL;
+
+	utask = t->utask;
+	if (!utask)
+		return ret;
+	mutex_lock(&gb_state_lock);
+	if (utask->state != UTASK_TRACE_SLEEP)
+		goto out;
+
+	uprobe_gb_remove_active(t->pid);
+
+	utask->state = traced ?
+		UTASK_TRACE_WOKEUP_TRACED : UTASK_TRACE_WOKEUP_NORMAL;
+	wake_up_state(t, TASK_KILLABLE);
+	ret = 0;
+out:
+	mutex_unlock(&gb_state_lock);
+	return ret;
+}
+
+static int gp_continue_pid(const char *buf, int traced)
+{
+	struct task_struct *child;
+	unsigned long pid;
+	int ret;
+
+	if (isspace(*buf))
+		buf++;
+
+	ret = kstrtoul(buf, 0, &pid);
+	if (ret)
+		return ret;
+
+	rcu_read_lock();
+	child = find_task_by_vpid(pid);
+	if (child)
+		get_task_struct(child);
+	rcu_read_unlock();
+
+	if (!child)
+		return -EINVAL;
+
+	ret = uprobe_wakeup_task(child, traced);
+	put_task_struct(child);
+	return ret;
+}
+
+static ssize_t gp_active_write(struct file *filp,
+		const char __user *ubuf, size_t count, loff_t *ppos)
+{
+	char buf[32];
+	int ret;
+	int traced = 0;
+
+	if (count >= sizeof(buf))
+		return -ERANGE;
+	ret = copy_from_user(buf, ubuf, count);
+	if (ret)
+		return -EFAULT;
+	buf[count] = '\0';
+
+	switch (buf[0]) {
+	case 't':
+		traced = 1;
+	case 'c':
+		ret = gp_continue_pid(&buf[1], traced);
+		break;
+
+	default:
+		ret = -EINVAL;
+	};
+
+	if (ret < 0)
+		return ret;
+	return count;
+}
+
+static const struct file_operations uprobe_gp_active_ops = {
+	.owner		= THIS_MODULE,
+	.open		= simple_open,
+	.llseek		= gb_read_reset,
+	.read		= gb_active_read,
+	.write		= gp_active_write,
+	.poll		= gb_poll,
+};
+
+static pid_t exlcuded_pids[64];
+static u8 num_exlcuded_pids;
+
+static pid_t *gb_exclude_find(pid_t pid)
+{
+	return gb_pid_find(&exlcuded_pids[0],
+			&exlcuded_pids[num_exlcuded_pids], pid);
+}
+
+static int uprobe_gb_allowed(void)
+{
+	pid_t *match;
+
+	if (!num_exlcuded_pids) {
+		pr_err_once("Need atleast one PID which is excluded from the "
+				"global breakpoint. This should be the "
+				"debugging tool.\n");
+		return -EINVAL;
+	}
+	mutex_lock(&gb_pid_lock);
+	match = gb_exclude_find(current->pid);
+	mutex_unlock(&gb_pid_lock);
+	if (match)
+		return -EPERM;
+	return 0;
+}
+
+static int gp_exclude_pid(const char *buf)
+{
+	unsigned long pid;
+	pid_t *match;
+	int ret;
+
+	if (isspace(*buf))
+		buf++;
+	ret = kstrtoul(buf, 0, &pid);
+	if (ret)
+		return ret;
+
+	mutex_lock(&gb_pid_lock);
+	if (num_exlcuded_pids >= ARRAY_SIZE(exlcuded_pids)) {
+		ret = -E2BIG;
+		goto out;
+	}
+
+	match = gb_exclude_find(pid);
+	if (match) {
+		ret = 0;
+		goto out;
+	}
+
+	exlcuded_pids[num_exlcuded_pids] = pid;
+	num_exlcuded_pids++;
+
+	sort(exlcuded_pids, num_exlcuded_pids, sizeof(pid_t),
+			pidt_cmp, NULL);
+out:
+	mutex_unlock(&gb_pid_lock);
+	return ret;
+}
+
+int uprobe_gb_allow_pid(pid_t pid)
+{
+	int ret;
+	pid_t *match;
+	u8 entry;
+
+	mutex_lock(&gb_pid_lock);
+	match = gb_exclude_find(pid);
+	if (!match) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	num_exlcuded_pids--;
+	entry = match - exlcuded_pids;
+	memcpy(&exlcuded_pids[entry], &exlcuded_pids[entry + 1],
+			(num_exlcuded_pids - entry) * sizeof(pid_t));
+	ret = 0;
+out:
+	mutex_unlock(&gb_pid_lock);
+	return ret;
+}
+
+static int gp_allow_pid(const char *buf)
+{
+	unsigned long pid;
+	int ret;
+
+	if (isspace(*buf))
+		buf++;
+
+	ret = kstrtoul(buf, 0, &pid);
+	if (ret)
+		return ret;
+
+	return uprobe_gb_allow_pid(pid);
+}
+
+static ssize_t gp_exclude_write(struct file *filp,
+		const char __user *ubuf, size_t count, loff_t *ppos)
+{
+	char buf[32];
+	int ret;
+
+	if (count >= sizeof(buf))
+		return -ERANGE;
+	ret = copy_from_user(buf, ubuf, count);
+	if (ret)
+		return -EFAULT;
+	buf[count] = '\0';
+
+	switch (buf[0]) {
+	case 'e':
+		ret = gp_exclude_pid(&buf[1]);
+		break;
+
+	case 'r':
+		ret = gp_allow_pid(&buf[1]);
+		break;
+
+	default:
+		ret = -EINVAL;
+	};
+
+	if (ret < 0)
+		return ret;
+	return count;
+}
+
+static ssize_t gb_exclude_read(struct file *file, char __user *buffer,
+		size_t count, loff_t *ppos)
+{
+	return gb_read(buffer, count, ppos, exlcuded_pids, num_exlcuded_pids);
+}
+
+static const struct file_operations uprobe_gp_exclude_ops = {
+	.owner		= THIS_MODULE,
+	.open		= simple_open,
+	.llseek		= gb_read_reset,
+	.read		= gb_exclude_read,
+	.write		= gp_exclude_write,
+};
+
 /* Probes profiling interfaces */
 static int probes_profile_seq_show(struct seq_file *m, void *v)
 {
@@ -704,6 +1087,32 @@ int trace_uprobe_register(struct ftrace_event_call *event, enum trace_reg type,
 	return 0;
 }
 
+static void uprobe_wait_traced(struct trace_uprobe *tu)
+{
+	struct uprobe_task *utask;
+	int ret;
+
+	ret = uprobe_gb_allowed();
+	if (ret)
+		return;
+
+	mutex_lock(&gb_state_lock);
+	utask = current->utask;
+	utask->state = UTASK_TRACE_SLEEP;
+
+	set_current_state(TASK_KILLABLE);
+	ret = uprobe_gb_record();
+	if (ret < 0) {
+		utask->state = UTASK_TRACE_WOKEUP_NORMAL;
+		set_current_state(TASK_RUNNING);
+		mutex_unlock(&gb_state_lock);
+		return;
+	}
+	mutex_unlock(&gb_state_lock);
+
+	schedule();
+}
+
 static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
 {
 	struct uprobe_trace_consumer *utc;
@@ -721,6 +1130,9 @@ static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
 	if (tu->flags & TP_FLAG_PROFILE)
 		uprobe_perf_func(tu, regs);
 #endif
+	if (tu->is_gb)
+		uprobe_wait_traced(tu);
+
 	return 0;
 }
 
@@ -779,6 +1191,10 @@ static __init int init_uprobe_trace(void)
 
 	trace_create_file("uprobe_events", 0644, d_tracer,
 				    NULL, &uprobe_events_ops);
+	trace_create_file("uprobe_gb_exclude", 0644, d_tracer,
+				    NULL, &uprobe_gp_exclude_ops);
+	trace_create_file("uprobe_gb_active", 0644, d_tracer,
+				    NULL, &uprobe_gp_active_ops);
 	/* Profile interface */
 	trace_create_file("uprobe_profile", 0444, d_tracer,
 				    NULL, &uprobe_profile_ops);
-- 
1.7.10.4

