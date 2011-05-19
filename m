Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343Ab1ESCPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 22:15:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48926 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875Ab1ESCM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 22:12:56 -0400
X-Authority-Analysis: v=1.1 cv=NmbQexcdgr4rtO3OwYGrP5Q3rTMpacrTPhuaXkv4uP8= c=1 sm=0 a=vhdKIqpQuCYA:10 a=XqpGQbwg3coA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=3cxHkMQEFdGqQ6Wq5cIA:9 a=LicYF8E005Bni-BgX0AA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110519021255.257168594@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 22:11:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 03/13] ftrace: Create a global_ops to hold the filter and notrace hashes
References: <20110519021151.600991800@goodmis.org>
Content-Disposition: inline; filename=0003-ftrace-Create-a-global_ops-to-hold-the-filter-and-no.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Combine the filter and notrace hashes to be accessed by a single entity,
the global_ops. The global_ops is a ftrace_ops structure that is passed
to different functions that can read or modify the filtering of the
function tracer.

The ftrace_ops structure was modified to hold a filter and notrace
hashes so that later patches may allow each ftrace_ops to have its own
set of rules to what functions may be filtered.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |   10 ++++++-
 kernel/trace/ftrace.c  |   65 ++++++++++++++++++++++++++++++++++--------------
 2 files changed, 54 insertions(+), 21 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 52fc5d4..6658a51 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -29,9 +29,15 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 
 typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip);
 
+struct ftrace_hash;
+
 struct ftrace_ops {
-	ftrace_func_t	  func;
-	struct ftrace_ops *next;
+	ftrace_func_t			func;
+	struct ftrace_ops		*next;
+#ifdef CONFIG_DYNAMIC_FTRACE
+	struct ftrace_hash		*notrace_hash;
+	struct ftrace_hash		*filter_hash;
+#endif
 };
 
 extern int function_trace_stop;
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 222eca4..a517a6c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -889,6 +889,12 @@ static struct ftrace_hash filter_hash = {
 	.buckets = filter_buckets,
 };
 
+struct ftrace_ops global_ops = {
+	.func			= ftrace_stub,
+	.notrace_hash		= &notrace_hash,
+	.filter_hash		= &filter_hash,
+};
+
 static struct dyn_ftrace *ftrace_new_addrs;
 
 static DEFINE_MUTEX(ftrace_regex_lock);
@@ -1112,6 +1118,7 @@ int ftrace_text_reserved(void *start, void *end)
 static int
 __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 {
+	struct ftrace_ops *ops = &global_ops;
 	unsigned long ftrace_addr;
 	unsigned long flag = 0UL;
 
@@ -1126,8 +1133,9 @@ __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 	 * If we want to enable it and filtering is on, enable it only if
 	 * it's filtered
 	 */
-	if (enable && !ftrace_lookup_ip(&notrace_hash, rec->ip)) {
-		if (!filter_hash.count || ftrace_lookup_ip(&filter_hash, rec->ip))
+	if (enable && !ftrace_lookup_ip(ops->notrace_hash, rec->ip)) {
+		if (!ops->filter_hash->count ||
+		    ftrace_lookup_ip(ops->filter_hash, rec->ip))
 			flag = FTRACE_FL_ENABLED;
 	}
 
@@ -1531,6 +1539,7 @@ static void *
 t_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	struct ftrace_iterator *iter = m->private;
+	struct ftrace_ops *ops = &global_ops;
 	struct dyn_ftrace *rec = NULL;
 
 	if (unlikely(ftrace_disabled))
@@ -1557,10 +1566,10 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 		if ((rec->flags & FTRACE_FL_FREE) ||
 
 		    ((iter->flags & FTRACE_ITER_FILTER) &&
-		     !(ftrace_lookup_ip(&filter_hash, rec->ip))) ||
+		     !(ftrace_lookup_ip(ops->filter_hash, rec->ip))) ||
 
 		    ((iter->flags & FTRACE_ITER_NOTRACE) &&
-		     !ftrace_lookup_ip(&notrace_hash, rec->ip))) {
+		     !ftrace_lookup_ip(ops->notrace_hash, rec->ip))) {
 			rec = NULL;
 			goto retry;
 		}
