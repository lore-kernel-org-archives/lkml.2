Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab0F2DMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 23:12:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47269 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab0F2DKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 23:10:46 -0400
X-Authority-Analysis: v=1.1 cv=hVjE12FRt4v4sD2HVuppbi620CRC5en4UNTr7KPd1ng= c=1 sm=0 a=liv4jqiNzJYA:10 a=yQWWgrYGNuUA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=eRV4yW0wae2RUGSZnZQA:9 a=Q2iANXbTAsMEt_15N9el5wg61UwA:4 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100629031043.851992231@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 28 Jun 2010 23:08:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 5/9] tracing: Remove test of NULL define_fields callback
References: <20100629030836.222433712@goodmis.org>
Content-Disposition: inline; filename=0005-tracing-Remove-test-of-NULL-define_fields-callback.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

Every event (or event class) has it's define_fields callback,
so the test is redundant.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4BFA37BC.8080707@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c        |   28 +++++++++++++---------------
 kernel/trace/trace_events_filter.c |    9 ---------
 2 files changed, 13 insertions(+), 24 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index d3b4bdf..5bad9cb 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -987,23 +987,21 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 		 		  id);
 #endif
 
-	if (call->class->define_fields) {
-		/*
-		 * Other events may have the same class. Only update
-		 * the fields if they are not already defined.
-		 */
-		head = trace_get_fields(call);
-		if (list_empty(head)) {
-			ret = call->class->define_fields(call);
-			if (ret < 0) {
-				pr_warning("Could not initialize trace point"
-					   " events/%s\n", call->name);
-				return ret;
-			}
+	/*
+	 * Other events may have the same class. Only update
+	 * the fields if they are not already defined.
+	 */
+	head = trace_get_fields(call);
+	if (list_empty(head)) {
+		ret = call->class->define_fields(call);
+		if (ret < 0) {
+			pr_warning("Could not initialize trace point"
+				   " events/%s\n", call->name);
+			return ret;
 		}
-		trace_create_file("filter", 0644, call->dir, call,
-				  filter);
 	}
+	trace_create_file("filter", 0644, call->dir, call,
+			  filter);
 
 	trace_create_file("format", 0444, call->dir, call,
 			  format);
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 330fefd..36d4010 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -639,9 +639,6 @@ static int init_subsystem_preds(struct event_subsystem *system)
 	int err;
 
 	list_for_each_entry(call, &ftrace_events, list) {
-		if (!call->class || !call->class->define_fields)
-			continue;
-
 		if (strcmp(call->class->system, system->name) != 0)
 			continue;
 
@@ -658,9 +655,6 @@ static void filter_free_subsystem_preds(struct event_subsystem *system)
 	struct ftrace_event_call *call;
 
 	list_for_each_entry(call, &ftrace_events, list) {
-		if (!call->class || !call->class->define_fields)
-			continue;
-
 		if (strcmp(call->class->system, system->name) != 0)
 			continue;
 
@@ -1263,9 +1257,6 @@ static int replace_system_preds(struct event_subsystem *system,
 	list_for_each_entry(call, &ftrace_events, list) {
 		struct event_filter *filter = call->filter;
 
-		if (!call->class || !call->class->define_fields)
-			continue;
-
 		if (strcmp(call->class->system, system->name) != 0)
 			continue;
 
-- 
1.7.1


