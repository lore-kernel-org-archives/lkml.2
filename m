Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab0F2JXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 05:23:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:39189 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007Ab0F2JXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 05:23:46 -0400
Date: Tue, 29 Jun 2010 09:23:20 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4BFA37D4.7070500@cn.fujitsu.com>
References: <4BFA37D4.7070500@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Remove redundant raw_init callbacks
Message-ID: <tip-ffb9f99528574ab9a55d4c8fd22e9d3ca49efa86@git.kernel.org>
Git-Commit-ID: ffb9f99528574ab9a55d4c8fd22e9d3ca49efa86
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 29 Jun 2010 09:23:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ffb9f99528574ab9a55d4c8fd22e9d3ca49efa86
Gitweb:     http://git.kernel.org/tip/ffb9f99528574ab9a55d4c8fd22e9d3ca49efa86
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 24 May 2010 16:24:52 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 28 Jun 2010 17:12:53 -0400

tracing: Remove redundant raw_init callbacks

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
index f52b5f5..3b831d8 100644
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
