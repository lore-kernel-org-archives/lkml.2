Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381Ab2GEApt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 20:45:49 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:53404 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756137Ab2GEApo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 20:45:44 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 03/11] mm: shmem: do not try to uncharge known swapcache pages
Date: Thu,  5 Jul 2012 02:44:55 +0200
Message-Id: <1341449103-1986-4-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org>
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once charged, swapcache pages can only be uncharged after they are
removed from swapcache again.

Do not try to uncharge pages that are known to be in the swapcache, to
allow future patches to remove checks for that in the uncharge code.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/shmem.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index ee1c5a2..d12b705 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -302,8 +302,6 @@ static int shmem_add_to_page_cache(struct page *page,
 		if (!expected)
 			radix_tree_preload_end();
 	}
-	if (error)
-		mem_cgroup_uncharge_cache_page(page);
 	return error;
 }
 
@@ -1184,11 +1182,14 @@ static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
 		__set_page_locked(page);
 		error = mem_cgroup_cache_charge(page, current->mm,
 						gfp & GFP_RECLAIM_MASK);
-		if (!error)
-			error = shmem_add_to_page_cache(page, mapping, index,
-						gfp, NULL);
 		if (error)
 			goto decused;
+		error = shmem_add_to_page_cache(page, mapping, index,
+						gfp, NULL);
+		if (error) {
+			mem_cgroup_uncharge_cache_page(page);
+			goto decused;
+		}
 		lru_cache_add_anon(page);
 
 		spin_lock(&info->lock);
-- 
1.7.7.6

