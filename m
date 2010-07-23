Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab0GWDPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 23:15:16 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54518 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743Ab0GWDPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 23:15:13 -0400
Date: Fri, 23 Jul 2010 13:15:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the catalin tree with the arm tree
Message-Id: <20100723131509.8614658a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

Today's linux-next merge of the catalin tree got a conflict in
arch/arm/mm/mmu.c between commit 3abe9d33b382cb9eee7bfee8d90b10078f4baa4d
("ARM: early_alloc()") from the arm tree and commit
838105a674b7b72cb26c346155a40901c5bf7723 ("ARM: Remove the domain
switching on ARMv6k/v7 CPUs") from the catalin tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mm/mmu.c
index 9ee3c75,e107f1b..0000000
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@@ -11,12 -11,14 +11,13 @@@
  #include <linux/kernel.h>
  #include <linux/errno.h>
  #include <linux/init.h>
 -#include <linux/bootmem.h>
  #include <linux/mman.h>
  #include <linux/nodemask.h>
 +#include <linux/memblock.h>
  #include <linux/sort.h>
+ #include <linux/fs.h>
  
  #include <asm/cputype.h>
 -#include <asm/mach-types.h>
  #include <asm/sections.h>
  #include <asm/cachetype.h>
  #include <asm/setup.h>
@@@ -498,30 -488,33 +500,43 @@@ static void __init build_mem_type_table
  	}
  }
  
+ #ifdef CONFIG_ARM_DMA_MEM_BUFFERABLE
+ pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
+ 			      unsigned long size, pgprot_t vma_prot)
+ {
+ 	if (!pfn_valid(pfn))
+ 		return pgprot_noncached(vma_prot);
+ 	else if (file->f_flags & O_SYNC)
+ 		return pgprot_writecombine(vma_prot);
+ 	return vma_prot;
+ }
+ EXPORT_SYMBOL(phys_mem_access_prot);
+ #endif
+ 
  #define vectors_base()	(vectors_high() ? 0xffff0000 : 0)
  
 -static void __init alloc_init_pte(pmd_t *pmd, unsigned long addr,
 -				  unsigned long end, unsigned long pfn,
 -				  const struct mem_type *type)
 +static void __init *early_alloc(unsigned long sz)
  {
 -	pte_t *pte;
 +	void *ptr = __va(memblock_alloc(sz, sz));
 +	memset(ptr, 0, sz);
 +	return ptr;
 +}
  
 +static pte_t *early_pte_alloc(pmd_t *pmd, unsigned long addr, unsigned long prot)
 +{
  	if (pmd_none(*pmd)) {
 -		pte = alloc_bootmem_low_pages(2 * PTRS_PER_PTE * sizeof(pte_t));
 -		__pmd_populate(pmd, __pa(pte) | type->prot_l1);
 +		pte_t *pte = early_alloc(2 * PTRS_PER_PTE * sizeof(pte_t));
 +		__pmd_populate(pmd, __pa(pte) | prot);
  	}
 +	BUG_ON(pmd_bad(*pmd));
 +	return pte_offset_kernel(pmd, addr);
 +}
  
 -	pte = pte_offset_kernel(pmd, addr);
 +static void __init alloc_init_pte(pmd_t *pmd, unsigned long addr,
 +				  unsigned long end, unsigned long pfn,
 +				  const struct mem_type *type)
 +{
 +	pte_t *pte = early_pte_alloc(pmd, addr, type->prot_l1);
  	do {
  		set_pte_ext(pte, pfn_pte(pfn, __pgprot(type->prot_pte)), 0);
  		pfn++;
@@@ -888,7 -954,7 +902,7 @@@ static void __init devicemaps_init(stru
  	/*
  	 * Allocate the vector page early.
  	 */
- 	vectors = early_alloc(PAGE_SIZE);
 -	vectors_page = alloc_bootmem_low_pages(PAGE_SIZE);
++	vectors_page = early_alloc(PAGE_SIZE);
  
  	for (addr = VMALLOC_END; addr; addr += PGDIR_SIZE)
  		pmd_clear(pmd_off_k(addr));
