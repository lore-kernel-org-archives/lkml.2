Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab0EXIWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 04:22:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57017 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753812Ab0EXIWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 04:22:10 -0400
Message-ID: <4BFA37BC.8080707@cn.fujitsu.com>
Date: Mon, 24 May 2010 16:24:28 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/8] tracing: Remove test of NULL define_fields callback
References: <4BFA3728.3000701@cn.fujitsu.com>
In-Reply-To: <4BFA3728.3000701@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every event (or event class) has it's define_fields callback,
so the test is redundant.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_events.c        |   28 +++++++++++++---------------
 kernel/trace/trace_events_filter.c |    9 ---------
 2 files changed, 13 insertions(+), 24 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index efe1ffd..b5d5b73 100644
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
1.6.3

