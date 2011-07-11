Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964834Ab1GKHrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 03:47:41 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54806 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964822Ab1GKHrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 03:47:39 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, bvanassche@acm.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 14/21] dynamic_debug: hoist locking in ddebug_change to callers
Date: Mon, 11 Jul 2011 01:46:49 -0600
Message-Id: <1310370416-6322-15-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hoist locking out of ddebug_change(), into ddebug_exec_query(),
and fix return from inside the critical section.
Remove locking in ddebug_save_pending(), since its also
protected by ddebug_exec_query().

ddebug_add_module() also calls ddebug_change() via apply_pending_queries(),
move that call inside the critical section protecting list_add_tail()

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   37 ++++++++++++++-----------------------
 1 files changed, 14 insertions(+), 23 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 0faac83..d115f52 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -168,7 +168,7 @@ static int query_matches_callsite(struct _ddebug *dp,
  * Search the tables for _ddebug's which match the given
  * `query' and apply the `flags' and `mask' to them.  Tells
  * the user which ddebug's were changed, or whether none
- * were matched.
+ * were matched.  Called with ddebug_lock held.
  */
 static int ddebug_change(const struct ddebug_query *query,
 			unsigned int flags, unsigned int mask)
@@ -180,7 +180,6 @@ static int ddebug_change(const struct ddebug_query *query,
 	char flagbuf[8];
 
 	/* search for matching ddebugs */
-	mutex_lock(&ddebug_lock);
 	list_for_each_entry(dt, &ddebug_tables, link) {
 
 		/* match against the module name */
@@ -212,8 +211,6 @@ static int ddebug_change(const struct ddebug_query *query,
 							sizeof(flagbuf)));
 		}
 	}
-	mutex_unlock(&ddebug_lock);
-
 	return nfound;
 }
 
@@ -475,8 +472,8 @@ static int queries_match(struct ddebug_query *q1, struct ddebug_query *q2)
 	return 1;
 }
 
-/* copy query off stack, save flags & mask, and store in pending-list,
-   after checking that query isnt already there
+/* copy query off stack, save flags & mask, and store or update in
+   pending-list.  Called with ddebug_lock held.
  */
 static int ddebug_save_pending(struct ddebug_query *query,
 				unsigned int flags, unsigned int mask)
@@ -499,7 +496,6 @@ static int ddebug_save_pending(struct ddebug_query *query,
 	if (verbose)
 		pr_info("add to pending: %s\n", show_ddebug_query(query));
 
-	pending_ct++;
 	pq = kzalloc(sizeof(struct pending_query), GFP_KERNEL);
 	if (pq == NULL)
 		return -ENOMEM;
@@ -517,9 +513,8 @@ static int ddebug_save_pending(struct ddebug_query *query,
 	pq->flags = flags;
 	pq->mask = mask;
 
-	mutex_lock(&ddebug_lock);
 	list_add(&pq->link, &pending_queries);
-	mutex_unlock(&ddebug_lock);
+	pending_ct++;
 
 	if (verbose)
 		pr_info("query saved as pending %d\n", pending_ct);
@@ -533,7 +528,7 @@ static int ddebug_exec_query(char *query_string)
 #define MAXWORDS 9
 	int nwords;
 	char *words[MAXWORDS];
-	int nfound;
+	int nfound, rc = 0;
 
 	nwords = ddebug_tokenize(query_string, words, MAXWORDS);
 	if (nwords <= 0)
@@ -544,17 +539,18 @@ static int ddebug_exec_query(char *query_string)
 		return -EINVAL;
 
 	/* actually go and implement the change */
+	mutex_lock(&ddebug_lock);
 	nfound = ddebug_change(&query, flags, mask);
-
-	pr_info("nfound %d on %s\n", nfound, show_ddebug_query(&query));
 	if (!nfound) {
 		if (flags & _DPRINTK_FLAGS_APPEND)
-			return ddebug_save_pending(&query, flags, mask);
+			rc = ddebug_save_pending(&query, flags, mask);
 		else
 			pr_warn("no match on: %s\n",
 				show_ddebug_query(&query));
 	}
-	return 0;
+	mutex_unlock(&ddebug_lock);
+	pr_info("nfound %d on %s\n", nfound, show_ddebug_query(&query));
+	return rc;
 }
 
 /* handle multiple queries, continue on error, return last error */
@@ -904,7 +900,7 @@ static const struct file_operations ddebug_proc_fops = {
 	.write = ddebug_proc_write
 };
 
-/* apply matching queries in pending-queries list */
+/* apply matching queries in pending-queries list. Called with lock held */
 static void apply_pending_queries(struct ddebug_table *dt)
 {
 	struct pending_query *pq, *pqnext;
@@ -914,7 +910,6 @@ static void apply_pending_queries(struct ddebug_table *dt)
 		pr_info("pending_ct: %d\n", pending_ct);
 
 	list_for_each_entry_safe(pq, pqnext, &pending_queries, link) {
-
 		if (verbose)
 			pr_info("check: %s <-> %s\n",
 				dt->mod_name, show_pending_query(pq));
@@ -922,15 +917,12 @@ static void apply_pending_queries(struct ddebug_table *dt)
 		nfound = ddebug_change(&pq->query, pq->flags, pq->mask);
 
 		if (nfound) {
-			mutex_lock(&ddebug_lock);
 			list_del(&pq->link);
-			mutex_unlock(&ddebug_lock);
 			kfree(pq);
 			pending_ct--;
 		} else if (verbose)
 			pr_info("no-match: %s\n", show_pending_query(pq));
 	}
-
 }
 /*
  * Allocate a new ddebug_table for the given module
@@ -954,14 +946,13 @@ int ddebug_add_module(struct _ddebug *tab, unsigned int n,
 	dt->num_ddebugs = n;
 	dt->ddebugs = tab;
 
-	mutex_lock(&ddebug_lock);
-	list_add_tail(&dt->link, &ddebug_tables);
-	mutex_unlock(&ddebug_lock);
-
 	if (verbose)
 		pr_info("%u debug prints in module %s\n", n, dt->mod_name);
 
+	mutex_lock(&ddebug_lock);
+	list_add_tail(&dt->link, &ddebug_tables);
 	apply_pending_queries(dt);
+	mutex_unlock(&ddebug_lock);
 
 	return 0;
 }
-- 
1.7.4.1

