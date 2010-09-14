Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab0INU3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 16:29:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46449 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab0INU3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 16:29:10 -0400
X-Authority-Analysis: v=1.1 cv=8l6A00wGdfxWf8DimOOtudg6dZOi9rXZmlWhmOLJpog= c=1 sm=0 a=GJHq10ptLZwA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=xn_2uDM6AAAA:8 a=meVymXHHAAAA:8 a=TzR3T3odkhCL-pDeDdoA:9 a=fgLjTrBXmUAcrWVg9KIA:7 a=eoX4yFmLR0xZMHXTvNATthpeNe0A:4 a=jEp0ucaQiEUA:10 a=AlnqcuNMsHEA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20100914202842.597441667@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 14 Sep 2010 16:27:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH 2/4] tracing: Replace typecasted void pointer in set_ftrace_filter code
References: <20100914202714.376849326@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Replace-typecasted-void-pointer-in-set_ftrac.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The set_ftrace_filter uses seq_file and reads from two lists. The
pointer returned by t_next() can either be of type struct dyn_ftrace
or struct ftrace_func_probe. If there is a bug (there was one)
the wrong pointer may be used and the reference can cause an oops.

This patch makes t_next() and friends only return the iterator structure
which now has a pointer of type struct dyn_ftrace and struct
ftrace_func_probe. The t_show() can now test if the pointer is NULL or
not and if the pointer exists, it is guaranteed to be of the correct type.

Now if there's a bug, only wrong data will be shown but not an oops.

Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   67 +++++++++++++++++++++++++++++++++---------------
 1 files changed, 46 insertions(+), 21 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 585ea27..c8db0db 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1368,25 +1368,29 @@ enum {
 #define FTRACE_BUFF_MAX (KSYM_SYMBOL_LEN+4) /* room for wildcards */
 
 struct ftrace_iterator {
-	loff_t			func_pos;
-	struct ftrace_page	*pg;
-	int			hidx;
-	int			idx;
-	unsigned		flags;
-	struct trace_parser	parser;
+	loff_t				func_pos;
+	struct ftrace_page		*pg;
+	struct dyn_ftrace		*func;
+	struct ftrace_func_probe	*probe;
+	struct trace_parser		parser;
+	int				hidx;
+	int				idx;
+	unsigned			flags;
 };
 
 static void *
-t_hash_next(struct seq_file *m, void *v, loff_t *pos)
+t_hash_next(struct seq_file *m, loff_t *pos)
 {
 	struct ftrace_iterator *iter = m->private;
-	struct hlist_node *hnd = v;
+	struct hlist_node *hnd = NULL;
 	struct hlist_head *hhd;
 
 	WARN_ON(!(iter->flags & FTRACE_ITER_HASH));
 
 	(*pos)++;
 
+	if (iter->probe)
+		hnd = &iter->probe->node;
  retry:
 	if (iter->hidx >= FTRACE_FUNC_HASHSIZE)
 		return NULL;
@@ -1409,7 +1413,12 @@ t_hash_next(struct seq_file *m, void *v, loff_t *pos)
 		}
 	}
 
-	return hnd;
+	if (WARN_ON_ONCE(!hnd))
+		return NULL;
+
+	iter->probe = hlist_entry(hnd, struct ftrace_func_probe, node);
+
+	return iter;
 }
 
 static void *t_hash_start(struct seq_file *m, loff_t *pos)
@@ -1428,19 +1437,24 @@ static void *t_hash_start(struct seq_file *m, loff_t *pos)
 
 	iter->hidx = 0;
 	for (l = 0; l <= (*pos - iter->func_pos); ) {
-		p = t_hash_next(m, p, &l);
+		p = t_hash_next(m, &l);
 		if (!p)
 			break;
 	}
-	return p;
+	if (!p)
+		return NULL;
+
+	return iter;
 }
 
-static int t_hash_show(struct seq_file *m, void *v)
+static int
+t_hash_show(struct seq_file *m, struct ftrace_iterator *iter)
 {
 	struct ftrace_func_probe *rec;
-	struct hlist_node *hnd = v;
 
-	rec = hlist_entry(hnd, struct ftrace_func_probe, node);
+	rec = iter->probe;
+	if (WARN_ON_ONCE(!rec))
+		return -EIO;
 
 	if (rec->ops->print)
 		return rec->ops->print(m, rec->ip, rec->ops, rec->data);
@@ -1461,7 +1475,7 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 	struct dyn_ftrace *rec = NULL;
 
 	if (iter->flags & FTRACE_ITER_HASH)
-		return t_hash_next(m, v, pos);
+		return t_hash_next(m, pos);
 
 	(*pos)++;
 
@@ -1495,7 +1509,12 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 		}
 	}
 
-	return rec;
+	if (!rec)
+		return NULL;
+
+	iter->func = rec;
+
+	return iter;
 }
 
 static void *t_start(struct seq_file *m, loff_t *pos)
@@ -1530,10 +1549,14 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 			break;
 	}
 
-	if (!p && iter->flags & FTRACE_ITER_FILTER)
-		return t_hash_start(m, pos);
+	if (!p) {
+		if (iter->flags & FTRACE_ITER_FILTER)
+			return t_hash_start(m, pos);
 
-	return p;
+		return NULL;
+	}
+
+	return iter;
 }
 
 static void t_stop(struct seq_file *m, void *p)
@@ -1544,16 +1567,18 @@ static void t_stop(struct seq_file *m, void *p)
 static int t_show(struct seq_file *m, void *v)
 {
 	struct ftrace_iterator *iter = m->private;
-	struct dyn_ftrace *rec = v;
+	struct dyn_ftrace *rec;
 
 	if (iter->flags & FTRACE_ITER_HASH)
-		return t_hash_show(m, v);
+		return t_hash_show(m, iter);
 
 	if (iter->flags & FTRACE_ITER_PRINTALL) {
 		seq_printf(m, "#### all functions enabled ####\n");
 		return 0;
 	}
 
+	rec = iter->func;
+
 	if (!rec)
 		return 0;
 
-- 
1.7.1


