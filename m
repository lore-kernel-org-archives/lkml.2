Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab1LLChE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 21:37:04 -0500
Received: from home.keithp.com ([63.227.221.253]:33709 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756Ab1LLChB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 21:37:01 -0500
From: Keith Packard <keithp@keithp.com>
To: linux-kernel@vger.kernel.org
Cc: Keith Packard <keithp@keithp.com>, Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Matthew Garrett <mjg@redhat.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] Revert "x86, efi: Calling __pa() with an ioremap()ed address is invalid"
Date: Sun, 11 Dec 2011 16:12:42 -0800
Message-Id: <1323648762-2148-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This hangs my MacBook Air at boot time; I get no console messages at
all. I reverted this on top of -rc5 and my machine boots again.

This reverts commit e8c7106280a305e1ff2a3a8a4dfce141469fb039.

Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Huang Ying <huang.ying.caritas@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1321621751-3650-1-git-send-email-matt@console
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Keith Packard <keithp@keithp.com>
---
 arch/x86/include/asm/e820.h    |    8 --------
 arch/x86/include/asm/efi.h     |    5 +++++
 arch/x86/kernel/e820.c         |    3 +--
 arch/x86/kernel/setup.c        |   21 +--------------------
 arch/x86/platform/efi/efi.c    |   29 +++++++++++------------------
 arch/x86/platform/efi/efi_64.c |   17 +++++++++++++++++
 6 files changed, 35 insertions(+), 48 deletions(-)

diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index c954703..908b969 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -53,13 +53,6 @@
  */
 #define E820_RESERVED_KERN        128
 
-/*
- * Address ranges that need to be mapped by the kernel direct
- * mapping. This is used to make sure regions such as
- * EFI_RUNTIME_SERVICES_DATA are directly mapped. See setup_arch().
- */
-#define E820_RESERVED_EFI         129
-
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
 struct e820entry {
@@ -122,7 +115,6 @@ static inline void early_memtest(unsigned long start, unsigned long end)
 }
 #endif
 
-extern unsigned long e820_end_pfn(unsigned long limit_pfn, unsigned type);
 extern unsigned long e820_end_of_ram_pfn(void);
 extern unsigned long e820_end_of_low_ram_pfn(void);
 extern u64 early_reserve_e820(u64 startt, u64 sizet, u64 align);
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index b8d8bfc..7093e4a 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -33,6 +33,8 @@ extern unsigned long asmlinkage efi_call_phys(void *, ...);
 #define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)	\
 	efi_call_virt(f, a1, a2, a3, a4, a5, a6)
 
+#define efi_ioremap(addr, size, type)		ioremap_cache(addr, size)
+
 #else /* !CONFIG_X86_32 */
 
 extern u64 efi_call0(void *fp);
