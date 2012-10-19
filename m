Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab2JSMZ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 08:25:56 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:36473 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752671Ab2JSMZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 08:25:55 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Matthew Garrett <mjg@redhat.com>, Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        Keith Packard <keithp@keithp.com>
Subject: [PATCH] x86/efi: Fix oops caused by incorrect set_memory_uc() usage
Date: Fri, 19 Oct 2012 13:25:46 +0100
Message-Id: <1350649546-23541-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Calling __pa() with an ioremap'd address is invalid. If we
encounter an efi_memory_desc_t without EFI_MEMORY_WB set in
->attribute we currently call set_memory_uc(), which in turn
calls __pa() on a potentially ioremap'd address. On
CONFIG_X86_32 this results in the following oops,

  BUG: unable to handle kernel paging request at f7f22280
  IP: [<c10257b9>] reserve_ram_pages_type+0x89/0x210
  *pdpt = 0000000001978001 *pde = 0000000001ffb067 *pte = 0000000000000000
  Oops: 0000 [#1] PREEMPT SMP
  Modules linked in:

  Pid: 0, comm: swapper Not tainted 3.0.0-acpi-efi-0805 #3
   EIP: 0060:[<c10257b9>] EFLAGS: 00010202 CPU: 0
   EIP is at reserve_ram_pages_type+0x89/0x210
   EAX: 0070e280 EBX: 38714000 ECX: f7814000 EDX: 00000000
   ESI: 00000000 EDI: 38715000 EBP: c189fef0 ESP: c189fea8
   DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
  Process swapper (pid: 0, ti=c189e000 task=c18bbe60 task.ti=c189e000)
  Stack:
   80000200 ff108000 00000000 c189ff00 00038714 00000000 00000000 c189fed0
   c104f8ca 00038714 00000000 00038715 00000000 00000000 00038715 00000000
   00000010 38715000 c189ff48 c1025aff 38715000 00000000 00000010 00000000
  Call Trace:
   [<c104f8ca>] ? page_is_ram+0x1a/0x40
   [<c1025aff>] reserve_memtype+0xdf/0x2f0
   [<c1024dc9>] set_memory_uc+0x49/0xa0
   [<c19334d0>] efi_enter_virtual_mode+0x1c2/0x3aa
   [<c19216d4>] start_kernel+0x291/0x2f2
   [<c19211c7>] ? loglevel+0x1b/0x1b
   [<c19210bf>] i386_start_kernel+0xbf/0xc8

The only time we can call set_memory_uc() for a memory region is when
it is part of the direct kernel mapping. For the case where we ioremap
a memory region we must leave it alone.

This patch reimplements the fix from e8c7106280a3 ("x86, efi: Calling
__pa() with an ioremap()ed address is invalid") which was reverted in
e1ad783b12ec because it caused a regression on some MacBooks (they
hung at boot). The regression was caused because the commit only
marked EFI_RUNTIME_SERVICES_DATA as E820_RESERVED_EFI, when it should
have marked all regions that have the EFI_MEMORY_RUNTIME
attribute.

Despite first impressions, it's not possible to use ioremap_cache() to
map all cached memory regions on CONFIG_X86_64 because of the way that
the memory map might be configured as detailed in the following bug
report,

	https://bugzilla.redhat.com/show_bug.cgi?id=748516

e.g. some of the EFI memory regions *need* to be mapped as part of the
direct kernel mapping.

Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Huang Ying <huang.ying.caritas@gmail.com>
Cc: Keith Packard <keithp@keithp.com>
---
 arch/x86/include/asm/efi.h     |  5 +++--
 arch/x86/platform/efi/efi.c    | 29 ++++++++++++++++++-----------
 arch/x86/platform/efi/efi_64.c |  7 +++++--
 3 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index ae3bf3b..e56fde0 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -35,7 +35,7 @@ extern unsigned long asmlinkage efi_call_phys(void *, ...);
 #define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)	\
 	efi_call_virt(f, a1, a2, a3, a4, a5, a6)
 
-#define efi_ioremap(addr, size, type)		ioremap_cache(addr, size)
+#define efi_ioremap(addr, size, type, attr)	ioremap_cache(addr, size)
 
 #else /* !CONFIG_X86_32 */
 
@@ -103,7 +103,7 @@ extern void efi_call_virt_epilog(unsigned long);
 		  (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
 
 extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
-				 u32 type);
+				 u32 type, u64 attribute);
 
 #endif /* CONFIG_X86_32 */
 
@@ -112,6 +112,7 @@ extern void efi_set_executable(efi_memory_desc_t *md, bool executable);
 extern int efi_memblock_x86_reserve_range(void);
 extern void efi_call_phys_prelog(void);
 extern void efi_call_phys_epilog(void);
+extern void efi_memory_uc(u64 addr, unsigned long size);
 
 #ifndef CONFIG_EFI
 /*
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 7578344..7679689 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -788,6 +788,16 @@ void __iomem *efi_lookup_mapped_addr(u64 phys_addr)
 	return NULL;
 }
 
+void efi_memory_uc(u64 addr, unsigned long size)
+{
+	unsigned long page_shift = 1UL << EFI_PAGE_SHIFT;
+	u64 npages;
+
+	npages = round_up(size, page_shift) / page_shift;
+	memrange_efi_to_native(&addr, &npages);
+	set_memory_uc(addr, npages);
+}
+
 /*
  * This function will switch the EFI runtime services to virtual mode.
  * Essentially, look through the EFI memmap and map every region that
@@ -801,7 +811,7 @@ void __init efi_enter_virtual_mode(void)
 	efi_memory_desc_t *md, *prev_md = NULL;
 	efi_status_t status;
 	unsigned long size;
-	u64 end, systab, addr, npages, end_pfn;
+	u64 end, systab, end_pfn;
 	void *p, *va, *new_memmap = NULL;
 	int count = 0;
 
@@ -857,10 +867,14 @@ void __init efi_enter_virtual_mode(void)
 		end_pfn = PFN_UP(end);
 		if (end_pfn <= max_low_pfn_mapped
 		    || (end_pfn > (1UL << (32 - PAGE_SHIFT))
-			&& end_pfn <= max_pfn_mapped))
+			&& end_pfn <= max_pfn_mapped)) {
 			va = __va(md->phys_addr);
-		else
-			va = efi_ioremap(md->phys_addr, size, md->type);
+
+			if (!(md->attribute & EFI_MEMORY_WB))
+				efi_memory_uc((u64)(unsigned long)va, size);
+		} else
+			va = efi_ioremap(md->phys_addr, size,
+					 md->type, md->attribute);
 
 		md->virt_addr = (u64) (unsigned long) va;
 
@@ -870,13 +884,6 @@ void __init efi_enter_virtual_mode(void)
 			continue;
 		}
 
-		if (!(md->attribute & EFI_MEMORY_WB)) {
-			addr = md->virt_addr;
-			npages = md->num_pages;
-			memrange_efi_to_native(&addr, &npages);
-			set_memory_uc(addr, npages);
-		}
-
 		systab = (u64) (unsigned long) efi_phys.systab;
 		if (md->phys_addr <= systab && systab < end) {
 			systab += md->virt_addr - md->phys_addr;
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index ddb0174..06c8b2e 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -97,7 +97,7 @@ void __init efi_call_phys_epilog(void)
 }
 
 void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
-				 u32 type)
+				 u32 type, u64 attribute)
 {
 	unsigned long last_map_pfn;
 
@@ -107,8 +107,11 @@ void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
 	last_map_pfn = init_memory_mapping(phys_addr, phys_addr + size);
 	if ((last_map_pfn << PAGE_SHIFT) < phys_addr + size) {
 		unsigned long top = last_map_pfn << PAGE_SHIFT;
-		efi_ioremap(top, size - (top - phys_addr), type);
+		efi_ioremap(top, size - (top - phys_addr), type, attribute);
 	}
 
+	if (!(attribute & EFI_MEMORY_WB))
+		efi_memory_uc((u64)(unsigned long)__va(phys_addr), size);
+
 	return (void __iomem *)__va(phys_addr);
 }
-- 
1.7.11.7

