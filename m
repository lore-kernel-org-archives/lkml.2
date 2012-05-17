Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760861Ab2EQCQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 22:16:31 -0400
Received: from linux-sh.org ([111.68.239.195]:51895 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760826Ab2EQCQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 22:16:28 -0400
Date: Thu, 17 May 2012 11:14:30 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alex Shi <alex.shi@intel.com>, Nick Piggin <npiggin@gmail.com>,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com, jeremy@goop.org,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, borislav.petkov@amd.com,
        yinghai@kernel.org, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, tj@kernel.org, oleg@redhat.com,
        axboe@kernel.dk, jmorris@namei.org, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        yongjie.ren@intel.com, linux-arch@vger.kernel.org
Subject: Re: [PATCH v5 6/7] x86/tlb: optimizing flush_tlb_mm
Message-ID: <20120517021430.GC16069@linux-sh.org>
References: <1337072138-8323-1-git-send-email-alex.shi@intel.com>
 <1337072138-8323-7-git-send-email-alex.shi@intel.com>
 <CAPa8GCDsSOrzQwX2qRJyocYAZdGbwjD4t4fjxmWXV6=EoXjXZw@mail.gmail.com>
 <4FB2590C.1050303@intel.com>
 <1337092577.27694.45.camel@twins>
 <1337093840.27694.56.camel@twins>
 <4FB34D49.1060809@intel.com>
 <1337155239.27694.131.camel@twins>
 <4FB3ACD2.5010900@intel.com>
 <1337202569.4281.13.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337202569.4281.13.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 11:09:29PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-05-16 at 21:34 +0800, Alex Shi wrote:
> > 
> > So, if the minimum change of tlb->start/end can be protected by
> > HAVE_GENERIC_MMU_GATHER, it is safe and harmless, am I right?
> > 
> safe yes, but not entirely harmless. A quick look seems to suggest you
> fail for VM_HUGETLB. If your mmu_gather spans a vma with VM_HUGETLB
> you'll do a regular range flush not a full mm flush like the other paths
> do.
> 
> Anyway, I did a quick refresh of my series on a recent -tip tree:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/peterz/mmu.git tlb-unify
> 
> With that all you need is to "select HAVE_MMU_GATHER_RANGE" for x86 and
> implement a useful flush_tlb_range().
> 
> In particular, see:
> http://git.kernel.org/?p=linux/kernel/git/peterz/mmu.git;a=commitdiff;h=05e53144177e6242fda404045f50f48114bcf185;hp=2cd7dc710652127522392f4b7ecb5fa6e954941e
> 
> I've slightly changed the code to address an open issue with the
> vm_flags tracking. We now force flush the mmu_gather whenever VM_HUGETLB
> flips because most (all?) archs that look at that flag expect pure huge
> pages and not a mixture.
> 
> I've seem to have misplaced my cross-compiler set, so I've only compiled
> x86-64 for now.

It was on my list to test when you sent out the series initially, but
seems to have slipped my mind until I saw this thread. Here's a patch on
top of your tlb-unify branch that gets sh working (tested on all of
2-level, 3-level, and nommu).

I opted to shove the asm/cacheflush.h include in to tlb.h directly since
it is calling flush_cache_range() openly now, and the rest of the
architectures are just getting at it through various whimsical means. sh
was getting it through pagemap.h -> highmem.h, while ARM presently can't
seem to make up its mind and includes pagemap.h for nommu only as well as
cacheflush.h explicitly.

With the reworked interface we don't seem to actually need to stub out
the interface for the nommu case anymore anyways, all of the users are
insular to mm/memory.c which we don't build for nommu.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

diff --git a/arch/sh/include/asm/pgalloc.h b/arch/sh/include/asm/pgalloc.h
index 8c00785..bedc2ed 100644
--- a/arch/sh/include/asm/pgalloc.h
+++ b/arch/sh/include/asm/pgalloc.h
@@ -13,6 +13,8 @@ extern void pgd_free(struct mm_struct *mm, pgd_t *pgd);
 extern void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmd);
 extern pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address);
 extern void pmd_free(struct mm_struct *mm, pmd_t *pmd);
+
+#define __pmd_free_tlb(tlb, pmdp, addr)	pmd_free((tlb)->mm, pmdp)
 #endif
 
 static inline void pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmd,
diff --git a/arch/sh/include/asm/tlb.h b/arch/sh/include/asm/tlb.h
index 45e5925..71af915 100644
--- a/arch/sh/include/asm/tlb.h
+++ b/arch/sh/include/asm/tlb.h
@@ -6,18 +6,7 @@
 #endif
 
 #ifndef __ASSEMBLY__
-#include <linux/pagemap.h>
-
 #ifdef CONFIG_MMU
-#include <linux/swap.h>
-
-#define __tlb_remove_tlb_entry(tlb, ptep, addr) do { } while (0)
-
-#define __pte_free_tlb(tlb, ptep, addr)	pte_free((tlb)->mm, ptep)
-#define __pmd_free_tlb(tlb, pmdp, addr)	pmd_free((tlb)->mm, pmdp)
-#define __pud_free_tlb(tlb, pudp, addr)	pud_free((tlb)->mm, pudp)
-
-#include <asm-generic/tlb.h>
 
 #if defined(CONFIG_CPU_SH4) || defined(CONFIG_SUPERH64)
 extern void tlb_wire_entry(struct vm_area_struct *, unsigned long, pte_t);
@@ -35,8 +24,6 @@ static inline void tlb_unwire_entry(void)
 }
 #endif
 
-#else /* CONFIG_MMU */
-
 #define __tlb_remove_tlb_entry(tlb, pte, address)	do { } while (0)
 
 #include <asm-generic/tlb.h>
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 90a725c..571e2cf 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -18,6 +18,7 @@
 #include <linux/swap.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
+#include <asm/cacheflush.h>
 
 static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page);
 
