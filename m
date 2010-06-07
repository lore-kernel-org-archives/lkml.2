Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab0FGLUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 07:20:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:41224 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab0FGLUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 07:20:06 -0400
Message-Id: <20100607111406.850090352@chello.nl>
User-Agent: quilt/0.48-1
Date: Mon, 07 Jun 2010 13:06:59 +0200
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
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 05/28] track the root (oldest) anon_vma
References: <20100607110654.606530953@chello.nl>
Content-Disposition: inline; filename=riel-03-mm-track_the_root__oldest__anon_vma.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Track the root (oldest) anon_vma in each anon_vma tree.   Because we only
take the lock on the root anon_vma, we cannot use the lock on higher-up
anon_vmas to lock anything.  This makes it impossible to do an indirect
lookup of the root anon_vma, since the data structures could go away from
under us.

However, a direct pointer is safe because the root anon_vma is always the
last one that gets freed on munmap or exit, by virtue of the same_vma list
order and unlink_anon_vmas walking the list forward.

Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100526154010.3904df5c@annuminas.surriel.com>
---
 include/linux/rmap.h |    1 +
 mm/rmap.c            |   18 ++++++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/rmap.h
===================================================================
--- linux-2.6.orig/include/linux/rmap.h
+++ linux-2.6/include/linux/rmap.h
@@ -26,6 +26,7 @@
  */
 struct anon_vma {
 	spinlock_t lock;	/* Serialize access to vma list */
+	struct anon_vma *root;	/* Root of this anon_vma tree */
 #if defined(CONFIG_KSM) || defined(CONFIG_MIGRATION)
 
 	/*
Index: linux-2.6/mm/rmap.c
===================================================================
--- linux-2.6.orig/mm/rmap.c
+++ linux-2.6/mm/rmap.c
@@ -132,6 +132,11 @@ int anon_vma_prepare(struct vm_area_stru
 			if (unlikely(!anon_vma))
 				goto out_enomem_free_avc;
 			allocated = anon_vma;
+			/*
+			 * This VMA had no anon_vma yet.  This anon_vma is
+			 * the root of any anon_vma tree that might form.
+			 */
+			anon_vma->root = anon_vma;
 		}
 
 		anon_vma_lock(anon_vma);
@@ -224,9 +229,15 @@ int anon_vma_fork(struct vm_area_struct 
 	avc = anon_vma_chain_alloc();
 	if (!avc)
 		goto out_error_free_anon_vma;
-	anon_vma_chain_link(vma, avc, anon_vma);
+
+	/*
+	 * The root anon_vm's spinlock is the lock actually used when we
+	 * lock any of the anon_vmas in this anon_vma tree.
+	 */
+	anon_vma->root = pvma->anon_vma->root;
 	/* Mark this anon_vma as the one where our new (COWed) pages go. */
 	vma->anon_vma = anon_vma;
+	anon_vma_chain_link(vma, avc, anon_vma);
 
 	return 0;
 
@@ -261,7 +272,10 @@ void unlink_anon_vmas(struct vm_area_str
 {
 	struct anon_vma_chain *avc, *next;
 
-	/* Unlink each anon_vma chained to the VMA. */
+	/*
+	 * Unlink each anon_vma chained to the VMA.  This list is ordered
+	 * from newest to oldest, ensuring the root anon_vma gets freed last.
+	 */
 	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
 		anon_vma_unlink(avc);
 		list_del(&avc->same_vma);


