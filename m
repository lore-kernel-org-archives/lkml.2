Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab1GYVrB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:47:01 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:39747 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab1GYVne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:43:34 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: bvanassche@acm.org, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 12/25] dynamic_debug: save non-matching queries to pending-list for later application.
Date: Mon, 25 Jul 2011 15:42:37 -0600
Message-Id: <1311630170-26057-13-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a query/rule doesnt match against current callsites, call
save_pending(new function) to copy the query off the stack, into
a (new) struct pending_query, and add to pending_queries (new) list.
Alter ddebug_change to return number of matches found for query/rule.

Patch adds: /sys/module/dynamic_debug/parameters/
  verbose - rw, added previously, here for completeness
  pending_ct - ro, shows current count of pending queries

With this and previous patches, queries submitted (on the boot-line
for example) which do not match (because module is not built-in,
and thus not present yet) are added to pending_queries.

Clear pending list in ddebug_remove_all_tables().  Note that latter is
currently only used for init-error path, its not called during cleanup.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |  108 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 101 insertions(+), 7 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 5774a6f..4135bf5 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -53,6 +53,16 @@ struct ddebug_query {
 	unsigned int first_lineno, last_lineno;
 };
 
+struct pending_query {
+	struct list_head link;
+	struct ddebug_query query;
+	char filename[100];
+	char module[30];
+	char function[50];
+	char format[200];
+	unsigned int flags, mask;
+};
+
 struct ddebug_iter {
 	struct ddebug_table *table;
 	unsigned int idx;
@@ -63,6 +73,11 @@ static LIST_HEAD(ddebug_tables);
 static int verbose = 0;
 module_param(verbose, int, 0644);
 
+/* legal but inapplicable queries, save and test against new modules */
+static LIST_HEAD(pending_queries);
+static int pending_ct;
+module_param(pending_ct, int, 0444);
+
 /* Return the last part of a pathname */
 static inline const char *basename(const char *path)
 {
@@ -111,14 +126,31 @@ static char *show_ddebug_query(const struct ddebug_query *q)
 	return p;
 }
 
+static char *show_pending_query(struct pending_query *pq)
+{
+	struct ddebug_query *q = &pq->query;
+
+	char *p = kasprintf(GFP_KERNEL,
+			"func=\"%s\" file=\"%s\" "
+			"module=\"%s\" format=\"%s\" lineno=%u-%u"
+			" flags=0x%x mask=0x%x",
+			q->function ? q->function : "",
+			q->filename ? q->filename : "",
+			q->module ? q->module : "",
+			q->format ? q->format : "",
+			q->first_lineno, q->last_lineno,
+			pq->flags, pq->mask);
+	return p;
+}
+
 /*
  * Search the tables for _ddebug's which match the given
  * `query' and apply the `flags' and `mask' to them.  Tells
  * the user which ddebug's were changed, or whether none
  * were matched.
  */
-static void ddebug_change(const struct ddebug_query *query,
-			   unsigned int flags, unsigned int mask)
+static int ddebug_change(const struct ddebug_query *query,
+			unsigned int flags, unsigned int mask)
 {
 	int i;
 	struct ddebug_table *dt;
@@ -181,8 +213,7 @@ static void ddebug_change(const struct ddebug_query *query,
 	}
 	mutex_unlock(&ddebug_lock);
 
-	if (!nfound)
-		pr_debug("no matches for query\n");
+	return nfound;
 }
 
 /*
@@ -421,13 +452,58 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 	return 0;
 }
 
+/* copy query off stack, save flags & mask, and store in pending-list */
+static int ddebug_save_pending(struct ddebug_query *query,
+				unsigned int flags, unsigned int mask)
+{
+	struct pending_query *pq;
+	char *qstr;
+
+	qstr = show_ddebug_query(query);
+	pr_debug("add to pending: %s\n", qstr);
+	kfree(qstr);
+
+	pq = kzalloc(sizeof(struct pending_query), GFP_KERNEL);
+	if (pq == NULL)
+		return -ENOMEM;
+
+	/* copy non-null match-specs into allocd mem, update pointers */
+	if (query->module) {
+		strlcpy(pq->module, query->module, sizeof(pq->module));
+		pq->query.module = pq->module;
+	}
+	if (query->function) {
+		strlcpy(pq->function, query->function, sizeof(pq->function));
+		pq->query.function = pq->function;
+	}
+	if (query->filename) {
+		strlcpy(pq->filename, query->filename, sizeof(pq->filename));
+		pq->query.filename = pq->filename;
+	}
+	if (query->format) {
+		strlcpy(pq->format, query->format, sizeof(pq->format));
+		pq->query.format = pq->format;
+	}
+	pq->flags = flags;
+	pq->mask = mask;
+
+	mutex_lock(&ddebug_lock);
+	list_add(&pq->link, &pending_queries);
+	pending_ct++;
+	mutex_unlock(&ddebug_lock);
+
+	pr_debug("query saved as pending %d\n", pending_ct);
+	return 0;
+}
+
 static int ddebug_exec_query(char *query_string)
 {
 	unsigned int flags = 0, mask = 0;
 	struct ddebug_query query;
 #define MAXWORDS 9
 	int nwords;
-	char *words[MAXWORDS];
+	char *words[MAXWORDS], *qstr;
+	int nfound, rc = 0;
 
 	nwords = ddebug_tokenize(query_string, words, MAXWORDS);
 	if (nwords <= 0)
@@ -438,8 +514,17 @@ static int ddebug_exec_query(char *query_string)
 		return -EINVAL;
 
 	/* actually go and implement the change */
-	ddebug_change(&query, flags, mask);
-	return 0;
+	nfound = ddebug_change(&query, flags, mask);
+	qstr = show_ddebug_query(&query);
+	pr_debug("nfound %d on %s\n", nfound, qstr);
+	if (!nfound) {
+		if (flags & _DPRINTK_FLAGS_APPEND)
+			rc = ddebug_save_pending(&query, flags, mask);
+		else
+			pr_warn("no match on: %s\n", qstr);
+	}
+	kfree(qstr);
+	return rc;
 }
 
 /* handle multiple queries, continue on error, return last error */
@@ -845,6 +930,8 @@ EXPORT_SYMBOL_GPL(ddebug_remove_module);
 
 static void ddebug_remove_all_tables(void)
 {
+	struct pending_query *pq, *pqnext;
+
 	mutex_lock(&ddebug_lock);
 	while (!list_empty(&ddebug_tables)) {
 		struct ddebug_table *dt = list_entry(ddebug_tables.next,
@@ -852,6 +939,13 @@ static void ddebug_remove_all_tables(void)
 						      link);
 		ddebug_table_free(dt);
 	}
+	list_for_each_entry_safe(pq, pqnext, &pending_queries, link) {
+		char *qstr = show_pending_query(pq);
+		pr_debug("delete pending: %s\n", qstr);
+		kfree(qstr);
+		list_del_init(&pq->link);
+		kfree(pq);
+	}
 	mutex_unlock(&ddebug_lock);
 }
 
-- 
1.7.4.1

