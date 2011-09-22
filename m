Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab1IVSiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 14:38:08 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:47985 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab1IVSiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 14:38:05 -0400
Date: Thu, 22 Sep 2011 14:32:32 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Christopher S. Aker" <caker@theshore.net>,
        Shaun R <mailinglists@unix-scripts.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: kernel BUG at mm/swapfile.c:2527! [was 3.0.0 Xen
 pv guest - BUG: Unable to handle]
Message-ID: <20110922183232.GA23825@phenom.oracle.com>
References: <9CAEB881-07FE-437C-8A6B-DB7B690CEABE@linode.com>
 <4E5BA49D.5060800@theshore.net>
 <20110829150734.GB24825@dumpdata.com>
 <1314704744.28989.2.camel@zakaz.uk.xensource.com>
 <4E5E9CDB.3070706@theshore.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <4E5E9CDB.3070706@theshore.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4E7B807C.00C7:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> >I'd bet the dereference corresponds to the "*map" in that same place but
> >Peter can you convert that address to a line of code please?
> 
> root@build:/build/xen/domU/i386/3.0.0-linode35-debug# gdb vmlinux
> GNU gdb (GDB) 7.1-ubuntu (...snip...)
> Reading symbols from
> /build/xen/domU/i386/3.0.0-linode35-debug/vmlinux...done.
> (gdb) list *0xc01ab854
> 0xc01ab854 is in swap_count_continued (mm/swapfile.c:2493).
> 2488
> 2489            if (count == (SWAP_MAP_MAX | COUNT_CONTINUED)) { /*
> incrementing */
> 2490                    /*
> 2491                     * Think of how you add 1 to 999
> 2492                     */
> 2493                    while (*map == (SWAP_CONT_MAX | COUNT_CONTINUED)) {
> 2494                            kunmap_atomic(map, KM_USER0);
> 2495                            page = list_entry(page->lru.next,
> struct page, lru);
> 2496                            BUG_ON(page == head);
> 2497                            map = kmap_atomic(page, KM_USER0) + offset;
> (gdb)
> 
> >map came from a kmap_atomic() not far before this point so it appears
> >that it is mapping the wrong page (so *map != 0) and/or mapping a
> >non-existent page (leading to the fault).

First of thanks to Jeremy for help on this one, and Shaun R for lending
me one of his boxes with a environment to easily test it.

The problem looks that in copy_page_range we turn lazy mode on, and then
in swap_entry_free we call swap_count_continued which ends up in:

         map = kmap_atomic(page, KM_USER0) + offset;

and then later on touching *map.

Basically we are forking a process and copying the pages that are also
"swap" pages. We don't need to access the user pages immediately, but we
do for the swap pages as we need proper reference counting.

Well, since we are running in batched mode we don't actually set up the
PTE mappings and the kmap_atomic is not done synchronously and ends up
trying to dereference a page that has not been set.

Looking at kmap_atomic_prot_pfn, it uses 'arch_flush_lazy_mmu_mode' and
sprinkling that in kmap_atomic_prot and __kunmap_atomic seems to make
the problem go away.

This is the patch that looks to be doing the trick. Please double check
if it fixes in your guys setup.


diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index b499626..f4f29b1 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -45,6 +45,7 @@ void *kmap_atomic_prot(struct page *page, pgprot_t prot)
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	BUG_ON(!pte_none(*(kmap_pte-idx)));
 	set_pte(kmap_pte-idx, mk_pte(page, prot));
+	arch_flush_lazy_mmu_mode();
 
 	return (void *)vaddr;
 }
@@ -88,6 +89,7 @@ void __kunmap_atomic(void *kvaddr)
 		 */
 		kpte_clear_flush(kmap_pte-idx, vaddr);
 		kmap_atomic_idx_pop();
+		arch_flush_lazy_mmu_mode();
 	}
 #ifdef CONFIG_DEBUG_HIGHMEM
 	else {



--WIyZ46R2i8wDzkSu
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="flush.patch"

diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index b499626..f4f29b1 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -45,6 +45,7 @@ void *kmap_atomic_prot(struct page *page, pgprot_t prot)
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	BUG_ON(!pte_none(*(kmap_pte-idx)));
 	set_pte(kmap_pte-idx, mk_pte(page, prot));
+	arch_flush_lazy_mmu_mode();
 
 	return (void *)vaddr;
 }
@@ -88,6 +89,7 @@ void __kunmap_atomic(void *kvaddr)
 		 */
 		kpte_clear_flush(kmap_pte-idx, vaddr);
 		kmap_atomic_idx_pop();
+		arch_flush_lazy_mmu_mode();
 	}
 #ifdef CONFIG_DEBUG_HIGHMEM
 	else {

--WIyZ46R2i8wDzkSu--
