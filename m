Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759586Ab0EFSDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 14:03:39 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:33371 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759423Ab0EFSDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 14:03:34 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 06 May 2010 23:33:26 +0530
Message-Id: <20100506180326.28877.52640.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100506180139.28877.81699.sendpatchset@localhost6.localdomain6>
References: <20100506180139.28877.81699.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v3 9/10] trace: uprobes trace_event interface
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uprobes_trace_events.patch

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

The following patch implements trace_event support for uprobes. In its
current form it can be used to put probes at a specified text address
in a process and dump the required registers when the code flow reaches
the probed address.

This is based on trace_events for kprobes to the extent that it may
resemble that file on 2.6.34-rc3.

The following example shows how to dump the instruction pointer and %ax a
register at the probed text address.

Start a process to trace. Get the address to trace.
  [Here pid is asssumed as 3548]
  [Address to trace is 0x0000000000446420]
  [Registers to be dumped are %ip and %ax]

# cd /sys/kernel/debug/tracing/
# echo 'p 3548:0x0000000000446420 %ip %ax' > uprobe_events
# cat uprobe_events
p:uprobes/p_3548_0x0000000000446420 3548:0x0000000000446420 %ip=%ip %ax=%ax
# cat events/uprobes/p_3548_0x0000000000446420/enable
0
[enable the event]
# echo 1 > events/uprobes/p_3548_0x0000000000446420/enable
# cat events/uprobes/p_3548_0x0000000000446420/enable
1
# #### do some activity on the program so that it hits the breakpoint
# cat uprobe_profile
  3548 p_3548_0x0000000000446420                                234
# tracer: nop
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
           <...>-3548  [001]   294.285812: p_3548_0x0000000000446420: (0x446420) %ip=446421 %ax=1
           <...>-3548  [001]   294.285884: p_3548_0x0000000000446420: (0x446420) %ip=446421 %ax=1
           <...>-3548  [001]   294.285894: p_3548_0x0000000000446420: (0x446420) %ip=446421 %ax=1
           <...>-3548  [001]   294.285903: p_3548_0x0000000000446420: (0x446420) %ip=446421 %ax=1
           <...>-3548  [001]   294.285912: p_3548_0x0000000000446420: (0x446420) %ip=446421 %ax=1
           <...>-3548  [001]   294.285922: p_3548_0x0000000000446420: (0x446420) %ip=446421 %ax=1

TODO: Documentation/trace/uprobetrace.txt

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

 kernel/trace/Kconfig        |    8 
 kernel/trace/Makefile       |    1 
 kernel/trace/trace.h        |   12 +
 kernel/trace/trace_uprobe.c |  927 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 948 insertions(+), 0 deletions(-)
 create mode 100644 kernel/trace/trace_uprobe.c


diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 13e13d4..1435e09 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -557,6 +557,14 @@ config RING_BUFFER_BENCHMARK
 
 	  If unsure, say N.
 
+config UPROBE_EVENT
+	depends on UPROBES
+	bool "Enable uprobes-based dynamic events"
+	select TRACING
+	default y
+	help
+	  This allows the user to add tracing events (similar to tracepoints)
+	  on the fly via the traceevents interface.
 endif # FTRACE
 
 endif # TRACING_SUPPORT
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 78edc64..8911959 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -58,5 +58,6 @@ obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
 obj-$(CONFIG_KPROBE_EVENT) += trace_kprobe.o
 obj-$(CONFIG_KSYM_TRACER) += trace_ksym.o
 obj-$(CONFIG_EVENT_TRACING) += power-traces.o
