Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030231Ab2CNXCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 19:02:54 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:34736 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964793Ab2CNXCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 19:02:44 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com, rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 09/11] dynamic_debug: add modname arg to exec_query callchain
Date: Wed, 14 Mar 2012 17:02:04 -0600
Message-Id: <1331766126-11674-10-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.8.1
In-Reply-To: <1331766126-11674-1-git-send-email-jim.cromie@gmail.com>
References: <1331766126-11674-1-git-send-email-jim.cromie@gmail.com>
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
 lib/dynamic_debug.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 662204a..8fcead5 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -338,7 +338,7 @@ static int check_set(const char **dest, char *src, char *name)
  * Returns 0 on success, <0 on error.
  */
 static int ddebug_parse_query(char *words[], int nwords,
-			       struct ddebug_query *query)
+			struct ddebug_query *query, const char *modname)
 {
 	unsigned int i;
 	int rc;
@@ -348,6 +348,10 @@ static int ddebug_parse_query(char *words[], int nwords,
 		return -EINVAL;
 	memset(query, 0, sizeof(*query));
 
+	if (modname)
+		/* support $modname.dyndbg=<multiple queries> */
+		query->module = modname;
+
 	for (i = 0 ; i < nwords ; i += 2) {
 		if (!strcmp(words[i], "func"))
 			rc = check_set(&query->function, words[i+1], "func");
@@ -444,7 +448,7 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 	return 0;
 }
 
-static int ddebug_exec_query(char *query_string)
+static int ddebug_exec_query(char *query_string, const char *modname)
 {
 	unsigned int flags = 0, mask = 0;
 	struct ddebug_query query;
@@ -455,7 +459,7 @@ static int ddebug_exec_query(char *query_string)
 	nwords = ddebug_tokenize(query_string, words, MAXWORDS);
 	if (nwords <= 0)
 		return -EINVAL;
-	if (ddebug_parse_query(words, nwords-1, &query))
+	if (ddebug_parse_query(words, nwords-1, &query, modname))
 		return -EINVAL;
 	if (ddebug_parse_flags(words[nwords-1], &flags, &mask))
 		return -EINVAL;
@@ -471,7 +475,7 @@ static int ddebug_exec_query(char *query_string)
    last error or number of matching callsites.  Module name is either
    in param (for boot arg) or perhaps in query string.
 */
-static int ddebug_exec_queries(char *query)
+static int ddebug_exec_queries(char *query, const char *modname)
 {
 	char *split;
 	int i, errs = 0, exitcode = 0, rc, nfound = 0;
@@ -487,7 +491,7 @@ static int ddebug_exec_queries(char *query)
 
 		vpr_info("query %d: \"%s\"\n", i, query);
 
-		rc = ddebug_exec_query(query);
+		rc = ddebug_exec_query(query, modname);
 		if (rc < 0) {
 			errs++;
 			exitcode = rc;
@@ -652,7 +656,7 @@ static ssize_t ddebug_proc_write(struct file *file, const char __user *ubuf,
 	tmpbuf[len] = '\0';
 	vpr_info("read %d bytes from userspace\n", (int)len);
 
-	ret = ddebug_exec_queries(tmpbuf);
+	ret = ddebug_exec_queries(tmpbuf, NULL);
 	kfree(tmpbuf);
 	if (ret < 0)
 		return ret;
@@ -880,7 +884,8 @@ static int ddebug_dyndbg_boot_param_cb(char *param, char *val,
 
 	vpr_info("module: %s %s=\"%s\"\n", modname, param, val);
 
-	ddebug_exec_queries(val ? val : "+p");
+	ddebug_exec_queries((val ? val : "+p"), modname);
+
 	return 0; /* query failure shouldnt stop module load */
 }
 
-- 
1.7.7.6

