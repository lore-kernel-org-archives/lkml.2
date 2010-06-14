Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab0FNIbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 04:31:52 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:49542 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab0FNIbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 04:31:48 -0400
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
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 14 Jun 2010 13:59:53 +0530
Message-Id: <20100614082953.29068.76083.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100614082748.29068.21995.sendpatchset@localhost6.localdomain6>
References: <20100614082748.29068.21995.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v5 10/14] trace: Common code for kprobes/uprobes traceevents
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

share_traceevents.patch.

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Changelog from v5: Addressed comments from Masami.
        Also shared lot more code from kprobes traceevents.

Move common parts of trace_kprobe.c and trace_uprobec.
Adjust kernel/trace/trace_kprobe.c after moving common code to
kernel/trace/trace_probe.h. However they still have few duplicate
functions.

TODO: Merge both events to a single probe event.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

 kernel/trace/trace_kprobe.c |  141 +--------------------------------------
 kernel/trace/trace_probe.h  |  157 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 161 insertions(+), 137 deletions(-)
 create mode 100644 kernel/trace/trace_probe.h


diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index f52b5f5..f546e73 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -20,32 +20,12 @@
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
-#include <linux/stringify.h>
-#include <asm/bitsperlong.h>
-
-#include "trace.h"
-#include "trace_output.h"
-
-#define MAX_TRACE_ARGS 128
-#define MAX_ARGSTR_LEN 63
-#define MAX_EVENT_NAME_LEN 64
-#define KPROBE_EVENT_SYSTEM "kprobes"
 
-/* Reserved field names */
-#define FIELD_STRING_IP "__probe_ip"
-#define FIELD_STRING_RETIP "__probe_ret_ip"
-#define FIELD_STRING_FUNC "__probe_func"
+#include "trace_probe.h"
+
+#define KPROBE_EVENT_SYSTEM "kprobes"
 
-const char *reserved_field_names[] = {
+static const char *reserved_field_names[] = {
 	"common_type",
 	"common_flags",
 	"common_preempt_count",
@@ -57,70 +37,9 @@ const char *reserved_field_names[] = {
 	FIELD_STRING_FUNC,
 };
 
-/* Printing function type */
-typedef int (*print_type_func_t)(struct trace_seq *, const char *, void *);
-#define PRINT_TYPE_FUNC_NAME(type)	print_type_##type
-#define PRINT_TYPE_FMT_NAME(type)	print_type_format_##type
-
-/* Printing  in basic type function template */
-#define DEFINE_BASIC_PRINT_TYPE_FUNC(type, fmt, cast)			\
-static __kprobes int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s,	\
-						const char *name, void *data)\
-{									\
-	return trace_seq_printf(s, " %s=" fmt, name, (cast)*(type *)data);\
-}									\
-static const char PRINT_TYPE_FMT_NAME(type)[] = fmt;
-
-DEFINE_BASIC_PRINT_TYPE_FUNC(u8, "%x", unsigned int)
-DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "%x", unsigned int)
-DEFINE_BASIC_PRINT_TYPE_FUNC(u32, "%lx", unsigned long)
-DEFINE_BASIC_PRINT_TYPE_FUNC(u64, "%llx", unsigned long long)
-DEFINE_BASIC_PRINT_TYPE_FUNC(s8, "%d", int)
-DEFINE_BASIC_PRINT_TYPE_FUNC(s16, "%d", int)
 DEFINE_BASIC_PRINT_TYPE_FUNC(s32, "%ld", long)
 DEFINE_BASIC_PRINT_TYPE_FUNC(s64, "%lld", long long)
 
