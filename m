Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab0CWGDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 02:03:39 -0400
Received: from mga10.intel.com ([192.55.52.92]:21326 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751772Ab0CWGDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 02:03:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,292,1267430400"; 
   d="scan'208,223";a="783073378"
Message-ID: <4BA859B7.4070906@linux.intel.com>
Date: Tue, 23 Mar 2010 14:03:35 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: John Villalovos <sodarock@gmail.com>
CC: ak@linux.intel.com, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>,
       "Li, Haicheng" <haicheng.li@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX] [PATCH] x86: update all PGDs for direct mapping changes
 	on 64bit.
References: <4BA7344C.6030108@linux.intel.com> <5e61b72f1003220741s741c56bbn886243d02f6f66ac@mail.gmail.com>
In-Reply-To: <5e61b72f1003220741s741c56bbn886243d02f6f66ac@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------080708080103010705040405"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080708080103010705040405
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

John,

The patch is attached. On my side, last email is OK without corruption.

John Villalovos wrote:
> On Mon, Mar 22, 2010 at 5:11 AM, Haicheng Li
> <haicheng.li@linux.intel.com> wrote:
>> Hello,
>>
>> In our recent CPU/MEM hotplug testing, a kernel BUG() was found:
> 
> Haicheng,
> 
> Maybe it is just my mail reader but the patch seems corrupted with
> extraneous space characters.
> 
> Any chance it can be reposted?
> 
> Thanks,
> John

--------------080708080103010705040405
Content-Type: text/x-patch;
 name="0001-x86-update-all-PGDs-for-direct-mapping-changes-on-6.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-x86-update-all-PGDs-for-direct-mapping-changes-on-6.pat";
 filename*1="ch"

>From 3cf6b38b984b49f03dd5b72258b301eb17b55d62 Mon Sep 17 00:00:00 2001
From: Haicheng Li <haicheng.li@linux.intel.com>
Date: Mon, 22 Mar 2010 13:20:00 +0800
Subject: [PATCH] x86: update all PGDs for direct mapping changes on 64bit.

When memory hotadd/removal happens for a large enough area
that a new PGD entry is needed for the direct mapping, the PGDs
of other processes would not get updated. This leads to some CPUs
oopsing when they have to access the unmapped areas.

This patch makes sure to always replicate new direct mapping PGD entries
to the PGDs of all processes.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
---
 arch/x86/mm/init_64.c |   82 ++++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 67 insertions(+), 15 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index e9b040e..384ca43 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -96,6 +96,37 @@ static int __init nonx32_setup(char *str)
 }
 __setup("noexec32=", nonx32_setup);
 
+
+/*
+ * When memory was added/removed make sure all the processes MM have
+ * suitable PGD entries in the local PGD level page.
+ * Caller must flush global TLBs if needed (old mapping changed)
+ */
+static void sync_global_pgds(unsigned long start, unsigned long end)
+{
+	unsigned long flags;
+	struct page *page;
+	unsigned long addr;
+
+	spin_lock_irqsave(&pgd_lock, flags);
+	for (addr = start; addr < end; addr += PGDIR_SIZE) {
+		pgd_t *ref_pgd = pgd_offset_k(addr);
+		list_for_each_entry(page, &pgd_list, lru) {
+			pgd_t *pgd_base = page_address(page);
+			pgd_t *pgd = pgd_base + pgd_index(addr);
+
+			/*
+			 * When the state is the same in one other,
+			 * assume it's the same everywhere.
+			 */
+			if (pgd_base != init_mm.pgd &&
+			    !!pgd_none(*pgd) != !!pgd_none(*ref_pgd))
+				set_pgd(pgd, *ref_pgd);
+		}
+	}
+	spin_unlock_irqrestore(&pgd_lock, flags);
+}
+
 /*
  * NOTE: This function is marked __ref because it calls __init function
  * (alloc_bootmem_pages). It's safe to do it ONLY when after_bootmem == 0.
@@ -217,6 +248,8 @@ static void __init __init_extra_mapping(unsigned long phys, unsigned long size,
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
+	int pgd_changed = 0;
+	unsigned long addr = phys;
 
 	BUG_ON((phys & ~PMD_MASK) || (size & ~PMD_MASK));
 	for (; size; phys += PMD_SIZE, size -= PMD_SIZE) {
@@ -225,6 +258,7 @@ static void __init __init_extra_mapping(unsigned long phys, unsigned long size,
 			pud = (pud_t *) spp_getpage();
 			set_pgd(pgd, __pgd(__pa(pud) | _KERNPG_TABLE |
 						_PAGE_USER));
+			pgd_changed = 1;
 		}
 		pud = pud_offset(pgd, (unsigned long)__va(phys));
 		if (pud_none(*pud)) {
@@ -236,6 +270,11 @@ static void __init __init_extra_mapping(unsigned long phys, unsigned long size,
 		BUG_ON(!pmd_none(*pmd));
 		set_pmd(pmd, __pmd(phys | pgprot_val(prot)));
 	}
+	if (pgd_changed) {
+		sync_global_pgds(addr, addr + size);
+		/* Might not be needed if the previous mapping was always zero*/
+		__flush_tlb_all();
+	}
 }
 
 void __init init_extra_mapping_wb(unsigned long phys, unsigned long size)
