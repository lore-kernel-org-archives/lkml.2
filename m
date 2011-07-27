Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab1G0WED (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:04:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:12903 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755487Ab1G0Vsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="33043629"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: hughd@google.com, viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [39/99] mm: fix ENOSPC returned by handle_mm_fault()
Message-Id: <20110727214838.080A02403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Hugh Dickins <hughd@google.com>

commit e0dcd8a05be438b3d2e49ef61441ea3a463663f8 upstream.

Al Viro observes that in the hugetlb case, handle_mm_fault() may return
a value of the kind ENOSPC when its caller is expecting a value of the
kind VM_FAULT_SIGBUS: fix alloc_huge_page()'s failure returns.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/mm/hugetlb.c
===================================================================
--- linux-2.6.35.y.orig/mm/hugetlb.c
+++ linux-2.6.35.y/mm/hugetlb.c
@@ -1030,10 +1030,10 @@ static struct page *alloc_huge_page(stru
 	 */
 	chg = vma_needs_reservation(h, vma, addr);
 	if (chg < 0)
-		return ERR_PTR(chg);
+		return ERR_PTR(-VM_FAULT_OOM);
 	if (chg)
 		if (hugetlb_get_quota(inode->i_mapping, chg))
-			return ERR_PTR(-ENOSPC);
+			return ERR_PTR(-VM_FAULT_SIGBUS);
 
 	spin_lock(&hugetlb_lock);
 	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve);
