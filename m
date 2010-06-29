Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab0F2JXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 05:23:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:39178 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007Ab0F2JXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 05:23:24 -0400
Date: Tue, 29 Jun 2010 09:23:00 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4BFA37BC.8080707@cn.fujitsu.com>
References: <4BFA37BC.8080707@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Remove test of NULL define_fields callback
Message-ID: <tip-c9d932cf8a1c608b676021aef0189376ba6ef151@git.kernel.org>
Git-Commit-ID: c9d932cf8a1c608b676021aef0189376ba6ef151
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 29 Jun 2010 09:23:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c9d932cf8a1c608b676021aef0189376ba6ef151
Gitweb:     http://git.kernel.org/tip/c9d932cf8a1c608b676021aef0189376ba6ef151
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 24 May 2010 16:24:28 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 28 Jun 2010 17:12:52 -0400

tracing: Remove test of NULL define_fields callback

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
 
