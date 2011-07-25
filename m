Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab1GYVnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:43:55 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:39747 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab1GYVnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:43:45 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: bvanassche@acm.org, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 19/25] dynamic_debug: add flags filtering to flags spec
Date: Mon, 25 Jul 2011 15:42:44 -0600
Message-Id: <1311630170-26057-20-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change definition of flags spec to [pmflta_]*[-+=][pmflta_]*
The flags preceding the op are optional filter-flags; if provided,
they add an additional constraint to call-site matching done
by ddebug_change; call-sites which do not have all specified flags
are skipped (additional flags are allowed).

This allows query/rules like "p+t" to turn on TID logging for all
currently enabled call-sites, while leaving the others alone.
This will also allow filtering on pending rules (with 'a' flag),
which will support removal of pending rules.

Also allow 0 flags byte, so that active rules can be completely
reset by writing "p=" or "p=_".

Patch factors flag-scanning into ddebug_parse_flag_settings(),
and uses it for both filter-flags and new flags, and adds pr_err()
where useful.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   81 ++++++++++++++++++++++++++++++++-------------------
 1 files changed, 51 insertions(+), 30 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 37f9748..275cf30 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -180,7 +180,8 @@ static bool query_matches_callsite(struct _ddebug *dp,
  * were matched.  Called with ddebug_lock held.
  */
 static int ddebug_change(const struct ddebug_query *query,
-			unsigned int flags, unsigned int mask)
+			unsigned int flags, unsigned int mask,
+			unsigned int filter)
 {
 	int i;
 	struct ddebug_table *dt;
@@ -202,6 +203,9 @@ static int ddebug_change(const struct ddebug_query *query,
 			if (!query_matches_callsite(dp, query))
 				continue;
 
+			if (filter && (dp->flags & filter) != filter)
+				continue;
+
 			nfound++;
 
 			newflags = (dp->flags & mask) | flags;
@@ -402,28 +406,9 @@ static int ddebug_parse_query(char *words[], int nwords,
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
-	pr_debug("op='%c'\n", op);
+	int i, flags = 0;
 
 	for ( ; *str ; ++str) {
 		for (i = ARRAY_SIZE(opt_array) - 1; i >= 0; i--) {
@@ -432,12 +417,46 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
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
-	pr_debug("flags=0x%x\n", flags);
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
+	if (flags < 0) {
+		pr_err("flags=0x%x\n", flags);
+		return -EINVAL;
+	}
 
 	/* calculate final *flagsp, *maskp according to mask and op */
 	switch (op) {
@@ -454,7 +473,9 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 		*flagsp = 0;
 		break;
 	}
-	pr_debug("*flagsp=0x%x *maskp=0x%x\n", *flagsp, *maskp);
+	pr_debug("filter=0x%x op='%c' flags=0x%x *flagsp=0x%x *maskp=0x%x\n",
+		filter, op, flags, *flagsp, *maskp);
+
 	return 0;
 }
 
@@ -539,7 +560,7 @@ static int ddebug_save_pending(struct ddebug_query *query,
 
 static int ddebug_exec_query(char *query_string)
 {
-	unsigned int flags = 0, mask = 0;
+	unsigned int flags = 0, mask = 0, filter = 0;
 	struct ddebug_query query;
 #define MAXWORDS 9
 	int nwords;
@@ -551,12 +572,12 @@ static int ddebug_exec_query(char *query_string)
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
 	qstr = show_ddebug_query(&query);
 	pr_debug("nfound %d on %s\n", nfound, qstr);
 	if (!nfound) {
@@ -917,7 +938,7 @@ static void apply_pending_queries(struct ddebug_table *dt)
 	char *qstr;
 
 	list_for_each_entry_safe(pq, pqnext, &pending_queries, link) {
-		nfound = ddebug_change(&pq->query, pq->flags, pq->mask);
+		nfound = ddebug_change(&pq->query, pq->flags, pq->mask, 0);
 		qstr = show_pending_query(pq);
 		pr_debug("%s: %s\n", (nfound) ? "applied" : "no-match", qstr);
 		kfree(qstr);
-- 
1.7.4.1

