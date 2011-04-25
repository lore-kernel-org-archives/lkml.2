Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708Ab1DYUlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:41:11 -0400
Received: from 1wt.eu ([62.212.114.60]:34380 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932318Ab1DYUY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:56 -0400
Message-Id: <20110425200237.166324095@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:08 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Shaohua Li <shaohua.li@intel.com>,
        Mallick Asit K <asit.k.mallick@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, Ingo Molnar <mingo@elte.hu>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 096/173] x86: Flush TLB if PGD entry is changed in i386 PAE mode
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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

Index: longterm-2.6.27/include/asm-x86/pgtable-3level.h
===================================================================
--- longterm-2.6.27.orig/include/asm-x86/pgtable-3level.h	2011-01-23 10:52:33.916066510 +0100
+++ longterm-2.6.27/include/asm-x86/pgtable-3level.h	2011-04-25 15:55:12.384279160 +0200
@@ -101,8 +101,6 @@
 
 static inline void pud_clear(pud_t *pudp)
 {
-	unsigned long pgd;
-
 	set_pud(pudp, __pud(0));
 
 	/*
@@ -111,13 +109,10 @@
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
 
 #define pud_page(pud) ((struct page *) __va(pud_val(pud) & PTE_PFN_MASK))
Index: longterm-2.6.27/arch/x86/mm/pgtable.c
===================================================================
--- longterm-2.6.27.orig/arch/x86/mm/pgtable.c	2011-01-23 10:52:13.760064270 +0100
+++ longterm-2.6.27/arch/x86/mm/pgtable.c	2011-04-25 15:55:12.391278523 +0200
@@ -138,8 +138,7 @@
 	 * section 8.1: in PAE mode we explicitly have to flush the
 	 * TLB via cr3 if the top-level pgd is changed...
 	 */
-	if (mm == current->active_mm)
-		write_cr3(read_cr3());
+	flush_tlb_mm(mm);
 }
 #else  /* !CONFIG_X86_PAE */
 


