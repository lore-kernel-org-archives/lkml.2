Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab0F2JWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 05:22:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:39126 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845Ab0F2JWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 05:22:11 -0400
Date: Tue, 29 Jun 2010 09:21:39 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4BFA3746.8070100@cn.fujitsu.com>
References: <4BFA3746.8070100@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Use a global field list for all syscall exit events
Message-ID: <tip-c9642c49aae1272d7c24008a40ae614470b957a6@git.kernel.org>
Git-Commit-ID: c9642c49aae1272d7c24008a40ae614470b957a6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 29 Jun 2010 09:21:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c9642c49aae1272d7c24008a40ae614470b957a6
Gitweb:     http://git.kernel.org/tip/c9642c49aae1272d7c24008a40ae614470b957a6
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 24 May 2010 16:22:30 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 28 Jun 2010 17:12:44 -0400

tracing: Use a global field list for all syscall exit events

All syscall exit events have the same fields.

The kernel size drops 2.5K:

   text    data     bss     dec     hex filename
7018612 2034376 7251132 16304120         f8c7f8 vmlinux.o.orig
7018612 2031888 7251132 16301632         f8be40 vmlinux.o

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4BFA3746.8070100@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/syscalls.h      |    2 --
 include/trace/syscall.h       |    1 -
 kernel/trace/trace_syscalls.c |    7 ++++---
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 7f614ce..7994bd4 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -165,7 +165,6 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 		.enter_event	= &event_enter_##sname,		\
 		.exit_event	= &event_exit_##sname,		\
 		.enter_fields	= LIST_HEAD_INIT(__syscall_meta_##sname.enter_fields), \
-		.exit_fields	= LIST_HEAD_INIT(__syscall_meta_##sname.exit_fields), \
 	};
 
 #define SYSCALL_DEFINE0(sname)					\
@@ -180,7 +179,6 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 		.enter_event	= &event_enter__##sname,	\
 		.exit_event	= &event_exit__##sname,		\
 		.enter_fields	= LIST_HEAD_INIT(__syscall_meta__##sname.enter_fields), \
-		.exit_fields	= LIST_HEAD_INIT(__syscall_meta__##sname.exit_fields), \
 	};							\
 	asmlinkage long sys_##sname(void)
 #else
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 257e089..31966a4 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -26,7 +26,6 @@ struct syscall_metadata {
 	const char	**types;
 	const char	**args;
 	struct list_head enter_fields;
-	struct list_head exit_fields;
 
 	struct ftrace_event_call *enter_event;
 	struct ftrace_event_call *exit_event;
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 34e3580..bac752f 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -23,6 +23,9 @@ static int syscall_exit_register(struct ftrace_event_call *event,
 static int syscall_enter_define_fields(struct ftrace_event_call *call);
 static int syscall_exit_define_fields(struct ftrace_event_call *call);
 
+/* All syscall exit events have the same fields */
+static LIST_HEAD(syscall_exit_fields);
+
 static struct list_head *
 syscall_get_enter_fields(struct ftrace_event_call *call)
 {
@@ -34,9 +37,7 @@ syscall_get_enter_fields(struct ftrace_event_call *call)
 static struct list_head *
 syscall_get_exit_fields(struct ftrace_event_call *call)
 {
-	struct syscall_metadata *entry = call->data;
-
-	return &entry->exit_fields;
+	return &syscall_exit_fields;
 }
 
 struct trace_event_functions enter_syscall_print_funcs = {
