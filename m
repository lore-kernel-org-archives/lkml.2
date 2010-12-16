Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab0LPDMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 22:12:55 -0500
Received: from smtp-out.google.com ([74.125.121.35]:34052 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987Ab0LPDMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 22:12:51 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:
	content-disposition:x-system-of-record;
	b=YmZOP2vST30l26jr4a4Qi3U8B8ACLHZd1AeYMgA7PEfOulM+bjsIqfdrg/QBCX0W9
	5+YS4Ld1+ONfOpM6tyd4g==
Message-Id: <20101216031038.067028969@google.com>
User-Agent: quilt/0.48-1
Date: Wed, 15 Dec 2010 19:10:17 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch 1/2] sched: move periodic share updates to entity_tick()
References: <20101216031016.186364650@google.com>
Content-Disposition: inline; filename=shares_on_tick.patch
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Long running entities that do not block (dequeue) require periodic updates to
maintain accurate share values.  (Note: group entities with several threads are
quite likely to be non-blocking in many circumstances).

By virtue of being long-running however, we will see entity ticks (otherwise 
the required update occurs in dequeue/put and we are done).  Thus we can move 
the detection (and associated work) for these updates into the periodic path.

This restores the 'atomicity' of update_curr() with respect to accounting.

Signed-off-by: Paul Turner <pjt@google.com>

---
 kernel/sched_fair.c |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

Index: tip3/kernel/sched_fair.c
===================================================================
--- tip3.orig/kernel/sched_fair.c
+++ tip3/kernel/sched_fair.c
@@ -563,12 +563,10 @@ __update_curr(struct cfs_rq *cfs_rq, str
 	update_min_vruntime(cfs_rq);
 
 #if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
-	cfs_rq->load_unacc_exec_time += delta_exec;
-	if (cfs_rq->load_unacc_exec_time > sysctl_sched_shares_window) {
-		update_cfs_load(cfs_rq, 0);
-		update_cfs_shares(cfs_rq, 0);
-	}
+	if (!entity_is_task(curr))
+		group_cfs_rq(curr)->load_unacc_exec_time += delta_exec;
 #endif
+
 }
 
 static void update_curr(struct cfs_rq *cfs_rq)
@@ -809,6 +807,20 @@ static void update_cfs_shares(struct cfs
 
 	reweight_entity(cfs_rq_of(se), se, shares);
 }
+
+static void update_entity_shares_tick(struct sched_entity *se)
+{
+	struct cfs_rq *cfs_rq;
+
+	if (entity_is_task(se))
+		return;
+
+	cfs_rq = group_cfs_rq(se);
+	if (cfs_rq->load_unacc_exec_time > sysctl_sched_shares_window) {
+		update_cfs_load(cfs_rq, 0);
+		update_cfs_shares(cfs_rq, 0);
+	}
+}
 #else /* CONFIG_FAIR_GROUP_SCHED */
 static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
 {
@@ -1133,6 +1145,13 @@ entity_tick(struct cfs_rq *cfs_rq, struc
 	 */
 	update_curr(cfs_rq);
 
+#if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
+	/*
+	 * Update share accounting for long-running entities.
+	 */
+	update_entity_shares_tick(curr);
+#endif
+
 #ifdef CONFIG_SCHED_HRTICK
 	/*
 	 * queued ticks are scheduled to match the slice, so don't bother


