Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab2GEAqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 20:46:39 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:53389 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755977Ab2GEApm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 20:45:42 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 02/11] mm: swapfile: clean up unuse_pte race handling
Date: Thu,  5 Jul 2012 02:44:54 +0200
Message-Id: <1341449103-1986-3-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org>
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The conditional mem_cgroup_cancel_charge_swapin() is a leftover from
when the function would continue to reestablish the page even after
mem_cgroup_try_charge_swapin() failed.  After 85d9fc8 "memcg: fix
refcnt handling at swapoff", the condition is always true when this
code is reached.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/swapfile.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 64408be..75881ca 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -845,8 +845,7 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	if (unlikely(!pte_same(*pte, swp_entry_to_pte(entry)))) {
-		if (ret > 0)
-			mem_cgroup_cancel_charge_swapin(memcg);
+		mem_cgroup_cancel_charge_swapin(memcg);
 		ret = 0;
 		goto out;
 	}
-- 
1.7.7.6

