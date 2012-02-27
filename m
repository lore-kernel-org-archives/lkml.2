Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab2B0JgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 04:36:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44813 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab2B0JgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 04:36:17 -0500
Date: Mon, 27 Feb 2012 01:35:44 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-e59a0bff3ecf389951e3c9378ddfd00f6448bfaa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        jolsa@redhat.com
In-Reply-To: <1329317514-8131-5-git-send-email-jolsa@redhat.com>
References: <1329317514-8131-5-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace:
  Add FTRACE_ENTRY_REG macro to allow event registration
Git-Commit-ID: e59a0bff3ecf389951e3c9378ddfd00f6448bfaa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 27 Feb 2012 01:36:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e59a0bff3ecf389951e3c9378ddfd00f6448bfaa
Gitweb:     http://git.kernel.org/tip/e59a0bff3ecf389951e3c9378ddfd00f6448bfaa
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 15 Feb 2012 15:51:51 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 21 Feb 2012 11:08:26 -0500

ftrace: Add FTRACE_ENTRY_REG macro to allow event registration

Adding FTRACE_ENTRY_REG macro so particular ftrace entries
could specify registration function and thus become accesible
via perf.

This will be used in upcomming patch for function trace.

Link: http://lkml.kernel.org/r/1329317514-8131-5-git-send-email-jolsa@redhat.com

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h        |    4 ++++
 kernel/trace/trace_export.c |   18 ++++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 55c6ea0..638476a 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -68,6 +68,10 @@ enum trace_type {
 #undef FTRACE_ENTRY_DUP
 #define FTRACE_ENTRY_DUP(name, name_struct, id, tstruct, printk)
 
+#undef FTRACE_ENTRY_REG
+#define FTRACE_ENTRY_REG(name, struct_name, id, tstruct, print, regfn) \
+	FTRACE_ENTRY(name, struct_name, id, PARAMS(tstruct), PARAMS(print))
+
 #include "trace_entries.h"
 
 /*
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index bbeec31..f74de86 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -18,6 +18,14 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM	ftrace
 
+/*
+ * The FTRACE_ENTRY_REG macro allows ftrace entry to define register
+ * function and thus become accesible via perf.
+ */
+#undef FTRACE_ENTRY_REG
+#define FTRACE_ENTRY_REG(name, struct_name, id, tstruct, print, regfn) \
+	FTRACE_ENTRY(name, struct_name, id, PARAMS(tstruct), PARAMS(print))
+
 /* not needed for this file */
 #undef __field_struct
 #define __field_struct(type, item)
@@ -152,13 +160,14 @@ ftrace_define_fields_##name(struct ftrace_event_call *event_call)	\
 #undef F_printk
 #define F_printk(fmt, args...) #fmt ", "  __stringify(args)
 
-#undef FTRACE_ENTRY
-#define FTRACE_ENTRY(call, struct_name, etype, tstruct, print)		\
+#undef FTRACE_ENTRY_REG
+#define FTRACE_ENTRY_REG(call, struct_name, etype, tstruct, print, regfn)\
 									\
 struct ftrace_event_class event_class_ftrace_##call = {			\
 	.system			= __stringify(TRACE_SYSTEM),		\
 	.define_fields		= ftrace_define_fields_##call,		\
 	.fields			= LIST_HEAD_INIT(event_class_ftrace_##call.fields),\
+	.reg			= regfn,				\
 };									\
 									\
 struct ftrace_event_call __used event_##call = {			\
@@ -170,4 +179,9 @@ struct ftrace_event_call __used event_##call = {			\
 struct ftrace_event_call __used						\
 __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call;
 
+#undef FTRACE_ENTRY
+#define FTRACE_ENTRY(call, struct_name, etype, tstruct, print)		\
+	FTRACE_ENTRY_REG(call, struct_name, etype,			\
+			 PARAMS(tstruct), PARAMS(print), NULL)
+
 #include "trace_entries.h"
