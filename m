Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab1BCOjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 09:39:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46761 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab1BCOjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 09:39:00 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=17fnuEHSxYQA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=7d_E57ReAAAA:8 a=meVymXHHAAAA:8 a=6_G9IIM5MvjJUqGUZ1QA:9 a=nCqbf-hoUf-iE4WcIYEA:7 a=80CueJ2Iy3UkRqagmT5Ki2Cb8DoA:4 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=D6-X0JM3zdQA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110203143857.484963664@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 03 Feb 2011 09:35:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 3/3 v2] tracing: Replace syscall_meta_data struct array with pointer array
References: <20110203143518.707423251@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Replace-syscall_meta_data-struct-array-with-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently the syscall_meta structures for the syscall tracepoints are
placed in the __syscall_metadata section, and at link time, the linker
makes one large array of all these syscall metadata structures. On boot
up, this array is read (much like the initcall sections) and the syscall
data is processed.

The problem is that there is no guarantee that gcc will place complex
structures nicely together in an array format. Two structures in the
same file may be placed awkwardly, because gcc has no clue that they
are suppose to be in an array.

A hack was used previous to force the alignment to 4, to pack the
structures together. But this caused alignment issues with other
architectures (sparc).

Instead of packing the structures into an array, the structures' addresses
are now put into the __syscall_metadata section. As pointers are always the
natural alignment, gcc should always pack them tightly together
(otherwise initcall, extable, etc would also fail).

By having the pointers to the structures in the section, we can still
iterate the trace_events without causing unnecessary alignment problems
with other architectures, or depending on the current behaviour of
gcc that will likely change in the future just to tick us kernel developers
off a little more.

The __syscall_metadata section is also moved into the .init.data section
as it is now only needed at boot up.

Suggested-by: David Miller <davem@davemloft.net>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/asm-generic/vmlinux.lds.h |    9 ++++-----
 include/linux/syscalls.h          |   18 +++++++++---------
 kernel/trace/trace_syscalls.c     |   19 ++++++++++---------
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 57b1b68..fe77e33 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -141,7 +141,8 @@
 #endif
 
 #ifdef CONFIG_FTRACE_SYSCALLS
-#define TRACE_SYSCALLS() VMLINUX_SYMBOL(__start_syscalls_metadata) = .;	\
+#define TRACE_SYSCALLS() . = ALIGN(8);					\
+			 VMLINUX_SYMBOL(__start_syscalls_metadata) = .;	\
 			 *(__syscalls_metadata)				\
 			 VMLINUX_SYMBOL(__stop_syscalls_metadata) = .;
 #else
@@ -175,10 +176,7 @@
 	VMLINUX_SYMBOL(__stop___verbose) = .;				\
 	LIKELY_PROFILE()		       				\
 	BRANCH_PROFILE()						\
