Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab1GYVnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:43:42 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:63998 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab1GYVnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:43:35 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: bvanassche@acm.org, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 13/25] dynamic_debug: apply_pending_queries() from ddebug_add_module()
Date: Mon, 25 Jul 2011 15:42:38 -0600
Message-Id: <1311630170-26057-14-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a module is loaded, ddebug_add_module calls apply_pending_queries
to scan pending_queries list and call ddebug_change to apply them.
Pending queries remain on the list after they're applied, so they
persist through modprobe-rmmod cycles during debugging.

With this change, the loaded module's pr_debugs are enabled when
its module_init is invoked, which is not possible otherwize.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 4135bf5..7e4f919 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -866,6 +866,21 @@ static const struct file_operations ddebug_proc_fops = {
 	.write = ddebug_proc_write
 };
 
+/* apply matching queries in pending-queries list */
+static void apply_pending_queries(struct ddebug_table *dt)
+{
+	struct pending_query *pq, *pqnext;
+	int nfound;
+	char *qstr;
+
+	list_for_each_entry_safe(pq, pqnext, &pending_queries, link) {
+		nfound = ddebug_change(&pq->query, pq->flags, pq->mask);
+		qstr = show_pending_query(pq);
+		pr_debug("%s: %s\n", (nfound) ? "applied" : "no-match", qstr);
+		kfree(qstr);
+	}
+}
+
 /*
  * Allocate a new ddebug_table for the given module
  * and add it to the global list.
@@ -890,6 +905,7 @@ int ddebug_add_module(struct _ddebug *tab, unsigned int n,
 
 	mutex_lock(&ddebug_lock);
 	list_add_tail(&dt->link, &ddebug_tables);
+	apply_pending_queries(dt);
 	mutex_unlock(&ddebug_lock);
 
 	if (verbose)
-- 
1.7.4.1

