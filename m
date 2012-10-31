Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab2JaJSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:18:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:33690 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754115Ab2JaJSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:18:35 -0400
X-IronPort-AV: E=Sophos;i="4.80,687,1344182400"; 
   d="scan'208";a="6107702"
From: Wen Congyang <wency@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org
Cc: Rob Landley <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Yinghai Lu <yinghai@kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Subject: [PART6 Patch] mempolicy: fix is_valid_nodemask()
Date: Wed, 31 Oct 2012 17:24:18 +0800
Message-Id: <1351675458-11859-2-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1351675458-11859-1-git-send-email-wency@cn.fujitsu.com>
References: <1351675458-11859-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 17:17:48,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 17:17:49,
	Serialize complete at 2012/10/31 17:17:49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

is_valid_nodemask() is introduced by 19770b32. but it does not match
its comments, because it does not check the zone which > policy_zone.

Also in b377fd, this commits told us, if highest zone is ZONE_MOVABLE,
we should also apply memory policies to it. so ZONE_MOVABLE should be valid zone
for policies. is_valid_nodemask() need to be changed to match it.

Fix: check all zones, even its zoneid > policy_zone.
Use nodes_intersects() instead open code to check it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Reported-by: Wen Congyang <wency@cn.fujitsu.com>
---
 mm/mempolicy.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index d04a8a5..de5aa24 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -140,19 +140,7 @@ static const struct mempolicy_operations {
 /* Check that the nodemask contains at least one populated zone */
 static int is_valid_nodemask(const nodemask_t *nodemask)
 {
-	int nd, k;
-
-	for_each_node_mask(nd, *nodemask) {
-		struct zone *z;
-
-		for (k = 0; k <= policy_zone; k++) {
-			z = &NODE_DATA(nd)->node_zones[k];
-			if (z->present_pages > 0)
-				return 1;
-		}
-	}
-
-	return 0;
+	return nodes_intersects(*nodemask, node_states[N_MEMORY]);
 }
 
 static inline int mpol_store_user_nodemask(const struct mempolicy *pol)
@@ -1572,6 +1560,26 @@ struct mempolicy *get_vma_policy(struct task_struct *task,
 	return pol;
 }
 
+static int apply_policy_zone(struct mempolicy *policy, enum zone_type zone)
+{
+	enum zone_type dynamic_policy_zone = policy_zone;
+
+	BUG_ON(dynamic_policy_zone == ZONE_MOVABLE);
+
+	/*
+	 * if policy->v.nodes has movable memory only,
+	 * we apply policy when gfp_zone(gfp) = ZONE_MOVABLE only.
+	 *
+	 * policy->v.nodes is intersect with node_states[N_MEMORY].
+	 * so if the following test faile, it implies
+	 * policy->v.nodes has movable memory only.
+	 */
+	if (!nodes_intersects(policy->v.nodes, node_states[N_HIGH_MEMORY]))
+		dynamic_policy_zone = ZONE_MOVABLE;
+
+	return zone >= dynamic_policy_zone;
+}
+
 /*
  * Return a nodemask representing a mempolicy for filtering nodes for
  * page allocation
@@ -1580,7 +1588,7 @@ static nodemask_t *policy_nodemask(gfp_t gfp, struct mempolicy *policy)
 {
 	/* Lower zones don't get a nodemask applied for MPOL_BIND */
 	if (unlikely(policy->mode == MPOL_BIND) &&
-			gfp_zone(gfp) >= policy_zone &&
+			apply_policy_zone(policy, gfp_zone(gfp)) &&
 			cpuset_nodemask_valid_mems_allowed(&policy->v.nodes))
 		return &policy->v.nodes;
 
-- 
1.8.0

