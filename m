Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab1KGPrL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:47:11 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:53861 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754901Ab1KGPrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:47:08 -0500
From: Matt Fleming <matt@console-pimps.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [PATCH v3] x86, efi: Calling __pa() with an ioremap'd address is invalid
Date: Mon,  7 Nov 2011 15:46:58 +0000
Message-Id: <1320680818-2951-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

(Sorry for people seeing this email twice)

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

So, if we're ioremap'ing an address range let's setup the mapping with
the correct caching attribute from the start instead of modifying it
after the fact. The uncached case can be handled by ioremap_nocache()
for both 32-bit and 64-bit. However, in the cached case we need to
handle the mapping differently. CONFIG_X86_64 can simply extend the
direct kernel mapping to include the address range, whereas on
CONFIG_X86_32 we need to use ioremap_cache().

Despite first impressions, it's not possible to use ioremap_cache()
for CONFIG_X86_64 because of the way that the memory map might be
configured as detailed in the following bug report,

	https://bugzilla.redhat.com/show_bug.cgi?id=748516

We need to be careful to ensure that any EFI_RUNTIME_SERVICES_DATA
regions are covered by the direct kernel mapping table on
CONFIG_X86_64, which unfortunately means we can't unify the 32-bit and
64-bit efi_ioremap() implementations.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Huang Ying <huang.ying.caritas@gmail.com>
Cc: stable@kernel.org
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---

The two previous version of this patch can be found here,

 1. https://lkml.org/lkml/2011/10/11/157
 2. http://lkml.org/lkml/2011/10/14/155

After the feedback from v1 I tried to unify the efi_ioremap()
implementations but ran into the issue detailed in the RH bug report
in the changelog. Unless we teach the x86 setup code that
EFI_RUNTIME_SERVICES_DATA regions should be part of the direct kernel
mapping table (even though they're marked as E820_RESERVED) I think
this patch makes the most sense.

 arch/x86/include/asm/efi.h     |    5 ++---
 arch/x86/platform/efi/efi.c    |   24 ++++++++++++++----------
 arch/x86/platform/efi/efi_64.c |    8 ++------
 3 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 7093e4a..940107d 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -33,7 +33,7 @@ extern unsigned long asmlinkage efi_call_phys(void *, ...);
 #define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)	\
 	efi_call_virt(f, a1, a2, a3, a4, a5, a6)
 
-#define efi_ioremap(addr, size, type)		ioremap_cache(addr, size)
+#define efi_ioremap(addr, size)		ioremap_cache(addr, size)
 
 #else /* !CONFIG_X86_32 */
 
@@ -84,8 +84,7 @@ extern u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
 	efi_call6((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
 
-extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
-				 u32 type);
+extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size);
 
 #endif /* CONFIG_X86_32 */
 
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 3ae4128..8f2f7f6 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -670,10 +670,21 @@ void __init efi_enter_virtual_mode(void)
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
+		} else {
+			if (!(md->attribute & EFI_MEMORY_WB))
+				va = ioremap_nocache(md->phys_addr, size);
+			else
+				va = efi_ioremap(md->phys_addr, size);
+		}
 
 		md->virt_addr = (u64) (unsigned long) va;
 
@@ -683,13 +694,6 @@ void __init efi_enter_virtual_mode(void)
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
index ac3aa54..1f4b86b 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -81,18 +81,14 @@ void __init efi_call_phys_epilog(void)
 	early_code_mapping_set_exec(0);
 }
 
-void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
-				 u32 type)
+void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size)
 {
 	unsigned long last_map_pfn;
 
-	if (type == EFI_MEMORY_MAPPED_IO)
-		return ioremap(phys_addr, size);
-
 	last_map_pfn = init_memory_mapping(phys_addr, phys_addr + size);
 	if ((last_map_pfn << PAGE_SHIFT) < phys_addr + size) {
 		unsigned long top = last_map_pfn << PAGE_SHIFT;
-		efi_ioremap(top, size - (top - phys_addr), type);
+		efi_ioremap(top, size - (top - phys_addr));
 	}
 
 	return (void __iomem *)__va(phys_addr);
-- 
1.7.4.4

