Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab2B0Jhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 04:37:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44830 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab2B0Jhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 04:37:53 -0500
Date: Mon, 27 Feb 2012 01:37:19 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-02aa3162edaa166a01d193f80ccde890be8b55da@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <1329317514-8131-7-git-send-email-jolsa@redhat.com>
References: <1329317514-8131-7-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace:
  Allow to specify filter field type for ftrace events
Git-Commit-ID: 02aa3162edaa166a01d193f80ccde890be8b55da
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 27 Feb 2012 01:37:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  02aa3162edaa166a01d193f80ccde890be8b55da
Gitweb:     http://git.kernel.org/tip/02aa3162edaa166a01d193f80ccde890be8b55da
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 15 Feb 2012 15:51:53 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 21 Feb 2012 11:08:29 -0500

ftrace: Allow to specify filter field type for ftrace events

Adding FILTER_TRACE_FN event field type for function tracepoint
event, so it can be properly recognized within filtering code.

Currently all fields of ftrace subsystem events share the common
field type FILTER_OTHER. Since the function trace fields need
special care within the filtering code we need to recognize it
properly, hence adding the FILTER_TRACE_FN event type.

Adding filter parameter to the FTRACE_ENTRY macro, to specify the
filter field type for the event.

Link: http://lkml.kernel.org/r/1329317514-8131-7-git-send-email-jolsa@redhat.com

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h       |    1 +
 kernel/trace/trace.h               |   23 +++++++++-------
 kernel/trace/trace_entries.h       |   48 ++++++++++++++++++++++++---------
 kernel/trace/trace_events_filter.c |    7 ++++-
 kernel/trace/trace_export.c        |   51 +++++++++++++++++++----------------
 5 files changed, 83 insertions(+), 47 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 2bf677c..dd478fc 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -245,6 +245,7 @@ enum {
 	FILTER_STATIC_STRING,
 	FILTER_DYN_STRING,
 	FILTER_PTR_STRING,
+	FILTER_TRACE_FN,
 };
 
 #define EVENT_STORAGE_SIZE 128
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 76a1c50..29f93cd 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -56,21 +56,23 @@ enum trace_type {
 #define F_STRUCT(args...)		args
 
 #undef FTRACE_ENTRY
-#define FTRACE_ENTRY(name, struct_name, id, tstruct, print)	\
-	struct struct_name {					\
-		struct trace_entry	ent;			\
-		tstruct						\
+#define FTRACE_ENTRY(name, struct_name, id, tstruct, print, filter)	\
+	struct struct_name {						\
+		struct trace_entry	ent;				\
+		tstruct							\
 	}
 
 #undef TP_ARGS
 #define TP_ARGS(args...)	args
 
 #undef FTRACE_ENTRY_DUP
-#define FTRACE_ENTRY_DUP(name, name_struct, id, tstruct, printk)
+#define FTRACE_ENTRY_DUP(name, name_struct, id, tstruct, printk, filter)
 
 #undef FTRACE_ENTRY_REG
-#define FTRACE_ENTRY_REG(name, struct_name, id, tstruct, print, regfn) \
-	FTRACE_ENTRY(name, struct_name, id, PARAMS(tstruct), PARAMS(print))
+#define FTRACE_ENTRY_REG(name, struct_name, id, tstruct, print,	\
+			 filter, regfn) \
+	FTRACE_ENTRY(name, struct_name, id, PARAMS(tstruct), PARAMS(print), \
+		     filter)
 
 #include "trace_entries.h"
 
@@ -826,12 +828,13 @@ extern const char *__start___trace_bprintk_fmt[];
 extern const char *__stop___trace_bprintk_fmt[];
 
 #undef FTRACE_ENTRY
-#define FTRACE_ENTRY(call, struct_name, id, tstruct, print)		\
+#define FTRACE_ENTRY(call, struct_name, id, tstruct, print, filter)	\
 	extern struct ftrace_event_call					\
 	__attribute__((__aligned__(4))) event_##call;
 #undef FTRACE_ENTRY_DUP
-#define FTRACE_ENTRY_DUP(call, struct_name, id, tstruct, print)		\
-	FTRACE_ENTRY(call, struct_name, id, PARAMS(tstruct), PARAMS(print))
+#define FTRACE_ENTRY_DUP(call, struct_name, id, tstruct, print, filter)	\
+	FTRACE_ENTRY(call, struct_name, id, PARAMS(tstruct), PARAMS(print), \
+		     filter)
 #include "trace_entries.h"
 
 #ifdef CONFIG_PERF_EVENTS
diff --git a/kernel/trace/trace_entries.h b/kernel/trace/trace_entries.h
index 47db7ed..d91eb05 100644
--- a/kernel/trace/trace_entries.h
+++ b/kernel/trace/trace_entries.h
@@ -66,6 +66,8 @@ FTRACE_ENTRY_REG(function, ftrace_entry,
 
 	F_printk(" %lx <-- %lx", __entry->ip, __entry->parent_ip),
 
+	FILTER_TRACE_FN,
+
 	perf_ftrace_event_register
 );
 
@@ -80,7 +82,9 @@ FTRACE_ENTRY(funcgraph_entry, ftrace_graph_ent_entry,
 		__field_desc(	int,		graph_ent,	depth		)
 	),
 
-	F_printk("--> %lx (%d)", __entry->func, __entry->depth)
+	F_printk("--> %lx (%d)", __entry->func, __entry->depth),
+
+	FILTER_OTHER
 );
 
 /* Function return entry */
