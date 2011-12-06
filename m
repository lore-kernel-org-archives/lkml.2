Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab1LFTMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:12:55 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56514 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab1LFTMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:12:52 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 17/25] dynamic_debug: process multiple debug-queries on a line
Date: Tue,  6 Dec 2011 12:11:27 -0700
Message-Id: <1323198694-7186-18-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>, <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>
 <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Insert ddebug_exec_queries() in place of ddebug_exec_query().  It
splits the query string on [;\n], and calls ddebug_exec_query() on
each.  All queries are processed independent of errors, allowing a
query to fail, for example when a module is not installed.  Empty
lines and comments are skipped.  Errors are counted, and the last
error seen (negative) or the number of callsites found (0 or positive)
is returned.  Return code checks are altered accordingly.

With this, multiple queries can be given in ddebug_query, allowing
more selective enabling of callsites.  As a side effect, a set of
commands can be batched in:

	cat cmd-file > $DBGMT/dynamic_debug/control

We dont want a ddebug_query syntax error to kill the dynamic debug
facility, so dynamic_debug_init() zeros ddebug_exec_queries()'s return
code after logging the appropriate message, so that ddebug tables are
preserved and $DBGMT/dynamic_debug/control file is created.  This
would be appropriate even without accepting multiple queries.

This patch also alters ddebug_change() to return number of callsites
matched (which typically is the same as number of callsites changed).
ddebug_exec_query() also returns the number found, or a negative value
if theres a parse error on the query.

Splitting on [;\n] prevents their use in format-specs, but selecting
callsites on punctuation is brittle anyway, meaningful and selective
substrings are more typical.

Note: splitting queries on ';' before handling trailing #comments
means that a ';' also terminates a comment, and text after the ';' is
treated as another query.  This trailing query will almost certainly
result in a parse error and thus have no effect other than the error
message.  The double corner case with unexpected results is:

     ddebug_query="func foo +p # enable foo ; +p"

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 Documentation/dynamic-debug-howto.txt |   17 +++-----
 lib/dynamic_debug.c                   |   73 ++++++++++++++++++++++++++-------
 2 files changed, 65 insertions(+), 25 deletions(-)

diff --git a/Documentation/dynamic-debug-howto.txt b/Documentation/dynamic-debug-howto.txt
index 378b5d1..989a892 100644
--- a/Documentation/dynamic-debug-howto.txt
+++ b/Documentation/dynamic-debug-howto.txt
@@ -12,7 +12,7 @@ dynamically enabled per-callsite.
 Dynamic debug has even more useful features:
 
  * Simple query language allows turning on and off debugging statements by
-   matching any combination of:
+   matching any combination of 0 or 1 of:
 
    - source filename
    - function name
@@ -92,18 +92,15 @@ nullarbor:~ # echo -c 'file svcsock.c\nline 1603 +p' >
 nullarbor:~ # echo -n 'file svcsock.c line 1603 +p' >
 				<debugfs>/dynamic_debug/control
 
-Commands are bounded by a write() system call.  If you want to do
-multiple commands you need to do a separate "echo" for each, like:
+Command submissions are bounded by a write() system call.
+Multiple commands can be written together, separated by ';' or '\n'.
 
-nullarbor:~ # echo 'file svcsock.c line 1603 +p' > /proc/dprintk ;\
-> echo 'file svcsock.c line 1563 +p' > /proc/dprintk
+  ~# echo "func pnpacpi_get_resources +p; func pnp_assign_mem +p" \
+     > <debugfs>/dynamic_debug/control
 
-or even like:
+If your query set is big, you can batch them too:
 
