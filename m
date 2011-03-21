Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab1CUX42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:56:28 -0400
Received: from kroah.org ([198.145.64.141]:49111 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754860Ab1CUXOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:14:05 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:10:54 2011
Message-Id: <20110321231054.162297660@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:10:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shaohua Li <shaohua.li@intel.com>,
        Mallick Asit K <asit.k.mallick@intel.com>,
        linux-mm <linux-mm@kvack.org>, Ingo Molnar <mingo@elte.hu>
Subject: [34/44] x86: Flush TLB if PGD entry is changed in i386 PAE mode
In-Reply-To: <20110321231105.GA1744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Shaohua Li <shaohua.li@intel.com>

commit 4981d01eada5354d81c8929d5b2836829ba3df7b upstream.

According to intel CPU manual, every time PGD entry is changed in i386 PAE
mode, we need do a full TLB flush. Current code follows this and there is
comment for this too in the code.

But current code misses the multi-threaded case. A changed page table
might be used by several CPUs, every such CPU should flush TLB. Usually
this isn't a problem, because we prepopulate all PGD entries at process
fork. But when the process does munmap and follows new mmap, this issue
will be triggered.

When it happens, some CPUs keep doing page faults:

  http://marc.info/?l=linux-kernel&m=129915020508238&w=2

Reported-by: Yasunori Goto<y-goto@jp.fujitsu.com>
Tested-by: Yasunori Goto<y-goto@jp.fujitsu.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Shaohua Li<shaohua.li@intel.com>
Cc: Mallick Asit K <asit.k.mallick@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>
LKML-Reference: <1300246649.2337.95.camel@sli10-conroe>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/pgtable-3level.h |   11 +++--------
 arch/x86/mm/pgtable.c                 |    3 +--
 2 files changed, 4 insertions(+), 10 deletions(-)

--- a/arch/x86/include/asm/pgtable-3level.h
+++ b/arch/x86/include/asm/pgtable-3level.h
@@ -69,8 +69,6 @@ static inline void native_pmd_clear(pmd_
 
 static inline void pud_clear(pud_t *pudp)
 {
-	unsigned long pgd;
-
 	set_pud(pudp, __pud(0));
 
 	/*
@@ -79,13 +77,10 @@ static inline void pud_clear(pud_t *pudp
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
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -159,8 +159,7 @@ void pud_populate(struct mm_struct *mm,
 	 * section 8.1: in PAE mode we explicitly have to flush the
 	 * TLB via cr3 if the top-level pgd is changed...
 	 */
-	if (mm == current->active_mm)
-		write_cr3(read_cr3());
+	flush_tlb_mm(mm);
 }
 #else  /* !CONFIG_X86_PAE */
 


