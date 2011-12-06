Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab1LFTNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:13:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56514 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab1LFTNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:13:02 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 20/25] dynamic_debug: add modname arg to exec_query callchain
Date: Tue,  6 Dec 2011 12:11:30 -0700
Message-Id: <1323198694-7186-21-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>, <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>
 <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Pass module name into ddebug_exec_queries(), ddebug_exec_query(), and
ddebug_parse_query() as separate parameter.  In ddebug_parse_query(),
the module name is added into the query struct before the query-string
is parsed.  This allows the query-string to be shorter:

instead of:
   $modname.dyndbg="module $modname +fp"
do this:
   $modname.dyndbg="+fp"

Omitting "module $modname" from the query string is actually required
for $modname.dyndbg rules; the set-only-once check added in a previous
patch will throw an error if its added again.  ddebug_query="..." has
no $modname associated with it, so the query string may include it.

This also plays well with multiple queries per string:

   $modname.dyndbg="func foo +fp; func bar +fp"

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index b774849..baed922 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -337,7 +337,7 @@ static int check_set(const char **dest, char *src, char *name)
  * Returns 0 on success, <0 on error.
  */
 static int ddebug_parse_query(char *words[], int nwords,
-			       struct ddebug_query *query)
+			struct ddebug_query *query, const char *modname)
 {
 	unsigned int i;
 	int rc;
@@ -347,6 +347,10 @@ static int ddebug_parse_query(char *words[], int nwords,
 		return -EINVAL;
 	memset(query, 0, sizeof(*query));
 
+	if (modname)
+		/* support $modname.dyndbg=<multiple queries> */
+		query->module = modname;
+
 	for (i = 0 ; i < nwords ; i += 2) {
 		if (!strcmp(words[i], "func"))
 			rc = check_set(&query->function, words[i+1], "func");
@@ -446,7 +450,7 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 	return 0;
 }
 
-static int ddebug_exec_query(char *query_string)
+static int ddebug_exec_query(char *query_string, const char *modname)
 {
 	unsigned int flags = 0, mask = 0;
 	struct ddebug_query query;
@@ -457,7 +461,7 @@ static int ddebug_exec_query(char *query_string)
 	nwords = ddebug_tokenize(query_string, words, MAXWORDS);
 	if (nwords <= 0)
 		return -EINVAL;
-	if (ddebug_parse_query(words, nwords-1, &query))
+	if (ddebug_parse_query(words, nwords-1, &query, modname))
 		return -EINVAL;
 	if (ddebug_parse_flags(words[nwords-1], &flags, &mask))
 		return -EINVAL;
@@ -473,7 +477,7 @@ static int ddebug_exec_query(char *query_string)
    last error or number of matching callsites.  Module name is either
    in param (for boot arg) or perhaps in query string.
 */
-static int ddebug_exec_queries(char *query)
+static int ddebug_exec_queries(char *query, const char *modname)
 {
 	char *split;
 	int i, errs = 0, exitcode = 0, rc, nfound = 0;
@@ -490,7 +494,7 @@ static int ddebug_exec_queries(char *query)
 		if (verbose)
 			pr_info("query %d: \"%s\"\n", i, query);
 
-		rc = ddebug_exec_query(query);
+		rc = ddebug_exec_query(query, modname);
 		if (rc < 0) {
 			errs++;
 			exitcode = rc;
@@ -656,7 +660,7 @@ static ssize_t ddebug_proc_write(struct file *file, const char __user *ubuf,
 	if (verbose)
 		pr_info("read %d bytes from userspace\n", (int)len);
 
-	ret = ddebug_exec_queries(tmpbuf);
+	ret = ddebug_exec_queries(tmpbuf, NULL);
 	kfree(tmpbuf);
 	if (ret < 0)
 		return ret;
@@ -882,7 +886,9 @@ int ddebug_dyndbg_param_cb(char *param, char* val, const char* modname)
 	if (verbose)
 		pr_info("module: %s %s=\"%s\"\n", modname, param, val);
 
-	ddebug_exec_queries((val ? val : "+p"));
+	ddebug_exec_queries((val ? val : "+p"), 
+			    !strcmp(modname, "*") ? NULL : modname);
+
 	return 0; /* query failure shouldnt stop module load */
 }
 
@@ -982,7 +988,7 @@ static int __init dynamic_debug_init(void)
 
 	/* ddebug_query boot param got passed -> set it up */
 	if (ddebug_setup_string[0] != '\0') {
-		ret = ddebug_exec_queries(ddebug_setup_string);
+		ret = ddebug_exec_queries(ddebug_setup_string, NULL);
 		if (ret < 0)
 			pr_warn("Invalid ddebug boot param %s",
 				ddebug_setup_string);
-- 
1.7.7.3

