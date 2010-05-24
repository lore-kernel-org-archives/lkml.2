Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab0EXIWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 04:22:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52351 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753783Ab0EXIWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 04:22:34 -0400
Message-ID: <4BFA37D4.7070500@cn.fujitsu.com>
Date: Mon, 24 May 2010 16:24:52 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 7/8] tracing: Remove redundant raw_init callbacks
References: <4BFA3728.3000701@cn.fujitsu.com>
In-Reply-To: <4BFA3728.3000701@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

raw_init callback is optional.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
1.6.3

