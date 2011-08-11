Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab1HKSgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 14:36:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907Ab1HKSgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 14:36:39 -0400
Date: Thu, 11 Aug 2011 14:36:33 -0400
From: Jason Baron <jbaron@redhat.com>
To: gregkh@suse.de
Cc: joe@perches.com, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org
Message-Id: <b744348cd02493a867a7ca447cf91d018a8eb3f5.1313085588.git.jbaron@redhat.com>
In-Reply-To: <cover.1313085588.git.jbaron@redhat.com>
References: <cover.1313085588.git.jbaron@redhat.com>
Subject: [PATCH 04/11] dynamic_debug: Convert printks to pr_<level>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Add pr_fmt(fmt) with __func__.
Converts "ddebug:" prefix to "dynamic_debug:".

Most likely the if (verbose) outputs could
also be converted from pr_info to pr_debug.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 lib/dynamic_debug.c |   59 ++++++++++++++++++++++----------------------------
 1 files changed, 26 insertions(+), 33 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index a3eb6ab..4fc03dd 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -10,6 +10,8 @@
  * Copyright (C) 2011 Bart Van Assche.  All Rights Reserved.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -160,8 +162,7 @@ static void ddebug_change(const struct ddebug_query *query,
 			else
 				dp->enabled = 0;
 			if (verbose)
-				printk(KERN_INFO
-					"ddebug: changed %s:%d [%s]%s %s\n",
+				pr_info("changed %s:%d [%s]%s %s\n",
 					dp->filename, dp->lineno,
 					dt->mod_name, dp->function,
 					ddebug_describe_flags(dp, flagbuf,
@@ -171,7 +172,7 @@ static void ddebug_change(const struct ddebug_query *query,
 	mutex_unlock(&ddebug_lock);
 
 	if (!nfound && verbose)
-		printk(KERN_INFO "ddebug: no matches for query\n");
+		pr_info("no matches for query\n");
 }
 
 /*
@@ -216,10 +217,10 @@ static int ddebug_tokenize(char *buf, char *words[], int maxwords)
 
 	if (verbose) {
 		int i;
-		printk(KERN_INFO "%s: split into words:", __func__);
+		pr_info("split into words:");
 		for (i = 0 ; i < nwords ; i++)
-			printk(" \"%s\"", words[i]);
-		printk("\n");
+			pr_cont(" \"%s\"", words[i]);
+		pr_cont("\n");
 	}
 
 	return nwords;
@@ -331,16 +332,15 @@ static int ddebug_parse_query(char *words[], int nwords,
 			}
 		} else {
 			if (verbose)
-				printk(KERN_ERR "%s: unknown keyword \"%s\"\n",
-					__func__, words[i]);
+				pr_err("unknown keyword \"%s\"\n", words[i]);
 			return -EINVAL;
 		}
 	}
 
 	if (verbose)
-		printk(KERN_INFO "%s: q->function=\"%s\" q->filename=\"%s\" "
-		       "q->module=\"%s\" q->format=\"%s\" q->lineno=%u-%u\n",
-			__func__, query->function, query->filename,
+		pr_info("q->function=\"%s\" q->filename=\"%s\" "
+			"q->module=\"%s\" q->format=\"%s\" q->lineno=%u-%u\n",
+			query->function, query->filename,
 			query->module, query->format, query->first_lineno,
 			query->last_lineno);
 
@@ -369,7 +369,7 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 		return -EINVAL;
 	}
 	if (verbose)
-		printk(KERN_INFO "%s: op='%c'\n", __func__, op);
+		pr_info("op='%c'\n", op);
 
 	for ( ; *str ; ++str) {
 		for (i = ARRAY_SIZE(opt_array) - 1; i >= 0; i--) {
@@ -384,7 +384,7 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 	if (flags == 0)
 		return -EINVAL;
 	if (verbose)
-		printk(KERN_INFO "%s: flags=0x%x\n", __func__, flags);
+		pr_info("flags=0x%x\n", flags);
 
 	/* calculate final *flagsp, *maskp according to mask and op */
 	switch (op) {
@@ -402,8 +402,7 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 		break;
 	}
 	if (verbose)
-		printk(KERN_INFO "%s: *flagsp=0x%x *maskp=0x%x\n",
-			__func__, *flagsp, *maskp);
+		pr_info("*flagsp=0x%x *maskp=0x%x\n", *flagsp, *maskp);
 	return 0;
 }
 
@@ -508,7 +507,7 @@ static __initdata char ddebug_setup_string[1024];
 static __init int ddebug_setup_query(char *str)
 {
 	if (strlen(str) >= 1024) {
-		pr_warning("ddebug boot param string too large\n");
+		pr_warn("ddebug boot param string too large\n");
 		return 0;
 	}
 	strcpy(ddebug_setup_string, str);
@@ -536,8 +535,7 @@ static ssize_t ddebug_proc_write(struct file *file, const char __user *ubuf,
 		return -EFAULT;
 	tmpbuf[len] = '\0';
 	if (verbose)
-		printk(KERN_INFO "%s: read %d bytes from userspace\n",
-			__func__, (int)len);
+		pr_info("read %d bytes from userspace\n", (int)len);
 
 	ret = ddebug_exec_query(tmpbuf);
 	if (ret)
@@ -600,8 +598,7 @@ static void *ddebug_proc_start(struct seq_file *m, loff_t *pos)
 	int n = *pos;
 
 	if (verbose)
-		printk(KERN_INFO "%s: called m=%p *pos=%lld\n",
-			__func__, m, (unsigned long long)*pos);
+		pr_info("called m=%p *pos=%lld\n", m, (unsigned long long)*pos);
 
 	mutex_lock(&ddebug_lock);
 
@@ -626,8 +623,8 @@ static void *ddebug_proc_next(struct seq_file *m, void *p, loff_t *pos)
 	struct _ddebug *dp;
 
 	if (verbose)
-		printk(KERN_INFO "%s: called m=%p p=%p *pos=%lld\n",
-			__func__, m, p, (unsigned long long)*pos);
+		pr_info("called m=%p p=%p *pos=%lld\n",
+			m, p, (unsigned long long)*pos);
 
 	if (p == SEQ_START_TOKEN)
 		dp = ddebug_iter_first(iter);
@@ -650,8 +647,7 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
 	char flagsbuf[8];
 
 	if (verbose)
-		printk(KERN_INFO "%s: called m=%p p=%p\n",
-			__func__, m, p);
+		pr_info("called m=%p p=%p\n", m, p);
 
 	if (p == SEQ_START_TOKEN) {
 		seq_puts(m,
@@ -676,8 +672,7 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
 static void ddebug_proc_stop(struct seq_file *m, void *p)
 {
 	if (verbose)
-		printk(KERN_INFO "%s: called m=%p p=%p\n",
-			__func__, m, p);
+		pr_info("called m=%p p=%p\n", m, p);
 	mutex_unlock(&ddebug_lock);
 }
 
@@ -700,7 +695,7 @@ static int ddebug_proc_open(struct inode *inode, struct file *file)
 	int err;
 
 	if (verbose)
-		printk(KERN_INFO "%s: called\n", __func__);
+		pr_info("called\n");
 
 	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
 	if (iter == NULL)
@@ -752,8 +747,7 @@ int ddebug_add_module(struct _ddebug *tab, unsigned int n,
 	mutex_unlock(&ddebug_lock);
 
 	if (verbose)
-		printk(KERN_INFO "%u debug prints in module %s\n",
-				 n, dt->mod_name);
+		pr_info("%u debug prints in module %s\n", n, dt->mod_name);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ddebug_add_module);
@@ -775,8 +769,7 @@ int ddebug_remove_module(const char *mod_name)
 	int ret = -ENOENT;
 
 	if (verbose)
-		printk(KERN_INFO "%s: removing module \"%s\"\n",
-				__func__, mod_name);
+		pr_info("removing module \"%s\"\n", mod_name);
 
 	mutex_lock(&ddebug_lock);
 	list_for_each_entry_safe(dt, nextdt, &ddebug_tables, link) {
@@ -852,8 +845,8 @@ static int __init dynamic_debug_init(void)
 	if (ddebug_setup_string[0] != '\0') {
 		ret = ddebug_exec_query(ddebug_setup_string);
 		if (ret)
-			pr_warning("Invalid ddebug boot param %s",
-				   ddebug_setup_string);
+			pr_warn("Invalid ddebug boot param %s",
+				ddebug_setup_string);
 		else
 			pr_info("ddebug initialized with string %s",
 				ddebug_setup_string);
-- 
1.7.5.4

