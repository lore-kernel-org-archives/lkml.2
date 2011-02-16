Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358Ab1BPBb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:31:26 -0500
Received: from kroah.org ([198.145.64.141]:39316 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756975Ab1BPAVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:21:34 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:37 2011
Message-Id: <20110216001437.344826778@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Junichi Nomura" <j-nomura@ce.jp.nec.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [123/272] mm: fix migration hangs on anon_vma lock
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hugh Dickins <hughd@google.com>

commit 1ce82b69e96c838d007f316b8347b911fdfa9842 upstream.

Increased usage of page migration in mmotm reveals that the anon_vma
locking in unmap_and_move() has been deficient since 2.6.36 (or even
earlier).  Review at the time of f18194275c39835cb84563500995e0d503a32d9a
("mm: fix hang on anon_vma->root->lock") missed the issue here: the
anon_vma to which we get a reference may already have been freed back to
its slab (it is in use when we check page_mapped, but that can change),
and so its anon_vma->root may be switched at any moment by reuse in
anon_vma_prepare.

Perhaps we could fix that with a get_anon_vma_unless_zero(), but let's
not: just rely on page_lock_anon_vma() to do all the hard thinking for us,
then we don't need any rcu read locking over here.

In removing the rcu_unlock label: since PageAnon is a bit in
page->mapping, it's impossible for a !page->mapping page to be anon; but
insert VM_BUG_ON in case the implementation ever changes.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/migrate.c |   48 +++++++++++++++++++-----------------------------
 1 file changed, 19 insertions(+), 29 deletions(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -620,7 +620,6 @@ static int unmap_and_move(new_page_t get
 	int *result = NULL;
 	struct page *newpage = get_new_page(page, private, &result);
 	int remap_swapcache = 1;
-	int rcu_locked = 0;
 	int charge = 0;
 	struct mem_cgroup *mem = NULL;
 	struct anon_vma *anon_vma = NULL;
@@ -672,20 +671,26 @@ static int unmap_and_move(new_page_t get
 	/*
 	 * By try_to_unmap(), page->mapcount goes down to 0 here. In this case,
 	 * we cannot notice that anon_vma is freed while we migrates a page.
-	 * This rcu_read_lock() delays freeing anon_vma pointer until the end
+	 * This get_anon_vma() delays freeing anon_vma pointer until the end
 	 * of migration. File cache pages are no problem because of page_lock()
 	 * File Caches may use write_page() or lock_page() in migration, then,
 	 * just care Anon page here.
 	 */
 	if (PageAnon(page)) {
-		rcu_read_lock();
-		rcu_locked = 1;
-
-		/* Determine how to safely use anon_vma */
-		if (!page_mapped(page)) {
-			if (!PageSwapCache(page))
-				goto rcu_unlock;
-
+		/*
+		 * Only page_lock_anon_vma() understands the subtleties of
+		 * getting a hold on an anon_vma from outside one of its mms.
+		 */
+		anon_vma = page_lock_anon_vma(page);
+		if (anon_vma) {
+			/*
+			 * Take a reference count on the anon_vma if the
+			 * page is mapped so that it is guaranteed to
+			 * exist when the page is remapped later
+			 */
+			get_anon_vma(anon_vma);
+			page_unlock_anon_vma(anon_vma);
+		} else if (PageSwapCache(page)) {
 			/*
 			 * We cannot be sure that the anon_vma of an unmapped
 			 * swapcache page is safe to use because we don't
@@ -700,13 +705,7 @@ static int unmap_and_move(new_page_t get
 			 */
 			remap_swapcache = 0;
 		} else {
-			/*
-			 * Take a reference count on the anon_vma if the
-			 * page is mapped so that it is guaranteed to
-			 * exist when the page is remapped later
-			 */
-			anon_vma = page_anon_vma(page);
-			get_anon_vma(anon_vma);
+			goto uncharge;
 		}
 	}
 
@@ -723,16 +722,10 @@ static int unmap_and_move(new_page_t get
 	 * free the metadata, so the page can be freed.
 	 */
 	if (!page->mapping) {
-		if (!PageAnon(page) && page_has_private(page)) {
-			/*
-			 * Go direct to try_to_free_buffers() here because
-			 * a) that's what try_to_release_page() would do anyway
-			 * b) we may be under rcu_read_lock() here, so we can't
-			 *    use GFP_KERNEL which is what try_to_release_page()
-			 *    needs to be effective.
-			 */
+		VM_BUG_ON(PageAnon(page));
+		if (page_has_private(page)) {
 			try_to_free_buffers(page);
-			goto rcu_unlock;
+			goto uncharge;
 		}
 		goto skip_unmap;
 	}
@@ -746,14 +739,11 @@ skip_unmap:
 
 	if (rc && remap_swapcache)
 		remove_migration_ptes(page, page);
-rcu_unlock:
 
 	/* Drop an anon_vma reference if we took one */
 	if (anon_vma)
 		drop_anon_vma(anon_vma);
 
-	if (rcu_locked)
-		rcu_read_unlock();
 uncharge:
 	if (!charge)
 		mem_cgroup_end_migration(mem, page, newpage);


