Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471Ab1E1UU2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 16:20:28 -0400
Received: from smtp-out.google.com ([74.125.121.67]:50770 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab1E1UU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 16:20:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=fbRpx8p3UmROFZP1Ip2sicDmhODaR4ETJOmVoZ4Pss3baYhTquGPEZxM9wsQ6jd0YF
         jclBZEORRAE64O4zES/Q==
Date: Sat, 28 May 2011 13:20:21 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH] mm: fix page_lock_anon_vma leaving mutex locked
Message-ID: <alpine.LSU.2.00.1105281317090.13319@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On one machine I've been getting hangs, a page fault's anon_vma_prepare()
waiting in anon_vma_lock(), other processes waiting for that page's lock.

This is a replay of last year's f18194275c39
"mm: fix hang on anon_vma->root->lock".

The new page_lock_anon_vma() places too much faith in its refcount: when
it has acquired the mutex_trylock(), it's possible that a racing task in
anon_vma_alloc() has just reallocated the struct anon_vma, set refcount
to 1, and is about to reset its anon_vma->root.

Fix this by saving anon_vma->root, and relying on the usual page_mapped()
check instead of a refcount check: if page is still mapped, the anon_vma
is still ours; if page is not still mapped, we're no longer interested.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/rmap.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- linux.orig/mm/rmap.c	2011-05-27 20:07:44.000000000 -0700
+++ linux/mm/rmap.c	2011-05-27 20:31:04.596303434 -0700
@@ -405,6 +405,7 @@ out:
 struct anon_vma *page_lock_anon_vma(struct page *page)
 {
 	struct anon_vma *anon_vma = NULL;
+	struct anon_vma *root_anon_vma;
 	unsigned long anon_mapping;
 
 	rcu_read_lock();
@@ -415,13 +416,15 @@ struct anon_vma *page_lock_anon_vma(stru
 		goto out;
 
 	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
-	if (mutex_trylock(&anon_vma->root->mutex)) {
+	root_anon_vma = ACCESS_ONCE(anon_vma->root);
+	if (mutex_trylock(&root_anon_vma->mutex)) {
 		/*
-		 * If we observe a !0 refcount, then holding the lock ensures
-		 * the anon_vma will not go away, see __put_anon_vma().
+		 * If the page is still mapped, then this anon_vma is still
+		 * its anon_vma, and holding the mutex ensures that it will
+		 * not go away, see __put_anon_vma().
 		 */
-		if (!atomic_read(&anon_vma->refcount)) {
-			anon_vma_unlock(anon_vma);
+		if (!page_mapped(page)) {
+			mutex_unlock(&root_anon_vma->mutex);
 			anon_vma = NULL;
 		}
 		goto out;
