Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab1GYVn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:43:29 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:46811 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab1GYVnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:43:19 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: bvanassche@acm.org, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 03/25] dynamic_debug: use pr_debug instead of pr_info
Date: Mon, 25 Jul 2011 15:42:28 -0600
Message-Id: <1311630170-26057-4-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace almost all occurrences of "if (verbose) pr_info()" with
pr_debug(), and get full control of output at each callsite.
Leave a few sites unaltered:

1st also uses pr_cont(), and theres no pr_debug_cont().
2nd is in ddebug_add_module(), which is called during arch_init,
too early for callsite to be enabled when called.

3rd, pr_debug doesnt work in dynamic_debug_init(), its too early.
Also move the print ddebug_setup_string prior to parsing, since
afterwards it's been chopped up with '\0's, and only 1st word is seen.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   66 ++++++++++++++++++++-------------------------------
 1 files changed, 26 insertions(+), 40 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index af6f1ae..a7161db 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -157,18 +157,17 @@ static void ddebug_change(const struct ddebug_query *query,
 				dp->enabled = 1;
 			else
 				dp->enabled = 0;
-			if (verbose)
-				pr_info("changed %s:%d [%s]%s %s\n",
-					dp->filename, dp->lineno,
-					dt->mod_name, dp->function,
-					ddebug_describe_flags(dp, flagbuf,
-							sizeof(flagbuf)));
+			pr_debug("changed %s:%d [%s]%s %s\n",
+				dp->filename, dp->lineno,
+				dt->mod_name, dp->function,
+				ddebug_describe_flags(dp, flagbuf,
+						sizeof(flagbuf)));
 		}
 	}
 	mutex_unlock(&ddebug_lock);
 
-	if (!nfound && verbose)
-		pr_info("no matches for query\n");
+	if (!nfound)
+		pr_debug("no matches for query\n");
 }
 
 /*
@@ -333,12 +332,11 @@ static int ddebug_parse_query(char *words[], int nwords,
 		}
 	}
 
-	if (verbose)
-		pr_info("q->function=\"%s\" q->filename=\"%s\" "
-			"q->module=\"%s\" q->format=\"%s\" q->lineno=%u-%u\n",
-			query->function, query->filename,
-			query->module, query->format, query->first_lineno,
-			query->last_lineno);
+	pr_debug("q->function=\"%s\" q->filename=\"%s\" "
+		"q->module=\"%s\" q->format=\"%s\" q->lineno=%u-%u\n",
+		query->function, query->filename,
+		query->module, query->format, query->first_lineno,
+		query->last_lineno);
 
 	return 0;
 }
@@ -364,8 +362,7 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 	default:
 		return -EINVAL;
 	}
-	if (verbose)
-		pr_info("op='%c'\n", op);
+	pr_debug("op='%c'\n", op);
 
 	for ( ; *str ; ++str) {
 		for (i = ARRAY_SIZE(opt_array) - 1; i >= 0; i--) {
@@ -379,8 +376,7 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 	}
 	if (flags == 0)
 		return -EINVAL;
-	if (verbose)
-		pr_info("flags=0x%x\n", flags);
+	pr_debug("flags=0x%x\n", flags);
 
 	/* calculate final *flagsp, *maskp according to mask and op */
 	switch (op) {
@@ -397,8 +393,7 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 		*flagsp = 0;
 		break;
 	}
-	if (verbose)
-		pr_info("*flagsp=0x%x *maskp=0x%x\n", *flagsp, *maskp);
+	pr_debug("*flagsp=0x%x *maskp=0x%x\n", *flagsp, *maskp);
 	return 0;
 }
 
@@ -542,8 +537,7 @@ static ssize_t ddebug_proc_write(struct file *file, const char __user *ubuf,
 	if (copy_from_user(tmpbuf, ubuf, len))
 		return -EFAULT;
 	tmpbuf[len] = '\0';
-	if (verbose)
-		pr_info("read %d bytes from userspace\n", (int)len);
+	pr_debug("read %d bytes from userspace\n", (int)len);
 
 	ret = ddebug_exec_query(tmpbuf);
 	if (ret)
@@ -605,8 +599,7 @@ static void *ddebug_proc_start(struct seq_file *m, loff_t *pos)
 	struct _ddebug *dp;
 	int n = *pos;
 
-	if (verbose)
-		pr_info("called m=%p *pos=%lld\n", m, (unsigned long long)*pos);
+	pr_debug("called m=%p *pos=%lld\n", m, (unsigned long long)*pos);
 
 	mutex_lock(&ddebug_lock);
 
@@ -630,9 +623,8 @@ static void *ddebug_proc_next(struct seq_file *m, void *p, loff_t *pos)
 	struct ddebug_iter *iter = m->private;
 	struct _ddebug *dp;
 
-	if (verbose)
-		pr_info("called m=%p p=%p *pos=%lld\n",
-			m, p, (unsigned long long)*pos);
+	pr_debug("called m=%p p=%p *pos=%lld\n",
+		m, p, (unsigned long long)*pos);
 
 	if (p == SEQ_START_TOKEN)
 		dp = ddebug_iter_first(iter);
@@ -654,8 +646,7 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
 	struct _ddebug *dp = p;
 	char flagsbuf[8];
 
-	if (verbose)
-		pr_info("called m=%p p=%p\n", m, p);
+	pr_debug("called m=%p p=%p\n", m, p);
 
 	if (p == SEQ_START_TOKEN) {
 		seq_puts(m,
@@ -679,8 +670,7 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
  */
 static void ddebug_proc_stop(struct seq_file *m, void *p)
 {
-	if (verbose)
-		pr_info("called m=%p p=%p\n", m, p);
+	pr_debug("called m=%p p=%p\n", m, p);
 	mutex_unlock(&ddebug_lock);
 }
 
@@ -702,8 +692,7 @@ static int ddebug_proc_open(struct inode *inode, struct file *file)
 	struct ddebug_iter *iter;
 	int err;
 
-	if (verbose)
-		pr_info("called\n");
+	pr_debug("called\n");
 
 	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
 	if (iter == NULL)
@@ -775,8 +764,7 @@ int ddebug_remove_module(const char *mod_name)
 	struct ddebug_table *dt, *nextdt;
 	int ret = -ENOENT;
 
-	if (verbose)
-		pr_info("removing module \"%s\"\n", mod_name);
+	pr_debug("removing module \"%s\"\n", mod_name);
 
 	mutex_lock(&ddebug_lock);
 	list_for_each_entry_safe(dt, nextdt, &ddebug_tables, link) {
@@ -850,13 +838,11 @@ static int __init dynamic_debug_init(void)
 
 	/* ddebug_query boot param got passed -> set it up */
 	if (ddebug_setup_string[0] != '\0') {
+		pr_info("ddebug initializing with string \"%s\"",
+			ddebug_setup_string);
 		ret = ddebug_exec_query(ddebug_setup_string);
 		if (ret)
-			pr_warn("Invalid ddebug boot param %s",
-				ddebug_setup_string);
-		else
-			pr_info("ddebug initialized with string %s",
-				ddebug_setup_string);
+			pr_warn("invalid ddebug_query\n");
 	}
 
 out_free:
-- 
1.7.4.1

