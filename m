Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab2L1Uhj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 15:37:39 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:54502 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab2L1Ugt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 15:36:49 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, axboe@kernel.dk, vgoyal@redhat.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 22/24] cfq-iosched: separate out cfqg_stats_reset() from cfq_pd_reset_stats()
Date: Fri, 28 Dec 2012 12:35:44 -0800
Message-Id: <1356726946-26037-23-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356726946-26037-1-git-send-email-tj@kernel.org>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate out cfqg_stats_reset() which takes struct cfqg_stats * from
cfq_pd_reset_stats() and move the latter to where other pd methods are
defined.  cfqg_stats_reset() will be used to implement hierarchical
stats.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/cfq-iosched.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index d43145cc..f8b34bb 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -688,11 +688,9 @@ static inline void cfqg_stats_update_completion(struct cfq_group *cfqg,
 				io_start_time - start_time);
 }
 
-static void cfq_pd_reset_stats(struct blkcg_gq *blkg)
+/* @stats = 0 */
+static void cfqg_stats_reset(struct cfqg_stats *stats)
 {
-	struct cfq_group *cfqg = blkg_to_cfqg(blkg);
-	struct cfqg_stats *stats = &cfqg->stats;
-
 	/* queued stats shouldn't be cleared */
 	blkg_rwstat_reset(&stats->service_bytes);
 	blkg_rwstat_reset(&stats->serviced);
@@ -1477,6 +1475,13 @@ static void cfq_pd_init(struct blkcg_gq *blkg)
 	cfqg->leaf_weight = blkg->blkcg->cfq_leaf_weight;
 }
 
+static void cfq_pd_reset_stats(struct blkcg_gq *blkg)
+{
+	struct cfq_group *cfqg = blkg_to_cfqg(blkg);
+
+	cfqg_stats_reset(&cfqg->stats);
+}
+
 /*
  * Search for the cfq group current task belongs to. request_queue lock must
  * be held.
-- 
1.8.0.2

