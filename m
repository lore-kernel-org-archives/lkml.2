Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161057Ab2ERKVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:21:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42165 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757060Ab2ERKU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:20:56 -0400
Date: Fri, 18 May 2012 03:20:35 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-2ab41dd599228532afc0d5920f82e6378ec1c5f3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, cl@linux.com, akpm@linux-foundation.org,
        mgorman@suse.de, tglx@linutronix.de, rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, cl@linux.com, akpm@linux-foundation.org,
        mgorman@suse.de, tglx@linutronix.de, rientjes@google.com
In-Reply-To: <1332759384.16159.92.camel@twins>
References: <1332759384.16159.92.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] mm: Optimize put_mems_allowed() usage
Git-Commit-ID: 2ab41dd599228532afc0d5920f82e6378ec1c5f3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:20:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2ab41dd599228532afc0d5920f82e6378ec1c5f3
Gitweb:     http://git.kernel.org/tip/2ab41dd599228532afc0d5920f82e6378ec1c5f3
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 26 Mar 2012 14:13:05 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 17 May 2012 14:06:12 +0200

mm: Optimize put_mems_allowed() usage

Since put_mems_allowed() is strictly optional, its a seqcount retry,
we don't need to evaluate the function if the allocation was in fact
successful, saving a smp_rmb some loads and comparisons on some
relative fast-paths.

Since the naming, get/put_mems_allowed() does suggest a mandatory
pairing, rename the interface, as suggested by Mel, to resemble the
seqcount interface.

This gives us: read_mems_allowed_begin() and
read_mems_allowed_retry(), where it is important to note that the
return value of the latter call is inverted from its previous
incarnation.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Link: http://lkml.kernel.org/r/1332759384.16159.92.camel@twins
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/cpuset.h |   27 ++++++++++++++-------------
 kernel/cpuset.c        |    2 +-
 mm/filemap.c           |    4 ++--
 mm/hugetlb.c           |    4 ++--
 mm/mempolicy.c         |   14 +++++++-------
 mm/page_alloc.c        |    8 ++++----
 mm/slab.c              |    4 ++--
 mm/slub.c              |   16 +++-------------
 8 files changed, 35 insertions(+), 44 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 668f66b..4052564 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -89,25 +89,26 @@ extern void rebuild_sched_domains(void);
 extern void cpuset_print_task_mems_allowed(struct task_struct *p);
 
 /*
- * get_mems_allowed is required when making decisions involving mems_allowed
- * such as during page allocation. mems_allowed can be updated in parallel
- * and depending on the new value an operation can fail potentially causing
- * process failure. A retry loop with get_mems_allowed and put_mems_allowed
- * prevents these artificial failures.
+ * read_mems_allowed_begin is required when making decisions involving
+ * mems_allowed such as during page allocation. mems_allowed can be updated in
+ * parallel and depending on the new value an operation can fail potentially
+ * causing process failure. A retry loop with read_mems_allowed_begin and
+ * read_mems_allowed_retry prevents these artificial failures.
  */
-static inline unsigned int get_mems_allowed(void)
+static inline unsigned int read_mems_allowed_begin(void)
 {
 	return read_seqcount_begin(&current->mems_allowed_seq);
 }
 
 /*
- * If this returns false, the operation that took place after get_mems_allowed
- * may have failed. It is up to the caller to retry the operation if
+ * If this returns true, the operation that took place after
+ * read_mems_allowed_begin may have failed artificially due to a concurrent
+ * update of mems_allowed. It is up to the caller to retry the operation if
  * appropriate.
  */
-static inline bool put_mems_allowed(unsigned int seq)
+static inline bool read_mems_allowed_retry(unsigned int seq)
 {
-	return !read_seqcount_retry(&current->mems_allowed_seq, seq);
+	return read_seqcount_retry(&current->mems_allowed_seq, seq);
 }
 
 static inline void set_mems_allowed(nodemask_t nodemask)
@@ -223,14 +224,14 @@ static inline void set_mems_allowed(nodemask_t nodemask)
 {
 }
 
