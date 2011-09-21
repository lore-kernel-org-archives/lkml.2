Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846Ab1IUV4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 17:56:05 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33832 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab1IUV4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:56:00 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: joe@perches.com, bart.vanassche@gmail.com, greg@kroah.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 06/26] dynamic_debug: add trim_prefix() to provide source-root relative paths
Date: Wed, 21 Sep 2011 15:54:55 -0600
Message-Id: <1316642115-20029-7-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

trim_prefix(path) skips past the absolute source path root, and returns
the pointer to the relative path from there.  Use it to shorten displayed
path in ddebug_change() and in ddebug_proc_show().  Function insures
common prefix, so out-of-tree module paths are preserved as absolute paths.

For example:
  kernel/freezer.c:128 [freezer]cancel_freezing - "  clean up: %s\012"

Use trim_prefix() in ddebug_change to allow use of a relative pathname
in a file match-spec, in addition to basename and full-path.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index e7090f2..2d26c10 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -69,6 +69,17 @@ static inline const char *basename(const char *path)
 	return tail ? tail+1 : path;
 }
 
+/* Return the path relative to source root */
+static inline const char *trim_prefix(const char *path)
+{
+	int skip = strlen(__FILE__) - strlen("lib/dynamic_debug.c");
+
+	if (strncmp(path, __FILE__, skip))
+		skip = 0; /* prefix mismatch, don't skip */
+
+	return path + skip;
+}
+
 static struct { unsigned flag:8; char opt_char; } opt_array[] = {
 	{ _DPRINTK_FLAGS_PRINT, 'p' },
 	{ _DPRINTK_FLAGS_INCL_MODNAME, 'm' },
@@ -125,7 +136,8 @@ static void ddebug_change(const struct ddebug_query *query,
 			/* match against the source filename */
 			if (query->filename != NULL &&
 			    strcmp(query->filename, dp->filename) &&
-			    strcmp(query->filename, basename(dp->filename)))
+			    strcmp(query->filename, basename(dp->filename)) &&
+			    strcmp(query->filename, trim_prefix(dp->filename)))
 				continue;
 
 			/* match against the function */
@@ -154,7 +166,7 @@ static void ddebug_change(const struct ddebug_query *query,
 			dp->flags = newflags;
 			if (verbose)
 				pr_info("changed %s:%d [%s]%s %s\n",
-					dp->filename, dp->lineno,
+					trim_prefix(dp->filename), dp->lineno,
 					dt->mod_name, dp->function,
 					ddebug_describe_flags(dp, flagbuf,
 							sizeof(flagbuf)));
@@ -682,9 +694,9 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
 	}
 
 	seq_printf(m, "%s:%u [%s]%s %s \"",
-		   dp->filename, dp->lineno,
-		   iter->table->mod_name, dp->function,
-		   ddebug_describe_flags(dp, flagsbuf, sizeof(flagsbuf)));
+		trim_prefix(dp->filename), dp->lineno,
+		iter->table->mod_name, dp->function,
+		ddebug_describe_flags(dp, flagsbuf, sizeof(flagsbuf)));
 	seq_escape(m, dp->format, "\t\r\n\"");
 	seq_puts(m, "\"\n");
 
-- 
1.7.4.4

