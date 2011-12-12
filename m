Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab1LLXPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:15:20 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51049 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab1LLXNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:13:44 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 20/25] dynamic_debug: add modname arg to exec_query callchain
Date: Mon, 12 Dec 2011 16:12:46 -0700
Message-Id: <1323731569-20644-20-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323731569-20644-1-git-send-email-jim.cromie@gmail.com>
References: <1323731569-20644-1-git-send-email-jim.cromie@gmail.com>
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

This also fixes redundant "module $modname" otherwise needed to handle
multiple queries per string:

   $modname.dyndbg="func foo +fp; func bar +fp"

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   25 ++++++++++++++++---------
 1 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 4cdcc64..5711628 100644
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
 
-	ddebug_exec_queries(val ? val : "+p");
+	ddebug_exec_queries((val ? val : "+p"),
+			    !strcmp(modname, "*") ? NULL : modname);
+
 	return 0; /* query failure shouldnt stop module load */
 }
 
@@ -909,7 +915,8 @@ static __init void ddebug_boot_parse_args(void)
 		if (verbose)
 			pr_info("Param: %s, val: %s\n", param, val);
 
-		ddebug_exec_queries(val ? val : "+p");
+		ddebug_exec_queries((val ? val : "+p"),
+				!strcmp(modname, "*") ? NULL : modname);
 	}
 }
 
@@ -1009,7 +1016,7 @@ static int __init dynamic_debug_init(void)
 
 	/* ddebug_query boot param got passed -> set it up */
 	if (ddebug_setup_string[0] != '\0') {
-		ret = ddebug_exec_queries(ddebug_setup_string);
+		ret = ddebug_exec_queries(ddebug_setup_string, NULL);
 		if (ret < 0)
 			pr_warn("Invalid ddebug boot param %s",
 				ddebug_setup_string);
-- 
1.7.7.3

