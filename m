Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965596Ab2DKX2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:28:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45547 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965563Ab2DKX2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:28:14 -0400
Message-Id: <20120411231309.481308736@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:13:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Wolfgang Mauerer <wolfgang.mauerer@siemens.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 13/42] tracing: Fix ftrace stack trace entries
In-Reply-To: <20120411231443.GA808@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfgang Mauerer <wolfgang.mauerer@siemens.com>

commit 01de982abf8c9e10fc3089e10585cd2cc914bdab upstream.

8 hex characters tell only half the tale for 64 bit CPUs,
so use the appropriate length.

Link: http://lkml.kernel.org/r/1332411501-8059-2-git-send-email-wolfgang.mauerer@siemens.com

Signed-off-by: Wolfgang Mauerer <wolfgang.mauerer@siemens.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_entries.h |   16 ++++++++++++----
 kernel/trace/trace_export.c  |    2 +-
 2 files changed, 13 insertions(+), 5 deletions(-)

--- a/kernel/trace/trace_entries.h
+++ b/kernel/trace/trace_entries.h
@@ -156,6 +156,12 @@ FTRACE_ENTRY_DUP(wakeup, ctx_switch_entr
 
 #define FTRACE_STACK_ENTRIES	8
 
+#ifndef CONFIG_64BIT
+# define IP_FMT "%08lx"
+#else
+# define IP_FMT "%016lx"
+#endif
+
 FTRACE_ENTRY(kernel_stack, stack_entry,
 
 	TRACE_STACK,
@@ -164,8 +170,9 @@ FTRACE_ENTRY(kernel_stack, stack_entry,
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
@@ -180,8 +187,9 @@ FTRACE_ENTRY(user_stack, userstack_entry
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
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -150,7 +150,7 @@ ftrace_define_fields_##name(struct ftrac
 #define __dynamic_array(type, item)
 
 #undef F_printk
-#define F_printk(fmt, args...) #fmt ", "  __stringify(args)
+#define F_printk(fmt, args...) __stringify(fmt) ", "  __stringify(args)
 
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(call, struct_name, etype, tstruct, print)		\