-/* Data fetch function type */
-typedef	void (*fetch_func_t)(struct pt_regs *, void *, void *);
-
-struct fetch_param {
-	fetch_func_t	fn;
-	void *data;
-};
-
-static __kprobes void call_fetch(struct fetch_param *fprm,
-				 struct pt_regs *regs, void *dest)
-{
-	return fprm->fn(regs, fprm->data, dest);
-}
-
-#define FETCH_FUNC_NAME(kind, type)	fetch_##kind##_##type
-/*
- * Define macro for basic types - we don't need to define s* types, because
- * we have to care only about bitwidth at recording time.
- */
-#define DEFINE_BASIC_FETCH_FUNCS(kind)  \
-DEFINE_FETCH_##kind(u8)			\
-DEFINE_FETCH_##kind(u16)		\
-DEFINE_FETCH_##kind(u32)		\
-DEFINE_FETCH_##kind(u64)
-
-#define CHECK_BASIC_FETCH_FUNCS(kind, fn)	\
-	((FETCH_FUNC_NAME(kind, u8) == fn) ||	\
-	 (FETCH_FUNC_NAME(kind, u16) == fn) ||	\
-	 (FETCH_FUNC_NAME(kind, u32) == fn) ||	\
-	 (FETCH_FUNC_NAME(kind, u64) == fn))
-
-/* Data fetch function templates */
-#define DEFINE_FETCH_reg(type)						\
-static __kprobes void FETCH_FUNC_NAME(reg, type)(struct pt_regs *regs,	\
-					  void *offset, void *dest)	\
-{									\
-	*(type *)dest = (type)regs_get_register(regs,			\
-				(unsigned int)((unsigned long)offset));	\
-}
-DEFINE_BASIC_FETCH_FUNCS(reg)
-
 #define DEFINE_FETCH_stack(type)					\
 static __kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,\
 					  void *offset, void *dest)	\
@@ -234,15 +153,6 @@ static __kprobes void free_deref_fetch_param(struct deref_fetch_param *data)
 	kfree(data);
 }
 
-/* Default (unsigned long) fetch type */
-#define __DEFAULT_FETCH_TYPE(t) u##t
-#define _DEFAULT_FETCH_TYPE(t) __DEFAULT_FETCH_TYPE(t)
-#define DEFAULT_FETCH_TYPE _DEFAULT_FETCH_TYPE(BITS_PER_LONG)
-#define DEFAULT_FETCH_TYPE_STR __stringify(DEFAULT_FETCH_TYPE)
-
-#define ASSIGN_FETCH_FUNC(kind, type)	\
-	.kind = FETCH_FUNC_NAME(kind, type)
-
 #define ASSIGN_FETCH_TYPE(ptype, ftype, sign)	\
 	{.name = #ptype,			\
 	 .size = sizeof(ftype),			\
@@ -306,18 +216,6 @@ static __kprobes void fetch_stack_address(struct pt_regs *regs,
  * Kprobe event core functions
  */
 
-struct probe_arg {
-	struct fetch_param	fetch;
-	unsigned int		offset;	/* Offset from argument entry */
-	const char		*name;	/* Name of this argument */
-	const char		*comm;	/* Command of this argument */
-	const struct fetch_type	*type;	/* Type of this argument */
-};
-
-/* Flags for trace_probe */
-#define TP_FLAG_TRACE	1
-#define TP_FLAG_PROFILE	2
-
 struct trace_probe {
 	struct list_head	list;
 	struct kretprobe	rp;	/* Use rp.kp for kprobe use */
@@ -355,19 +253,6 @@ static LIST_HEAD(probe_list);
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
@@ -537,8 +422,6 @@ static int split_symbol_offset(char *symbol, unsigned long *offset)
 	return 0;
 }
 
-#define PARAM_MAX_ARGS 16
-#define PARAM_MAX_STACK (THREAD_SIZE / sizeof(unsigned long))
 
 static int parse_probe_vars(char *arg, const struct fetch_type *t,
 			    struct fetch_param *f, int is_return)
@@ -1214,22 +1097,6 @@ static void probe_event_disable(struct ftrace_event_call *call)
 	}
 }
 
