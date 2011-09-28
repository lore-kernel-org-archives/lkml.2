Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822Ab1I1WpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:45:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54404 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932801Ab1I1WpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:45:18 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:41 2011
Message-Id: <20110928220141.019970932@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Hansen <dave@linux.vnet.ibm.com>, Hugh Dickins <hughd@google.com>,
        David Rientjes <rientjes@google.com>
Subject: [149/244] teach /proc/$pid/numa_maps about transparent hugepages
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Hansen <dave@linux.vnet.ibm.com>

commit 32ef43848f283e0ef945d3c67e851c143fea3970 upstream.

This is modeled after the smaps code.

It detects transparent hugepages and then does a single gather_stats()
for the page as a whole.  This has two benifits:
 1. It is more efficient since it does many pages in a single shot.
 2. It does not have to break down the huge page.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/task_mmu.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -936,6 +936,26 @@ static int gather_pte_stats(pmd_t *pmd,
 	pte_t *pte;
 
 	md = walk->private;
+	spin_lock(&walk->mm->page_table_lock);
+	if (pmd_trans_huge(*pmd)) {
+		if (pmd_trans_splitting(*pmd)) {
+			spin_unlock(&walk->mm->page_table_lock);
+			wait_split_huge_page(md->vma->anon_vma, pmd);
+		} else {
+			pte_t huge_pte = *(pte_t *)pmd;
+			struct page *page;
+
+			page = can_gather_numa_stats(huge_pte, md->vma, addr);
+			if (page)
+				gather_stats(page, md, pte_dirty(huge_pte),
+						HPAGE_PMD_SIZE/PAGE_SIZE);
+			spin_unlock(&walk->mm->page_table_lock);
+			return 0;
+		}
+	} else {
+		spin_unlock(&walk->mm->page_table_lock);
+	}
+
 	orig_pte = pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
 	do {
 		struct page *page = can_gather_numa_stats(*pte, md->vma, addr);


