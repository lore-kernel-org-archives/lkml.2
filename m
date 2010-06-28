Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab0F1GEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 02:04:40 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:47989 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab0F1GEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 02:04:34 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 28 Jun 2010 11:29:31 +0530
Message-Id: <20100628055931.6869.15045.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100628055740.6869.77397.sendpatchset@localhost6.localdomain6>
References: <20100628055740.6869.77397.sendpatchset@localhost6.localdomain6>
Subject: [PATCHv6 2.6.35-rc3-tip 9/12]  trace: uprobes trace_event interface
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


trace: uprobes trace_event interface

Changelog from v5: Addressed comments from Masami Hiramatsu and Steven
      Rostedt. Some changes because of changes in common probe events.

Changelog from v4: (Merged to 2.6.35-rc3-tip)

Changelog from v2/v3: (Addressing comments from Steven Rostedt
					and Frederic Weisbecker)
	* removed pit field from uprobe_trace_entry.
	* share common parts with kprobe trace events.
	* use trace_create_file instead of debugfs_create_file.

Implements trace_event support for uprobes. In its
current form it can be used to put probes at a specified text address
in a process and dump the required registers when the code flow reaches
the probed address.

TODO: Documentation/trace/uprobetrace.txt

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

The following example shows how to dump the instruction pointer and %ax a
register at the probed text address.

Start a process to trace. Get the address to trace.
  [Here pid is asssumed as 6016]
  [Address to trace is 0x0000000000446420]
  [Registers to be dumped are %ip and %ax]

# cd /sys/kernel/debug/tracing/
# echo 'p 6016:0x0000000000446420 %ip %ax' > uprobe_events
# cat uprobe_events
p:uprobes/p_6016_0x0000000000446420 6016:0x0000000000446420 %ip=%ip %ax=%ax
# cat events/uprobes/p_6016_0x0000000000446420/enable
0
[enable the event]
# echo 1 > events/uprobes/p_6016_0x0000000000446420/enable
# cat events/uprobes/p_6016_0x0000000000446420/enable
1
# #### do some activity on the program so that it hits the breakpoint
# cat uprobe_profile
  6016 p_6016_0x0000000000446420                                234
# tracer: nop
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
             zsh-6016  [004] 227931.093579: p_6016_0x0000000000446420: (0x446420) %ip=446421 %ax=79
             zsh-6016  [005] 227931.097541: p_6016_0x0000000000446420: (0x446420) %ip=446421 %ax=79
             zsh-6016  [000] 227931.124909: p_6016_0x0000000000446420: (0x446420) %ip=446421 %ax=79
             zsh-6016  [001] 227933.128565: p_6016_0x0000000000446420: (0x446420) %ip=446421 %ax=79
             zsh-6016  [004] 227933.132756: p_6016_0x0000000000446420: (0x446420) %ip=446421 %ax=79
             zsh-6016  [000] 227933.158802: p_6016_0x0000000000446420: (0x446420) %ip=446421 %ax=79
             zsh-6016  [001] 227935.161602: p_6016_0x0000000000446420: (0x446420) %ip=446421 %ax=79
             zsh-6016  [004] 227935.165229: p_6016_0x0000000000446420: (0x446420) %ip=446421 %ax=79


 arch/Kconfig                |   11 -
 kernel/trace/Kconfig        |   16 +
 kernel/trace/Makefile       |    1 
 kernel/trace/trace.h        |    5 
 kernel/trace/trace_probe.h  |    2 
 kernel/trace/trace_uprobe.c |  739 +++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 764 insertions(+), 10 deletions(-)
 create mode 100644 kernel/trace/trace_uprobe.c


diff --git a/arch/Kconfig b/arch/Kconfig
index c8c8e3f..5c89a10 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -48,16 +48,7 @@ config OPTPROBES
 	select KALLSYMS_ALL
 
 config UPROBES
-	bool "User-space probes (EXPERIMENTAL)"
-	default n
-	depends on ARCH_SUPPORTS_UPROBES
-	depends on MMU
-	help
-	  Uprobes enables kernel subsystems to establish probepoints
-	  in user applications and execute handler functions when
-	  the probepoints are hit. For more information, refer to
-	  Documentation/uprobes.txt.
-	  If in doubt, say "N".
+	def_bool n 
 
 config HAVE_EFFICIENT_UNALIGNED_ACCESS
 	bool
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index ab62d9a..2f46188 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -513,6 +513,22 @@ config RING_BUFFER_BENCHMARK
 
 	  If unsure, say N.
 
