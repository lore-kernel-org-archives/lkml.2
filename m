Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab2JAW7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 18:59:24 -0400
Received: from 1wt.eu ([62.212.114.60]:34940 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932326Ab2JAW7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:59:22 -0400
Message-Id: <20121001225157.908958808@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:04 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 007/180] futex: Fix uninterruptible loop due to gate_area
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
[PG: 2.6.34 variable is page, not page_head, since it doesn't have a5b338f2]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/futex.c |   28 ++++++++++++++++++++--------
 1 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index fb98c9f..0b06da1 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -264,17 +264,29 @@ again:
 
 	page = compound_head(page);
 	lock_page(page);
+
+	/*
+	 * If page->mapping is NULL, then it cannot be a PageAnon
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
+	 * an unlikely race, but we do need to retry for page->mapping.
+	 */
 	if (!page->mapping) {
+		int shmem_swizzled = PageSwapCache(page);
 		unlock_page(page);
 		put_page(page);
-		/*
-		* ZERO_PAGE pages don't have a mapping. Avoid a busy loop
-		* trying to find one. RW mapping would have COW'd (and thus
-		* have a mapping) so this page is RO and won't ever change.
-		*/
-		if ((page == ZERO_PAGE(address)))
-			return -EFAULT;
-		goto again;
+		if (shmem_swizzled)
+			goto again;
+		return -EFAULT;
 	}
 
 	/*
-- 
1.7.2.1.45.g54fbc



