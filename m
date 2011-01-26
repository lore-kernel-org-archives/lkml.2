Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab1AZEKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 23:10:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44535 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab1AZEKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 23:10:16 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=sKaVN7zY6ikA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=7d_E57ReAAAA:8 a=J1Y8HTJGAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=rexgf7VZJ6ZURpyc0UwA:9 a=GjM8H3XdZZVw70Y6a9kA:7 a=SrJV2O1aStH6vqzpKFEADk3TfzIA:4 a=D6-X0JM3zdQA:10 a=4N9Db7Z2_RYA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110126041014.647233683@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 25 Jan 2011 23:05:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Miller <davem@davemloft.net>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 2/3] tracing: Fix sparc64 alignment crash with __u64_aligned/U64_ALIGN()
References: <20110126040459.289776311@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Fix-sparc64-alignment-crash-with-__u64_align.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Problem description:

gcc happily align structures defined statically on 32-byte. Ftrace trace events
and Tracepoints both statically define structures into sections (using the
"section" attribute), to then assign these to symbols with the linker scripts to
iterate the these sections as an array.

However, gcc uses different alignments for these structures when they are
defined statically and when they are globally visible and/or in an array.
Therefore iteration on these arrays sees "holes" of padding.

Use the __u64_aligned for type declarations and variable definitions to ensure
that gcc:

a) iterates on the correctly aligned type. (type attribute)
b) generates the definitions within the sections with the appropriate alignment.
   (variable attribute)

The Ftrace code introduced the "aligned(4)" variable attribute in commit
1473e4417c79f12d91ef91a469699bfa911f510f to try to work around this problem that
showed up on x86_64, but it causes unaligned accesses on sparc64, and is
generally a bad idea on 64-bit if RCU pointers are contained within the
structure. Moreover, it did not use the same attribute as type attribute, which
could cause the iteration on the extern array structure not to match the
variable definitions for some structure sizes.

We should also ensure proper alignment of each Ftrace section in
include/asm-generic/vmlinux.lds.h.

Moving all STRUCT_ALIGN() for FTRACE_EVENTS() and TRACE_SYSCALLS() into the
definitions, so the alignment is only done if these infrastructures are
configured in. Use U64_ALIGN instead of STRUCT_ALIGN.

Also align TRACE_PRINTKS on U64_ALIGN to make sure the beginning of the section
is aligned on pointer size.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
LKML-Reference: <20110121203642.884088920@efficios.com>
Acked-by: David Miller <davem@davemloft.net>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/asm-generic/vmlinux.lds.h |   19 ++++++++++---------
 include/linux/compiler.h          |    6 +++---
 include/linux/ftrace_event.h      |    2 +-
 include/linux/syscalls.h          |   12 ++++++------
 include/trace/ftrace.h            |    8 ++++----
 include/trace/syscall.h           |    2 +-
 kernel/trace/trace.h              |    2 +-
 kernel/trace/trace_export.c       |    2 +-
 8 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index bdc1688..e4af65c 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -114,7 +114,8 @@
 #endif
 
 #ifdef CONFIG_TRACE_BRANCH_PROFILING
-#define LIKELY_PROFILE()	VMLINUX_SYMBOL(__start_annotated_branch_profile) = .; \
+#define LIKELY_PROFILE()	U64_ALIGN();					      \
+				VMLINUX_SYMBOL(__start_annotated_branch_profile) = .; \
 				*(_ftrace_annotated_branch)			      \
 				VMLINUX_SYMBOL(__stop_annotated_branch_profile) = .;
 #else
@@ -122,7 +123,8 @@
 #endif
 
 #ifdef CONFIG_PROFILE_ALL_BRANCHES
-#define BRANCH_PROFILE()	VMLINUX_SYMBOL(__start_branch_profile) = .;   \
+#define BRANCH_PROFILE()	U64_ALIGN();				      \
+				VMLINUX_SYMBOL(__start_branch_profile) = .;   \
 				*(_ftrace_branch)			      \
 				VMLINUX_SYMBOL(__stop_branch_profile) = .;
 #else
