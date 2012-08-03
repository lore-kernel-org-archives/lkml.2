Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab2HCM4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 08:56:47 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:53218 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab2HCM4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 08:56:46 -0400
MIME-Version: 1.0
Date: Fri, 3 Aug 2012 20:56:45 +0800
Message-ID: <CAJd=RBB=jKD+9JcuBmBGC8R8pAQ-QoWHexMNMsXpb9zV548h5g@mail.gmail.com>
Subject: [patch] hugetlb: correct page offset index for sharing pmd
From: Hillf Danton <dhillf@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The computation of page offset index is open coded, and incorrect, to
be used in scanning prio tree, as huge page offset is required, and is
fixed with the well defined routine.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/arch/x86/mm/hugetlbpage.c	Fri Aug  3 20:34:58 2012
+++ b/arch/x86/mm/hugetlbpage.c	Fri Aug  3 20:40:16 2012
@@ -72,12 +72,15 @@ static void huge_pmd_share(struct mm_str
 	if (!vma_shareable(vma, addr))
 		return;

+	idx = linear_page_index(vma, addr);
+
 	mutex_lock(&mapping->i_mmap_mutex);
 	vma_prio_tree_foreach(svma, &iter, &mapping->i_mmap, idx, idx) {
 		if (svma == vma)
 			continue;

-		saddr = page_table_shareable(svma, vma, addr, idx);
+		saddr = page_table_shareable(svma, vma, addr,
+						idx * (PMD_SIZE/PAGE_SIZE));
 		if (saddr) {
 			spte = huge_pte_offset(svma->vm_mm, saddr);
 			if (spte) {
--