-static inline unsigned int get_mems_allowed(void)
+static inline unsigned int read_mems_allowed_begin(void)
 {
 	return 0;
 }
 
-static inline bool put_mems_allowed(unsigned int seq)
+static inline bool read_mems_allowed_retry(unsigned int seq)
 {
-	return true;
+	return false;
 }
 
 #endif /* !CONFIG_CPUSETS */
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 14f7070..a9ac50d 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -976,7 +976,7 @@ static void cpuset_change_task_nodemask(struct task_struct *tsk,
 	task_lock(tsk);
 	/*
 	 * Determine if a loop is necessary if another thread is doing
-	 * get_mems_allowed().  If at least one node remains unchanged and
+	 * read_mems_allowed_begin().  If at least one node remains unchanged and
 	 * tsk does not have a mempolicy, then an empty nodemask will not be
 	 * possible when mems_allowed is larger than a word.
 	 */
diff --git a/mm/filemap.c b/mm/filemap.c
index 79c4b2b..800c592 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -501,10 +501,10 @@ struct page *__page_cache_alloc(gfp_t gfp)
 	if (cpuset_do_page_mem_spread()) {
 		unsigned int cpuset_mems_cookie;
 		do {
-			cpuset_mems_cookie = get_mems_allowed();
+			cpuset_mems_cookie = read_mems_allowed_begin();
 			n = cpuset_mem_spread_node();
 			page = alloc_pages_exact_node(n, gfp, 0);
-		} while (!put_mems_allowed(cpuset_mems_cookie) && !page);
+		} while (!page && read_mems_allowed_retry(cpuset_mems_cookie));
 
 		return page;
 	}
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 5a16423..35f315c 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -541,7 +541,7 @@ static struct page *dequeue_huge_page_vma(struct hstate *h,
 	unsigned int cpuset_mems_cookie;
 
 retry_cpuset:
-	cpuset_mems_cookie = get_mems_allowed();
+	cpuset_mems_cookie = read_mems_allowed_begin();
 	zonelist = huge_zonelist(vma, address,
 					htlb_alloc_mask, &mpol, &nodemask);
 	/*
@@ -570,7 +570,7 @@ retry_cpuset:
 	}
 
 	mpol_cond_put(mpol);
-	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
+	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
 		goto retry_cpuset;
 	return page;
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index b195691..1a51b7f 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1695,7 +1695,7 @@ int node_random(const nodemask_t *maskp)
  * If the effective policy is 'BIND, returns a pointer to the mempolicy's
  * @nodemask for filtering the zonelist.
  *
- * Must be protected by get_mems_allowed()
+ * Must be protected by read_mems_allowed_begin()
  */
 struct zonelist *huge_zonelist(struct vm_area_struct *vma, unsigned long addr,
 				gfp_t gfp_flags, struct mempolicy **mpol,
@@ -1860,7 +1860,7 @@ alloc_pages_vma(gfp_t gfp, int order, struct vm_area_struct *vma,
 
 retry_cpuset:
 	pol = get_vma_policy(current, vma, addr);
-	cpuset_mems_cookie = get_mems_allowed();
+	cpuset_mems_cookie = read_mems_allowed_begin();
 
 	if (unlikely(pol->mode == MPOL_INTERLEAVE)) {
 		unsigned nid;
@@ -1868,7 +1868,7 @@ retry_cpuset:
 		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT + order);
 		mpol_cond_put(pol);
 		page = alloc_page_interleave(gfp, order, nid);
-		if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
+		if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
 			goto retry_cpuset;
 
 		return page;
@@ -1881,7 +1881,7 @@ retry_cpuset:
 		struct page *page =  __alloc_pages_nodemask(gfp, order,
 						zl, policy_nodemask(gfp, pol));
 		__mpol_put(pol);
-		if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
+		if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
 			goto retry_cpuset;
 		return page;
 	}
@@ -1890,7 +1890,7 @@ retry_cpuset:
 	 */
 	page = __alloc_pages_nodemask(gfp, order, zl,
 				      policy_nodemask(gfp, pol));
-	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
+	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
 		goto retry_cpuset;
 	return page;
 }
@@ -1924,7 +1924,7 @@ struct page *alloc_pages_current(gfp_t gfp, unsigned order)
 		pol = &default_policy;
 
 retry_cpuset:
-	cpuset_mems_cookie = get_mems_allowed();
+	cpuset_mems_cookie = read_mems_allowed_begin();
 
 	/*
 	 * No reference counting needed for current->mempolicy
@@ -1937,7 +1937,7 @@ retry_cpuset:
 				policy_zonelist(gfp, pol, numa_node_id()),
 				policy_nodemask(gfp, pol));
 
-	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
+	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
 		goto retry_cpuset;
 
 	return page;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a712fb9..ccc75cc 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2442,7 +2442,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 		return NULL;
 
 retry_cpuset:
-	cpuset_mems_cookie = get_mems_allowed();
+	cpuset_mems_cookie = read_mems_allowed_begin();
 
 	/* The preferred zone is used for statistics later */
 	first_zones_zonelist(zonelist, high_zoneidx,
@@ -2469,7 +2469,7 @@ out:
 	 * the mask is being updated. If a page allocation is about to fail,
 	 * check if the cpuset changed during allocation and if so, retry.
 	 */
-	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
+	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
 		goto retry_cpuset;
 
 	return page;
@@ -2691,9 +2691,9 @@ bool skip_free_areas_node(unsigned int flags, int nid)
 		goto out;
 
 	do {
-		cpuset_mems_cookie = get_mems_allowed();
+		cpuset_mems_cookie = read_mems_allowed_begin();
 		ret = !node_isset(nid, cpuset_current_mems_allowed);
-	} while (!put_mems_allowed(cpuset_mems_cookie));
+	} while (read_mems_allowed_retry(cpuset_mems_cookie));
 out:
 	return ret;
 }
