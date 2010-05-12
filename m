Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab0ELRmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 13:42:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab0ELRmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 13:42:08 -0400
Date: Wed, 12 May 2010 13:39:58 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrea Arcangeli <aarcange@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>, Linux-MM <linux-mm@kvack.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3/5] track the root (oldest) anon_vma
Message-ID: <20100512133958.3aff0515@annuminas.surriel.com>
In-Reply-To: <20100512133815.0d048a86@annuminas.surriel.com>
References: <20100512133815.0d048a86@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: track the root (oldest) anon_vma

Track the root (oldest) anon_vma in each anon_vma tree.   Because we only
take the lock on the root anon_vma, we cannot use the lock on higher-up
anon_vmas to lock anything.  This makes it impossible to do an indirect
lookup of the root anon_vma, since the data structures could go away from
under us.

However, a direct pointer is safe because the root anon_vma is always the
last one that gets freed on munmap or exit, by virtue of the same_vma list
order and unlink_anon_vmas walking the list forward.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 include/linux/rmap.h |    1 +
 mm/rmap.c            |   20 +++++++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 72ecd87..457ae1e 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -26,6 +26,7 @@
  */
 struct anon_vma {
 	spinlock_t lock;	/* Serialize access to vma list */
+	struct anon_vma *root;	/* Root of this anon_vma tree */
 #ifdef CONFIG_KSM
 	atomic_t ksm_refcount;
 #endif
diff --git a/mm/rmap.c b/mm/rmap.c
index 6102f77..e34cb56 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -132,6 +132,11 @@ int anon_vma_prepare(struct vm_area_struct *vma)
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
@@ -203,7 +208,7 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
  */
 int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 {
-	struct anon_vma_chain *avc;
+	struct anon_vma_chain *avc, *root_avc;
 	struct anon_vma *anon_vma;
 
 	/* Don't bother if the parent process has no anon_vma here. */
@@ -224,9 +229,18 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 	avc = anon_vma_chain_alloc();
 	if (!avc)
 		goto out_error_free_anon_vma;
-	anon_vma_chain_link(vma, avc, anon_vma);
+
+	/*
+	 * Get the root anon_vma on the list by depending on the ordering
+	 * of the same_vma list setup by previous invocations of anon_vma_fork.
+	 * The root anon_vma will always be referenced by the last item
+	 * in the anon_vma_chain list.
+	 */
+	root_avc = list_entry(vma->anon_vma_chain.prev, struct anon_vma_chain, same_vma);
+	anon_vma->root = root_avc->anon_vma;
 	/* Mark this anon_vma as the one where our new (COWed) pages go. */
 	vma->anon_vma = anon_vma;
+	anon_vma_chain_link(vma, avc, anon_vma);
 
 	return 0;
 
@@ -261,7 +275,7 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 {
 	struct anon_vma_chain *avc, *next;
 
-	/* Unlink each anon_vma chained to the VMA. */
+	/* Unlink each anon_vma chained to the VMA, from newest to oldest. */
 	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
 		anon_vma_unlink(avc);
 		list_del(&avc->same_vma);

