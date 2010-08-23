Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab0HWR6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 13:58:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:45652 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab0HWR6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 13:58:00 -0400
Date: Mon, 23 Aug 2010 17:57:45 GMT
From: tip-bot for Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        aarcange@redhat.com, suresh.b.siddha@intel.com, shaohua.li@intel.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        aarcange@redhat.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        shaohua.li@intel.com
In-Reply-To: <20100816011655.GA362@sli10-desk.sh.intel.com>
References: <20100816011655.GA362@sli10-desk.sh.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm: Avoid unnecessary TLB flush
Message-ID: <tip-61c77326d1df079f202fa79403c3ccd8c5966a81@git.kernel.org>
Git-Commit-ID: 61c77326d1df079f202fa79403c3ccd8c5966a81
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 23 Aug 2010 17:57:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  61c77326d1df079f202fa79403c3ccd8c5966a81
Gitweb:     http://git.kernel.org/tip/61c77326d1df079f202fa79403c3ccd8c5966a81
Author:     Shaohua Li <shaohua.li@intel.com>
AuthorDate: Mon, 16 Aug 2010 09:16:55 +0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 23 Aug 2010 10:04:57 -0700

x86, mm: Avoid unnecessary TLB flush

In x86, access and dirty bits are set automatically by CPU when CPU accesses
memory. When we go into the code path of below flush_tlb_fix_spurious_fault(),
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
LKML-Reference: <20100816011655.GA362@sli10-desk.sh.intel.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andrea Archangeli <aarcange@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/pgtable.h |    2 ++
 include/asm-generic/pgtable.h  |    4 ++++
 mm/memory.c                    |    2 +-
 3 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index a34c785..2d0a33b 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -603,6 +603,8 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm,
 	pte_update(mm, addr, ptep);
 }
 
+#define flush_tlb_fix_spurious_fault(vma, address)
+
 /*
  * clone_pgd_range(pgd_t *dst, pgd_t *src, int count);
  *
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index e2bd73e..f4d4120 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -129,6 +129,10 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addres
 #define move_pte(pte, prot, old_addr, new_addr)	(pte)
 #endif
 
+#ifndef flush_tlb_fix_spurious_fault
+#define flush_tlb_fix_spurious_fault(vma, address) flush_tlb_page(vma, address)
+#endif
+
 #ifndef pgprot_noncached
 #define pgprot_noncached(prot)	(prot)
 #endif
diff --git a/mm/memory.c b/mm/memory.c
index 2ed2267..a40da69 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3147,7 +3147,7 @@ static inline int handle_pte_fault(struct mm_struct *mm,
 		 * with threads.
 		 */
 		if (flags & FAULT_FLAG_WRITE)
-			flush_tlb_page(vma, address);
+			flush_tlb_fix_spurious_fault(vma, address);
 	}
 unlock:
 	pte_unmap_unlock(pte, ptl);
