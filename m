Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934775Ab1ESUy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 16:54:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43910 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934726Ab1ESUyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 16:54:25 -0400
Date: Thu, 19 May 2011 22:54:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/efi changes for v2.6.40
Message-ID: <20110519205409.GA4256@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-efi-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-efi-for-linus

 Thanks,

	Ingo

------------------>
Matthew Garrett (5):
      x86, efi: Remove virtual-mode SetVirtualAddressMap call
      x86, efi: Consolidate EFI nx control
      x86, efi: Merge contiguous memory regions of the same type and attribute
      x86, efi: Pass a minimal map to SetVirtualAddressMap()
      x86, efi: Ensure that the entirity of a region is mapped


 arch/x86/include/asm/efi.h     |    1 +
 arch/x86/platform/efi/efi.c    |   78 +++++++++++++++++++++++++++++-----------
 arch/x86/platform/efi/efi_64.c |   34 +++++-------------
 3 files changed, 67 insertions(+), 46 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 8e4a165..7093e4a 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -90,6 +90,7 @@ extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
 #endif /* CONFIG_X86_32 */
 
 extern int add_efi_memmap;
+extern void efi_set_executable(efi_memory_desc_t *md, bool executable);
 extern void efi_memblock_x86_reserve_range(void);
 extern void efi_call_phys_prelog(void);
 extern void efi_call_phys_epilog(void);
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 0fe27d7..b30aa26 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -145,17 +145,6 @@ static void virt_efi_reset_system(int reset_type,
 		       data_size, data);
 }
 
-static efi_status_t virt_efi_set_virtual_address_map(
-	unsigned long memory_map_size,
-	unsigned long descriptor_size,
-	u32 descriptor_version,
-	efi_memory_desc_t *virtual_map)
-{
-	return efi_call_virt4(set_virtual_address_map,
-			      memory_map_size, descriptor_size,
-			      descriptor_version, virtual_map);
-}
-
 static efi_status_t __init phys_efi_set_virtual_address_map(
 	unsigned long memory_map_size,
 	unsigned long descriptor_size,
@@ -468,11 +457,25 @@ void __init efi_init(void)
 #endif
 }
 
+void __init efi_set_executable(efi_memory_desc_t *md, bool executable)
+{
+	u64 addr, npages;
+
+	addr = md->virt_addr;
+	npages = md->num_pages;
+
+	memrange_efi_to_native(&addr, &npages);
+
+	if (executable)
+		set_memory_x(addr, npages);
+	else
+		set_memory_nx(addr, npages);
+}
+
 static void __init runtime_code_page_mkexec(void)
 {
 	efi_memory_desc_t *md;
 	void *p;
-	u64 addr, npages;
 
 	/* Make EFI runtime service code area executable */
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
@@ -481,10 +484,7 @@ static void __init runtime_code_page_mkexec(void)
 		if (md->type != EFI_RUNTIME_SERVICES_CODE)
 			continue;
 
-		addr = md->virt_addr;
-		npages = md->num_pages;
-		memrange_efi_to_native(&addr, &npages);
-		set_memory_x(addr, npages);
+		efi_set_executable(md, true);
 	}
 }
 
@@ -498,13 +498,42 @@ static void __init runtime_code_page_mkexec(void)
  */
 void __init efi_enter_virtual_mode(void)
 {
-	efi_memory_desc_t *md;
+	efi_memory_desc_t *md, *prev_md = NULL;
 	efi_status_t status;
 	unsigned long size;
 	u64 end, systab, addr, npages, end_pfn;
-	void *p, *va;
+	void *p, *va, *new_memmap = NULL;
+	int count = 0;
 
 	efi.systab = NULL;
+
+	/* Merge contiguous regions of the same type and attribute */
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		u64 prev_size;
+		md = p;
+
+		if (!prev_md) {
+			prev_md = md;
+			continue;
+		}
+
+		if (prev_md->type != md->type ||
+		    prev_md->attribute != md->attribute) {
+			prev_md = md;
+			continue;
+		}
+
+		prev_size = prev_md->num_pages << EFI_PAGE_SHIFT;
+
+		if (md->phys_addr == (prev_md->phys_addr + prev_size)) {
+			prev_md->num_pages += md->num_pages;
+			md->type = EFI_RESERVED_TYPE;
+			md->attribute = 0;
+			continue;
+		}
+		prev_md = md;
+	}
+
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
 		if (!(md->attribute & EFI_MEMORY_RUNTIME))
