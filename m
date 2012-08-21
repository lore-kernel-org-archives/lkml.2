Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027Ab2HUTmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 15:42:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:42996 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab2HUTmG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 15:42:06 -0400
Date: Tue, 21 Aug 2012 21:42:00 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakaynahalli <ananth@in.ibm.com>, stan_shebs@mentor.com,
        gdb-patches@sourceware.org
Subject: [RFC 5/5 v2] uprobes: add global breakpoints
Message-ID: <20120821194200.GA32293@linutronix.de>
References: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de>
 <1344355952-2382-6-git-send-email-bigeasy@linutronix.de>
 <1344857686.31459.25.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1344857686.31459.25.camel@twins>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By setting an uprobe tracepoint, one learns whenever a certain point
within a program is reached / passed. This is recorded and the
application continues.
This patch adds the ability to hold the program once this point has been
passed and the user may attach to the program via ptrace.
First, setup a global breakpoint which is very similar to a uprobe trace
point:

|echo 'g /home/bigeasy/uprobetest/sample:0x0000044d %ip %ax %bx' > uprobe_events

This is exactly what uprobe does except that it starts with the letter
'g' instead of 'p'.

Step two is to enable it:
|echo 1 > events/uprobes/enable

Step three is to add pids of prcocess which are excluded from global
breakpoints even if the process would hit one. This should ensure that
the debugger remains active and the global breakpoint on system libc's
malloc() does not freeze the system. A pid can be excluded by
| echo e $pid > uprobe_gb_exclude

You need atleast one pid in the exlude list. An entry can be removed by
| echo a $pid > uprobe_gb_exclude

Lets assume you execute ./sample and the breakpoint is hit. In ps you will
see:
|1938 pts/1    t+     0:00 ./sample

Now you can attach gdb via 'gdb -p 1938'. The gdb now can interact with
the tracee and inspect its registers or its stack, single step, let it
run…
In case the process is not of great interest, the user may continue
without gdb by writting its pid into the uprobe_gp_wakeup file

|echo 1938 > uprobe_gp_wakeup

Cc: gdb-patches@sourceware.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
v1..v2: 
 - closed the window between set state / check state
 - tried to address Peters review / concern:
   - added "uprobe_gb_exclude". This file contains a list of pids which
     are excluded from the "global breakpoint" behavior. The idea is to
     whitelist programs which are essential and must not hit a
     breakpoint. An empty list is invalid and _no_ global breakpoint will
     hit.
   - added "uprobe_gb_active". This file contains a list of pids which
     hit the global breakpoint. The user can poll() here and wait for
     the next victim. The size of the list limited. This is step two to
     ensure a global system lock up does not occur. If a java program is
     beeing debugged and the size of the list is too small then the list
     could be allocated at runtime with more entries.

   I've been thinking about alterntives to the approach above:
   - cgroups
     Would solve some problems. It would be very easy for the user to
     group tasks in two groups: "root" group with "allowed" tasks and
     sub group "excluded" for tasks which are excluded from the global
     breakpoint(s). A third group would be required to put the "halted"
     tasks. I would need one file to set the type of the group (root is
     easy, "allowed" and "halted" have to be set). The notification
     mechanism works on per file basis. So I would have to add file with
     no content just to let the user that the task file has new entries.
     All in all this looks like a abuse of cgroups just to follow forks
     on the exclude list and maintain the list.
   - auto exclude the read()er / poll()er of uprobe_gb_active
     This sounds lovely but has two short commings:
     - the pid of the process that opened it may change after fork()
       since the initial owner may exit
     - they may be two+ childs after fork() which read() / poll(). Both
       should be excluded since I don't kwnow which one is which. I don't
       know which one terminates because ->release() is called by last
       process that closes the fd. That means in this scenario I would
       add more entries to the while list than remove.
     - having a list of tasks which currently poll() the file would
       solve the problem with this endless growing list. However once
       poll() is done (one process just hit the global breakpoint) I have
       an empty list since no one can poll() now. That means that I
       would exclude every further process which hits the global breakpoint
       before someone poll()s again.

Oleg: The change in ptrace_attach() is still as it was. I tried to
address Peter concern here.
Now what options do I have here:
- not putting the task in TASK_TRACED but simply halt. This would work
  without a change to ptrace_attach() but the task continues on any
  signal. So a signal friendly task would continue and not notice a
  thing.
- putting the TASK_TRACED and not touching ptrace_attach(). Each
  ptrace() user would have to kick the task itself which means changes
  to gdb / strace. If this is the prefered way then I guess it can be
  done :)

 include/linux/uprobes.h     |   10 ++
 kernel/events/uprobes.c     |   13 +-
 kernel/ptrace.c             |    4 +-
 kernel/trace/trace_uprobe.c |  414 ++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 435 insertions(+), 6 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 0fc6585..991a665 100644
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
+	int				skip_handler;
 };
 
 /*
@@ -120,6 +124,8 @@ extern bool uprobe_deny_signal(void);
 extern bool __weak arch_uprobe_skip_sstep(struct arch_uprobe *aup, struct pt_regs *regs);
 extern void uprobe_clear_state(struct mm_struct *mm);
 extern void uprobe_reset_state(struct mm_struct *mm);
+extern int uprobe_wakeup_task(struct task_struct *t, int traced);
+
 #else /* !CONFIG_UPROBES */
 struct uprobes_state {
 };
