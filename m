Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab1LIUJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 15:09:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46314 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab1LIUJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 15:09:15 -0500
Date: Fri, 9 Dec 2011 12:08:56 -0800
From: tip-bot for Matt Fleming <matt.fleming@intel.com>
Message-ID: <tip-e8c7106280a305e1ff2a3a8a4dfce141469fb039@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@redhat.com, torvalds@linux-foundation.org, rui.zhang@intel.com,
        huang.ying.caritas@gmail.com, matt.fleming@intel.com,
        akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        rui.zhang@intel.com, huang.ying.caritas@gmail.com,
        matt.fleming@intel.com, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1321621751-3650-1-git-send-email-matt@console-pimps.org>
References: <1321621751-3650-1-git-send-email-matt@console-pimps.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, efi: Calling __pa() with an ioremap()ed address is invalid
Git-Commit-ID: e8c7106280a305e1ff2a3a8a4dfce141469fb039
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 09 Dec 2011 12:09:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e8c7106280a305e1ff2a3a8a4dfce141469fb039
Gitweb:     http://git.kernel.org/tip/e8c7106280a305e1ff2a3a8a4dfce141469fb039
Author:     Matt Fleming <matt.fleming@intel.com>
AuthorDate: Fri, 18 Nov 2011 13:09:11 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 9 Dec 2011 08:32:26 +0100

x86, efi: Calling __pa() with an ioremap()ed address is invalid

If we encounter an efi_memory_desc_t without EFI_MEMORY_WB set
in ->attribute we currently call set_memory_uc(), which in turn
calls __pa() on a potentially ioremap'd address.

On CONFIG_X86_32 this is invalid, resulting in the following
oops on some machines:

  BUG: unable to handle kernel paging request at f7f22280
  IP: [<c10257b9>] reserve_ram_pages_type+0x89/0x210
  [...]

  Call Trace:
   [<c104f8ca>] ? page_is_ram+0x1a/0x40
   [<c1025aff>] reserve_memtype+0xdf/0x2f0
   [<c1024dc9>] set_memory_uc+0x49/0xa0
   [<c19334d0>] efi_enter_virtual_mode+0x1c2/0x3aa
   [<c19216d4>] start_kernel+0x291/0x2f2
   [<c19211c7>] ? loglevel+0x1b/0x1b
   [<c19210bf>] i386_start_kernel+0xbf/0xc8

A better approach to this problem is to map the memory region
with the correct attributes from the start, instead of modifying
it after the fact. The uncached case can be handled by
ioremap_nocache() and the cached by ioremap_cache().

Despite first impressions, it's not possible to use
ioremap_cache() to map all cached memory regions on
CONFIG_X86_64 because EFI_RUNTIME_SERVICES_DATA regions really
don't like being mapped into the vmalloc space, as detailed in
the following bug report,

	https://bugzilla.redhat.com/show_bug.cgi?id=748516

Therefore, we need to ensure that any EFI_RUNTIME_SERVICES_DATA
regions are covered by the direct kernel mapping table on
CONFIG_X86_64. To accomplish this we now map E820_RESERVED_EFI
regions via the direct kernel mapping with the initial call to
init_memory_mapping() in setup_arch(), whereas previously these
regions wouldn't be mapped if they were after the last E820_RAM
region until efi_ioremap() was called. Doing it this way allows
us to delete efi_ioremap() completely.

Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Huang Ying <huang.ying.caritas@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1321621751-3650-1-git-send-email-matt@console-pimps.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/e820.h    |    8 ++++++++
 arch/x86/include/asm/efi.h     |    5 -----
 arch/x86/kernel/e820.c         |    3 ++-
 arch/x86/kernel/setup.c        |   21 ++++++++++++++++++++-
 arch/x86/platform/efi/efi.c    |   29 ++++++++++++++++++-----------
 arch/x86/platform/efi/efi_64.c |   17 -----------------
 6 files changed, 48 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index 908b969..c954703 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -53,6 +53,13 @@
  */
 #define E820_RESERVED_KERN        128
 
+/*
+ * Address ranges that need to be mapped by the kernel direct
+ * mapping. This is used to make sure regions such as
+ * EFI_RUNTIME_SERVICES_DATA are directly mapped. See setup_arch().
+ */
+#define E820_RESERVED_EFI         129
+
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
 struct e820entry {
@@ -115,6 +122,7 @@ static inline void early_memtest(unsigned long start, unsigned long end)
 }
 #endif
 
