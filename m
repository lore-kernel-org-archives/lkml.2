Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab1ESCNB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 22:13:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64627 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866Ab1ESCM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 22:12:56 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=vhdKIqpQuCYA:10 a=tz_ytaAa3nAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=eSHpfkU-kuFJs0XTKBMA:9 a=39y_UpPBOILKEdU72VQA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110519021255.024424117@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 22:11:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 02/13] ftrace: Use hash instead for FTRACE_FL_FILTER
References: <20110519021151.600991800@goodmis.org>
Content-Disposition: inline; filename=0002-ftrace-Use-hash-instead-for-FTRACE_FL_FILTER.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When multiple users are allowed to have their own set of functions
to trace, having the FTRACE_FL_FILTER flag will not be enough to
handle the accounting of those users. Each user will need their own
set of functions.

Replace the FTRACE_FL_FILTER with a filter_hash instead. This is
temporary until the rest of the function filtering accounting
gets in.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    3 +-
 kernel/trace/ftrace.c  |  151 ++++++++++++++++++++++--------------------------
 2 files changed, 70 insertions(+), 84 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index fe0a90a..52fc5d4 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -147,8 +147,7 @@ extern int ftrace_text_reserved(void *start, void *end);
 
 enum {
 	FTRACE_FL_FREE		= (1 << 0),
-	FTRACE_FL_FILTER	= (1 << 1),
-	FTRACE_FL_ENABLED	= (1 << 2),
+	FTRACE_FL_ENABLED	= (1 << 1),
 };
 
 struct dyn_ftrace {
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 04c002a..222eca4 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -883,7 +883,11 @@ static struct ftrace_hash notrace_hash = {
 	.buckets = notrace_buckets,
 };
 
-static int ftrace_filtered;
+static struct hlist_head filter_buckets[1 << FTRACE_HASH_MAX_BITS];
+static struct ftrace_hash filter_hash = {
+	.size_bits = FTRACE_HASH_MAX_BITS,
+	.buckets = filter_buckets,
+};
 
 static struct dyn_ftrace *ftrace_new_addrs;
 
@@ -1123,7 +1127,7 @@ __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 	 * it's filtered
 	 */
 	if (enable && !ftrace_lookup_ip(&notrace_hash, rec->ip)) {
-		if (!ftrace_filtered || (rec->flags & FTRACE_FL_FILTER))
+		if (!filter_hash.count || ftrace_lookup_ip(&filter_hash, rec->ip))
 			flag = FTRACE_FL_ENABLED;
 	}
 
@@ -1430,6 +1434,7 @@ struct ftrace_iterator {
 	struct dyn_ftrace		*func;
 	struct ftrace_func_probe	*probe;
 	struct trace_parser		parser;
+	struct ftrace_hash		*hash;
 	int				hidx;
 	int				idx;
 	unsigned			flags;
@@ -1552,7 +1557,7 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 		if ((rec->flags & FTRACE_FL_FREE) ||
 
 		    ((iter->flags & FTRACE_ITER_FILTER) &&
-		     !(rec->flags & FTRACE_FL_FILTER)) ||
+		     !(ftrace_lookup_ip(&filter_hash, rec->ip))) ||
 
 		    ((iter->flags & FTRACE_ITER_NOTRACE) &&
 		     !ftrace_lookup_ip(&notrace_hash, rec->ip))) {
@@ -1598,7 +1603,7 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 	 * off, we can short cut and just print out that all
 	 * functions are enabled.
 	 */
-	if (iter->flags & FTRACE_ITER_FILTER && !ftrace_filtered) {
+	if (iter->flags & FTRACE_ITER_FILTER && !filter_hash.count) {
 		if (*pos > 0)
 			return t_hash_start(m, pos);
 		iter->flags |= FTRACE_ITER_PRINTALL;
@@ -1695,24 +1700,16 @@ ftrace_avail_open(struct inode *inode, struct file *file)
 	return ret;
 }
 
-static void ftrace_filter_reset(int enable)
+static void ftrace_filter_reset(struct ftrace_hash *hash)
 {
-	struct ftrace_page *pg;
-	struct dyn_ftrace *rec;
-
 	mutex_lock(&ftrace_lock);
-	if (enable) {
-		ftrace_filtered = 0;
-		do_for_each_ftrace_rec(pg, rec) {
-			rec->flags &= ~FTRACE_FL_FILTER;
-		} while_for_each_ftrace_rec();
-	} else
-		ftrace_hash_clear(&notrace_hash);
+	ftrace_hash_clear(hash);
 	mutex_unlock(&ftrace_lock);
 }
 
 static int
-ftrace_regex_open(struct inode *inode, struct file *file, int enable)
+ftrace_regex_open(struct ftrace_hash *hash, int flag,
+		  struct inode *inode, struct file *file)
 {
 	struct ftrace_iterator *iter;
 	int ret = 0;
@@ -1729,15 +1726,16 @@ ftrace_regex_open(struct inode *inode, struct file *file, int enable)
 		return -ENOMEM;
 	}
 
+	iter->hash = hash;
+
 	mutex_lock(&ftrace_regex_lock);
 	if ((file->f_mode & FMODE_WRITE) &&
 	    (file->f_flags & O_TRUNC))
-		ftrace_filter_reset(enable);
+		ftrace_filter_reset(hash);
 
 	if (file->f_mode & FMODE_READ) {
 		iter->pg = ftrace_pages_start;
-		iter->flags = enable ? FTRACE_ITER_FILTER :
-			FTRACE_ITER_NOTRACE;
+		iter->flags = flag;
 
 		ret = seq_open(file, &show_ftrace_seq_ops);
 		if (!ret) {
@@ -1757,13 +1755,15 @@ ftrace_regex_open(struct inode *inode, struct file *file, int enable)
 static int
 ftrace_filter_open(struct inode *inode, struct file *file)
 {
-	return ftrace_regex_open(inode, file, 1);
+	return ftrace_regex_open(&filter_hash, FTRACE_ITER_FILTER,
+				 inode, file);
 }
 
 static int
 ftrace_notrace_open(struct inode *inode, struct file *file)
 {
-	return ftrace_regex_open(inode, file, 0);
+	return ftrace_regex_open(&notrace_hash, FTRACE_ITER_NOTRACE,
+				 inode, file);
 }
 
 static loff_t
@@ -1808,33 +1808,24 @@ static int ftrace_match(char *str, char *regex, int len, int type)
 }
 
 static int
-update_record(struct dyn_ftrace *rec, int enable, int not)
+enter_record(struct ftrace_hash *hash, struct dyn_ftrace *rec, int not)
 {
 	struct ftrace_func_entry *entry;
-	struct ftrace_hash *hash = &notrace_hash;
 	int ret = 0;
 
-	if (enable) {
-		if (not)
-			rec->flags &= ~FTRACE_FL_FILTER;
-		else
-			rec->flags |= FTRACE_FL_FILTER;
-	} else {
-		if (not) {
-			/* Do nothing if it doesn't exist */
-			entry = ftrace_lookup_ip(hash, rec->ip);
-			if (!entry)
-				return 0;
+	entry = ftrace_lookup_ip(hash, rec->ip);
+	if (not) {
+		/* Do nothing if it doesn't exist */
+		if (!entry)
+			return 0;
 
-			remove_hash_entry(hash, entry);
-		} else {
-			/* Do nothing if it exists */
-			entry = ftrace_lookup_ip(hash, rec->ip);
-			if (entry)
-				return 0;
+		remove_hash_entry(hash, entry);
+	} else {
+		/* Do nothing if it exists */
+		if (entry)
+			return 0;
 
-			ret = add_hash_entry(hash, rec->ip);
-		}
+		ret = add_hash_entry(hash, rec->ip);
 	}
 	return ret;
 }
@@ -1861,7 +1852,9 @@ ftrace_match_record(struct dyn_ftrace *rec, char *mod,
 	return ftrace_match(str, regex, len, type);
 }
 
-static int match_records(char *buff, int len, char *mod, int enable, int not)
+static int
+match_records(struct ftrace_hash *hash, char *buff,
+	      int len, char *mod, int not)
 {
 	unsigned search_len = 0;
 	struct ftrace_page *pg;
@@ -1884,20 +1877,13 @@ static int match_records(char *buff, int len, char *mod, int enable, int not)
 	do_for_each_ftrace_rec(pg, rec) {
 
 		if (ftrace_match_record(rec, mod, search, search_len, type)) {
-			ret = update_record(rec, enable, not);
+			ret = enter_record(hash, rec, not);
 			if (ret < 0) {
 				found = ret;
 				goto out_unlock;
 			}
 			found = 1;
 		}
-		/*
-		 * Only enable filtering if we have a function that
-		 * is filtered on.
-		 */
-		if (enable && (rec->flags & FTRACE_FL_FILTER))
-			ftrace_filtered = 1;
-
 	} while_for_each_ftrace_rec();
  out_unlock:
 	mutex_unlock(&ftrace_lock);
@@ -1906,12 +1892,13 @@ static int match_records(char *buff, int len, char *mod, int enable, int not)
 }
 
 static int
-ftrace_match_records(char *buff, int len, int enable)
+ftrace_match_records(struct ftrace_hash *hash, char *buff, int len)
 {
-	return match_records(buff, len, NULL, enable, 0);
+	return match_records(hash, buff, len, NULL, 0);
 }
 
-static int ftrace_match_module_records(char *buff, char *mod, int enable)
+static int
+ftrace_match_module_records(struct ftrace_hash *hash, char *buff, char *mod)
 {
 	int not = 0;
 
@@ -1925,7 +1912,7 @@ static int ftrace_match_module_records(char *buff, char *mod, int enable)
 		not = 1;
 	}
 
-	return match_records(buff, strlen(buff), mod, enable, not);
+	return match_records(hash, buff, strlen(buff), mod, not);
 }
 
 /*
@@ -1936,6 +1923,7 @@ static int ftrace_match_module_records(char *buff, char *mod, int enable)
 static int
 ftrace_mod_callback(char *func, char *cmd, char *param, int enable)
 {
+	struct ftrace_hash *hash;
 	char *mod;
 	int ret = -EINVAL;
 
@@ -1955,7 +1943,12 @@ ftrace_mod_callback(char *func, char *cmd, char *param, int enable)
 	if (!strlen(mod))
 		return ret;
 
-	ret = ftrace_match_module_records(func, mod, enable);
+	if (enable)
+		hash = &filter_hash;
+	else
+		hash = &notrace_hash;
+
+	ret = ftrace_match_module_records(hash, func, mod);
 	if (!ret)
 		ret = -EINVAL;
 	if (ret < 0)
@@ -2253,12 +2246,18 @@ static int ftrace_process_regex(char *buff, int len, int enable)
 {
 	char *func, *command, *next = buff;
 	struct ftrace_func_command *p;
+	struct ftrace_hash *hash;
 	int ret;
 
+	if (enable)
+		hash = &filter_hash;
+	else
+		hash = &notrace_hash;
+
 	func = strsep(&next, ":");
 
 	if (!next) {
-		ret = ftrace_match_records(func, len, enable);
+		ret = ftrace_match_records(hash, func, len);
 		if (!ret)
 			ret = -EINVAL;
 		if (ret < 0)
@@ -2340,16 +2339,16 @@ ftrace_notrace_write(struct file *file, const char __user *ubuf,
 }
 
 static void
-ftrace_set_regex(unsigned char *buf, int len, int reset, int enable)
+ftrace_set_regex(struct ftrace_hash *hash, unsigned char *buf, int len, int reset)
 {
 	if (unlikely(ftrace_disabled))
 		return;
 
 	mutex_lock(&ftrace_regex_lock);
 	if (reset)
-		ftrace_filter_reset(enable);
+		ftrace_filter_reset(hash);
 	if (buf)
-		ftrace_match_records(buf, len, enable);
+		ftrace_match_records(hash, buf, len);
 	mutex_unlock(&ftrace_regex_lock);
 }
 
@@ -2364,7 +2363,7 @@ ftrace_set_regex(unsigned char *buf, int len, int reset, int enable)
  */
 void ftrace_set_filter(unsigned char *buf, int len, int reset)
 {
-	ftrace_set_regex(buf, len, reset, 1);
+	ftrace_set_regex(&filter_hash, buf, len, reset);
 }
 
 /**
@@ -2379,7 +2378,7 @@ void ftrace_set_filter(unsigned char *buf, int len, int reset)
  */
 void ftrace_set_notrace(unsigned char *buf, int len, int reset)
 {
-	ftrace_set_regex(buf, len, reset, 0);
+	ftrace_set_regex(&notrace_hash, buf, len, reset);
 }
 
 /*
@@ -2431,22 +2430,22 @@ static void __init set_ftrace_early_graph(char *buf)
 }
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
-static void __init set_ftrace_early_filter(char *buf, int enable)
+static void __init set_ftrace_early_filter(struct ftrace_hash *hash, char *buf)
 {
 	char *func;
 
 	while (buf) {
 		func = strsep(&buf, ",");
-		ftrace_set_regex(func, strlen(func), 0, enable);
+		ftrace_set_regex(hash, func, strlen(func), 0);
 	}
 }
 
 static void __init set_ftrace_early_filters(void)
 {
 	if (ftrace_filter_buf[0])
-		set_ftrace_early_filter(ftrace_filter_buf, 1);
+		set_ftrace_early_filter(&filter_hash, ftrace_filter_buf);
 	if (ftrace_notrace_buf[0])
-		set_ftrace_early_filter(ftrace_notrace_buf, 0);
+		set_ftrace_early_filter(&notrace_hash, ftrace_notrace_buf);
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	if (ftrace_graph_buf[0])
 		set_ftrace_early_graph(ftrace_graph_buf);
@@ -2454,7 +2453,7 @@ static void __init set_ftrace_early_filters(void)
 }
 
 static int
-ftrace_regex_release(struct inode *inode, struct file *file, int enable)
+ftrace_regex_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *m = (struct seq_file *)file->private_data;
 	struct ftrace_iterator *iter;
@@ -2471,7 +2470,7 @@ ftrace_regex_release(struct inode *inode, struct file *file, int enable)
 	parser = &iter->parser;
 	if (trace_parser_loaded(parser)) {
 		parser->buffer[parser->idx] = 0;
-		ftrace_match_records(parser->buffer, parser->idx, enable);
+		ftrace_match_records(iter->hash, parser->buffer, parser->idx);
 	}
 
 	trace_parser_put(parser);
@@ -2488,18 +2487,6 @@ ftrace_regex_release(struct inode *inode, struct file *file, int enable)
 	return 0;
 }
 
-static int
-ftrace_filter_release(struct inode *inode, struct file *file)
-{
-	return ftrace_regex_release(inode, file, 1);
-}
-
-static int
-ftrace_notrace_release(struct inode *inode, struct file *file)
-{
-	return ftrace_regex_release(inode, file, 0);
-}
-
 static const struct file_operations ftrace_avail_fops = {
 	.open = ftrace_avail_open,
 	.read = seq_read,
@@ -2512,7 +2499,7 @@ static const struct file_operations ftrace_filter_fops = {
 	.read = seq_read,
 	.write = ftrace_filter_write,
 	.llseek = ftrace_regex_lseek,
-	.release = ftrace_filter_release,
+	.release = ftrace_regex_release,
 };
 
 static const struct file_operations ftrace_notrace_fops = {
@@ -2520,7 +2507,7 @@ static const struct file_operations ftrace_notrace_fops = {
 	.read = seq_read,
 	.write = ftrace_notrace_write,
 	.llseek = ftrace_regex_lseek,
-	.release = ftrace_notrace_release,
+	.release = ftrace_regex_release,
 };
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-- 
1.7.4.4


