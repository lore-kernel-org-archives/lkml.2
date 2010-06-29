Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab0F2DKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 23:10:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47269 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab0F2DKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 23:10:45 -0400
X-Authority-Analysis: v=1.1 cv=hVjE12FRt4v4sD2HVuppbi620CRC5en4UNTr7KPd1ng= c=1 sm=0 a=aY-MOS5_IMoA:10 a=1CvaPgNKC-EA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=B-_IZyXVQfu485Ka1vQA:9 a=XYgu-dqyDdCuLrFm2MRlAWmgXcEA:4 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100629031042.861705713@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 28 Jun 2010 23:08:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 1/9] tracing: Use a global field list for all syscall exit events
References: <20100629030836.222433712@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Use-a-global-field-list-for-all-syscall-exit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

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
-- 
1.7.1


