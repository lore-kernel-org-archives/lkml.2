Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414Ab1ESCPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 22:15:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58541 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777Ab1ESCM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 22:12:56 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=Cdlhz2q-UmMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=VQUNIRac2-N1bN5HVmkA:9 a=Jh2-D-EFQ3nIADJUGMcA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110519021254.719416123@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 22:11:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 01/13] ftrace: Replace FTRACE_FL_NOTRACE flag with a hash of ignored
References: <20110519021151.600991800@goodmis.org>
Content-Disposition: inline; filename=0001-ftrace-Replace-FTRACE_FL_NOTRACE-flag-with-a-hash-of.patch
 functions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

To prepare for the accounting system that will allow multiple users of
the function tracer, having the FTRACE_FL_NOTRACE as a flag in the
dyn_trace record does not make sense.

All ftrace_ops will soon have a hash of functions they should trace
and not trace. By making a global hash of functions not to trace makes
this easier for the transition.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    1 -
 kernel/trace/ftrace.c  |  176 +++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 150 insertions(+), 27 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 3204744..fe0a90a 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -149,7 +149,6 @@ enum {
 	FTRACE_FL_FREE		= (1 << 0),
 	FTRACE_FL_FILTER	= (1 << 1),
 	FTRACE_FL_ENABLED	= (1 << 2),
-	FTRACE_FL_NOTRACE	= (1 << 3),
 };
 
 struct dyn_ftrace {
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index d340634..04c002a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -57,6 +57,7 @@
 /* hash bits for specific function selection */
 #define FTRACE_HASH_BITS 7
 #define FTRACE_FUNC_HASHSIZE (1 << FTRACE_HASH_BITS)
+#define FTRACE_HASH_MAX_BITS 10
 
 /* ftrace_enabled is a method to turn ftrace on or off */
 int ftrace_enabled __read_mostly;
@@ -865,6 +866,22 @@ enum {
 	FTRACE_START_FUNC_RET		= (1 << 3),
 	FTRACE_STOP_FUNC_RET		= (1 << 4),
 };
+struct ftrace_func_entry {
+	struct hlist_node hlist;
+	unsigned long ip;
+};
+
+struct ftrace_hash {
+	unsigned long		size_bits;
+	struct hlist_head	*buckets;
+	unsigned long		count;
+};
+
+static struct hlist_head notrace_buckets[1 << FTRACE_HASH_MAX_BITS];
+static struct ftrace_hash notrace_hash = {
+	.size_bits = FTRACE_HASH_MAX_BITS,
+	.buckets = notrace_buckets,
+};
 
 static int ftrace_filtered;
 
@@ -889,6 +906,79 @@ static struct ftrace_page	*ftrace_pages;
 
 static struct dyn_ftrace *ftrace_free_records;
 
+static struct ftrace_func_entry *
+ftrace_lookup_ip(struct ftrace_hash *hash, unsigned long ip)
+{
+	unsigned long key;
+	struct ftrace_func_entry *entry;
+	struct hlist_head *hhd;
+	struct hlist_node *n;
+
+	if (!hash->count)
+		return NULL;
+
+	if (hash->size_bits > 0)
+		key = hash_long(ip, hash->size_bits);
+	else
+		key = 0;
+
+	hhd = &hash->buckets[key];
+
+	hlist_for_each_entry_rcu(entry, n, hhd, hlist) {
+		if (entry->ip == ip)
+			return entry;
+	}
+	return NULL;
+}
+
+static int add_hash_entry(struct ftrace_hash *hash, unsigned long ip)
+{
+	struct ftrace_func_entry *entry;
+	struct hlist_head *hhd;
+	unsigned long key;
+
+	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
+
+	if (hash->size_bits)
+		key = hash_long(ip, hash->size_bits);
+	else
+		key = 0;
+
+	entry->ip = ip;
+	hhd = &hash->buckets[key];
+	hlist_add_head(&entry->hlist, hhd);
+	hash->count++;
+
+	return 0;
+}
+
+static void
+remove_hash_entry(struct ftrace_hash *hash,
+		  struct ftrace_func_entry *entry)
+{
+	hlist_del(&entry->hlist);
+	kfree(entry);
+	hash->count--;
+}
+
+static void ftrace_hash_clear(struct ftrace_hash *hash)
+{
+	struct hlist_head *hhd;
+	struct hlist_node *tp, *tn;
+	struct ftrace_func_entry *entry;
+	int size = 1 << hash->size_bits;
+	int i;
+
+	for (i = 0; i < size; i++) {
+		hhd = &hash->buckets[i];
+		hlist_for_each_entry_safe(entry, tp, tn, hhd, hlist)
+			remove_hash_entry(hash, entry);
+	}
+	FTRACE_WARN_ON(hash->count);
+}
+
 /*
  * This is a double for. Do not use 'break' to break out of the loop,
  * you must use a goto.
@@ -1032,7 +1122,7 @@ __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 	 * If we want to enable it and filtering is on, enable it only if
 	 * it's filtered
 	 */
-	if (enable && !(rec->flags & FTRACE_FL_NOTRACE)) {
+	if (enable && !ftrace_lookup_ip(&notrace_hash, rec->ip)) {
 		if (!ftrace_filtered || (rec->flags & FTRACE_FL_FILTER))
 			flag = FTRACE_FL_ENABLED;
 	}
@@ -1465,7 +1555,7 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 		     !(rec->flags & FTRACE_FL_FILTER)) ||
 
 		    ((iter->flags & FTRACE_ITER_NOTRACE) &&
-		     !(rec->flags & FTRACE_FL_NOTRACE))) {
+		     !ftrace_lookup_ip(&notrace_hash, rec->ip))) {
 			rec = NULL;
 			goto retry;
 		}
