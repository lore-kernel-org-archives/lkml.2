Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab1K3T6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 14:58:20 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33731 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab1K3T6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 14:58:15 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 22/25] dynamic_debug: add modname arg to exec_query callchain
Date: Wed, 30 Nov 2011 12:56:51 -0700
Message-Id: <1322683014-13285-23-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1322683014-13285-1-git-send-email-jim.cromie@gmail.com>
References: <1322683014-13285-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Extract module name from param-name, and pass to ddebug_exec_query(),
ddebug_exec_queries() and ddebug_parse_query() as separate parameter.
This has 2 purposes:

1. support multiple queries:
   $modname.dyndbg="func foo +fp; func bar +fp"

In ddebug_parse_query(), the module name is added into the query
struct before each query-string is parsed, so "module $module" must be
omitted from the query-string (param-value), otherwize the
set-only-once test added previously will issue an error.

2. With module-name passed by ddebug_boot_parse_args() into
ddebug_exec_queries(), we no longer need to sprintf "module modname"
into the query-string, and can just drop the sprintf buffer.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   29 ++++++++++++++---------------
 1 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 9dcbb61..fc3f68a 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -340,7 +340,7 @@ static int check_set(const char **dest, char *src, char *name)
  * Returns 0 on success, <0 on error.
  */
 static int ddebug_parse_query(char *words[], int nwords,
-			       struct ddebug_query *query)
+			struct ddebug_query *query, const char *modname)
 {
 	unsigned int i;
 	int rc;
@@ -350,6 +350,10 @@ static int ddebug_parse_query(char *words[], int nwords,
 		return -EINVAL;
 	memset(query, 0, sizeof(*query));
 
+	if (modname)
+		/* support $modname.dyndbg=<multiple queries> */
+		query->module = modname;
+
 	for (i = 0 ; i < nwords ; i += 2) {
 		if (!strcmp(words[i], "func"))
 			rc = check_set(&query->function, words[i+1], "func");
@@ -449,7 +453,7 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 	return 0;
 }
 
-static int ddebug_exec_query(char *query_string)
+static int ddebug_exec_query(char *query_string, const char *modname)
 {
 	unsigned int flags = 0, mask = 0;
 	struct ddebug_query query;
@@ -463,7 +467,7 @@ static int ddebug_exec_query(char *query_string)
 	nwords = ddebug_tokenize(query_string, words, MAXWORDS);
 	if (nwords <= 0)
 		return -EINVAL;
-	if (ddebug_parse_query(words, nwords-1, &query))
+	if (ddebug_parse_query(words, nwords-1, &query, modname))
 		return -EINVAL;
 	if (ddebug_parse_flags(words[nwords-1], &flags, &mask))
 		return -EINVAL;
@@ -479,7 +483,7 @@ static int ddebug_exec_query(char *query_string)
    last error or number of matching callsites.  Module name is either
    in param (for boot arg) or perhaps in query string.
 */
-static int ddebug_exec_queries(char *query)
+static int ddebug_exec_queries(char *query, char *modname)
 {
 	char *split;
 	int i, errs = 0, exitcode = 0, rc, nfound = 0;
@@ -496,7 +500,7 @@ static int ddebug_exec_queries(char *query)
 		if (verbose)
 			pr_info("query %d: \"%s\"\n", i, query);
 
-		rc = ddebug_exec_query(query);
+		rc = ddebug_exec_query(query, modname);
 		if (rc < 0) {
 			errs++;
 			exitcode = rc;
@@ -662,7 +666,7 @@ static ssize_t ddebug_proc_write(struct file *file, const char __user *ubuf,
 	if (verbose)
 		pr_info("read %d bytes from userspace\n", (int)len);
 
-	ret = ddebug_exec_queries(tmpbuf);
+	ret = ddebug_exec_queries(tmpbuf, NULL);
 	kfree(tmpbuf);
 	if (ret < 0)
 		return ret;
@@ -882,7 +886,7 @@ EXPORT_SYMBOL_GPL(ddebug_add_module);
 void ddebug_module_parse_args(const char *modname, char* modargs,
 			      struct kernel_param *params, unsigned num)
 {
-	char ddebug[DDEBUG_STRING_SIZE], *param, *val, *args_it, *arg_dup_ptr;
+	char *param, *val, *args_it, *arg_dup_ptr;
 	int i;
 
 	if (!modargs || !*modargs)
@@ -894,7 +898,6 @@ void ddebug_module_parse_args(const char *modname, char* modargs,
 	 */
 	arg_dup_ptr = args_it = kstrdup(modargs, GFP_KERNEL);
 	args_it = skip_spaces(args_it);
-
 	if (verbose)
 		pr_info("%s ARGS: %s\n", modname, args_it);
 
@@ -913,9 +916,7 @@ void ddebug_module_parse_args(const char *modname, char* modargs,
 		if (verbose)
 			pr_info("Param: %s, val: %s\n", param, val);
 
-		snprintf(ddebug, DDEBUG_STRING_SIZE, "module %s %s",
-			modname, (val ? val : "+p"));
-		ddebug_exec_queries(ddebug);
+		ddebug_exec_queries((val ? val : "+p"), modname);
 	}
 	kfree(arg_dup_ptr);
 	if (verbose)
@@ -945,9 +946,7 @@ static __init void ddebug_boot_parse_args(void)
 		if (verbose)
 			pr_info("Param: %s, val: %s\n", param, val);
 
-		snprintf(ddebug, DDEBUG_STRING_SIZE, "module %s %s",
-			module, (val ? val : "+p"));
-		ddebug_exec_queries(ddebug);
+		ddebug_exec_queries((val ? val : "+p"), module);
 	}
 }
 
@@ -1047,7 +1046,7 @@ static int __init dynamic_debug_init(void)
 
 	/* ddebug_query boot param got passed -> set it up */
 	if (ddebug_setup_string[0] != '\0') {
-		ret = ddebug_exec_queries(ddebug_setup_string);
+		ret = ddebug_exec_queries(ddebug_setup_string, NULL);
 		if (ret < 0)
 			pr_warn("Invalid ddebug boot param %s",
 				ddebug_setup_string);
-- 
1.7.7.3

