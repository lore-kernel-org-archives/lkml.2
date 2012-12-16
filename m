Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab2LPMnu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 07:43:50 -0500
Received: from mga10.intel.com ([192.55.52.92]:40872 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752435Ab2LPMns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 07:43:48 -0500
Message-ID: <1355661820.2903.25.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [GIT PULL] x86/uapi for 3.8
From: Matt Fleming <matt.fleming@intel.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Sun, 16 Dec 2012 12:43:40 +0000
In-Reply-To: <20121215163535.GB229@x4>
References: <201212122211.qBCMBRxl027895@terminus.zytor.com>
	 <23916.1355356085@warthog.procyon.org.uk>
	 <CA+55aFwBh3SY-K_dqdjpqyiBE+_PzbjMc=Qnt-QU9LNaK325TA@mail.gmail.com>
	 <21507.1355528749@warthog.procyon.org.uk>
	 <CA+55aFw34Nwi_aNjN-jm4SHkvT5659_aNVVmvARTCg5=9K0cZg@mail.gmail.com>
	 <CA+55aFytC4xktWHAfQ96cdbt5nu+qbYytUGky8wWAkxZE=J0kw@mail.gmail.com>
	 <CA+55aFyd5O_GyB_+BgHVYNLW-DV8xMQ9LOgPU34AtCqVvzfDaQ@mail.gmail.com>
	 <20121215163323.GA229@x4> <20121215163535.GB229@x4>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-12-15 at 17:35 +0100, Markus Trippelsdorf wrote:
> On 2012.12.15 at 17:33 +0100, Markus Trippelsdorf wrote:
> > On 2012.12.14 at 17:47 -0800, Linus Torvalds wrote:
> > > On Fri, Dec 14, 2012 at 5:41 PM, Linus Torvalds
> > > <torvalds@linux-foundation.org> wrote:
> > > > I was wrong. It's not the x86 UAPI split, it's the DT pull. More people added.
> > > 
> > > Looking at the merge (just in case it could have done something odd),
> > > I'm starting to worry that this is some nasty heisenbug, and my
> > > bisection is not trustworthy at all. Because the DT pull sure as heck
> > > doesn't look like a likely candidate for anything either.
> > > 
> > > Ho humm. Anybody else see anything strange?
> > 
> > Yes. I'm seeing a BUG early during boot on my machine (RIP=NULL):
> >  
> >  BUG: unable to handle kernel NULL pointer dereference at           (null)
> > 
> > This is caused by:
> > 
> > commit 53b87cf088e2ea68d7c59619d0214cc15bb76133
> > Author: Matt Fleming <matt.fleming@intel.com>
> > Date:   Fri Sep 7 18:23:51 2012 +0100
> > 
> >     x86, mm: Include the entire kernel memory map in trampoline_pgd
> >     
> >     There are various pieces of code in arch/x86 that require a page table
> >     with an identity mapping. Make trampoline_pgd a proper kernel page
> >     table, it currently only includes the kernel text and module space
> >     mapping.
> >     
> >     One new feature of trampoline_pgd is that it now has mappings for the
> >     physical I/O device addresses, which are inserted at ioremap()
> >     time. Some broken implementations of EFI firmware require these
> >     mappings to always be around.
> >     
> >     Acked-by: Jan Beulich <jbeulich@suse.com>
> >     Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> > 
> 
> Adding Matt to CC.

Markus, could you please send me your full dmesg, or if possible the
dmesgs from both a working and non-working kernel.

After looking at your memory map layout, nothing immediately jumps out.

Could you try this revised patch and see if things work better? It's the
only thing I noticed that looked wrong with the original patch (apart
from the >512G ram bug that Yinghai pointed out).

---

>From dbc2a0bc1f3ea6c4df591e691916801e5aac85e3 Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt.fleming@intel.com>
Date: Fri, 7 Sep 2012 18:23:51 +0100
Subject: [PATCH] x86, mm: Include the entire kernel memory map in
 trampoline_pgd

There are various pieces of code in arch/x86 that require a page table
with an identity mapping. Make trampoline_pgd a proper kernel page
table, it currently only includes the kernel text and module space
mapping.

One new feature of trampoline_pgd is that it now has mappings for the
physical I/O device addresses, which are inserted at ioremap()
time. Some broken implementations of EFI firmware require these
mappings to always be around.

Acked-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---

v2: Ensure we update 'paddr' as we work our way through the pgtables.

 arch/x86/mm/init_64.c    |   9 +++-
 arch/x86/mm/ioremap.c    | 111 +++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/realmode/init.c |  17 +++++++-
 3 files changed, 134 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 2b6b4a3..fd4404f 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -108,13 +108,13 @@ void sync_global_pgds(unsigned long start, unsigned long end)
 	for (address = start; address <= end; address += PGDIR_SIZE) {
 		const pgd_t *pgd_ref = pgd_offset_k(address);
 		struct page *page;
+		pgd_t *pgd;
 
 		if (pgd_none(*pgd_ref))
 			continue;
 
 		spin_lock(&pgd_lock);
 		list_for_each_entry(page, &pgd_list, lru) {
-			pgd_t *pgd;
 			spinlock_t *pgt_lock;
 
 			pgd = (pgd_t *)page_address(page) + pgd_index(address);
@@ -130,6 +130,13 @@ void sync_global_pgds(unsigned long start, unsigned long end)
 
 			spin_unlock(pgt_lock);
 		}
+
+		pgd = __va(real_mode_header->trampoline_pgd);
+		pgd += pgd_index(address);
+
+		if (pgd_none(*pgd))
+			set_pgd(pgd, *pgd_ref);
+
 		spin_unlock(&pgd_lock);
 	}
 }
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 78fe3f1..353b64b 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -50,6 +50,113 @@ int ioremap_change_attr(unsigned long vaddr, unsigned long size,
 	return err;
 }
 
