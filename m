Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab2IYI4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 04:56:51 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:13165 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303Ab2IYI4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 04:56:44 -0400
From: Glauber Costa <glommer@parallels.com>
To: <linux-kernel@vger.kernel.org>
Cc: <cgroups@vger.kernel.org>, <linux-mm@kvack.org>, <devel@openvz.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Glauber Costa <glommer@parallels.com>, Michal Hocko <mhocko@suse.cz>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC 4/4] memcg: do not walk all the way to the root for memcg
Date: Tue, 25 Sep 2012 12:52:53 +0400
Message-Id: <1348563173-8952-5-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348563173-8952-1-git-send-email-glommer@parallels.com>
References: <1348563173-8952-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the root is special anyway, and we always get its figures from
global counters anyway, there is no make all cgroups its descendants,
wrt res_counters. The sad effect of doing that is that we need to lock
the root for all allocations, since it is a common ancestor of
everybody.

Not having the root as a common ancestor should lead to better
scalability for not-uncommon case of tasks in the cgroup being
node-bound to different nodes in NUMA systems.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Michal Hocko <mhocko@suse.cz>
CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Johannes Weiner <hannes@cmpxchg.org>
CC: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f8115f0..829ea9e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5720,7 +5720,7 @@ mem_cgroup_create(struct cgroup *cont)
 		static_key_slow_inc(&memcg_in_use_key);
 	}
 
-	if (parent && parent->use_hierarchy) {
+	if (parent && !mem_cgroup_is_root(parent) && parent->use_hierarchy) {
 		struct mem_cgroup __maybe_unused *p;
 
 		res_counter_init(&memcg->res, &parent->res);
-- 
1.7.11.4

