Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab2CXH4c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 03:56:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60528 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab2CXH4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 03:56:30 -0400
Date: Sat, 24 Mar 2012 00:56:04 -0700
From: tip-bot for Wolfgang Mauerer <wolfgang.mauerer@siemens.com>
Message-ID: <tip-01de982abf8c9e10fc3089e10585cd2cc914bdab@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, wolfgang.mauerer@siemens.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, wolfgang.mauerer@siemens.com, tglx@linutronix.de
In-Reply-To: <1332411501-8059-2-git-send-email-wolfgang.mauerer@siemens.com>
References: <1332411501-8059-2-git-send-email-wolfgang.mauerer@siemens.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing: Fix ftrace stack trace entries
Git-Commit-ID: 01de982abf8c9e10fc3089e10585cd2cc914bdab
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 24 Mar 2012 00:56:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  01de982abf8c9e10fc3089e10585cd2cc914bdab
Gitweb:     http://git.kernel.org/tip/01de982abf8c9e10fc3089e10585cd2cc914bdab
Author:     Wolfgang Mauerer <wolfgang.mauerer@siemens.com>
AuthorDate: Thu, 22 Mar 2012 11:18:20 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 22 Mar 2012 12:19:23 -0400

tracing: Fix ftrace stack trace entries

8 hex characters tell only half the tale for 64 bit CPUs,
so use the appropriate length.

Link: http://lkml.kernel.org/r/1332411501-8059-2-git-send-email-wolfgang.mauerer@siemens.com

Cc: stable@vger.kernel.org
Signed-off-by: Wolfgang Mauerer <wolfgang.mauerer@siemens.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_entries.h |   16 ++++++++++++----
 kernel/trace/trace_export.c  |    2 +-
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_entries.h b/kernel/trace/trace_entries.h
index 9336590..205dcac 100644
--- a/kernel/trace/trace_entries.h
+++ b/kernel/trace/trace_entries.h
@@ -156,6 +156,12 @@ FTRACE_ENTRY_DUP(wakeup, ctx_switch_entry,
 
 #define FTRACE_STACK_ENTRIES	8
 
+#ifndef CONFIG_64BIT
+# define IP_FMT "%08lx"
+#else
+# define IP_FMT "%016lx"
+#endif
+
 FTRACE_ENTRY(kernel_stack, stack_entry,
 
 	TRACE_STACK,
@@ -165,8 +171,9 @@ FTRACE_ENTRY(kernel_stack, stack_entry,
 		__dynamic_array(unsigned long,	caller	)
 	),
 
-	F_printk("\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n"
-		 "\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n",
+	F_printk("\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n"
+		 "\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n"
+		 "\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n",
 		 __entry->caller[0], __entry->caller[1], __entry->caller[2],
 		 __entry->caller[3], __entry->caller[4], __entry->caller[5],
 		 __entry->caller[6], __entry->caller[7])
@@ -181,8 +188,9 @@ FTRACE_ENTRY(user_stack, userstack_entry,
 		__array(	unsigned long,	caller, FTRACE_STACK_ENTRIES	)
 	),
 
-	F_printk("\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n"
-		 "\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n",
+	F_printk("\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n"
+		 "\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n"
+		 "\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n",
 		 __entry->caller[0], __entry->caller[1], __entry->caller[2],
 		 __entry->caller[3], __entry->caller[4], __entry->caller[5],
 		 __entry->caller[6], __entry->caller[7])
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index bbeec31..ad4000c 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -150,7 +150,7 @@ ftrace_define_fields_##name(struct ftrace_event_call *event_call)	\
 #define __dynamic_array(type, item)
 
 #undef F_printk
-#define F_printk(fmt, args...) #fmt ", "  __stringify(args)
+#define F_printk(fmt, args...) __stringify(fmt) ", "  __stringify(args)
 
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(call, struct_name, etype, tstruct, print)		\
