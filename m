Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab1FFFDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 01:03:32 -0400
Received: from smtp-out.google.com ([74.125.121.67]:43209 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570Ab1FFFDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 01:03:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=VyLZsS6Hm4da+bA/btrUPPFrNr1PIDKqnpb+Cm4DKPK6tIQuvVKqn7VCPGmdBKElLV
         bnzm9Q+h8+RK0vRfJ95A==
Date: Sun, 5 Jun 2011 22:03:13 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Mel Gorman <mel@csn.ul.ie>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] mm: fix ENOSPC returned by handle_mm_fault()
In-Reply-To: <20110605221344.GJ11521@ZenIV.linux.org.uk>
Message-ID: <alpine.LSU.2.00.1106052145370.17285@sister.anvils>
References: <20110605134317.GF11521@ZenIV.linux.org.uk> <alpine.LSU.2.00.1106051141570.5792@sister.anvils> <20110605195025.GH11521@ZenIV.linux.org.uk> <alpine.LSU.2.00.1106051339001.8317@sister.anvils> <20110605221344.GJ11521@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro observes that in the hugetlb case, handle_mm_fault() may return
a value of the kind ENOSPC when its caller is expecting a value of the
kind VM_FAULT_SIGBUS: fix alloc_huge_page()'s failure returns.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: stable@kernel.org
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- 3.0-rc1/mm/hugetlb.c	2011-05-29 18:42:37.425882575 -0700
+++ linux/mm/hugetlb.c	2011-06-05 13:33:22.795341004 -0700
@@ -1033,10 +1033,10 @@ static struct page *alloc_huge_page(stru
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
