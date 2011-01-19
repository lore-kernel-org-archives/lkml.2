Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318Ab1ASFIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 00:08:50 -0500
Received: from mail.openrapids.net ([64.15.138.104]:52743 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750712Ab1ASFIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 00:08:48 -0500
Date: Wed, 19 Jan 2011 00:08:45 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Miller <davem@davemloft.net>, richm@oldelvet.org.uk,
        609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
	Unknown relocation: 36
Message-ID: <20110119050844.GA8776@Krystal>
References: <1295273486.16479.15.camel@gandalf.stny.rr.com> <20110117.213448.226787087.davem@davemloft.net> <20110117.220039.71097651.davem@davemloft.net> <20110117.220857.104046847.davem@davemloft.net> <20110118164633.GA12872@Krystal> <1295372019.12215.30.camel@gandalf.stny.rr.com> <1295374595.12215.32.camel@gandalf.stny.rr.com> <1295375178.12215.33.camel@gandalf.stny.rr.com> <20110118201323.GA14930@Krystal> <1295382144.12215.123.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295382144.12215.123.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 22:57:15 up 56 days,  9:00,  5 users,  load average: 0.02, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Tue, 2011-01-18 at 15:13 -0500, Mathieu Desnoyers wrote:
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > On Tue, 2011-01-18 at 13:16 -0500, Steven Rostedt wrote:
> > > > On Tue, 2011-01-18 at 12:33 -0500, Steven Rostedt wrote:
> > > > > On Tue, 2011-01-18 at 11:46 -0500, Mathieu Desnoyers wrote:
> > > > 
> > > > > > Also align TRACE_PRINTKS on 8 bytes to make sure the beginning of the section is
> > > > > > aligned on pointer size.
> > > > > 
> > > > > If I can make it crash without the alignments and this fixes the issue,
> > > > > I'll apply both patches.
> > > > 
> > > > After applying David's patch, I do indeed get a crash. I'll now apply
> > > > yours and see if it fixes the issue.
> > > 
> > > Your patch doesn't seem to fix it either. I'll investigate this further.
> > 
> > I think David's patch missed kernel/trace/trace_export.c
> > 
> > struct ftrace_event_call __used                                         \
> > __attribute__((__aligned__(4)))                                         \
> > __attribute__((section("_ftrace_events"))) event_##call = {             \
> > 
> > and kernel/trace/trace.h:
> > 
> > #define FTRACE_ENTRY(call, struct_name, id, tstruct, print)             \
> >         extern struct ftrace_event_call                                 \
> >         __attribute__((__aligned__(4))) event_##call;
> > 
> > does it help if you remove these ?
> 
> I doubt it, but I'll try it anyway.

The following works fine for me now. Comments are welcome.


tracing: use __aligned__() variable and type attributes to work around gcc bug

I just played with the possible combinations, and here are my current results,
with the appropriately aligned linker script sections (with my patch applied):

- No aligned() type attribute nor variable attribute. I get a crash on x86_64
  (NULL pointer exception when executing __trace_add_event_call, the 5th call).
  __alignof__(struct ftrace_event_call) is worth 8.

- adding type attribute aligned(32) on the struct ftrace_event_call and
  struct syscall_metadata declarations seems to work fine, but consumes space
  needlessly (struct ftrace_event_call grows from 136 to 160 bytes). Note that
  tracepoints use the type attribute aligned(32), which falls in this category
  (waste of space). We might want to do better.

- adding type attribute aligned(8) crashes. Note that the gcc documentation for
  type attributes explains that this specifies the minimum alignment for the
  type, so the compiler is free to choose a larger one.

- adding type attribute (packed, aligned(8)) should force the compiler to
  consider a 8-byte alignment for the type (as shown by __alignof__), but it
  doesn't work (crash).

I really don't like specifying alignment as variable attributes (rather than
type attributes), because the extern array that iterates on the attributes has
no clue of the alignment used (same for pointer arithmetic). Unfortunately, it
seems to be the only way to really make sure gcc does not use an alignment
larger than prescribed.

So far, my somewhat premature conclusion is that gcc honours the aligned() type
attribute for the array iteration (thus expecting a 136 bytes array aligned on 8
bytes boundaries), but does not apply the aligned() type attribute to the
structure definition when used in combination with the "section" variable
attribute, choosing to align the structure on 32 bytes instead. My hunch is thatthis is a gcc bug that appeared a few months before Fri Nov 14 17:47:47 2008
-0500, which led me to change the tracepoint structure alignment from 8 to 32
in commit 7e066fb870fcd1025ec3ba7bbde5d541094f4ce1 because of a very similar
problem.

