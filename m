Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab1BPAVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:21:41 -0500
Received: from kroah.org ([198.145.64.141]:39330 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757311Ab1BPAVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:21:35 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:37 2011
Message-Id: <20110216001437.443368423@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Junichi Nomura" <j-nomura@ce.jp.nec.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [124/272] mm: fix hugepage migration
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hugh Dickins <hughd@google.com>

commit fd4a4663db293bfd5dc20fb4113977f62895e550 upstream.

2.6.37 added an unmap_and_move_huge_page() for memory failure recovery,
but its anon_vma handling was still based around the 2.6.35 conventions.
Update it to use page_lock_anon_vma, get_anon_vma, page_unlock_anon_vma,
drop_anon_vma in the same way as we're now changing unmap_and_move().

I don't particularly like to propose this for stable when I've not seen
its problems in practice nor tested the solution: but it's clearly out of
synch at present.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/migrate.c |   23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -805,7 +805,6 @@ static int unmap_and_move_huge_page(new_
 	int rc = 0;
 	int *result = NULL;
 	struct page *new_hpage = get_new_page(hpage, private, &result);
-	int rcu_locked = 0;
 	struct anon_vma *anon_vma = NULL;
 
 	if (!new_hpage)
@@ -820,12 +819,10 @@ static int unmap_and_move_huge_page(new_
 	}
 
 	if (PageAnon(hpage)) {
-		rcu_read_lock();
-		rcu_locked = 1;
-
-		if (page_mapped(hpage)) {
-			anon_vma = page_anon_vma(hpage);
-			atomic_inc(&anon_vma->external_refcount);
+		anon_vma = page_lock_anon_vma(hpage);
+		if (anon_vma) {
+			get_anon_vma(anon_vma);
+			page_unlock_anon_vma(anon_vma);
 		}
 	}
 
@@ -837,16 +834,8 @@ static int unmap_and_move_huge_page(new_
 	if (rc)
 		remove_migration_ptes(hpage, hpage);
 
-	if (anon_vma && atomic_dec_and_lock(&anon_vma->external_refcount,
-					    &anon_vma->lock)) {
-		int empty = list_empty(&anon_vma->head);
-		spin_unlock(&anon_vma->lock);
-		if (empty)
-			anon_vma_free(anon_vma);
-	}
-
-	if (rcu_locked)
-		rcu_read_unlock();
+	if (anon_vma)
+		drop_anon_vma(anon_vma);
 out:
 	unlock_page(hpage);
 


