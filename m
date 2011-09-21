Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab1IUV43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 17:56:29 -0400
Received: from mail-gw0-f42.google.com ([74.125.83.42]:36106 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab1IUV40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:56:26 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: joe@perches.com, bart.vanassche@gmail.com, greg@kroah.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 16/26] dynamic_debug: save 'a' queries to pending-list for later (re)application.
Date: Wed, 21 Sep 2011 15:55:05 -0600
Message-Id: <1316642115-20029-17-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Save queries with 'a' flag to pending-queries after applying them.
When a module is loaded later, ddebug_add_module() calls
apply_pending_queries() to scan pending_queries list and call
ddebug_change to apply them.

With this change, the loaded module's pr_debug()s are enabled before
its module_init is invoked, allowing use of pr_debug()s during
initialization.

Behavior:
If pending query matches existing one, the existing one is updated.
Pending queries stay on list through rmmod, modprobe cycles.
If the updated query has 0 flags, it is removed.
If pending query has 0 flags, it is discarded, not added.

Patch adds:
'a' flag to dynamic_debug.h
struct pending_query: like ddebug_query, but with storage for match specs.
ddebug_save_pending():
  checks new pending query against existing, to update or remove
  discards new do-nothing pending queries.
  copies ddebug_query, saving match specs from stack.
  adds new pending query to end of pending list (fifo)
apply_pending_queries():
  called from ddebug_add_module()
  (re)applies queries on newly loaded modules.
