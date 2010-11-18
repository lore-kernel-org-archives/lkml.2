Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab0KREKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 23:10:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44705 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab0KREJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 23:09:52 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=CnaIoPfr4AYA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=UEjL8U_K-RMWIabbDwEA:9 a=pBO4X4ZwFwW-ToPB680A:7 a=Hdv9UdaAswWp3OjwT4lcvHe7e88A:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101118040949.782054673@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 17 Nov 2010 22:58:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "jason.wessel" <jason.wessel@windriver.com>,
        "Ted Ts'o" <tytso@mit.edu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC][PATCH 2/2] [PATCH 2/2] tracing: Make event based trace_printk()
References: <20101118035803.453609353@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Make-event-based-trace_printk.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Add the trace_printk() that places the usage in the
/debug/tracing/events/printk directory.

Adding a trace_printk() into sched.c at line 2181, we have:

[root@bxf ~]# ls -R /debug/tracing/events/printk/
/debug/tracing/events/printk/:
enable  kernel

/debug/tracing/events/printk/kernel:
enable  sched.c

/debug/tracing/events/printk/kernel/sched.c:
2180  enable

/debug/tracing/events/printk/kernel/sched.c/2180:
enable  format

and

[root@bxf ~]# cat /debug/tracing/events/printk/kernel/sched.c/2180/format
"migrate task %s:%d
"

Note, although the trace_printk's are now in the event directories,
the top level events/enable file does not enable or disable trace_printk
events.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/asm-generic/vmlinux.lds.h |    7 +-
 include/linux/kernel.h            |    2 +
 include/trace/event_printk.h      |   52 ++++++
 kernel/trace/Makefile             |    1 +
 kernel/trace/event_printk.c       |  365 +++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.h              |    1 +
 kernel/trace/trace_events.c       |    2 +-
 7 files changed, 428 insertions(+), 2 deletions(-)
 create mode 100644 include/trace/event_printk.h
 create mode 100644 kernel/trace/event_printk.c

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index bd69d79..e74dac7 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -131,10 +131,14 @@
 #endif
 
 #ifdef CONFIG_TRACING
-#define TRACE_PRINTKS() VMLINUX_SYMBOL(__start___trace_bprintk_fmt) = .;      \
+#define FTRACE_PRINTKS() VMLINUX_SYMBOL(__start___trace_bprintk_fmt) = .;      \
 			 *(__trace_printk_fmt) /* Trace_printk fmt' pointer */ \
 			 VMLINUX_SYMBOL(__stop___trace_bprintk_fmt) = .;
+#define TRACE_PRINTKS()	VMLINUX_SYMBOL(__start_trace_printk) = .;   \
+				*(_trace_printk)		      \
+				VMLINUX_SYMBOL(__stop_trace_printk) = .;
 #else
+#define FTRACE_PRINTKS()
 #define TRACE_PRINTKS()
 #endif
 
@@ -169,6 +173,7 @@
 	LIKELY_PROFILE()		       				\
 	BRANCH_PROFILE()						\
 	TRACE_PRINTKS()							\
+	FTRACE_PRINTKS()						\
 									\
 	STRUCT_ALIGN();							\
 	FTRACE_EVENTS()							\
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 12151e5..8a376d5 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -402,6 +402,8 @@ ftrace_vprintk(const char *fmt, va_list ap)
 static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
 #endif /* CONFIG_TRACING */
 
