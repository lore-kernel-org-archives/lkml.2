Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab1IUV4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 17:56:39 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33832 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab1IUV4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:56:34 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: joe@perches.com, bart.vanassche@gmail.com, greg@kroah.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 19/26] dynamic_debug: add flags filtering to flags spec
Date: Wed, 21 Sep 2011 15:55:08 -0600
Message-Id: <1316642115-20029-20-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Change definition of flags spec to [pmflta_]*[-+=][pmflta_]*
The flags preceding the op are optional filter-flags; if provided,
they add an additional constraint to call-site matching done
by ddebug_change; call-sites which do not have all specified flags
are skipped (additional flags are allowed).

This allows query/rules like "p+t" to turn on TID logging for all
currently enabled call-sites, while leaving the others alone.
This also allows rules like "a-a" to select pending queries and
remove them from the list.

Also allow 0 flags byte, so that active rules can be completely
reset by writing "p=" or "p=_".

Patch factors flag-scanning into ddebug_parse_flag_settings(),
and uses it for both filter-flags and new flags, and adds pr_err()
where useful.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   85 +++++++++++++++++++++++++++++++--------------------
 1 files changed, 52 insertions(+), 33 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 29dbf69..3c9244d 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -191,7 +191,8 @@ static bool query_matches_callsite(struct _ddebug *dp,
  * were matched.  Called with ddebug_lock held.
  */
 static int ddebug_change(const struct ddebug_query *query,
-			unsigned int flags, unsigned int mask)
+			unsigned int flags, unsigned int mask,
+			unsigned int filter)
 {
 	int i;
 	struct ddebug_table *dt;
@@ -213,6 +214,9 @@ static int ddebug_change(const struct ddebug_query *query,
 			if (!query_matches_callsite(dp, query))
 				continue;
 
+			if (filter && (dp->flags & filter) != filter)
+				continue;
+
 			nfound++;
 
 			newflags = (dp->flags & mask) | flags;
@@ -406,29 +410,9 @@ static int ddebug_parse_query(char *words[], int nwords,
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
@@ -437,13 +421,46 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
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
+ * [pmflta_]*[-+=][pmflta_]+.  Sets up *maskp, *flagsp and *filterp to
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
-	if (verbose)
-		pr_info("flags=0x%x\n", flags);
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
@@ -461,7 +478,9 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 		break;
 	}
 	if (verbose)
-		pr_info("*flagsp=0x%x *maskp=0x%x\n", *flagsp, *maskp);
+		pr_info("filter=0x%x op='%c' flags=0x%x *flagsp=0x%x *maskp=0x%x\n",
+			filter, op, flags, *flagsp, *maskp);
+
 	return 0;
 }
 
@@ -563,7 +582,7 @@ static int ddebug_save_pending(struct ddebug_query *query,
 
 static int ddebug_exec_query(char *query_string)
 {
-	unsigned int flags = 0, mask = 0;
+	unsigned int flags = 0, mask = 0, filter = 0;
 	struct ddebug_query query;
 #define MAXWORDS 9
 	int nwords;
@@ -575,14 +594,14 @@ static int ddebug_exec_query(char *query_string)
 		return -EINVAL;
 	if (ddebug_parse_query(words, nwords-1, &query))
 		return -EINVAL;
-	if (ddebug_parse_flags(words[nwords-1], &flags, &mask))
+	if (ddebug_parse_flags(words[nwords-1], &flags, &mask, &filter))
 		return -EINVAL;
 
 	/* actually go and implement the change */
-	nfound = ddebug_change(&query, flags, mask);
+	nfound = ddebug_change(&query, flags, mask, filter);
 	vpr_info_dq((&query), (nfound) ? "applied" : "no-match");
 
-	if (flags & _DPRINTK_FLAGS_APPEND)
+	if (flags & _DPRINTK_FLAGS_APPEND || filter & _DPRINTK_FLAGS_APPEND)
 		rc = ddebug_save_pending(&query, flags, mask);
 
 	return rc;
@@ -950,7 +969,7 @@ static void apply_pending_queries(struct ddebug_table *dt)
 	int nfound;
 
 	list_for_each_entry_safe(pq, pqnext, &pending_queries, link) {
-		nfound = ddebug_change(&pq->query, pq->flags, pq->mask);
+		nfound = ddebug_change(&pq->query, pq->flags, pq->mask, 0);
 		vpr_info_pq(pq, (nfound) ?
 			"applied pending" : "no-match on pending");
 	}
-- 
1.7.4.4