@@ -100,7 +104,9 @@ FTRACE_ENTRY(funcgraph_exit, ftrace_graph_ret_entry,
 	F_printk("<-- %lx (%d) (start: %llx  end: %llx) over: %d",
 		 __entry->func, __entry->depth,
 		 __entry->calltime, __entry->rettime,
-		 __entry->depth)
+		 __entry->depth),
+
+	FILTER_OTHER
 );
 
 /*
@@ -129,8 +135,9 @@ FTRACE_ENTRY(context_switch, ctx_switch_entry,
 	F_printk("%u:%u:%u  ==> %u:%u:%u [%03u]",
 		 __entry->prev_pid, __entry->prev_prio, __entry->prev_state,
 		 __entry->next_pid, __entry->next_prio, __entry->next_state,
-		 __entry->next_cpu
-		)
+		 __entry->next_cpu),
+
+	FILTER_OTHER
 );
 
 /*
@@ -148,8 +155,9 @@ FTRACE_ENTRY_DUP(wakeup, ctx_switch_entry,
 	F_printk("%u:%u:%u  ==+ %u:%u:%u [%03u]",
 		 __entry->prev_pid, __entry->prev_prio, __entry->prev_state,
 		 __entry->next_pid, __entry->next_prio, __entry->next_state,
-		 __entry->next_cpu
-		)
+		 __entry->next_cpu),
+
+	FILTER_OTHER
 );
 
 /*
@@ -171,7 +179,9 @@ FTRACE_ENTRY(kernel_stack, stack_entry,
 		 "\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n",
 		 __entry->caller[0], __entry->caller[1], __entry->caller[2],
 		 __entry->caller[3], __entry->caller[4], __entry->caller[5],
-		 __entry->caller[6], __entry->caller[7])
+		 __entry->caller[6], __entry->caller[7]),
+
+	FILTER_OTHER
 );
 
 FTRACE_ENTRY(user_stack, userstack_entry,
@@ -187,7 +197,9 @@ FTRACE_ENTRY(user_stack, userstack_entry,
 		 "\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n",
 		 __entry->caller[0], __entry->caller[1], __entry->caller[2],
 		 __entry->caller[3], __entry->caller[4], __entry->caller[5],
-		 __entry->caller[6], __entry->caller[7])
+		 __entry->caller[6], __entry->caller[7]),
+
+	FILTER_OTHER
 );
 
 /*
@@ -204,7 +216,9 @@ FTRACE_ENTRY(bprint, bprint_entry,
 	),
 
 	F_printk("%08lx fmt:%p",
-		 __entry->ip, __entry->fmt)
+		 __entry->ip, __entry->fmt),
+
+	FILTER_OTHER
 );
 
 FTRACE_ENTRY(print, print_entry,
@@ -217,7 +231,9 @@ FTRACE_ENTRY(print, print_entry,
 	),
 
 	F_printk("%08lx %s",
-		 __entry->ip, __entry->buf)
+		 __entry->ip, __entry->buf),
+
+	FILTER_OTHER
 );
 
 FTRACE_ENTRY(mmiotrace_rw, trace_mmiotrace_rw,
@@ -236,7 +252,9 @@ FTRACE_ENTRY(mmiotrace_rw, trace_mmiotrace_rw,
 
 	F_printk("%lx %lx %lx %d %x %x",
 		 (unsigned long)__entry->phys, __entry->value, __entry->pc,
-		 __entry->map_id, __entry->opcode, __entry->width)
+		 __entry->map_id, __entry->opcode, __entry->width),
+
+	FILTER_OTHER
 );
 
 FTRACE_ENTRY(mmiotrace_map, trace_mmiotrace_map,
@@ -254,7 +272,9 @@ FTRACE_ENTRY(mmiotrace_map, trace_mmiotrace_map,
 
 	F_printk("%lx %lx %lx %d %x",
 		 (unsigned long)__entry->phys, __entry->virt, __entry->len,
-		 __entry->map_id, __entry->opcode)
+		 __entry->map_id, __entry->opcode),
+
+	FILTER_OTHER
 );
 
 
@@ -274,6 +294,8 @@ FTRACE_ENTRY(branch, trace_branch,
 
 	F_printk("%u:%s:%s (%u)",
 		 __entry->line,
-		 __entry->func, __entry->file, __entry->correct)
+		 __entry->func, __entry->file, __entry->correct),
+
+	FILTER_OTHER
 );
 
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 76afaee..3da3d0e 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -899,6 +899,11 @@ int filter_assign_type(const char *type)
 	return FILTER_OTHER;
 }
 
+static bool is_function_field(struct ftrace_event_field *field)
+{
+	return field->filter_type == FILTER_TRACE_FN;
+}
+
 static bool is_string_field(struct ftrace_event_field *field)
 {
 	return field->filter_type == FILTER_DYN_STRING ||
@@ -986,7 +991,7 @@ static int init_pred(struct filter_parse_state *ps,
 			fn = filter_pred_strloc;
 		else
 			fn = filter_pred_pchar;
-	} else {
+	} else if (!is_function_field(field)) {
 		if (field->is_signed)
 			ret = strict_strtoll(pred->regex.pattern, 0, &val);
 		else
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index a3dbee6..7b46c9b 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -23,8 +23,10 @@
  * function and thus become accesible via perf.
  */
 #undef FTRACE_ENTRY_REG