@@ -163,5 +169,9 @@ static inline void uprobe_clear_state(struct mm_struct *mm)
 static inline void uprobe_reset_state(struct mm_struct *mm)
 {
 }
+static inline int uprobe_wakeup_task(struct task_struct *t, int traced)
+{
+	return 0;
+}
 #endif /* !CONFIG_UPROBES */
 #endif	/* _LINUX_UPROBES_H */
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index c8e5204..c140e03 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1513,7 +1513,16 @@ static void handle_swbp(struct pt_regs *regs)
 			goto cleanup_ret;
 	}
 	utask->active_uprobe = uprobe;
-	handler_chain(uprobe, regs);
+	if (utask->skip_handler)
+		utask->skip_handler = 0;
+	else
+		handler_chain(uprobe, regs);
+
+	if (utask->state == UTASK_TRACE_WOKEUP_TRACED) {
+		send_sig(SIGTRAP, current, 0);
+		utask->skip_handler = 1;
+		goto cleanup_ret;
+	}
 	if (uprobe->flags & UPROBE_SKIP_SSTEP && can_skip_sstep(uprobe, regs))
 		goto cleanup_ret;
 
@@ -1528,7 +1537,7 @@ cleanup_ret:
 		utask->active_uprobe = NULL;
 		utask->state = UTASK_RUNNING;
 	}
-	if (!(uprobe->flags & UPROBE_SKIP_SSTEP))
+	if (!(uprobe->flags & UPROBE_SKIP_SSTEP) || utask->skip_handler)
 
 		/*
 		 * cannot singlestep; cannot skip instruction;
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index a232bb5..5d6d3ed 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -286,8 +286,10 @@ static int ptrace_attach(struct task_struct *task, long request,
 	__ptrace_link(task, current);
 
 	/* SEIZE doesn't trap tracee on attach */
-	if (!seize)
+	if (!seize) {
 		send_sig_info(SIGSTOP, SEND_SIG_FORCED, task);
+		uprobe_wakeup_task(task, 1);
+	}
 
 	spin_lock(&task->sighand->siglock);
 
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index f3c3811..693c50a 100644
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
@@ -435,6 +450,366 @@ static const struct file_operations uprobe_events_ops = {
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
+static pid_t* gb_pid_find(pid_t *first, pid_t *last, pid_t pid)
+{
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
+	for (i = 0; (i < num_pids) && left - wrote > 0; i++) {
+		wrote += snprintf(&buf[wrote], left - wrote, "%d\n",
+				pids[i]);
+	}
+	mutex_unlock(&gb_pid_lock);
+
+	wrote = min(wrote, count);
+	ret = copy_to_user(buffer, buf, wrote);
+	if (ret)
+		return -EFAULT;
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
+static pid_t* gb_active_find(pid_t pid)
+{
+	return gb_pid_find(&active_pids[0],
+			&active_pids[num_active_pids], pid);
+}
+
+static int uprobe_gb_remove_active(pid_t pid)
+{
+	pid_t *match;
+	u8 entry;
+
+	mutex_lock(&gb_pid_lock);
+	match = gb_active_find(pid);
+	if (!match) {
+		mutex_unlock(&gb_pid_lock);
+		return -EINVAL;
+	}
+
+	num_active_pids--;
+	entry = match - active_pids;
+	memcpy(&active_pids[entry], &active_pids[entry + 1],
+			(num_active_pids - entry) * sizeof(pid_t));
+	mutex_unlock(&gb_pid_lock);
+	return 0;
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
+static ssize_t gb_active_read(struct file *file, char __user * buffer, size_t count,
+		loff_t *ppos)
+{
+	int ret;
+	ret = gb_read(buffer, count, ppos, active_pids, num_active_pids);
+	return ret;
+}
+
+int uprobe_wakeup_task(struct task_struct *t, int traced)
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
+	wake_up_state(t, __TASK_TRACED);
+	ret = 0;
+out:
+	mutex_unlock(&gb_state_lock);
+	return ret;
+}
+
+static int gp_continue_pid(const char *buf)
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
+	ret = uprobe_wakeup_task(child, 0);
+	put_task_struct(child);
+	return ret;
+}
+
+static ssize_t gp_active_write(struct file *filp,
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
+		case 'c':
+			ret = gp_continue_pid(&buf[1]);
+			break;
+
+		default:
+			ret = -EINVAL;
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
+static pid_t* gb_exclude_find(pid_t pid)
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
+static int gp_allow_pid(const char *buf)
+{
+	unsigned long pid;
+	pid_t *match;
+	u8 entry;
+	int ret;
+
+	if (isspace(*buf))
+		buf++;
+
+	ret = kstrtoul(buf, 0, &pid);
+	if (ret)
+		return ret;
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
+	case 'a':
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
+	int ret;
+
+	ret = gb_read(buffer, count, ppos, exlcuded_pids, num_exlcuded_pids);
+	return ret;
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
@@ -704,6 +1079,32 @@ int trace_uprobe_register(struct ftrace_event_call *event, enum trace_reg type,
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
+	set_current_state(TASK_TRACED);
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
@@ -721,6 +1122,9 @@ static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
 	if (tu->flags & TP_FLAG_PROFILE)
 		uprobe_perf_func(tu, regs);
 #endif
+	if (tu->is_gb)
+		uprobe_wait_traced(tu);
+
 	return 0;
 }
 
@@ -779,6 +1183,10 @@ static __init int init_uprobe_trace(void)
 
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

