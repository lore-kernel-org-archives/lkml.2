Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab1ESCM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 22:12:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58541 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944Ab1ESCM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 22:12:56 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=cApj_IFiptoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=-PYXUXeuTtzzRoD8VA8A:9 a=atM6AopCHsmQ5EBbcBEA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110519021255.703337577@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 22:11:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 05/13] ftrace: Use counters to enable functions to trace
References: <20110519021151.600991800@goodmis.org>
Content-Disposition: inline; filename=0005-ftrace-Use-counters-to-enable-functions-to-trace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Every function has its own record that stores the instruction
pointer and flags for the function to be traced. There are only
two flags: enabled and free. The enabled flag states that tracing
for the function has been enabled (actively traced), and the free
flag states that the record no longer points to a function and can
be used by new functions (loaded modules).

These flags are now moved to the MSB of the flags (actually just
the top 32bits). The rest of the bits (30 bits) are now used as
a ref counter. Everytime a tracer register functions to trace,
those functions will have its counter incremented.

When tracing is enabled, to determine if a function should be traced,
the counter is examined, and if it is non-zero it is set to trace.

When a ftrace_ops is registered to trace functions, its hashes
are examined. If the ftrace_ops filter_hash count is zero, then
all functions are set to be traced, otherwise only the functions
in the hash are to be traced. The exception to this is if a function
is also in the ftrace_ops notrace_hash. Then that function's counter
is not incremented for this ftrace_ops.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    8 ++-
 kernel/trace/ftrace.c  |  158 +++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 148 insertions(+), 18 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 6658a51..ab1c46e 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -37,6 +37,7 @@ struct ftrace_ops {
 #ifdef CONFIG_DYNAMIC_FTRACE
 	struct ftrace_hash		*notrace_hash;
 	struct ftrace_hash		*filter_hash;
+	unsigned long			flags;
 #endif
 };
 
@@ -152,10 +153,13 @@ extern void unregister_ftrace_function_probe_all(char *glob);
 extern int ftrace_text_reserved(void *start, void *end);
 
 enum {
-	FTRACE_FL_FREE		= (1 << 0),
-	FTRACE_FL_ENABLED	= (1 << 1),
+	FTRACE_FL_ENABLED	= (1 << 30),
+	FTRACE_FL_FREE		= (1 << 31),
 };
 
