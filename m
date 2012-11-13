Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab2KMRPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:15:25 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65052 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443Ab2KMRPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:15:22 -0500
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Paul Turner <pjt@google.com>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michel Lespinasse <walken@google.com>
Subject: [PATCH 19/31] x86/mm: Completely drop the TLB flush from ptep_set_access_flags()
Date: Tue, 13 Nov 2012 18:13:42 +0100
Message-Id: <1352826834-11774-20-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352826834-11774-1-git-send-email-mingo@kernel.org>
References: <1352826834-11774-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Intel has an architectural guarantee that the TLB entry causing
a page fault gets invalidated automatically. This means
we should be able to drop the local TLB invalidation.

Because of the way other areas of the page fault code work,
chances are good that all x86 CPUs do this.  However, if
someone somewhere has an x86 CPU that does not invalidate
the TLB entry causing a page fault, this one-liner should
be easy to revert - or a CPU model specific quirk could
be added to retain this optimization on most CPUs.

Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Linus Torvalds <torvalds@kernel.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michel Lespinasse <walken@google.com>
[ Applied changelog massage and moved this last in the series,
  to create bisection distance. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/pgtable.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index be3bb46..7353de3 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -317,7 +317,6 @@ int ptep_set_access_flags(struct vm_area_struct *vma,
 	if (changed && dirty) {
 		*ptep = entry;
 		pte_update_defer(vma->vm_mm, address, ptep);
-		__flush_tlb_one(address);
 	}
 
 	return changed;
-- 
1.7.11.7

