Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab2CVKdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 06:33:50 -0400
Received: from gecko.sbs.de ([194.138.37.40]:20097 "EHLO gecko.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab2CVKdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 06:33:49 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Mar 2012 06:33:49 EDT
From: Wolfgang Mauerer <wolfgang.mauerer@siemens.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Fix ftrace stack trace entries
Date: Thu, 22 Mar 2012 11:18:20 +0100
Message-Id: <1332411501-8059-2-git-send-email-wolfgang.mauerer@siemens.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1332411501-8059-1-git-send-email-wolfgang.mauerer@siemens.com>
References: <1332411501-8059-1-git-send-email-wolfgang.mauerer@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

8 hex characters tell only half the tale for 64 bit CPUs,
so use the appropriate length.

Signed-off-by: Wolfgang Mauerer <wolfgang.mauerer@siemens.com>
---
 kernel/trace/trace_entries.h |   16 ++++++++++++----
 kernel/trace/trace_export.c  |    2 +-
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_entries.h b/kernel/trace/trace_entries.h
index d91eb05..4108e12 100644
--- a/kernel/trace/trace_entries.h
+++ b/kernel/trace/trace_entries.h
@@ -166,6 +166,12 @@ FTRACE_ENTRY_DUP(wakeup, ctx_switch_entry,
 
 #define FTRACE_STACK_ENTRIES	8
 
+#ifndef CONFIG_64BIT
+# define IP_FMT "%08lx"
+#else
+# define IP_FMT "%016lx"
+#endif
+
 FTRACE_ENTRY(kernel_stack, stack_entry,
 
 	TRACE_STACK,
@@ -175,8 +181,9 @@ FTRACE_ENTRY(kernel_stack, stack_entry,
 		__dynamic_array(unsigned long,	caller	)
 	),
 
-	F_printk("\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n"
-		 "\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n",
+	F_printk("\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n"
+		 "\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n"
+		 "\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n",
 		 __entry->caller[0], __entry->caller[1], __entry->caller[2],
 		 __entry->caller[3], __entry->caller[4], __entry->caller[5],
 		 __entry->caller[6], __entry->caller[7]),
@@ -193,8 +200,9 @@ FTRACE_ENTRY(user_stack, userstack_entry,
 		__array(	unsigned long,	caller, FTRACE_STACK_ENTRIES	)
 	),
 
-	F_printk("\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n"
-		 "\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n",
+	F_printk("\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n"
+		 "\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n"
+		 "\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n",
 		 __entry->caller[0], __entry->caller[1], __entry->caller[2],
 		 __entry->caller[3], __entry->caller[4], __entry->caller[5],
 		 __entry->caller[6], __entry->caller[7]),
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 7b46c9b..3dd15e8 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -162,7 +162,7 @@ ftrace_define_fields_##name(struct ftrace_event_call *event_call)	\
 #define __dynamic_array(type, item)
 
 #undef F_printk
-#define F_printk(fmt, args...) #fmt ", "  __stringify(args)
+#define F_printk(fmt, args...) __stringify(fmt) ", "  __stringify(args)
 
 #undef FTRACE_ENTRY_REG
 #define FTRACE_ENTRY_REG(call, struct_name, etype, tstruct, print, filter,\
-- 
1.7.6.4