-static int probe_event_raw_init(struct ftrace_event_call *event_call)
-{
-	return 0;
-}
-
-#undef DEFINE_FIELD
-#define DEFINE_FIELD(type, item, name, is_signed)			\
-	do {								\
-		ret = trace_define_field(event_call, #type, name,	\
-					 offsetof(typeof(field), item),	\
-					 sizeof(field.item), is_signed, \
-					 FILTER_OTHER);			\
-		if (ret)						\
-			return ret;					\
-	} while (0)
-
 static int kprobe_event_define_fields(struct ftrace_event_call *event_call)
 {
 	int ret, i;
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
new file mode 100644
index 0000000..b4c5763
--- /dev/null
+++ b/kernel/trace/trace_probe.h
@@ -0,0 +1,157 @@
+/*
+ * Common header file for probe-based Dynamic events.
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
+
+/* Reserved field names */
+#define FIELD_STRING_IP "__probe_ip"
+#define FIELD_STRING_RETIP "__probe_ret_ip"
+#define FIELD_STRING_FUNC "__probe_func"
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
+/* Printing function type */
+typedef int (*print_type_func_t)(struct trace_seq *, const char *, void *);
+#define PRINT_TYPE_FUNC_NAME(type)	print_type_##type
+#define PRINT_TYPE_FMT_NAME(type)	print_type_format_##type
+
+/* Printing  in basic type function template */
+#define DEFINE_BASIC_PRINT_TYPE_FUNC(type, fmt, cast)			\
+static __kprobes int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s,	\
+						const char *name, void *data)\
+{									\
+	return trace_seq_printf(s, " %s=" fmt, name, (cast)*(type *)data);\
+}									\
+static const char PRINT_TYPE_FMT_NAME(type)[] = fmt;
+
+DEFINE_BASIC_PRINT_TYPE_FUNC(u8, "%x", unsigned int)
+DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "%x", unsigned int)
+DEFINE_BASIC_PRINT_TYPE_FUNC(u32, "%lx", unsigned long)
+DEFINE_BASIC_PRINT_TYPE_FUNC(u64, "%llx", unsigned long long)
+DEFINE_BASIC_PRINT_TYPE_FUNC(s8, "%d", int)
+DEFINE_BASIC_PRINT_TYPE_FUNC(s16, "%d", int)
+
+/* Data fetch function type */
+typedef	void (*fetch_func_t)(struct pt_regs *, void *, void *);
+
+struct fetch_param {
+	fetch_func_t	fn;
+	void *data;
+};
+
+#define FETCH_FUNC_NAME(kind, type)	fetch_##kind##_##type
+/*
+ * Define macro for basic types - we don't need to define s* types, because
+ * we have to care only about bitwidth at recording time.
+ */
+#define DEFINE_BASIC_FETCH_FUNCS(kind)  \
+DEFINE_FETCH_##kind(u8)			\
+DEFINE_FETCH_##kind(u16)		\
+DEFINE_FETCH_##kind(u32)		\
+DEFINE_FETCH_##kind(u64)
+
+#define CHECK_BASIC_FETCH_FUNCS(kind, fn)	\
+	((FETCH_FUNC_NAME(kind, u8) == fn) ||	\
+	 (FETCH_FUNC_NAME(kind, u16) == fn) ||	\
+	 (FETCH_FUNC_NAME(kind, u32) == fn) ||	\
+	 (FETCH_FUNC_NAME(kind, u64) == fn))
+
+/* Data fetch function templates */
+#define DEFINE_FETCH_reg(type)						\
+static __kprobes void FETCH_FUNC_NAME(reg, type)(struct pt_regs *regs,	\
+					  void *offset, void *dest)	\
+{									\
+	*(type *)dest = (type)regs_get_register(regs,			\
+				(unsigned int)((unsigned long)offset));	\
+}
+DEFINE_BASIC_FETCH_FUNCS(reg)
+
+/* Default (unsigned long) fetch type */
+#define __DEFAULT_FETCH_TYPE(t) u##t
+#define _DEFAULT_FETCH_TYPE(t) __DEFAULT_FETCH_TYPE(t)
+#define DEFAULT_FETCH_TYPE _DEFAULT_FETCH_TYPE(BITS_PER_LONG)
+#define DEFAULT_FETCH_TYPE_STR __stringify(DEFAULT_FETCH_TYPE)
+
+#define ASSIGN_FETCH_FUNC(kind, type)	\
+	.kind = FETCH_FUNC_NAME(kind, type)
+
+/* Flags for trace_probe */
+#define TP_FLAG_TRACE	1
+#define TP_FLAG_PROFILE	2
+
+#define PARAM_MAX_ARGS 16
+#define PARAM_MAX_STACK (THREAD_SIZE / sizeof(unsigned long))
+
+struct probe_arg {
+	struct fetch_param	fetch;
+	unsigned int		offset;	/* Offset from argument entry */
+	const char		*name;	/* Name of this argument */
+	const char		*comm;	/* Command of this argument */
+	const struct fetch_type	*type;	/* Type of this argument */
+};
+
+static __kprobes void call_fetch(struct fetch_param *fprm,
+				 struct pt_regs *regs, void *dest)
+{
+	return fprm->fn(regs, fprm->data, dest);
+}
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
+static int probe_event_raw_init(struct ftrace_event_call *event_call)
+{
+	return 0;
+}
