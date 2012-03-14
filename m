Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760009Ab2CNXCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 19:02:36 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:62306 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758532Ab2CNXCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 19:02:33 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com, rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 03/11] dynamic_debug: replace if (verbose) pr_info with macro vpr_info
Date: Wed, 14 Mar 2012 17:01:58 -0600
Message-Id: <1331766126-11674-4-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.8.1
In-Reply-To: <1331766126-11674-1-git-send-email-jim.cromie@gmail.com>
References: <1331766126-11674-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

use new macro to declutter code, reduce indenting.
dont use pr_debug in lib/dynamic_debug.c, replace with vpr_info.
Disregard checkpatch warning about complex macro arg; there are
plenty of examples in include/*

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   79 ++++++++++++++++++++++-----------------------------
 1 files changed, 34 insertions(+), 45 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 310c753..563e5fc 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -107,20 +107,22 @@ static char *ddebug_describe_flags(struct _ddebug *dp, char *buf,
 	return buf;
 }
 
-#define vpr_info_dq(q, msg)						\
-do {									\
-	if (verbose)							\
-		/* trim last char off format print */			\
-		pr_info("%s: func=\"%s\" file=\"%s\" "			\
-			"module=\"%s\" format=\"%.*s\" "		\
-			"lineno=%u-%u",					\
-			msg,						\
-			q->function ? q->function : "",			\
-			q->filename ? q->filename : "",			\
-			q->module ? q->module : "",			\
-			(int)(q->format ? strlen(q->format) - 1 : 0),	\
-			q->format ? q->format : "",			\
-			q->first_lineno, q->last_lineno);		\
+#define vpr_info(fmt, ...) \
+	if (verbose) do { pr_info(fmt, ##__VA_ARGS__); } while (0)
+
+#define vpr_info_dq(q, msg)					\
+do {								\
+	/* trim last char off format print */			\
+	vpr_info("%s: func=\"%s\" file=\"%s\" "			\
+		"module=\"%s\" format=\"%.*s\" "		\
+		"lineno=%u-%u",					\
+		msg,						\
+		q->function ? q->function : "",			\
+		q->filename ? q->filename : "",			\
+		q->module ? q->module : "",			\
+		(int)(q->format ? strlen(q->format) - 1 : 0),	\
+		q->format ? q->format : "",			\
+		q->first_lineno, q->last_lineno);		\
 } while (0)
 
 /*
@@ -180,12 +182,11 @@ static int ddebug_change(const struct ddebug_query *query,
 			if (newflags == dp->flags)
 				continue;
 			dp->flags = newflags;
-			if (verbose)
-				pr_info("changed %s:%d [%s]%s =%s\n",
-					trim_prefix(dp->filename), dp->lineno,
-					dt->mod_name, dp->function,
-					ddebug_describe_flags(dp, flagbuf,
-							sizeof(flagbuf)));
+			vpr_info("changed %s:%d [%s]%s =%s\n",
+				trim_prefix(dp->filename), dp->lineno,
+				dt->mod_name, dp->function,
+				ddebug_describe_flags(dp, flagbuf,
+						sizeof(flagbuf)));
 		}
 	}
 	mutex_unlock(&ddebug_lock);
@@ -410,8 +411,7 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 	default:
 		return -EINVAL;
 	}
-	if (verbose)
-		pr_info("op='%c'\n", op);
+	vpr_info("op='%c'\n", op);
 
 	for ( ; *str ; ++str) {
 		for (i = ARRAY_SIZE(opt_array) - 1; i >= 0; i--) {
@@ -423,8 +423,7 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 		if (i < 0)
 			return -EINVAL;
 	}
-	if (verbose)
-		pr_info("flags=0x%x\n", flags);
+	vpr_info("flags=0x%x\n", flags);
 
 	/* calculate final *flagsp, *maskp according to mask and op */
 	switch (op) {
@@ -441,8 +440,7 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 		*flagsp = 0;
 		break;
 	}
-	if (verbose)
-		pr_info("*flagsp=0x%x *maskp=0x%x\n", *flagsp, *maskp);
+	vpr_info("*flagsp=0x%x *maskp=0x%x\n", *flagsp, *maskp);
 	return 0;
 }
 
@@ -487,8 +485,7 @@ static int ddebug_exec_queries(char *query)
 		if (!query || !*query || *query == '#')
 			continue;
 
-		if (verbose)
-			pr_info("query %d: \"%s\"\n", i, query);
+		vpr_info("query %d: \"%s\"\n", i, query);
 
 		rc = ddebug_exec_query(query);
 		if (rc < 0) {
@@ -653,8 +650,7 @@ static ssize_t ddebug_proc_write(struct file *file, const char __user *ubuf,
 		return -EFAULT;
 	}
 	tmpbuf[len] = '\0';
-	if (verbose)
-		pr_info("read %d bytes from userspace\n", (int)len);
+	vpr_info("read %d bytes from userspace\n", (int)len);
 
 	ret = ddebug_exec_queries(tmpbuf);
 	kfree(tmpbuf);
@@ -717,8 +713,7 @@ static void *ddebug_proc_start(struct seq_file *m, loff_t *pos)
 	struct _ddebug *dp;
 	int n = *pos;
 
-	if (verbose)
-		pr_info("called m=%p *pos=%lld\n", m, (unsigned long long)*pos);
+	vpr_info("called m=%p *pos=%lld\n", m, (unsigned long long)*pos);
 
 	mutex_lock(&ddebug_lock);
 
@@ -742,9 +737,8 @@ static void *ddebug_proc_next(struct seq_file *m, void *p, loff_t *pos)
 	struct ddebug_iter *iter = m->private;
 	struct _ddebug *dp;
 
-	if (verbose)
-		pr_info("called m=%p p=%p *pos=%lld\n",
-			m, p, (unsigned long long)*pos);
+	vpr_info("called m=%p p=%p *pos=%lld\n",
+		m, p, (unsigned long long)*pos);
 
 	if (p == SEQ_START_TOKEN)
 		dp = ddebug_iter_first(iter);
@@ -766,8 +760,7 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
 	struct _ddebug *dp = p;
 	char flagsbuf[10];
 
-	if (verbose)
-		pr_info("called m=%p p=%p\n", m, p);
+	vpr_info("called m=%p p=%p\n", m, p);
 
 	if (p == SEQ_START_TOKEN) {
 		seq_puts(m,
@@ -791,8 +784,7 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
  */
 static void ddebug_proc_stop(struct seq_file *m, void *p)
 {
-	if (verbose)
-		pr_info("called m=%p p=%p\n", m, p);
+	vpr_info("called m=%p p=%p\n", m, p);
 	mutex_unlock(&ddebug_lock);
 }
 
@@ -815,8 +807,7 @@ static int ddebug_proc_open(struct inode *inode, struct file *file)
 	struct ddebug_iter *iter;
 	int err;
 
-	if (verbose)
-		pr_info("called\n");
+	vpr_info("called\n");
 
 	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
 	if (iter == NULL)
@@ -866,8 +857,7 @@ int ddebug_add_module(struct _ddebug *tab, unsigned int n,
 	list_add_tail(&dt->link, &ddebug_tables);
 	mutex_unlock(&ddebug_lock);
 
-	if (verbose)
-		pr_info("%u debug prints in module %s\n", n, dt->mod_name);
+	vpr_info("%u debug prints in module %s\n", n, dt->mod_name);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ddebug_add_module);
@@ -888,8 +878,7 @@ int ddebug_remove_module(const char *mod_name)
 	struct ddebug_table *dt, *nextdt;
 	int ret = -ENOENT;
 
-	if (verbose)
-		pr_info("removing module \"%s\"\n", mod_name);
+	vpr_info("removing module \"%s\"\n", mod_name);
 
 	mutex_lock(&ddebug_lock);
 	list_for_each_entry_safe(dt, nextdt, &ddebug_tables, link) {
-- 
1.7.7.6

