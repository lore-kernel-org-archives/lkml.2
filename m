Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936313Ab1KJEIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:08:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44671 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936097Ab1KJDok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:44:40 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:00 2011
Message-Id: <20111109213200.426105516@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:33:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <jweiner@redhat.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: [181/264] powerpc: gup_hugepte() support THP based tail recounting
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Arcangeli <aarcange@redhat.com>

commit 3526741f0964c88bc2ce511e1078359052bf225b upstream.

Up to this point the code assumed old refcounting for hugepages (pre-thp).
This updates the code directly to the thp mapcount tail page refcounting.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/mm/hugetlbpage.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

--- a/arch/powerpc/mm/hugetlbpage.c
+++ b/arch/powerpc/mm/hugetlbpage.c
@@ -385,12 +385,23 @@ follow_huge_pmd(struct mm_struct *mm, un
 	return NULL;
 }
 
+static inline void get_huge_page_tail(struct page *page)
+{
+	/*
+	 * __split_huge_page_refcount() cannot run
+	 * from under us.
+	 */
+	VM_BUG_ON(page_mapcount(page) < 0);
+	VM_BUG_ON(atomic_read(&page->_count) != 0);
+	atomic_inc(&page->_mapcount);
+}
+
 static noinline int gup_hugepte(pte_t *ptep, unsigned long sz, unsigned long addr,
 		       unsigned long end, int write, struct page **pages, int *nr)
 {
 	unsigned long mask;
 	unsigned long pte_end;
-	struct page *head, *page;
+	struct page *head, *page, *tail;
 	pte_t pte;
 	int refs;
 
@@ -413,6 +424,7 @@ static noinline int gup_hugepte(pte_t *p
 	head = pte_page(pte);
 
 	page = head + ((addr & (sz-1)) >> PAGE_SHIFT);
+	tail = page;
 	do {
 		VM_BUG_ON(compound_head(page) != head);
 		pages[*nr] = page;
@@ -431,6 +443,16 @@ static noinline int gup_hugepte(pte_t *p
 		*nr -= refs;
 		while (refs--)
 			put_page(head);
+	} else {
+		/*
+		 * Any tail page need their mapcount reference taken
+		 * before we return.
+		 */
+		while (refs--) {
+			if (PageTail(tail))
+				get_huge_page_tail(tail);
+			tail++;
+		}
 	}
 
 	return 1;


