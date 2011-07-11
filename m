Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964819Ab1GKHri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 03:47:38 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33546 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246Ab1GKHrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 03:47:32 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, bvanassche@acm.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 10/21] dynamic_debug: call apply_pending_queries from ddebug_add_module
Date: Mon, 11 Jul 2011 01:46:45 -0600
Message-Id: <1310370416-6322-11-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a module is loaded, ddebug_add_module calls apply_pending_queries
to scan pending_queries list and call ddebug_change to apply them.
Matching rules are removed from pending_queries.

With this change, the loaded module's pr_debugs are enabled when
its module_init is invoked, which is not possible otherwize.

With verbose=1, kernel logs look like:

  apply_pending_queries: check: pc8736x_gpio <-> q->function="(null)" q->filename="(null)" \
	q->module="pc8736x_gpio" q->format="(null)" q->lineno=0-0 q->flags=0x1 q->mask=0xffffffff
  ...
  ddebug_change: changed .../drivers/char/pc8736x_gpio.c:342 [pc8736x_gpio]pc8736x_gpio_cleanup p
  ddebug_change: changed .../drivers/char/pc8736x_gpio.c:319 [pc8736x_gpio]pc8736x_gpio_init p
  ...
  platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
  platform pc8736x_gpio.0: GPIO ioport 6600 reserved

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index b049ef2..cc8e157 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -124,6 +124,16 @@ static char *show_ddebug_query(const struct ddebug_query *q)
 	return prbuf_query;
 }
 
+static char *show_pending_query(struct pending_query *pq)
+{
+	struct ddebug_query *dq = &pq->query;
+	char *tmp = show_ddebug_query(dq);
+
+	sprintf(tmp + strlen(tmp), " q->flags=0x%x q->mask=0x%x",
+		pq->flags, pq->mask);
+	return prbuf_query;
+}
+
 /*
  * Search the tables for _ddebug's which match the given
  * `query' and apply the `flags' and `mask' to them.  Tells
@@ -846,6 +856,34 @@ static const struct file_operations ddebug_proc_fops = {
 	.write = ddebug_proc_write
 };
 
+/* apply matching queries in pending-queries list */
+static void apply_pending_queries(struct ddebug_table *dt)
+{
+	struct pending_query *pq, *pqnext;
+	int nfound;
+
+	if (verbose)
+		pr_info("pending_ct: %d\n", pending_ct);
+
+	list_for_each_entry_safe(pq, pqnext, &pending_queries, link) {
+
+		if (verbose)
+			pr_info("check: %s <-> %s\n",
+				dt->mod_name, show_pending_query(pq));
+
+		nfound = ddebug_change(&pq->query, pq->flags, pq->mask);
+
+		if (nfound) {
+			mutex_lock(&ddebug_lock);
+			list_del(&pq->link);
+			mutex_unlock(&ddebug_lock);
+			kfree(pq);
+			pending_ct--;
+		} else if (verbose)
+			pr_info("no-match: %s\n", show_pending_query(pq));
+	}
+
+}
 /*
  * Allocate a new ddebug_table for the given module
  * and add it to the global list.
@@ -874,6 +912,9 @@ int ddebug_add_module(struct _ddebug *tab, unsigned int n,
 
 	if (verbose)
 		pr_info("%u debug prints in module %s\n", n, dt->mod_name);
+
+	apply_pending_queries(dt);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ddebug_add_module);
-- 
1.7.4.1