queries_match() - helper for ddebug_save_pending
ddebug_remove_all_tables() - clear pending-queries here.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 include/linux/dynamic_debug.h |    1 +
 lib/dynamic_debug.c           |  154 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 150 insertions(+), 5 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 12ef233..2c9c476 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -26,6 +26,7 @@ struct _ddebug {
 #define _DPRINTK_FLAGS_INCL_FUNCNAME	(1<<2)
 #define _DPRINTK_FLAGS_INCL_LINENO	(1<<3)
 #define _DPRINTK_FLAGS_INCL_TID		(1<<4)
+#define _DPRINTK_FLAGS_APPEND		(1<<5)  /* add query to pending list */
 #if defined DEBUG
 #define _DPRINTK_FLAGS_DEFAULT _DPRINTK_FLAGS_PRINT
 #else
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 4c8e178..a59d48c 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -53,6 +53,12 @@ struct ddebug_query {
 	unsigned int first_lineno, last_lineno;
 };
 
+struct pending_query {
+	struct list_head link;
+	struct ddebug_query query;
+	unsigned int flags, mask;
+};
+
 struct ddebug_iter {
 	struct ddebug_table *table;
 	unsigned int idx;
@@ -65,6 +71,9 @@ static int verbose = 0;
 #define VERBOSE_PROC_SHOW 11	/* enable per-line msgs on control file reads */
 module_param(verbose, int, 0644);
 
+/* legal but inapplicable queries, save and test against new modules */
+static LIST_HEAD(pending_queries);
+
 /* Return the last part of a pathname */
 static inline const char *basename(const char *path)
 {
@@ -89,6 +98,7 @@ static struct { unsigned flag:8; char opt_char; } opt_array[] = {
 	{ _DPRINTK_FLAGS_INCL_FUNCNAME, 'f' },
 	{ _DPRINTK_FLAGS_INCL_LINENO, 'l' },
 	{ _DPRINTK_FLAGS_INCL_TID, 't' },
+	{ _DPRINTK_FLAGS_APPEND, 'a' },
 };
 
 /* format a string into buf[] which describes the _ddebug's flags */
@@ -125,6 +135,25 @@ do {									\
 			q->first_lineno, q->last_lineno);		\
 } while (0)
 
+#define vpr_info_pq(pq, msg)						\
+do {									\
+	struct ddebug_query *q = &pq->query;				\
+	if (verbose)							\
+		/* trim last char off format print */			\
+		pr_info("%s: func=\"%s\" file=\"%s\" "			\
+			"module=\"%s\" format=\"%.*s\" "		\
+			"lineno=%u-%u "					\
+			"flags=0x%x mask=0x%x",				\
+			msg,						\
+			q->function ? q->function : "",			\
+			q->filename ? q->filename : "",			\
+			q->module ? q->module : "",			\
+			(int)(q->format ? strlen(q->format) - 1 : 0),	\
+			q->format ? q->format : "",			\
+			q->first_lineno, q->last_lineno,		\
+			pq->flags, pq->mask);				\
+} while (0)
+
 static bool query_matches_callsite(struct _ddebug *dp,
 				const struct ddebug_query *query)
 {
@@ -159,7 +188,7 @@ static bool query_matches_callsite(struct _ddebug *dp,
  * the user which ddebug's were changed, or whether none
  * were matched.  Called with ddebug_lock held.
  */
-static void ddebug_change(const struct ddebug_query *query,
+static int ddebug_change(const struct ddebug_query *query,
 			unsigned int flags, unsigned int mask)
 {
 	int i;
@@ -196,8 +225,7 @@ static void ddebug_change(const struct ddebug_query *query,
 							sizeof(flagbuf)));
 		}
 	}
-	if (!nfound && verbose)
-		pr_info("no matches for query\n");
+	return nfound;
 }
 
 /*
@@ -435,6 +463,95 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 	return 0;
 }
 
+/* check if new query exactly matches existing one */
+static bool queries_match(struct ddebug_query *qnew, struct ddebug_query *qcur)
+{
+	if (!qnew->module != !qcur->module ||
+		!qnew->filename != !qcur->filename ||
+		!qnew->function != !qcur->function ||
+		!qnew->format != !qcur->format)
+		return false;  /* a match-spec set/unset state differs */
+
+	if (qnew->last_lineno != qcur->last_lineno ||
+		qnew->first_lineno != qcur->first_lineno)
+		return false;
+
+	if ((qnew->module && strcmp(qnew->module, qcur->module)) ||
+		(qnew->filename && strcmp(qnew->filename, qcur->filename)) ||
+		(qnew->function && strcmp(qnew->function, qcur->function)) ||
+		(qnew->format && strcmp(qnew->format, qcur->format)))
+		return false;
+
+	return true;
+}
+
+static void pqfree(struct pending_query *pq)
+{
+	if (pq->query.module)
+		kfree(pq->query.module);
+	if (pq->query.function)
+		kfree(pq->query.function);
+	if (pq->query.filename)
+		kfree(pq->query.filename);
+	if (pq->query.format)
+		kfree(pq->query.format);
+	kfree(pq);
+}
+
+/* copy query off stack, save flags & mask, and store or update in
+   pending-list.  Called with ddebug_lock held.
+ */
+static int ddebug_save_pending(struct ddebug_query *query,
+				unsigned int flags, unsigned int mask)
+{
+	struct pending_query *pq, *pqnext;
+
+	list_for_each_entry_safe(pq, pqnext, &pending_queries, link) {
+		if (queries_match(query, &pq->query)) {
+			/* query already in list, update flags */
+			if (pq->flags != flags)
+				pq->flags = flags;
+			if (pq->mask != mask)
+				pq->mask = mask;
+			vpr_info_pq(pq, "already pending, updated it");
+			return 0;
+		}
+	}
+	if (!flags) {
+		vpr_info_pq(pq, "pending query has 0 flags, discarding");
+		return 0;
+	}
+	vpr_info_dq(query, "add to pending");
+
+	pq = kzalloc(sizeof(struct pending_query), GFP_KERNEL);
+	if (pq == NULL)
+		return -ENOMEM;
+
+	/* copy non-null match-specs into allocd mem, update pointers */
+	if (query->module)
+		if (!(pq->query.module = kstrdup(query->module, GFP_KERNEL)))
+			return -ENOMEM;
+	if (query->function)
+		if (!(pq->query.function = kstrdup(query->function, GFP_KERNEL)))
+			return -ENOMEM;
+	if (query->filename)
+		if (!(pq->query.filename = kstrdup(query->filename, GFP_KERNEL)))
+			return -ENOMEM;
+	if (query->format)
+		if (!(pq->query.format = kstrdup(query->format, GFP_KERNEL)))
+			return -ENOMEM;
+
+	pq->flags = flags;
+	pq->mask = mask;
+
+	list_add_tail(&pq->link, &pending_queries);
+
+	if (verbose)
+		pr_info("query saved as pending, in %ld bytes\n",
+			sizeof(struct pending_query));
+	return 0;
+}
+
 static int ddebug_exec_query(char *query_string)
 {
 	unsigned int flags = 0, mask = 0;
@@ -442,6 +559,7 @@ static int ddebug_exec_query(char *query_string)
 #define MAXWORDS 9
 	int nwords;
 	char *words[MAXWORDS];
+	int nfound, rc = 0;
 
 	nwords = ddebug_tokenize(query_string, words, MAXWORDS);
 	if (nwords <= 0)
@@ -452,8 +570,13 @@ static int ddebug_exec_query(char *query_string)
 		return -EINVAL;
 
 	/* actually go and implement the change */
-	ddebug_change(&query, flags, mask);
-	return 0;
+	nfound = ddebug_change(&query, flags, mask);
+	vpr_info_dq((&query), (nfound) ? "applied" : "no-match");
+
+	if (flags & _DPRINTK_FLAGS_APPEND)
+		rc = ddebug_save_pending(&query, flags, mask);
+
+	return rc;
 }
 
 /* handle multiple queries, continue on error, return last error */
@@ -811,6 +934,19 @@ static const struct file_operations ddebug_proc_fops = {
 	.write = ddebug_proc_write
 };
 
+/* apply matching queries in pending-queries list */
+static void apply_pending_queries(struct ddebug_table *dt)
+{
+	struct pending_query *pq, *pqnext;
+	int nfound;
+
+	list_for_each_entry_safe(pq, pqnext, &pending_queries, link) {
+		nfound = ddebug_change(&pq->query, pq->flags, pq->mask);
+		vpr_info_pq(pq, (nfound) ?
+			"applied pending" : "no-match on pending");
+	}
+}
+
 /*
  * Allocate a new ddebug_table for the given module
  * and add it to the global list.
@@ -835,6 +971,7 @@ int ddebug_add_module(struct _ddebug *tab, unsigned int n,
 
 	mutex_lock(&ddebug_lock);
 	list_add_tail(&dt->link, &ddebug_tables);
+	apply_pending_queries(dt);
 	mutex_unlock(&ddebug_lock);
 
 	if (verbose)
@@ -876,6 +1013,8 @@ EXPORT_SYMBOL_GPL(ddebug_remove_module);
 
 static void ddebug_remove_all_tables(void)
 {
+	struct pending_query *pq, *pqnext;
+
 	mutex_lock(&ddebug_lock);
 	while (!list_empty(&ddebug_tables)) {
 		struct ddebug_table *dt = list_entry(ddebug_tables.next,
@@ -883,6 +1022,11 @@ static void ddebug_remove_all_tables(void)
 						      link);
 		ddebug_table_free(dt);
 	}
+	list_for_each_entry_safe(pq, pqnext, &pending_queries, link) {
+		vpr_info_pq(pq, "delete pending");
+		list_del_init(&pq->link);
+		pqfree(pq);
+	}
 	mutex_unlock(&ddebug_lock);
 }
 
-- 
1.7.4.4

