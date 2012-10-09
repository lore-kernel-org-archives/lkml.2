Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab2JIQ7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 12:59:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53590 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab2JIQ6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 12:58:49 -0400
From: Mel Gorman <mgorman@suse.de>
To: Stable <stable@vger.kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Jones <davej@redhat.com>, Christoph Lameter <cl@linux.com>,
        Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 5/5] mempolicy: fix a memory corruption by refcount imbalance in alloc_pages_vma()
Date: Tue,  9 Oct 2012 17:58:41 +0100
Message-Id: <1349801921-16598-6-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1349801921-16598-1-git-send-email-mgorman@suse.de>
References: <1349801921-16598-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 00442ad04a5eac08a98255697c510e708f6082e2 upstream.

Commit cc9a6c877661 ("cpuset: mm: reduce large amounts of memory barrier
related damage v3") introduced a potential memory corruption.
shmem_alloc_page() uses a pseudo vma and it has one significant unique
combination, vma->vm_ops=NULL and vma->policy->flags & MPOL_F_SHARED.

get_vma_policy() does NOT increase a policy ref when vma->vm_ops=NULL
and mpol_cond_put() DOES decrease a policy ref when a policy has
MPOL_F_SHARED.  Therefore, when a cpuset update race occurs,
alloc_pages_vma() falls in 'goto retry_cpuset' path, decrements the
reference count and frees the policy prematurely.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Christoph Lameter <cl@linux.com>
Cc: Josh Boyer <jwboyer@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/mempolicy.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 1763418..3d64b36 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1552,8 +1552,18 @@ struct mempolicy *get_vma_policy(struct task_struct *task,
 									addr);
 			if (vpol)
 				pol = vpol;
-		} else if (vma->vm_policy)
+		} else if (vma->vm_policy) {
 			pol = vma->vm_policy;
+
+			/*
+			 * shmem_alloc_page() passes MPOL_F_SHARED policy with
+			 * a pseudo vma whose vma->vm_ops=NULL. Take a reference
+			 * count on these policies which will be dropped by
+			 * mpol_cond_put() later
+			 */
+			if (mpol_needs_cond_ref(pol))
+				mpol_get(pol);
+		}
 	}
 	if (!pol)
 		pol = &default_policy;
-- 
1.7.9.2

