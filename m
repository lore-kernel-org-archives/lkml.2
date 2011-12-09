Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab1LIU3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 15:29:24 -0500
Received: from www.linutronix.de ([62.245.132.108]:47618 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab1LIU3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 15:29:22 -0500
Date: Fri, 9 Dec 2011 21:29:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: [GIT pull] x86 fixes for 3.2
Message-ID: <alpine.LFD.2.02.1112092128150.3020@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-urgent-for-linus

Thanks,

	tglx

------------------>
Alan Cox (2):
      x86/intel_mid: Fix the Kconfig for MID selection
      x86/intel_mid: Kconfig select fix

Mark Langsdorf (1):
      x86, hpet: Immediately disable HPET timer 1 if rtc irq is masked

Matt Fleming (1):
      x86, efi: Calling __pa() with an ioremap()ed address is invalid


 arch/x86/Kconfig               |    8 ++++++--
 arch/x86/include/asm/e820.h    |    8 ++++++++
 arch/x86/include/asm/efi.h     |    5 -----
 arch/x86/kernel/e820.c         |    3 ++-
 arch/x86/kernel/hpet.c         |   21 ++++++++++++++-------
 arch/x86/kernel/setup.c        |   21 ++++++++++++++++++++-
 arch/x86/platform/efi/efi.c    |   29 ++++++++++++++++++-----------
 arch/x86/platform/efi/efi_64.c |   17 -----------------
 8 files changed, 68 insertions(+), 44 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cb9a104..efb4294 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -390,7 +390,7 @@ config X86_INTEL_CE
 	  This option compiles in support for the CE4100 SOC for settop
 	  boxes and media devices.
 
-config X86_INTEL_MID
+config X86_WANT_INTEL_MID
 	bool "Intel MID platform support"
 	depends on X86_32
 	depends on X86_EXTENDED_PLATFORM
@@ -399,7 +399,10 @@ config X86_INTEL_MID
 	  systems which do not have the PCI legacy interfaces (Moorestown,
 	  Medfield). If you are building for a PC class system say N here.
 
-if X86_INTEL_MID
+if X86_WANT_INTEL_MID
+
+config X86_INTEL_MID
+	bool
 
 config X86_MRST
        bool "Moorestown MID platform"
@@ -411,6 +414,7 @@ config X86_MRST
 	select SPI
 	select INTEL_SCU_IPC
 	select X86_PLATFORM_DEVICES
+	select X86_INTEL_MID
 	---help---
 	  Moorestown is Intel's Low Power Intel Architecture (LPIA) based Moblin
 	  Internet Device(MID) platform. Moorestown consists of two chips:
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
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index b946a9e..1bb0bf4 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -1049,6 +1049,14 @@ int hpet_rtc_timer_init(void)
 }
 EXPORT_SYMBOL_GPL(hpet_rtc_timer_init);
 
+static void hpet_disable_rtc_channel(void)
+{
+	unsigned long cfg;
+	cfg = hpet_readl(HPET_T1_CFG);
+	cfg &= ~HPET_TN_ENABLE;
+	hpet_writel(cfg, HPET_T1_CFG);
+}
+
 /*
  * The functions below are called from rtc driver.
  * Return 0 if HPET is not being used.
@@ -1060,6 +1068,9 @@ int hpet_mask_rtc_irq_bit(unsigned long bit_mask)
 		return 0;
 
 	hpet_rtc_flags &= ~bit_mask;
+	if (unlikely(!hpet_rtc_flags))
+		hpet_disable_rtc_channel();
+
 	return 1;
 }
 EXPORT_SYMBOL_GPL(hpet_mask_rtc_irq_bit);
@@ -1125,15 +1136,11 @@ EXPORT_SYMBOL_GPL(hpet_rtc_dropped_irq);
 
 static void hpet_rtc_timer_reinit(void)
 {
-	unsigned int cfg, delta;
+	unsigned int delta;
 	int lost_ints = -1;
 
-	if (unlikely(!hpet_rtc_flags)) {
-		cfg = hpet_readl(HPET_T1_CFG);
-		cfg &= ~HPET_TN_ENABLE;
-		hpet_writel(cfg, HPET_T1_CFG);
-		return;
-	}
+	if (unlikely(!hpet_rtc_flags))
+		hpet_disable_rtc_channel();
 
 	if (!(hpet_rtc_flags & RTC_PIE) || hpet_pie_limit)
 		delta = hpet_default_delta;
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
