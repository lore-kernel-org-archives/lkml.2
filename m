Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab1LERXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:23:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755455Ab1LERXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:23:10 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, aarapov@redhat.com,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHv2 02/10] ftrace: Change mcount call replacement logic
Date: Mon,  5 Dec 2011 18:22:48 +0100
Message-Id: <1323105776-26961-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1323105776-26961-1-git-send-email-jolsa@redhat.com>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
 <1323105776-26961-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current logic of updating calls is to do the mcount replacement
only when ftrace_ops is being registered. When ftrace_ops is being
unregistered then only in case it was the last registered ftrace_ops,
all calls are disabled.

This is an issue when ftrace_ops without FTRACE_OPS_FL_GLOBAL flag
is being unregistered, because all the functions stays enabled
and thus inherrited by global_ops, like in following scenario:

  - set restricting global filter
  - enable function trace
  - register/unregister ftrace_ops with flags != FTRACE_OPS_FL_GLOBAL
    and with no filter

Now the global_ops will get by all the functions regardless the
global_ops filter. So we need all functions that where enabled via
this ftrace_ops and are not part of global filter to be disabled.

Note, currently if there are only global ftrace_ops registered,
there's no filter hash check and the filter is represented only
by enabled records.

Changing the ftrace_shutdown logic to ensure the replacement
is called for each ftrace_ops being unregistered.

Also changing FTRACE_ENABLE_CALLS into FTRACE_UPDATE_CALLS
calls which seems more suitable now.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/ftrace.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index c6d0293..b79ab33 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -948,7 +948,7 @@ struct ftrace_func_probe {
 };
 
 enum {
-	FTRACE_ENABLE_CALLS		= (1 << 0),
+	FTRACE_UPDATE_CALLS		= (1 << 0),
 	FTRACE_DISABLE_CALLS		= (1 << 1),
 	FTRACE_UPDATE_TRACE_FUNC	= (1 << 2),
 	FTRACE_START_FUNC_RET		= (1 << 3),
@@ -1520,7 +1520,7 @@ int ftrace_text_reserved(void *start, void *end)
 
 
 static int
-__ftrace_replace_code(struct dyn_ftrace *rec, int enable)
+__ftrace_replace_code(struct dyn_ftrace *rec, int update)
 {
 	unsigned long ftrace_addr;
 	unsigned long flag = 0UL;
@@ -1528,17 +1528,17 @@ __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 	ftrace_addr = (unsigned long)FTRACE_ADDR;
 
 	/*
-	 * If we are enabling tracing:
+	 * If we are updating calls:
 	 *
 	 *   If the record has a ref count, then we need to enable it
 	 *   because someone is using it.
 	 *
 	 *   Otherwise we make sure its disabled.
 	 *
-	 * If we are disabling tracing, then disable all records that
+	 * If we are disabling calls, then disable all records that
 	 * are enabled.
 	 */
-	if (enable && (rec->flags & ~FTRACE_FL_MASK))
+	if (update && (rec->flags & ~FTRACE_FL_MASK))
 		flag = FTRACE_FL_ENABLED;
 
 	/* If the state of this record hasn't changed, then do nothing */
@@ -1554,7 +1554,7 @@ __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 	return ftrace_make_nop(NULL, rec, ftrace_addr);
 }
 
-static void ftrace_replace_code(int enable)
+static void ftrace_replace_code(int update)
 {
 	struct dyn_ftrace *rec;
 	struct ftrace_page *pg;
@@ -1568,7 +1568,7 @@ static void ftrace_replace_code(int enable)
 		if (rec->flags & FTRACE_FL_FREE)
 			continue;
 
-		failed = __ftrace_replace_code(rec, enable);
+		failed = __ftrace_replace_code(rec, update);
 		if (failed) {
 			ftrace_bug(failed, rec->ip);
 			/* Stop processing */
@@ -1624,7 +1624,7 @@ static int __ftrace_modify_code(void *data)
 	 */
 	function_trace_stop++;
 
-	if (*command & FTRACE_ENABLE_CALLS)
+	if (*command & FTRACE_UPDATE_CALLS)
 		ftrace_replace_code(1);
 	else if (*command & FTRACE_DISABLE_CALLS)
 		ftrace_replace_code(0);
@@ -1692,7 +1692,7 @@ static int ftrace_startup(struct ftrace_ops *ops, int command)
 		return -ENODEV;
 
 	ftrace_start_up++;
-	command |= FTRACE_ENABLE_CALLS;
+	command |= FTRACE_UPDATE_CALLS;
 
 	/* ops marked global share the filter hashes */
 	if (ops->flags & FTRACE_OPS_FL_GLOBAL) {
@@ -1744,8 +1744,7 @@ static void ftrace_shutdown(struct ftrace_ops *ops, int command)
 	if (ops != &global_ops || !global_start_up)
 		ops->flags &= ~FTRACE_OPS_FL_ENABLED;
 
-	if (!ftrace_start_up)
-		command |= FTRACE_DISABLE_CALLS;
+	command |= FTRACE_UPDATE_CALLS;
 
 	if (saved_ftrace_func != ftrace_trace_function) {
 		saved_ftrace_func = ftrace_trace_function;
@@ -1767,7 +1766,7 @@ static void ftrace_startup_sysctl(void)
 	saved_ftrace_func = NULL;
 	/* ftrace_start_up is true if we want ftrace running */
 	if (ftrace_start_up)
-		ftrace_run_update_code(FTRACE_ENABLE_CALLS);
+		ftrace_run_update_code(FTRACE_UPDATE_CALLS);
 }
 
 static void ftrace_shutdown_sysctl(void)
@@ -2920,7 +2919,7 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
 	ret = ftrace_hash_move(ops, enable, orig_hash, hash);
 	if (!ret && ops->flags & FTRACE_OPS_FL_ENABLED
 	    && ftrace_enabled)
-		ftrace_run_update_code(FTRACE_ENABLE_CALLS);
+		ftrace_run_update_code(FTRACE_UPDATE_CALLS);
 
 	mutex_unlock(&ftrace_lock);
 
@@ -3108,7 +3107,7 @@ ftrace_regex_release(struct inode *inode, struct file *file)
 				       orig_hash, iter->hash);
 		if (!ret && (iter->ops->flags & FTRACE_OPS_FL_ENABLED)
 		    && ftrace_enabled)
-			ftrace_run_update_code(FTRACE_ENABLE_CALLS);
+			ftrace_run_update_code(FTRACE_UPDATE_CALLS);
 
 		mutex_unlock(&ftrace_lock);
 	}
-- 
1.7.1

