Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab1F1HMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 03:12:38 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59669 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756712Ab1F1HK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 03:10:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Se2MXlemOOOvzVevUYWldfMfvWEy0t+eGvyRN/MjywgyS/2274HhrMjkRZYo1lhbqW
         mWBjKPe5zvVDsd2zni1ER3uV55aZLt7r2wVAG9db0UXB8jEk+8TOWr2SPLD7wfV/nSBk
         YUWkxRyz1DSpbL55K0DvCZCwh7ji4MbdBBG0w=
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gnb@fmeh.org, jbaron@redhat.com, bvanassche@acm.org, gregkh@suse.de,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 10/11] dynamic_debug: call apply_pending_queries from ddebug_add_module
Date: Tue, 28 Jun 2011 01:09:51 -0600
Message-Id: <1309244992-2305-11-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a module is loaded, ddebug_add_module calls apply_pending_queries
to scan pending_queries list and call ddebug_change to apply them.
Matching rules are removed from pending_queries.

With this change, the loaded module's pr_debugs are enabled when
its module_init is invoked, which is not possible otherwize.

With verbose=1, kernel logs look like:

apply_pending_queries: check: pc8736x_gpio <-> q->function="(null)" q->filename="(null)" q->module="pc8736x_gpio" q->format="(null)" q->lineno=0-0 q->flags=0x1 q->mask=0xffffffff

ddebug_change: changed /home/jimc/projects/lx/linux-2.6/drivers/char/pc8736x_gpio.c:342 [pc8736x_gpio]pc8736x_gpio_cleanup p
ddebug_change: changed /home/jimc/projects/lx/linux-2.6/drivers/char/pc8736x_gpio.c:319 [pc8736x_gpio]pc8736x_gpio_init p
...
platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
platform pc8736x_gpio.0: GPIO ioport 6600 reserved

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 37d0275..252888a 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -126,8 +126,8 @@ static char *show_ddebug_query(const struct ddebug_query *q)
 }
 
 /* copy query off stack, save flags & mask, and store in pending-list */
-static void add_to_pending(const struct ddebug_query *query,
-			   unsigned int flags, unsigned int mask)
+static void ddebug_add_to_pending(struct ddebug_query *query,
+				unsigned int flags, unsigned int mask)
 {
 	struct pending_query *pq;
 
@@ -351,6 +351,20 @@ static char *unescape(char *str)
 	return str;
 }
 
+static char *show_pending_query(struct pending_query *pq)
+{
+	struct ddebug_query *dq = &pq->query;
+        sprintf(prbuf_query,
+		"q->function=\"%s\" q->filename=\"%s\" "
+		"q->module=\"%s\" q->format=\"%s\" q->lineno=%u-%u "
+		"q->flags=0x%x q->mask=0x%x\n",
+		dq->function, dq->filename, dq->module, dq->format,
+		dq->first_lineno, dq->last_lineno,
+		pq->flags, pq->mask);
+
+	return prbuf_query;
+}
+
 static inline void check_set(const char **dest, char *src, char *name)
 {
 	if (*dest)
@@ -786,6 +800,35 @@ static const struct file_operations ddebug_proc_fops = {
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
+		}
+		else if (verbose)
+			pr_info("no-match: %s\n", show_pending_query(pq));
+	}
+
+}
 /*
  * Allocate a new ddebug_table for the given module
  * and add it to the global list.
@@ -815,6 +858,9 @@ int ddebug_add_module(struct _ddebug *tab, unsigned int n,
 
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

