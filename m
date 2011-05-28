Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab1E1URI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 16:17:08 -0400
Received: from smtp-out.google.com ([216.239.44.51]:51257 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab1E1URF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 16:17:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=APBq06QNCe1EWL5jLFAsOOI6/VbsZFO7sqJyttIVBtp7WD9foxW+GooJDzbogGshns
         MLbDCclvbxDFGNQoucfA==
Date: Sat, 28 May 2011 13:17:04 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shaohua.li@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH] mm: fix kernel BUG at mm/rmap.c:1017!
Message-ID: <alpine.LSU.2.00.1105281314220.13319@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've hit the "address >= vma->vm_end" check in do_page_add_anon_rmap()
just once.  The stack showed khugepaged allocation trying to compact
pages: the call to page_add_anon_rmap() coming from remove_migration_pte().

That path holds anon_vma lock, but does not hold mmap_sem: it can
therefore race with a split_vma(), and in commit 5f70b962ccc2 "mmap:
avoid unnecessary anon_vma lock" we just took away the anon_vma lock
protection when adjusting vma->vm_end.

I don't think that particular BUG_ON ever caught anything interesting,
so better replace it by a comment, than reinstate the anon_vma locking.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/rmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux.orig/mm/rmap.c	2011-05-27 19:05:27.000000000 -0700
+++ linux/mm/rmap.c	2011-05-27 20:07:44.601361236 -0700
@@ -1014,7 +1014,7 @@ void do_page_add_anon_rmap(struct page *
 		return;
 
 	VM_BUG_ON(!PageLocked(page));
-	VM_BUG_ON(address < vma->vm_start || address >= vma->vm_end);
+	/* address might be in next vma when migration races vma_adjust */
 	if (first)
 		__page_set_anon_rmap(page, vma, address, exclusive);
 	else
@@ -1709,7 +1709,7 @@ void hugepage_add_anon_rmap(struct page
 
 	BUG_ON(!PageLocked(page));
 	BUG_ON(!anon_vma);
-	BUG_ON(address < vma->vm_start || address >= vma->vm_end);
+	/* address might be in next vma when migration races vma_adjust */
 	first = atomic_inc_and_test(&page->_mapcount);
 	if (first)
 		__hugepage_set_anon_rmap(page, vma, address, 0);
