Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422663Ab2LGATv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 19:19:51 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61623 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528Ab2LGATr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:19:47 -0500
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: [PATCH 5/9] numa, mm, sched: Fix NUMA affinity tracking logic
Date: Fri,  7 Dec 2012 01:19:22 +0100
Message-Id: <1354839566-15697-6-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354839566-15697-1-git-send-email-mingo@kernel.org>
References: <1354839566-15697-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for the p->numa_policy affinity tracking by the scheduler
went missing during the mm/ unification: revive and integrate it
properly.

( This in particular fixes NUMA_POLICY_MANYBUDDIES, which
  bug caused a few regressions in various workloads such as
  numa01 and regressed !THP workloads in particular. )

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/mempolicy.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 2f2095c..6bb9fd0 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -121,8 +121,10 @@ static struct mempolicy default_policy_local = {
 static struct mempolicy *default_policy(void)
 {
 #ifdef CONFIG_NUMA_BALANCING
-	if (task_numa_shared(current) == 1)
-		return &current->numa_policy;
+	struct mempolicy *pol = &current->numa_policy;
+
+	if (task_numa_shared(current) == 1 && nodes_weight(pol->v.nodes) >= 2)
+		return pol;
 #endif
 	return &default_policy_local;
 }
@@ -135,6 +137,11 @@ static struct mempolicy *get_task_policy(struct task_struct *p)
 	int node;
 
 	if (!pol) {
+#ifdef CONFIG_NUMA_BALANCING
+		pol = default_policy();
+		if (pol != &default_policy_local)
+			return pol;
+#endif
 		node = numa_node_id();
 		if (node != -1)
 			pol = &preferred_node_policy[node];
@@ -2367,7 +2374,8 @@ int mpol_misplaced(struct page *page, struct vm_area_struct *vma, unsigned long
 			shift = PAGE_SHIFT;
 
 		target_node = interleave_nid(pol, vma, addr, shift);
-		break;
+
+		goto out_keep_page;
 	}
 
 	case MPOL_PREFERRED:
-- 
1.7.11.7

