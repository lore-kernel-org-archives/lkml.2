Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab2FKJSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 05:18:17 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40634 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab2FKJSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 05:18:15 -0400
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@google.com>,
        Dave Jones <davej@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Christoph Lameter <cl@linux.com>, stable@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 1/6] Revert "mm: mempolicy: Let vma_merge and vma_split handle vma->vm_policy linkages"
Date: Mon, 11 Jun 2012 05:17:25 -0400
Message-Id: <1339406250-10169-2-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1339406250-10169-1-git-send-email-kosaki.motohiro@gmail.com>
References: <1339406250-10169-1-git-send-email-kosaki.motohiro@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>

commit 05f144a0d5 "mm: mempolicy: Let vma_merge and vma_split handle
vma->vm_policy linkages" removed a vma->vm_policy updates. But it is
a primary purpose of mbind_range(). Now, mbind(2) is no-op in several
case unintentionally. It is not ideal fix. This patch reverts it.

Cc: Dave Jones <davej@redhat.com>,
Cc: Mel Gorman <mgorman@suse.de>
Cc: Christoph Lameter <cl@linux.com>,
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/mempolicy.c |   41 ++++++++++++++++++++++++-----------------
 1 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index f15c1b2..0a60def 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -607,6 +607,27 @@ check_range(struct mm_struct *mm, unsigned long start, unsigned long end,
 	return first;
 }
 
+/* Apply policy to a single VMA */
+static int policy_vma(struct vm_area_struct *vma, struct mempolicy *new)
+{
+	int err = 0;
+	struct mempolicy *old = vma->vm_policy;
+
+	pr_debug("vma %lx-%lx/%lx vm_ops %p vm_file %p set_policy %p\n",
+		 vma->vm_start, vma->vm_end, vma->vm_pgoff,
+		 vma->vm_ops, vma->vm_file,
+		 vma->vm_ops ? vma->vm_ops->set_policy : NULL);
+
+	if (vma->vm_ops && vma->vm_ops->set_policy)
+		err = vma->vm_ops->set_policy(vma, new);
+	if (!err) {
+		mpol_get(new);
+		vma->vm_policy = new;
+		mpol_put(old);
+	}
+	return err;
+}
+
 /* Step 2: apply policy to a range and do splits. */
 static int mbind_range(struct mm_struct *mm, unsigned long start,
 		       unsigned long end, struct mempolicy *new_pol)
@@ -655,23 +676,9 @@ static int mbind_range(struct mm_struct *mm, unsigned long start,
 			if (err)
 				goto out;
 		}
-
-		/*
-		 * Apply policy to a single VMA. The reference counting of
-		 * policy for vma_policy linkages has already been handled by
-		 * vma_merge and split_vma as necessary. If this is a shared
-		 * policy then ->set_policy will increment the reference count
-		 * for an sp node.
-		 */
-		pr_debug("vma %lx-%lx/%lx vm_ops %p vm_file %p set_policy %p\n",
-			vma->vm_start, vma->vm_end, vma->vm_pgoff,
-			vma->vm_ops, vma->vm_file,
-			vma->vm_ops ? vma->vm_ops->set_policy : NULL);
-		if (vma->vm_ops && vma->vm_ops->set_policy) {
-			err = vma->vm_ops->set_policy(vma, new_pol);
-			if (err)
-				goto out;
-		}
+		err = policy_vma(vma, new_pol);
+		if (err)
+			goto out;
 	}
 
  out:
-- 
1.7.1