diff --git a/mm/slab.c b/mm/slab.c
index e901a36..5070f96 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3367,7 +3367,7 @@ static void *fallback_alloc(struct kmem_cache *cache, gfp_t flags)
 	local_flags = flags & (GFP_CONSTRAINT_MASK|GFP_RECLAIM_MASK);
 
 retry_cpuset:
-	cpuset_mems_cookie = get_mems_allowed();
+	cpuset_mems_cookie = read_mems_allowed_begin();
 	zonelist = node_zonelist(slab_node(current->mempolicy), flags);
 
 retry:
@@ -3423,7 +3423,7 @@ retry:
 		}
 	}
 
-	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !obj))
+	if (unlikely(!obj && read_mems_allowed_retry(cpuset_mems_cookie)))
 		goto retry_cpuset;
 	return obj;
 }
diff --git a/mm/slub.c b/mm/slub.c
index ffe13fd..4b0e61f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1613,7 +1613,7 @@ static struct page *get_any_partial(struct kmem_cache *s, gfp_t flags,
 		return NULL;
 
 	do {
-		cpuset_mems_cookie = get_mems_allowed();
+		cpuset_mems_cookie = read_mems_allowed_begin();
 		zonelist = node_zonelist(slab_node(current->mempolicy), flags);
 		for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
 			struct kmem_cache_node *n;
@@ -1623,21 +1623,11 @@ static struct page *get_any_partial(struct kmem_cache *s, gfp_t flags,
 			if (n && cpuset_zone_allowed_hardwall(zone, flags) &&
 					n->nr_partial > s->min_partial) {
 				object = get_partial_node(s, n, c);
-				if (object) {
-					/*
-					 * Return the object even if
-					 * put_mems_allowed indicated that
-					 * the cpuset mems_allowed was
-					 * updated in parallel. It's a
-					 * harmless race between the alloc
-					 * and the cpuset update.
-					 */
-					put_mems_allowed(cpuset_mems_cookie);
+				if (object)
 					return object;
-				}
 			}
 		}
-	} while (!put_mems_allowed(cpuset_mems_cookie));
+	} while (read_mems_allowed_retry(cpuset_mems_cookie));
 #endif
 	return NULL;
 }
