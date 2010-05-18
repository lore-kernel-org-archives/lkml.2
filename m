Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044Ab0ERRBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 13:01:00 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:33558 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757963Ab0ERRAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 13:00:38 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Tue, 18 May 2010 22:30:24 +0530
Message-Id: <20100518170024.20070.25438.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100518165826.20070.11594.sendpatchset@localhost6.localdomain6>
References: <20100518165826.20070.11594.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v4 10/13] trace: Common code for kprobes/uprobes traceevents
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Move common parts of trace_kprobe.c and adjust
kernel/trace/trace_kprobe.c after moving common code to
kernel/trace/trace_probe.h

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

 kernel/trace/trace_kprobe.c |   76 +----------------------------
 kernel/trace/trace_probe.h  |  111 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 113 insertions(+), 74 deletions(-)
 create mode 100644 kernel/trace/trace_probe.h


diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 1251e36..dc1840a 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -20,42 +20,8 @@
 #include <linux/module.h>
 #include <linux/uaccess.h>
 #include <linux/kprobes.h>
-#include <linux/seq_file.h>
-#include <linux/slab.h>
-#include <linux/smp.h>
-#include <linux/debugfs.h>
-#include <linux/types.h>
-#include <linux/string.h>
-#include <linux/ctype.h>
-#include <linux/ptrace.h>
-#include <linux/perf_event.h>
-
-#include "trace.h"
-#include "trace_output.h"
-
-#define MAX_TRACE_ARGS 128
-#define MAX_ARGSTR_LEN 63
-#define MAX_EVENT_NAME_LEN 64
-#define KPROBE_EVENT_SYSTEM "kprobes"
-
-/* Reserved field names */
-#define FIELD_STRING_IP "__probe_ip"
-#define FIELD_STRING_NARGS "__probe_nargs"
-#define FIELD_STRING_RETIP "__probe_ret_ip"
-#define FIELD_STRING_FUNC "__probe_func"
-
-const char *reserved_field_names[] = {
-	"common_type",
-	"common_flags",
-	"common_preempt_count",
-	"common_pid",
-	"common_tgid",
-	"common_lock_depth",
-	FIELD_STRING_IP,
-	FIELD_STRING_NARGS,
-	FIELD_STRING_RETIP,
-	FIELD_STRING_FUNC,
-};
+
+#include "trace_probe.h"
 
 struct fetch_func {
 	unsigned long (*func)(struct pt_regs *, void *);
@@ -192,10 +158,6 @@ struct probe_arg {
 	const char		*name;
 };
 
-/* Flags for trace_probe */
-#define TP_FLAG_TRACE	1
-#define TP_FLAG_PROFILE	2
-
 struct trace_probe {
 	struct list_head	list;
 	struct kretprobe	rp;	/* Use rp.kp for kprobe use */
@@ -274,19 +236,6 @@ static LIST_HEAD(probe_list);
 static int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs);
 static int kretprobe_dispatcher(struct kretprobe_instance *ri,
 				struct pt_regs *regs);
-
-/* Check the name is good for event/group */
-static int check_event_name(const char *name)
-{
-	if (!isalpha(*name) && *name != '_')
-		return 0;
-	while (*++name != '\0') {
-		if (!isalpha(*name) && !isdigit(*name) && *name != '_')
-			return 0;
-	}
-	return 1;
-}
-
 /*
  * Allocate new trace_probe and initialize it (including kprobes).
  */
@@ -454,9 +403,6 @@ static int split_symbol_offset(char *symbol, unsigned long *offset)
 	return 0;
 }
 
-#define PARAM_MAX_ARGS 16
-#define PARAM_MAX_STACK (THREAD_SIZE / sizeof(unsigned long))
-
 static int parse_probe_vars(char *arg, struct fetch_func *ff, int is_return)
 {
 	int ret = 0;
@@ -835,24 +781,6 @@ static int probes_open(struct inode *inode, struct file *file)
 	return seq_open(file, &probes_seq_op);
 }
 
-static int command_trace_probe(const char *buf)
-{
-	char **argv;
-	int argc = 0, ret = 0;
-
-	argv = argv_split(GFP_KERNEL, buf, &argc);
-	if (!argv)
-		return -ENOMEM;
-
-	if (argc)
-		ret = create_trace_probe(argc, argv);
-
-	argv_free(argv);
-	return ret;
-}
-
-#define WRITE_BUFSIZE 128
-
 static ssize_t probes_write(struct file *file, const char __user *buffer,
 			    size_t count, loff_t *ppos)
 {
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
new file mode 100644
index 0000000..66a4498
--- /dev/null
+++ b/kernel/trace/trace_probe.h
@@ -0,0 +1,111 @@
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
+#include <linux/seq_file.h>
+#include <linux/slab.h>
+#include <linux/smp.h>
+#include <linux/debugfs.h>
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/ctype.h>
+#include <linux/ptrace.h>
+#include <linux/perf_event.h>
+
+#include "trace.h"
+#include "trace_output.h"
+
+#define MAX_TRACE_ARGS 128
+#define MAX_ARGSTR_LEN 63
+#define MAX_EVENT_NAME_LEN 64
+#define UPROBE_EVENT_SYSTEM "uprobes"
+#define KPROBE_EVENT_SYSTEM "kprobes"
+
+/* Reserved field names */
+#define FIELD_STRING_IP "__probe_ip"
+#define FIELD_STRING_NARGS "__probe_nargs"
+#define FIELD_STRING_RETIP "__probe_ret_ip"
+#define FIELD_STRING_FUNC "__probe_func"
+#define FIELD_STRING_PID "__probe_pid"
+
+static const char *reserved_field_names[] = {
+	"common_type",
+	"common_flags",
+	"common_preempt_count",
+	"common_pid",
+	"common_tgid",
+	"common_lock_depth",
+	FIELD_STRING_IP,
+	FIELD_STRING_NARGS,
+	FIELD_STRING_RETIP,
+	FIELD_STRING_FUNC,
+	FIELD_STRING_PID,
+};
+
+/* Flags for trace_probe */
+#define TP_FLAG_TRACE	1
+#define TP_FLAG_PROFILE	2
+#define UPROBE_ENABLED	4
+
+
+/* Check the name is good for event/group */
+static inline int check_event_name(const char *name)
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
+#define PARAM_MAX_ARGS 16
+#define PARAM_MAX_STACK (THREAD_SIZE / sizeof(unsigned long))
+
+static int create_trace_probe(int argc, char **argv);
+static inline int command_trace_probe(const char *buf)
+{
+	char **argv;
+	int argc = 0, ret = 0;
+
+	argv = argv_split(GFP_KERNEL, buf, &argc);
+	if (!argv)
+		return -ENOMEM;
+
+	if (argc)
+		ret = create_trace_probe(argc, argv);
+
+	argv_free(argv);
+	return ret;
+}
+
+#define WRITE_BUFSIZE 128
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
