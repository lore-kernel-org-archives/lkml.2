Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab2JNOmS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:42:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46190 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754344Ab2JNOmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:42:09 -0400
Message-Id: <20121014143551.483150486@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:44 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Josh Boyer <jwboyer@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 131/147] mempolicy: fix a memory corruption by refcount  imbalance in alloc_pages_vma()
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