-	TRACE_PRINTKS()							\
-									\
-	STRUCT_ALIGN();							\
-	TRACE_SYSCALLS()
+	TRACE_PRINTKS()
 
 /*
  * Data section helpers
@@ -483,6 +481,7 @@
 	*(.init.rodata)							\
 	MCOUNT_REC()							\
 	FTRACE_EVENTS()							\
+	TRACE_SYSCALLS()						\
 	DEV_DISCARD(init.rodata)					\
 	CPU_DISCARD(init.rodata)					\
 	MEM_DISCARD(init.rodata)					\
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 45508fe..98664db 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -125,8 +125,7 @@ extern struct trace_event_functions enter_syscall_print_funcs;
 extern struct trace_event_functions exit_syscall_print_funcs;
 
 #define SYSCALL_TRACE_ENTER_EVENT(sname)				\
-	static struct syscall_metadata					\
-	__attribute__((__aligned__(4))) __syscall_meta_##sname;		\
+	static struct syscall_metadata __syscall_meta_##sname;		\
 	static struct ftrace_event_call __used				\
 	  event_enter_##sname = {					\
 		.name                   = "sys_enter"#sname,		\
@@ -140,8 +139,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	__TRACE_EVENT_FLAGS(enter_##sname, TRACE_EVENT_FL_CAP_ANY)
 
 #define SYSCALL_TRACE_EXIT_EVENT(sname)					\
-	static struct syscall_metadata					\
-	__attribute__((__aligned__(4))) __syscall_meta_##sname;		\
+	static struct syscall_metadata __syscall_meta_##sname;		\
 	static struct ftrace_event_call __used				\
 	  event_exit_##sname = {					\
 		.name                   = "sys_exit"#sname,		\
@@ -158,8 +156,6 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	SYSCALL_TRACE_ENTER_EVENT(sname);			\
 	SYSCALL_TRACE_EXIT_EVENT(sname);			\
 	static struct syscall_metadata __used			\
-	  __attribute__((__aligned__(4)))			\
-	  __attribute__((section("__syscalls_metadata")))	\
 	  __syscall_meta_##sname = {				\
 		.name 		= "sys"#sname,			\
 		.nb_args 	= nb,				\
@@ -168,14 +164,15 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 		.enter_event	= &event_enter_##sname,		\
 		.exit_event	= &event_exit_##sname,		\
 		.enter_fields	= LIST_HEAD_INIT(__syscall_meta_##sname.enter_fields), \
-	};
+	};							\
+	static struct syscall_metadata __used			\
+	  __attribute__((section("__syscalls_metadata")))	\
+	 *__p_syscall_meta_##sname = &__syscall_meta_##sname;
 
 #define SYSCALL_DEFINE0(sname)					\
 	SYSCALL_TRACE_ENTER_EVENT(_##sname);			\
 	SYSCALL_TRACE_EXIT_EVENT(_##sname);			\
 	static struct syscall_metadata __used			\
-	  __attribute__((__aligned__(4)))			\
-	  __attribute__((section("__syscalls_metadata")))	\
 	  __syscall_meta__##sname = {				\
 		.name 		= "sys_"#sname,			\
 		.nb_args 	= 0,				\
@@ -183,6 +180,9 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 		.exit_event	= &event_exit__##sname,		\
 		.enter_fields	= LIST_HEAD_INIT(__syscall_meta__##sname.enter_fields), \
 	};							\
+	static struct syscall_metadata __used			\
+	  __attribute__((section("__syscalls_metadata")))	\
+	 *__p_syscall_meta_##sname = &__syscall_meta__##sname;	\
 	asmlinkage long sys_##sname(void)
 #else
 #define SYSCALL_DEFINE0(name)	   asmlinkage long sys_##name(void)
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index b706529..5c9fe08 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -55,20 +55,21 @@ struct ftrace_event_class event_class_syscall_exit = {
 	.raw_init	= init_syscall_trace,
 };
 
-extern unsigned long __start_syscalls_metadata[];
-extern unsigned long __stop_syscalls_metadata[];
+extern struct syscall_metadata *__start_syscalls_metadata[];
+extern struct syscall_metadata *__stop_syscalls_metadata[];
 
 static struct syscall_metadata **syscalls_metadata;
 
-static struct syscall_metadata *find_syscall_meta(unsigned long syscall)
+static __init struct syscall_metadata *
+find_syscall_meta(unsigned long syscall)
 {
-	struct syscall_metadata *start;
-	struct syscall_metadata *stop;
+	struct syscall_metadata **start;
+	struct syscall_metadata **stop;
 	char str[KSYM_SYMBOL_LEN];
 
 
-	start = (struct syscall_metadata *)__start_syscalls_metadata;
-	stop = (struct syscall_metadata *)__stop_syscalls_metadata;
+	start = __start_syscalls_metadata;
+	stop = __stop_syscalls_metadata;
 	kallsyms_lookup(syscall, NULL, NULL, NULL, str);
 
 	for ( ; start < stop; start++) {
@@ -78,8 +79,8 @@ static struct syscall_metadata *find_syscall_meta(unsigned long syscall)
 		 * with "SyS" instead of "sys", leading to an unwanted
 		 * mismatch.
 		 */
-		if (start->name && !strcmp(start->name + 3, str + 3))
-			return start;
+		if ((*start)->name && !strcmp((*start)->name + 3, str + 3))
+			return *start;
 	}
 	return NULL;
 }
-- 
1.7.2.3


