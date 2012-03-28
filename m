Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933229Ab2C1WxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 18:53:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48045 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758989Ab2C1Wvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 18:51:54 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/21] blkcg: implement blkio_policy_type->cftypes
Date: Wed, 28 Mar 2012 15:51:20 -0700
Message-Id: <1332975091-10950-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332975091-10950-1-git-send-email-tj@kernel.org>
References: <1332975091-10950-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add blkiop->cftypes which is added and removed together with the
policy.  This will be used to move conf/stat handling to the policies.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-cgroup.c |    6 ++++++
 block/blk-cgroup.h |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index df1e197..2f05056 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1538,6 +1538,9 @@ void blkio_policy_register(struct blkio_policy_type *blkiop)
 	list_for_each_entry(q, &all_q_list, all_q_node)
 		update_root_blkg_pd(q, blkiop->plid);
 	blkcg_bypass_end();
+
+	if (blkiop->cftypes)
+		WARN_ON(cgroup_add_cftypes(&blkio_subsys, blkiop->cftypes));
 }
 EXPORT_SYMBOL_GPL(blkio_policy_register);
 
@@ -1545,6 +1548,9 @@ void blkio_policy_unregister(struct blkio_policy_type *blkiop)
 {
 	struct request_queue *q;
 
+	if (blkiop->cftypes)
+		cgroup_rm_cftypes(&blkio_subsys, blkiop->cftypes);
+
 	blkcg_bypass_start();
 	spin_lock(&blkio_list_lock);
 
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 361ecfa..fa744d5 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -181,6 +181,7 @@ struct blkio_policy_type {
 	struct blkio_policy_ops ops;
 	enum blkio_policy_id plid;
 	size_t pdata_size;		/* policy specific private data size */
+	struct cftype *cftypes;		/* cgroup files for the policy */
 };
 
 extern int blkcg_init_queue(struct request_queue *q);
-- 
1.7.7.3