+#include <trace/event_printk.h>
+
 /*
  * min()/max()/clamp() macros that also do
  * strict type-checking.. See the
diff --git a/include/trace/event_printk.h b/include/trace/event_printk.h
new file mode 100644
index 0000000..8ef9bda
--- /dev/null
+++ b/include/trace/event_printk.h
@@ -0,0 +1,52 @@
+#ifndef _EVENT_PRINTK_H
+#define _EVENT_PRINTK_H
+
+#ifdef CONFIG_TRACING
+#include <linux/jump_label.h>
+
+struct event_printk_struct {
+	const char		*format;
+	const char		*func;
+	const char		*file;
+	int			line;
+	char			enable;
+};
+
+static inline int __event_printk_test(char *key)
+{
+	JUMP_LABEL(key, do_trace);
+	return 0;
+do_trace:
+	return 1;
+}
+
+/* Compiler time bug */
+extern void trace_printk_can_only_have_constant_format(void);
+
+#define trace_printk(fmt, args...)					\
+	do {								\
+		static struct event_printk_struct			\
+		__attribute__((__aligned__(4)))				\
+		__attribute__((section("_trace_printk")))		\
+		______t = {						\
+			.format = fmt,					\
+			.func = __func__,				\
+			.file = __FILE__,				\
+			.line = __LINE__,				\
+		};							\
+		__trace_printk_check_format(fmt, ##args);		\
+		if (!__builtin_constant_p(fmt))				\
+			trace_printk_can_only_have_constant_format();	\
+		if (unlikely(__event_printk_test(&______t.enable)))	\
+			__trace_bprintk(_THIS_IP_, fmt, ##args); \
+	} while (0)
+
+#else
+static inline int
+trace_printk(const char *fmt, ...) __attribute__ ((format (printf, 1, 2)));
+{
+	return 0;
+}
+#endif /* CONFIG_TRACING */
+
+#endif /* _EVENT_PRINTK_H */
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 53f3381..44bea92 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_TRACING) += trace.o
 obj-$(CONFIG_TRACING) += trace_output.o
 obj-$(CONFIG_TRACING) += trace_stat.o
 obj-$(CONFIG_TRACING) += trace_printk.o
+obj-$(CONFIG_TRACING) += event_printk.o
 obj-$(CONFIG_CONTEXT_SWITCH_TRACER) += trace_sched_switch.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace_functions.o
 obj-$(CONFIG_IRQSOFF_TRACER) += trace_irqsoff.o
diff --git a/kernel/trace/event_printk.c b/kernel/trace/event_printk.c
new file mode 100644
index 0000000..1134e3b
--- /dev/null
+++ b/kernel/trace/event_printk.c
@@ -0,0 +1,365 @@
+#include <linux/spinlock.h>
+#include <linux/debugfs.h>
+#include <linux/uaccess.h>
+#include <linux/module.h>
+#include <linux/ctype.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+
+#include <asm/setup.h>
+
+#include "trace.h"
+
+#include <trace/event_printk.h>
+
+extern struct event_printk_struct __start_trace_printk[];
+extern struct event_printk_struct __stop_trace_printk[];
+
+struct printk_nodes {
+	struct printk_nodes		*next;
+	struct dentry			*entry;
+	char				*name;
+	struct printk_nodes		*children;
+	struct event_printk_struct	*print;
+};
+
+static struct printk_nodes	*printk_nodes;
+struct dentry			*printk_root;
+
+#define for_each_printk(p, start, end)			\
+	for (p = start;					\
+	     (unsigned long)p < (unsigned long)end;	\
+	     p++)
+
+static struct printk_nodes *find_node(struct printk_nodes *list, char *name)
+{
+	struct printk_nodes *item;
+
+	for (item = list; item; item = item->next) {
+		if (strcmp(name, item->name) == 0)
+			break;
+	}
+	return item;
+}
+
+static int find_set(struct printk_nodes *node, int set, int paranoid)
+{
+	/* If we already have a mixture, just finish */
+	if (set == 3)
+		return set;
+
+	/* If this is a leaf, return its enabled node */
+	if (node && node->print)
+		return set | (1 << !!node->print->enable);
+
+	if (WARN_ONCE(paranoid > 9, "Printk directories too deep"))
+		return set;
+
+	if (!node)
+		node = printk_nodes;
+	else
+		node = node->children;
+
+	for (; node; node = node->next) {
+		set |= find_set(node, set, paranoid + 1);
+		if (set == 3)
+			break;
+	}
+
+	return set;
+}
+
+static int update_values(struct printk_nodes *node, int val, int paranoid)
+{
+	int ret = 0;
+
+	/* For leaf nodes just update the print */
+	if (node && node->print) {
+		if (!node->print->enable && val) {
+			jump_label_enable(&node->print->enable);
+			node->print->enable = val;
+		} else if (node->print->enable && !val) {
+			jump_label_disable(&node->print->enable);
+			node->print->enable = val;
+		}
+		return 0;
+	}
+
+	if (WARN_ONCE(paranoid > 9, "Printk directories too deep"))
+		return -EIO;
+
+	if (!node)
+		node = printk_nodes;
+	else
+		node = node->children;
+
+	for (; node; node = node->next) {
+		ret = update_values(node, val, paranoid + 1);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+static ssize_t
+printk_format_read(struct file *filp, char __user *ubuf, size_t cnt,
+		   loff_t *ppos)
+{
+	struct printk_nodes *node = filp->private_data;
+	char *buf;
+	int ret;
+
+	if (!node->print)
+		return -EIO;
+
+	buf = kmalloc(strlen(node->print->format) + 4, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	sprintf(buf, "\"%s\"\n", node->print->format);
+
+	ret = simple_read_from_buffer(ubuf, cnt, ppos, buf, strlen(buf));
+
+	kfree(buf);
+
+	return ret;
+}
+
+static const struct file_operations trace_printk_format_fops = {
+	.open = tracing_open_generic,
+	.read = printk_format_read,
+};
+
+static ssize_t
+printk_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
+		   loff_t *ppos)
+{
+	const char set_to_char[4] = { '?', '0', '1', 'X' };
+	struct printk_nodes *node = filp->private_data;
+	char buf[2];
+	int set;
+	int ret;
+
+	set = find_set(node, 0, 0);
+
+	buf[0] = set_to_char[set];
+	buf[1] = '\n';
+
+	ret = simple_read_from_buffer(ubuf, cnt, ppos, buf, 2);
+
+	return ret;
+}
+
+static ssize_t
+printk_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
+		    loff_t *ppos)
+{
+	struct printk_nodes *node = filp->private_data;
+	unsigned long val;
+	char buf[64];
+	ssize_t ret;
+
+	if (cnt >= sizeof(buf))
+		return -EINVAL;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+
+	buf[cnt] = 0;
+
+	ret = strict_strtoul(buf, 10, &val);
+	if (ret < 0)
+		return ret;
+
+	ret = tracing_update_buffers();
+	if (ret < 0)
+		return ret;
+
+	if (val != 0 && val != 1)
+		return -EINVAL;
+
+	ret = update_values(node, val, 0);
+	if (ret)
+		goto out;
+
+	ret = cnt;
+
+out:
+	*ppos += cnt;
+
+	return ret;
+}
+
+static const struct file_operations trace_printk_enable_fops = {
+	.open = tracing_open_generic,
+	.read = printk_enable_read,
+	.write = printk_enable_write,
+	.llseek = default_llseek,
+};
+
+static struct printk_nodes *
+add_node(struct printk_nodes *parent, const char *p, int len)
+{
+	struct printk_nodes **list;
+	struct printk_nodes *item;
+	struct dentry *dentry;
+	char *name;
+
+	if (!parent) {
+		list = &printk_nodes;
+		dentry = printk_root;
+	} else {
+		list = &parent->children;
+		dentry = parent->entry;
+	}
+
+	name = kstrndup(p, len, GFP_KERNEL);
+	if (WARN_ON(!name))
+		return NULL;
+
+	item = find_node(*list, name);
+
+	if (item) {
+		kfree(name);
+		return item;
+	}
+
+	item = kzalloc(sizeof(*item), GFP_KERNEL);
+	if (WARN_ON(!item)) {
+		kfree(name);
+		return NULL;
+	}
+	item->name = name;
+	item->entry = debugfs_create_dir(name, dentry);
+	if (WARN_ON(!item->entry)) {
+		kfree(name);
+		kfree(item);
+		return NULL;
+	}
+	trace_create_file("enable", 0644, item->entry,
+			  item, &trace_printk_enable_fops);
+	item->next = *list;
+	*list = item;
+	return item;
+}
+
+static struct printk_nodes *
+process_parent(struct printk_nodes *parent, const char *p, int len)
+{
+	struct printk_nodes *node;
+
+	node = add_node(parent, p, len);
+	if (!node)
+		return NULL;
+
+	return node;
+}
+
+static void
+process_leaf(struct printk_nodes *parent,
+	     struct event_printk_struct *print, const char *p)
+{
+	struct printk_nodes *dir;
+	struct printk_nodes *node;
+	char buf[30];
+	int i=0;
+
+	dir = add_node(parent, p, strlen(p));
+	if (!dir)
+		return;
+
+	/*
+	 * Make sure this is a unique node. If more than one trace_printk
+	 * is on the same line (probably do to macros) then just append
+	 * a -# to the name.
+	 */
+
+	snprintf(buf, 30, "%d", print->line);
+	while ((node = find_node(dir->children, buf)))
+		snprintf(buf, 30, "%d-%d", print->line, ++i);
+	node = add_node(dir, buf, strlen(buf));
+	if (!node)
+		return;
+
+	trace_create_file("format", 0644, node->entry,
+			  node, &trace_printk_format_fops);
+
+	node->print = print;
+}
+
+static void add_event_printk(const char *topdir, int len,
+			     struct event_printk_struct *print)
+{
+	struct printk_nodes *parent = NULL;
+	const char *p;
+	const char *n;
+
+	if (WARN_ON_ONCE(strncmp(topdir, print->file, len) != 0)) {
+		printk(KERN_INFO "Entry \"%s\" not in path \"%s\"\n",
+		       print->file, topdir);
+		return;
+	}
+
+	for (p = print->file + len; p; p = n) {
+		n = strstr(p, "/");
+		if (n) {
+			parent = process_parent(parent, p, n - p);
+			n++;
+		} else
+			process_leaf(parent, print, p);
+	}
+}
+
+static __init int event_printk_init(void)
+{
+	struct event_printk_struct *print;
+	struct dentry *d_events;
+	char *topdir;
+	char *p;
+	int len;
+	int ret = -1;
+
+	/*
+	 * Do nothing if we have no trace printks.
+	 * May change in the future when we support modules.
+	 */
+	if (__start_trace_printk == __stop_trace_printk)
+		return 0;
+
+	/*
+	 * Use this file to find the path for other
+	 * files. That is, __FILE__ returns the full path,
+	 * but we don't want the top dir path, so we must
+	 * chop it off. We know the path of this file as it
+	 * is (kernel/trace/event_printk.c), so we simply
+	 * cut that off and then we have the path to cut
+	 * off of other files.
+	 */
+	topdir = kstrdup(__FILE__, GFP_KERNEL);
+	if (WARN(!topdir, "failed to allocate printk info"))
+		return -1;
+
+	p = strstr(topdir, "kernel/trace/event_printk.c");
+	if (WARN(!p, "event_printk.c not found. Did the file move?"))
+		goto out;
+	*p = '\0';
+
+	d_events = event_trace_events_dir();
+
+	printk_root = debugfs_create_dir("printk", d_events);
+	if (WARN(!printk_root, "Could not create printk entry"))
+		goto out;
+
+	trace_create_file("enable", 0644, printk_root,
+			  NULL, &trace_printk_enable_fops);
+
+	len = strlen(topdir);
+	for_each_printk(print, __start_trace_printk, __stop_trace_printk)
+		add_event_printk(topdir, len, print);
+
+ out:
+	kfree(topdir);
+	return ret;
+}
+fs_initcall(event_printk_init);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 9021f8c..c99c79f 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -295,6 +295,7 @@ struct dentry *trace_create_file(const char *name,
 				 const struct file_operations *fops);
 
 struct dentry *tracing_init_dentry(void);
+struct dentry *event_trace_events_dir(void);
 
 struct ring_buffer_event;
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 0725eea..4e96e09 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -975,7 +975,7 @@ static const struct file_operations ftrace_show_header_fops = {
 	.llseek = default_llseek,
 };
 
-static struct dentry *event_trace_events_dir(void)
+struct dentry *event_trace_events_dir(void)
 {
 	static struct dentry *d_tracer;
 	static struct dentry *d_events;
-- 
1.7.1


