Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964844Ab1GKHry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 03:47:54 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33546 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289Ab1GKHrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 03:47:51 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, bvanassche@acm.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 21/21] dynamic_debug: delete pending queries
Date: Mon, 11 Jul 2011 01:46:56 -0600
Message-Id: <1310370416-6322-22-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

delete pending queries by re-issuing it with disabled flags

with:
$> echo "module foo +ap" > <debugfs>/dynamic_debug/control
$> echo "module foo +apt" > <debugfs>/dynamic_debug/control
$> echo "module foo ap=" > <debugfs>/dynamic_debug/control

1st command adds a pending query on foo
2nd command modifies it by adding a TID flag
3rd command deletes it by setting flags to 0

Note that the pending query matches 'ap' as required by the flags-filter,
but additionally has 't'.  An exact match on the query-spec is required,
"module foo line 10-20" would not match, and wouldnt be removed.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index f0c2b39..2fd207d 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -447,7 +447,7 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 	*filterp = filter;
 
 	flags = ddebug_parse_flag_settings(s);
-	if (flags <= 0) {
+	if (flags < 0) {
 		pr_err("flags=0x%x\n", flags);
 		return -EINVAL;
 	}
@@ -505,7 +505,17 @@ static int ddebug_save_pending(struct ddebug_query *query,
 
 	list_for_each_entry_safe(pq, pqnext, &pending_queries, link) {
 		if (queries_match(query, &pq->query)) {
-			/* query already in list, update flags */
+			/* query already in list */
+			if (!flags) {
+				/* zeroed flags, remove query */
+				if (verbose)
+					pr_info("delete pending: %s\n",
+						show_pending_query(pq));
+				list_del_init(&pq->link);
+				kfree(pq);
+				pending_ct--;
+				return 0;
+			}
 			if (pq->flags != flags)
 				pq->flags = flags;
 			if (pq->mask != mask)
@@ -565,7 +575,8 @@ static int ddebug_exec_query(char *query_string)
 	mutex_lock(&ddebug_lock);
 	nfound = ddebug_change(&query, flags, mask, filter);
 	if (!nfound) {
-		if (flags & _DPRINTK_FLAGS_APPEND)
+		if (flags & _DPRINTK_FLAGS_APPEND ||
+			filter & _DPRINTK_FLAGS_APPEND)
 			rc = ddebug_save_pending(&query, flags, mask);
 		else
 			pr_warn("no match on: %s\n",
-- 
1.7.4.1