@@ -1584,6 +1593,7 @@ static void reset_iter_read(struct ftrace_iterator *iter)
 static void *t_start(struct seq_file *m, loff_t *pos)
 {
 	struct ftrace_iterator *iter = m->private;
+	struct ftrace_ops *ops = &global_ops;
 	void *p = NULL;
 	loff_t l;
 
@@ -1603,7 +1613,7 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 	 * off, we can short cut and just print out that all
 	 * functions are enabled.
 	 */
-	if (iter->flags & FTRACE_ITER_FILTER && !filter_hash.count) {
+	if (iter->flags & FTRACE_ITER_FILTER && !ops->filter_hash->count) {
 		if (*pos > 0)
 			return t_hash_start(m, pos);
 		iter->flags |= FTRACE_ITER_PRINTALL;
@@ -1708,10 +1718,11 @@ static void ftrace_filter_reset(struct ftrace_hash *hash)
 }
 
 static int
-ftrace_regex_open(struct ftrace_hash *hash, int flag,
+ftrace_regex_open(struct ftrace_ops *ops, int flag,
 		  struct inode *inode, struct file *file)
 {
 	struct ftrace_iterator *iter;
+	struct ftrace_hash *hash;
 	int ret = 0;
 
 	if (unlikely(ftrace_disabled))
@@ -1726,6 +1737,11 @@ ftrace_regex_open(struct ftrace_hash *hash, int flag,
 		return -ENOMEM;
 	}
 
+	if (flag & FTRACE_ITER_NOTRACE)
+		hash = ops->notrace_hash;
+	else
+		hash = ops->filter_hash;
+
 	iter->hash = hash;
 
 	mutex_lock(&ftrace_regex_lock);
@@ -1755,14 +1771,14 @@ ftrace_regex_open(struct ftrace_hash *hash, int flag,
 static int
 ftrace_filter_open(struct inode *inode, struct file *file)
 {
-	return ftrace_regex_open(&filter_hash, FTRACE_ITER_FILTER,
+	return ftrace_regex_open(&global_ops, FTRACE_ITER_FILTER,
 				 inode, file);
 }
 
 static int
 ftrace_notrace_open(struct inode *inode, struct file *file)
 {
-	return ftrace_regex_open(&notrace_hash, FTRACE_ITER_NOTRACE,
+	return ftrace_regex_open(&global_ops, FTRACE_ITER_NOTRACE,
 				 inode, file);
 }
 
@@ -1923,6 +1939,7 @@ ftrace_match_module_records(struct ftrace_hash *hash, char *buff, char *mod)
 static int
 ftrace_mod_callback(char *func, char *cmd, char *param, int enable)
 {
+	struct ftrace_ops *ops = &global_ops;
 	struct ftrace_hash *hash;
 	char *mod;
 	int ret = -EINVAL;
@@ -1944,9 +1961,9 @@ ftrace_mod_callback(char *func, char *cmd, char *param, int enable)
 		return ret;
 
 	if (enable)
-		hash = &filter_hash;
+		hash = ops->filter_hash;
 	else
-		hash = &notrace_hash;
+		hash = ops->notrace_hash;
 
 	ret = ftrace_match_module_records(hash, func, mod);
 	if (!ret)
@@ -2245,14 +2262,15 @@ int unregister_ftrace_command(struct ftrace_func_command *cmd)
 static int ftrace_process_regex(char *buff, int len, int enable)
 {
 	char *func, *command, *next = buff;
+	struct ftrace_ops *ops = &global_ops;
 	struct ftrace_func_command *p;
 	struct ftrace_hash *hash;
 	int ret;
 
 	if (enable)
-		hash = &filter_hash;
+		hash = ops->filter_hash;
 	else
-		hash = &notrace_hash;
+		hash = ops->notrace_hash;
 
 	func = strsep(&next, ":");
 
@@ -2339,11 +2357,19 @@ ftrace_notrace_write(struct file *file, const char __user *ubuf,
 }
 
 static void
-ftrace_set_regex(struct ftrace_hash *hash, unsigned char *buf, int len, int reset)
+ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
+		 int reset, int enable)
 {
+	struct ftrace_hash *hash;
+
 	if (unlikely(ftrace_disabled))
 		return;
 
+	if (enable)
+		hash = ops->filter_hash;
+	else
+		hash = ops->notrace_hash;
+
 	mutex_lock(&ftrace_regex_lock);
 	if (reset)
 		ftrace_filter_reset(hash);
@@ -2363,7 +2389,7 @@ ftrace_set_regex(struct ftrace_hash *hash, unsigned char *buf, int len, int rese
  */
 void ftrace_set_filter(unsigned char *buf, int len, int reset)
 {
-	ftrace_set_regex(&filter_hash, buf, len, reset);
+	ftrace_set_regex(&global_ops, buf, len, reset, 1);
 }
 
 /**
@@ -2378,7 +2404,7 @@ void ftrace_set_filter(unsigned char *buf, int len, int reset)
  */
 void ftrace_set_notrace(unsigned char *buf, int len, int reset)
 {
-	ftrace_set_regex(&notrace_hash, buf, len, reset);
+	ftrace_set_regex(&global_ops, buf, len, reset, 0);
 }
 
 /*
@@ -2430,22 +2456,23 @@ static void __init set_ftrace_early_graph(char *buf)
 }
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
-static void __init set_ftrace_early_filter(struct ftrace_hash *hash, char *buf)
+static void __init
+set_ftrace_early_filter(struct ftrace_ops *ops, char *buf, int enable)
 {
 	char *func;
 
 	while (buf) {
 		func = strsep(&buf, ",");
-		ftrace_set_regex(hash, func, strlen(func), 0);
+		ftrace_set_regex(ops, func, strlen(func), 0, enable);
 	}
 }
 
 static void __init set_ftrace_early_filters(void)
 {
 	if (ftrace_filter_buf[0])
-		set_ftrace_early_filter(&filter_hash, ftrace_filter_buf);
+		set_ftrace_early_filter(&global_ops, ftrace_filter_buf, 1);
 	if (ftrace_notrace_buf[0])
-		set_ftrace_early_filter(&notrace_hash, ftrace_notrace_buf);
+		set_ftrace_early_filter(&global_ops, ftrace_notrace_buf, 0);
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	if (ftrace_graph_buf[0])
 		set_ftrace_early_graph(ftrace_graph_buf);
-- 
1.7.4.4


