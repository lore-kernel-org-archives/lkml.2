Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934120Ab2JXM6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:58:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56663 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455Ab2JXM6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:58:45 -0400
Date: Wed, 24 Oct 2012 05:57:25 -0700
From: tip-bot for Matt Fleming <matt.fleming@intel.com>
Message-ID: <tip-3e8fa263a97079c74880675c451587bb6899e661@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@kernel.org, keithp@keithp.com, torvalds@linux-foundation.org,
        rui.zhang@intel.com, huang.ying.caritas@gmail.com,
        matt.fleming@intel.com, akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, keithp@keithp.com,
        torvalds@linux-foundation.org, rui.zhang@intel.com,
        huang.ying.caritas@gmail.com, matt.fleming@intel.com,
        akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <1350649546-23541-1-git-send-email-matt@console-pimps.org>
References: <1350649546-23541-1-git-send-email-matt@console-pimps.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/efi:
  Fix oops caused by incorrect set_memory_uc() usage
Git-Commit-ID: 3e8fa263a97079c74880675c451587bb6899e661
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 05:57:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3e8fa263a97079c74880675c451587bb6899e661
Gitweb:     http://git.kernel.org/tip/3e8fa263a97079c74880675c451587bb6899e661
Author:     Matt Fleming <matt.fleming@intel.com>
AuthorDate: Fri, 19 Oct 2012 13:25:46 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 12:48:47 +0200

x86/efi: Fix oops caused by incorrect set_memory_uc() usage

Calling __pa() with an ioremap'd address is invalid. If we
encounter an efi_memory_desc_t without EFI_MEMORY_WB set in
->attribute we currently call set_memory_uc(), which in turn
calls __pa() on a potentially ioremap'd address.

On CONFIG_X86_32 this results in the following oops:

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

The only time we can call set_memory_uc() for a memory region is
when it is part of the direct kernel mapping. For the case where
we ioremap a memory region we must leave it alone.

This patch reimplements the fix from e8c7106280a3 ("x86, efi:
Calling __pa() with an ioremap()ed address is invalid") which
was reverted in e1ad783b12ec because it caused a regression on
some MacBooks (they hung at boot). The regression was caused
because the commit only marked EFI_RUNTIME_SERVICES_DATA as
E820_RESERVED_EFI, when it should have marked all regions that
have the EFI_MEMORY_RUNTIME attribute.

Despite first impressions, it's not possible to use
ioremap_cache() to map all cached memory regions on
CONFIG_X86_64 because of the way that the memory map might be
configured as detailed in the following bug report,

	https://bugzilla.redhat.com/show_bug.cgi?id=748516

e.g. some of the EFI memory regions *need* to be mapped as part
of the direct kernel mapping.

Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Huang Ying <huang.ying.caritas@gmail.com>
Cc: Keith Packard <keithp@keithp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1350649546-23541-1-git-send-email-matt@console-pimps.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/efi.h     |    5 +++--
 arch/x86/platform/efi/efi.c    |   29 ++++++++++++++++++-----------
 arch/x86/platform/efi/efi_64.c |    7 +++++--
 3 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index c9dcc18..36ff332 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -35,7 +35,7 @@ extern unsigned long asmlinkage efi_call_phys(void *, ...);
 #define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)	\
 	efi_call_virt(f, a1, a2, a3, a4, a5, a6)
 
-#define efi_ioremap(addr, size, type)		ioremap_cache(addr, size)
+#define efi_ioremap(addr, size, type, attr)	ioremap_cache(addr, size)
 
 #else /* !CONFIG_X86_32 */
 
@@ -89,7 +89,7 @@ extern u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
 		  (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
 
 extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
-				 u32 type);
+				 u32 type, u64 attribute);
 
 #endif /* CONFIG_X86_32 */
 
@@ -98,6 +98,7 @@ extern void efi_set_executable(efi_memory_desc_t *md, bool executable);
 extern int efi_memblock_x86_reserve_range(void);
 extern void efi_call_phys_prelog(void);
 extern void efi_call_phys_epilog(void);
+extern void efi_memory_uc(u64 addr, unsigned long size);
 
 #ifndef CONFIG_EFI
 /*
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index aded2a9..cb34839 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -810,6 +810,16 @@ void __iomem *efi_lookup_mapped_addr(u64 phys_addr)
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
@@ -823,7 +833,7 @@ void __init efi_enter_virtual_mode(void)
 	efi_memory_desc_t *md, *prev_md = NULL;
 	efi_status_t status;
 	unsigned long size;
-	u64 end, systab, addr, npages, end_pfn;
+	u64 end, systab, end_pfn;
 	void *p, *va, *new_memmap = NULL;
 	int count = 0;
 
@@ -879,10 +889,14 @@ void __init efi_enter_virtual_mode(void)
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
 
@@ -892,13 +906,6 @@ void __init efi_enter_virtual_mode(void)
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
index ac3aa54..95fd505 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -82,7 +82,7 @@ void __init efi_call_phys_epilog(void)
 }
 
 void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
-				 u32 type)
+				 u32 type, u64 attribute)
 {
 	unsigned long last_map_pfn;
 
@@ -92,8 +92,11 @@ void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
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
