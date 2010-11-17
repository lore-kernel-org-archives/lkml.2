Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933586Ab0KQBAC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 20:00:02 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35453 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933362Ab0KQA7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 19:59:42 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=9Af13J09wJoA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=3WzRdkubO7ijKibudRIA:9 a=nn8Ic0cjr9VsNJ-k-FIA:7 a=Hhz80NiZCiG1lveO5829Pe0b0F8A:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101117005940.168079730@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 16 Nov 2010 19:54:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC][PATCH 3/5] [PATCH 3/5] tracing/events: Add infrastructure to show stable event formats
References: <20101117005357.024472450@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-events-Add-infrastructure-to-show-stable-eve.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Add the infrastructure to connect to the eventfs filesystem and
create a event directory. Currently, all events are flat. That is
there is no hierarchy. Each stable event has its own directory
in /sys/kernel/events (after the eventfs is mounted there).

Currently only one file exists in each of the event directories.
This file is the format file. The format shows each item
in the stable event. The name of that item, the item's type,
the size of the item (in bits), the count of entries of the item
(if that item is an array), the alignment needed for that item to
be read (arch specific) and the sign of the item.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/events/Makefile       |    2 +-
 kernel/events/event_format.c |   74 ++++++++++++++++++++++++++++++++++++++++++
 kernel/events/event_format.h |   64 ++++++++++++++++++++++++++++++++++++
 3 files changed, 139 insertions(+), 1 deletions(-)
 create mode 100644 kernel/events/event_format.c
 create mode 100644 kernel/events/event_format.h

diff --git a/kernel/events/Makefile b/kernel/events/Makefile
index 86fd7c1..943bda5 100644
--- a/kernel/events/Makefile
+++ b/kernel/events/Makefile
@@ -1 +1 @@
-obj-y += events.o
+obj-y += events.o event_format.o
diff --git a/kernel/events/event_format.c b/kernel/events/event_format.c
new file mode 100644
index 0000000..705948a
--- /dev/null
+++ b/kernel/events/event_format.c
@@ -0,0 +1,74 @@
+/*
+ * event_format.c - code to show events in eventfs
+ *
+ * Copyright (C) 2010 Steven Rostedt <srostedt@redhat.com> Red Hat Inc
+ */
+#include <linux/eventfs.h>
+#include <linux/seq_file.h>
+
+typedef void (*event_format_func)(struct seq_file *m);
+
+static void *f_next(struct seq_file *m, void *v, loff_t *pos)
+{
+
+	if ((*pos)++ == 0)
+		return m->private;
+
+	return NULL;
+}
+
+static void *f_start(struct seq_file *m, loff_t *pos)
+{
+	/* It's all or nothing */
+	if ((*pos)++)
+		return NULL;
+
+	return m->private;
+}
+
+static int f_show(struct seq_file *m, void *v)
+{
+	event_format_func func = m->private;
+
+	if (!v)
+		return 0;
+
+	func(m);
+	return 0;
+}
+
+static void f_stop(struct seq_file *m, void *p)
+{
+}
+
+static const struct seq_operations event_format_seq_ops = {
+	.start		= f_start,
+	.next		= f_next,
+	.stop		= f_stop,
+	.show		= f_show,
+};
+
+static int event_format_open(struct inode *inode, struct file *file)
+{
+	struct seq_file *m;
+	int ret;
+
+	ret = seq_open(file, &event_format_seq_ops);
+	if (ret < 0)
+		return ret;
+
+	m = file->private_data;
+	m->private = inode->i_private;
+
+	return 0;
+}
+
+static const struct file_operations event_format_fops = {
+	.open = event_format_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release,
+};
+
+#include "event_format.h"
+
diff --git a/kernel/events/event_format.h b/kernel/events/event_format.h
new file mode 100644
index 0000000..aa43fc0
--- /dev/null
+++ b/kernel/events/event_format.h
@@ -0,0 +1,64 @@
+/*
+ * event_format.h - code to show events in eventfs
+ *
+ * Copyright (C) 2010 Steven Rostedt <srostedt@redhat.com> Red Hat Inc
+ *
+ * For every stable event a directory is created in the eventfs.
+ * For now, only one file exists in that directory, which is
+ * the format file. This format shows the format of that event as:
+ *
+ * field:name type:type size:bit-size align:alignment signed:signed;
+ *
+ * Or for arrays:
+ *
+ * array:name type:type size:bit-size count:items algin:alignment signed:signed;
+ *
+ * The size is in bits. For the array, the size is of a single entry,
+ * and the count is the number of those entries.
+ */
+#include <linux/ftrace_event.h>
+
+#define STABLE_HEADER_MULTI_READ
+
+#undef __SEP__
+#define __SEP__
+
+#undef __field
+#define __field(type, item)						\
+	seq_printf(m, "\tfield:%s\ttype:%s\tsize:%ld\talign:%ld\tsigned:%d;\n", \
+		   #item, #type, sizeof(type) * 8,			\
+		   __alignof__(type), is_signed_type(type));
+
+#undef __array
+#define __array(type, item, size)					\
+	seq_printf(m, "\tarray:%s\ttype:%s\tsize:%ld\tcount:%d\talign:%ld\tsigned:%d;\n", \
+		   #item, #type, sizeof(type) * 8, size,		\
+		   __alignof__(type), is_signed_type(type));
+
+#define EVENT_STRUCT(s)	s
+
+#undef STABLE_EVENT
+#define STABLE_EVENT(name, estruct)					\
+static void format_##name(struct seq_file *m)				\
+{									\
+	estruct;							\
+}									\
+									\
+static int __init create_stable_##name(void)				\
+{									\
+	struct dentry *entry;						\
+	struct dentry *dir;						\
+									\
+	dir = eventfs_create_dir(#name, NULL);				\
+	if (WARN(!dir, "Unable to create directory %s", #name))		\
+		return -1;						\
+									\
+	entry = eventfs_create_file("format", 0644, dir, format_##name,	\
+				    &event_format_fops);		\
+									\
+	return 0;							\
+}									\
+									\
+fs_initcall(create_stable_##name);
+
+#include <trace/stable_list.h>
-- 
1.7.1


