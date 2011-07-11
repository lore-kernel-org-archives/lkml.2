Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964857Ab1GKHsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 03:48:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54806 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283Ab1GKHrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 03:47:49 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, bvanassche@acm.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 20/21] dynamic_debug: clear pending_queries list in remove_all_tables
Date: Mon, 11 Jul 2011 01:46:55 -0600
Message-Id: <1310370416-6322-21-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 9514071..f0c2b39 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -1017,6 +1017,8 @@ EXPORT_SYMBOL_GPL(ddebug_remove_module);
 
 static void ddebug_remove_all_tables(void)
 {
+	struct pending_query *pq, *pqnext;
+
 	mutex_lock(&ddebug_lock);
 	while (!list_empty(&ddebug_tables)) {
 		struct ddebug_table *dt = list_entry(ddebug_tables.next,
@@ -1024,6 +1026,13 @@ static void ddebug_remove_all_tables(void)
 						      link);
 		ddebug_table_free(dt);
 	}
+	list_for_each_entry_safe(pq, pqnext, &pending_queries, link) {
+		if (verbose > 1)
+			pr_info("delete pending: %s\n",
+				show_pending_query(pq));
+		list_del_init(&pq->link);
+		kfree(pq);
+	}
 	mutex_unlock(&ddebug_lock);
 }
 
-- 
1.7.4.1