@@ -82,6 +84,9 @@ extern u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
 	efi_call6((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
 
+extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
+				 u32 type);
+
 #endif /* CONFIG_X86_32 */
 
 extern int add_efi_memmap;
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 65ffd11..303a0e4 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -135,7 +135,6 @@ static void __init e820_print_type(u32 type)
 		printk(KERN_CONT "(usable)");
 		break;
 	case E820_RESERVED:
-	case E820_RESERVED_EFI:
 		printk(KERN_CONT "(reserved)");
 		break;
 	case E820_ACPI:
@@ -784,7 +783,7 @@ u64 __init early_reserve_e820(u64 startt, u64 sizet, u64 align)
 /*
  * Find the highest page frame number we have available
  */
-unsigned long __init e820_end_pfn(unsigned long limit_pfn, unsigned type)
+static unsigned long __init e820_end_pfn(unsigned long limit_pfn, unsigned type)
 {
 	int i;
 	unsigned long last_pfn = 0;
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 9a9e40f..cf0ef98 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -691,8 +691,6 @@ early_param("reservelow", parse_reservelow);
 
 void __init setup_arch(char **cmdline_p)
 {
-	unsigned long end_pfn;
-
 #ifdef CONFIG_X86_32
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
 	visws_early_detect();
@@ -934,24 +932,7 @@ void __init setup_arch(char **cmdline_p)
 	init_gbpages();
 
 	/* max_pfn_mapped is updated here */
-	end_pfn = max_low_pfn;
-
-#ifdef CONFIG_X86_64
-	/*
-	 * There may be regions after the last E820_RAM region that we
-	 * want to include in the kernel direct mapping, such as
-	 * EFI_RUNTIME_SERVICES_DATA.
-	 */
-	if (efi_enabled) {
-		unsigned long efi_end;
-
-		efi_end = e820_end_pfn(MAXMEM>>PAGE_SHIFT, E820_RESERVED_EFI);
-		if (efi_end > max_low_pfn)
-			end_pfn = efi_end;
-	}
-#endif
-
-	max_low_pfn_mapped = init_memory_mapping(0, end_pfn << PAGE_SHIFT);
+	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
 	max_pfn_mapped = max_low_pfn_mapped;
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index c9718a1..37718f0 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -323,13 +323,10 @@ static void __init do_add_efi_memmap(void)
 		case EFI_UNUSABLE_MEMORY:
 			e820_type = E820_UNUSABLE;
 			break;
-		case EFI_RUNTIME_SERVICES_DATA:
-			e820_type = E820_RESERVED_EFI;
-			break;
 		default:
 			/*
 			 * EFI_RESERVED_TYPE EFI_RUNTIME_SERVICES_CODE
-			 * EFI_MEMORY_MAPPED_IO
+			 * EFI_RUNTIME_SERVICES_DATA EFI_MEMORY_MAPPED_IO
 			 * EFI_MEMORY_MAPPED_IO_PORT_SPACE EFI_PAL_CODE
 			 */
 			e820_type = E820_RESERVED;
@@ -674,21 +671,10 @@ void __init efi_enter_virtual_mode(void)
 		end_pfn = PFN_UP(end);
 		if (end_pfn <= max_low_pfn_mapped
 		    || (end_pfn > (1UL << (32 - PAGE_SHIFT))
-			&& end_pfn <= max_pfn_mapped)) {
+			&& end_pfn <= max_pfn_mapped))
 			va = __va(md->phys_addr);
-
-			if (!(md->attribute & EFI_MEMORY_WB)) {
-				addr = (u64) (unsigned long)va;
-				npages = md->num_pages;
-				memrange_efi_to_native(&addr, &npages);
-				set_memory_uc(addr, npages);
-			}
-		} else {
-			if (!(md->attribute & EFI_MEMORY_WB))
-				va = ioremap_nocache(md->phys_addr, size);
-			else
-				va = ioremap_cache(md->phys_addr, size);
-		}
+		else
+			va = efi_ioremap(md->phys_addr, size, md->type);
 
 		md->virt_addr = (u64) (unsigned long) va;
 
@@ -698,6 +684,13 @@ void __init efi_enter_virtual_mode(void)
 			continue;
 		}
 
+		if (!(md->attribute & EFI_MEMORY_WB)) {
+			addr = md->virt_addr;
+			npages = md->num_pages;
+			memrange_efi_to_native(&addr, &npages);
+			set_memory_uc(addr, npages);
+		}
+
 		systab = (u64) (unsigned long) efi_phys.systab;
 		if (md->phys_addr <= systab && systab < end) {
 			systab += md->virt_addr - md->phys_addr;
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 312250c..ac3aa54 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -80,3 +80,20 @@ void __init efi_call_phys_epilog(void)
 	local_irq_restore(efi_flags);
 	early_code_mapping_set_exec(0);
 }
+
+void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
+				 u32 type)
+{
+	unsigned long last_map_pfn;
+
+	if (type == EFI_MEMORY_MAPPED_IO)
+		return ioremap(phys_addr, size);
+
+	last_map_pfn = init_memory_mapping(phys_addr, phys_addr + size);
+	if ((last_map_pfn << PAGE_SHIFT) < phys_addr + size) {
+		unsigned long top = last_map_pfn << PAGE_SHIFT;
+		efi_ioremap(top, size - (top - phys_addr), type);
+	}
+
+	return (void __iomem *)__va(phys_addr);
+}
-- 
1.7.7.3

