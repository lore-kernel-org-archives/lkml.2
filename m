Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab2DZVKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 17:10:50 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:40199 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab2DZVKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 17:10:49 -0400
Date: Thu, 26 Apr 2012 14:10:42 -0700
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: axboe@kernel.dk,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        paulmck@linux.vnet.ibm.com
Subject: [PATCH block/for-3.5/core] blkcg: tg_stats_alloc_lock is an irq
 lock
Message-ID: <20120426211042.GC27486@google.com>
References: <1335339396.16988.80.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335339396.16988.80.camel@lappy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tg_stats_alloc_lock nests inside queue lock and should always be held
with irq disabled.  throtl_pd_{init|exit}() were using non-irqsafe
spinlock ops which triggered inverse lock ordering via irq warning via
RCU freeing of blkg invoking throtl_pd_exit() w/o disabling IRQ.

Update both functions to use irq safe operations.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
LKML-Reference: <1335339396.16988.80.camel@lappy>
---
 block/blk-throttle.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: work/block/blk-throttle.c
===================================================================
--- work.orig/block/blk-throttle.c
+++ work/block/blk-throttle.c
@@ -219,6 +219,7 @@ alloc_stats:
 static void throtl_pd_init(struct blkcg_gq *blkg)
 {
 	struct throtl_grp *tg = blkg_to_tg(blkg);
+	unsigned long flags;
 
 	RB_CLEAR_NODE(&tg->rb_node);
 	bio_list_init(&tg->bio_lists[0]);
@@ -235,19 +236,20 @@ static void throtl_pd_init(struct blkcg_
 	 * but percpu allocator can't be called from IO path.  Queue tg on
 	 * tg_stats_alloc_list and allocate from work item.
 	 */
-	spin_lock(&tg_stats_alloc_lock);
+	spin_lock_irqsave(&tg_stats_alloc_lock, flags);
 	list_add(&tg->stats_alloc_node, &tg_stats_alloc_list);
 	queue_delayed_work(system_nrt_wq, &tg_stats_alloc_work, 0);
-	spin_unlock(&tg_stats_alloc_lock);
+	spin_unlock_irqrestore(&tg_stats_alloc_lock, flags);
 }
 
 static void throtl_pd_exit(struct blkcg_gq *blkg)
 {
 	struct throtl_grp *tg = blkg_to_tg(blkg);
+	unsigned long flags;
 
-	spin_lock(&tg_stats_alloc_lock);
+	spin_lock_irqsave(&tg_stats_alloc_lock, flags);
 	list_del_init(&tg->stats_alloc_node);
-	spin_unlock(&tg_stats_alloc_lock);
+	spin_unlock_irqrestore(&tg_stats_alloc_lock, flags);
 
 	free_percpu(tg->stats_cpu);
 }