-nullarbor:~ # (
-> echo 'file svcsock.c line 1603 +p' ;\
-> echo 'file svcsock.c line 1563 +p' ;\
-> ) > /proc/dprintk
+  ~# cat query-batch-file > <debugfs>/dynamic_debug/control
 
 At the syntactical level, a command comprises a sequence of match
 specifications, followed by a flags change specification.
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 1a0e9bd..516ad4e 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -124,13 +124,13 @@ do {									\
 } while (0)
 
 /*
- * Search the tables for _ddebug's which match the given
- * `query' and apply the `flags' and `mask' to them.  Tells
- * the user which ddebug's were changed, or whether none
- * were matched.
+ * Search the tables for _ddebug's which match the given `query' and
+ * apply the `flags' and `mask' to them.  Returns number of matching
+ * callsites, normally the same as number of changes.  If verbose,
+ * logs the changes.  Takes ddebug_lock.
  */
-static void ddebug_change(const struct ddebug_query *query,
-			   unsigned int flags, unsigned int mask)
+static int ddebug_change(const struct ddebug_query *query,
+			unsigned int flags, unsigned int mask)
 {
 	int i;
 	struct ddebug_table *dt;
@@ -192,6 +192,8 @@ static void ddebug_change(const struct ddebug_query *query,
 
 	if (!nfound && verbose)
 		pr_info("no matches for query\n");
+
+	return nfound;
 }
 
 /*
@@ -449,7 +451,7 @@ static int ddebug_exec_query(char *query_string)
 	unsigned int flags = 0, mask = 0;
 	struct ddebug_query query;
 #define MAXWORDS 9
-	int nwords;
+	int nwords, nfound;
 	char *words[MAXWORDS];
 
 	nwords = ddebug_tokenize(query_string, words, MAXWORDS);
@@ -461,8 +463,47 @@ static int ddebug_exec_query(char *query_string)
 		return -EINVAL;
 
 	/* actually go and implement the change */
-	ddebug_change(&query, flags, mask);
-	return 0;
+	nfound = ddebug_change(&query, flags, mask);
+	vpr_info_dq((&query), (nfound) ? "applied" : "no-match");
+
+	return nfound;
+}
+
+/* handle multiple queries in query string, continue on error, return
+   last error or number of matching callsites.  Module name is either
+   in param (for boot arg) or perhaps in query string.
+*/
+static int ddebug_exec_queries(char *query)
+{
+	char *split;
+	int i, errs = 0, exitcode = 0, rc, nfound = 0;
+
+	for (i = 0; query; query = split) {
+		split = strpbrk(query, ";\n");
+		if (split)
+			*split++ = '\0';
+
+		query = skip_spaces(query);
+		if (!query || !*query || *query == '#')
+			continue;
+
+		if (verbose)
+			pr_info("query %d: \"%s\"\n", i, query);
+
+		rc = ddebug_exec_query(query);
+		if (rc < 0) {
+			errs++;
+			exitcode = rc;
+		} else
+			nfound += rc;
+		i++;
+	}
+	pr_info("processed %d queries, with %d matches, %d errs\n",
+		 i, nfound, errs);
+
+	if (exitcode)
+		return exitcode;
+	return nfound;
 }
 
 #define PREFIX_SIZE 64
@@ -615,9 +656,9 @@ static ssize_t ddebug_proc_write(struct file *file, const char __user *ubuf,
 	if (verbose)
 		pr_info("read %d bytes from userspace\n", (int)len);
 
-	ret = ddebug_exec_query(tmpbuf);
+	ret = ddebug_exec_queries(tmpbuf);
 	kfree(tmpbuf);
-	if (ret)
+	if (ret < 0)
 		return ret;
 
 	*offp += len;
@@ -927,13 +968,15 @@ static int __init dynamic_debug_init(void)
 
 	/* ddebug_query boot param got passed -> set it up */
 	if (ddebug_setup_string[0] != '\0') {
-		ret = ddebug_exec_query(ddebug_setup_string);
-		if (ret)
+		ret = ddebug_exec_queries(ddebug_setup_string);
+		if (ret < 0)
 			pr_warn("Invalid ddebug boot param %s",
 				ddebug_setup_string);
 		else
-			pr_info("ddebug initialized with string %s",
-				ddebug_setup_string);
+			pr_info("%d changes by ddebug_query\n", ret);
+
+		/* keep tables even on ddebug_query parse error */
+		ret = 0;
 	}
 
 out_free:
-- 
1.7.7.3

