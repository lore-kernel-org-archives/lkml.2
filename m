Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab1BCMzD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 07:55:03 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:59072 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932083Ab1BCMzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 07:55:01 -0500
Date: Thu, 3 Feb 2011 13:54:54 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp,
        balbir@linux.vnet.ibm.com, minchan.kim@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch 1/2] memcg: soft limit reclaim should end at limit not below
Message-ID: <20110203125453.GB2286@cmpxchg.org>
References: <1296482635-13421-1-git-send-email-hannes@cmpxchg.org>
 <1296482635-13421-3-git-send-email-hannes@cmpxchg.org>
 <20110131144131.6733aa3a.akpm@linux-foundation.org>
 <20110201000455.GB19534@cmpxchg.org>
 <20110131162448.e791f0ae.akpm@linux-foundation.org>
 <20110203125357.GA2286@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110203125357.GA2286@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soft limit reclaim continues until the usage is below the current soft
limit, but the documented semantics are actually that soft limit
reclaim will push usage back until the soft limits are met again.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/res_counter.h |    4 ++--
 mm/memcontrol.c             |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index a5930cb..bf1f01b 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -139,7 +139,7 @@ static inline bool res_counter_limit_check_locked(struct res_counter *cnt)
 
 static inline bool res_counter_soft_limit_check_locked(struct res_counter *cnt)
 {
-	if (cnt->usage < cnt->soft_limit)
+	if (cnt->usage <= cnt->soft_limit)
 		return true;
 
 	return false;
@@ -202,7 +202,7 @@ static inline bool res_counter_check_margin(struct res_counter *cnt,
 	return ret;
 }
 
-static inline bool res_counter_check_under_soft_limit(struct res_counter *cnt)
+static inline bool res_counter_check_within_soft_limit(struct res_counter *cnt)
 {
 	bool ret;
 	unsigned long flags;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 350bfd2..23b14188 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1451,7 +1451,7 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
 			return ret;
 		total += ret;
 		if (check_soft) {
-			if (res_counter_check_under_soft_limit(&root_mem->res))
+			if (res_counter_check_within_soft_limit(&root_mem->res))
 				return total;
 		} else if (mem_cgroup_check_under_limit(root_mem))
 			return 1 + total;
-- 
1.7.4

