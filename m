Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab2L1UmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 15:42:20 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:36002 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab2L1UmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 15:42:04 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, axboe@kernel.dk, vgoyal@redhat.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 21/24] blkcg: make blkcg_print_blkgs() grab q locks instead of blkcg lock
Date: Fri, 28 Dec 2012 12:35:43 -0800
Message-Id: <1356726946-26037-22-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356726946-26037-1-git-send-email-tj@kernel.org>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of holding blkcg->lock while walking ->blkg_list and executing
prfill(), RCU walk ->blkg_list and hold the blkg's queue lock while
executing prfill().  This makes prfill() implementations easier as
stats are mostly protected by queue lock.

This will be used to implement hierarchical stats.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-cgroup.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index a1a4b97..22f75d1 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -504,8 +504,9 @@ static const char *blkg_dev_name(struct blkcg_gq *blkg)
  *
  * This function invokes @prfill on each blkg of @blkcg if pd for the
  * policy specified by @pol exists.  @prfill is invoked with @sf, the
- * policy data and @data.  If @show_total is %true, the sum of the return
- * values from @prfill is printed with "Total" label at the end.
+ * policy data and @data and the matching queue lock held.  If @show_total
+ * is %true, the sum of the return values from @prfill is printed with
+ * "Total" label at the end.
  *
  * This is to be used to construct print functions for
  * cftype->read_seq_string method.
@@ -520,11 +521,14 @@ void blkcg_print_blkgs(struct seq_file *sf, struct blkcg *blkcg,
 	struct hlist_node *n;
 	u64 total = 0;
 
-	spin_lock_irq(&blkcg->lock);
-	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node)
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(blkg, n, &blkcg->blkg_list, blkcg_node) {
+		spin_lock_irq(blkg->q->queue_lock);
 		if (blkcg_policy_enabled(blkg->q, pol))
 			total += prfill(sf, blkg->pd[pol->plid], data);
-	spin_unlock_irq(&blkcg->lock);
+		spin_unlock_irq(blkg->q->queue_lock);
+	}
+	rcu_read_unlock();
 
 	if (show_total)
 		seq_printf(sf, "Total %llu\n", (unsigned long long)total);
-- 
1.8.0.2

