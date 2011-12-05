Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648Ab1LERXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:23:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932630Ab1LERX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:23:28 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, aarapov@redhat.com,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHv2 10/10] ftrace, graph: Add global_ops filter callback for graph tracing
Date: Mon,  5 Dec 2011 18:22:56 +0100
Message-Id: <1323105776-26961-11-git-send-email-jolsa@redhat.com>
In-Reply-To: <1323105776-26961-1-git-send-email-jolsa@redhat.com>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
 <1323105776-26961-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function graph tracer should depend on the global_ops filter,
and process only functions that pass the global_ops filter.

Currently the function graph tracer gets all the functions
enabled for tracing no matter what ftrace_ops enabled them.

Adding a hook for the graph entry callback, which ensures the
function is compared against the global_ops filter and bail
out of if it does not match.

This hook is enabled only if there's at least one non global
ftrace_ops registered.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/ftrace.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 2dae0c7..dc49ba6 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -95,10 +95,13 @@ ftrace_func_t __ftrace_trace_function __read_mostly = ftrace_stub;
 ftrace_func_t ftrace_pid_function __read_mostly = ftrace_stub;
 static struct ftrace_ops global_ops;
 static struct ftrace_ops control_ops;
+static int non_global_ops_registered;
 
 static void
 ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip);
 
+static void ftrace_graph_update_filter(void);
+
 /*
  * Traverse the ftrace_global_list, invoking all entries.  The reason that we
  * can use rcu_dereference_raw() is that elements removed from this list
@@ -330,6 +333,9 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
 	if (!core_kernel_data((unsigned long)ops))
 		ops->flags |= FTRACE_OPS_FL_DYNAMIC;
 
+	if (!(ops->flags & FTRACE_OPS_FL_GLOBAL))
+		non_global_ops_registered++;
+
 	if (ops->flags & FTRACE_OPS_FL_GLOBAL) {
 		add_ftrace_ops(&ftrace_global_list, &global_ops, ops);
 		ops->flags |= FTRACE_OPS_FL_ENABLED;
@@ -359,6 +365,9 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 	if (FTRACE_WARN_ON(ops == &global_ops))
 		return -EINVAL;
 
+	if (!(ops->flags & FTRACE_OPS_FL_GLOBAL))
+		non_global_ops_registered--;
+
 	if (ops->flags & FTRACE_OPS_FL_GLOBAL) {
 		ret = remove_ftrace_ops(&ftrace_global_list, &global_ops, ops);
 		if (!ret)
@@ -1695,6 +1704,8 @@ static int __ftrace_modify_code(void *data)
 	if (*command & FTRACE_UPDATE_TRACE_FUNC)
 		ftrace_update_ftrace_func(ftrace_trace_function);
 
+	ftrace_graph_update_filter();
+
 	if (*command & FTRACE_START_FUNC_RET)
 		ftrace_enable_ftrace_graph_caller();
 	else if (*command & FTRACE_STOP_FUNC_RET)
@@ -4339,4 +4350,34 @@ void ftrace_graph_stop(void)
 {
 	ftrace_stop();
 }
+
+static trace_func_graph_ent_t ftrace_graph_entry_saved;
+
+int ftrace_graph_entry_filter(struct ftrace_graph_ent *ent)
+{
+	if (ftrace_ops_test(&global_ops, ent->func))
+		return ftrace_graph_entry_saved(ent);
+
+	return 0;
+}
+
+static void ftrace_graph_update_filter(void)
+{
+	bool installed = (ftrace_graph_entry == ftrace_graph_entry_filter);
+
+	if (!ftrace_graph_active)
+		return;
+
+	if (!installed && non_global_ops_registered) {
+		ftrace_graph_entry_saved = ftrace_graph_entry;
+		ftrace_graph_entry = ftrace_graph_entry_filter;
+		return;
+	}
+
+	if (installed && !non_global_ops_registered)
+		ftrace_graph_entry = ftrace_graph_entry_saved;
+}
+
+#else
+static void ftrace_graph_update_filter(void) { }
 #endif
-- 
1.7.1

