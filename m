Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab2KUKWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 05:22:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43614 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab2KUKWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 05:22:06 -0500
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>
Cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 05/46] mm: Only flush the TLB when clearing an accessible pte
Date: Wed, 21 Nov 2012 10:21:11 +0000
Message-Id: <1353493312-8069-6-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1353493312-8069-1-git-send-email-mgorman@suse.de>
References: <1353493312-8069-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

If ptep_clear_flush() is called to clear a page table entry that is
accessible anyway by the CPU, eg. a _PAGE_PROTNONE page table entry,
there is no need to flush the TLB on remote CPUs.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-vm3rkzevahelwhejx5uwm8ex@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/pgtable-generic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index d8397da..0c8323f 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -88,7 +88,8 @@ pte_t ptep_clear_flush(struct vm_area_struct *vma, unsigned long address,
 {
 	pte_t pte;
 	pte = ptep_get_and_clear((vma)->vm_mm, address, ptep);
-	flush_tlb_page(vma, address);
+	if (pte_accessible(pte))
+		flush_tlb_page(vma, address);
 	return pte;
 }
 #endif
-- 
1.7.9.2

