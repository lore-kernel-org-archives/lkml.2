Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab1JTVIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 17:08:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893Ab1JTVIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 17:08:30 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: vgoyal@redhat.com, tj@kernel.org
Subject: [PATCH 2/2] blk-throttle: Take blkcg->lock while traversing blkcg->policy_list
Date: Thu, 20 Oct 2011 17:08:26 -0400
Message-Id: <1319144906-5066-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1319144906-5066-1-git-send-email-vgoyal@redhat.com>
References: <1319144906-5066-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blkcg->policy_list is protected by blkcg->lock. Its not rcu protected
list. So even for readers, they need to take blkcg->lock. There are
few functions which were reading the list without taking lock. Fix it.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c |   54 ++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 4ddf11f..1b5d789 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -879,60 +879,86 @@ unsigned int blkcg_get_weight(struct blkio_cgroup *blkcg,
 			      dev_t dev)
 {
 	struct blkio_policy_node *pn;
+	unsigned long flags;
+	unsigned int weight;
+
+	spin_lock_irqsave(&blkcg->lock, flags);
 
 	pn = blkio_policy_search_node(blkcg, dev, BLKIO_POLICY_PROP,
 				BLKIO_PROP_weight_device);
 	if (pn)
-		return pn->val.weight;
+		weight = pn->val.weight;
 	else
-		return blkcg->weight;
+		weight = blkcg->weight;
+
+	spin_unlock_irqrestore(&blkcg->lock, flags);
+
+	return weight;
 }
 EXPORT_SYMBOL_GPL(blkcg_get_weight);
 
 uint64_t blkcg_get_read_bps(struct blkio_cgroup *blkcg, dev_t dev)
 {
 	struct blkio_policy_node *pn;
+	unsigned long flags;
+	uint64_t bps = -1;
 
+	spin_lock_irqsave(&blkcg->lock, flags);
 	pn = blkio_policy_search_node(blkcg, dev, BLKIO_POLICY_THROTL,
 				BLKIO_THROTL_read_bps_device);
 	if (pn)
-		return pn->val.bps;
-	else
-		return -1;
+		bps = pn->val.bps;
+	spin_unlock_irqrestore(&blkcg->lock, flags);
+
+	return bps;
 }
 
 uint64_t blkcg_get_write_bps(struct blkio_cgroup *blkcg, dev_t dev)
 {
 	struct blkio_policy_node *pn;
+	unsigned long flags;
+	uint64_t bps = -1;
+
+	spin_lock_irqsave(&blkcg->lock, flags);
 	pn = blkio_policy_search_node(blkcg, dev, BLKIO_POLICY_THROTL,
 				BLKIO_THROTL_write_bps_device);
 	if (pn)
-		return pn->val.bps;
-	else
-		return -1;
+		bps = pn->val.bps;
+	spin_unlock_irqrestore(&blkcg->lock, flags);
+
+	return bps;
 }
 
 unsigned int blkcg_get_read_iops(struct blkio_cgroup *blkcg, dev_t dev)
 {
 	struct blkio_policy_node *pn;
+	unsigned long flags;
+	unsigned int iops = -1;
 
+	spin_lock_irqsave(&blkcg->lock, flags);
 	pn = blkio_policy_search_node(blkcg, dev, BLKIO_POLICY_THROTL,
 				BLKIO_THROTL_read_iops_device);
 	if (pn)
-		return pn->val.iops;
-	else
-		return -1;
+		iops = pn->val.iops;
+	spin_unlock_irqrestore(&blkcg->lock, flags);
+
+	return iops;
 }
 
 unsigned int blkcg_get_write_iops(struct blkio_cgroup *blkcg, dev_t dev)
 {
 	struct blkio_policy_node *pn;
+	unsigned long flags;
+	unsigned int iops = -1;
+
+	spin_lock_irqsave(&blkcg->lock, flags);
 	pn = blkio_policy_search_node(blkcg, dev, BLKIO_POLICY_THROTL,
 				BLKIO_THROTL_write_iops_device);
 	if (pn)
-		return pn->val.iops;
-	else
-		return -1;
+		iops = pn->val.iops;
+	spin_unlock_irqrestore(&blkcg->lock, flags);
+
+	return iops;
 }
 
 /* Checks whether user asked for deleting a policy rule */
-- 
1.7.4.4

