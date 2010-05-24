Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab0EXIUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 04:20:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60725 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755951Ab0EXIUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 04:20:12 -0400
Message-ID: <4BFA3746.8070100@cn.fujitsu.com>
Date: Mon, 24 May 2010 16:22:30 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Jason Baron <jbaron@redhat.com>
Subject: [PATCH 1/8] tracing: Use a global field list for all syscall exit
 events
References: <4BFA3728.3000701@cn.fujitsu.com>
In-Reply-To: <4BFA3728.3000701@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All syscall exit events have the same fields.

The kernel size drops 2.5K:

   text    data     bss     dec     hex filename
7018612 2034376 7251132 16304120         f8c7f8 vmlinux.o.orig
7018612 2031888 7251132 16301632         f8be40 vmlinux.o

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/syscalls.h      |    2 --
 include/trace/syscall.h       |    1 -
 kernel/trace/trace_syscalls.c |    7 ++++---
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index a1a86a5..5e800c3 100644
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
index d2c859c..19d46a2 100644
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
1.6.3

