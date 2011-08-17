Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab1HQTuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 15:50:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200Ab1HQTub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 15:50:31 -0400
Date: Wed, 17 Aug 2011 21:49:27 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        Balbir Singh <bsingharora@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [patch] memcg: pin execution to current cpu while draining stock
Message-ID: <20110817194927.GA10982@redhat.com>
References: <cover.1311338634.git.mhocko@suse.cz>
 <2f17df54db6661c39a05669d08a9e6257435b898.1311338634.git.mhocko@suse.cz>
 <20110725101657.21f85bf0.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110725101657.21f85bf0.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d1a05b6 'memcg: do not try to drain per-cpu caches without
pages' added a drain_local_stock() call to a preemptible section.

The draining task looks up the cpu-local stock twice to set the
draining-flag, then to drain the stock and clear the flag again.  If
the task is migrated to a different CPU in between, noone will clear
the flag on the first stock and it will be forever undrainable.  Its
charge can not be recovered and the cgroup can not be deleted anymore.

Properly pin the task to the executing CPU while draining stocks.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com
Cc: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 697a1d5..e9b1206 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2085,13 +2085,7 @@ static void drain_all_stock(struct mem_cgroup *root_mem, bool sync)
 
 	/* Notify other cpus that system-wide "drain" is running */
 	get_online_cpus();
-	/*
-	 * Get a hint for avoiding draining charges on the current cpu,
-	 * which must be exhausted by our charging.  It is not required that
-	 * this be a precise check, so we use raw_smp_processor_id() instead of
-	 * getcpu()/putcpu().
-	 */
-	curcpu = raw_smp_processor_id();
+	curcpu = get_cpu();
 	for_each_online_cpu(cpu) {
 		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
 		struct mem_cgroup *mem;
@@ -2108,6 +2102,7 @@ static void drain_all_stock(struct mem_cgroup *root_mem, bool sync)
 				schedule_work_on(cpu, &stock->work);
 		}
 	}
+	put_cpu();
 
 	if (!sync)
 		goto out;
-- 
1.7.6
