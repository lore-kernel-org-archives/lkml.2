Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab1GKHsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 03:48:30 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33546 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275Ab1GKHrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 03:47:47 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, bvanassche@acm.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 19/21] dynamic_debug: add flags filtering to flags spec handling
Date: Mon, 11 Jul 2011 01:46:54 -0600
Message-Id: <1310370416-6322-20-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change definition of flags spec to [ptlmfa]*[-+=][ptlmfa]+
The flags preceding the op are optional filter-flags, if provided,
they add an additional constraint to call-site matching done
by ddebug_change; call-sites which do not have all specified flags
are skipped (additional flags are allowed).

This allows query/rules like "p+t" to turn on TID logging for all
currently enabled call-sites, while leaving the others alone.
This will also allow filtering on pending rules (with 'a' flag),
which will support removal of pending rules.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   81 +++++++++++++++++++++++++++++++-------------------
 1 files changed, 50 insertions(+), 31 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 44ccc02..9514071 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -174,7 +174,8 @@ static int query_matches_callsite(struct _ddebug *dp,
  * were matched.  Called with ddebug_lock held.
  */
 static int ddebug_change(const struct ddebug_query *query,
-			unsigned int flags, unsigned int mask)
+			unsigned int flags, unsigned int mask,
+			unsigned int filter)
 {
 	int i;
 	struct ddebug_table *dt;
@@ -196,6 +197,9 @@ static int ddebug_change(const struct ddebug_query *query,
 			if (!query_matches_callsite(dp, query))
 				continue;
 
+			if (filter && (dp->flags & filter) != filter)
+				continue;
+
 			nfound++;
 
 			newflags = (dp->flags & mask) | flags;
@@ -396,29 +400,9 @@ static int ddebug_parse_query(char *words[], int nwords,
 	return 0;
 }
 
-/*
- * Parse `str' as a flags specification, format [-+=][p]+.
- * Sets up *maskp and *flagsp to be used when changing the
- * flags fields of matched _ddebug's.  Returns 0 on success
- * or <0 on error.
- */
-static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
-			       unsigned int *maskp)
+static int ddebug_parse_flag_settings(const char *str)
 {
-	unsigned flags = 0;
-	int op = '=', i;
-
-	switch (*str) {
-	case '+':
-	case '-':
-	case '=':
-		op = *str++;
-		break;
-	default:
-		return -EINVAL;
-	}
-	if (verbose)
-		pr_info("op='%c'\n", op);
+	int i, flags = 0;
 
 	for ( ; *str ; ++str) {
 		for (i = ARRAY_SIZE(opt_array) - 1; i >= 0; i--) {
@@ -427,13 +411,49 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 				break;
 			}
 		}
-		if (i < 0)
+		if (i < 0 && *str) {
+			pr_err("unknown flag: %c\n", *str);
 			return -EINVAL;
+		}
 	}
-	if (flags == 0)
+	return flags;
+}
+
+/*
+ * Parse `str' as a flags filter and specification, with format
+ * [ptlmfa]*[-+=][ptlmfa]+.  Sets up *maskp, *flagsp and *filterp to
+ * be used when changing the flags fields of matched _ddebug's.
+ * Returns 0 on success or <0 on error.
+ */
+static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
+			unsigned int *maskp, unsigned int *filterp)
+{
+	int flags, filter;
+	int op = '=';
+	char *s = strpbrk(str, "+-=");
+
+	if (!s) {
+		pr_err("flags spec missing op, expecting [+-=]\n");
 		return -EINVAL;
+	} else {
+		op = *s;
+		*s++ = '\0';
+	}
+	filter = ddebug_parse_flag_settings(str);
+	if (filter < 0) {
+		pr_err("flags_filter=0x%x\n", filter);
+		return -EINVAL;
+	}
+	*filterp = filter;
+
+	flags = ddebug_parse_flag_settings(s);
+	if (flags <= 0) {
+		pr_err("flags=0x%x\n", flags);
+		return -EINVAL;
+	}
 	if (verbose)
-		pr_info("flags=0x%x\n", flags);
+		pr_info(" flags_filter=0x%x\n op='%c'\n flags=0x%x\n",
+			filter, op, flags);
 
 	/* calculate final *flagsp, *maskp according to mask and op */
 	switch (op) {
@@ -526,7 +546,7 @@ static int ddebug_save_pending(struct ddebug_query *query,
 
 static int ddebug_exec_query(char *query_string)
 {
-	unsigned int flags = 0, mask = 0;
+	unsigned int flags = 0, mask = 0, filter = 0;
 	struct ddebug_query query;
 #define MAXWORDS 9
 	int nwords;
@@ -538,12 +558,12 @@ static int ddebug_exec_query(char *query_string)
 		return -EINVAL;
 	if (ddebug_parse_query(words, nwords-1, &query))
 		return -EINVAL;
-	if (ddebug_parse_flags(words[nwords-1], &flags, &mask))
+	if (ddebug_parse_flags(words[nwords-1], &flags, &mask, &filter))
 		return -EINVAL;
 
 	/* actually go and implement the change */
 	mutex_lock(&ddebug_lock);
-	nfound = ddebug_change(&query, flags, mask);
+	nfound = ddebug_change(&query, flags, mask, filter);
 	if (!nfound) {
 		if (flags & _DPRINTK_FLAGS_APPEND)
 			rc = ddebug_save_pending(&query, flags, mask);
@@ -921,8 +941,7 @@ static void apply_pending_queries(struct ddebug_table *dt)
 			pr_info("check: %s <-> %s\n",
 				dt->mod_name, show_pending_query(pq));
 
-		nfound = ddebug_change(&pq->query, pq->flags, pq->mask);
-
+		nfound = ddebug_change(&pq->query, pq->flags, pq->mask, 0);
 		if (nfound) {
 			list_del(&pq->link);
 			kfree(pq);
-- 
1.7.4.1

