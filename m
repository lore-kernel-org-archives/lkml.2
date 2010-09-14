Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab0INU2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 16:28:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46028 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349Ab0INU2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 16:28:44 -0400
X-Authority-Analysis: v=1.1 cv=8l6A00wGdfxWf8DimOOtudg6dZOi9rXZmlWhmOLJpog= c=1 sm=0 a=8zscghigsQMA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=e3wGGlKu-nvtmt4V_JQA:9 a=HybK2k321xJG8tzuhk0A:7 a=mTsfN4b4h77MWf7bwp-7v3HTw6UA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20100914202842.876447635@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 14 Sep 2010 16:27:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/4] tracing: Keep track of set_ftrace_filter position and allow lseek again
References: <20100914202714.376849326@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Keep-track-of-set_ftrace_filter-position-and.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch keeps track of the index within the elements of
set_ftrace_filter and if the position goes backwards, it nicely
resets and starts from the beginning again.

This allows for lseek and pread to work properly now.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   34 ++++++++++++++++++++++++++--------
 1 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index c8db0db..2d51166 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1368,6 +1368,7 @@ enum {
 #define FTRACE_BUFF_MAX (KSYM_SYMBOL_LEN+4) /* room for wildcards */
 
 struct ftrace_iterator {
+	loff_t				pos;
 	loff_t				func_pos;
 	struct ftrace_page		*pg;
 	struct dyn_ftrace		*func;
@@ -1385,9 +1386,8 @@ t_hash_next(struct seq_file *m, loff_t *pos)
 	struct hlist_node *hnd = NULL;
 	struct hlist_head *hhd;
 
-	WARN_ON(!(iter->flags & FTRACE_ITER_HASH));
-
 	(*pos)++;
+	iter->pos = *pos;
 
 	if (iter->probe)
 		hnd = &iter->probe->node;
@@ -1427,14 +1427,9 @@ static void *t_hash_start(struct seq_file *m, loff_t *pos)
 	void *p = NULL;
 	loff_t l;
 
-	if (!(iter->flags & FTRACE_ITER_HASH))
-		iter->func_pos = *pos;
-
 	if (iter->func_pos > *pos)
 		return NULL;
 
-	iter->flags |= FTRACE_ITER_HASH;
-
 	iter->hidx = 0;
 	for (l = 0; l <= (*pos - iter->func_pos); ) {
 		p = t_hash_next(m, &l);
@@ -1444,6 +1439,9 @@ static void *t_hash_start(struct seq_file *m, loff_t *pos)
 	if (!p)
 		return NULL;
 
+	/* Only set this if we have an item */
+	iter->flags |= FTRACE_ITER_HASH;
+
 	return iter;
 }
 
@@ -1478,6 +1476,8 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 		return t_hash_next(m, pos);
 
 	(*pos)++;
+	iter->pos = *pos;
+	iter->func_pos = *pos;
 
 	if (iter->flags & FTRACE_ITER_PRINTALL)
 		return NULL;
@@ -1517,6 +1517,13 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 	return iter;
 }
 
+static void reset_iter_read(struct ftrace_iterator *iter)
+{
+	iter->pos = 0;
+	iter->func_pos = 0;
+	iter->flags &= ~(FTRACE_ITER_PRINTALL & FTRACE_ITER_HASH);
+}
+
 static void *t_start(struct seq_file *m, loff_t *pos)
 {
 	struct ftrace_iterator *iter = m->private;
@@ -1525,6 +1532,12 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 
 	mutex_lock(&ftrace_lock);
 	/*
+	 * If an lseek was done, then reset and start from beginning.
+	 */
+	if (*pos < iter->pos)
+		reset_iter_read(iter);
+
+	/*
 	 * For set_ftrace_filter reading, if we have the filter
 	 * off, we can short cut and just print out that all
 	 * functions are enabled.
@@ -1541,6 +1554,11 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 	if (iter->flags & FTRACE_ITER_HASH)
 		return t_hash_start(m, pos);
 
+	/*
+	 * Unfortunately, we need to restart at ftrace_pages_start
+	 * every time we let go of the ftrace_mutex. This is because
+	 * those pointers can change without the lock.
+	 */
 	iter->pg = ftrace_pages_start;
 	iter->idx = 0;
 	for (l = 0; l <= *pos; ) {
@@ -2447,7 +2465,7 @@ static const struct file_operations ftrace_filter_fops = {
 	.open = ftrace_filter_open,
 	.read = seq_read,
 	.write = ftrace_filter_write,
-	.llseek = no_llseek,
+	.llseek = ftrace_regex_lseek,
 	.release = ftrace_filter_release,
 };
 
-- 
1.7.1


