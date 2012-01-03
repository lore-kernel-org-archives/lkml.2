Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab2ACXEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 18:04:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39524 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754975Ab2ACWgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:36:13 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:34 2012
Message-Id: <20120103223034.468493273@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:29:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Hugh Dickins <hughd@google.com>
Subject: [37/67] futex: Fix uninterruptible loop due to gate_area
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Dickins <hughd@google.com>

commit e6780f7243eddb133cc20ec37fa69317c218b709 upstream.

It was found (by Sasha) that if you use a futex located in the gate
area we get stuck in an uninterruptible infinite loop, much like the
ZERO_PAGE issue.

While looking at this problem, PeterZ realized you'll get into similar
trouble when hitting any install_special_pages() mapping.  And are there
still drivers setting up their own special mmaps without page->mapping,
and without special VM or pte flags to make get_user_pages fail?

In most cases, if page->mapping is NULL, we do not need to retry at all:
Linus points out that even /proc/sys/vm/drop_caches poses no problem,
because it ends up using remove_mapping(), which takes care not to
interfere when the page reference count is raised.

But there is still one case which does need a retry: if memory pressure
called shmem_writepage in between get_user_pages_fast dropping page
table lock and our acquiring page lock, then the page gets switched from
filecache to swapcache (and ->mapping set to NULL) whatever the refcount.
Fault it back in to get the page->mapping needed for key->shared.inode.

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/futex.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -314,17 +314,29 @@ again:
 #endif
 
 	lock_page(page_head);
+
+	/*
+	 * If page_head->mapping is NULL, then it cannot be a PageAnon
+	 * page; but it might be the ZERO_PAGE or in the gate area or
+	 * in a special mapping (all cases which we are happy to fail);
+	 * or it may have been a good file page when get_user_pages_fast
+	 * found it, but truncated or holepunched or subjected to
+	 * invalidate_complete_page2 before we got the page lock (also
+	 * cases which we are happy to fail).  And we hold a reference,
+	 * so refcount care in invalidate_complete_page's remove_mapping
+	 * prevents drop_caches from setting mapping to NULL beneath us.
+	 *
+	 * The case we do have to guard against is when memory pressure made
+	 * shmem_writepage move it from filecache to swapcache beneath us:
+	 * an unlikely race, but we do need to retry for page_head->mapping.
+	 */
 	if (!page_head->mapping) {
+		int shmem_swizzled = PageSwapCache(page_head);
 		unlock_page(page_head);
 		put_page(page_head);
-		/*
-		* ZERO_PAGE pages don't have a mapping. Avoid a busy loop
-		* trying to find one. RW mapping would have COW'd (and thus
-		* have a mapping) so this page is RO and won't ever change.
-		*/
-		if ((page_head == ZERO_PAGE(address)))
-			return -EFAULT;
-		goto again;
+		if (shmem_swizzled)
+			goto again;
+		return -EFAULT;
 	}
 
 	/*


