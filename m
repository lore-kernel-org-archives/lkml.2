Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab1GYVnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:43:49 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:63998 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab1GYVnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:43:42 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: bvanassche@acm.org, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 17/25] dynamic_debug: hoist locking in ddebug_change to callers
Date: Mon, 25 Jul 2011 15:42:42 -0600
Message-Id: <1311630170-26057-18-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hoist locking out of ddebug_change() and ddebug_save_pending()
into ddebug_exec_query().

ddebug_add_module() also calls ddebug_change() via apply_pending_queries(),
move that call inside the critical section protecting list_add_tail()

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 05773c8..396ffb4 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -175,7 +175,7 @@ static bool query_matches_callsite(struct _ddebug *dp,
  * Search the tables for _ddebug's which match the given
  * `query' and apply the `flags' and `mask' to them.  Tells
  * the user which ddebug's were changed, or whether none
- * were matched.
+ * were matched.  Called with ddebug_lock held.
  */
 static int ddebug_change(const struct ddebug_query *query,
 			unsigned int flags, unsigned int mask)
@@ -187,7 +187,6 @@ static int ddebug_change(const struct ddebug_query *query,
 	char flagbuf[8];
 
 	/* search for matching ddebugs */
-	mutex_lock(&ddebug_lock);
 	list_for_each_entry(dt, &ddebug_tables, link) {
 
 		/* match against the module name */
@@ -218,8 +217,6 @@ static int ddebug_change(const struct ddebug_query *query,
 						sizeof(flagbuf)));
 		}
 	}
-	mutex_unlock(&ddebug_lock);
-
 	return nfound;
 }
 
@@ -531,10 +528,8 @@ static int ddebug_save_pending(struct ddebug_query *query,
 	pq->flags = flags;
 	pq->mask = mask;
 
-	mutex_lock(&ddebug_lock);
 	list_add(&pq->link, &pending_queries);
 	pending_ct++;
-	mutex_unlock(&ddebug_lock);
 
 	pr_debug("query saved as pending %d\n", pending_ct);
 	return 0;
@@ -558,6 +553,7 @@ static int ddebug_exec_query(char *query_string)
 		return -EINVAL;
 
 	/* actually go and implement the change */
+	mutex_lock(&ddebug_lock);
 	nfound = ddebug_change(&query, flags, mask);
 	qstr = show_ddebug_query(&query);
 	pr_debug("nfound %d on %s\n", nfound, qstr);
@@ -568,6 +564,7 @@ static int ddebug_exec_query(char *query_string)
 			pr_warn("no match on: %s\n", qstr);
 	}
 	kfree(qstr);
+	mutex_unlock(&ddebug_lock);
 	return rc;
 }
 
@@ -910,7 +907,7 @@ static const struct file_operations ddebug_proc_fops = {
 	.write = ddebug_proc_write
 };
 
-/* apply matching queries in pending-queries list */
+/* apply matching queries in pending-queries list. Called with lock held */
 static void apply_pending_queries(struct ddebug_table *dt)
 {
 	struct pending_query *pq, *pqnext;
-- 
1.7.4.1

