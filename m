Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab1F1HLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 03:11:53 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59669 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab1F1HKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 03:10:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NOegk3gLWu0EDh1cT4NdM6sB/bNq4UYefbJ8mRVCPl41MpGpktn0oBYVdhPGnSggXI
         oltDXEgXdOhXhgsHUydXUulwhWB5LDoC6MCZ1eEC27+p25nL/+Fzoq2QUk0XxMPeym7v
         A2mfXF9l270GbumRVrjJUGZrQP12releCN+4I=
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gnb@fmeh.org, jbaron@redhat.com, bvanassche@acm.org, gregkh@suse.de,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 05/11] dynamic_debug: use pr_info instead of printk(KERN_INFO ..
Date: Tue, 28 Jun 2011 01:09:46 -0600
Message-Id: <1309244992-2305-6-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pr_info was already in use here, update most others.
Use pr_fmt to uniformly add __func__ to all calls.
A few printks were left alone, where line was left un-terminated,
and subsequent printks appended to it.  These need separate attention.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   55 +++++++++++++++++++++++---------------------------
 1 files changed, 25 insertions(+), 30 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 2505232..17bace8 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -31,6 +31,9 @@
 #include <linux/hardirq.h>
 #include <linux/sched.h>
 
+#undef pr_fmt
+#define pr_fmt(fmt) "%s: " fmt, __func__
+
 extern struct _ddebug __start___verbose[];
 extern struct _ddebug __stop___verbose[];
 
@@ -160,8 +163,7 @@ static void ddebug_change(const struct ddebug_query *query,
 			else
 				dp->enabled = 0;
 			if (verbose)
-				printk(KERN_INFO
-					"ddebug: changed %s:%d [%s]%s %s\n",
+				pr_info("changed %s:%d [%s]%s %s\n",
 					dp->filename, dp->lineno,
 					dt->mod_name, dp->function,
 					ddebug_describe_flags(dp, flagbuf,
@@ -171,7 +173,7 @@ static void ddebug_change(const struct ddebug_query *query,
 	mutex_unlock(&ddebug_lock);
 
 	if (!nfound && verbose)
-		printk(KERN_INFO "ddebug: no matches for query\n");
+		pr_info("no matches for query\n");
 }
 
 /*
@@ -349,9 +351,9 @@ static int ddebug_parse_query(char *words[], int nwords,
 	}
 
 	if (verbose)
-		printk(KERN_INFO "%s: q->function=\"%s\" q->filename=\"%s\" "
+		pr_info("q->function=\"%s\" q->filename=\"%s\" "
 		       "q->module=\"%s\" q->format=\"%s\" q->lineno=%u-%u\n",
-			__func__, query->function, query->filename,
+			query->function, query->filename,
 			query->module, query->format, query->first_lineno,
 			query->last_lineno);
 
@@ -380,7 +382,7 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 		return -EINVAL;
 	}
 	if (verbose)
-		printk(KERN_INFO "%s: op='%c'\n", __func__, op);
+		pr_info("op='%c'\n", op);
 
 	for ( ; *str ; ++str) {
 		for (i = ARRAY_SIZE(opt_array) - 1; i >= 0; i--) {
@@ -395,7 +397,7 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 	if (flags == 0)
 		return -EINVAL;
 	if (verbose)
-		printk(KERN_INFO "%s: flags=0x%x\n", __func__, flags);
+		pr_info("flags=0x%x\n", flags);
 
 	/* calculate final *flagsp, *maskp according to mask and op */
 	switch (op) {
@@ -413,8 +415,8 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 		break;
 	}
 	if (verbose)
-		printk(KERN_INFO "%s: *flagsp=0x%x *maskp=0x%x\n",
-			__func__, *flagsp, *maskp);
+		pr_info("*flagsp=0x%x *maskp=0x%x\n", *flagsp, *maskp);
+
 	return 0;
 }
 
@@ -457,8 +459,7 @@ static int ddebug_exec_queries(char *query)
 			*split++ = '\0';
 
 		if (verbose)
-			printk(KERN_INFO "%s: query %d: \"%s\"",
-				__func__, i, query);
+			pr_info("query %d: \"%s\"\n", i, query);
 
 		rc = ddebug_exec_query(query);
 		if (rc) {
@@ -467,9 +468,7 @@ static int ddebug_exec_queries(char *query)
 		}
 	}
 	if (verbose)
-		printk(KERN_INFO
-			"%s: processed %d queries, with %d errs",
-			__func__, i, errs);
+		pr_info("processed %d queries, with %d errs", i, errs);
 
 	return exitcode;
 }
@@ -507,7 +506,7 @@ static __initdata char ddebug_setup_string[1024];
 static __init int ddebug_setup_query(char *str)
 {
 	if (strlen(str) >= 1024) {
-		pr_warning("ddebug boot param string too large\n");
+		pr_warning("boot param string too large\n");
 		return 0;
 	}
 	strcpy(ddebug_setup_string, str);
@@ -535,8 +534,7 @@ static ssize_t ddebug_proc_write(struct file *file, const char __user *ubuf,
 		return -EFAULT;
 	tmpbuf[len] = '\0';
 	if (verbose)
-		printk(KERN_INFO "%s: read %d bytes from userspace\n",
-			__func__, (int)len);
+		pr_info("read %d bytes from userspace\n", (int)len);
 
 	ret = ddebug_exec_queries(tmpbuf);
 	if (ret)
@@ -599,8 +597,8 @@ static void *ddebug_proc_start(struct seq_file *m, loff_t *pos)
 	int n = *pos;
 
 	if (verbose)
-		printk(KERN_INFO "%s: called m=%p *pos=%lld\n",
-			__func__, m, (unsigned long long)*pos);
+		pr_info("called m=%p *pos=%lld\n",
+			m, (unsigned long long)*pos);
 
 	mutex_lock(&ddebug_lock);
 
@@ -625,8 +623,8 @@ static void *ddebug_proc_next(struct seq_file *m, void *p, loff_t *pos)
 	struct _ddebug *dp;
 
 	if (verbose)
-		printk(KERN_INFO "%s: called m=%p p=%p *pos=%lld\n",
-			__func__, m, p, (unsigned long long)*pos);
+		pr_info("called m=%p p=%p *pos=%lld\n",
+			m, p, (unsigned long long)*pos);
 
 	if (p == SEQ_START_TOKEN)
 		dp = ddebug_iter_first(iter);
@@ -650,8 +648,7 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
 	const int offset = strlen(__FILE__) - strlen("lib/dynamic_debug.c");
 
 	if (verbose)
-		printk(KERN_INFO "%s: called m=%p p=%p\n",
-			__func__, m, p);
+		pr_info("called m=%p p=%p\n", m, p);
 
 	if (p == SEQ_START_TOKEN) {
 		seq_puts(m,
@@ -676,8 +673,8 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
 static void ddebug_proc_stop(struct seq_file *m, void *p)
 {
 	if (verbose)
-		printk(KERN_INFO "%s: called m=%p p=%p\n",
-			__func__, m, p);
+		pr_info("called m=%p p=%p\n", m, p);
+			
 	mutex_unlock(&ddebug_lock);
 }
 
@@ -700,7 +697,7 @@ static int ddebug_proc_open(struct inode *inode, struct file *file)
 	int err;
 
 	if (verbose)
-		printk(KERN_INFO "%s: called\n", __func__);
+		pr_info("called\n");
 
 	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
 	if (iter == NULL)
@@ -752,8 +749,7 @@ int ddebug_add_module(struct _ddebug *tab, unsigned int n,
 	mutex_unlock(&ddebug_lock);
 
 	if (verbose)
-		printk(KERN_INFO "%u debug prints in module %s\n",
-				 n, dt->mod_name);
+		pr_info("%u debug prints in module %s\n", n, dt->mod_name);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ddebug_add_module);
@@ -775,8 +771,7 @@ int ddebug_remove_module(const char *mod_name)
 	int ret = -ENOENT;
 
 	if (verbose)
-		printk(KERN_INFO "%s: removing module \"%s\"\n",
-				__func__, mod_name);
+		pr_info("removing module \"%s\"\n", mod_name);
 
 	mutex_lock(&ddebug_lock);
 	list_for_each_entry_safe(dt, nextdt, &ddebug_tables, link) {
-- 
1.7.4.1

