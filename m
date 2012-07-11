Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088Ab2GKRDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 13:03:11 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:53881 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933020Ab2GKRC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 13:02:57 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        David Rientjes <rientjes@google.com>,
        Wanpeng Li <liwp.linux@gmail.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 07/10] mm: memcg: remove needless !mm fixup to init_mm when charging
Date: Wed, 11 Jul 2012 19:02:19 +0200
Message-Id: <1342026142-7284-8-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1342026142-7284-1-git-send-email-hannes@cmpxchg.org>
References: <1342026142-7284-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It does not matter to __mem_cgroup_try_charge() if the passed mm is
NULL or init_mm, it will charge the root memcg in either case.

Also fix up the comment in __mem_cgroup_try_charge() that claimed the
init_mm would be charged when no mm was passed.  It's not really
incorrect, but confusing.  Clarify that the root memcg is charged in
this case.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2c7d164c..c6bcaaa 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2334,7 +2334,7 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
 	 * We always charge the cgroup the mm_struct belongs to.
 	 * The mm_struct's mem_cgroup changes on task migration if the
 	 * thread group leader migrates. It's possible that mm is not
-	 * set, if so charge the init_mm (happens for pagecache usage).
+	 * set, if so charge the root memcg (happens for pagecache usage).
 	 */
 	if (!*ptr && !mm)
 		*ptr = root_mem_cgroup;
@@ -2834,8 +2834,6 @@ int mem_cgroup_try_charge_swapin(struct mm_struct *mm,
 		ret = 0;
 	return ret;
 charge_cur_mm:
-	if (unlikely(!mm))
-		mm = &init_mm;
 	ret = __mem_cgroup_try_charge(mm, mask, 1, memcgp, true);
 	if (ret == -EINTR)
 		ret = 0;
@@ -2900,9 +2898,6 @@ int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 	if (PageCompound(page))
 		return 0;
 
-	if (unlikely(!mm))
-		mm = &init_mm;
-
 	if (!PageSwapCache(page))
 		ret = mem_cgroup_charge_common(page, mm, gfp_mask, type);
 	else { /* page is swapcache/shmem */
-- 
1.7.7.6