+config UPROBE_EVENT
+	bool "Enable uprobes-based dynamic events"
+	depends on ARCH_SUPPORTS_UPROBES
+	depends on MMU
+	select UPROBES
+	select PROBE_EVENTS
+	select TRACING
+	default n
+	help
+	  This allows the user to add tracing events on top of userspace dynamic
+	  events (similar to tracepoints) on the fly via the traceevents interface.
+	  Those events can be inserted wherever uprobes can probe, and record
+	  various registers.
+	  This option is required if you plan to use perf-probe subcommand of perf
+	  tools on user space applications.
+
 endif # FTRACE
 
 endif # TRACING_SUPPORT
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 5a45910..a386d12 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -56,5 +56,6 @@ obj-$(CONFIG_KPROBE_EVENT) += trace_kprobe.o
 obj-$(CONFIG_KSYM_TRACER) += trace_ksym.o
 obj-$(CONFIG_EVENT_TRACING) += power-traces.o
 obj-$(CONFIG_PROBE_EVENTS) +=trace_probe.o
+obj-$(CONFIG_UPROBE_EVENT) += trace_uprobe.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 01ce088..0b446e6 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -99,6 +99,11 @@ struct kretprobe_trace_entry_head {
 	unsigned long		ret_ip;
 };
 
+struct uprobe_trace_entry_head {
+	struct trace_entry	ent;
+	unsigned long		ip;
+};
+
 /*
  * trace_flag_type is an enumeration that holds different
  * states when a trace occurs. These are:
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index cbee43a..76f2cca 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -43,6 +43,7 @@
 #define FIELD_STRING_IP "__probe_ip"
 #define FIELD_STRING_RETIP "__probe_ret_ip"
 #define FIELD_STRING_FUNC "__probe_func"
+#define FIELD_STRING_PID "__probe_pid"
 
 #undef DEFINE_FIELD
 #define DEFINE_FIELD(type, item, name, is_signed)			\
@@ -59,6 +60,7 @@
 /* Flags for trace_probe */
 #define TP_FLAG_TRACE	1
 #define TP_FLAG_PROFILE	2