@@ -130,7 +132,8 @@
 #endif
 
 #ifdef CONFIG_EVENT_TRACING
-#define FTRACE_EVENTS()	VMLINUX_SYMBOL(__start_ftrace_events) = .;	\
+#define FTRACE_EVENTS()	U64_ALIGN();					\
+			VMLINUX_SYMBOL(__start_ftrace_events) = .;	\
 			*(_ftrace_events)				\
 			VMLINUX_SYMBOL(__stop_ftrace_events) = .;
 #else
@@ -138,7 +141,8 @@
 #endif
 
 #ifdef CONFIG_TRACING
-#define TRACE_PRINTKS() VMLINUX_SYMBOL(__start___trace_bprintk_fmt) = .;      \
+#define TRACE_PRINTKS()  U64_ALIGN();					       \
+			 VMLINUX_SYMBOL(__start___trace_bprintk_fmt) = .;      \
 			 *(__trace_printk_fmt) /* Trace_printk fmt' pointer */ \
 			 VMLINUX_SYMBOL(__stop___trace_bprintk_fmt) = .;
 #else
@@ -146,7 +150,8 @@
 #endif
 
 #ifdef CONFIG_FTRACE_SYSCALLS
-#define TRACE_SYSCALLS() VMLINUX_SYMBOL(__start_syscalls_metadata) = .;	\
+#define TRACE_SYSCALLS() U64_ALIGN();					\
+			 VMLINUX_SYMBOL(__start_syscalls_metadata) = .;	\
 			 *(__syscalls_metadata)				\
 			 VMLINUX_SYMBOL(__stop_syscalls_metadata) = .;
 #else
@@ -183,11 +188,7 @@
 	LIKELY_PROFILE()		       				\
 	BRANCH_PROFILE()						\
 	TRACE_PRINTKS()							\
-									\
-	STRUCT_ALIGN();							\
 	FTRACE_EVENTS()							\
