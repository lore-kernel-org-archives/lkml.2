Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab1GKHtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 03:49:32 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33546 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964808Ab1GKHrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 03:47:37 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, bvanassche@acm.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 13/21] dynamic_debug: require 'a' flag to explicitly mark pending queries
Date: Mon, 11 Jul 2011 01:46:48 -0600
Message-Id: <1310370416-6322-14-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Require that user mark pending queries explicitly, otherwise warn
that they do not apply.  Note that pending rules are still applied
by default, and are only added to pending-list if they do not apply,
and bear the flag.

Also test that query hasnt already been added to pending-list,
if it has (according to queries_match), just update the found query.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   52 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index bee1376..0faac83 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -91,6 +91,7 @@ static struct { unsigned flag:8; char opt_char; } opt_array[] = {
 	{ _DPRINTK_FLAGS_INCL_FUNCNAME, 'f' },
 	{ _DPRINTK_FLAGS_INCL_LINENO, 'l' },
 	{ _DPRINTK_FLAGS_INCL_TID, 't' },
+	{ _DPRINTK_FLAGS_APPEND, 'a' },
 };
 
 /* format a string into buf[] which describes the _ddebug's flags */
@@ -454,12 +455,47 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 	return 0;
 }
 
-/* copy query off stack, save flags & mask, and store in pending-list */
+static int queries_match(struct ddebug_query *q1, struct ddebug_query *q2)
+{
+	if (!q1->module ^ !q2->module ||
+		!q1->filename ^ !q2->filename ||
+		!q1->function ^ !q2->function ||
+		!q1->format ^ !q2->format)
+		return 0;  /* a match-spec set/unset state differs */
+
+	if (q1->last_lineno != q2->last_lineno ||
+		q1->first_lineno != q2->first_lineno)
+		return 0;
+
+	if ((q1->module && strcmp(q1->module, q2->module)) ||
+		(q1->filename && strcmp(q1->filename, q2->filename)) ||
+		(q1->function && strcmp(q1->function, q2->function)) ||
+		(q1->format && strcmp(q1->format, q2->format)))
+		return 0;
+	return 1;
+}
+
+/* copy query off stack, save flags & mask, and store in pending-list,
+   after checking that query isnt already there
+ */
 static int ddebug_save_pending(struct ddebug_query *query,
 				unsigned int flags, unsigned int mask)
 {
-	struct pending_query *pq;
+	struct pending_query *pq, *pqnext;
 
+	list_for_each_entry_safe(pq, pqnext, &pending_queries, link) {
+		if (queries_match(query, &pq->query)) {
+			/* query already in list, update flags */
+			if (pq->flags != flags)
+				pq->flags = flags;
+			if (pq->mask != mask)
+				pq->mask = mask;
+			if (verbose)
+				pr_info("already pending, updated it: %s\n",
+					show_pending_query(pq));
+			return 0;
+		}
+	}
 	if (verbose)
 		pr_info("add to pending: %s\n", show_ddebug_query(query));
 
@@ -511,9 +547,13 @@ static int ddebug_exec_query(char *query_string)
 	nfound = ddebug_change(&query, flags, mask);
 
 	pr_info("nfound %d on %s\n", nfound, show_ddebug_query(&query));
-	if (!nfound)
-		return ddebug_save_pending(&query, flags, mask);
-
+	if (!nfound) {
+		if (flags & _DPRINTK_FLAGS_APPEND)
+			return ddebug_save_pending(&query, flags, mask);
+		else
+			pr_warn("no match on: %s\n",
+				show_ddebug_query(&query));
+	}
 	return 0;
 }
 
-- 
1.7.4.1

