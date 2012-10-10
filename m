Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933578Ab2JKA3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:29:06 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37716 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933463Ab2JKAZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:25:37 -0400
X-Sasl-enc: nXX1IGi/ny19GwLO1+T02ZqjcR2kCIu7BjggJMhtzNAn 1349915136
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Christoph Lameter <cl@linux.com>,
        Josh Boyer <jwboyer@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 103/122] mempolicy: fix a memory corruption by refcount imbalance in alloc_pages_vma()
Date: Thu, 11 Oct 2012 07:54:29 +0900
Message-Id: <20121010225356.581245289@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/mempolicy.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1552,8 +1552,18 @@ struct mempolicy *get_vma_policy(struct
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


