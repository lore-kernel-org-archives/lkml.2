Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761251Ab0HMAsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 20:48:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:49049 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599Ab0HMAsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 20:48:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,360,1278313200"; 
   d="scan'208";a="544706353"
Subject: Re: [patch]x86: avoid unnecessary tlb flush
From: Shaohua Li <shaohua.li@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, "hpa@zytor.com" <hpa@zytor.com>
In-Reply-To: <20100805221913.4da0f8be.akpm@linux-foundation.org>
References: <1281065308.29094.5.camel@sli10-desk.sh.intel.com>
	 <20100805221913.4da0f8be.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Aug 2010 08:47:55 +0800
Message-ID: <1281660475.21194.1.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-06 at 13:19 +0800, Andrew Morton wrote:
> On Fri, 06 Aug 2010 11:28:28 +0800 Shaohua Li <shaohua.li@intel.com> wrote:
> 
> > In x86, access and dirty bits are set automatically by CPU when CPU accesses
> > memory. When we go into the code path of below flush_tlb_nonprotect_page(),
> > we already set dirty bit for pte and don't need flush tlb. This might mean
> > tlb entry in some CPUs hasn't dirty bit set, but this doesn't matter. When
> > the CPUs do page write, they will automatically check the bit and no software
> > involved. 
> > 
> > On the other hand, flush tlb in below position is harmful. Test creates CPU
> > number of threads, each thread writes to a same but random address in same vma
> > range and we measure the total time. Under a 4 socket system, original time is
> > 1.96s, while with the patch, the time is 0.8s. Under a 2 socket system, there is
> > 20% time cut too. perf shows a lot of time are taking to send ipi/handle ipi for
> > tlb flush.
> > 
> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > 
> > ---
> >  arch/x86/include/asm/pgtable.h |    3 +++
> >  include/asm-generic/pgtable.h  |    4 ++++
> >  mm/memory.c                    |    2 +-
> >  3 files changed, 8 insertions(+), 1 deletion(-)
> > 
> > Index: linux/arch/x86/include/asm/pgtable.h
> > ===================================================================
> > --- linux.orig/arch/x86/include/asm/pgtable.h	2010-07-29 13:25:12.000000000 +0800
> > +++ linux/arch/x86/include/asm/pgtable.h	2010-08-03 09:02:07.000000000 +0800
> > @@ -603,6 +603,9 @@ static inline void ptep_set_wrprotect(st
> >  	pte_update(mm, addr, ptep);
> >  }
> >  
> > +#define __HAVE_ARCH_FLUSH_TLB_NONPROTECT_PAGE
> > +#define flush_tlb_nonprotect_page(vma, address)
> > +
> >  /*
> >   * clone_pgd_range(pgd_t *dst, pgd_t *src, int count);
> >   *
> > Index: linux/include/asm-generic/pgtable.h
> > ===================================================================
> > --- linux.orig/include/asm-generic/pgtable.h	2010-07-29 13:25:12.000000000 +0800
> > +++ linux/include/asm-generic/pgtable.h	2010-08-03 09:02:07.000000000 +0800
> > @@ -129,6 +129,10 @@ static inline void ptep_set_wrprotect(st
> >  #define move_pte(pte, prot, old_addr, new_addr)	(pte)
> >  #endif
> >  
> > +#ifndef __HAVE_ARCH_FLUSH_TLB_NONPROTECT_PAGE
> > +#define flush_tlb_nonprotect_page(vma, address) flush_tlb_page(vma, address)
> > +#endif
> 
> The preferred technique here is
> 
> #ifndef flush_tlb_nonprotect_page
> #define flush_tlb_nonprotect_page(vma, address) flush_tlb_page(vma, address)
> #endif
> 
> so no need for __HAVE_ARCH_FLUSH_TLB_NONPROTECT_PAGE. 
> include/asm-generic/pgtable.h uses a mix of the two techniques.
ok, updated the patch.


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
 arch/x86/include/asm/pgtable.h |    2 ++
 include/asm-generic/pgtable.h  |    4 ++++
 mm/memory.c                    |    2 +-
 3 files changed, 7 insertions(+), 1 deletion(-)

Index: linux/arch/x86/include/asm/pgtable.h
===================================================================
--- linux.orig/arch/x86/include/asm/pgtable.h	2010-08-13 08:23:13.000000000 +0800
+++ linux/arch/x86/include/asm/pgtable.h	2010-08-13 08:24:53.000000000 +0800
@@ -603,6 +603,8 @@ static inline void ptep_set_wrprotect(st
 	pte_update(mm, addr, ptep);
 }
 
+#define flush_tlb_nonprotect_page(vma, address)
+
 /*
  * clone_pgd_range(pgd_t *dst, pgd_t *src, int count);
  *
Index: linux/include/asm-generic/pgtable.h
===================================================================
--- linux.orig/include/asm-generic/pgtable.h	2010-08-13 08:23:13.000000000 +0800
+++ linux/include/asm-generic/pgtable.h	2010-08-13 08:24:53.000000000 +0800
@@ -129,6 +129,10 @@ static inline void ptep_set_wrprotect(st
 #define move_pte(pte, prot, old_addr, new_addr)	(pte)
 #endif
 
+#ifndef flush_tlb_nonprotect_page
+#define flush_tlb_nonprotect_page(vma, address) flush_tlb_page(vma, address)
+#endif
+
 #ifndef pgprot_noncached
 #define pgprot_noncached(prot)	(prot)
 #endif
Index: linux/mm/memory.c
===================================================================
--- linux.orig/mm/memory.c	2010-08-13 08:23:13.000000000 +0800
+++ linux/mm/memory.c	2010-08-13 08:24:53.000000000 +0800
@@ -3116,7 +3116,7 @@ static inline int handle_pte_fault(struc
 		 * with threads.
 		 */
 		if (flags & FAULT_FLAG_WRITE)
-			flush_tlb_page(vma, address);
+			flush_tlb_nonprotect_page(vma, address);
 	}
 unlock:
 	pte_unmap_unlock(pte, ptl);