@@ -541,15 +570,21 @@ void __init efi_enter_virtual_mode(void)
 			systab += md->virt_addr - md->phys_addr;
 			efi.systab = (efi_system_table_t *) (unsigned long) systab;
 		}
+		new_memmap = krealloc(new_memmap,
+				      (count + 1) * memmap.desc_size,
+				      GFP_KERNEL);
+		memcpy(new_memmap + (count * memmap.desc_size), md,
+		       memmap.desc_size);
+		count++;
 	}
 
 	BUG_ON(!efi.systab);
 
 	status = phys_efi_set_virtual_address_map(
-		memmap.desc_size * memmap.nr_map,
+		memmap.desc_size * count,
 		memmap.desc_size,
 		memmap.desc_version,
-		memmap.phys_map);
+		(efi_memory_desc_t *)__pa(new_memmap));
 
 	if (status != EFI_SUCCESS) {
 		printk(KERN_ALERT "Unable to switch EFI into virtual mode "
@@ -572,11 +607,12 @@ void __init efi_enter_virtual_mode(void)
 	efi.set_variable = virt_efi_set_variable;
 	efi.get_next_high_mono_count = virt_efi_get_next_high_mono_count;
 	efi.reset_system = virt_efi_reset_system;
-	efi.set_virtual_address_map = virt_efi_set_virtual_address_map;
+	efi.set_virtual_address_map = NULL;
 	if (__supported_pte_mask & _PAGE_NX)
 		runtime_code_page_mkexec();
 	early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
 	memmap.map = NULL;
+	kfree(new_memmap);
 }
 
 /*
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index ac0621a..2649426 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -41,22 +41,7 @@
 static pgd_t save_pgd __initdata;
 static unsigned long efi_flags __initdata;
 
-static void __init early_mapping_set_exec(unsigned long start,
-					  unsigned long end,
-					  int executable)
-{
-	unsigned long num_pages;
-
-	start &= PMD_MASK;
-	end = (end + PMD_SIZE - 1) & PMD_MASK;
-	num_pages = (end - start) >> PAGE_SHIFT;
-	if (executable)
-		set_memory_x((unsigned long)__va(start), num_pages);
-	else
-		set_memory_nx((unsigned long)__va(start), num_pages);
-}
-
-static void __init early_runtime_code_mapping_set_exec(int executable)
+static void __init early_code_mapping_set_exec(int executable)
 {
 	efi_memory_desc_t *md;
 	void *p;
@@ -67,11 +52,8 @@ static void __init early_runtime_code_mapping_set_exec(int executable)
 	/* Make EFI runtime service code area executable */
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
-		if (md->type == EFI_RUNTIME_SERVICES_CODE) {
-			unsigned long end;
-			end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
-			early_mapping_set_exec(md->phys_addr, end, executable);
-		}
+		if (md->type == EFI_RUNTIME_SERVICES_CODE)
+			efi_set_executable(md, executable);
 	}
 }
 
@@ -79,7 +61,7 @@ void __init efi_call_phys_prelog(void)
 {
 	unsigned long vaddress;
 
-	early_runtime_code_mapping_set_exec(1);
+	early_code_mapping_set_exec(1);
 	local_irq_save(efi_flags);
 	vaddress = (unsigned long)__va(0x0UL);
 	save_pgd = *pgd_offset_k(0x0UL);
@@ -95,7 +77,7 @@ void __init efi_call_phys_epilog(void)
 	set_pgd(pgd_offset_k(0x0UL), save_pgd);
 	__flush_tlb_all();
 	local_irq_restore(efi_flags);
-	early_runtime_code_mapping_set_exec(0);
+	early_code_mapping_set_exec(0);
 }
 
 void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
@@ -107,8 +89,10 @@ void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
 		return ioremap(phys_addr, size);
 
 	last_map_pfn = init_memory_mapping(phys_addr, phys_addr + size);
-	if ((last_map_pfn << PAGE_SHIFT) < phys_addr + size)
-		return NULL;
+	if ((last_map_pfn << PAGE_SHIFT) < phys_addr + size) {
+		unsigned long top = last_map_pfn << PAGE_SHIFT;
+		efi_ioremap(top, size - (top - phys_addr), type);
+	}
 
 	return (void __iomem *)__va(phys_addr);
 }
