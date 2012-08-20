Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab2HTJVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 05:21:23 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55006 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab2HTJVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 05:21:20 -0400
Date: Mon, 20 Aug 2012 11:21:14 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20120820092114.GA9875@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   HEAD: 515c7af85ed92696c311c53d53cb4898ff32d784 x32: Use compat shims for {g,s}etsockopt

Please have an extra look at:

  515c7af85ed9 x32: Use compat shims for {g,s}etsockopt

Which contains a socket ABI fix with a -stable backport tag.

 Thanks,

	Ingo

------------------>
Andrew Boie (1):
      x86, build: Globally set -fno-pic

H. Peter Anvin (1):
      Revert "x86-64/efi: Use EFI to deal with platform wall clock"

Mike Frysinger (1):
      x32: Use compat shims for {g,s}etsockopt

Suresh Siddha (2):
      x86, avx: don't use avx instructions with "noxsave" boot param
      x86, apic: fix broken legacy interrupts in the logical apic mode


 arch/x86/Makefile                |  4 ++++
 arch/x86/boot/Makefile           |  2 +-
 arch/x86/kernel/apic/io_apic.c   | 10 ++++++++++
 arch/x86/kernel/cpu/common.c     |  2 ++
 arch/x86/mm/pageattr.c           | 10 ++++------
 arch/x86/platform/efi/efi.c      | 30 ++++++++++++++++++++++++++----
 arch/x86/realmode/rm/Makefile    |  2 +-
 arch/x86/syscalls/syscall_64.tbl |  6 ++++--
 include/linux/efi.h              |  2 ++
 init/main.c                      |  8 ++++----
 10 files changed, 58 insertions(+), 18 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index b0c5276..682e9c2 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -27,6 +27,10 @@ ifeq ($(CONFIG_X86_32),y)
 
         KBUILD_CFLAGS += -msoft-float -mregparm=3 -freg-struct-return
 
+        # Never want PIC in a 32-bit kernel, prevent breakage with GCC built
+        # with nonstandard options
+        KBUILD_CFLAGS += -fno-pic
+
         # prevent gcc from keeping the stack 16 byte aligned
         KBUILD_CFLAGS += $(call cc-option,-mpreferred-stack-boundary=2)
 
diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 5a747dd..f7535be 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -57,7 +57,7 @@ KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os -D_SETUP -D__KERNEL__ \
 		   -Wall -Wstrict-prototypes \
 		   -march=i386 -mregparm=3 \
 		   -include $(srctree)/$(src)/code16gcc.h \