-#define FTRACE_ENTRY_REG(name, struct_name, id, tstruct, print, regfn) \
-	FTRACE_ENTRY(name, struct_name, id, PARAMS(tstruct), PARAMS(print))
+#define FTRACE_ENTRY_REG(name, struct_name, id, tstruct, print, \
+			 filter, regfn) \
+	FTRACE_ENTRY(name, struct_name, id, PARAMS(tstruct), PARAMS(print), \
+		     filter)
 
 /* not needed for this file */
 #undef __field_struct
@@ -52,21 +54,22 @@
 #define F_printk(fmt, args...) fmt, args
 
 #undef FTRACE_ENTRY
-#define FTRACE_ENTRY(name, struct_name, id, tstruct, print)	\
-struct ____ftrace_##name {					\
-	tstruct							\
-};								\
-static void __always_unused ____ftrace_check_##name(void)	\
-{								\
-	struct ____ftrace_##name *__entry = NULL;		\
-								\
-	/* force compile-time check on F_printk() */		\
-	printk(print);						\
+#define FTRACE_ENTRY(name, struct_name, id, tstruct, print, filter)	\
+struct ____ftrace_##name {						\
+	tstruct								\
+};									\
+static void __always_unused ____ftrace_check_##name(void)		\
+{									\
+	struct ____ftrace_##name *__entry = NULL;			\
+									\
+	/* force compile-time check on F_printk() */			\
+	printk(print);							\
 }
 
 #undef FTRACE_ENTRY_DUP
