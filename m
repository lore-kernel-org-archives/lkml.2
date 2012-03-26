Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab2CZK5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 06:57:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:58394 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757183Ab2CZK5H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 06:57:07 -0400
Message-ID: <1332759384.16159.92.camel@twins>
Subject: Re: [PATCH] cpuset: mm: Reduce large amounts of memory barrier
 related damage v3
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Miao Xie <miaox@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Mon, 26 Mar 2012 12:56:24 +0200
In-Reply-To: <20120307180852.GE17697@suse.de>
References: <20120307180852.GE17697@suse.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-07 at 18:08 +0000, Mel Gorman wrote:
> +               } while (!put_mems_allowed(cpuset_mems_cookie) && !page);

Sorry for only noticing this now, but wouldn't it be better to first
check page and only then bother with the put_mems_allowed() thing? That
avoids the smp_rmb() and seqcount conditional all together in the likely
case the allocation actually succeeded.

---
Subject: mm: Optimize put_mems_allowed() usage

Avoid calling put_mems_allowed() in case the page allocation succeeded.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/cpuset.h |    2 +-
 mm/filemap.c           |    2 +-
 mm/hugetlb.c           |    2 +-
 mm/mempolicy.c         |    6 +++---
 mm/page_alloc.c        |    2 +-
 mm/slab.c              |    2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 7a7e5fd..f666b99 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -107,7 +107,7 @@ static inline unsigned int get_mems_allowed(void)
  */
 static inline bool put_mems_allowed(unsigned int seq)
 {
-	return !read_seqcount_retry(&current->mems_allowed_seq, seq);
+	return likely(!read_seqcount_retry(&current->mems_allowed_seq, seq));
 }
 
 static inline void set_mems_allowed(nodemask_t nodemask)
diff --git a/mm/filemap.c b/mm/filemap.c
index c3811bc..3b41553 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -504,7 +504,7 @@ struct page *__page_cache_alloc(gfp_t gfp)
 			cpuset_mems_cookie = get_mems_allowed();
 			n = cpuset_mem_spread_node();
 			page = alloc_pages_exact_node(n, gfp, 0);
-		} while (!put_mems_allowed(cpuset_mems_cookie) && !page);
+		} while (!page && !put_mems_allowed(cpuset_mems_cookie));
 
 		return page;
 	}
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b8ce6f4..25250c9 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -570,7 +570,7 @@ static struct page *dequeue_huge_page_vma(struct hstate *h,
 	}
 
 	mpol_cond_put(mpol);
-	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
+	if (unlikely(!page && !put_mems_allowed(cpuset_mems_cookie)))
 		goto retry_cpuset;
 	return page;
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index cfb6c86..6010eef 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1865,7 +1865,7 @@ alloc_pages_vma(gfp_t gfp, int order, struct vm_area_struct *vma,
 		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT + order);
 		mpol_cond_put(pol);
 		page = alloc_page_interleave(gfp, order, nid);
-		if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
+		if (unlikely(!page && !put_mems_allowed(cpuset_mems_cookie)))
 			goto retry_cpuset;
 
 		return page;
@@ -1878,7 +1878,7 @@ alloc_pages_vma(gfp_t gfp, int order, struct vm_area_struct *vma,
 		struct page *page =  __alloc_pages_nodemask(gfp, order,
 						zl, policy_nodemask(gfp, pol));
 		__mpol_put(pol);
-		if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
+		if (unlikely(!page && !put_mems_allowed(cpuset_mems_cookie)))
 			goto retry_cpuset;
 		return page;
 	}
@@ -1887,7 +1887,7 @@ alloc_pages_vma(gfp_t gfp, int order, struct vm_area_struct *vma,
 	 */
 	page = __alloc_pages_nodemask(gfp, order, zl,
 				      policy_nodemask(gfp, pol));
-	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
+	if (unlikely(!page && !put_mems_allowed(cpuset_mems_cookie)))
 		goto retry_cpuset;
 	return page;
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index caea788..96acea4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2429,7 +2429,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 	 * the mask is being updated. If a page allocation is about to fail,
 	 * check if the cpuset changed during allocation and if so, retry.
 	 */
-	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
+	if (unlikely(!page && !put_mems_allowed(cpuset_mems_cookie)))
 		goto retry_cpuset;
 
 	return page;
diff --git a/mm/slab.c b/mm/slab.c
index 29c8716..7d320b5 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3374,7 +3374,7 @@ static void *fallback_alloc(struct kmem_cache *cache, gfp_t flags)
 		}
 	}
 
-	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !obj))
+	if (unlikely(!obj && !put_mems_allowed(cpuset_mems_cookie)))
 		goto retry_cpuset;
 	return obj;
 }

