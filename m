Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205Ab2LQC4y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 21:56:54 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38713 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab2LQC4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 21:56:53 -0500
Date: Sun, 16 Dec 2012 18:56:58 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Mel Gorman <mgorman@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Hillf Danton <dhillf@gmail.com>, David Rientjes <rientjes@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm: fix kernel BUG at huge_memory.c:1474!
In-Reply-To: <alpine.LNX.2.00.1212161850060.1626@eggly.anvils>
Message-ID: <alpine.LNX.2.00.1212161854000.1626@eggly.anvils>
References: <20121212100338.GS1009@suse.de> <CA+55aFzedbhcuo-WObUjigrXGuG2VGLqDOvh_HFA9Cn_BRkwjQ@mail.gmail.com> <alpine.LNX.2.00.1212161850060.1626@eggly.anvils>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea's autonuma-benchmark numa01 hits kernel BUG at huge_memory.c:1474!
in change_huge_pmd called from change_protection from change_prot_numa
from task_numa_work.

That BUG, introduced in the huge zero page commit cad7f613c4d0 ("thp:
change_huge_pmd(): make sure we don't try to make a page writable")
was trying to verify that newprot never adds write permission to an
anonymous huge page; but Automatic NUMA Balancing's 4b10e7d562c9 ("mm:
mempolicy: Implement change_prot_numa() in terms of change_protection()")
adds a new prot_numa path into change_huge_pmd(), which makes no use of
the newprot provided, and may retain the write bit in the pmd.

Just move the BUG_ON(pmd_write(entry)) up into the !prot_numa block.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/huge_memory.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- 2a74dbb9/mm/huge_memory.c	2012-12-16 16:35:08.752441527 -0800
+++ linux/mm/huge_memory.c	2012-12-16 18:21:24.308156970 -0800
@@ -1460,9 +1460,10 @@ int change_huge_pmd(struct vm_area_struc
 	if (__pmd_trans_huge_lock(pmd, vma) == 1) {
 		pmd_t entry;
 		entry = pmdp_get_and_clear(mm, addr, pmd);
-		if (!prot_numa)
+		if (!prot_numa) {
 			entry = pmd_modify(entry, newprot);
-		else {
+			BUG_ON(pmd_write(entry));
+		} else {
 			struct page *page = pmd_page(*pmd);
 
 			/* only check non-shared pages */
@@ -1471,7 +1472,6 @@ int change_huge_pmd(struct vm_area_struc
 				entry = pmd_mknuma(entry);
 			}
 		}
-		BUG_ON(pmd_write(entry));
 		set_pmd_at(mm, addr, pmd, entry);
 		spin_unlock(&vma->vm_mm->page_table_lock);
 		ret = 1;
