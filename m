Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab2KMRPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:15:04 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65052 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932220Ab2KMRPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:15:00 -0500
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Paul Turner <pjt@google.com>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 08/31] mm: Only flush the TLB when clearing an accessible pte
Date: Tue, 13 Nov 2012 18:13:31 +0100
Message-Id: <1352826834-11774-9-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352826834-11774-1-git-send-email-mingo@kernel.org>
References: <1352826834-11774-1-git-send-email-mingo@kernel.org>
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
 mm/pgtable-generic.c | 3 ++-
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
1.7.11.7

