Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967966Ab2ERKWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:22:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42208 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967636Ab2ERKWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:22:52 -0400
Date: Fri, 18 May 2012 03:22:15 -0700
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Message-ID: <tip-e975d6ac08f3447d7e44851d37f7791ace6da73b@git.kernel.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        peterz@infradead.org, cl@linux.com, riel@redhat.com,
        akpm@linux-foundation.org, aarcange@redhat.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, pjt@google.com, bharata.rao@gmail.com,
        Lee.Schermerhorn@hp.com, danms@us.ibm.com
Reply-To: mingo@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, peterz@infradead.org, cl@linux.com,
        riel@redhat.com, akpm@linux-foundation.org, aarcange@redhat.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, pjt@google.com, bharata.rao@gmail.com,
        Lee.Schermerhorn@hp.com, danms@us.ibm.com
In-Reply-To: <1326380820.2442.186.camel@twins>
References: <1326380820.2442.186.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] mm/mpol: Remove NUMA_INTERLEAVE_HIT
Git-Commit-ID: e975d6ac08f3447d7e44851d37f7791ace6da73b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:22:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e975d6ac08f3447d7e44851d37f7791ace6da73b
Gitweb:     http://git.kernel.org/tip/e975d6ac08f3447d7e44851d37f7791ace6da73b
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 12 Jan 2012 16:07:00 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 17 May 2012 14:06:12 +0200

mm/mpol: Remove NUMA_INTERLEAVE_HIT

Since the NUMA_INTERLEAVE_HIT statistic is useless on its own; it wants
to be compared to either a total of interleave allocations or to a miss
count, remove it.

Fixing it would be possible, but since we've gone years without these
statistics I figure we can continue that way.

Also NUMA_HIT fully includes NUMA_INTERLEAVE_HIT so users might
switch to using that.

This cleans up some of the weird MPOL_INTERLEAVE allocation exceptions.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Paul Turner <pjt@google.com>
Cc: Dan Smith <danms@us.ibm.com>
Cc: Bharata B Rao <bharata.rao@gmail.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1326380820.2442.186.camel@twins
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/base/node.c    |    2 +-
 include/linux/mmzone.h |    1 -
 mm/mempolicy.c         |   68 +++++++++++++++---------------------------------
 3 files changed, 22 insertions(+), 49 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 90aa2a1..e7c61f3 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -169,7 +169,7 @@ static ssize_t node_read_numastat(struct device *dev,
 		       node_page_state(dev->id, NUMA_HIT),
 		       node_page_state(dev->id, NUMA_MISS),
 		       node_page_state(dev->id, NUMA_FOREIGN),
-		       node_page_state(dev->id, NUMA_INTERLEAVE_HIT),
+		       0UL,
 		       node_page_state(dev->id, NUMA_LOCAL),
 		       node_page_state(dev->id, NUMA_OTHER));
 }
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index dff7115..0440e51 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -111,7 +111,6 @@ enum zone_stat_item {
 	NUMA_HIT,		/* allocated in intended node */
 	NUMA_MISS,		/* allocated in non intended node */
 	NUMA_FOREIGN,		/* was intended here, hit elsewhere */
-	NUMA_INTERLEAVE_HIT,	/* interleaver preferred this zone */
 	NUMA_LOCAL,		/* allocation from local node */
 	NUMA_OTHER,		/* allocation from other node */
 #endif
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index cdb3b9d..82d209b 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1489,11 +1489,29 @@ static nodemask_t *policy_nodemask(gfp_t gfp, struct mempolicy *policy)
 	return NULL;
 }
 
+/* Do dynamic interleaving for a process */
+static unsigned interleave_nodes(struct mempolicy *policy)
+{
+	unsigned nid, next;
+	struct task_struct *me = current;
+
+	nid = me->il_next;
+	next = next_node(nid, policy->v.nodes);
+	if (next >= MAX_NUMNODES)
+		next = first_node(policy->v.nodes);
+	if (next < MAX_NUMNODES)
+		me->il_next = next;
+	return nid;
+}
+
 /* Return a zonelist indicated by gfp for node representing a mempolicy */
 static struct zonelist *policy_zonelist(gfp_t gfp, struct mempolicy *policy,
 	int nd)
 {
 	switch (policy->mode) {
+	case MPOL_INTERLEAVE:
+		nd = interleave_nodes(policy);
+		break;
 	case MPOL_PREFERRED:
 		if (!(policy->flags & MPOL_F_LOCAL))
 			nd = policy->v.preferred_node;
@@ -1515,21 +1533,6 @@ static struct zonelist *policy_zonelist(gfp_t gfp, struct mempolicy *policy,
 	return node_zonelist(nd, gfp);
 }
 
-/* Do dynamic interleaving for a process */
-static unsigned interleave_nodes(struct mempolicy *policy)
-{
-	unsigned nid, next;
-	struct task_struct *me = current;
-
-	nid = me->il_next;
-	next = next_node(nid, policy->v.nodes);
-	if (next >= MAX_NUMNODES)
-		next = first_node(policy->v.nodes);
-	if (next < MAX_NUMNODES)
-		me->il_next = next;
-	return nid;
-}
-
 /*
  * Depending on the memory policy provide a node from which to allocate the
  * next slab entry.
@@ -1760,21 +1763,6 @@ out:
 	return ret;
 }
 
-/* Allocate a page in interleaved policy.
-   Own path because it needs to do special accounting. */
-static struct page *alloc_page_interleave(gfp_t gfp, unsigned order,
-					unsigned nid)
-{
-	struct zonelist *zl;
-	struct page *page;
-
-	zl = node_zonelist(nid, gfp);
-	page = __alloc_pages(gfp, order, zl);
-	if (page && page_zone(page) == zonelist_zone(&zl->_zonerefs[0]))
-		inc_zone_page_state(page, NUMA_INTERLEAVE_HIT);
-	return page;
-}
-
 /**
  * 	alloc_pages_vma	- Allocate a page for a VMA.
  *
@@ -1811,17 +1799,6 @@ retry_cpuset:
 	pol = get_vma_policy(current, vma, addr);
 	cpuset_mems_cookie = read_mems_allowed_begin();
 
-	if (unlikely(pol->mode == MPOL_INTERLEAVE)) {
-		unsigned nid;
-
-		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT + order);
-		mpol_cond_put(pol);
-		page = alloc_page_interleave(gfp, order, nid);
-		if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
-			goto retry_cpuset;
-
-		return page;
-	}
 	zl = policy_zonelist(gfp, pol, node);
 	if (unlikely(mpol_needs_cond_ref(pol))) {
 		/*
@@ -1879,12 +1856,9 @@ retry_cpuset:
 	 * No reference counting needed for current->mempolicy
 	 * nor system default_policy
 	 */
-	if (pol->mode == MPOL_INTERLEAVE)
-		page = alloc_page_interleave(gfp, order, interleave_nodes(pol));
-	else
-		page = __alloc_pages_nodemask(gfp, order,
-				policy_zonelist(gfp, pol, numa_node_id()),
-				policy_nodemask(gfp, pol));
+	page = __alloc_pages_nodemask(gfp, order,
+			policy_zonelist(gfp, pol, numa_node_id()),
+			policy_nodemask(gfp, pol));
 
 	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
 		goto retry_cpuset;