+obj-$(CONFIG_UPROBE_EVENT) += trace_uprobe.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 2825ef2..9fe02ab 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -126,6 +126,18 @@ struct kretprobe_trace_entry {
 	(offsetof(struct kretprobe_trace_entry, args) +	\
 	(sizeof(unsigned long) * (n)))
 
+struct uprobe_trace_entry {
+	struct trace_entry	ent;
+	pid_t			pid;
+	unsigned long		ip;
+	int			nargs;
+	unsigned long		args[];
+};
+
+#define SIZEOF_UPROBE_TRACE_ENTRY(n)			\
+	(offsetof(struct uprobe_trace_entry, args) +	\
+	(sizeof(unsigned long) * (n)))
+
 /*
  * trace_flag_type is an enumeration that holds different
  * states when a trace occurs. These are:
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
new file mode 100644
index 0000000..8c48818
--- /dev/null
+++ b/kernel/trace/trace_uprobe.c
@@ -0,0 +1,927 @@
+/*
+ * Uprobes-based tracing events
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
+#include <linux/seq_file.h>
+#include <linux/debugfs.h>
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/ctype.h>
+#include <linux/ptrace.h>
+#include <linux/perf_event.h>
+#include <linux/slab.h>
+
+#include "trace.h"
+#include "trace_output.h"
+
+#define MAX_TRACE_ARGS 128
+#define MAX_ARGSTR_LEN 63
+#define MAX_EVENT_NAME_LEN 64
+#define UPROBE_EVENT_SYSTEM "uprobes"
+
+/* Reserved field names */
+#define FIELD_STRING_IP "__probe_ip"
+#define FIELD_STRING_NARGS "__probe_nargs"
+#define FIELD_STRING_PID "__probe_pid"
+
+const char *ureserved_field_names[] = {
+	"common_type",
+	"common_flags",
+	"common_preempt_count",
+	"common_pid",
+	"common_tgid",
+	"common_lock_depth",
+	FIELD_STRING_IP,
+	FIELD_STRING_NARGS,
+	FIELD_STRING_PID,
+};
+
+struct fetch_func {
+	unsigned long (*func)(struct pt_regs *, void *);
+	void *data;
+};
+
+static unsigned long call_fetch(struct fetch_func *f,
+					  struct pt_regs *regs)
+{
+	return f->func(regs, f->data);
+}
+
+/* fetch handlers */
+static  unsigned long fetch_register(struct pt_regs *regs,
+					      void *offset)
+{
+	return regs_get_register(regs, (unsigned int)((unsigned long)offset));
+}
+
+/**
+ * Uprobe event core functions
+ */
+
+/* Flags for trace_probe */
+#define TP_FLAG_TRACE	1
+#define TP_FLAG_PROFILE	2
+#define UPROBE_ENABLED	4
+
+struct probe_arg {
+	struct fetch_func	fetch;
+	const char		*name;
+};
+
+struct trace_uprobe {
+	struct list_head	list;
+	struct uprobe		up;
+	unsigned long		nhit;
+	unsigned int		flags;	/* For TP_FLAG_* */
+	struct ftrace_event_call	call;
+	struct trace_event		event;
+	unsigned int		nr_args;
+	struct probe_arg	args[];
+};
+
+#define SIZEOF_TRACE_UPROBE(n)			\
+	(offsetof(struct trace_uprobe, args) +	\
+	(sizeof(struct probe_arg) * (n)))
+
+static int probe_arg_string(char *buf, size_t n, struct fetch_func *ff)
+{
+	int ret = -EINVAL;
+
+	if (ff->func == fetch_register) {
+		const char *name;
+		name = regs_query_register_name((unsigned int)((long)ff->data));
+		ret = snprintf(buf, n, "%%%s", name);
+	}
+	if (ret >= n)
+		return -ENOSPC;
+	return ret;
+}
+
+static int register_uprobe_event(struct trace_uprobe *tp);
+static void unregister_uprobe_event(struct trace_uprobe *tp);
+
+static DEFINE_MUTEX(uprobe_lock);
+static LIST_HEAD(uprobe_list);
+
+static void uprobe_dispatcher(struct uprobe *up, struct pt_regs *regs);
+
+/* Check the name is good for event/group */
+static int check_event_name(const char *name)
+{
+	if (!isalpha(*name) && *name != '_')
+		return 0;
+	while (*++name != '\0') {
+		if (!isalpha(*name) && !isdigit(*name) && *name != '_')
+			return 0;
+	}
+	return 1;
+}
+
+/*
+ * Allocate new trace_uprobe and initialize it (including uprobes).
+ */
+static struct trace_uprobe *alloc_trace_uprobe(const char * group,
+					const char *event,
+					void *addr,
+					pid_t pid, int nargs)
+{
+	struct trace_uprobe *tp;
+	int ret = -ENOMEM;
+
+	if (!event || !check_event_name(event))
+		return ERR_PTR(-EINVAL);
+
+	if (!group || !check_event_name(group))
+		return ERR_PTR(-EINVAL);
+
+	tp = kzalloc(SIZEOF_TRACE_UPROBE(nargs), GFP_KERNEL);
+	if (!tp)
+		return ERR_PTR(ret);
+
+	tp->up.vaddr = (unsigned long)addr;
+	tp->up.pid = pid;
+	tp->up.handler = uprobe_dispatcher;
+
+	tp->call.name = kstrdup(event, GFP_KERNEL);
+	if (!tp->call.name)
+		goto error;
+
+	tp->call.system = kstrdup(group, GFP_KERNEL);
+	if (!tp->call.system)
+		goto error;
+
+	INIT_LIST_HEAD(&tp->list);
+	return tp;
+error:
+	kfree(tp->call.name);
+	kfree(tp);
+	return ERR_PTR(ret);
+}
+
+static void free_probe_arg(struct probe_arg *arg)
+{
+	kfree(arg->name);
+}
+
+static void free_trace_uprobe(struct trace_uprobe *tp)
+{
+	int i;
+
+	for (i = 0; i < tp->nr_args; i++)
+		free_probe_arg(&tp->args[i]);
+
+	kfree(tp->call.system);
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
+		    strcmp(tp->call.system, group) == 0)
+			return tp;
+	return NULL;
+}
+
+/* Unregister a trace_uprobe and probe_event: call with locking uprobe_lock */
+static void unregister_trace_uprobe(struct trace_uprobe *tp)
+{
+	if (tp->flags & UPROBE_ENABLED)
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
+	old_tp = find_probe_event(tp->call.name, tp->call.system);
+	if (old_tp) {
+		/* delete old event */
+		unregister_trace_uprobe(old_tp);
+		free_trace_uprobe(old_tp);
+	}
+	ret = register_uprobe_event(tp);
+	if (ret) {
+		pr_warning("Faild to register probe event(%d)\n", ret);
+		goto end;
+	}
+
+	list_add_tail(&tp->list, &uprobe_list);
+end:
+	mutex_unlock(&uprobe_lock);
+	return ret;
+}
+
+#define PARAM_MAX_ARGS 16
+#define PARAM_MAX_STACK (THREAD_SIZE / sizeof(unsigned long))
+
+/* Recursive argument parser */
+static int __parse_probe_arg(char *arg, struct fetch_func *ff)
+{
+	int ret = 0;
+
+	switch (arg[0]) {
+	case '%':	/* named register */
+		ret = regs_query_register_offset(arg + 1);
+		if (ret >= 0) {
+			ff->func = fetch_register;
+			ff->data = (void *)(unsigned long)ret;
+			ret = 0;
+		}
+		break;
+	default:
+		/* TODO: support custom handler */
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
+/* String length checking wrapper */
+static int parse_probe_arg(char *arg, struct fetch_func *ff)
+{
+	if (strlen(arg) > MAX_ARGSTR_LEN) {
+		pr_info("Argument is too long.: %s\n",  arg);
+		return -ENOSPC;
+	}
+	return __parse_probe_arg(arg, ff);
+}
+
+/* Return 1 if name is reserved or already used by another argument */
+static int conflict_field_name(const char *name,
+			       struct probe_arg *args, int narg)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(ureserved_field_names); i++)
+		if (strcmp(ureserved_field_names[i], name) == 0)
+			return 1;
+	for (i = 0; i < narg; i++)
+		if (strcmp(args[i].name, name) == 0)
+			return 1;
+	return 0;
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
+		tp = find_probe_event(event, group);
+		if (!tp) {
+			pr_info("Event %s/%s doesn't exist.\n", group, event);
+			return -ENOENT;
+		}
+		/* delete an event */
+		unregister_trace_uprobe(tp);
+		free_trace_uprobe(tp);
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
+		if (conflict_field_name(argv[i], tp->args, i)) {
+			pr_info("Argument%d name '%s' conflicts with "
+				"another field.\n", i, argv[i]);
+			ret = -EINVAL;
+			goto error;
+		}
+
+		tp->args[i].name = kstrdup(argv[i], GFP_KERNEL);
+		if (!tp->args[i].name) {
+			pr_info("Failed to allocate argument%d name '%s'.\n",
+				i, argv[i]);
+			ret = -ENOMEM;
+			goto error;
+		}
+
+		/* Parse fetch argument */
+		ret = parse_probe_arg(arg, &tp->args[i].fetch);
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
+	int i, ret;
+	char buf[MAX_ARGSTR_LEN + 1];
+
+	seq_printf(m, "%c", 'p');
+	seq_printf(m, ":%s/%s", tp->call.system, tp->call.name);
+
+	seq_printf(m, " %d:0x%p", tp->up.pid, (void *)tp->up.vaddr);
+
+	for (i = 0; i < tp->nr_args; i++) {
+		ret = probe_arg_string(buf, MAX_ARGSTR_LEN, &tp->args[i].fetch);
+		if (ret < 0) {
+			pr_warning("Argument%d decoding error(%d).\n", i, ret);
+			return ret;
+		}
+		seq_printf(m, " %s=%s", tp->args[i].name, buf);
+	}
+	seq_printf(m, "\n");
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
+static int command_trace_uprobe(const char *buf)
+{
+	char **argv;
+	int argc = 0, ret = 0;
+
+	argv = argv_split(GFP_KERNEL, buf, &argc);
+	if (!argv)
+		return -ENOMEM;
+
+	if (argc)
+		ret = create_trace_uprobe(argc, argv);
+
+	argv_free(argv);
+	return ret;
+}
+
+#define WRITE_BUFSIZE 128
+
+static ssize_t probes_write(struct file *file, const char __user *buffer,
+			    size_t count, loff_t *ppos)
+{
+	char *kbuf, *tmp;
+	int ret;
+	size_t done;
+	size_t size;
+
+	kbuf = kmalloc(WRITE_BUFSIZE, GFP_KERNEL);
+	if (!kbuf)
+		return -ENOMEM;
+
+	ret = done = 0;
+	while (done < count) {
+		size = count - done;
+		if (size >= WRITE_BUFSIZE)
+			size = WRITE_BUFSIZE - 1;
+		if (copy_from_user(kbuf, buffer + done, size)) {
+			ret = -EFAULT;
+			goto out;
+		}
+		kbuf[size] = '\0';
+		tmp = strchr(kbuf, '\n');
+		if (tmp) {
+			*tmp = '\0';
+			size = tmp - kbuf + 1;
+		} else if (done + size < count) {
+			pr_warning("Line length is too long: "
+				   "Should be less than %d.", WRITE_BUFSIZE);
+			ret = -EINVAL;
+			goto out;
+		}
+		done += size;
+		/* Remove comments */
+		tmp = strchr(kbuf, '#');
+		if (tmp)
+			*tmp = '\0';
+
+		ret = command_trace_uprobe(kbuf);
+		if (ret)
+			goto out;
+	}
+	ret = done;
+out:
+	kfree(kbuf);
+	return ret;
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
+/* Uprobe handler */
+static void uprobe_trace_func(struct uprobe *up, struct pt_regs *regs)
+{
+	struct trace_uprobe *tp = container_of(up, struct trace_uprobe, up);
+	struct uprobe_trace_entry *entry;
+	struct ring_buffer_event *event;
+	struct ring_buffer *buffer;
+	int size, i, pc;
+	unsigned long irq_flags;
+	struct ftrace_event_call *call = &tp->call;
+
+	tp->nhit++;
+
+	local_save_flags(irq_flags);
+	pc = preempt_count();
+
+	size = SIZEOF_UPROBE_TRACE_ENTRY(tp->nr_args);
+
+	event = trace_current_buffer_lock_reserve(&buffer, call->id, size,
+						  irq_flags, pc);
+	if (!event)
+		return;
+
+	entry = ring_buffer_event_data(event);
+	entry->nargs = tp->nr_args;
+	entry->ip = (unsigned long)up->vaddr;
+	for (i = 0; i < tp->nr_args; i++)
+		entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
+
+	if (!filter_current_check_discard(buffer, call, entry, event))
+		trace_nowake_buffer_unlock_commit(buffer, event, irq_flags, pc);
+}
+
+/* Event entry printers */
+enum print_line_t
+print_uprobe_event(struct trace_iterator *iter, int flags)
+{
+	struct uprobe_trace_entry *field;
+	struct trace_seq *s = &iter->seq;
+	struct trace_event *event;
+	struct trace_uprobe *tp;
+	int i;
+
+	field = (struct uprobe_trace_entry *)iter->ent;
+	event = ftrace_find_event(field->ent.type);
+	tp = container_of(event, struct trace_uprobe, event);
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
+	for (i = 0; i < field->nargs; i++)
+		if (!trace_seq_printf(s, " %s=%lx",
+				      tp->args[i].name, field->args[i]))
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
+	if (!(tp->flags & UPROBE_ENABLED)) {
+		ret = register_uprobe(&tp->up);
+		if (!ret)
+			tp->flags |= (UPROBE_ENABLED | TP_FLAG_TRACE);
+	}
+	return ret;
+}
+
+static void probe_event_disable(struct ftrace_event_call *call)
+{
+	struct trace_uprobe *tp = (struct trace_uprobe *)call->data;
+
+	if (tp->flags & UPROBE_ENABLED) {
+		unregister_uprobe(&tp->up);
+		tp->flags &= ~(UPROBE_ENABLED | TP_FLAG_TRACE);
+	}
+}
+
+static int probe_event_raw_init(struct ftrace_event_call *event_call)
+{
+	INIT_LIST_HEAD(&event_call->fields);
+
+	return 0;
+}
+
+#undef DEFINE_FIELD
+#define DEFINE_FIELD(type, item, name, is_signed)			\
+	do {								\
+		ret = trace_define_field(event_call, #type, name,	\
+					 offsetof(typeof(field), item),	\
+					 sizeof(field.item), is_signed, \
+					 FILTER_OTHER);			\
+		if (ret)						\
+			return ret;					\
+	} while (0)
+
+static int uprobe_event_define_fields(struct ftrace_event_call *event_call)
+{
+	int ret, i;
+	struct uprobe_trace_entry field;
+	struct trace_uprobe *tp = (struct trace_uprobe *)event_call->data;
+
+	DEFINE_FIELD(unsigned long, ip, FIELD_STRING_IP, 0);
+	DEFINE_FIELD(int, nargs, FIELD_STRING_NARGS, 1);
+	DEFINE_FIELD(pid_t, pid, FIELD_STRING_PID, 2);
+	/* Set argument names as fields */
+	for (i = 0; i < tp->nr_args; i++)
+		DEFINE_FIELD(unsigned long, args[i], tp->args[i].name, 0);
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
+	for (i = 0; i < tp->nr_args; i++)
+		pos += snprintf(buf + pos, LEN_OR_ZERO, " %s=%%lx",
+				tp->args[i].name);
+
+	pos += snprintf(buf + pos, LEN_OR_ZERO, "\", %s", arg);
+	for (i = 0; i < tp->nr_args; i++)
+		pos += snprintf(buf + pos, LEN_OR_ZERO, ", REC->%s",
+				tp->args[i].name);
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
+/* Uprobe profile handler */
+static void uprobe_perf_func(struct uprobe *up,
+					 struct pt_regs *regs)
+{
+	struct trace_uprobe *tp = container_of(up, struct trace_uprobe, up);
+	struct ftrace_event_call *call = &tp->call;
+	struct uprobe_trace_entry *entry;
+	int size, __size, i;
+	unsigned long irq_flags;
+	int rctx;
+
+	__size = SIZEOF_UPROBE_TRACE_ENTRY(tp->nr_args);
+	size = ALIGN(__size + sizeof(u32), sizeof(u64));
+	size -= sizeof(u32);
+	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
+		     "profile buffer not large enough"))
+		return;
+
+	entry = perf_trace_buf_prepare(size, call->id, &rctx, &irq_flags);
+	if (!entry)
+		return;
+
+	entry->nargs = tp->nr_args;
+	entry->ip = (unsigned long)up->vaddr;
+	for (i = 0; i < tp->nr_args; i++)
+		entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
+
+	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, irq_flags, regs);
+}
+
+static int probe_perf_enable(struct ftrace_event_call *call)
+{
+	int ret = 0;
+	struct trace_uprobe *tp = (struct trace_uprobe *)call->data;
+
+	if (!(tp->flags & UPROBE_ENABLED)) {
+		ret = register_uprobe(&tp->up);
+		if (!ret)
+			tp->flags |= (UPROBE_ENABLED | TP_FLAG_PROFILE);
+	}
+	return ret;
+}
+
+static void probe_perf_disable(struct ftrace_event_call *call)
+{
+	struct trace_uprobe *tp = (struct trace_uprobe *)call->data;
+
+	if (tp->flags & UPROBE_ENABLED) {
+		unregister_uprobe(&tp->up);
+		tp->flags &= ~(UPROBE_ENABLED | TP_FLAG_PROFILE);
+	}
+}
+#endif	/* CONFIG_PERF_EVENTS */
+
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
+static int register_uprobe_event(struct trace_uprobe *tp)
+{
+	struct ftrace_event_call *call = &tp->call;
+	int ret;
+
+	/* Initialize ftrace_event_call */
+	tp->event.trace = print_uprobe_event;
+	call->raw_init = probe_event_raw_init;
+	call->define_fields = uprobe_event_define_fields;
+	if (set_print_fmt(tp) < 0)
+		return -ENOMEM;
+
+	call->event = &tp->event;
+	call->id = register_ftrace_event(&tp->event);
+	if (!call->id) {
+		kfree(call->print_fmt);
+		return -ENODEV;
+	}
+
+	call->enabled = 0;
+	call->regfunc = probe_event_enable;
+	call->unregfunc = probe_event_disable;
+
+#ifdef CONFIG_PERF_EVENTS
+	call->perf_event_enable = probe_perf_enable;
+	call->perf_event_disable = probe_perf_disable;
+#endif
+	call->data = tp;
+	ret = trace_add_event_call(call);
+	if (ret) {
+		pr_info("Failed to register uprobe event: %s\n", call->name);
+		kfree(call->print_fmt);
+		unregister_ftrace_event(&tp->event);
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
+/* Make a debugfs interface for controling probe points */
+static __init int init_uprobe_trace(void)
+{
+	struct dentry *d_tracer;
+	struct dentry *entry;
+
+	d_tracer = tracing_init_dentry();
+	if (!d_tracer)
+		return 0;
+
+	entry = debugfs_create_file("uprobe_events", 0644, d_tracer,
+				    NULL, &uprobe_events_ops);
+
+	/* Event list interface */
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'uprobe_events' entry\n");
+
+	/* Profile interface */
+	entry = debugfs_create_file("uprobe_profile", 0444, d_tracer,
+				    NULL, &uprobe_profile_ops);
+
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'uprobe_profile' entry\n");
+	return 0;
+}
+fs_initcall(init_uprobe_trace);
