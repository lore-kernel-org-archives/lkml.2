Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab0KCPfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:35:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932219Ab0KCPbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:31:09 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 07 of 66] update futex compound knowledge
X-Mercurial-Node: 4c0192396a2fc13a2d0a4510d9035d14ab9ef0ed
Message-Id: <4c0192396a2fc13a2d0a.1288798062@v2.random>
In-Reply-To: <patchbomb.1288798055@v2.random>
References: <patchbomb.1288798055@v2.random>
User-Agent: Mercurial-patchbomb/1.4.1
Date: Wed, 03 Nov 2010 16:27:42 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Adam Litke <agl@us.ibm.com>,
        Avi Kivity <avi@redhat.com>, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrea Arcangeli <aarcange@redhat.com>

Futex code is smarter than most other gup_fast O_DIRECT code and knows about
the compound internals. However now doing a put_page(head_page) will not
release the pin on the tail page taken by gup-fast, leading to all sort of
refcounting bugchecks. Getting a stable head_page is a little tricky.

page_head = page is there because if this is not a tail page it's also the
page_head. Only in case this is a tail page, compound_head is called, otherwise
it's guaranteed unnecessary. And if it's a tail page compound_head has to run
atomically inside irq disabled section __get_user_pages_fast before returning.
Otherwise ->first_page won't be a stable pointer.

Disableing irq before __get_user_page_fast and releasing irq after running
compound_head is needed because if __get_user_page_fast returns == 1, it means
the huge pmd is established and cannot go away from under us.
pmdp_splitting_flush_notify in __split_huge_page_splitting will have to wait
for local_irq_enable before the IPI delivery can return. This means
__split_huge_page_refcount can't be running from under us, and in turn when we
run compound_head(page) we're not reading a dangling pointer from
tailpage->first_page. Then after we get to stable head page, we are always safe
to call compound_lock and after taking the compound lock on head page we can
finally re-check if the page returned by gup-fast is still a tail page. in
which case we're set and we didn't need to split the hugepage in order to take
a futex on it.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Rik van Riel <riel@redhat.com>
---

diff --git a/kernel/futex.c b/kernel/futex.c
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -219,7 +219,7 @@ get_futex_key(u32 __user *uaddr, int fsh
 {
 	unsigned long address = (unsigned long)uaddr;
 	struct mm_struct *mm = current->mm;
-	struct page *page;
+	struct page *page, *page_head;
 	int err;
 
 	/*
@@ -251,11 +251,46 @@ again:
 	if (err < 0)
 		return err;
 
-	page = compound_head(page);
-	lock_page(page);
-	if (!page->mapping) {
-		unlock_page(page);
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	page_head = page;
+	if (unlikely(PageTail(page))) {
 		put_page(page);
+		/* serialize against __split_huge_page_splitting() */
+		local_irq_disable();
+		if (likely(__get_user_pages_fast(address, 1, 1, &page) == 1)) {
+			page_head = compound_head(page);
+			/*
+			 * page_head is valid pointer but we must pin
+			 * it before taking the PG_lock and/or
+			 * PG_compound_lock. The moment we re-enable
+			 * irqs __split_huge_page_splitting() can
+			 * return and the head page can be freed from
+			 * under us. We can't take the PG_lock and/or
+			 * PG_compound_lock on a page that could be
+			 * freed from under us.
+			 */
+			if (page != page_head) {
+				get_page(page_head);
+				put_page(page);
+			}
+			local_irq_enable();
+		} else {
+			local_irq_enable();
+			goto again;
+		}
+	}
+#else
+	page_head = compound_head(page);
+	if (page != page_head) {
+		get_page(page_head);
+		put_page(page);
+	}
+#endif
+
+	lock_page(page_head);
+	if (!page_head->mapping) {
+		unlock_page(page_head);
+		put_page(page_head);
 		goto again;
 	}
 
@@ -266,20 +301,20 @@ again:
 	 * it's a read-only handle, it's expected that futexes attach to
 	 * the object not the particular process.
 	 */
-	if (PageAnon(page)) {
+	if (PageAnon(page_head)) {
 		key->both.offset |= FUT_OFF_MMSHARED; /* ref taken on mm */
 		key->private.mm = mm;
 		key->private.address = address;
 	} else {
 		key->both.offset |= FUT_OFF_INODE; /* inode-based key */
-		key->shared.inode = page->mapping->host;
-		key->shared.pgoff = page->index;
+		key->shared.inode = page_head->mapping->host;
+		key->shared.pgoff = page_head->index;
 	}
 
 	get_futex_key_refs(key);
 
-	unlock_page(page);
-	put_page(page);
+	unlock_page(page_head);
+	put_page(page_head);
 	return 0;
 }
 