+#define TP_FLAG_UPROBE	4
 
 /* Data fetch function type */
 typedef	void (*fetch_func_t)(struct pt_regs *, void *, void *);
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
new file mode 100644
index 0000000..e8b701b
--- /dev/null
+++ b/kernel/trace/trace_uprobe.c
@@ -0,0 +1,739 @@
+/*
+ * uprobes-based tracing events
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * Copyright (C) IBM Corporation, 2010
+ * Author:	Srikar Dronamraju
+ */
+
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <linux/uprobes.h>
+
+#include "trace_probe.h"
+
+#define UPROBE_EVENT_SYSTEM "uprobes"
+
+/**
+ * uprobe event core functions
+ */
+
+struct trace_uprobe {
+	struct list_head	list;
+	struct uprobe		up;
+	unsigned long		nhit;
+	unsigned int		flags;	/* For TP_FLAG_* */
+	struct ftrace_event_class	class;
+	struct ftrace_event_call	call;
+	ssize_t			size;		/* trace entry size */
+	unsigned int		nr_args;
+	struct probe_arg	args[];
+};
+
+#define SIZEOF_TRACE_UPROBE(n)			\
+	(offsetof(struct trace_uprobe, args) +	\
+	(sizeof(struct probe_arg) * (n)))
+
+static int register_uprobe_event(struct trace_uprobe *tp);
+static void unregister_uprobe_event(struct trace_uprobe *tp);
+
+static DEFINE_MUTEX(uprobe_lock);
+static LIST_HEAD(uprobe_list);
+
+static void uprobe_dispatcher(struct uprobe *up, struct pt_regs *regs);
+
+/*
+ * Allocate new trace_uprobe and initialize it (including uprobes).
+ */
+static struct trace_uprobe *alloc_trace_uprobe(const char *group,
+					const char *event,
+					void *addr,
+					pid_t pid, int nargs)
+{
+	struct trace_uprobe *tp;
+
+	if (!event || !tp_check_event_name(event))
+		return ERR_PTR(-EINVAL);
+
+	if (!group || !tp_check_event_name(group))
+		return ERR_PTR(-EINVAL);
+
+	tp = kzalloc(SIZEOF_TRACE_UPROBE(nargs), GFP_KERNEL);
+	if (!tp)
+		return ERR_PTR(-ENOMEM);
+
+	tp->up.vaddr = (unsigned long)addr;
+	tp->up.pid = pid;
+	tp->up.handler = uprobe_dispatcher;
+
+	tp->call.class = &tp->class;
+	tp->call.name = kstrdup(event, GFP_KERNEL);
+	if (!tp->call.name)
+		goto error;
+
+	tp->class.system = kstrdup(group, GFP_KERNEL);
+	if (!tp->class.system)
+		goto error;
+
+	INIT_LIST_HEAD(&tp->list);
+	return tp;
+error:
+	kfree(tp->call.name);
+	kfree(tp);
+	return ERR_PTR(-ENOMEM);
+}
+
+static void free_trace_uprobe(struct trace_uprobe *tp)
+{
+	int i;
+
+	for (i = 0; i < tp->nr_args; i++)
+		tp_free_probe_arg(&tp->args[i]);
+
+	kfree(tp->call.class->system);
+	kfree(tp->call.name);
+	kfree(tp);
+}
+
+static struct trace_uprobe *find_probe_event(const char *event,
+					const char *group)
+{
+	struct trace_uprobe *tp;
+
+	list_for_each_entry(tp, &uprobe_list, list)
+		if (strcmp(tp->call.name, event) == 0 &&
+		    strcmp(tp->call.class->system, group) == 0)
+			return tp;
+	return NULL;
+}
+
+/* Unregister a trace_uprobe and probe_event: call with locking uprobe_lock */
+static void unregister_trace_uprobe(struct trace_uprobe *tp)
+{
+	if (tp->flags & TP_FLAG_UPROBE)
+		unregister_uprobe(&tp->up);
+	list_del(&tp->list);
+	unregister_uprobe_event(tp);
+}
+
+/* Register a trace_uprobe and probe_event */
+static int register_trace_uprobe(struct trace_uprobe *tp)
+{
+	struct trace_uprobe *old_tp;
+	int ret;
+
+	mutex_lock(&uprobe_lock);
+
+	/* register as an event */
+	old_tp = find_probe_event(tp->call.name, tp->call.class->system);
+	if (old_tp) {
+		/* delete old event */
+		unregister_trace_uprobe(old_tp);
+		free_trace_uprobe(old_tp);
+	}
+	ret = register_uprobe_event(tp);
+	if (ret) {
+		pr_warning("Failed to register probe event(%d)\n", ret);
+		goto end;
+	}
+
+	list_add_tail(&tp->list, &uprobe_list);
+end:
+	mutex_unlock(&uprobe_lock);
+	return ret;
+}
+
+static int create_trace_uprobe(int argc, char **argv)
+{
+	/*
+	 * Argument syntax:
+	 *  - Add uprobe: p[:[GRP/]EVENT] VADDR@PID [%REG]
+	 *
+	 *  - Remove uprobe: -:[GRP/]EVENT
+	 */
+	struct trace_uprobe *tp;
+	int i, ret = 0;
+	int is_delete = 0;
+	char *arg = NULL, *event = NULL, *group = NULL;
+	void *addr = NULL;
+	pid_t pid = 0;
+	char buf[MAX_EVENT_NAME_LEN];
+	char *tmp;
+
+	/* argc must be >= 1 */
+	if (argv[0][0] == '-')
+		is_delete = 1;
+	else if (argv[0][0] != 'p') {
+		pr_info("Probe definition must be started with 'p', 'r' or"
+			" '-'.\n");
+		return -EINVAL;
+	}
+
+	if (argv[0][1] == ':') {
+		event = &argv[0][2];
+		if (strchr(event, '/')) {
+			group = event;
+			event = strchr(group, '/') + 1;
+			event[-1] = '\0';
+			if (strlen(group) == 0) {
+				pr_info("Group name is not specified\n");
+				return -EINVAL;
+			}
+		}
+		if (strlen(event) == 0) {
+			pr_info("Event name is not specified\n");
+			return -EINVAL;
+		}
+	}
+	if (!group)
+		group = UPROBE_EVENT_SYSTEM;
+
+	if (is_delete) {
+		if (!event) {
+			pr_info("Delete command needs an event name.\n");
+			return -EINVAL;
+		}
+		mutex_lock(&uprobe_lock);
+		tp = find_probe_event(event, group);
+		if (!tp) {
+			mutex_unlock(&uprobe_lock);
+			pr_info("Event %s/%s doesn't exist.\n", group, event);
+			return -ENOENT;
+		}
+		/* delete an event */
+		unregister_trace_uprobe(tp);
+		free_trace_uprobe(tp);
+		mutex_unlock(&uprobe_lock);
+		return 0;
+	}
+
+	if (argc < 2) {
+		pr_info("Probe point is not specified.\n");
+		return -EINVAL;
+	}
+	if (isdigit(argv[1][0])) {
+		/* an address specified */
+		arg = strchr(argv[1], ':');
+		if (!arg)
+			goto fail_address_parse;
+
+		*arg++ = '\0';
+		ret = strict_strtoul(&argv[1][0], 0, (unsigned long *)&pid);
+		if (ret)
+			goto fail_address_parse;
+
+		ret = strict_strtoul(arg, 0, (unsigned long *)&addr);
+		if (ret)
+			goto fail_address_parse;
+	}
+	argc -= 2; argv += 2;
+
+	/* setup a probe */
+	if (!event) {
+		snprintf(buf, MAX_EVENT_NAME_LEN, "%c_%d_0x%p", 'p',
+							pid, addr);
+		event = buf;
+	}
+	tp = alloc_trace_uprobe(group, event, addr, pid, argc);
+	if (IS_ERR(tp)) {
+		pr_info("Failed to allocate trace_uprobe.(%d)\n",
+			(int)PTR_ERR(tp));
+		return PTR_ERR(tp);
+	}
+
+	/* parse arguments */
+	ret = 0;
+	for (i = 0; i < argc && i < MAX_TRACE_ARGS; i++) {
+		/* Parse argument name */
+		arg = strchr(argv[i], '=');
+		if (arg)
+			*arg++ = '\0';
+		else
+			arg = argv[i];
+
+		tp->args[i].name = kstrdup(argv[i], GFP_KERNEL);
+		if (!tp->args[i].name) {
+			pr_info("Failed to allocate argument%d name '%s'.\n",
+				i, argv[i]);
+			ret = -ENOMEM;
+			goto error;
+		}
+		tmp = strchr(tp->args[i].name, ':');
+		if (tmp)
+			*tmp = '_';	/* convert : to _ */
+
+		if (tp_conflict_field_name(tp->args[i].name, tp->args, i)) {
+			pr_info("Argument%d name '%s' conflicts with "
+				"another field.\n", i, argv[i]);
+			ret = -EINVAL;
+			goto error;
+		}
+
+		/* Parse fetch argument */
+		ret = tp_parse_probe_arg(arg, &tp->size, &tp->args[i],
+								false, false);
+		if (ret) {
+			pr_info("Parse error at argument%d. (%d)\n", i, ret);
+			kfree(tp->args[i].name);
+			goto error;
+		}
+
+		tp->nr_args++;
+	}
+
+	ret = register_trace_uprobe(tp);
+	if (ret)
+		goto error;
+	return 0;
+
+error:
+	free_trace_uprobe(tp);
+	return ret;
+
+fail_address_parse:
+	pr_info("Failed to parse address.\n");
+	return ret;
+}
+
+static void cleanup_all_probes(void)
+{
+	struct trace_uprobe *tp;
+
+	mutex_lock(&uprobe_lock);
+	/* TODO: Use batch unregistration */
+	while (!list_empty(&uprobe_list)) {
+		tp = list_entry(uprobe_list.next, struct trace_uprobe, list);
+		unregister_trace_uprobe(tp);
+		free_trace_uprobe(tp);
+	}
+	mutex_unlock(&uprobe_lock);
+}
+
+
+/* Probes listing interfaces */
+static void *probes_seq_start(struct seq_file *m, loff_t *pos)
+{
+	mutex_lock(&uprobe_lock);
+	return seq_list_start(&uprobe_list, *pos);
+}
+
+static void *probes_seq_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	return seq_list_next(v, &uprobe_list, pos);
+}
+
+static void probes_seq_stop(struct seq_file *m, void *v)
+{
+	mutex_unlock(&uprobe_lock);
+}
+
+static int probes_seq_show(struct seq_file *m, void *v)
+{
+	struct trace_uprobe *tp = v;
+	int i;
+
+	seq_printf(m, "%c", 'p');
+	seq_printf(m, ":%s/%s", tp->call.class->system, tp->call.name);
+
+	seq_printf(m, " %d:0x%p", tp->up.pid, (void *)tp->up.vaddr);
+
+	for (i = 0; i < tp->nr_args; i++)
+		seq_printf(m, " %s=%s", tp->args[i].name, tp->args[i].comm);
+	seq_printf(m, "\n");
+
+	return 0;
+}
+
+static const struct seq_operations probes_seq_op = {
+	.start  = probes_seq_start,
+	.next   = probes_seq_next,
+	.stop   = probes_seq_stop,
+	.show   = probes_seq_show
+};
+
+static int probes_open(struct inode *inode, struct file *file)
+{
+	if ((file->f_mode & FMODE_WRITE) &&
+	    (file->f_flags & O_TRUNC))
+		cleanup_all_probes();
+
+	return seq_open(file, &probes_seq_op);
+}
+
+static ssize_t probes_write(struct file *file, const char __user *buffer,
+			    size_t count, loff_t *ppos)
+{
+	return tp_probes_write(file, buffer, count, ppos,
+			create_trace_uprobe);
+}
+
+static const struct file_operations uprobe_events_ops = {
+	.owner          = THIS_MODULE,
+	.open           = probes_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = seq_release,
+	.write		= probes_write,
+};
+
+/* Probes profiling interfaces */
+static int probes_profile_seq_show(struct seq_file *m, void *v)
+{
+	struct trace_uprobe *tp = v;
+
+	seq_printf(m, "  %d %-44s %15lu\n", tp->up.pid, tp->call.name,
+								tp->nhit);
+	return 0;
+}
+
+static const struct seq_operations profile_seq_op = {
+	.start  = probes_seq_start,
+	.next   = probes_seq_next,
+	.stop   = probes_seq_stop,
+	.show   = probes_profile_seq_show
+};
+
+static int profile_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &profile_seq_op);
+}
+
+static const struct file_operations uprobe_profile_ops = {
+	.owner          = THIS_MODULE,
+	.open           = profile_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = seq_release,
+};
+
+/* uprobe handler */
+static void uprobe_trace_func(struct uprobe *up, struct pt_regs *regs)
+{
+	struct trace_uprobe *tp = container_of(up, struct trace_uprobe, up);
+	struct uprobe_trace_entry_head *entry;
+	struct ring_buffer_event *event;
+	struct ring_buffer *buffer;
+	u8 *data;
+	int size, i, pc;
+	unsigned long irq_flags;
+	struct ftrace_event_call *call = &tp->call;
+
+	tp->nhit++;
+
+	local_save_flags(irq_flags);
+	pc = preempt_count();
+
+	size = sizeof(*entry) + tp->size;
+
+	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
+						  size, irq_flags, pc);
+	if (!event)
+		return;
+
+	entry = ring_buffer_event_data(event);
+	entry->ip = (unsigned long)up->vaddr;
+	data = (u8 *)&entry[1];
+	for (i = 0; i < tp->nr_args; i++)
+		tp_call_fetch(&tp->args[i].fetch, regs,
+						data + tp->args[i].offset);
+
+	if (!filter_current_check_discard(buffer, call, entry, event))
+		trace_buffer_unlock_commit(buffer, event, irq_flags, pc);
+}
+
+/* Event entry printers */
+enum print_line_t
+print_uprobe_event(struct trace_iterator *iter, int flags,
+		   struct trace_event *event)
+{
+	struct uprobe_trace_entry_head *field;
+	struct trace_seq *s = &iter->seq;
+	struct trace_uprobe *tp;
+	u8 *data;
+	int i;
+
+	field = (struct uprobe_trace_entry_head *)iter->ent;
+	tp = container_of(event, struct trace_uprobe, call.event);
+
+	if (!trace_seq_printf(s, "%s: (", tp->call.name))
+		goto partial;
+
+	if (!seq_print_ip_sym(s, field->ip, flags | TRACE_ITER_SYM_OFFSET))
+		goto partial;
+
+	if (!trace_seq_puts(s, ")"))
+		goto partial;
+
+	data = (u8 *)&field[1];
+	for (i = 0; i < tp->nr_args; i++)
+		if (!tp->args[i].type->print(s, tp->args[i].name,
+					     data + tp->args[i].offset))
+			goto partial;
+
+	if (!trace_seq_puts(s, "\n"))
+		goto partial;
+
+	return TRACE_TYPE_HANDLED;
+partial:
+	return TRACE_TYPE_PARTIAL_LINE;
+}
+
+
+static int probe_event_enable(struct ftrace_event_call *call)
+{
+	int ret = 0;
+	struct trace_uprobe *tp = (struct trace_uprobe *)call->data;
+
+	if (!(tp->flags & TP_FLAG_UPROBE)) {
+		ret = register_uprobe(&tp->up);
+		if (!ret)
+			tp->flags |= (TP_FLAG_UPROBE | TP_FLAG_TRACE);
+	}
+	return ret;
+}
+
+static void probe_event_disable(struct ftrace_event_call *call)
+{
+	struct trace_uprobe *tp = (struct trace_uprobe *)call->data;
+
+	if (tp->flags & TP_FLAG_UPROBE) {
+		unregister_uprobe(&tp->up);
+		tp->flags &= ~(TP_FLAG_UPROBE | TP_FLAG_TRACE);
+	}
+}
+
+static int uprobe_event_define_fields(struct ftrace_event_call *event_call)
+{
+	int ret, i;
+	struct uprobe_trace_entry_head field;
+	struct trace_uprobe *tp = (struct trace_uprobe *)event_call->data;
+
+	DEFINE_FIELD(unsigned long, ip, FIELD_STRING_IP, 0);
+	/* Set argument names as fields */
+	for (i = 0; i < tp->nr_args; i++) {
+		ret = trace_define_field(event_call, tp->args[i].type->name,
+					 tp->args[i].name,
+					 sizeof(field) + tp->args[i].offset,
+					 tp->args[i].type->size,
+					 tp->args[i].type->is_signed,
+					 FILTER_OTHER);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+static int __set_print_fmt(struct trace_uprobe *tp, char *buf, int len)
+{
+	int i;
+	int pos = 0;
+
+	const char *fmt, *arg;
+
+	fmt = "(%lx)";
+	arg = "REC->" FIELD_STRING_IP;
+
+	/* When len=0, we just calculate the needed length */
+#define LEN_OR_ZERO (len ? len - pos : 0)
+
+	pos += snprintf(buf + pos, LEN_OR_ZERO, "\"%s", fmt);
+
+	for (i = 0; i < tp->nr_args; i++) {
+		pos += snprintf(buf + pos, LEN_OR_ZERO, " %s=%s",
+				tp->args[i].name, tp->args[i].type->fmt);
+	}
+
+	pos += snprintf(buf + pos, LEN_OR_ZERO, "\", %s", arg);
+
+	for (i = 0; i < tp->nr_args; i++) {
+		pos += snprintf(buf + pos, LEN_OR_ZERO, ", REC->%s",
+				tp->args[i].name);
+	}
+
+#undef LEN_OR_ZERO
+
+	/* return the length of print_fmt */
+	return pos;
+}
+
+static int set_print_fmt(struct trace_uprobe *tp)
+{
+	int len;
+	char *print_fmt;
+
+	/* First: called with 0 length to calculate the needed length */
+	len = __set_print_fmt(tp, NULL, 0);
+	print_fmt = kmalloc(len + 1, GFP_KERNEL);
+	if (!print_fmt)
+		return -ENOMEM;
+
+	/* Second: actually write the @print_fmt */
+	__set_print_fmt(tp, print_fmt, len + 1);
+	tp->call.print_fmt = print_fmt;
+
+	return 0;
+}
+
+#ifdef CONFIG_PERF_EVENTS
+
+/* uprobe profile handler */
+static void uprobe_perf_func(struct uprobe *up,
+					 struct pt_regs *regs)
+{
+	struct trace_uprobe *tp = container_of(up, struct trace_uprobe, up);
+	struct ftrace_event_call *call = &tp->call;
+	struct uprobe_trace_entry_head *entry;
+	struct hlist_head *head;
+	u8 *data;
+	int size, __size, i;
+	int rctx;
+
+	__size = sizeof(*entry) + tp->size;
+	size = ALIGN(__size + sizeof(u32), sizeof(u64));
+	size -= sizeof(u32);
+	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
+		     "profile buffer not large enough"))
+		return;
+
+	entry = perf_trace_buf_prepare(size, call->event.type, regs, &rctx);
+	if (!entry)
+		return;
+
+	entry->ip = (unsigned long)up->vaddr;
+	data = (u8 *)&entry[1];
+	for (i = 0; i < tp->nr_args; i++)
+		tp_call_fetch(&tp->args[i].fetch, regs,
+						data + tp->args[i].offset);
+
+	head = this_cpu_ptr(call->perf_events);
+	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, regs, head);
+}
+
+static int probe_perf_enable(struct ftrace_event_call *call)
+{
+	int ret = 0;
+	struct trace_uprobe *tp = (struct trace_uprobe *)call->data;
+
+	if (!(tp->flags & TP_FLAG_UPROBE)) {
+		ret = register_uprobe(&tp->up);
+		if (!ret)
+			tp->flags |= (TP_FLAG_UPROBE | TP_FLAG_PROFILE);
+	}
+	return ret;
+}
+
+static void probe_perf_disable(struct ftrace_event_call *call)
+{
+	struct trace_uprobe *tp = (struct trace_uprobe *)call->data;
+
+	if (tp->flags & TP_FLAG_UPROBE) {
+		unregister_uprobe(&tp->up);
+		tp->flags &= ~(TP_FLAG_UPROBE | TP_FLAG_PROFILE);
+	}
+}
+#endif	/* CONFIG_PERF_EVENTS */
+
+static
+int uprobe_register(struct ftrace_event_call *event, enum trace_reg type)
+{
+	switch (type) {
+	case TRACE_REG_REGISTER:
+		return probe_event_enable(event);
+	case TRACE_REG_UNREGISTER:
+		probe_event_disable(event);
+		return 0;
+
+#ifdef CONFIG_PERF_EVENTS
+	case TRACE_REG_PERF_REGISTER:
+		return probe_perf_enable(event);
+	case TRACE_REG_PERF_UNREGISTER:
+		probe_perf_disable(event);
+		return 0;
+#endif
+	}
+	return 0;
+}
+
+static void uprobe_dispatcher(struct uprobe *up, struct pt_regs *regs)
+{
+	struct trace_uprobe *tp = container_of(up, struct trace_uprobe, up);
+
+	if (tp->flags & TP_FLAG_TRACE)
+		uprobe_trace_func(up, regs);
+#ifdef CONFIG_PERF_EVENTS
+	if (tp->flags & TP_FLAG_PROFILE)
+		uprobe_perf_func(up, regs);
+#endif
+}
+
+
+static struct trace_event_functions uprobe_funcs = {
+	.trace		= print_uprobe_event
+};
+
+static int register_uprobe_event(struct trace_uprobe *tp)
+{
+	struct ftrace_event_call *call = &tp->call;
+	int ret;
+
+	/* Initialize ftrace_event_call */
+	INIT_LIST_HEAD(&call->class->fields);
+	call->event.funcs = &uprobe_funcs;
+	call->class->raw_init = tp_event_raw_init;
+	call->class->define_fields = uprobe_event_define_fields;
+	if (set_print_fmt(tp) < 0)
+		return -ENOMEM;
+	ret = register_ftrace_event(&call->event);
+	if (!ret) {
+		kfree(call->print_fmt);
+		return -ENODEV;
+	}
+	call->flags = 0;
+	call->class->reg = uprobe_register;
+	call->data = tp;
+	ret = trace_add_event_call(call);
+	if (ret) {
+		pr_info("Failed to register uprobe event: %s\n", call->name);
+		kfree(call->print_fmt);
+		unregister_ftrace_event(&call->event);
+	}
+	return ret;
+}
+
+static void unregister_uprobe_event(struct trace_uprobe *tp)
+{
+	/* tp->event is unregistered in trace_remove_event_call() */
+	trace_remove_event_call(&tp->call);
+	kfree(tp->call.print_fmt);
+}
+
+/* Make a trace interface for controling probe points */
+static __init int init_uprobe_trace(void)
+{
+	struct dentry *d_tracer;
+	struct dentry *entry;
+
+	d_tracer = tracing_init_dentry();
+	if (!d_tracer)
+		return 0;
+
+	entry = trace_create_file("uprobe_events", 0644, d_tracer,
+				    NULL, &uprobe_events_ops);
+	/* Profile interface */
+	entry = trace_create_file("uprobe_profile", 0444, d_tracer,
+				    NULL, &uprobe_profile_ops);
+	return 0;
+}
+fs_initcall(init_uprobe_trace);
