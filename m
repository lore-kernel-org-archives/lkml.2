Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab0H1O2T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 10:28:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:42776 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab0H1O1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 10:27:48 -0400
Message-Id: <20100828142455.531096778@chello.nl>
User-Agent: quilt/0.47-1
Date: Sat, 28 Aug 2010 16:16:39 +0200
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
Subject: [PATCH 02/20] mm: Improve page_lock_anon_vma() comment
References: <20100828141637.421594670@chello.nl>
Content-Disposition: inline; filename=mm-page_lock_anon_vma-comment.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A slightly more verbose comment to go along with the trickery in
page_lock_anon_vma().

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Mel Gorman <mel@csn.ul.ie>
LKML-Reference: <1271158226.4807.1107.camel@twins>
---
 mm/rmap.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/rmap.c
===================================================================
--- linux-2.6.orig/mm/rmap.c
+++ linux-2.6/mm/rmap.c
@@ -311,8 +311,22 @@ void __init anon_vma_init(void)
 }
 
 /*
- * Getting a lock on a stable anon_vma from a page off the LRU is
- * tricky: page_lock_anon_vma rely on RCU to guard against the races.
+ * Getting a lock on a stable anon_vma from a page off the LRU is tricky!
+ *
+ * Since there is no serialization what so ever against page_remove_rmap()
+ * the best this function can do is return a locked anon_vma that might
+ * have been relevant to this page.
+ *
+ * The page might have been remapped to a different anon_vma or the anon_vma
+ * returned may already be freed (and even reused).
+ *
+ * All users of this function must be very careful when walking the anon_vma
+ * chain and verify that the page in question is indeed mapped in it
+ * [ something equivalent to page_mapped_in_vma() ].
+ *
+ * Since anon_vma's slab is DESTROY_BY_RCU and we know from page_remove_rmap()
+ * that the anon_vma pointer from page->mapping is valid if there is a
+ * mapcount, we can dereference the anon_vma after observing those.
  */
 struct anon_vma *page_lock_anon_vma(struct page *page)
 {


