Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab1IUV6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 17:58:30 -0400
Received: from mail-gw0-f42.google.com ([74.125.83.42]:36106 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab1IUV43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:56:29 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: joe@perches.com, bart.vanassche@gmail.com, greg@kroah.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 17/26] dynamic_debug: remove pending query when flags zeroed
Date: Wed, 21 Sep 2011 15:55:06 -0600
Message-Id: <1316642115-20029-18-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

When a pending-query is resubmitted with zeroed flags, remove it
from pending-queries list.  The submission must have identical
match-specs, and like the original query, must have 'a' in the
filter-flags.  If other filter-flags are given, they must match
the query to be removed, but filter can be underspecified; "p"
will match against "pt".

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index a59d48c..0c9e53a 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -508,7 +508,14 @@ static int ddebug_save_pending(struct ddebug_query *query,
 
 	list_for_each_entry_safe(pq, pqnext, &pending_queries, link) {
 		if (queries_match(query, &pq->query)) {
-			/* query already in list, update flags */
+			/* query already in list */
+			if (!flags) {
+				/* zeroed flags, remove query */
+				vpr_info_pq(pq, "delete pending");
+				list_del_init(&pq->link);
+				pqfree(pq);
+				return 0;
+			}
 			if (pq->flags != flags)
 				pq->flags = flags;
 			if (pq->mask != mask)
-- 
1.7.4.4