+#ifdef CONFIG_X86_64
+static void ident_pte_range(unsigned long paddr, unsigned long vaddr,
+			    pmd_t *ppmd, pmd_t *vpmd, unsigned long end)
+{
+	pte_t *ppte = pte_offset_kernel(ppmd, paddr);
+	pte_t *vpte = pte_offset_kernel(vpmd, vaddr);
+
+	do {
+		set_pte(ppte, *vpte);
+	} while (ppte++, vpte++, vaddr += PAGE_SIZE, vaddr != end);
+}
+
+static int ident_pmd_range(unsigned long paddr, unsigned long vaddr,
+			    pud_t *ppud, pud_t *vpud, unsigned long end)
+{
+	pmd_t *ppmd = pmd_offset(ppud, paddr);
+	pmd_t *vpmd = pmd_offset(vpud, vaddr);
+	unsigned long next;
+
+	do {
+		next = pmd_addr_end(vaddr, end);
+
+		if (!pmd_present(*ppmd)) {
+			pte_t *ppte = (pte_t *)get_zeroed_page(GFP_KERNEL);
+			if (!ppte)
+				return 1;
+
+			set_pmd(ppmd, __pmd(_KERNPG_TABLE | __pa(ppte)));
+		}
+
+		ident_pte_range(paddr, vaddr, ppmd, vpmd, next);
+
+		paddr += PMD_SIZE;
+	} while (ppmd++, vpmd++, vaddr = next, vaddr != end);
+
+	return 0;
+}
+
+static int ident_pud_range(unsigned long paddr, unsigned long vaddr,
+			    pgd_t *ppgd, pgd_t *vpgd, unsigned long end)
+{
+	pud_t *ppud = pud_offset(ppgd, paddr);
+	pud_t *vpud = pud_offset(vpgd, vaddr);
+	unsigned long next;
+
+	do {
+		next = pud_addr_end(vaddr, end);
+
+		if (!pud_present(*ppud)) {
+			pmd_t *ppmd = (pmd_t *)get_zeroed_page(GFP_KERNEL);
+			if (!ppmd)
+				return 1;
+
+			set_pud(ppud, __pud(_KERNPG_TABLE | __pa(ppmd)));
+		}
+
+		if (ident_pmd_range(paddr, vaddr, ppud, vpud, next))
+			return 1;
+
+		paddr += PUD_SIZE;
+	} while (ppud++, vpud++, vaddr = next, vaddr != end);
+
+	return 0;
+}
+
+static int insert_identity_mapping(resource_size_t paddr, unsigned long vaddr,
+				    unsigned long size)
+{
+	unsigned long end = vaddr + size;
+	unsigned long next;
+	pgd_t *vpgd, *ppgd;
+
+	/* Don't map over the guard hole. */
+	if (paddr >= 0x800000000000 || paddr + size > 0x800000000000)
+		return 1;
+
+	ppgd = __va(real_mode_header->trampoline_pgd) + pgd_index(paddr);
+
+	vpgd = pgd_offset_k(vaddr);
+	do {
+		next = pgd_addr_end(vaddr, end);
+
+		if (!pgd_present(*ppgd)) {
+			pud_t *ppud = (pud_t *)get_zeroed_page(GFP_KERNEL);
+			if (!ppud)
+				return 1;
+
+			set_pgd(ppgd, __pgd(_KERNPG_TABLE | __pa(ppud)));
+		}
+
+		if (ident_pud_range(paddr, vaddr, ppgd, vpgd, next))
+			return 1;
+
+		paddr += PGDIR_SIZE;
+	} while (ppgd++, vpgd++, vaddr = next, vaddr != end);
+
+	return 0;
+}
+#else
+static inline int insert_identity_mapping(resource_size_t paddr,
+					  unsigned long vaddr,
+					  unsigned long size)
+{
+	return 0;
+}
+#endif /* CONFIG_X86_64 */
+
 /*
  * Remap an arbitrary physical address space into the kernel virtual
  * address space. Needed when the kernel wants to access high addresses
@@ -163,6 +270,10 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 	ret_addr = (void __iomem *) (vaddr + offset);
 	mmiotrace_ioremap(unaligned_phys_addr, unaligned_size, ret_addr);
 
+	if (insert_identity_mapping(phys_addr, vaddr, size))
+		printk(KERN_WARNING "ioremap: unable to map 0x%llx in identity pagetable\n",
+					(unsigned long long)phys_addr);
+
 	/*
 	 * Check if the request spans more than any BAR in the iomem resource
 	 * tree.
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index cbca565..8e6ab61 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -78,8 +78,21 @@ void __init setup_real_mode(void)
 	*trampoline_cr4_features = read_cr4();
 
 	trampoline_pgd = (u64 *) __va(real_mode_header->trampoline_pgd);
-	trampoline_pgd[0] = __pa(level3_ident_pgt) + _KERNPG_TABLE;
-	trampoline_pgd[511] = __pa(level3_kernel_pgt) + _KERNPG_TABLE;
+
+	/*
+	 * Create an identity mapping for all of physical memory.
+	 */
+	for (i = 0; i <= pgd_index(max_pfn << PAGE_SHIFT); i++) {
+		int index = pgd_index(PAGE_OFFSET) + i;
+
+		trampoline_pgd[i] = (u64)pgd_val(swapper_pg_dir[index]);
+	}
+
+	/*
+	 * Copy the upper-half of the kernel pages tables.
+	 */
+	for (i = pgd_index(PAGE_OFFSET); i < PTRS_PER_PGD; i++)
+		trampoline_pgd[i] = (u64)pgd_val(swapper_pg_dir[i]);
 #endif
 }
 
-- 
1.7.11.7


