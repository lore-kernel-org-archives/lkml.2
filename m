Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab2HGQOB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:14:01 -0400
Received: from www.linutronix.de ([62.245.132.108]:53110 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab2HGQMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:12:51 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakaynahalli <ananth@in.ibm.com>, stan_shebs@mentor.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        gdb-patches@sourceware.org
Subject: [RFC 5/5] uprobes: add global breakpoints
Date: Tue,  7 Aug 2012 18:12:32 +0200
Message-Id: <1344355952-2382-6-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de>
References: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
passed and the user may attach to the program via ptrace.
First, setup a global breakpoint which is very similar to a uprobe trace
point:

|echo 'g /home/bigeasy/sample:0x0000044d %ip %ax' > uprobe_events

This is exactly what uprobe does except that it starts with the letter
'g' instead of 'p'.

Step two is to enable it:
|echo 1 > events/uprobes/enable

Lets assume you execute ./sample and the breakpoint is hit. In ps you will
see:
|1938 pts/1    t+     0:00 ./sample

Now you can attach gdb via 'gdb -p 1938'. The gdb can now interact with
the tracee and inspect its registers, its stack, single step, let it
run…
In case the process is not of great interest, the user may continue
without gdb by writting its pid into the uprobe_gp_wakeup file

|echo 1938 > uprobe_gp_wakeup

What I miss right now is an interface to tell the user/gdb that there is a
program that hit a global breakpoint and is waiting for further instructions.
A "tail -f trace" does not work and may contain also a lot of other
informations. I've been thinking about a poll()able file which returns pids of
tasks which are put on hold. Other suggestions?

Cc: gdb-patches@sourceware.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/uprobes.h     |   10 +++++++
 kernel/events/uprobes.c     |   29 +++++++++++++++++--
 kernel/ptrace.c             |    4 ++-
 kernel/trace/trace_uprobe.c |   67 +++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 104 insertions(+), 6 deletions(-)

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
index c8e5204..f1326a2 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1473,6 +1473,22 @@ void __weak arch_uprobe_disable_step(struct arch_uprobe *arch)
 	user_disable_single_step(current);
 }
 
+int uprobe_wakeup_task(struct task_struct *t, int traced)
+{
+	struct uprobe_task *utask;
+
+	utask = t->utask;
+	if (!utask)
+		return -EINVAL;
+	if (utask->state != UTASK_TRACE_SLEEP)
+		return -EINVAL;
+
+	utask->state = traced ?
+		UTASK_TRACE_WOKEUP_TRACED : UTASK_TRACE_WOKEUP_NORMAL;
+	wake_up_state(t, __TASK_TRACED);
+	return 0;
+}
+
 /*
  * Run handler and ask thread to singlestep.
  * Ensure all non-fatal signals cannot interrupt thread while it singlesteps.
@@ -1513,7 +1529,16 @@ static void handle_swbp(struct pt_regs *regs)
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
 
@@ -1528,7 +1553,7 @@ cleanup_ret:
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
index f3c3811..0aabee4 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -48,6 +48,7 @@ struct trace_uprobe {
 	unsigned int			flags;	/* For TP_FLAG_* */
 	ssize_t				size;	/* trace entry size */
 	unsigned int			nr_args;
+	bool				is_gb;
 	struct probe_arg		args[];
 };
 
@@ -177,19 +178,24 @@ static int create_trace_uprobe(int argc, char **argv)
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
 
@@ -277,7 +283,8 @@ static int create_trace_uprobe(int argc, char **argv)
 		if (ptr)
 			*ptr = '\0';
 
-		snprintf(buf, MAX_EVENT_NAME_LEN, "%c_%s_0x%lx", 'p', tail, offset);
+		snprintf(buf, MAX_EVENT_NAME_LEN, "%c_%s_0x%lx",
+				is_gb ? 'g' : 'p', tail, offset);
 		event = buf;
 		kfree(tail);
 	}
@@ -298,6 +305,8 @@ static int create_trace_uprobe(int argc, char **argv)
 		goto error;
 	}
 
+	tu->is_gb = is_gb;
+
 	/* parse arguments */
 	ret = 0;
 	for (i = 0; i < argc && i < MAX_TRACE_ARGS; i++) {
@@ -394,8 +403,12 @@ static int probes_seq_show(struct seq_file *m, void *v)
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
@@ -435,6 +448,38 @@ static const struct file_operations uprobe_events_ops = {
 	.write		= probes_write,
 };
 
+static ssize_t uprobes_gp_wakeup_write(struct file *filp,
+		const char __user *ubuf, size_t count, loff_t *ppos)
+{
+	struct task_struct *child;
+	unsigned long pid;
+	int ret;
+
+	ret = kstrtoul_from_user(ubuf, count, 0, &pid);
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
+	return ret ? ret : count;
+}
+
+static const struct file_operations uprobe_gp_wakeup_ops = {
+	.owner		= THIS_MODULE,
+	.open		= simple_open,
+	.llseek		= noop_llseek,
+	.write		= uprobes_gp_wakeup_write,
+};
+
 /* Probes profiling interfaces */
 static int probes_profile_seq_show(struct seq_file *m, void *v)
 {
@@ -704,6 +749,17 @@ int trace_uprobe_register(struct ftrace_event_call *event, enum trace_reg type,
 	return 0;
 }
 
+static void uprobe_wait_traced(struct trace_uprobe *tu)
+{
+	struct uprobe_task *utask;
+
+	utask = current->utask;
+	utask->state = UTASK_TRACE_SLEEP;
+
+	set_current_state(TASK_TRACED);
+	schedule();
+}
+
 static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
 {
 	struct uprobe_trace_consumer *utc;
@@ -721,6 +777,9 @@ static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
 	if (tu->flags & TP_FLAG_PROFILE)
 		uprobe_perf_func(tu, regs);
 #endif
+	if (tu->is_gb)
+		uprobe_wait_traced(tu);
+
 	return 0;
 }
 
@@ -779,6 +838,8 @@ static __init int init_uprobe_trace(void)
 
 	trace_create_file("uprobe_events", 0644, d_tracer,
 				    NULL, &uprobe_events_ops);
+	trace_create_file("uprobe_gb_wakeup", 0644, d_tracer,
+				    NULL, &uprobe_gp_wakeup_ops);
 	/* Profile interface */
 	trace_create_file("uprobe_profile", 0444, d_tracer,
 				    NULL, &uprobe_profile_ops);
-- 
1.7.10.4

