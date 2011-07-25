Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab1GYVn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:43:58 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:63998 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab1GYVnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:43:47 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: bvanassche@acm.org, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 20/25] dynamic_debug: remove pending query when flags zeroed
Date: Mon, 25 Jul 2011 15:42:45 -0600
Message-Id: <1311630170-26057-21-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a pending-query is resubmitted with zeroed flags, remove it
from pending-queries list.  The submission must have identical
match-specs, and like the original query, must have 'a' in the
filter-flags.  If other filter-flags are given, they must match
the query to be removed, but filter can be underspecified; "p"
will match against "pt".

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 275cf30..8f56092 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -511,7 +511,17 @@ static int ddebug_save_pending(struct ddebug_query *query,
 
 	list_for_each_entry_safe(pq, pqnext, &pending_queries, link) {
 		if (queries_match(query, &pq->query)) {
-			/* query already in list, update flags */
+			/* query already in list */
+			if (!flags) {
+				/* zeroed flags, remove query */
+				qstr = show_pending_query(pq);
+				pr_debug("delete pending: %s\n", qstr);
+				kfree(qstr);
+				list_del_init(&pq->link);
+				kfree(pq);
+				pending_ct--;
+				return 0;
+			}
 			if (pq->flags != flags)
 				pq->flags = flags;
 			if (pq->mask != mask)
@@ -581,7 +591,8 @@ static int ddebug_exec_query(char *query_string)
 	qstr = show_ddebug_query(&query);
 	pr_debug("nfound %d on %s\n", nfound, qstr);
 	if (!nfound) {
-		if (flags & _DPRINTK_FLAGS_APPEND)
+		if (flags & _DPRINTK_FLAGS_APPEND ||
+			filter & _DPRINTK_FLAGS_APPEND)
 			rc = ddebug_save_pending(&query, flags, mask);
 		else
 			pr_warn("no match on: %s\n", qstr);
-- 
1.7.4.1