-#define FTRACE_ENTRY_DUP(name, struct_name, id, tstruct, print)	\
-	FTRACE_ENTRY(name, struct_name, id, PARAMS(tstruct), PARAMS(print))
+#define FTRACE_ENTRY_DUP(name, struct_name, id, tstruct, print, filter)	\
+	FTRACE_ENTRY(name, struct_name, id, PARAMS(tstruct), PARAMS(print), \
+		     filter)
 
 #include "trace_entries.h"
 
@@ -75,7 +78,7 @@ static void __always_unused ____ftrace_check_##name(void)	\
 	ret = trace_define_field(event_call, #type, #item,		\
 				 offsetof(typeof(field), item),		\
 				 sizeof(field.item),			\
-				 is_signed_type(type), FILTER_OTHER);	\
+				 is_signed_type(type), filter_type);	\
 	if (ret)							\
 		return ret;
 
@@ -85,7 +88,7 @@ static void __always_unused ____ftrace_check_##name(void)	\
 				 offsetof(typeof(field),		\
 					  container.item),		\
 				 sizeof(field.container.item),		\
-				 is_signed_type(type), FILTER_OTHER);	\
+				 is_signed_type(type), filter_type);	\
 	if (ret)							\
 		return ret;
 
@@ -99,7 +102,7 @@ static void __always_unused ____ftrace_check_##name(void)	\
 		ret = trace_define_field(event_call, event_storage, #item, \
 				 offsetof(typeof(field), item),		\
 				 sizeof(field.item),			\
-				 is_signed_type(type), FILTER_OTHER);	\
+				 is_signed_type(type), filter_type);	\
 		mutex_unlock(&event_storage_mutex);			\
 		if (ret)						\
 			return ret;					\
@@ -112,7 +115,7 @@ static void __always_unused ____ftrace_check_##name(void)	\
 				 offsetof(typeof(field),		\
 					  container.item),		\
 				 sizeof(field.container.item),		\
-				 is_signed_type(type), FILTER_OTHER);	\
+				 is_signed_type(type), filter_type);	\
 	if (ret)							\
 		return ret;
 
@@ -120,17 +123,18 @@ static void __always_unused ____ftrace_check_##name(void)	\
 #define __dynamic_array(type, item)					\
 	ret = trace_define_field(event_call, #type, #item,		\
 				 offsetof(typeof(field), item),		\
-				 0, is_signed_type(type), FILTER_OTHER);\
+				 0, is_signed_type(type), filter_type);\
 	if (ret)							\
 		return ret;
 
 #undef FTRACE_ENTRY
-#define FTRACE_ENTRY(name, struct_name, id, tstruct, print)		\
+#define FTRACE_ENTRY(name, struct_name, id, tstruct, print, filter)	\
 int									\
 ftrace_define_fields_##name(struct ftrace_event_call *event_call)	\
 {									\
 	struct struct_name field;					\
 	int ret;							\
+	int filter_type = filter;					\
 									\
 	tstruct;							\
 									\
@@ -161,7 +165,8 @@ ftrace_define_fields_##name(struct ftrace_event_call *event_call)	\
 #define F_printk(fmt, args...) #fmt ", "  __stringify(args)
 
 #undef FTRACE_ENTRY_REG
-#define FTRACE_ENTRY_REG(call, struct_name, etype, tstruct, print, regfn)\
+#define FTRACE_ENTRY_REG(call, struct_name, etype, tstruct, print, filter,\
+			 regfn)						\
 									\
 struct ftrace_event_class event_class_ftrace_##call = {			\
 	.system			= __stringify(TRACE_SYSTEM),		\
@@ -180,9 +185,9 @@ struct ftrace_event_call __used						\
 __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call;
 
 #undef FTRACE_ENTRY
-#define FTRACE_ENTRY(call, struct_name, etype, tstruct, print)		\
+#define FTRACE_ENTRY(call, struct_name, etype, tstruct, print, filter)	\
 	FTRACE_ENTRY_REG(call, struct_name, etype,			\
-			 PARAMS(tstruct), PARAMS(print), NULL)
+			 PARAMS(tstruct), PARAMS(print), filter, NULL)
 
 int ftrace_event_is_function(struct ftrace_event_call *call)
 {
