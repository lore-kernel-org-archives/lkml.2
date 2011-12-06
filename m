Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab1LFTMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:12:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56514 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab1LFTMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:12:46 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 15/25] dynamic_debug: add trim_prefix() to provide source-root relative paths
Date: Tue,  6 Dec 2011 12:11:25 -0700
Message-Id: <1323198694-7186-16-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>, <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>
 <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

trim_prefix(path) skips past the absolute source path root, and
returns the pointer to the relative path from there.  It is used to
shorten the displayed path in $DBGMT/dynamic_debug/control via
ddebug_proc_show(), and in ddebug_change() to allow relative filenames
to be used in applied queries.  For example:

  ~# echo file kernel/freezer.c +p > $DBGMT/dynamic_debug/control

  kernel/freezer.c:128 [freezer]cancel_freezing p "  clean up: %s\012"

trim_prefix(path) insures common prefix before trimming it, so
out-of-tree module paths are shown as full absolute paths.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 Documentation/dynamic-debug-howto.txt |    7 ++++---
 lib/dynamic_debug.c                   |   18 +++++++++++++++---
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/Documentation/dynamic-debug-howto.txt b/Documentation/dynamic-debug-howto.txt
index f959909..378b5d1 100644
--- a/Documentation/dynamic-debug-howto.txt
+++ b/Documentation/dynamic-debug-howto.txt
@@ -144,11 +144,12 @@ func
     func svc_tcp_accept
 
 file
-    The given string is compared against either the full
-    pathname or the basename of the source file of each
-    callsite.  Examples:
+    The given string is compared against either the full pathname, the
+    src-root relative pathname, or the basename of the source file of
+    each callsite.  Examples:
 
     file svcsock.c
+    file kernel/freezer.c
     file /usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svcsock.c
 
 module
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 6e5b9a3..cb078d4 100644
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
 			if (query->filename &&
 			    strcmp(query->filename, dp->filename) &&
-			    strcmp(query->filename, basename(dp->filename)))
+			    strcmp(query->filename, basename(dp->filename)) &&
+			    strcmp(query->filename, trim_prefix(dp->filename)))
 				continue;
 
 			/* match against the function */
@@ -154,7 +166,7 @@ static void ddebug_change(const struct ddebug_query *query,
 			dp->flags = newflags;
 			if (verbose)
 				pr_info("changed %s:%d [%s]%s =%s\n",
-					dp->filename, dp->lineno,
+					trim_prefix(dp->filename), dp->lineno,
 					dt->mod_name, dp->function,
 					ddebug_describe_flags(dp, flagbuf,
 							sizeof(flagbuf)));
@@ -714,7 +726,7 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
 	}
 
 	seq_printf(m, "%s:%u [%s]%s =%s \"",
-		dp->filename, dp->lineno,
+		trim_prefix(dp->filename), dp->lineno,
 		iter->table->mod_name, dp->function,
 		ddebug_describe_flags(dp, flagsbuf, sizeof(flagsbuf)));
 	seq_escape(m, dp->format, "\t\r\n\"");
-- 
1.7.7.3

