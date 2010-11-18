Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab0KRBdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 20:33:35 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46469 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab0KRBc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 20:32:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=GQ/Mq2VPGy6p+WcZvXuwGsWdGsBwDvR3pUfPvhNMeJLSWY8NWvm3l2KIqh6v8Kgi/U
         YpLYlgifnyJ+0F8dSrWdJop9NBnjaPTgAq/Y/5Gpk3IwGVH16/BoCbCx0gb/jSm7stwW
         ayur1oodJeQzQAgzGQRks7NqhRM/TLC2ftIBQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Jason Baron <jbaron@redhat.com>
Subject: [PATCH 4/5] tracing: Allow syscall trace events for non privileged users
Date: Thu, 18 Nov 2010 02:32:42 +0100
Message-Id: <1290043963-1480-5-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1290043963-1480-1-git-send-regression-fweisbec@gmail.com>
References: <1290043963-1480-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As for the raw syscalls events, individual syscall events won't
leak system wide information on task bound tracing. Allow non
privileged users to use them in such workflow.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jason Baron <jbaron@redhat.com>
---
 include/linux/ftrace_event.h |    8 ++++++++
 include/linux/syscalls.h     |    6 ++++--
 include/trace/ftrace.h       |    7 +------
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 312dce7..725bf6b 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -198,6 +198,14 @@ struct ftrace_event_call {
 #endif
 };
 
+#define __TRACE_EVENT_FLAGS(name, value)				\
+	static int __init trace_init_flags_##name(void)			\
+	{								\
+		event_##name.flags = value;				\
+		return 0;						\
+	}								\
+	early_initcall(trace_init_flags_##name);
+
 #define PERF_MAX_TRACE_SIZE	2048
 
 #define MAX_FILTER_PRED		32
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index cacc27a..13b9731 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -137,7 +137,8 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 		.class			= &event_class_syscall_enter,	\
 		.event.funcs            = &enter_syscall_print_funcs,	\
 		.data			= (void *)&__syscall_meta_##sname,\
-	}
+	};								\
+	__TRACE_EVENT_FLAGS(enter_##sname, TRACE_EVENT_FL_CAP_ANY)
 
 #define SYSCALL_TRACE_EXIT_EVENT(sname)					\
 	static struct syscall_metadata					\
@@ -152,7 +153,8 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 		.class			= &event_class_syscall_exit,	\
 		.event.funcs		= &exit_syscall_print_funcs,	\
 		.data			= (void *)&__syscall_meta_##sname,\
-	}
+	};								\
+	__TRACE_EVENT_FLAGS(exit_##sname, TRACE_EVENT_FL_CAP_ANY)
 
 #define SYSCALL_METADATA(sname, nb)				\
 	SYSCALL_TRACE_ENTER_EVENT(sname);			\
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 6f54012..e718a91 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -84,12 +84,7 @@
 
 #undef TRACE_EVENT_FLAGS
 #define TRACE_EVENT_FLAGS(name, value)					\
-	static int __init trace_init_flags_##name(void)			\
-	{								\
-		event_##name.flags = value;				\
-		return 0;						\
-	}								\
-	early_initcall(trace_init_flags_##name);
+	__TRACE_EVENT_FLAGS(name, value)
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
-- 
1.6.2.3