+#define FTRACE_FL_MASK		(0x3UL << 30)
+#define FTRACE_REF_MAX		((1 << 30) - 1)
+
 struct dyn_ftrace {
 	union {
 		unsigned long		ip; /* address of mcount call-site */
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 46f0826..5dd332c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -890,6 +890,10 @@ static const struct ftrace_hash empty_hash = {
 };
 #define EMPTY_HASH	((struct ftrace_hash *)&empty_hash)
 
+enum {
+	FTRACE_OPS_FL_ENABLED		= 1,
+};
+
 struct ftrace_ops global_ops = {
 	.func			= ftrace_stub,
 	.notrace_hash		= EMPTY_HASH,
@@ -1161,6 +1165,105 @@ ftrace_hash_move(struct ftrace_hash **dst, struct ftrace_hash *src)
 		}				\
 	}
 
+static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
+				     int filter_hash,
+				     bool inc)
+{
+	struct ftrace_hash *hash;
+	struct ftrace_hash *other_hash;
+	struct ftrace_page *pg;
+	struct dyn_ftrace *rec;
+	int count = 0;
+	int all = 0;
+
+	/* Only update if the ops has been registered */
+	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
+		return;
+
+	/*
+	 * In the filter_hash case:
+	 *   If the count is zero, we update all records.
+	 *   Otherwise we just update the items in the hash.
+	 *
+	 * In the notrace_hash case:
+	 *   We enable the update in the hash.
+	 *   As disabling notrace means enabling the tracing,
+	 *   and enabling notrace means disabling, the inc variable
+	 *   gets inversed.
+	 */
+	if (filter_hash) {
+		hash = ops->filter_hash;
+		other_hash = ops->notrace_hash;
+		if (!hash->count)
+			all = 1;
+	} else {
+		inc = !inc;
+		hash = ops->notrace_hash;
+		other_hash = ops->filter_hash;
+		/*
+		 * If the notrace hash has no items,
+		 * then there's nothing to do.
+		 */
+		if (!hash->count)
+			return;
+	}
+
+	do_for_each_ftrace_rec(pg, rec) {
+		int in_other_hash = 0;
+		int in_hash = 0;
+		int match = 0;
+
+		if (all) {
+			/*
+			 * Only the filter_hash affects all records.
+			 * Update if the record is not in the notrace hash.
+			 */
+			if (!ftrace_lookup_ip(other_hash, rec->ip))
+				match = 1;
+		} else {
+			in_hash = !!ftrace_lookup_ip(hash, rec->ip);
+			in_other_hash = !!ftrace_lookup_ip(other_hash, rec->ip);
+
+			/*
+			 *
+			 */
+			if (filter_hash && in_hash && !in_other_hash)
+				match = 1;
+			else if (!filter_hash && in_hash &&
+				 (in_other_hash || !other_hash->count))
+				match = 1;
+		}
+		if (!match)
+			continue;
+
+		if (inc) {
+			rec->flags++;
+			if (FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == FTRACE_REF_MAX))
+				return;
+		} else {
+			if (FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == 0))
+				return;
+			rec->flags--;
+		}
+		count++;
+		/* Shortcut, if we handled all records, we are done. */
+		if (!all && count == hash->count)
+			return;
+	} while_for_each_ftrace_rec();
+}
+
+static void ftrace_hash_rec_disable(struct ftrace_ops *ops,
+				    int filter_hash)
+{
+	__ftrace_hash_rec_update(ops, filter_hash, 0);
+}
+
+static void ftrace_hash_rec_enable(struct ftrace_ops *ops,
+				   int filter_hash)
+{
+	__ftrace_hash_rec_update(ops, filter_hash, 1);
+}
+
 static void ftrace_free_rec(struct dyn_ftrace *rec)
 {
 	rec->freelist = ftrace_free_records;
@@ -1276,26 +1379,24 @@ int ftrace_text_reserved(void *start, void *end)
 static int
 __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 {
-	struct ftrace_ops *ops = &global_ops;
 	unsigned long ftrace_addr;
 	unsigned long flag = 0UL;
 
 	ftrace_addr = (unsigned long)FTRACE_ADDR;
 
 	/*
-	 * If this record is not to be traced or we want to disable it,
-	 * then disable it.
+	 * If we are enabling tracing:
 	 *
-	 * If we want to enable it and filtering is off, then enable it.
+	 *   If the record has a ref count, then we need to enable it
+	 *   because someone is using it.
 	 *
-	 * If we want to enable it and filtering is on, enable it only if
-	 * it's filtered
+	 *   Otherwise we make sure its disabled.
+	 *
+	 * If we are disabling tracing, then disable all records that
+	 * are enabled.
 	 */
-	if (enable && !ftrace_lookup_ip(ops->notrace_hash, rec->ip)) {
-		if (!ops->filter_hash->count ||
-		    ftrace_lookup_ip(ops->filter_hash, rec->ip))
-			flag = FTRACE_FL_ENABLED;
-	}
+	if (enable && (rec->flags & ~FTRACE_FL_MASK))
+		flag = FTRACE_FL_ENABLED;
 
 	/* If the state of this record hasn't changed, then do nothing */
 	if ((rec->flags & FTRACE_FL_ENABLED) == flag)
@@ -1423,17 +1524,25 @@ static void ftrace_startup_enable(int command)
 
 static void ftrace_startup(int command)
 {
+	struct ftrace_ops *ops = &global_ops;
+
 	if (unlikely(ftrace_disabled))
 		return;
 
 	ftrace_start_up++;
 	command |= FTRACE_ENABLE_CALLS;
 
+	ops->flags |= FTRACE_OPS_FL_ENABLED;
+	if (ftrace_start_up == 1)
+		ftrace_hash_rec_enable(ops, 1);
+
 	ftrace_startup_enable(command);
 }
 
 static void ftrace_shutdown(int command)
 {
+	struct ftrace_ops *ops = &global_ops;
+
 	if (unlikely(ftrace_disabled))
 		return;
 
@@ -1446,7 +1555,12 @@ static void ftrace_shutdown(int command)
 	WARN_ON_ONCE(ftrace_start_up < 0);
 
 	if (!ftrace_start_up)
+		ftrace_hash_rec_disable(ops, 1);
+
+	if (!ftrace_start_up) {
 		command |= FTRACE_DISABLE_CALLS;
+		ops->flags &= ~FTRACE_OPS_FL_ENABLED;
+	}
 
 	if (saved_ftrace_func != ftrace_trace_function) {
 		saved_ftrace_func = ftrace_trace_function;
@@ -2668,6 +2782,7 @@ ftrace_regex_release(struct inode *inode, struct file *file)
 	struct ftrace_iterator *iter;
 	struct ftrace_hash **orig_hash;
 	struct trace_parser *parser;
+	int filter_hash;
 	int ret;
 
 	mutex_lock(&ftrace_regex_lock);
@@ -2687,15 +2802,26 @@ ftrace_regex_release(struct inode *inode, struct file *file)
 	trace_parser_put(parser);
 
 	if (file->f_mode & FMODE_WRITE) {
-		if (iter->flags & FTRACE_ITER_NOTRACE)
-			orig_hash = &iter->ops->notrace_hash;
-		else
+		filter_hash = !!(iter->flags & FTRACE_ITER_FILTER);
+
+		if (filter_hash)
 			orig_hash = &iter->ops->filter_hash;
+		else
+			orig_hash = &iter->ops->notrace_hash;
 
 		mutex_lock(&ftrace_lock);
+		/*
+		 * Remove the current set, update the hash and add
+		 * them back.
+		 */
+		ftrace_hash_rec_disable(iter->ops, filter_hash);
 		ret = ftrace_hash_move(orig_hash, iter->hash);
-		if (!ret && ftrace_start_up && ftrace_enabled)
-			ftrace_run_update_code(FTRACE_ENABLE_CALLS);
+		if (!ret) {
+			ftrace_hash_rec_enable(iter->ops, filter_hash);
+			if (iter->ops->flags & FTRACE_OPS_FL_ENABLED
+			    && ftrace_enabled)
+				ftrace_run_update_code(FTRACE_ENABLE_CALLS);
+		}
 		mutex_unlock(&ftrace_lock);
 	}
 	free_ftrace_hash(iter->hash);
-- 
1.7.4.4


