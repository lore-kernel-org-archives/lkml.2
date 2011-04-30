Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab1D3Pco (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 11:32:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34847 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757144Ab1D3PcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 11:32:13 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=vhdKIqpQuCYA:10 a=lMgXKpN8AgQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=hvrvjFMkwuz2Ne_LdEcA:9 a=hxoBX4rXuaVkVJYk_OgA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110430153211.111642620@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 30 Apr 2011 11:30:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/8] ftrace: Remove FTRACE_FL_FAILED flag
References: <20110430153040.354378898@goodmis.org>
Content-Disposition: inline; filename=0004-ftrace-Remove-FTRACE_FL_FAILED-flag.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Since we disable all function tracer processing if we detect
that a modification of a instruction had failed, we do not need
to track that the record has failed. No more ftrace processing
is allowed, and the FTRACE_FL_FAILED flag is pointless.

Removing this flag simplifies some of the code, but some ftrace_disabled
checks needed to be added or move around a little.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    9 ++---
 kernel/trace/ftrace.c  |   76 +++++++++++++++++++++++++++++------------------
 2 files changed, 51 insertions(+), 34 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index ca29e03..2a195ff 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -147,11 +147,10 @@ extern int ftrace_text_reserved(void *start, void *end);
 
 enum {
 	FTRACE_FL_FREE		= (1 << 0),
-	FTRACE_FL_FAILED	= (1 << 1),
-	FTRACE_FL_FILTER	= (1 << 2),
-	FTRACE_FL_ENABLED	= (1 << 3),
-	FTRACE_FL_NOTRACE	= (1 << 4),
-	FTRACE_FL_CONVERTED	= (1 << 5),
+	FTRACE_FL_FILTER	= (1 << 1),
+	FTRACE_FL_ENABLED	= (1 << 2),
+	FTRACE_FL_NOTRACE	= (1 << 3),
+	FTRACE_FL_CONVERTED	= (1 << 4),
 };
 
 struct dyn_ftrace {
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 97b30f8..eb19fae 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1083,19 +1083,20 @@ static void ftrace_replace_code(int enable)
 	struct ftrace_page *pg;
 	int failed;
 
+	if (unlikely(ftrace_disabled))
+		return;
+
 	do_for_each_ftrace_rec(pg, rec) {
 		/*
 		 * Skip over free records, records that have
 		 * failed and not converted.
 		 */
 		if (rec->flags & FTRACE_FL_FREE ||
-		    rec->flags & FTRACE_FL_FAILED ||
 		    !(rec->flags & FTRACE_FL_CONVERTED))
 			continue;
 
 		failed = __ftrace_replace_code(rec, enable);
 		if (failed) {
-			rec->flags |= FTRACE_FL_FAILED;
 			ftrace_bug(failed, rec->ip);
 			/* Stop processing */
 			return;
@@ -1111,10 +1112,12 @@ ftrace_code_disable(struct module *mod, struct dyn_ftrace *rec)
 
 	ip = rec->ip;
 
+	if (unlikely(ftrace_disabled))
+		return 0;
+
 	ret = ftrace_make_nop(mod, rec, MCOUNT_ADDR);
 	if (ret) {
 		ftrace_bug(ret, ip);
-		rec->flags |= FTRACE_FL_FAILED;
 		return 0;
 	}
 	return 1;
@@ -1466,6 +1469,9 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 	struct ftrace_iterator *iter = m->private;
 	struct dyn_ftrace *rec = NULL;
 
+	if (unlikely(ftrace_disabled))
+		return NULL;
+
 	if (iter->flags & FTRACE_ITER_HASH)
 		return t_hash_next(m, pos);
 
@@ -1518,6 +1524,10 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 	loff_t l;
 
 	mutex_lock(&ftrace_lock);
+
+	if (unlikely(ftrace_disabled))
+		return NULL;
+
 	/*
 	 * If an lseek was done, then reset and start from beginning.
 	 */
@@ -1636,8 +1646,6 @@ static void ftrace_filter_reset(int enable)
 	if (enable)
 		ftrace_filtered = 0;
 	do_for_each_ftrace_rec(pg, rec) {
-		if (rec->flags & FTRACE_FL_FAILED)
-			continue;
 		rec->flags &= ~type;
 	} while_for_each_ftrace_rec();
 	mutex_unlock(&ftrace_lock);
@@ -1767,9 +1775,6 @@ static int ftrace_match_records(char *buff, int len, int enable)
 	mutex_lock(&ftrace_lock);
 	do_for_each_ftrace_rec(pg, rec) {
 
-		if (rec->flags & FTRACE_FL_FAILED)
-			continue;
-
 		if (ftrace_match_record(rec, search, search_len, type)) {
 			if (not)
 				rec->flags &= ~flag;
@@ -1837,10 +1842,11 @@ static int ftrace_match_module_records(char *buff, char *mod, int enable)
 	}
 
 	mutex_lock(&ftrace_lock);
-	do_for_each_ftrace_rec(pg, rec) {
 
-		if (rec->flags & FTRACE_FL_FAILED)
-			continue;
+	if (unlikely(ftrace_disabled))
+		goto out_unlock;
+
+	do_for_each_ftrace_rec(pg, rec) {
 
 		if (ftrace_match_module_record(rec, mod,
 					       search, search_len, type)) {
@@ -1854,6 +1860,7 @@ static int ftrace_match_module_records(char *buff, char *mod, int enable)
 			ftrace_filtered = 1;
 
 	} while_for_each_ftrace_rec();
+ out_unlock:
 	mutex_unlock(&ftrace_lock);
 
 	return found;
@@ -2008,10 +2015,11 @@ register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 		return -EINVAL;
 
 	mutex_lock(&ftrace_lock);
-	do_for_each_ftrace_rec(pg, rec) {
 
-		if (rec->flags & FTRACE_FL_FAILED)
-			continue;
+	if (unlikely(ftrace_disabled))
+		goto out_unlock;
+
+	do_for_each_ftrace_rec(pg, rec) {
 
 		if (!ftrace_match_record(rec, search, len, type))
 			continue;
@@ -2218,6 +2226,10 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 
 	mutex_lock(&ftrace_regex_lock);
 
+	ret = -ENODEV;
+	if (unlikely(ftrace_disabled))
+		goto out_unlock;
+
 	if (file->f_mode & FMODE_READ) {
 		struct seq_file *m = file->private_data;
 		iter = m->private;
@@ -2545,9 +2557,6 @@ ftrace_set_func(unsigned long *array, int *idx, char *buffer)
 	bool exists;
 	int i;
 
-	if (ftrace_disabled)
-		return -ENODEV;
-
 	/* decode regex */
 	type = filter_parse_regex(buffer, strlen(buffer), &search, &not);
 	if (!not && *idx >= FTRACE_GRAPH_MAX_FUNCS)
@@ -2556,9 +2565,15 @@ ftrace_set_func(unsigned long *array, int *idx, char *buffer)
 	search_len = strlen(search);
 
 	mutex_lock(&ftrace_lock);
+
+	if (unlikely(ftrace_disabled)) {
+		mutex_unlock(&ftrace_lock);
+		return -ENODEV;
+	}
+
 	do_for_each_ftrace_rec(pg, rec) {
 
-		if (rec->flags & (FTRACE_FL_FAILED | FTRACE_FL_FREE))
+		if (rec->flags & FTRACE_FL_FREE)
 			continue;
 
 		if (ftrace_match_record(rec, search, search_len, type)) {
@@ -2700,10 +2715,11 @@ void ftrace_release_mod(struct module *mod)
 	struct dyn_ftrace *rec;
 	struct ftrace_page *pg;
 
+	mutex_lock(&ftrace_lock);
+
 	if (ftrace_disabled)
-		return;
+		goto out_unlock;
 
-	mutex_lock(&ftrace_lock);
 	do_for_each_ftrace_rec(pg, rec) {
 		if (within_module_core(rec->ip, mod)) {
 			/*
@@ -2714,6 +2730,7 @@ void ftrace_release_mod(struct module *mod)
 			ftrace_free_rec(rec);
 		}
 	} while_for_each_ftrace_rec();
+ out_unlock:
 	mutex_unlock(&ftrace_lock);
 }
 
@@ -3108,16 +3125,17 @@ void ftrace_kill(void)
  */
 int register_ftrace_function(struct ftrace_ops *ops)
 {
-	int ret;
-
-	if (unlikely(ftrace_disabled))
-		return -1;
+	int ret = -1;
 
 	mutex_lock(&ftrace_lock);
 
+	if (unlikely(ftrace_disabled))
+		goto out_unlock;
+
 	ret = __register_ftrace_function(ops);
 	ftrace_startup(0);
 
+ out_unlock:
 	mutex_unlock(&ftrace_lock);
 	return ret;
 }
@@ -3145,14 +3163,14 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 		     void __user *buffer, size_t *lenp,
 		     loff_t *ppos)
 {
-	int ret;
-
-	if (unlikely(ftrace_disabled))
-		return -ENODEV;
+	int ret = -ENODEV;
 
 	mutex_lock(&ftrace_lock);
 
-	ret  = proc_dointvec(table, write, buffer, lenp, ppos);
+	if (unlikely(ftrace_disabled))
+		goto out;
+
+	ret = proc_dointvec(table, write, buffer, lenp, ppos);
 
 	if (ret || !write || (last_ftrace_enabled == !!ftrace_enabled))
 		goto out;
-- 
1.7.2.3


