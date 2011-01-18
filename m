Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab1ARGAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 01:00:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47221
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750923Ab1ARGAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 01:00:06 -0500
Date: Mon, 17 Jan 2011 22:00:39 -0800 (PST)
Message-Id: <20110117.220039.71097651.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: richm@oldelvet.org.uk, 609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com, mathieu.desnoyers@efficios.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
 Unknown relocation: 36
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110117.213448.226787087.davem@davemloft.net>
References: <20110116.113944.48514452.davem@davemloft.net>
	<1295273486.16479.15.camel@gandalf.stny.rr.com>
	<20110117.213448.226787087.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, 17 Jan 2011 21:34:48 -0800 (PST)

> Where are these "holes" coming from?  Reading the commit message for
> the change that introduced this problem
> (86c38a31aa7f2dd6e74a262710bf8ebf7455acc5), it seems like the issue is
> coming from the compiler, and that fact that beforehand some
> structures were marked with 4-byte alignment.  The existing 4-byte
> alignment cases sound like the real bug to me, where is that happening
> and why?

Ok, now I'm getting a bit irritated.  I went and looked into the
history of this "aligned(4)" tag on ftrace_event_call.

The reason for it is completely undocumented, and in fact it gets
added in a commit whose commit message doesn't mention this part
of the commit's change at all.

That really sucks.

The commit message is:

commit 1473e4417c79f12d91ef91a469699bfa911f510f
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Tue Feb 24 14:15:08 2009 -0500

    tracing: make event directory structure
    
    This patch adds the directory /debug/tracing/events/ that will contain
    all the registered trace points.
    
     # ls /debug/tracing/events/
    sched_kthread_stop      sched_process_fork  sched_switch
    sched_kthread_stop_ret  sched_process_free  sched_wait_task
    sched_migrate_task      sched_process_wait  sched_wakeup
    sched_process_exit      sched_signal_send   sched_wakeup_new
    
     # ls /debug/tracing/events/sched_switch/
    enable
    
     # cat /debug/tracing/events/sched_switch/enable
    1
    
     # cat /debug/tracing/set_event
    sched_switch
    
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

And in this commit we have:

@@ -39,6 +41,7 @@ static void ftrace_unreg_event_##call(void)				\
 }									\
 									\
 static struct ftrace_event_call __used					\
+__attribute__((__aligned__(4)))						\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name 			= #call,				\
 	.regfunc		= ftrace_reg_event_##call,		\

Excuse me?

This is a serious infraction of responsible development, and it makes
bugs hard if not impossible to analyze.  I see it was postedo on LKML,
and I'm surprised nobody asked "Why are you adding that alignment, and
whatever the reason why isn't it mentioned in the commit message or in
a comment?"

Anyways, this commit is where this alignment originates.

It probably is spurious and unnecessary and we can remove it
completely from _ALL_ of the cases.  Did anyone do any research
whatsoever into why the alignment tag was put there in the first place
when the GCC 4.5 bug showed up?

Steven what is the deal here?

Can't we just do the following patch?  Also, I notice similar
alignment tag being used for syscall_metadata, what's the story there?

--------------------
ftrace: Remove unnecessary alignment tag from ftrace_event_call.

It's completely unnecessary and causes problems on platforms
where this tag down-aligns the structure's alignment.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 18cd068..05295f2 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -128,7 +128,6 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	static struct syscall_metadata					\
 	__attribute__((__aligned__(4))) __syscall_meta_##sname;		\
 	static struct ftrace_event_call __used				\
-	  __attribute__((__aligned__(4)))				\
 	  __attribute__((section("_ftrace_events")))			\
 	  event_enter_##sname = {					\
 		.name                   = "sys_enter"#sname,		\
@@ -142,7 +141,6 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	static struct syscall_metadata					\
 	__attribute__((__aligned__(4))) __syscall_meta_##sname;		\
 	static struct ftrace_event_call __used				\
-	  __attribute__((__aligned__(4)))				\
 	  __attribute__((section("_ftrace_events")))			\
 	  event_exit_##sname = {					\
 		.name                   = "sys_exit"#sname,		\
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