+extern unsigned long e820_end_pfn(unsigned long limit_pfn, unsigned type);
 extern unsigned long e820_end_of_ram_pfn(void);
 extern unsigned long e820_end_of_low_ram_pfn(void);
 extern u64 early_reserve_e820(u64 startt, u64 sizet, u64 align);
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 7093e4a..b8d8bfc 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -33,8 +33,6 @@ extern unsigned long asmlinkage efi_call_phys(void *, ...);
 #define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)	\
 	efi_call_virt(f, a1, a2, a3, a4, a5, a6)
 
-#define efi_ioremap(addr, size, type)		ioremap_cache(addr, size)
-
 #else /* !CONFIG_X86_32 */
 
 extern u64 efi_call0(void *fp);
@@ -84,9 +82,6 @@ extern u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
 	efi_call6((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
 
-extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
-				 u32 type);
-
 #endif /* CONFIG_X86_32 */
 
 extern int add_efi_memmap;
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 303a0e4..65ffd11 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -135,6 +135,7 @@ static void __init e820_print_type(u32 type)
 		printk(KERN_CONT "(usable)");
 		break;
 	case E820_RESERVED:
+	case E820_RESERVED_EFI:
 		printk(KERN_CONT "(reserved)");
 		break;
 	case E820_ACPI:
@@ -783,7 +784,7 @@ u64 __init early_reserve_e820(u64 startt, u64 sizet, u64 align)
 /*
  * Find the highest page frame number we have available
  */
-static unsigned long __init e820_end_pfn(unsigned long limit_pfn, unsigned type)
+unsigned long __init e820_end_pfn(unsigned long limit_pfn, unsigned type)
 {
 	int i;
 	unsigned long last_pfn = 0;
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index cf0ef98..9a9e40f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -691,6 +691,8 @@ early_param("reservelow", parse_reservelow);
 
 void __init setup_arch(char **cmdline_p)
 {
+	unsigned long end_pfn;
+
 #ifdef CONFIG_X86_32
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
 	visws_early_detect();
@@ -932,7 +934,24 @@ void __init setup_arch(char **cmdline_p)
 	init_gbpages();
 
 	/* max_pfn_mapped is updated here */
-	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
+	end_pfn = max_low_pfn;
+
+#ifdef CONFIG_X86_64
+	/*
+	 * There may be regions after the last E820_RAM region that we
+	 * want to include in the kernel direct mapping, such as
+	 * EFI_RUNTIME_SERVICES_DATA.
+	 */
+	if (efi_enabled) {
+		unsigned long efi_end;
+
+		efi_end = e820_end_pfn(MAXMEM>>PAGE_SHIFT, E820_RESERVED_EFI);
+		if (efi_end > max_low_pfn)
+			end_pfn = efi_end;
+	}
+#endif
+
+	max_low_pfn_mapped = init_memory_mapping(0, end_pfn << PAGE_SHIFT);
 	max_pfn_mapped = max_low_pfn_mapped;
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 37718f0..c9718a1 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -323,10 +323,13 @@ static void __init do_add_efi_memmap(void)
 		case EFI_UNUSABLE_MEMORY:
 			e820_type = E820_UNUSABLE;
 			break;
+		case EFI_RUNTIME_SERVICES_DATA:
+			e820_type = E820_RESERVED_EFI;
+			break;
 		default:
 			/*
 			 * EFI_RESERVED_TYPE EFI_RUNTIME_SERVICES_CODE
-			 * EFI_RUNTIME_SERVICES_DATA EFI_MEMORY_MAPPED_IO
+			 * EFI_MEMORY_MAPPED_IO
 			 * EFI_MEMORY_MAPPED_IO_PORT_SPACE EFI_PAL_CODE
 			 */
 			e820_type = E820_RESERVED;
@@ -671,10 +674,21 @@ void __init efi_enter_virtual_mode(void)
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
+				va = ioremap_cache(md->phys_addr, size);
+		}
 
 		md->virt_addr = (u64) (unsigned long) va;
 
@@ -684,13 +698,6 @@ void __init efi_enter_virtual_mode(void)
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
index ac3aa54..312250c 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -80,20 +80,3 @@ void __init efi_call_phys_epilog(void)
 	local_irq_restore(efi_flags);
 	early_code_mapping_set_exec(0);
 }
-
-void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
-				 u32 type)
-{
-	unsigned long last_map_pfn;
-
-	if (type == EFI_MEMORY_MAPPED_IO)
-		return ioremap(phys_addr, size);
-
-	last_map_pfn = init_memory_mapping(phys_addr, phys_addr + size);
-	if ((last_map_pfn << PAGE_SHIFT) < phys_addr + size) {
-		unsigned long top = last_map_pfn << PAGE_SHIFT;
-		efi_ioremap(top, size - (top - phys_addr), type);
-	}
-
-	return (void __iomem *)__va(phys_addr);
-}