@@ -1609,14 +1699,15 @@ static void ftrace_filter_reset(int enable)
 {
 	struct ftrace_page *pg;
 	struct dyn_ftrace *rec;
-	unsigned long type = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
 
 	mutex_lock(&ftrace_lock);
-	if (enable)
+	if (enable) {
 		ftrace_filtered = 0;
-	do_for_each_ftrace_rec(pg, rec) {
-		rec->flags &= ~type;
-	} while_for_each_ftrace_rec();
+		do_for_each_ftrace_rec(pg, rec) {
+			rec->flags &= ~FTRACE_FL_FILTER;
+		} while_for_each_ftrace_rec();
+	} else
+		ftrace_hash_clear(&notrace_hash);
 	mutex_unlock(&ftrace_lock);
 }
 
@@ -1716,13 +1807,36 @@ static int ftrace_match(char *str, char *regex, int len, int type)
 	return matched;
 }
 
-static void
-update_record(struct dyn_ftrace *rec, unsigned long flag, int not)
+static int
+update_record(struct dyn_ftrace *rec, int enable, int not)
 {
-	if (not)
-		rec->flags &= ~flag;
-	else
-		rec->flags |= flag;
+	struct ftrace_func_entry *entry;
+	struct ftrace_hash *hash = &notrace_hash;
+	int ret = 0;
+
+	if (enable) {
+		if (not)
+			rec->flags &= ~FTRACE_FL_FILTER;
+		else
+			rec->flags |= FTRACE_FL_FILTER;
+	} else {
+		if (not) {
+			/* Do nothing if it doesn't exist */
+			entry = ftrace_lookup_ip(hash, rec->ip);
+			if (!entry)
+				return 0;
+
+			remove_hash_entry(hash, entry);
+		} else {
+			/* Do nothing if it exists */
+			entry = ftrace_lookup_ip(hash, rec->ip);
+			if (entry)
+				return 0;
+
+			ret = add_hash_entry(hash, rec->ip);
+		}
+	}
+	return ret;
 }
 
 static int
@@ -1754,16 +1868,14 @@ static int match_records(char *buff, int len, char *mod, int enable, int not)
 	struct dyn_ftrace *rec;
 	int type = MATCH_FULL;
 	char *search = buff;
-	unsigned long flag;
 	int found = 0;
+	int ret;
 
 	if (len) {
 		type = filter_parse_regex(buff, len, &search, &not);
 		search_len = strlen(search);
 	}
 
-	flag = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
-
 	mutex_lock(&ftrace_lock);
 
 	if (unlikely(ftrace_disabled))
@@ -1772,7 +1884,11 @@ static int match_records(char *buff, int len, char *mod, int enable, int not)
 	do_for_each_ftrace_rec(pg, rec) {
 
 		if (ftrace_match_record(rec, mod, search, search_len, type)) {
-			update_record(rec, flag, not);
+			ret = update_record(rec, enable, not);
+			if (ret < 0) {
+				found = ret;
+				goto out_unlock;
+			}
 			found = 1;
 		}
 		/*
@@ -1821,6 +1937,7 @@ static int
 ftrace_mod_callback(char *func, char *cmd, char *param, int enable)
 {
 	char *mod;
+	int ret = -EINVAL;
 
 	/*
 	 * cmd == 'mod' because we only registered this func
@@ -1832,15 +1949,19 @@ ftrace_mod_callback(char *func, char *cmd, char *param, int enable)
 
 	/* we must have a module name */
 	if (!param)
-		return -EINVAL;
+		return ret;
 
 	mod = strsep(&param, ":");
 	if (!strlen(mod))
-		return -EINVAL;
+		return ret;
 
-	if (ftrace_match_module_records(func, mod, enable))
-		return 0;
-	return -EINVAL;
+	ret = ftrace_match_module_records(func, mod, enable);
+	if (!ret)
+		ret = -EINVAL;
+	if (ret < 0)
+		return ret;
+
+	return 0;
 }
 
 static struct ftrace_func_command ftrace_mod_cmd = {
@@ -2132,14 +2253,17 @@ static int ftrace_process_regex(char *buff, int len, int enable)
 {
 	char *func, *command, *next = buff;
 	struct ftrace_func_command *p;
-	int ret = -EINVAL;
+	int ret;
 
 	func = strsep(&next, ":");
 
 	if (!next) {
-		if (ftrace_match_records(func, len, enable))
-			return 0;
-		return ret;
+		ret = ftrace_match_records(func, len, enable);
+		if (!ret)
+			ret = -EINVAL;
+		if (ret < 0)
+			return ret;
+		return 0;
 	}
 
 	/* command found */
-- 
1.7.4.4


