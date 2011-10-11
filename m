Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab1JKMyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 08:54:09 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:50359 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752373Ab1JKMyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 08:54:08 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <ming@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <mjg@redhat.com>, Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>
Subject: [PATCH] x86, efi: Calling __pa() with an ioremap'd address is invalid
Date: Tue, 11 Oct 2011 13:54:05 +0100
Message-Id: <1318337645-7112-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

If we encounter an efi_memory_desc_t without EFI_MEMORY_WB set in
->attribute we currently call set_memory_uc(), which in turn calls
__pa() on a potentially ioremap'd address. On CONFIG_X86_32 this is
invalid, resulting in the following oops,

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

Let efi_ioremap() handle marking regions as uncached, whether that is
by calling ioremap_nocache() or calling set_memory_uc() on a
non-ioremap'd address.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <ming@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Huang Ying <huang.ying.caritas@gmail.com>
Cc: stable@kernel.org
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/include/asm/efi.h     |   11 +++++++++--
 arch/x86/platform/efi/efi.c    |   21 +++++++++++----------
 arch/x86/platform/efi/efi_64.c |   12 ++++++++++--
 3 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 7093e4a..d0ccbc4 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -33,7 +33,14 @@ extern unsigned long asmlinkage efi_call_phys(void *, ...);
 #define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)	\
 	efi_call_virt(f, a1, a2, a3, a4, a5, a6)
 
-#define efi_ioremap(addr, size, type)		ioremap_cache(addr, size)
+static inline void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
+					u32 type, u64 attr)
+{
+	if (type == EFI_MEMORY_MAPPED_IO || !(attr & EFI_MEMORY_WB))
+		return ioremap_nocache(addr, size);
+	else
+		return ioremap_cache(addr, size);
+}
 
 #else /* !CONFIG_X86_32 */
 
@@ -85,7 +92,7 @@ extern u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
 		  (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
 
 extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
-				 u32 type);
+				 u32 type, u64 attr);
 
 #endif /* CONFIG_X86_32 */
 
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 3ae4128..87f2295 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -670,10 +670,18 @@ void __init efi_enter_virtual_mode(void)
 		end_pfn = PFN_UP(end);
 		if (end_pfn <= max_low_pfn_mapped
 		    || (end_pfn > (1UL << (32 - PAGE_SHIFT))
-			&& end_pfn <= max_pfn_mapped))
+			&& end_pfn <= max_pfn_mapped)) {
 			va = __va(md->phys_addr);
-		else
-			va = efi_ioremap(md->phys_addr, size, md->type);
+
+			if (!(md->attribute & EFI_MEMORY_WB)) {
+				addr = (u64) (unsigned long)va;
+				npages = md->num_pages;
+				memrange_efi_to_native(&addr, &npages);
+				set_memory_uc(addr, npages);
+			}
+		} else
+			va = efi_ioremap(md->phys_addr, size,
+					 md->type, md->attribute);
 
 		md->virt_addr = (u64) (unsigned long) va;
 
@@ -683,13 +691,6 @@ void __init efi_enter_virtual_mode(void)
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
index ac3aa54..6d6e877 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -82,9 +82,10 @@ void __init efi_call_phys_epilog(void)
 }
 
 void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
-				 u32 type)
+				 u32 type, u64 attr)
 {
 	unsigned long last_map_pfn;
+	u64 addr, npages;
 
 	if (type == EFI_MEMORY_MAPPED_IO)
 		return ioremap(phys_addr, size);
@@ -92,7 +93,14 @@ void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
 	last_map_pfn = init_memory_mapping(phys_addr, phys_addr + size);
 	if ((last_map_pfn << PAGE_SHIFT) < phys_addr + size) {
 		unsigned long top = last_map_pfn << PAGE_SHIFT;
-		efi_ioremap(top, size - (top - phys_addr), type);
+		efi_ioremap(top, size - (top - phys_addr), type, attr);
+	}
+
+	if (!(attr & EFI_MEMORY_WB)) {
+		addr = (u64)(unsigned long)__va(phys_addr);
+		npages = size >> EFI_PAGE_SHIFT;
+		memrange_efi_to_native(&addr, &npages);
+		set_memory_uc(addr, npages);
 	}
 
 	return (void __iomem *)__va(phys_addr);
-- 
1.7.4.4

