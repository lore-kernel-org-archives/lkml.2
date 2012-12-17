Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab2LQPC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 10:02:58 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:18255 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab2LQPCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 10:02:55 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 15/15] tracing output: use new hashtable implementation
Date: Mon, 17 Dec 2012 10:01:35 -0500
Message-Id: <1355756497-15834-15-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1355756497-15834-1-git-send-email-sasha.levin@oracle.com>
References: <1355756497-15834-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch tracing to use the new hashtable implementation. This reduces the
amount of generic unrelated code in the tracing module.

This patch depends on d9b482c ("hashtable: introduce a small and naive
hashtable") which was merged in v3.6.

Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 kernel/trace/trace_output.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 194d796..d102d26 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -8,15 +8,15 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/ftrace.h>
+#include <linux/hashtable.h>
 
 #include "trace_output.h"
 
-/* must be a power of 2 */
-#define EVENT_HASHSIZE	128
+#define EVENT_HASH_BITS	7
 
 DECLARE_RWSEM(trace_event_mutex);
 
-static struct hlist_head event_hash[EVENT_HASHSIZE] __read_mostly;
+static DEFINE_HASHTABLE(event_hash, EVENT_HASH_BITS);
 
 static int next_event_type = __TRACE_LAST_TYPE + 1;
 
@@ -740,11 +740,8 @@ struct trace_event *ftrace_find_event(int type)
 {
 	struct trace_event *event;
 	struct hlist_node *n;
-	unsigned key;
 
-	key = type & (EVENT_HASHSIZE - 1);
-
-	hlist_for_each_entry(event, n, &event_hash[key], node) {
+	hash_for_each_possible(event_hash, event, n, node, type) {
 		if (event->type == type)
 			return event;
 	}
@@ -809,7 +806,6 @@ void trace_event_read_unlock(void)
  */
 int register_ftrace_event(struct trace_event *event)
 {
-	unsigned key;
 	int ret = 0;
 
 	down_write(&trace_event_mutex);
@@ -861,9 +857,7 @@ int register_ftrace_event(struct trace_event *event)
 	if (event->funcs->binary == NULL)
 		event->funcs->binary = trace_nop_print;
 
-	key = event->type & (EVENT_HASHSIZE - 1);
-
-	hlist_add_head(&event->node, &event_hash[key]);
+	hash_add(event_hash, &event->node, event->type);
 
 	ret = event->type;
  out:
@@ -878,7 +872,7 @@ EXPORT_SYMBOL_GPL(register_ftrace_event);
  */
 int __unregister_ftrace_event(struct trace_event *event)
 {
-	hlist_del(&event->node);
+	hash_del(&event->node);
 	list_del(&event->list);
 	return 0;
 }
-- 
1.8.0