-		   -fno-strict-aliasing -fomit-frame-pointer \
+		   -fno-strict-aliasing -fomit-frame-pointer -fno-pic \
 		   $(call cc-option, -ffreestanding) \
 		   $(call cc-option, -fno-toplevel-reorder,\
 			$(call cc-option, -fno-unit-at-a-time)) \
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index a6c64aa..c265593 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1356,6 +1356,16 @@ static void setup_ioapic_irq(unsigned int irq, struct irq_cfg *cfg,
 	if (!IO_APIC_IRQ(irq))
 		return;
 
+	/*
+	 * For legacy irqs, cfg->domain starts with cpu 0. Now that IO-APIC
+	 * can handle this irq and the apic driver is finialized at this point,
+	 * update the cfg->domain.
+	 */
+	if (irq < legacy_pic->nr_legacy_irqs &&
+	    cpumask_equal(cfg->domain, cpumask_of(0)))
+		apic->vector_allocation_domain(0, cfg->domain,
+					       apic->target_cpus());
+
 	if (assign_irq_vector(irq, cfg, apic->target_cpus()))
 		return;
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 46d8786..a5fbc3c 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -144,6 +144,8 @@ static int __init x86_xsave_setup(char *s)
 {
 	setup_clear_cpu_cap(X86_FEATURE_XSAVE);
 	setup_clear_cpu_cap(X86_FEATURE_XSAVEOPT);
+	setup_clear_cpu_cap(X86_FEATURE_AVX);
+	setup_clear_cpu_cap(X86_FEATURE_AVX2);
 	return 1;
 }
 __setup("noxsave", x86_xsave_setup);
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 931930a..a718e0d 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -919,13 +919,11 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 
 	/*
 	 * On success we use clflush, when the CPU supports it to
-	 * avoid the wbindv. If the CPU does not support it, in the
-	 * error case, and during early boot (for EFI) we fall back
-	 * to cpa_flush_all (which uses wbinvd):
+	 * avoid the wbindv. If the CPU does not support it and in the
+	 * error case we fall back to cpa_flush_all (which uses
+	 * wbindv):
 	 */
-	if (early_boot_irqs_disabled)
-		__cpa_flush_all((void *)(long)cache);
-	else if (!ret && cpu_has_clflush) {
+	if (!ret && cpu_has_clflush) {
 		if (cpa.flags & (CPA_PAGES_ARRAY | CPA_ARRAY)) {
 			cpa_flush_array(addr, numpages, cache,
 					cpa.flags, pages);
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 2dc29f5..92660eda 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -234,7 +234,22 @@ static efi_status_t __init phys_efi_set_virtual_address_map(
 	return status;
 }
 
-static int efi_set_rtc_mmss(unsigned long nowtime)
+static efi_status_t __init phys_efi_get_time(efi_time_t *tm,
+					     efi_time_cap_t *tc)
+{
+	unsigned long flags;
+	efi_status_t status;
+
+	spin_lock_irqsave(&rtc_lock, flags);
+	efi_call_phys_prelog();
+	status = efi_call_phys2(efi_phys.get_time, virt_to_phys(tm),
+				virt_to_phys(tc));
+	efi_call_phys_epilog();
+	spin_unlock_irqrestore(&rtc_lock, flags);
+	return status;
+}
+
+int efi_set_rtc_mmss(unsigned long nowtime)
 {
 	int real_seconds, real_minutes;
 	efi_status_t 	status;
@@ -263,7 +278,7 @@ static int efi_set_rtc_mmss(unsigned long nowtime)
 	return 0;
 }
 
-static unsigned long efi_get_time(void)
+unsigned long efi_get_time(void)
 {
 	efi_status_t status;
 	efi_time_t eft;
@@ -606,13 +621,18 @@ static int __init efi_runtime_init(void)
 	}
 	/*
 	 * We will only need *early* access to the following
-	 * EFI runtime service before set_virtual_address_map
+	 * two EFI runtime services before set_virtual_address_map
 	 * is invoked.
 	 */
+	efi_phys.get_time = (efi_get_time_t *)runtime->get_time;
 	efi_phys.set_virtual_address_map =
 		(efi_set_virtual_address_map_t *)
 		runtime->set_virtual_address_map;
-
+	/*
+	 * Make efi_get_time can be called before entering
+	 * virtual mode.
+	 */
+	efi.get_time = phys_efi_get_time;
 	early_iounmap(runtime, sizeof(efi_runtime_services_t));
 
 	return 0;
@@ -700,10 +720,12 @@ void __init efi_init(void)
 		efi_enabled = 0;
 		return;
 	}
+#ifdef CONFIG_X86_32
 	if (efi_native) {
 		x86_platform.get_wallclock = efi_get_time;
 		x86_platform.set_wallclock = efi_set_rtc_mmss;
 	}
+#endif
 
 #if EFI_DEBUG
 	print_efi_memmap();
diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
index b2d534c..8869287 100644
--- a/arch/x86/realmode/rm/Makefile
+++ b/arch/x86/realmode/rm/Makefile
@@ -72,7 +72,7 @@ KBUILD_CFLAGS	:= $(LINUXINCLUDE) -m32 -g -Os -D_SETUP -D__KERNEL__ -D_WAKEUP \
 		   -Wall -Wstrict-prototypes \
 		   -march=i386 -mregparm=3 \
 		   -include $(srctree)/$(src)/../../boot/code16gcc.h \
-		   -fno-strict-aliasing -fomit-frame-pointer \
+		   -fno-strict-aliasing -fomit-frame-pointer -fno-pic \
 		   $(call cc-option, -ffreestanding) \
 		   $(call cc-option, -fno-toplevel-reorder,\
 			$(call cc-option, -fno-unit-at-a-time)) \
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index 29aed7a..a582bfe 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -60,8 +60,8 @@
 51	common	getsockname		sys_getsockname
 52	common	getpeername		sys_getpeername
 53	common	socketpair		sys_socketpair
-54	common	setsockopt		sys_setsockopt
-55	common	getsockopt		sys_getsockopt
+54	64	setsockopt		sys_setsockopt
+55	64	getsockopt		sys_getsockopt
 56	common	clone			stub_clone
 57	common	fork			stub_fork
 58	common	vfork			stub_vfork
@@ -353,3 +353,5 @@
 538	x32	sendmmsg		compat_sys_sendmmsg
 539	x32	process_vm_readv	compat_sys_process_vm_readv
 540	x32	process_vm_writev	compat_sys_process_vm_writev
+541	x32	setsockopt		compat_sys_setsockopt
+542	x32	getsockopt		compat_sys_getsockopt
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 103adc6..ec45ccd 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -503,6 +503,8 @@ extern u64 efi_mem_attribute (unsigned long phys_addr, unsigned long size);
 extern int __init efi_uart_console_only (void);
 extern void efi_initialize_iomem_resources(struct resource *code_resource,
 		struct resource *data_resource, struct resource *bss_resource);
+extern unsigned long efi_get_time(void);
+extern int efi_set_rtc_mmss(unsigned long nowtime);
 extern void efi_reserve_boot_services(void);
 extern struct efi_memory_map memmap;
 
diff --git a/init/main.c b/init/main.c
index e60679d..b286730 100644
--- a/init/main.c
+++ b/init/main.c
@@ -461,10 +461,6 @@ static void __init mm_init(void)
 	percpu_init_late();
 	pgtable_cache_init();
 	vmalloc_init();
-#ifdef CONFIG_X86
-	if (efi_enabled)
-		efi_enter_virtual_mode();
-#endif
 }
 
 asmlinkage void __init start_kernel(void)
@@ -606,6 +602,10 @@ asmlinkage void __init start_kernel(void)
 	calibrate_delay();
 	pidmap_init();
 	anon_vma_init();
+#ifdef CONFIG_X86
+	if (efi_enabled)
+		efi_enter_virtual_mode();
+#endif
 	thread_info_cache_init();
 	cred_init();
 	fork_init(totalram_pages);
