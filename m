Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab2BTRX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 12:23:59 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43752 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab2BTRX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 12:23:57 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of koct9i@gmail.com designates 10.204.143.145 as permitted sender) smtp.mail=koct9i@gmail.com; dkim=pass header.i=koct9i@gmail.com
Subject: [PATCH v2 21/22] mm: free lruvec in memcgroup via rcu
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 20 Feb 2012 21:23:54 +0400
Message-ID: <20120220172354.22196.56006.stgit@zurg>
In-Reply-To: <20120220171138.22196.65847.stgit@zurg>
References: <20120220171138.22196.65847.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required for splitting lru_lock into per-lruvec pieces.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 mm/memcontrol.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 69763da..eb024c1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -148,6 +148,7 @@ struct mem_cgroup_per_zone {
 
 struct mem_cgroup_per_node {
 	struct mem_cgroup_per_zone zoneinfo[MAX_NR_ZONES];
+	struct rcu_head		rcu_head;
 };
 
 struct mem_cgroup_lru_info {
@@ -4657,18 +4658,27 @@ static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *memcg, int node)
 	return 0;
 }
 
+static void free_pn_rcu(struct rcu_head *rcu_head)
+{
+       struct mem_cgroup_per_node *pn;
+       int zone;
+
+       pn = container_of(rcu_head, struct mem_cgroup_per_node, rcu_head);
+
+       for (zone = 0; zone < MAX_NR_ZONES; zone++)
+	       wait_lruvec_unlock(&pn->zoneinfo[zone].lruvec);
+
+       kfree(pn);
+}
+
 static void free_mem_cgroup_per_zone_info(struct mem_cgroup *memcg, int node)
 {
 	struct mem_cgroup_per_node *pn = memcg->info.nodeinfo[node];
-	int zone;
 
 	if (!pn)
 		return;
 
-	for (zone = 0; zone < MAX_NR_ZONES; zone++)
-		wait_lruvec_unlock(&pn->zoneinfo[zone].lruvec);
-
-	kfree(pn);
+	call_rcu(&pn->rcu_head, free_pn_rcu);
 }
 
 static struct mem_cgroup *mem_cgroup_alloc(void)