One way to work around this could be to specify the aligned(8) type attribute to
the structure declarations *and* the aligned(8) variable attribute to the
structure definitions.

On 32-bit architectures, we really want a aligned(4), and on 64-bit
architectures, aligned(8). Represent this by creating:

#define __long_aligned __attribute__((__aligned__(__alignof__(long))))

The following patch passes the initial smoke test (it boots fine, without any
NULL pointer exception on x86_64).
(this patch is based on a 2.6.37 kernel)

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/compiler.h     |    8 +++++---
 include/linux/ftrace_event.h |    2 +-
 include/linux/syscalls.h     |   20 ++++++++++++--------
 include/trace/ftrace.h       |    8 ++++----
 include/trace/syscall.h      |    2 +-
 kernel/trace/trace.h         |    2 +-
 kernel/trace/trace_export.c  |    2 +-
 7 files changed, 25 insertions(+), 19 deletions(-)

Index: linux-2.6-lttng/include/linux/compiler.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/compiler.h
+++ linux-2.6-lttng/include/linux/compiler.h
@@ -57,6 +57,8 @@ extern void __chk_io_ptr(const volatile
 # include <linux/compiler-intel.h>
 #endif
 
+#define __long_aligned __attribute__((__aligned__(__alignof__(long))))
+
 /*
  * Generic compiler-dependent macros required for kernel
  * build go below this comment. Actual compiler/compiler version
@@ -78,7 +80,7 @@ struct ftrace_branch_data {
 		};
 		unsigned long miss_hit[2];
 	};
-};
+} __long_aligned;
 
 /*
  * Note: DISABLE_BRANCH_PROFILING can be used by special lowlevel code
@@ -94,7 +96,7 @@ void ftrace_likely_update(struct ftrace_
 #define __branch_check__(x, expect) ({					\
 			int ______r;					\
 			static struct ftrace_branch_data		\
-				__attribute__((__aligned__(4)))		\
+				__long_aligned				\
 				__attribute__((section("_ftrace_annotated_branch"))) \
 				______f = {				\
 				.func = __func__,			\
@@ -129,7 +131,7 @@ void ftrace_likely_update(struct ftrace_
 	({								\
 		int ______r;						\
 		static struct ftrace_branch_data			\
-			__attribute__((__aligned__(4)))			\
+			__long_aligned					\
 			__attribute__((section("_ftrace_branch")))	\
 			______f = {					\
 				.func = __func__,			\
Index: linux-2.6-lttng/include/linux/syscalls.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/syscalls.h
+++ linux-2.6-lttng/include/linux/syscalls.h
@@ -126,11 +126,13 @@ extern struct trace_event_functions exit
 
 #define SYSCALL_TRACE_ENTER_EVENT(sname)				\
 	static struct syscall_metadata					\
-	__attribute__((__aligned__(4))) __syscall_meta_##sname;		\
+	__long_aligned							\
+	__syscall_meta_##sname;						\
 	static struct ftrace_event_call					\
-	__attribute__((__aligned__(4))) event_enter_##sname;		\
+	__long_aligned							\
+	event_enter_##sname;						\
 	static struct ftrace_event_call __used				\
-	  __attribute__((__aligned__(4)))				\
+	  __long_aligned						\
 	  __attribute__((section("_ftrace_events")))			\
 	  event_enter_##sname = {					\
 		.name                   = "sys_enter"#sname,		\
@@ -141,11 +143,13 @@ extern struct trace_event_functions exit
 
 #define SYSCALL_TRACE_EXIT_EVENT(sname)					\
 	static struct syscall_metadata					\
-	__attribute__((__aligned__(4))) __syscall_meta_##sname;		\
+	__long_aligned							\
+	__syscall_meta_##sname;						\
 	static struct ftrace_event_call					\
-	__attribute__((__aligned__(4))) event_exit_##sname;		\
+	__long_aligned							\
+	event_exit_##sname;						\
 	static struct ftrace_event_call __used				\
-	  __attribute__((__aligned__(4)))				\
+	  __long_aligned						\
 	  __attribute__((section("_ftrace_events")))			\
 	  event_exit_##sname = {					\
 		.name                   = "sys_exit"#sname,		\
@@ -158,7 +162,7 @@ extern struct trace_event_functions exit
 	SYSCALL_TRACE_ENTER_EVENT(sname);			\
 	SYSCALL_TRACE_EXIT_EVENT(sname);			\
 	static struct syscall_metadata __used			\
-	  __attribute__((__aligned__(4)))			\
+	  __long_aligned					\
 	  __attribute__((section("__syscalls_metadata")))	\
 	  __syscall_meta_##sname = {				\
 		.name 		= "sys"#sname,			\
@@ -174,7 +178,7 @@ extern struct trace_event_functions exit
 	SYSCALL_TRACE_ENTER_EVENT(_##sname);			\
 	SYSCALL_TRACE_EXIT_EVENT(_##sname);			\
 	static struct syscall_metadata __used			\
-	  __attribute__((__aligned__(4)))			\
+	  __long_aligned					\
 	  __attribute__((section("__syscalls_metadata")))	\
 	  __syscall_meta__##sname = {				\
 		.name 		= "sys_"#sname,			\
Index: linux-2.6-lttng/include/trace/ftrace.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/ftrace.h
+++ linux-2.6-lttng/include/trace/ftrace.h
@@ -79,7 +79,7 @@
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, name, proto, args)	\
 	static struct ftrace_event_call	__used		\
-	__attribute__((__aligned__(4))) event_##name;
+	__long_aligned event_##name;
 
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
@@ -447,7 +447,7 @@ static inline notrace int ftrace_get_off
  * };
  *
  * static struct ftrace_event_call __used
- * __attribute__((__aligned__(4)))
+ * __long_aligned
  * __attribute__((section("_ftrace_events"))) event_<call> = {
  *	.name			= "<call>",
  *	.class			= event_class_<template>,
@@ -581,7 +581,7 @@ static struct ftrace_event_class __used
 #define DEFINE_EVENT(template, call, proto, args)			\
 									\
 static struct ftrace_event_call __used					\
-__attribute__((__aligned__(4)))						\
+__long_aligned								\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
 	.class			= &event_class_##template,		\
@@ -595,7 +595,7 @@ __attribute__((section("_ftrace_events")
 static const char print_fmt_##call[] = print;				\
 									\
 static struct ftrace_event_call __used					\
-__attribute__((__aligned__(4)))						\
+__long_aligned								\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
 	.class			= &event_class_##template,		\
Index: linux-2.6-lttng/kernel/trace/trace.h
===================================================================
--- linux-2.6-lttng.orig/kernel/trace/trace.h
+++ linux-2.6-lttng/kernel/trace/trace.h
@@ -749,7 +749,7 @@ extern const char *__stop___trace_bprint
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(call, struct_name, id, tstruct, print)		\
 	extern struct ftrace_event_call					\
-	__attribute__((__aligned__(4))) event_##call;
+	__long_aligned event_##call;
 #undef FTRACE_ENTRY_DUP
 #define FTRACE_ENTRY_DUP(call, struct_name, id, tstruct, print)		\
 	FTRACE_ENTRY(call, struct_name, id, PARAMS(tstruct), PARAMS(print))
Index: linux-2.6-lttng/kernel/trace/trace_export.c
===================================================================
--- linux-2.6-lttng.orig/kernel/trace/trace_export.c
+++ linux-2.6-lttng/kernel/trace/trace_export.c
@@ -156,7 +156,7 @@ struct ftrace_event_class event_class_ft
 };									\
 									\
 struct ftrace_event_call __used						\
-__attribute__((__aligned__(4)))						\
+__long_aligned								\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
 	.event.type		= etype,				\
Index: linux-2.6-lttng/include/linux/ftrace_event.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/ftrace_event.h
+++ linux-2.6-lttng/include/linux/ftrace_event.h
@@ -194,7 +194,7 @@ struct ftrace_event_call {
 	int				perf_refcount;
 	struct hlist_head __percpu	*perf_events;
 #endif
-};
+} __long_aligned;
 
 #define PERF_MAX_TRACE_SIZE	2048
 
Index: linux-2.6-lttng/include/trace/syscall.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/syscall.h
+++ linux-2.6-lttng/include/trace/syscall.h
@@ -29,7 +29,7 @@ struct syscall_metadata {
 
 	struct ftrace_event_call *enter_event;
 	struct ftrace_event_call *exit_event;
-};
+} __long_aligned;
 
 #ifdef CONFIG_FTRACE_SYSCALLS
 extern unsigned long arch_syscall_addr(int nr);

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
