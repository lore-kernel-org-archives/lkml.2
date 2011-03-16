Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438Ab1CPDhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 23:37:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:49311 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734Ab1CPDhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 23:37:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,192,1299484800"; 
   d="scan'208";a="613505613"
Subject: [PATCH]x86: flush tlb if PGD entry is changed in i386 PAE mode
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, y-goto@jp.fujitsu.com,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        stable <stable@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Mar 2011 11:37:29 +0800
Message-ID: <1300246649.2337.95.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to intel CPU manual, every time PGD entry is changed in i386 PAE mode,
we need do a full TLB flush. Current code follows this and there is comment
for this too in the code. But current code misses the multi-threaded case. A
changed page table might be used by several CPUs, every such CPU should flush
TLB.
Usually this isn't a problem, because we prepopulate all PGD entries at process
fork. But when the process does munmap and follows new mmap, this issue will be
triggered. When it happens, some CPUs will keep doing page fault.

See: http://marc.info/?l=linux-kernel&m=129915020508238&w=2

Reported-by: Yasunori Goto<y-goto@jp.fujitsu.com>
Signed-off-by: Shaohua Li<shaohua.li@intel.com>
Tested-by: Yasunori Goto<y-goto@jp.fujitsu.com>

diff --git a/arch/x86/include/asm/pgtable-3level.h b/arch/x86/include/asm/pgtable-3level.h
index 94b979d..effff47 100644
--- a/arch/x86/include/asm/pgtable-3level.h
+++ b/arch/x86/include/asm/pgtable-3level.h
@@ -69,8 +69,6 @@ static inline void native_pmd_clear(pmd_t *pmd)
 
 static inline void pud_clear(pud_t *pudp)
 {
-	unsigned long pgd;
-
 	set_pud(pudp, __pud(0));
 
 	/*
@@ -79,13 +77,10 @@ static inline void pud_clear(pud_t *pudp)
 	 * section 8.1: in PAE mode we explicitly have to flush the
 	 * TLB via cr3 if the top-level pgd is changed...
 	 *
-	 * Make sure the pud entry we're updating is within the
-	 * current pgd to avoid unnecessary TLB flushes.
+	 * Currently all places where pud_clear() is called either have
+	 * flush_tlb_mm() followed or don't need TLB flush (x86_64 code or
+	 * pud_clear_bad()), so we don't need TLB flush here.
 	 */
-	pgd = read_cr3();
-	if (__pa(pudp) >= pgd && __pa(pudp) <
-	    (pgd + sizeof(pgd_t)*PTRS_PER_PGD))
-		write_cr3(pgd);
 }
 
 #ifdef CONFIG_SMP
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 500242d..6ecc5c8 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -170,8 +170,7 @@ void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmd)
 	 * section 8.1: in PAE mode we explicitly have to flush the
 	 * TLB via cr3 if the top-level pgd is changed...
 	 */
-	if (mm == current->active_mm)
-		write_cr3(read_cr3());
+	flush_tlb_mm(mm);
 }
 #else  /* !CONFIG_X86_PAE */
 


