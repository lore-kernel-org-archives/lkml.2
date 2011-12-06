Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab1LFTMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:12:33 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56514 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab1LFTMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:12:30 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 09/25] dynamic_debug: describe_flags with '=[pmflt_]*'
Date: Tue,  6 Dec 2011 12:11:19 -0700
Message-Id: <1323198694-7186-10-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>, <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>
 <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Change describe_flags() to emit '=[pmflt_]+' for current callsite
flags, or just '=_' when they're disabled.  Having '=' in output
allows a more selective grep expression; in contrast '-' may appear
in filenames, line-ranges, and format-strings.  '=' also has better
mnemonics, saying; "the current setting is equal to <flags>".

This allows grep "=_" <dbgfs>/dynamic_debug/control to see disabled
callsites while avoiding the many occurrences of " = " seen in format
strings.

Enlarge flagsbufs to handle additional flag char, and alter
ddebug_parse_flags() to allow flags=0, so that user can turn off all
debug flags via:

  ~# echo =_ > <dbgfs>/dynamic_debug/control

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 include/linux/dynamic_debug.h |    3 ++-
 lib/dynamic_debug.c           |   21 ++++++++++-----------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 29ea09a..fc39640 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -21,7 +21,8 @@ struct _ddebug {
  	 * The bits here are changed dynamically when the user
 	 * writes commands to <debugfs>/dynamic_debug/control
 	 */
-#define _DPRINTK_FLAGS_PRINT   (1<<0)  /* printk() a message using the format */
+#define _DPRINTK_FLAGS_NONE	0
+#define _DPRINTK_FLAGS_PRINT	(1<<0) /* printk() a message using the format */
 #define _DPRINTK_FLAGS_INCL_MODNAME	(1<<1)
 #define _DPRINTK_FLAGS_INCL_FUNCNAME	(1<<2)
 #define _DPRINTK_FLAGS_INCL_LINENO	(1<<3)
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 6904fdc..6a170c3 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -75,6 +75,7 @@ static struct { unsigned flag:8; char opt_char; } opt_array[] = {
 	{ _DPRINTK_FLAGS_INCL_FUNCNAME, 'f' },
 	{ _DPRINTK_FLAGS_INCL_LINENO, 'l' },
 	{ _DPRINTK_FLAGS_INCL_TID, 't' },
+	{ _DPRINTK_FLAGS_NONE, '_' },
 };
 
 /* format a string into buf[] which describes the _ddebug's flags */
@@ -84,12 +85,12 @@ static char *ddebug_describe_flags(struct _ddebug *dp, char *buf,
 	char *p = buf;
 	int i;
 
-	BUG_ON(maxlen < 4);
+	BUG_ON(maxlen < 6);
 	for (i = 0; i < ARRAY_SIZE(opt_array); ++i)
 		if (dp->flags & opt_array[i].flag)
 			*p++ = opt_array[i].opt_char;
 	if (p == buf)
-		*p++ = '-';
+		*p++ = '_';
 	*p = '\0';
 
 	return buf;
@@ -108,7 +109,7 @@ static void ddebug_change(const struct ddebug_query *query,
 	struct ddebug_table *dt;
 	unsigned int newflags;
 	unsigned int nfound = 0;
-	char flagbuf[8];
+	char flagbuf[10];
 
 	/* search for matching ddebugs */
 	mutex_lock(&ddebug_lock);
@@ -152,7 +153,7 @@ static void ddebug_change(const struct ddebug_query *query,
 				continue;
 			dp->flags = newflags;
 			if (verbose)
-				pr_info("changed %s:%d [%s]%s %s\n",
+				pr_info("changed %s:%d [%s]%s =%s\n",
 					dp->filename, dp->lineno,
 					dt->mod_name, dp->function,
 					ddebug_describe_flags(dp, flagbuf,
@@ -370,8 +371,6 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 		if (i < 0)
 			return -EINVAL;
 	}
-	if (flags == 0)
-		return -EINVAL;
 	if (verbose)
 		pr_info("flags=0x%x\n", flags);
 
@@ -666,7 +665,7 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
 {
 	struct ddebug_iter *iter = m->private;
 	struct _ddebug *dp = p;
-	char flagsbuf[8];
+	char flagsbuf[10];
 
 	if (verbose)
 		pr_info("called m=%p p=%p\n", m, p);
@@ -677,10 +676,10 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
 		return 0;
 	}
 
-	seq_printf(m, "%s:%u [%s]%s %s \"",
-		   dp->filename, dp->lineno,
-		   iter->table->mod_name, dp->function,
-		   ddebug_describe_flags(dp, flagsbuf, sizeof(flagsbuf)));
+	seq_printf(m, "%s:%u [%s]%s =%s \"",
+		dp->filename, dp->lineno,
+		iter->table->mod_name, dp->function,
+		ddebug_describe_flags(dp, flagsbuf, sizeof(flagsbuf)));
 	seq_escape(m, dp->format, "\t\r\n\"");
 	seq_puts(m, "\"\n");
 
-- 
1.7.7.3

