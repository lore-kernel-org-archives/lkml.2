Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab1ARGIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 01:08:25 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50696
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750923Ab1ARGIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 01:08:24 -0500
Date: Mon, 17 Jan 2011 22:08:57 -0800 (PST)
Message-Id: <20110117.220857.104046847.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: richm@oldelvet.org.uk, 609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com, mathieu.desnoyers@efficios.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
 Unknown relocation: 36
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110117.220039.71097651.davem@davemloft.net>
References: <1295273486.16479.15.camel@gandalf.stny.rr.com>
	<20110117.213448.226787087.davem@davemloft.net>
	<20110117.220039.71097651.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, 17 Jan 2011 22:00:39 -0800 (PST)

> ftrace: Remove unnecessary alignment tag from ftrace_event_call.
> 
> It's completely unnecessary and causes problems on platforms
> where this tag down-aligns the structure's alignment.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
 ...

Ok, unless we can explain why these alignments are needed at all, we
should kill all of them:

--------------------
tracing: Remove unnecessary __aligned__(4) tag from trace data.

It's completely unnecessary and causes problems on platforms
where this tag down-aligns the structure's alignment.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 320d6c9..8620723 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -94,7 +94,6 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 #define __branch_check__(x, expect) ({					\
 			int ______r;					\
 			static struct ftrace_branch_data		\
-				__attribute__((__aligned__(4)))		\
 				__attribute__((section("_ftrace_annotated_branch"))) \
 				______f = {				\
 				.func = __func__,			\
@@ -129,7 +128,6 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 	({								\
 		int ______r;						\
 		static struct ftrace_branch_data			\
-			__attribute__((__aligned__(4)))			\
 			__attribute__((section("_ftrace_branch")))	\
 			______f = {					\
 				.func = __func__,			\
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 18cd068..e23a188 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -125,10 +125,8 @@ extern struct trace_event_functions enter_syscall_print_funcs;
 extern struct trace_event_functions exit_syscall_print_funcs;
 
 #define SYSCALL_TRACE_ENTER_EVENT(sname)				\
-	static struct syscall_metadata					\
-	__attribute__((__aligned__(4))) __syscall_meta_##sname;		\
+	static struct syscall_metadata __syscall_meta_##sname;		\
 	static struct ftrace_event_call __used				\
-	  __attribute__((__aligned__(4)))				\
 	  __attribute__((section("_ftrace_events")))			\
 	  event_enter_##sname = {					\
 		.name                   = "sys_enter"#sname,		\
@@ -139,10 +137,8 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	__TRACE_EVENT_FLAGS(enter_##sname, TRACE_EVENT_FL_CAP_ANY)
 
 #define SYSCALL_TRACE_EXIT_EVENT(sname)					\
-	static struct syscall_metadata					\
-	__attribute__((__aligned__(4))) __syscall_meta_##sname;		\
+	static struct syscall_metadata __syscall_meta_##sname;		\
 	static struct ftrace_event_call __used				\
-	  __attribute__((__aligned__(4)))				\
 	  __attribute__((section("_ftrace_events")))			\
 	  event_exit_##sname = {					\
 		.name                   = "sys_exit"#sname,		\
@@ -156,7 +152,6 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	SYSCALL_TRACE_ENTER_EVENT(sname);			\
 	SYSCALL_TRACE_EXIT_EVENT(sname);			\
 	static struct syscall_metadata __used			\
-	  __attribute__((__aligned__(4)))			\
 	  __attribute__((section("__syscalls_metadata")))	\
 	  __syscall_meta_##sname = {				\
 		.name 		= "sys"#sname,			\
@@ -172,7 +167,6 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	SYSCALL_TRACE_ENTER_EVENT(_##sname);			\
 	SYSCALL_TRACE_EXIT_EVENT(_##sname);			\
 	static struct syscall_metadata __used			\
-	  __attribute__((__aligned__(4)))			\
 	  __attribute__((section("__syscalls_metadata")))	\
 	  __syscall_meta__##sname = {				\
 		.name 		= "sys_"#sname,			\
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index e16610c..bd86d1b 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -68,8 +68,7 @@
 
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, name, proto, args)	\
-	static struct ftrace_event_call	__used		\
-	__attribute__((__aligned__(4))) event_##name
+	static struct ftrace_event_call	__used event_##name
 
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
@@ -447,7 +446,6 @@ static inline notrace int ftrace_get_offsets_##call(			\
  * };
  *
  * static struct ftrace_event_call __used
- * __attribute__((__aligned__(4)))
  * __attribute__((section("_ftrace_events"))) event_<call> = {
  *	.name			= "<call>",
  *	.class			= event_class_<template>,
@@ -580,7 +578,6 @@ static struct ftrace_event_class __used event_class_##call = {		\
 #define DEFINE_EVENT(template, call, proto, args)			\
 									\
 static struct ftrace_event_call __used					\
-__attribute__((__aligned__(4)))						\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
 	.class			= &event_class_##template,		\
@@ -594,7 +591,6 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 static const char print_fmt_##call[] = print;				\
 									\
 static struct ftrace_event_call __used					\
-__attribute__((__aligned__(4)))						\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
 	.class			= &event_class_##template,		\
