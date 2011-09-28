Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab1I1XLI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:11:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54399 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932705Ab1I1WpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:45:15 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:41 2011
Message-Id: <20110928220140.916279646@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Hansen <dave@linux.vnet.ibm.com>, Hugh Dickins <hughd@google.com>,
        David Rientjes <rientjes@google.com>
Subject: [148/244] break out numa_maps gather_pte_stats() checks
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Hansen <dave@linux.vnet.ibm.com>

commit 3200a8aaab0c9ccdc0f59b0dac2d4a47029137fa upstream.

gather_pte_stats() does a number of checks on a target page
to see whether it should even be considered for statistics.
This breaks that code out in to a separate function so that
we can use it in the transparent hugepage case in the next
patch.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Acked-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Christoph Lameter <cl@gentwo.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/task_mmu.c |   39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -904,6 +904,29 @@ static void gather_stats(struct page *pa
 	md->node[page_to_nid(page)] += nr_pages;
 }
 
+static struct page *can_gather_numa_stats(pte_t pte, struct vm_area_struct *vma,
+		unsigned long addr)
+{
+	struct page *page;
+	int nid;
+
+	if (!pte_present(pte))
+		return NULL;
+
+	page = vm_normal_page(vma, addr, pte);
+	if (!page)
+		return NULL;
+
+	if (PageReserved(page))
+		return NULL;
+
+	nid = page_to_nid(page);
+	if (!node_isset(nid, node_states[N_HIGH_MEMORY]))
+		return NULL;
+
+	return page;
+}
+
 static int gather_pte_stats(pmd_t *pmd, unsigned long addr,
 		unsigned long end, struct mm_walk *walk)
 {
@@ -915,23 +938,9 @@ static int gather_pte_stats(pmd_t *pmd,
 	md = walk->private;
 	orig_pte = pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
 	do {
-		struct page *page;
-		int nid;
-
-		if (!pte_present(*pte))
-			continue;
-
-		page = vm_normal_page(md->vma, addr, *pte);
+		struct page *page = can_gather_numa_stats(*pte, md->vma, addr);
 		if (!page)
 			continue;
-
-		if (PageReserved(page))
-			continue;
-
-		nid = page_to_nid(page);
-		if (!node_isset(nid, node_states[N_HIGH_MEMORY]))
-			continue;
-
 		gather_stats(page, md, pte_dirty(*pte), 1);
 
 	} while (pte++, addr += PAGE_SIZE, addr != end);


