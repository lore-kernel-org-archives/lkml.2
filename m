Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360Ab2B2JQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 04:16:13 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34834 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757272Ab2B2JQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 04:16:09 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of koct9i@gmail.com designates 10.204.157.145 as permitted sender) smtp.mail=koct9i@gmail.com; dkim=pass header.i=koct9i@gmail.com
Subject: [PATCH 7/7] mm/memcg: use vm_swappiness from target memory cgroup
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Wed, 29 Feb 2012 13:16:04 +0400
Message-ID: <20120229091604.29236.63600.stgit@zurg>
In-Reply-To: <20120229090748.29236.35489.stgit@zurg>
References: <20120229090748.29236.35489.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use vm_swappiness from memory cgroup which is triggered this memory reclaim.
This is more reasonable and allows to kill one argument.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 mm/vmscan.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index ab447df..fd96eb8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1873,12 +1873,11 @@ static unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
 	return shrink_inactive_list(nr_to_scan, mz, sc, priority, lru);
 }
 
-static int vmscan_swappiness(struct mem_cgroup_zone *mz,
-			     struct scan_control *sc)
+static int vmscan_swappiness(struct scan_control *sc)
 {
 	if (global_reclaim(sc))
 		return vm_swappiness;
-	return mem_cgroup_swappiness(mz->mem_cgroup);
+	return mem_cgroup_swappiness(sc->target_mem_cgroup);
 }
 
 /*
@@ -1947,8 +1946,8 @@ static void get_scan_count(struct mem_cgroup_zone *mz, struct scan_control *sc,
 	 * With swappiness at 100, anonymous and file have the same priority.
 	 * This scanning priority is essentially the inverse of IO cost.
 	 */
-	anon_prio = vmscan_swappiness(mz, sc);
-	file_prio = 200 - vmscan_swappiness(mz, sc);
+	anon_prio = vmscan_swappiness(sc);
+	file_prio = 200 - vmscan_swappiness(sc);
 
 	/*
 	 * OK, so we have swap space and a fair amount of page cache