@@ -533,36 +572,41 @@ kernel_physical_mapping_init(unsigned long start,
 			     unsigned long end,
 			     unsigned long page_size_mask)
 {
-
+	int pgd_changed = 0;
 	unsigned long next, last_map_addr = end;
+	unsigned long addr;
 
 	start = (unsigned long)__va(start);
 	end = (unsigned long)__va(end);
 
-	for (; start < end; start = next) {
-		pgd_t *pgd = pgd_offset_k(start);
+	for (addr = start; addr < end; addr = next) {
+		pgd_t *pgd = pgd_offset_k(addr);
 		unsigned long pud_phys;
 		pud_t *pud;
 
-		next = (start + PGDIR_SIZE) & PGDIR_MASK;
+		next = (addr + PGDIR_SIZE) & PGDIR_MASK;
 		if (next > end)
 			next = end;
 
 		if (pgd_val(*pgd)) {
-			last_map_addr = phys_pud_update(pgd, __pa(start),
+			last_map_addr = phys_pud_update(pgd, __pa(addr),
 						 __pa(end), page_size_mask);
 			continue;
 		}
 
 		pud = alloc_low_page(&pud_phys);
-		last_map_addr = phys_pud_init(pud, __pa(start), __pa(next),
+		last_map_addr = phys_pud_init(pud, __pa(addr), __pa(next),
 						 page_size_mask);
 		unmap_low_page(pud);
 
 		spin_lock(&init_mm.page_table_lock);
 		pgd_populate(&init_mm, pgd, __va(pud_phys));
 		spin_unlock(&init_mm.page_table_lock);
+		pgd_changed = 1;
 	}
+
+	if (pgd_changed)
+		sync_global_pgds(start, end);
 	__flush_tlb_all();
 
 	return last_map_addr;
@@ -938,35 +982,37 @@ static int __meminitdata node_start;
 int __meminit
 vmemmap_populate(struct page *start_page, unsigned long size, int node)
 {
-	unsigned long addr = (unsigned long)start_page;
+	unsigned long start = (unsigned long)start_page;
 	unsigned long end = (unsigned long)(start_page + size);
-	unsigned long next;
+	unsigned long addr, next;
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
+	int err = -ENOMEM;
 
-	for (; addr < end; addr = next) {
+	for (addr = start; addr < end; addr = next) {
 		void *p = NULL;
 
+		err = -ENOMEM;
 		pgd = vmemmap_pgd_populate(addr, node);
 		if (!pgd)
-			return -ENOMEM;
+			break;
 
 		pud = vmemmap_pud_populate(pgd, addr, node);
 		if (!pud)
-			return -ENOMEM;
+			break;
 
 		if (!cpu_has_pse) {
 			next = (addr + PAGE_SIZE) & PAGE_MASK;
 			pmd = vmemmap_pmd_populate(pud, addr, node);
 
 			if (!pmd)
-				return -ENOMEM;
+				break;
 
 			p = vmemmap_pte_populate(pmd, addr, node);
 
 			if (!p)
-				return -ENOMEM;
+				break;
 
 			addr_end = addr + PAGE_SIZE;
 			p_end = p + PAGE_SIZE;
@@ -979,7 +1025,7 @@ vmemmap_populate(struct page *start_page, unsigned long size, int node)
 
 				p = vmemmap_alloc_block_buf(PMD_SIZE, node);
 				if (!p)
-					return -ENOMEM;
+					break;
 
 				entry = pfn_pte(__pa(p) >> PAGE_SHIFT,
 						PAGE_KERNEL_LARGE);
@@ -1000,9 +1046,15 @@ vmemmap_populate(struct page *start_page, unsigned long size, int node)
 			} else
 				vmemmap_verify((pte_t *)pmd, node, addr, next);
 		}
+		err = 0;
+	}
 
+	if (!err) {
+		sync_global_pgds(start, end);
+		__flush_tlb_all();
 	}
-	return 0;
+
+	return err;
 }
 
 void __meminit vmemmap_populate_print_last(void)
-- 
1.5.6.1


--------------080708080103010705040405--