-									\
-	STRUCT_ALIGN();							\
 	TRACE_SYSCALLS()
 
 /*
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 5036024..ffd6e7e 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -80,7 +80,7 @@ struct ftrace_branch_data {
 		};
 		unsigned long miss_hit[2];
 	};
-};
+} __u64_aligned;
 
 /*
  * Note: DISABLE_BRANCH_PROFILING can be used by special lowlevel code
@@ -96,7 +96,7 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 #define __branch_check__(x, expect) ({					\
 			int ______r;					\
 			static struct ftrace_branch_data		\
-				__attribute__((__aligned__(4)))		\
+				__u64_aligned				\
 				__attribute__((section("_ftrace_annotated_branch"))) \
 				______f = {				\
 				.func = __func__,			\
@@ -131,7 +131,7 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 	({								\
 		int ______r;						\
 		static struct ftrace_branch_data			\
-			__attribute__((__aligned__(4)))			\
+			__u64_aligned					\
 			__attribute__((section("_ftrace_branch")))	\
 			______f = {					\
 				.func = __func__,			\
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 47e3997..481a259 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -196,7 +196,7 @@ struct ftrace_event_call {
 	int				perf_refcount;
 	struct hlist_head __percpu	*perf_events;
 #endif
-};
+} __u64_aligned;
 
 #define __TRACE_EVENT_FLAGS(name, value)				\
 	static int __init trace_init_flags_##name(void)			\
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 18cd068..ea7ab85 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -126,9 +126,9 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 
 #define SYSCALL_TRACE_ENTER_EVENT(sname)				\
 	static struct syscall_metadata					\
-	__attribute__((__aligned__(4))) __syscall_meta_##sname;		\
+	  __u64_aligned __syscall_meta_##sname;				\
 	static struct ftrace_event_call __used				\
-	  __attribute__((__aligned__(4)))				\
+	  __u64_aligned							\
 	  __attribute__((section("_ftrace_events")))			\
 	  event_enter_##sname = {					\
 		.name                   = "sys_enter"#sname,		\
@@ -140,9 +140,9 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 
 #define SYSCALL_TRACE_EXIT_EVENT(sname)					\
 	static struct syscall_metadata					\
-	__attribute__((__aligned__(4))) __syscall_meta_##sname;		\
+	  __u64_aligned __syscall_meta_##sname;				\
 	static struct ftrace_event_call __used				\
-	  __attribute__((__aligned__(4)))				\
+	  __u64_aligned							\
 	  __attribute__((section("_ftrace_events")))			\
 	  event_exit_##sname = {					\
 		.name                   = "sys_exit"#sname,		\
@@ -156,7 +156,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	SYSCALL_TRACE_ENTER_EVENT(sname);			\
 	SYSCALL_TRACE_EXIT_EVENT(sname);			\
 	static struct syscall_metadata __used			\
-	  __attribute__((__aligned__(4)))			\
+	  __u64_aligned						\
 	  __attribute__((section("__syscalls_metadata")))	\
 	  __syscall_meta_##sname = {				\
 		.name 		= "sys"#sname,			\
@@ -172,7 +172,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	SYSCALL_TRACE_ENTER_EVENT(_##sname);			\
 	SYSCALL_TRACE_EXIT_EVENT(_##sname);			\
 	static struct syscall_metadata __used			\
-	  __attribute__((__aligned__(4)))			\
+	  __u64_aligned						\
 	  __attribute__((section("__syscalls_metadata")))	\
 	  __syscall_meta__##sname = {				\
 		.name 		= "sys_"#sname,			\
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index e16610c..ee44cf4 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -69,7 +69,7 @@
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, name, proto, args)	\
 	static struct ftrace_event_call	__used		\
-	__attribute__((__aligned__(4))) event_##name
+	__u64_aligned event_##name;
 
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
@@ -447,7 +447,7 @@ static inline notrace int ftrace_get_offsets_##call(			\
  * };
  *
  * static struct ftrace_event_call __used
- * __attribute__((__aligned__(4)))
+ * __u64_aligned
  * __attribute__((section("_ftrace_events"))) event_<call> = {
  *	.name			= "<call>",
  *	.class			= event_class_<template>,
@@ -580,7 +580,7 @@ static struct ftrace_event_class __used event_class_##call = {		\
 #define DEFINE_EVENT(template, call, proto, args)			\
 									\
 static struct ftrace_event_call __used					\
-__attribute__((__aligned__(4)))						\
+__u64_aligned								\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
 	.class			= &event_class_##template,		\
@@ -594,7 +594,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 static const char print_fmt_##call[] = print;				\
 									\
 static struct ftrace_event_call __used					\
-__attribute__((__aligned__(4)))						\
+__u64_aligned								\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
 	.class			= &event_class_##template,		\
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 31966a4..69578b3 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -29,7 +29,7 @@ struct syscall_metadata {
 
 	struct ftrace_event_call *enter_event;
 	struct ftrace_event_call *exit_event;
-};
+} __u64_aligned;
 
 #ifdef CONFIG_FTRACE_SYSCALLS
 extern unsigned long arch_syscall_addr(int nr);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 9021f8c..6a08891 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -749,7 +749,7 @@ extern const char *__stop___trace_bprintk_fmt[];
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(call, struct_name, id, tstruct, print)		\
 	extern struct ftrace_event_call					\
-	__attribute__((__aligned__(4))) event_##call;
+	__u64_aligned event_##call;
 #undef FTRACE_ENTRY_DUP
 #define FTRACE_ENTRY_DUP(call, struct_name, id, tstruct, print)		\
 	FTRACE_ENTRY(call, struct_name, id, PARAMS(tstruct), PARAMS(print))
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 4b74d71..a6ebf4e 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -162,7 +162,7 @@ struct ftrace_event_class event_class_ftrace_##call = {			\
 };									\
 									\
 struct ftrace_event_call __used						\
-__attribute__((__aligned__(4)))						\
+__u64_aligned								\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
 	.event.type		= etype,				\
-- 
1.7.2.3


