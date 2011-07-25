Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab1GYVqG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:46:06 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:39747 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab1GYVnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:43:40 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: bvanassche@acm.org, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 16/25] dynamic_debug: require 'a' flag to explicitly mark pending queries
Date: Mon, 25 Jul 2011 15:42:41 -0600
Message-Id: <1311630170-26057-17-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Require that user mark pending queries explicitly, otherwise warn
that they do not apply.  Note that pending rules are still applied
by default, and are only added to pending-list if they do not apply,
and bear the flag.

Add queries_match() to test newly submitted pending query against
those already on the pending list, and either update the flags
or add the new query

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   42 ++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 0c25ba0..05773c8 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -91,6 +91,7 @@ static struct { unsigned flag:8; char opt_char; } opt_array[] = {
 	{ _DPRINTK_FLAGS_INCL_FUNCNAME, 'f' },
 	{ _DPRINTK_FLAGS_INCL_LINENO, 'l' },
 	{ _DPRINTK_FLAGS_INCL_TID, 't' },
+	{ _DPRINTK_FLAGS_APPEND, 'a' },
 };
 
 /* format a string into buf[] which describes the _ddebug's flags */
@@ -458,13 +459,50 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 	return 0;
 }
 
-/* copy query off stack, save flags & mask, and store in pending-list */
+static bool queries_match(struct ddebug_query *q1, struct ddebug_query *q2)
+{
+	if (!q1->module ^ !q2->module ||
+		!q1->filename ^ !q2->filename ||
+		!q1->function ^ !q2->function ||
+		!q1->format ^ !q2->format)
+		return false;  /* a match-spec set/unset state differs */
+
+	if (q1->last_lineno != q2->last_lineno ||
+		q1->first_lineno != q2->first_lineno)
+		return false;
+
+	if ((q1->module && strcmp(q1->module, q2->module)) ||
+		(q1->filename && strcmp(q1->filename, q2->filename)) ||
+		(q1->function && strcmp(q1->function, q2->function)) ||
+		(q1->format && strcmp(q1->format, q2->format)))
+		return false;
+
+	return true;
+}
+
+/* copy query off stack, save flags & mask, and store or update in
+   pending-list.  Called with ddebug_lock held.
+ */
 static int ddebug_save_pending(struct ddebug_query *query,
 				unsigned int flags, unsigned int mask)
 {
-	struct pending_query *pq;
+	struct pending_query *pq, *pqnext;
 	char *qstr;
 
+	list_for_each_entry_safe(pq, pqnext, &pending_queries, link) {
+		if (queries_match(query, &pq->query)) {
+			/* query already in list, update flags */
+			if (pq->flags != flags)
+				pq->flags = flags;
+			if (pq->mask != mask)
+				pq->mask = mask;
+			qstr = show_pending_query(pq);
+			pr_debug("already pending, updated it: %s\n", qstr);
+			kfree(qstr);
+			return 0;
+		}
+	}
+
 	qstr = show_ddebug_query(query);
 	pr_debug("add to pending: %s\n", qstr);
 	kfree(qstr);
-- 
1.7.4.1

