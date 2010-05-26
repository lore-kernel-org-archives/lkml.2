Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab0EZUMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 16:12:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36876 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862Ab0EZULo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 16:11:44 -0400
X-Authority-Analysis: v=1.1 cv=EbJB9AiBqsyZPMVATYsj78CfMiBiOs+4P7kRKNQkfg0= c=1 sm=0 a=27zEix0Cy8oA:10 a=hO-oPbc3tlwA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=ZwnnlKpAyDbT_5MkDpEA:9 a=2F8-xdeJ_McpgAyFOiWsAvKUabMA:4 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100526201142.571159649@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 26 May 2010 16:10:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 6/7] tracing: Remove redundant raw_init callbacks
References: <20100526201036.951395509@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-Remove-redundant-raw_init-callbacks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

raw_init callback is optional.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4BFA37D4.7070500@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_export.c |    8 +-------
 kernel/trace/trace_kprobe.c |   10 +---------
 2 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 8536e2a..4ba44de 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -125,12 +125,6 @@ ftrace_define_fields_##name(struct ftrace_event_call *event_call)	\
 
 #include "trace_entries.h"
 
-static int ftrace_raw_init_event(struct ftrace_event_call *call)
-{
-	INIT_LIST_HEAD(&call->class->fields);
-	return 0;
-}
-
 #undef __entry
 #define __entry REC
 
@@ -158,7 +152,7 @@ static int ftrace_raw_init_event(struct ftrace_event_call *call)
 struct ftrace_event_class event_class_ftrace_##call = {			\
 	.system			= __stringify(TRACE_SYSTEM),		\
 	.define_fields		= ftrace_define_fields_##call,		\
-	.raw_init		= ftrace_raw_init_event,		\
+	.fields			= LIST_HEAD_INIT(event_class_ftrace_##call.fields),\
 };									\
 									\
 struct ftrace_event_call __used						\
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index faf7cef..fed5919 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1214,11 +1214,6 @@ static void probe_event_disable(struct ftrace_event_call *call)
 	}
 }
 
-static int probe_event_raw_init(struct ftrace_event_call *event_call)
-{
-	return 0;
-}
-
 #undef DEFINE_FIELD
 #define DEFINE_FIELD(type, item, name, is_signed)			\
 	do {								\
@@ -1486,15 +1481,12 @@ static int register_probe_event(struct trace_probe *tp)
 	int ret;
 
 	/* Initialize ftrace_event_call */
+	INIT_LIST_HEAD(&call->class->fields);
 	if (probe_is_return(tp)) {
-		INIT_LIST_HEAD(&call->class->fields);
 		call->event.funcs = &kretprobe_funcs;
-		call->class->raw_init = probe_event_raw_init;
 		call->class->define_fields = kretprobe_event_define_fields;
 	} else {
-		INIT_LIST_HEAD(&call->class->fields);
 		call->event.funcs = &kprobe_funcs;
-		call->class->raw_init = probe_event_raw_init;
 		call->class->define_fields = kprobe_event_define_fields;
 	}
 	if (set_print_fmt(tp) < 0)
-- 
1.7.0


