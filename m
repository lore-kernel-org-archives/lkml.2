Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461Ab0DHTcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 15:32:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:50045 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933470Ab0DHTbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 15:31:19 -0400
Message-Id: <20100408192722.687144862@chello.nl>
User-Agent: quilt/0.47-1
Date: Thu, 08 Apr 2010 21:17:39 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 02/13] mm: Revalidate anon_vma in page_lock_anon_vma()
References: <20100408191737.296180458@chello.nl>
Content-Disposition: inline; filename=mm-page_lock_anon_vma.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is nothing preventing the anon_vma from being detached while we
are spinning to acquire the lock. Most (all?) current users end up
calling something like vma_address(page, vma) on it, which has a
fairly good chance of weeding out wonky vmas.

However suppose the anon_vma got freed and re-used while we were
waiting to acquire the lock, and the new anon_vma fits with the
page->index (because that is the only thing vma_address() uses to
determine if the page fits in a particular vma, we could end up
traversing faulty anon_vma chains.

Close this hole for good by re-validating that page->mapping still
holds the very same anon_vma pointer after we acquire the lock, if not
be utterly paranoid and retry the whole operation (which will very
likely bail, because it's unlikely the page got attached to a different
anon_vma in the meantime).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 mm/rmap.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6/mm/rmap.c
===================================================================
--- linux-2.6.orig/mm/rmap.c
+++ linux-2.6/mm/rmap.c
@@ -294,6 +294,7 @@ struct anon_vma *page_lock_anon_vma(stru
 	unsigned long anon_mapping;
 
 	rcu_read_lock();
+again:
 	anon_mapping = (unsigned long) ACCESS_ONCE(page->mapping);
 	if ((anon_mapping & PAGE_MAPPING_FLAGS) != PAGE_MAPPING_ANON)
 		goto out;
@@ -302,6 +303,12 @@ struct anon_vma *page_lock_anon_vma(stru
 
 	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
 	spin_lock(&anon_vma->lock);
+
+	if (page_rmapping(page) != anon_vma) {
+		spin_unlock(&anon_vma->lock);
+		goto again;
+	}
+
 	return anon_vma;
 out:
 	rcu_read_unlock();


