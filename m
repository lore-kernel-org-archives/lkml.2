Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab0H1O2b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 10:28:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47782 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab0H1O1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 10:27:53 -0400
Message-Id: <20100828142455.810694185@chello.nl>
User-Agent: quilt/0.47-1
Date: Sat, 28 Aug 2010 16:16:43 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 06/20] mm: Use refcounts for page_lock_anon_vma()
References: <20100828141637.421594670@chello.nl>
Content-Disposition: inline; filename=mm-ref-page_lock_anon_vma.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert page_lock_anon_vma() over to use refcounts. This is
done for each of convertion of anon_vma from spinlock to mutex.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 mm/rmap.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

Index: linux-2.6/mm/rmap.c
===================================================================
--- linux-2.6.orig/mm/rmap.c
+++ linux-2.6/mm/rmap.c
@@ -332,9 +332,9 @@ void __init anon_vma_init(void)
  * that the anon_vma pointer from page->mapping is valid if there is a
  * mapcount, we can dereference the anon_vma after observing those.
  */
-struct anon_vma *page_lock_anon_vma(struct page *page)
+struct anon_vma *page_get_anon_vma(struct page *page)
 {
-	struct anon_vma *anon_vma;
+	struct anon_vma *anon_vma = NULL;
 	unsigned long anon_mapping;
 
 	rcu_read_lock();
@@ -345,17 +345,28 @@ struct anon_vma *page_lock_anon_vma(stru
 		goto out;
 
 	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
-	anon_vma_lock(anon_vma);
-	return anon_vma;
+	if (!atomic_inc_not_zero(&anon_vma->refcount))
+		anon_vma = NULL;
 out:
 	rcu_read_unlock();
-	return NULL;
+
+	return anon_vma;
+}
+
+struct anon_vma *page_lock_anon_vma(struct page *page)
+{
+	struct anon_vma *anon_vma = page_get_anon_vma(page);
+
+	if (anon_vma)
+		anon_vma_lock(anon_vma);
+
+	return anon_vma;
 }
 
 void page_unlock_anon_vma(struct anon_vma *anon_vma)
 {
 	anon_vma_unlock(anon_vma);
-	rcu_read_unlock();
+	put_anon_vma(anon_vma);
 }
 
 /*


