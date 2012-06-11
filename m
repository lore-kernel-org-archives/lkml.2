Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab2FKJSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 05:18:40 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:52355 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab2FKJSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 05:18:38 -0400
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@google.com>,
        Dave Jones <davej@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Christoph Lameter <cl@linux.com>, stable@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miao Xie <miaox@cn.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 5/6] mempolicy: fix a memory corruption by refcount imbalance in alloc_pages_vma()
Date: Mon, 11 Jun 2012 05:17:29 -0400
Message-Id: <1339406250-10169-6-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1339406250-10169-1-git-send-email-kosaki.motohiro@gmail.com>
References: <1339406250-10169-1-git-send-email-kosaki.motohiro@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit cc9a6c8776 (cpuset: mm: reduce large amounts of memory barrier related
damage v3) introduced a memory corruption.

shmem_alloc_page() passes pseudo vma and it has one significant unique
combination, vma->vm_ops=NULL and (vma->policy->flags & MPOL_F_SHARED).

Now, get_vma_policy() does NOT increase a policy ref when vma->vm_ops=NULL
and mpol_cond_put() DOES decrease a policy ref when a policy has MPOL_F_SHARED.
Therefore, when alloc_pages_vma() goes 'goto retry_cpuset' path, a policy
refcount will be decreased too much and therefore it will make a memory corruption.

This patch fixes it.

Cc: Dave Jones <davej@redhat.com>,
Cc: Mel Gorman <mgorman@suse.de>
Cc: Christoph Lameter <cl@linux.com>,
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
---
 mm/mempolicy.c |   13 ++++++++++++-
 mm/shmem.c     |    9 +++++----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 7fb7d51..0da0969 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1544,18 +1544,29 @@ struct mempolicy *get_vma_policy(struct task_struct *task,
 		struct vm_area_struct *vma, unsigned long addr)
 {
 	struct mempolicy *pol = task->mempolicy;
+	int got_ref;
 
 	if (vma) {
 		if (vma->vm_ops && vma->vm_ops->get_policy) {
 			struct mempolicy *vpol = vma->vm_ops->get_policy(vma,
 									addr);
-			if (vpol)
+			if (vpol) {
 				pol = vpol;
+				got_ref = 1;
+			}
 		} else if (vma->vm_policy)
 			pol = vma->vm_policy;
 	}
 	if (!pol)
 		pol = &default_policy;
+
+	/*
+	 * shmem_alloc_page() passes MPOL_F_SHARED policy with vma->vm_ops=NULL.
+	 * Thus, we need to take additional ref for avoiding refcount imbalance.
+	 */
+	if (!got_ref && mpol_needs_cond_ref(pol))
+		mpol_get(pol);
+
 	return pol;
 }
 
diff --git a/mm/shmem.c b/mm/shmem.c
index d576b84..eb5f1eb 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -919,6 +919,7 @@ static struct page *shmem_alloc_page(gfp_t gfp,
 			struct shmem_inode_info *info, pgoff_t index)
 {
 	struct vm_area_struct pvma;
+	struct page *page;
 
 	/* Create a pseudo vma that just contains the policy */
 	pvma.vm_start = 0;
@@ -926,10 +927,10 @@ static struct page *shmem_alloc_page(gfp_t gfp,
 	pvma.vm_ops = NULL;
 	pvma.vm_policy = mpol_shared_policy_lookup(&info->policy, index);
 
-	/*
-	 * alloc_page_vma() will drop the shared policy reference
-	 */
-	return alloc_page_vma(gfp, &pvma, 0);
+	page = alloc_page_vma(gfp, &pvma, 0);
+
+	mpol_put(pvma.vm_policy);
+	return page;
 }
 #else /* !CONFIG_NUMA */
 #ifdef CONFIG_TMPFS
-- 
1.7.1

