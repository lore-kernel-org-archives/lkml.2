Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935338Ab0HFD2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 23:28:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:13508 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933385Ab0HFD2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 23:28:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,326,1278313200"; 
   d="scan'208";a="593470854"
Subject: [patch]x86: avoid unnecessary tlb flush
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Aug 2010 11:28:28 +0800
Message-ID: <1281065308.29094.5.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In x86, access and dirty bits are set automatically by CPU when CPU accesses
memory. When we go into the code path of below flush_tlb_nonprotect_page(),
we already set dirty bit for pte and don't need flush tlb. This might mean
tlb entry in some CPUs hasn't dirty bit set, but this doesn't matter. When
the CPUs do page write, they will automatically check the bit and no software
involved. 

On the other hand, flush tlb in below position is harmful. Test creates CPU
number of threads, each thread writes to a same but random address in same vma
range and we measure the total time. Under a 4 socket system, original time is
1.96s, while with the patch, the time is 0.8s. Under a 2 socket system, there is
20% time cut too. perf shows a lot of time are taking to send ipi/handle ipi for
tlb flush.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 arch/x86/include/asm/pgtable.h |    3 +++
 include/asm-generic/pgtable.h  |    4 ++++
 mm/memory.c                    |    2 +-
 3 files changed, 8 insertions(+), 1 deletion(-)

Index: linux/arch/x86/include/asm/pgtable.h
===================================================================
--- linux.orig/arch/x86/include/asm/pgtable.h	2010-07-29 13:25:12.000000000 +0800
+++ linux/arch/x86/include/asm/pgtable.h	2010-08-03 09:02:07.000000000 +0800
@@ -603,6 +603,9 @@ static inline void ptep_set_wrprotect(st
 	pte_update(mm, addr, ptep);
 }
 
+#define __HAVE_ARCH_FLUSH_TLB_NONPROTECT_PAGE
+#define flush_tlb_nonprotect_page(vma, address)
+
 /*
  * clone_pgd_range(pgd_t *dst, pgd_t *src, int count);
  *
Index: linux/include/asm-generic/pgtable.h
===================================================================
--- linux.orig/include/asm-generic/pgtable.h	2010-07-29 13:25:12.000000000 +0800
+++ linux/include/asm-generic/pgtable.h	2010-08-03 09:02:07.000000000 +0800
@@ -129,6 +129,10 @@ static inline void ptep_set_wrprotect(st
 #define move_pte(pte, prot, old_addr, new_addr)	(pte)
 #endif
 
+#ifndef __HAVE_ARCH_FLUSH_TLB_NONPROTECT_PAGE
+#define flush_tlb_nonprotect_page(vma, address) flush_tlb_page(vma, address)
+#endif
+
 #ifndef pgprot_noncached
 #define pgprot_noncached(prot)	(prot)
 #endif
Index: linux/mm/memory.c
===================================================================
--- linux.orig/mm/memory.c	2010-08-02 08:50:05.000000000 +0800
+++ linux/mm/memory.c	2010-08-03 09:02:07.000000000 +0800
@@ -3116,7 +3116,7 @@ static inline int handle_pte_fault(struc
 		 * with threads.
 		 */
 		if (flags & FAULT_FLAG_WRITE)
-			flush_tlb_page(vma, address);
+			flush_tlb_nonprotect_page(vma, address);
 	}
 unlock:
 	pte_unmap_unlock(pte, ptl);


