Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab2E2X01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 19:26:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58879 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab2E2X0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 19:26:22 -0400
Date: Tue, 29 May 2012 16:25:11 -0700
Message-Id: <201205292325.q4TNPBPw007366@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 trampoline rework for 3.5
Cc: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Len Brown <len.brown@intel.com>, Len Brown <lenb@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, Michal Marek <mmarek@suse.cz>,
        Paolo Bonzini <pbonzini@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 29 May 2012 16:25:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This code reworks all the "trampoline"/"realmode" code (various bits
that need to live in the first megabyte of memory, most but not all of
which runs in real mode at some point) in the kernel into a single
object.  The main reason for doing this is that it eliminates the last
place in the kernel where we needed pages to be mapped RWX.  This code
separates all that code into proper R/RW/RX pages.

The rework of relocs.c is already in upstream.  I know you don't like
lambda merges, but I did one for this branch, because I found that
without it git will silently mismerge relocs.c between your tree and
this branch; with the lambda merge in place it merges correctly.

If you prefer to do this manually, you can instead pull
61f5446169046c217a5479517edac3a890c3bee7; however, make sure that
arch/x86/tools/relocs.c ends up being the one from your current
upstream tree.

The following changes since commit ea17e7414bc62e8d3bde8d08e3df1d921c518c17:

  x86, relocs: Add jiffies and jiffies_64 to the relative whitelist (2012-05-24 07:16:18 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-trampoline-for-linus

The head of this branch is 015dc188a8c1bf47390be50e942e0b1a2f6fb3c5.

H. Peter Anvin (22):
      x86, realmode: 16-bit real-mode code support for relocs tool
      x86, realmode: Allow absolute pa_* symbols in the realmode code
      x86, realmode: Add .text64 section, make barrier symbols absolute
      x86, realmode: Move bits to the proper sections in trampoline_64.S
      x86, realmode: Align .data section in trampoline_32.S
      x86, realmode: Remove indirect jumps in trampoline_64.S
      x86, realmode: Remove indirect jumps in trampoline_32 and wakeup_asm
      x86, realmode: Replace open-coded ljmpw with a macro
      x86, realmode: Move trampoline_*.S early in the link order
      x86, realmode: Fix always-zero test in reboot_32.S
      x86, realmode: Make sure all generated files are listed in targets
      x86, realmode: Mask out EFER.LMA when saving trampoline EFER
      x86, realmode: Move not-common bits out of trampoline_common.S
      x86, realmode: Move kernel/realmode.c to realmode/init.c
      x86, realmode: Change EFER to a single u64 field
      acpi, bgrd: Add missing <linux/io.h> to drivers/acpi/bgrt.c
      xen-acpi-processor: Add missing #include <xen/xen.h>
      x86, relocs: Workaround for binutils 2.22.52.0.1 section bug
      x86, relocs: More relocations which may end up as absolute
      x86, relocs: When printing an error, say relative or absolute
      x86, realmode: Move end signature into header.S
      Merge commit 'ea17e7414bc62e8d3bde8d08e3df1d921c518c17' into x86/trampoline

Jarkko Sakkinen (15):
      x86, realmode: realmode.bin infrastructure
      x86, realmode: Relocator for realmode code
      x86, realmode: Move reboot_32.S to unified realmode code
      x86, realmode: Move SMP trampoline to unified realmode code
      x86, realmode: Move ACPI wakeup to unified realmode code
      x86, realmode: Set permission for real mode pages
      x86, realmode: fix 64-bit wakeup sequence
      x86, realmode: don't copy real_mode_header
      x86, realmode: flattened rm hierachy
      x86, realmode: header for trampoline code
      x86, realmode: move relocs from scripts/ to arch/x86/tools
      x86, realmode: fixes compilation issue in tboot.c
      x86, realmode: read cr4 and EFER from kernel for 64-bit trampoline
      x86, realmode: build fix: remove duplicate build
      x86, realmode: Fix no cache bits test in reboot_32.S

 arch/x86/Kbuild                                    |    2 +-
 arch/x86/include/asm/acpi.h                        |    2 -
 arch/x86/include/asm/processor.h                   |    7 +-
 arch/x86/include/asm/realmode.h                    |   62 ++++++++
 arch/x86/include/asm/trampoline.h                  |   39 -----
 arch/x86/kernel/Makefile                           |    2 -
 arch/x86/kernel/acpi/Makefile                      |    9 +-
 arch/x86/kernel/acpi/realmode/.gitignore           |    3 -
 arch/x86/kernel/acpi/realmode/Makefile             |   59 --------
 arch/x86/kernel/acpi/realmode/bioscall.S           |    1 -
 arch/x86/kernel/acpi/realmode/copy.S               |    1 -
 arch/x86/kernel/acpi/realmode/regs.c               |    1 -
 arch/x86/kernel/acpi/realmode/video-bios.c         |    1 -
 arch/x86/kernel/acpi/realmode/video-mode.c         |    1 -
 arch/x86/kernel/acpi/realmode/video-vesa.c         |    1 -
 arch/x86/kernel/acpi/realmode/video-vga.c          |    1 -
 arch/x86/kernel/acpi/realmode/wakeup.lds.S         |   62 --------
 arch/x86/kernel/acpi/sleep.c                       |   33 +----
 arch/x86/kernel/acpi/sleep.h                       |    2 +-
 arch/x86/kernel/acpi/wakeup_rm.S                   |   12 --
 arch/x86/kernel/head32.c                           |    1 -
 arch/x86/kernel/head64.c                           |    1 -
 arch/x86/kernel/head_32.S                          |    5 +-
 arch/x86/kernel/head_64.S                          |    4 -
 arch/x86/kernel/mpparse.c                          |    1 -
 arch/x86/kernel/reboot.c                           |   25 +---
 arch/x86/kernel/setup.c                            |    6 +-
 arch/x86/kernel/smpboot.c                          |   18 ++-
 arch/x86/kernel/tboot.c                            |    7 +-
 arch/x86/kernel/trampoline.c                       |   42 ------
 arch/x86/kernel/trampoline_32.S                    |   83 -----------
 arch/x86/kernel/vmlinux.lds.S                      |   12 --
 arch/x86/realmode/Makefile                         |   18 +++
 arch/x86/realmode/init.c                           |  115 +++++++++++++++
 arch/x86/realmode/rm/.gitignore                    |    3 +
 arch/x86/realmode/rm/Makefile                      |   82 +++++++++++
 arch/x86/realmode/rm/bioscall.S                    |    1 +
 arch/x86/realmode/rm/copy.S                        |    1 +
 arch/x86/realmode/rm/header.S                      |   41 ++++++
 arch/x86/realmode/rm/realmode.h                    |   21 +++
 arch/x86/realmode/rm/realmode.lds.S                |   76 ++++++++++
 arch/x86/{kernel => realmode/rm}/reboot_32.S       |   89 ++++++------
 arch/x86/realmode/rm/regs.c                        |    1 +
 arch/x86/realmode/rm/stack.S                       |   19 +++
 arch/x86/realmode/rm/trampoline_32.S               |   74 ++++++++++
 arch/x86/{kernel => realmode/rm}/trampoline_64.S   |  148 +++++++++-----------
 arch/x86/realmode/rm/trampoline_common.S           |    7 +
 arch/x86/realmode/rm/video-bios.c                  |    1 +
 arch/x86/realmode/rm/video-mode.c                  |    1 +
 arch/x86/realmode/rm/video-vesa.c                  |    1 +
 arch/x86/realmode/rm/video-vga.c                   |    1 +
 .../acpi/realmode => realmode/rm}/wakemain.c       |    3 +-
 .../{kernel/acpi/realmode => realmode/rm}/wakeup.h |   10 +--
 .../realmode/wakeup.S => realmode/rm/wakeup_asm.S} |  131 +++++++++--------
 arch/x86/realmode/rmpiggy.S                        |   20 +++
 arch/x86/tools/relocs.c                            |    7 +
 drivers/acpi/bgrt.c                                |    1 +
 drivers/acpi/sleep.c                               |    8 +-
 drivers/xen/xen-acpi-processor.c                   |    1 +
 59 files changed, 774 insertions(+), 613 deletions(-)

diff --git a/arch/x86/Kbuild b/arch/x86/Kbuild
index 0e9dec6..e5287d8 100644
--- a/arch/x86/Kbuild
+++ b/arch/x86/Kbuild
@@ -1,4 +1,3 @@
-
 obj-$(CONFIG_KVM) += kvm/
 
 # Xen paravirtualization support
@@ -7,6 +6,7 @@ obj-$(CONFIG_XEN) += xen/
 # lguest paravirtualization support
 obj-$(CONFIG_LGUEST_GUEST) += lguest/
 
+obj-y += realmode/
 obj-y += kernel/
 obj-y += mm/
 
diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 610001d..724aa44 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -29,7 +29,6 @@
 #include <asm/processor.h>
 #include <asm/mmu.h>
 #include <asm/mpspec.h>
-#include <asm/trampoline.h>
 
 #define COMPILER_DEPENDENT_INT64   long long
 #define COMPILER_DEPENDENT_UINT64  unsigned long long
@@ -118,7 +117,6 @@ static inline void acpi_disable_pci(void)
 extern int acpi_suspend_lowlevel(void);
 
 extern const unsigned char acpi_wakeup_code[];
-#define acpi_wakeup_address (__pa(TRAMPOLINE_SYM(acpi_wakeup_code)))
 
 /* early initialization routine */
 extern void acpi_reserve_wakeup_memory(void);
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 4fa7dcc..404583c 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -544,13 +544,16 @@ static inline void load_sp0(struct tss_struct *tss,
  * enable), so that any CPU's that boot up
  * after us can get the correct flags.
  */
-extern unsigned long		mmu_cr4_features;
+extern unsigned long mmu_cr4_features;
+extern u32 *trampoline_cr4_features;
 
 static inline void set_in_cr4(unsigned long mask)
 {
 	unsigned long cr4;
 
 	mmu_cr4_features |= mask;
+	if (trampoline_cr4_features)
+		*trampoline_cr4_features = mmu_cr4_features;
 	cr4 = read_cr4();
 	cr4 |= mask;
 	write_cr4(cr4);
@@ -561,6 +564,8 @@ static inline void clear_in_cr4(unsigned long mask)
 	unsigned long cr4;
 
 	mmu_cr4_features &= ~mask;
+	if (trampoline_cr4_features)
+		*trampoline_cr4_features = mmu_cr4_features;
 	cr4 = read_cr4();
 	cr4 &= ~mask;
 	write_cr4(cr4);
diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmode.h
new file mode 100644
index 0000000..fce3f4a
--- /dev/null
+++ b/arch/x86/include/asm/realmode.h
@@ -0,0 +1,62 @@
+#ifndef _ARCH_X86_REALMODE_H
+#define _ARCH_X86_REALMODE_H
+
+#include <linux/types.h>
+#include <asm/io.h>
+
+/* This must match data at realmode.S */
+struct real_mode_header {
+	u32	text_start;
+	u32	ro_end;
+	/* SMP trampoline */
+	u32	trampoline_start;
+	u32	trampoline_status;
+	u32	trampoline_header;
+#ifdef CONFIG_X86_64
+	u32	trampoline_pgd;
+#endif
+	/* ACPI S3 wakeup */
+#ifdef CONFIG_ACPI_SLEEP
+	u32	wakeup_start;
+	u32	wakeup_header;
+#endif
+	/* APM/BIOS reboot */
+#ifdef CONFIG_X86_32
+	u32	machine_real_restart_asm;
+#endif
+};
+
+/* This must match data at trampoline_32/64.S */
+struct trampoline_header {
+#ifdef CONFIG_X86_32
+	u32 start;
+	u16 gdt_pad;
+	u16 gdt_limit;
+	u32 gdt_base;
+#else
+	u64 start;
+	u64 efer;
+	u32 cr4;
+#endif
+};
+
+extern struct real_mode_header *real_mode_header;
+extern unsigned char real_mode_blob_end[];
+
+extern unsigned long init_rsp;
+extern unsigned long initial_code;
+extern unsigned long initial_gs;
+
+extern unsigned char real_mode_blob[];
+extern unsigned char real_mode_relocs[];
+
+#ifdef CONFIG_X86_32
+extern unsigned char startup_32_smp[];
+extern unsigned char boot_gdt[];
+#else
+extern unsigned char secondary_startup_64[];
+#endif
+
+extern void __init setup_real_mode(void);
+
+#endif /* _ARCH_X86_REALMODE_H */
diff --git a/arch/x86/include/asm/trampoline.h b/arch/x86/include/asm/trampoline.h
deleted file mode 100644
index feca311..0000000
--- a/arch/x86/include/asm/trampoline.h
+++ /dev/null
@@ -1,39 +0,0 @@
-#ifndef _ASM_X86_TRAMPOLINE_H
-#define _ASM_X86_TRAMPOLINE_H
-
-#ifndef __ASSEMBLY__
-
-#include <linux/types.h>
-#include <asm/io.h>
-
-/*
- * Trampoline 80x86 program as an array.  These are in the init rodata
- * segment, but that's okay, because we only care about the relative
- * addresses of the symbols.
- */
-extern const unsigned char x86_trampoline_start [];
-extern const unsigned char x86_trampoline_end   [];
-extern unsigned char *x86_trampoline_base;
-
-extern unsigned long init_rsp;
-extern unsigned long initial_code;
-extern unsigned long initial_gs;
-
-extern void __init setup_trampolines(void);
-
-extern const unsigned char trampoline_data[];
-extern const unsigned char trampoline_status[];
-
-#define TRAMPOLINE_SYM(x)						\
-	((void *)(x86_trampoline_base +					\
-		  ((const unsigned char *)(x) - x86_trampoline_start)))
-
-/* Address of the SMP trampoline */
-static inline unsigned long trampoline_address(void)
-{
-	return virt_to_phys(TRAMPOLINE_SYM(trampoline_data));
-}
-
-#endif /* __ASSEMBLY__ */
-
-#endif /* _ASM_X86_TRAMPOLINE_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 532d2e0..0848433 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -35,7 +35,6 @@ obj-y			+= tsc.o io_delay.o rtc.o
 obj-y			+= pci-iommu_table.o
 obj-y			+= resource.o
 
-obj-y				+= trampoline.o trampoline_$(BITS).o
 obj-y				+= process.o
 obj-y				+= i387.o xsave.o
 obj-y				+= ptrace.o
@@ -48,7 +47,6 @@ obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
 obj-y				+= acpi/
 obj-y				+= reboot.o
-obj-$(CONFIG_X86_32)		+= reboot_32.o
 obj-$(CONFIG_MCA)		+= mca_32.o
 obj-$(CONFIG_X86_MSR)		+= msr.o
 obj-$(CONFIG_X86_CPUID)		+= cpuid.o
diff --git a/arch/x86/kernel/acpi/Makefile b/arch/x86/kernel/acpi/Makefile
index 6f35260..163b225 100644
--- a/arch/x86/kernel/acpi/Makefile
+++ b/arch/x86/kernel/acpi/Makefile
@@ -1,14 +1,7 @@
-subdir-				:= realmode
-
 obj-$(CONFIG_ACPI)		+= boot.o
-obj-$(CONFIG_ACPI_SLEEP)	+= sleep.o wakeup_rm.o wakeup_$(BITS).o
+obj-$(CONFIG_ACPI_SLEEP)	+= sleep.o wakeup_$(BITS).o
 
 ifneq ($(CONFIG_ACPI_PROCESSOR),)
 obj-y				+= cstate.o
 endif
 
-$(obj)/wakeup_rm.o:    $(obj)/realmode/wakeup.bin
-
-$(obj)/realmode/wakeup.bin: FORCE
-	$(Q)$(MAKE) $(build)=$(obj)/realmode
-
diff --git a/arch/x86/kernel/acpi/realmode/.gitignore b/arch/x86/kernel/acpi/realmode/.gitignore
deleted file mode 100644
index 58f1f48..0000000
--- a/arch/x86/kernel/acpi/realmode/.gitignore
+++ /dev/null
@@ -1,3 +0,0 @@
-wakeup.bin
-wakeup.elf
-wakeup.lds
diff --git a/arch/x86/kernel/acpi/realmode/Makefile b/arch/x86/kernel/acpi/realmode/Makefile
deleted file mode 100644
index 6a564ac..0000000
--- a/arch/x86/kernel/acpi/realmode/Makefile
+++ /dev/null
@@ -1,59 +0,0 @@
-#
-# arch/x86/kernel/acpi/realmode/Makefile
-#
-# This file is subject to the terms and conditions of the GNU General Public
-# License.  See the file "COPYING" in the main directory of this archive
-# for more details.
-#
-
-always		:= wakeup.bin
-targets		:= wakeup.elf wakeup.lds
-
-wakeup-y	+= wakeup.o wakemain.o video-mode.o copy.o bioscall.o regs.o
-
-# The link order of the video-*.o modules can matter.  In particular,
-# video-vga.o *must* be listed first, followed by video-vesa.o.
-# Hardware-specific drivers should follow in the order they should be
-# probed, and video-bios.o should typically be last.
-wakeup-y	+= video-vga.o
-wakeup-y	+= video-vesa.o
-wakeup-y	+= video-bios.o
-
-targets		+= $(wakeup-y)
-
-bootsrc		:= $(src)/../../../boot
-
-# ---------------------------------------------------------------------------
-
-# How to compile the 16-bit code.  Note we always compile for -march=i386,
-# that way we can complain to the user if the CPU is insufficient.
-# Compile with _SETUP since this is similar to the boot-time setup code.
-KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os -D_SETUP -D_WAKEUP -D__KERNEL__ \
-		   -I$(srctree)/$(bootsrc) \
-		   $(cflags-y) \
-		   -Wall -Wstrict-prototypes \
-		   -march=i386 -mregparm=3 \
-		   -include $(srctree)/$(bootsrc)/code16gcc.h \
-		   -fno-strict-aliasing -fomit-frame-pointer \
-		   $(call cc-option, -ffreestanding) \
-		   $(call cc-option, -fno-toplevel-reorder,\
-			$(call cc-option, -fno-unit-at-a-time)) \
-		   $(call cc-option, -fno-stack-protector) \
-		   $(call cc-option, -mpreferred-stack-boundary=2)
-KBUILD_CFLAGS	+= $(call cc-option, -m32)
-KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
-GCOV_PROFILE := n
-
-WAKEUP_OBJS = $(addprefix $(obj)/,$(wakeup-y))
-
-LDFLAGS_wakeup.elf	:= -T
-
-CPPFLAGS_wakeup.lds += -P -C
-
-$(obj)/wakeup.elf: $(obj)/wakeup.lds $(WAKEUP_OBJS) FORCE
-	$(call if_changed,ld)
-
-OBJCOPYFLAGS_wakeup.bin	:= -O binary
-
-$(obj)/wakeup.bin: $(obj)/wakeup.elf FORCE
-	$(call if_changed,objcopy)
diff --git a/arch/x86/kernel/acpi/realmode/bioscall.S b/arch/x86/kernel/acpi/realmode/bioscall.S
deleted file mode 100644
index f51eb0b..0000000
--- a/arch/x86/kernel/acpi/realmode/bioscall.S
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../../boot/bioscall.S"
diff --git a/arch/x86/kernel/acpi/realmode/copy.S b/arch/x86/kernel/acpi/realmode/copy.S
deleted file mode 100644
index dc59ebe..0000000
--- a/arch/x86/kernel/acpi/realmode/copy.S
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../../boot/copy.S"
diff --git a/arch/x86/kernel/acpi/realmode/regs.c b/arch/x86/kernel/acpi/realmode/regs.c
deleted file mode 100644
index 6206033..0000000
--- a/arch/x86/kernel/acpi/realmode/regs.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../../boot/regs.c"
diff --git a/arch/x86/kernel/acpi/realmode/video-bios.c b/arch/x86/kernel/acpi/realmode/video-bios.c
deleted file mode 100644
index 7deabc1..0000000
--- a/arch/x86/kernel/acpi/realmode/video-bios.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../../boot/video-bios.c"
diff --git a/arch/x86/kernel/acpi/realmode/video-mode.c b/arch/x86/kernel/acpi/realmode/video-mode.c
deleted file mode 100644
index 328ad20..0000000
--- a/arch/x86/kernel/acpi/realmode/video-mode.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../../boot/video-mode.c"
diff --git a/arch/x86/kernel/acpi/realmode/video-vesa.c b/arch/x86/kernel/acpi/realmode/video-vesa.c
deleted file mode 100644
index 9dbb967..0000000
--- a/arch/x86/kernel/acpi/realmode/video-vesa.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../../boot/video-vesa.c"
diff --git a/arch/x86/kernel/acpi/realmode/video-vga.c b/arch/x86/kernel/acpi/realmode/video-vga.c
deleted file mode 100644
index bcc8125..0000000
--- a/arch/x86/kernel/acpi/realmode/video-vga.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../../boot/video-vga.c"
diff --git a/arch/x86/kernel/acpi/realmode/wakeup.lds.S b/arch/x86/kernel/acpi/realmode/wakeup.lds.S
deleted file mode 100644
index d4f8010..0000000
--- a/arch/x86/kernel/acpi/realmode/wakeup.lds.S
+++ /dev/null
@@ -1,62 +0,0 @@
-/*
- * wakeup.ld
- *
- * Linker script for the real-mode wakeup code
- */
-#undef i386
-#include "wakeup.h"
-
-OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
-OUTPUT_ARCH(i386)
-ENTRY(_start)
-
-SECTIONS
-{
-	. = 0;
-	.jump	: {
-		*(.jump)
-	} = 0x90909090
-
-	. = WAKEUP_HEADER_OFFSET;
-	.header : {
-		*(.header)
-	}
-
-	. = ALIGN(16);
-	.text : {
-		 *(.text*)
-	} = 0x90909090
-
-	. = ALIGN(16);
-	.rodata : {
-		*(.rodata*)
-	}
-
-	.videocards : {
-		video_cards = .;
-		*(.videocards)
-		video_cards_end = .;
-	}
-
-	. = ALIGN(16);
-	.data : {
-		 *(.data*)
-	}
-
-	. = ALIGN(16);
-	.bss :	{
-		__bss_start = .;
-		*(.bss)
-		__bss_end = .;
-	}
-
-	.signature : {
-		*(.signature)
-	}
-
-	_end = .;
-
-	/DISCARD/ : {
-		*(.note*)
-	}
-}
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 146a49c..95bf99d 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -14,8 +14,9 @@
 #include <asm/desc.h>
 #include <asm/pgtable.h>
 #include <asm/cacheflush.h>
+#include <asm/realmode.h>
 
-#include "realmode/wakeup.h"
+#include "../../realmode/rm/wakeup.h"
 #include "sleep.h"
 
 unsigned long acpi_realmode_flags;
@@ -36,13 +37,9 @@ asmlinkage void acpi_enter_s3(void)
  */
 int acpi_suspend_lowlevel(void)
 {
-	struct wakeup_header *header;
-	/* address in low memory of the wakeup routine. */
-	char *acpi_realmode;
+	struct wakeup_header *header =
+		(struct wakeup_header *) __va(real_mode_header->wakeup_header);
 
-	acpi_realmode = TRAMPOLINE_SYM(acpi_wakeup_code);
-
-	header = (struct wakeup_header *)(acpi_realmode + WAKEUP_HEADER_OFFSET);
 	if (header->signature != WAKEUP_HEADER_SIGNATURE) {
 		printk(KERN_ERR "wakeup header does not match\n");
 		return -EINVAL;
@@ -50,27 +47,6 @@ int acpi_suspend_lowlevel(void)
 
 	header->video_mode = saved_video_mode;
 
-	header->wakeup_jmp_seg = acpi_wakeup_address >> 4;
-
-	/*
-	 * Set up the wakeup GDT.  We set these up as Big Real Mode,
-	 * that is, with limits set to 4 GB.  At least the Lenovo
-	 * Thinkpad X61 is known to need this for the video BIOS
-	 * initialization quirk to work; this is likely to also
-	 * be the case for other laptops or integrated video devices.
-	 */
-
-	/* GDT[0]: GDT self-pointer */
-	header->wakeup_gdt[0] =
-		(u64)(sizeof(header->wakeup_gdt) - 1) +
-		((u64)__pa(&header->wakeup_gdt) << 16);
-	/* GDT[1]: big real mode-like code segment */
-	header->wakeup_gdt[1] =
-		GDT_ENTRY(0x809b, acpi_wakeup_address, 0xfffff);
-	/* GDT[2]: big real mode-like data segment */
-	header->wakeup_gdt[2] =
-		GDT_ENTRY(0x8093, acpi_wakeup_address, 0xfffff);
-
 #ifndef CONFIG_64BIT
 	store_gdt((struct desc_ptr *)&header->pmode_gdt);
 
@@ -95,7 +71,6 @@ int acpi_suspend_lowlevel(void)
 	header->pmode_cr3 = (u32)__pa(&initial_page_table);
 	saved_magic = 0x12345678;
 #else /* CONFIG_64BIT */
-	header->trampoline_segment = trampoline_address() >> 4;
 #ifdef CONFIG_SMP
 	stack_start = (unsigned long)temp_stack + sizeof(temp_stack);
 	early_gdt_descr.address =
diff --git a/arch/x86/kernel/acpi/sleep.h b/arch/x86/kernel/acpi/sleep.h
index d68677a..5653a57 100644
--- a/arch/x86/kernel/acpi/sleep.h
+++ b/arch/x86/kernel/acpi/sleep.h
@@ -2,8 +2,8 @@
  *	Variables and functions used by the code in sleep.c
  */
 
-#include <asm/trampoline.h>
 #include <linux/linkage.h>
+#include <asm/realmode.h>
 
 extern unsigned long saved_video_mode;
 extern long saved_magic;
diff --git a/arch/x86/kernel/acpi/wakeup_rm.S b/arch/x86/kernel/acpi/wakeup_rm.S
deleted file mode 100644
index 63b8ab5..0000000
--- a/arch/x86/kernel/acpi/wakeup_rm.S
+++ /dev/null
@@ -1,12 +0,0 @@
-/*
- * Wrapper script for the realmode binary as a transport object
- * before copying to low memory.
- */
-#include <asm/page_types.h>
-
-	.section ".x86_trampoline","a"
-	.balign PAGE_SIZE
-	.globl	acpi_wakeup_code
-acpi_wakeup_code:
-	.incbin	"arch/x86/kernel/acpi/realmode/wakeup.bin"
-	.size	acpi_wakeup_code, .-acpi_wakeup_code
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index 51ff186..c18f59d 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -14,7 +14,6 @@
 #include <asm/sections.h>
 #include <asm/e820.h>
 #include <asm/page.h>
-#include <asm/trampoline.h>
 #include <asm/apic.h>
 #include <asm/io_apic.h>
 #include <asm/bios_ebda.h>
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 3a3b779..037df57 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -24,7 +24,6 @@
 #include <asm/sections.h>
 #include <asm/kdebug.h>
 #include <asm/e820.h>
-#include <asm/trampoline.h>
 #include <asm/bios_ebda.h>
 
 static void __init zap_identity_mappings(void)
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index ce0be7c..a3c2b4f 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -273,10 +273,7 @@ num_subarch_entries = (. - subarch_entries) / 4
  * If cpu hotplug is not supported then this code can go in init section
  * which will be freed later
  */
-
 __CPUINIT
-
-#ifdef CONFIG_SMP
 ENTRY(startup_32_smp)
 	cld
 	movl $(__BOOT_DS),%eax
@@ -287,7 +284,7 @@ ENTRY(startup_32_smp)
 	movl pa(stack_start),%ecx
 	movl %eax,%ss
 	leal -__PAGE_OFFSET(%ecx),%esp
-#endif /* CONFIG_SMP */
+
 default_entry:
 
 /*
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 40f4eb3..d70bc2e 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -136,10 +136,6 @@ ident_complete:
 	/* Fixup phys_base */
 	addq	%rbp, phys_base(%rip)
 
-	/* Fixup trampoline */
-	addq	%rbp, trampoline_level4_pgt + 0(%rip)
-	addq	%rbp, trampoline_level4_pgt + (511*8)(%rip)
-
 	/* Due to ENTRY(), sometimes the empty space gets filled with
 	 * zeros. Better take a jmp than relying on empty space being
 	 * filled with 0x90 (nop)
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index ca470e4..f44d311 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -27,7 +27,6 @@
 #include <asm/proto.h>
 #include <asm/bios_ebda.h>
 #include <asm/e820.h>
-#include <asm/trampoline.h>
 #include <asm/setup.h>
 #include <asm/smp.h>
 
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index d840e69..658f856 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -24,6 +24,7 @@
 #ifdef CONFIG_X86_32
 # include <linux/ctype.h>
 # include <linux/mc146818rtc.h>
+# include <asm/realmode.h>
 #else
 # include <asm/x86_init.h>
 #endif
@@ -332,15 +333,10 @@ static int __init reboot_init(void)
 }
 core_initcall(reboot_init);
 
-extern const unsigned char machine_real_restart_asm[];
-extern const u64 machine_real_restart_gdt[3];
-
 void machine_real_restart(unsigned int type)
 {
-	void *restart_va;
-	unsigned long restart_pa;
-	void (*restart_lowmem)(unsigned int);
-	u64 *lowmem_gdt;
+	void (*restart_lowmem)(unsigned int) = (void (*)(unsigned int))
+		real_mode_header->machine_real_restart_asm;
 
 	local_irq_disable();
 
@@ -369,21 +365,6 @@ void machine_real_restart(unsigned int type)
 	   too. */
 	*((unsigned short *)0x472) = reboot_mode;
 
-	/* Patch the GDT in the low memory trampoline */
-	lowmem_gdt = TRAMPOLINE_SYM(machine_real_restart_gdt);
-
-	restart_va = TRAMPOLINE_SYM(machine_real_restart_asm);
-	restart_pa = virt_to_phys(restart_va);
-	restart_lowmem = (void (*)(unsigned int))restart_pa;
-
-	/* GDT[0]: GDT self-pointer */
-	lowmem_gdt[0] =
-		(u64)(sizeof(machine_real_restart_gdt) - 1) +
-		((u64)virt_to_phys(lowmem_gdt) << 16);
-	/* GDT[1]: 64K real mode code segment */
-	lowmem_gdt[1] =
-		GDT_ENTRY(0x009b, restart_pa, 0xffff);
-
 	/* Jump to the identity-mapped low memory code */
 	restart_lowmem(type);
 }
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 1a29015..efcf305 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -73,7 +73,7 @@
 
 #include <asm/mtrr.h>
 #include <asm/apic.h>
-#include <asm/trampoline.h>
+#include <asm/realmode.h>
 #include <asm/e820.h>
 #include <asm/mpspec.h>
 #include <asm/setup.h>
@@ -917,7 +917,7 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_DEBUG "initial memory mapped : 0 - %08lx\n",
 			max_pfn_mapped<<PAGE_SHIFT);
 
-	setup_trampolines();
+	setup_real_mode();
 
 	init_gbpages();
 
@@ -975,6 +975,8 @@ void __init setup_arch(char **cmdline_p)
 	if (boot_cpu_data.cpuid_level >= 0) {
 		/* A CPU has %cr4 if and only if it has CPUID */
 		mmu_cr4_features = read_cr4();
+		if (trampoline_cr4_features)
+			*trampoline_cr4_features = mmu_cr4_features;
 	}
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 6e1e406..757c4b1 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -57,7 +57,7 @@
 #include <asm/nmi.h>
 #include <asm/irq.h>
 #include <asm/idle.h>
-#include <asm/trampoline.h>
+#include <asm/realmode.h>
 #include <asm/cpu.h>
 #include <asm/numa.h>
 #include <asm/pgtable.h>
@@ -73,6 +73,8 @@
 #include <asm/smpboot_hooks.h>
 #include <asm/i8259.h>
 
+#include <asm/realmode.h>
+
 /* State of each CPU */
 DEFINE_PER_CPU(int, cpu_state) = { 0 };
 
@@ -662,8 +664,12 @@ static void __cpuinit announce_cpu(int cpu, int apicid)
  */
 static int __cpuinit do_boot_cpu(int apicid, int cpu)
 {
+	volatile u32 *trampoline_status =
+		(volatile u32 *) __va(real_mode_header->trampoline_status);
+	/* start_ip had better be page-aligned! */
+	unsigned long start_ip = real_mode_header->trampoline_start;
+
 	unsigned long boot_error = 0;
-	unsigned long start_ip;
 	int timeout;
 	struct create_idle c_idle = {
 		.cpu	= cpu,
@@ -713,9 +719,6 @@ do_rest:
 	initial_code = (unsigned long)start_secondary;
 	stack_start  = c_idle.idle->thread.sp;
 
-	/* start_ip had better be page-aligned! */
-	start_ip = trampoline_address();
-
 	/* So we see what's up */
 	announce_cpu(cpu, apicid);
 
@@ -778,8 +781,7 @@ do_rest:
 			pr_debug("CPU%d: has booted.\n", cpu);
 		} else {
 			boot_error = 1;
-			if (*(volatile u32 *)TRAMPOLINE_SYM(trampoline_status)
-			    == 0xA5A5A5A5)
+			if (*trampoline_status == 0xA5A5A5A5)
 				/* trampoline started but...? */
 				pr_err("CPU%d: Stuck ??\n", cpu);
 			else
@@ -805,7 +807,7 @@ do_rest:
 	}
 
 	/* mark "stuck" area as not stuck */
-	*(volatile u32 *)TRAMPOLINE_SYM(trampoline_status) = 0;
+	*trampoline_status = 0;
 
 	if (get_uv_system_type() != UV_NON_UNIQUE_APIC) {
 		/*
diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index 6410744..f84fe00 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -32,7 +32,7 @@
 #include <linux/mm.h>
 #include <linux/tboot.h>
 
-#include <asm/trampoline.h>
+#include <asm/realmode.h>
 #include <asm/processor.h>
 #include <asm/bootparam.h>
 #include <asm/pgtable.h>
@@ -44,7 +44,7 @@
 #include <asm/e820.h>
 #include <asm/io.h>
 
-#include "acpi/realmode/wakeup.h"
+#include "../realmode/rm/wakeup.h"
 
 /* Global pointer to shared data; NULL means no measured launch. */
 struct tboot *tboot __read_mostly;
@@ -201,7 +201,8 @@ static int tboot_setup_sleep(void)
 		add_mac_region(e820.map[i].addr, e820.map[i].size);
 	}
 
-	tboot->acpi_sinfo.kernel_s3_resume_vector = acpi_wakeup_address;
+	tboot->acpi_sinfo.kernel_s3_resume_vector =
+		real_mode_header->wakeup_start;
 
 	return 0;
 }
diff --git a/arch/x86/kernel/trampoline.c b/arch/x86/kernel/trampoline.c
deleted file mode 100644
index a73b610..0000000
--- a/arch/x86/kernel/trampoline.c
+++ /dev/null
@@ -1,42 +0,0 @@
-#include <linux/io.h>
-#include <linux/memblock.h>
-
-#include <asm/trampoline.h>
-#include <asm/cacheflush.h>
-#include <asm/pgtable.h>
-
-unsigned char *x86_trampoline_base;
-
-void __init setup_trampolines(void)
-{
-	phys_addr_t mem;
-	size_t size = PAGE_ALIGN(x86_trampoline_end - x86_trampoline_start);
-
-	/* Has to be in very low memory so we can execute real-mode AP code. */
-	mem = memblock_find_in_range(0, 1<<20, size, PAGE_SIZE);
-	if (!mem)
-		panic("Cannot allocate trampoline\n");
-
-	x86_trampoline_base = __va(mem);
-	memblock_reserve(mem, size);
-
-	printk(KERN_DEBUG "Base memory trampoline at [%p] %llx size %zu\n",
-	       x86_trampoline_base, (unsigned long long)mem, size);
-
-	memcpy(x86_trampoline_base, x86_trampoline_start, size);
-}
-
-/*
- * setup_trampolines() gets called very early, to guarantee the
- * availability of low memory.  This is before the proper kernel page
- * tables are set up, so we cannot set page permissions in that
- * function.  Thus, we use an arch_initcall instead.
- */
-static int __init configure_trampolines(void)
-{
-	size_t size = PAGE_ALIGN(x86_trampoline_end - x86_trampoline_start);
-
-	set_memory_x((unsigned long)x86_trampoline_base, size >> PAGE_SHIFT);
-	return 0;
-}
-arch_initcall(configure_trampolines);
diff --git a/arch/x86/kernel/trampoline_32.S b/arch/x86/kernel/trampoline_32.S
deleted file mode 100644
index 451c0a7..0000000
--- a/arch/x86/kernel/trampoline_32.S
+++ /dev/null
@@ -1,83 +0,0 @@
-/*
- *
- *	Trampoline.S	Derived from Setup.S by Linus Torvalds
- *
- *	4 Jan 1997 Michael Chastain: changed to gnu as.
- *
- *	This is only used for booting secondary CPUs in SMP machine
- *
- *	Entry: CS:IP point to the start of our code, we are 
- *	in real mode with no stack, but the rest of the 
- *	trampoline page to make our stack and everything else
- *	is a mystery.
- *
- *	We jump into arch/x86/kernel/head_32.S.
- *
- *	On entry to trampoline_data, the processor is in real mode
- *	with 16-bit addressing and 16-bit data.  CS has some value
- *	and IP is zero.  Thus, data addresses need to be absolute
- *	(no relocation) and are taken with regard to r_base.
- *
- *	If you work on this file, check the object module with
- *	objdump --reloc to make sure there are no relocation
- *	entries except for:
- *
- *	TYPE              VALUE
- *	R_386_32          startup_32_smp
- *	R_386_32          boot_gdt
- */
-
-#include <linux/linkage.h>
-#include <linux/init.h>
-#include <asm/segment.h>
-#include <asm/page_types.h>
-
-#ifdef CONFIG_SMP
-
-	.section ".x86_trampoline","a"
-	.balign PAGE_SIZE
-	.code16
-
-ENTRY(trampoline_data)
-r_base = .
-	wbinvd			# Needed for NUMA-Q should be harmless for others
-	mov	%cs, %ax	# Code and data in the same place
-	mov	%ax, %ds
-
-	cli			# We should be safe anyway
-
-	movl	$0xA5A5A5A5, trampoline_status - r_base
-				# write marker for master knows we're running
-
-	/* GDT tables in non default location kernel can be beyond 16MB and
-	 * lgdt will not be able to load the address as in real mode default
-	 * operand size is 16bit. Use lgdtl instead to force operand size
-	 * to 32 bit.
-	 */
-
-	lidtl	boot_idt_descr - r_base	# load idt with 0, 0
-	lgdtl	boot_gdt_descr - r_base	# load gdt with whatever is appropriate
-
-	xor	%ax, %ax
-	inc	%ax		# protected mode (PE) bit
-	lmsw	%ax		# into protected mode
-	# flush prefetch and jump to startup_32_smp in arch/i386/kernel/head.S
-	ljmpl	$__BOOT_CS, $(startup_32_smp-__PAGE_OFFSET)
-
-	# These need to be in the same 64K segment as the above;
-	# hence we don't use the boot_gdt_descr defined in head.S
-boot_gdt_descr:
-	.word	__BOOT_DS + 7			# gdt limit
-	.long	boot_gdt - __PAGE_OFFSET	# gdt base
-
-boot_idt_descr:
-	.word	0				# idt limit = 0
-	.long	0				# idt base = 0L
-
-ENTRY(trampoline_status)
-	.long	0
-
-.globl trampoline_end
-trampoline_end:
-
-#endif /* CONFIG_SMP */
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 0f703f1..22a1530 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -197,18 +197,6 @@ SECTIONS
 
 	INIT_DATA_SECTION(16)
 
-	/*
-	 * Code and data for a variety of lowlevel trampolines, to be
-	 * copied into base memory (< 1 MiB) during initialization.
-	 * Since it is copied early, the main copy can be discarded
-	 * afterwards.
-	 */
-	 .x86_trampoline : AT(ADDR(.x86_trampoline) - LOAD_OFFSET) {
-		x86_trampoline_start = .;
-		*(.x86_trampoline)
-		x86_trampoline_end = .;
-	}
-
 	.x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
 		__x86_cpu_dev_start = .;
 		*(.x86_cpu_dev.init)
diff --git a/arch/x86/realmode/Makefile b/arch/x86/realmode/Makefile
new file mode 100644
index 0000000..94f7fbe
--- /dev/null
+++ b/arch/x86/realmode/Makefile
@@ -0,0 +1,18 @@
+#
+# arch/x86/realmode/Makefile
+#
+# This file is subject to the terms and conditions of the GNU General Public
+# License.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+#
+
+subdir- := rm
+
+obj-y += init.o
+obj-y += rmpiggy.o
+
+$(obj)/rmpiggy.o: $(obj)/rm/realmode.bin
+
+$(obj)/rm/realmode.bin: FORCE
+	$(Q)$(MAKE) $(build)=$(obj)/rm $@
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
new file mode 100644
index 0000000..cbca565
--- /dev/null
+++ b/arch/x86/realmode/init.c
@@ -0,0 +1,115 @@
+#include <linux/io.h>
+#include <linux/memblock.h>
+
+#include <asm/cacheflush.h>
+#include <asm/pgtable.h>
+#include <asm/realmode.h>
+
+struct real_mode_header *real_mode_header;
+u32 *trampoline_cr4_features;
+
+void __init setup_real_mode(void)
+{
+	phys_addr_t mem;
+	u16 real_mode_seg;
+	u32 *rel;
+	u32 count;
+	u32 *ptr;
+	u16 *seg;
+	int i;
+	unsigned char *base;
+	struct trampoline_header *trampoline_header;
+	size_t size = PAGE_ALIGN(real_mode_blob_end - real_mode_blob);
+#ifdef CONFIG_X86_64
+	u64 *trampoline_pgd;
+	u64 efer;
+#endif
+
+	/* Has to be in very low memory so we can execute real-mode AP code. */
+	mem = memblock_find_in_range(0, 1<<20, size, PAGE_SIZE);
+	if (!mem)
+		panic("Cannot allocate trampoline\n");
+
+	base = __va(mem);
+	memblock_reserve(mem, size);
+	real_mode_header = (struct real_mode_header *) base;
+	printk(KERN_DEBUG "Base memory trampoline at [%p] %llx size %zu\n",
+	       base, (unsigned long long)mem, size);
+
+	memcpy(base, real_mode_blob, size);
+
+	real_mode_seg = __pa(base) >> 4;
+	rel = (u32 *) real_mode_relocs;
+
+	/* 16-bit segment relocations. */
+	count = rel[0];
+	rel = &rel[1];
+	for (i = 0; i < count; i++) {
+		seg = (u16 *) (base + rel[i]);
+		*seg = real_mode_seg;
+	}
+
+	/* 32-bit linear relocations. */
+	count = rel[i];
+	rel =  &rel[i + 1];
+	for (i = 0; i < count; i++) {
+		ptr = (u32 *) (base + rel[i]);
+		*ptr += __pa(base);
+	}
+
+	/* Must be perfomed *after* relocation. */
+	trampoline_header = (struct trampoline_header *)
+		__va(real_mode_header->trampoline_header);
+
+#ifdef CONFIG_X86_32
+	trampoline_header->start = __pa(startup_32_smp);
+	trampoline_header->gdt_limit = __BOOT_DS + 7;
+	trampoline_header->gdt_base = __pa(boot_gdt);
+#else
+	/*
+	 * Some AMD processors will #GP(0) if EFER.LMA is set in WRMSR
+	 * so we need to mask it out.
+	 */
+	rdmsrl(MSR_EFER, efer);
+	trampoline_header->efer = efer & ~EFER_LMA;
+
+	trampoline_header->start = (u64) secondary_startup_64;
+	trampoline_cr4_features = &trampoline_header->cr4;
+	*trampoline_cr4_features = read_cr4();
+
+	trampoline_pgd = (u64 *) __va(real_mode_header->trampoline_pgd);
+	trampoline_pgd[0] = __pa(level3_ident_pgt) + _KERNPG_TABLE;
+	trampoline_pgd[511] = __pa(level3_kernel_pgt) + _KERNPG_TABLE;
+#endif
+}
+
+/*
+ * set_real_mode_permissions() gets called very early, to guarantee the
+ * availability of low memory.  This is before the proper kernel page
+ * tables are set up, so we cannot set page permissions in that
+ * function.  Thus, we use an arch_initcall instead.
+ */
+static int __init set_real_mode_permissions(void)
+{
+	unsigned char *base = (unsigned char *) real_mode_header;
+	size_t size = PAGE_ALIGN(real_mode_blob_end - real_mode_blob);
+
+	size_t ro_size =
+		PAGE_ALIGN(real_mode_header->ro_end) -
+		__pa(base);
+
+	size_t text_size =
+		PAGE_ALIGN(real_mode_header->ro_end) -
+		real_mode_header->text_start;
+
+	unsigned long text_start =
+		(unsigned long) __va(real_mode_header->text_start);
+
+	set_memory_nx((unsigned long) base, size >> PAGE_SHIFT);
+	set_memory_ro((unsigned long) base, ro_size >> PAGE_SHIFT);
+	set_memory_x((unsigned long) text_start, text_size >> PAGE_SHIFT);
+
+	return 0;
+}
+
+arch_initcall(set_real_mode_permissions);
diff --git a/arch/x86/realmode/rm/.gitignore b/arch/x86/realmode/rm/.gitignore
new file mode 100644
index 0000000..b6ed3a2
--- /dev/null
+++ b/arch/x86/realmode/rm/.gitignore
@@ -0,0 +1,3 @@
+pasyms.h
+realmode.lds
+realmode.relocs
diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
new file mode 100644
index 0000000..5b84a2d
--- /dev/null
+++ b/arch/x86/realmode/rm/Makefile
@@ -0,0 +1,82 @@
+#
+# arch/x86/realmode/Makefile
+#
+# This file is subject to the terms and conditions of the GNU General Public
+# License.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+#
+
+always := realmode.bin realmode.relocs
+
+wakeup-objs	:= wakeup_asm.o wakemain.o video-mode.o
+wakeup-objs	+= copy.o bioscall.o regs.o
+# The link order of the video-*.o modules can matter.  In particular,
+# video-vga.o *must* be listed first, followed by video-vesa.o.
+# Hardware-specific drivers should follow in the order they should be
+# probed, and video-bios.o should typically be last.
+wakeup-objs	+= video-vga.o
+wakeup-objs	+= video-vesa.o
+wakeup-objs	+= video-bios.o
+
+realmode-y			+= header.o
+realmode-y			+= trampoline_$(BITS).o
+realmode-y			+= stack.o
+realmode-$(CONFIG_X86_32)	+= reboot_32.o
+realmode-$(CONFIG_ACPI_SLEEP)	+= $(wakeup-objs)
+
+targets	+= $(realmode-y)
+
+REALMODE_OBJS = $(addprefix $(obj)/,$(realmode-y))
+
+sed-pasyms := -n -r -e 's/^([0-9a-fA-F]+) [ABCDGRSTVW] (.+)$$/pa_\2 = \2;/p'
+
+quiet_cmd_pasyms = PASYMS  $@
+      cmd_pasyms = $(NM) $(filter-out FORCE,$^) | \
+		   sed $(sed-pasyms) | sort | uniq > $@
+
+targets += pasyms.h
+$(obj)/pasyms.h: $(REALMODE_OBJS) FORCE
+	$(call if_changed,pasyms)
+
+targets += realmode.lds
+$(obj)/realmode.lds: $(obj)/pasyms.h
+
+LDFLAGS_realmode.elf := --emit-relocs -T
+CPPFLAGS_realmode.lds += -P -C -I$(obj)
+
+targets += realmode.elf
+$(obj)/realmode.elf: $(obj)/realmode.lds $(REALMODE_OBJS) FORCE
+	$(call if_changed,ld)
+
+OBJCOPYFLAGS_realmode.bin := -O binary
+
+targets += realmode.bin
+$(obj)/realmode.bin: $(obj)/realmode.elf $(obj)/realmode.relocs
+	$(call if_changed,objcopy)
+
+quiet_cmd_relocs = RELOCS  $@
+      cmd_relocs = arch/x86/tools/relocs --realmode $< > $@
+
+targets += realmode.relocs
+$(obj)/realmode.relocs: $(obj)/realmode.elf FORCE
+	$(call if_changed,relocs)
+
+# ---------------------------------------------------------------------------
+
+# How to compile the 16-bit code.  Note we always compile for -march=i386,
+# that way we can complain to the user if the CPU is insufficient.
+KBUILD_CFLAGS	:= $(LINUXINCLUDE) -m32 -g -Os -D_SETUP -D__KERNEL__ -D_WAKEUP \
+		   -I$(srctree)/arch/x86/boot \
+		   -DDISABLE_BRANCH_PROFILING \
+		   -Wall -Wstrict-prototypes \
+		   -march=i386 -mregparm=3 \
+		   -include $(srctree)/$(src)/../../boot/code16gcc.h \
+		   -fno-strict-aliasing -fomit-frame-pointer \
+		   $(call cc-option, -ffreestanding) \
+		   $(call cc-option, -fno-toplevel-reorder,\
+			$(call cc-option, -fno-unit-at-a-time)) \
+		   $(call cc-option, -fno-stack-protector) \
+		   $(call cc-option, -mpreferred-stack-boundary=2)
+KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
+GCOV_PROFILE := n
diff --git a/arch/x86/realmode/rm/bioscall.S b/arch/x86/realmode/rm/bioscall.S
new file mode 100644
index 0000000..16162d1
--- /dev/null
+++ b/arch/x86/realmode/rm/bioscall.S
@@ -0,0 +1 @@
+#include "../../boot/bioscall.S"
diff --git a/arch/x86/realmode/rm/copy.S b/arch/x86/realmode/rm/copy.S
new file mode 100644
index 0000000..b785e6f
--- /dev/null
+++ b/arch/x86/realmode/rm/copy.S
@@ -0,0 +1 @@
+#include "../../boot/copy.S"
diff --git a/arch/x86/realmode/rm/header.S b/arch/x86/realmode/rm/header.S
new file mode 100644
index 0000000..fadf483
--- /dev/null
+++ b/arch/x86/realmode/rm/header.S
@@ -0,0 +1,41 @@
+/*
+ * Real-mode blob header; this should match realmode.h and be
+ * readonly; for mutable data instead add pointers into the .data
+ * or .bss sections as appropriate.
+ */
+
+#include <linux/linkage.h>
+#include <asm/page_types.h>
+
+#include "realmode.h"
+	
+	.section ".header", "a"
+
+	.balign	16
+GLOBAL(real_mode_header)
+	.long	pa_text_start
+	.long	pa_ro_end
+	/* SMP trampoline */
+	.long	pa_trampoline_start
+	.long	pa_trampoline_status
+	.long	pa_trampoline_header
+#ifdef CONFIG_X86_64
+	.long	pa_trampoline_pgd;
+#endif
+	/* ACPI S3 wakeup */
+#ifdef CONFIG_ACPI_SLEEP
+	.long	pa_wakeup_start
+	.long	pa_wakeup_header
+#endif
+	/* APM/BIOS reboot */
+#ifdef CONFIG_X86_32
+	.long	pa_machine_real_restart_asm
+#endif
+END(real_mode_header)
+
+	/* End signature, used to verify integrity */
+	.section ".signature","a"
+	.balign 4
+GLOBAL(end_signature)
+	.long	REALMODE_END_SIGNATURE
+END(end_signature)
diff --git a/arch/x86/realmode/rm/realmode.h b/arch/x86/realmode/rm/realmode.h
new file mode 100644
index 0000000..d74cff6
--- /dev/null
+++ b/arch/x86/realmode/rm/realmode.h
@@ -0,0 +1,21 @@
+#ifndef ARCH_X86_REALMODE_RM_REALMODE_H
+#define ARCH_X86_REALMODE_RM_REALMODE_H
+
+#ifdef __ASSEMBLY__
+
+/*
+ * 16-bit ljmpw to the real_mode_seg
+ *
+ * This must be open-coded since gas will choke on using a
+ * relocatable symbol for the segment portion.
+ */
+#define LJMPW_RM(to)	.byte 0xea ; .word (to), real_mode_seg
+
+#endif /* __ASSEMBLY__ */
+
+/*
+ * Signature at the end of the realmode region
+ */
+#define REALMODE_END_SIGNATURE	0x65a22c82
+
+#endif /* ARCH_X86_REALMODE_RM_REALMODE_H */
diff --git a/arch/x86/realmode/rm/realmode.lds.S b/arch/x86/realmode/rm/realmode.lds.S
new file mode 100644
index 0000000..86b2e8d
--- /dev/null
+++ b/arch/x86/realmode/rm/realmode.lds.S
@@ -0,0 +1,76 @@
+/*
+ * realmode.lds.S
+ *
+ * Linker script for the real-mode code
+ */
+
+#include <asm/page_types.h>
+
+#undef i386
+
+OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
+OUTPUT_ARCH(i386)
+
+SECTIONS
+{
+	real_mode_seg = 0;
+
+	. = 0;
+	.header : {
+		pa_real_mode_base = .;
+		*(.header)
+	}
+
+	. = ALIGN(4);
+	.rodata : {
+		*(.rodata)
+		*(.rodata.*)
+		. = ALIGN(16);
+		video_cards = .;
+		*(.videocards)
+		video_cards_end = .;
+	}
+
+	. = ALIGN(PAGE_SIZE);
+	pa_text_start = .;
+	.text : {
+		*(.text)
+		*(.text.*)
+	}
+
+	.text32 : {
+		*(.text32)
+		*(.text32.*)
+	}
+
+	.text64 : {
+		*(.text64)
+		*(.text64.*)
+	}
+	pa_ro_end = .;
+
+	. = ALIGN(PAGE_SIZE);
+	.data : {
+		*(.data)
+		*(.data.*)
+	}
+
+	. = ALIGN(128);
+	.bss : {
+		*(.bss*)
+	}
+
+	/* End signature for integrity checking */
+	. = ALIGN(4);
+	.signature : {
+		*(.signature)
+	}
+
+	/DISCARD/ : {
+		*(.note*)
+		*(.debug*)
+		*(.eh_frame*)
+	}
+
+#include "pasyms.h"
+}
diff --git a/arch/x86/kernel/reboot_32.S b/arch/x86/realmode/rm/reboot_32.S
similarity index 71%
rename from arch/x86/kernel/reboot_32.S
rename to arch/x86/realmode/rm/reboot_32.S
index 1d5c46d..1140448 100644
--- a/arch/x86/kernel/reboot_32.S
+++ b/arch/x86/realmode/rm/reboot_32.S
@@ -2,6 +2,7 @@
 #include <linux/init.h>
 #include <asm/segment.h>
 #include <asm/page_types.h>
+#include "realmode.h"
 
 /*
  * The following code and data reboots the machine by switching to real
@@ -13,34 +14,20 @@
  *
  * This code is called with the restart type (0 = BIOS, 1 = APM) in %eax.
  */
-	.section ".x86_trampoline","a"
-	.balign 16
+	.section ".text32", "ax"
 	.code32
-ENTRY(machine_real_restart_asm)
-r_base = .
-	/* Get our own relocated address */
-	call	1f
-1:	popl	%ebx
-	subl	$(1b - r_base), %ebx
-
-	/* Compute the equivalent real-mode segment */
-	movl	%ebx, %ecx
-	shrl	$4, %ecx
-	
-	/* Patch post-real-mode segment jump */
-	movw	(dispatch_table - r_base)(%ebx,%eax,2),%ax
-	movw	%ax, (101f - r_base)(%ebx)
-	movw	%cx, (102f - r_base)(%ebx)
 
+	.balign	16
+ENTRY(machine_real_restart_asm)
 	/* Set up the IDT for real mode. */
-	lidtl	(machine_real_restart_idt - r_base)(%ebx)
+	lidtl	pa_machine_real_restart_idt
 
 	/*
 	 * Set up a GDT from which we can load segment descriptors for real
 	 * mode.  The GDT is not used in real mode; it is just needed here to
 	 * prepare the descriptors.
 	 */
-	lgdtl	(machine_real_restart_gdt - r_base)(%ebx)
+	lgdtl	pa_machine_real_restart_gdt
 
 	/*
 	 * Load the data segment registers with 16-bit compatible values
@@ -51,7 +38,7 @@ r_base = .
 	movl	%ecx, %fs
 	movl	%ecx, %gs
 	movl	%ecx, %ss
-	ljmpl	$8, $1f - r_base
+	ljmpw	$8, $1f
 
 /*
  * This is 16-bit protected mode code to disable paging and the cache,
@@ -76,27 +63,29 @@ r_base = .
  *
  * Most of this work is probably excessive, but it is what is tested.
  */
+	.text
 	.code16
+
+	.balign	16
+machine_real_restart_asm16:
 1:
 	xorl	%ecx, %ecx
-	movl	%cr0, %eax
-	andl	$0x00000011, %eax
-	orl	$0x60000000, %eax
-	movl	%eax, %cr0
+	movl	%cr0, %edx
+	andl	$0x00000011, %edx
+	orl	$0x60000000, %edx
+	movl	%edx, %cr0
 	movl	%ecx, %cr3
 	movl	%cr0, %edx
-	andl	$0x60000000, %edx	/* If no cache bits -> no wbinvd */
+	testl	$0x60000000, %edx	/* If no cache bits -> no wbinvd */
 	jz	2f
 	wbinvd
 2:
-	andb	$0x10, %al
-	movl	%eax, %cr0
-	.byte	0xea			/* ljmpw */
-101:	.word	0			/* Offset */
-102:	.word	0			/* Segment */
-
-bios:
-	ljmpw	$0xf000, $0xfff0
+	andb	$0x10, %dl
+	movl	%edx, %cr0
+	LJMPW_RM(3f)
+3:
+	andw	%ax, %ax
+	jz	bios
 
 apm:
 	movw	$0x1000, %ax
@@ -106,26 +95,34 @@ apm:
 	movw	$0x0001, %bx
 	movw	$0x0003, %cx
 	int	$0x15
+	/* This should never return... */
 
-END(machine_real_restart_asm)
+bios:
+	ljmpw	$0xf000, $0xfff0
 
-	.balign 16
-	/* These must match <asm/reboot.h */
-dispatch_table:
-	.word	bios - r_base
-	.word	apm - r_base
-END(dispatch_table)
+	.section ".rodata", "a"
 
-	.balign 16
-machine_real_restart_idt:
+	.balign	16
+GLOBAL(machine_real_restart_idt)
 	.word	0xffff		/* Length - real mode default value */
 	.long	0		/* Base - real mode default value */
 END(machine_real_restart_idt)
 
-	.balign 16
-ENTRY(machine_real_restart_gdt)
-	.quad	0		/* Self-pointer, filled in by PM code */
-	.quad	0		/* 16-bit code segment, filled in by PM code */
+	.balign	16
+GLOBAL(machine_real_restart_gdt)
+	/* Self-pointer */
+	.word	0xffff		/* Length - real mode default value */
+	.long	pa_machine_real_restart_gdt
+	.word	0
+
+	/*
+	 * 16-bit code segment pointing to real_mode_seg
+	 * Selector value 8
+	 */
+	.word	0xffff		/* Limit */
+	.long	0x9b000000 + pa_real_mode_base
+	.word	0
+
 	/*
 	 * 16-bit data segment with the selector value 16 = 0x10 and
 	 * base value 0x100; since this is consistent with real mode
diff --git a/arch/x86/realmode/rm/regs.c b/arch/x86/realmode/rm/regs.c
new file mode 100644
index 0000000..fbb15b9
--- /dev/null
+++ b/arch/x86/realmode/rm/regs.c
@@ -0,0 +1 @@
+#include "../../boot/regs.c"
diff --git a/arch/x86/realmode/rm/stack.S b/arch/x86/realmode/rm/stack.S
new file mode 100644
index 0000000..867ae87
--- /dev/null
+++ b/arch/x86/realmode/rm/stack.S
@@ -0,0 +1,19 @@
+/*
+ * Common heap and stack allocations
+ */
+
+#include <linux/linkage.h>
+
+	.data
+GLOBAL(HEAP)
+	.long	rm_heap
+GLOBAL(heap_end)
+	.long	rm_stack
+
+	.bss
+	.balign	16
+GLOBAL(rm_heap)
+	.space	2048
+GLOBAL(rm_stack)
+	.space	2048
+GLOBAL(rm_stack_end)
diff --git a/arch/x86/realmode/rm/trampoline_32.S b/arch/x86/realmode/rm/trampoline_32.S
new file mode 100644
index 0000000..c1b2791
--- /dev/null
+++ b/arch/x86/realmode/rm/trampoline_32.S
@@ -0,0 +1,74 @@
+/*
+ *
+ *	Trampoline.S	Derived from Setup.S by Linus Torvalds
+ *
+ *	4 Jan 1997 Michael Chastain: changed to gnu as.
+ *
+ *	This is only used for booting secondary CPUs in SMP machine
+ *
+ *	Entry: CS:IP point to the start of our code, we are
+ *	in real mode with no stack, but the rest of the
+ *	trampoline page to make our stack and everything else
+ *	is a mystery.
+ *
+ *	We jump into arch/x86/kernel/head_32.S.
+ *
+ *	On entry to trampoline_start, the processor is in real mode
+ *	with 16-bit addressing and 16-bit data.  CS has some value
+ *	and IP is zero.  Thus, we load CS to the physical segment
+ *	of the real mode code before doing anything further.
+ */
+
+#include <linux/linkage.h>
+#include <linux/init.h>
+#include <asm/segment.h>
+#include <asm/page_types.h>
+#include "realmode.h"
+
+	.text
+	.code16
+
+	.balign	PAGE_SIZE
+ENTRY(trampoline_start)
+	wbinvd			# Needed for NUMA-Q should be harmless for others
+
+	LJMPW_RM(1f)
+1:
+	mov	%cs, %ax	# Code and data in the same place
+	mov	%ax, %ds
+
+	cli			# We should be safe anyway
+
+	movl	tr_start, %eax	# where we need to go
+
+	movl	$0xA5A5A5A5, trampoline_status
+				# write marker for master knows we're running
+
+	/*
+	 * GDT tables in non default location kernel can be beyond 16MB and
+	 * lgdt will not be able to load the address as in real mode default
+	 * operand size is 16bit. Use lgdtl instead to force operand size
+	 * to 32 bit.
+	 */
+	lidtl	tr_idt			# load idt with 0, 0
+	lgdtl	tr_gdt			# load gdt with whatever is appropriate
+
+	movw	$1, %dx			# protected mode (PE) bit
+	lmsw	%dx			# into protected mode
+
+	ljmpl	$__BOOT_CS, $pa_startup_32
+
+	.section ".text32","ax"
+	.code32
+ENTRY(startup_32)			# note: also used from wakeup_asm.S
+	jmp	*%eax
+
+	.bss
+	.balign 8
+GLOBAL(trampoline_header)
+	tr_start:		.space	4
+	tr_gdt_pad:		.space	2
+	tr_gdt:			.space	6
+END(trampoline_header)
+	
+#include "trampoline_common.S"
diff --git a/arch/x86/kernel/trampoline_64.S b/arch/x86/realmode/rm/trampoline_64.S
similarity index 51%
rename from arch/x86/kernel/trampoline_64.S
rename to arch/x86/realmode/rm/trampoline_64.S
index 09ff517..bb360dc 100644
--- a/arch/x86/kernel/trampoline_64.S
+++ b/arch/x86/realmode/rm/trampoline_64.S
@@ -5,12 +5,12 @@
  *	4 Jan 1997 Michael Chastain: changed to gnu as.
  *	15 Sept 2005 Eric Biederman: 64bit PIC support
  *
- *	Entry: CS:IP point to the start of our code, we are 
- *	in real mode with no stack, but the rest of the 
+ *	Entry: CS:IP point to the start of our code, we are
+ *	in real mode with no stack, but the rest of the
  *	trampoline page to make our stack and everything else
  *	is a mystery.
  *
- *	On entry to trampoline_data, the processor is in real mode
+ *	On entry to trampoline_start, the processor is in real mode
  *	with 16-bit addressing and 16-bit data.  CS has some value
  *	and IP is zero.  Thus, data addresses need to be absolute
  *	(no relocation) and are taken with regard to r_base.
@@ -31,43 +31,33 @@
 #include <asm/msr.h>
 #include <asm/segment.h>
 #include <asm/processor-flags.h>
+#include "realmode.h"
 
-	.section ".x86_trampoline","a"
-	.balign PAGE_SIZE
+	.text
 	.code16
 
-ENTRY(trampoline_data)
-r_base = .
+	.balign	PAGE_SIZE
+ENTRY(trampoline_start)
 	cli			# We should be safe anyway
 	wbinvd
+
+	LJMPW_RM(1f)
+1:
 	mov	%cs, %ax	# Code and data in the same place
 	mov	%ax, %ds
 	mov	%ax, %es
 	mov	%ax, %ss
 
+	movl	$0xA5A5A5A5, trampoline_status
+	# write marker for master knows we're running
 
-	movl	$0xA5A5A5A5, trampoline_status - r_base
-				# write marker for master knows we're running
-
-					# Setup stack
-	movw	$(trampoline_stack_end - r_base), %sp
+	# Setup stack
+	movl	$rm_stack_end, %esp
 
 	call	verify_cpu		# Verify the cpu supports long mode
 	testl   %eax, %eax		# Check for return code
 	jnz	no_longmode
 
-	mov	%cs, %ax
-	movzx	%ax, %esi		# Find the 32bit trampoline location
-	shll	$4, %esi
-
-					# Fixup the absolute vectors
-	leal	(startup_32 - r_base)(%esi), %eax
-	movl	%eax, startup_32_vector - r_base
-	leal	(startup_64 - r_base)(%esi), %eax
-	movl	%eax, startup_64_vector - r_base
-	leal	(tgdt - r_base)(%esi), %eax
-	movl	%eax, (tgdt + 2 - r_base)
-
 	/*
 	 * GDT tables in non default location kernel can be beyond 16MB and
 	 * lgdt will not be able to load the address as in real mode default
@@ -75,36 +65,49 @@ r_base = .
 	 * to 32 bit.
 	 */
 
-	lidtl	tidt - r_base	# load idt with 0, 0
-	lgdtl	tgdt - r_base	# load gdt with whatever is appropriate
+	lidtl	tr_idt	# load idt with 0, 0
+	lgdtl	tr_gdt	# load gdt with whatever is appropriate
+
+	movw	$__KERNEL_DS, %dx	# Data segment descriptor
 
-	mov	$X86_CR0_PE, %ax	# protected mode (PE) bit
-	lmsw	%ax			# into protected mode
+	# Enable protected mode
+	movl	$X86_CR0_PE, %eax	# protected mode (PE) bit
+	movl	%eax, %cr0		# into protected mode
 
 	# flush prefetch and jump to startup_32
-	ljmpl	*(startup_32_vector - r_base)
+	ljmpl	$__KERNEL32_CS, $pa_startup_32
 
+no_longmode:
+	hlt
+	jmp no_longmode
+#include "../kernel/verify_cpu.S"
+
+	.section ".text32","ax"
 	.code32
 	.balign 4
-startup_32:
-	movl	$__KERNEL_DS, %eax	# Initialize the %ds segment register
-	movl	%eax, %ds
-
-	movl	$X86_CR4_PAE, %eax
+ENTRY(startup_32)
+	movl	%edx, %ss
+	addl	$pa_real_mode_base, %esp
+	movl	%edx, %ds
+	movl	%edx, %es
+	movl	%edx, %fs
+	movl	%edx, %gs
+
+	movl	pa_tr_cr4, %eax
 	movl	%eax, %cr4		# Enable PAE mode
 
-					# Setup trampoline 4 level pagetables
-	leal	(trampoline_level4_pgt - r_base)(%esi), %eax
+	# Setup trampoline 4 level pagetables
+	movl	$pa_trampoline_pgd, %eax
 	movl	%eax, %cr3
 
+	# Set up EFER
+	movl	pa_tr_efer, %eax
+	movl	pa_tr_efer + 4, %edx
 	movl	$MSR_EFER, %ecx
-	movl	$(1 << _EFER_LME), %eax	# Enable Long Mode
-	xorl	%edx, %edx
 	wrmsr
 
 	# Enable paging and in turn activate Long Mode
-	# Enable protected mode
-	movl	$(X86_CR0_PG | X86_CR0_PE), %eax
+	movl	$(X86_CR0_PG | X86_CR0_WP | X86_CR0_PE), %eax
 	movl	%eax, %cr0
 
 	/*
@@ -113,59 +116,38 @@ startup_32:
 	 * EFER.LMA = 1). Now we want to jump in 64bit mode, to do that we use
 	 * the new gdt/idt that has __KERNEL_CS with CS.L = 1.
 	 */
-	ljmp	*(startup_64_vector - r_base)(%esi)
+	ljmpl	$__KERNEL_CS, $pa_startup_64
 
+	.section ".text64","ax"
 	.code64
 	.balign 4
-startup_64:
+ENTRY(startup_64)
 	# Now jump into the kernel using virtual addresses
-	movq	$secondary_startup_64, %rax
-	jmp	*%rax
-
-	.code16
-no_longmode:
-	hlt
-	jmp no_longmode
-#include "verify_cpu.S"
-
-	.balign 4
-	# Careful these need to be in the same 64K segment as the above;
-tidt:
-	.word	0			# idt limit = 0
-	.word	0, 0			# idt base = 0L
+	jmpq	*tr_start(%rip)
 
+	.section ".rodata","a"
 	# Duplicate the global descriptor table
 	# so the kernel can live anywhere
-	.balign 4
-tgdt:
-	.short	tgdt_end - tgdt		# gdt limit
-	.long	tgdt - r_base
-	.short 0
+	.balign	16
+	.globl tr_gdt
+tr_gdt:
+	.short	tr_gdt_end - tr_gdt - 1	# gdt limit
+	.long	pa_tr_gdt
+	.short	0
 	.quad	0x00cf9b000000ffff	# __KERNEL32_CS
 	.quad	0x00af9b000000ffff	# __KERNEL_CS
 	.quad	0x00cf93000000ffff	# __KERNEL_DS
-tgdt_end:
+tr_gdt_end:
 
-	.balign 4
-startup_32_vector:
-	.long	startup_32 - r_base
-	.word	__KERNEL32_CS, 0
+	.bss
+	.balign	PAGE_SIZE
+GLOBAL(trampoline_pgd)		.space	PAGE_SIZE
 
-	.balign 4
-startup_64_vector:
-	.long	startup_64 - r_base
-	.word	__KERNEL_CS, 0
+	.balign	8
+GLOBAL(trampoline_header)
+	tr_start:		.space	8
+	GLOBAL(tr_efer)		.space	8
+	GLOBAL(tr_cr4)		.space	4
+END(trampoline_header)
 
-	.balign 4
-ENTRY(trampoline_status)
-	.long	0
-
-trampoline_stack:
-	.org 0x1000
-trampoline_stack_end:
-ENTRY(trampoline_level4_pgt)
-	.quad	level3_ident_pgt - __START_KERNEL_map + _KERNPG_TABLE
-	.fill	510,8,0
-	.quad	level3_kernel_pgt - __START_KERNEL_map + _KERNPG_TABLE
-
-ENTRY(trampoline_end)
+#include "trampoline_common.S"
diff --git a/arch/x86/realmode/rm/trampoline_common.S b/arch/x86/realmode/rm/trampoline_common.S
new file mode 100644
index 0000000..b1ecdb9
--- /dev/null
+++ b/arch/x86/realmode/rm/trampoline_common.S
@@ -0,0 +1,7 @@
+	.section ".rodata","a"
+	.balign	16
+tr_idt: .fill 1, 6, 0
+
+	.bss
+	.balign	4
+GLOBAL(trampoline_status)	.space	4
diff --git a/arch/x86/realmode/rm/video-bios.c b/arch/x86/realmode/rm/video-bios.c
new file mode 100644
index 0000000..848b25a
--- /dev/null
+++ b/arch/x86/realmode/rm/video-bios.c
@@ -0,0 +1 @@
+#include "../../boot/video-bios.c"
diff --git a/arch/x86/realmode/rm/video-mode.c b/arch/x86/realmode/rm/video-mode.c
new file mode 100644
index 0000000..2a98b7e
--- /dev/null
+++ b/arch/x86/realmode/rm/video-mode.c
@@ -0,0 +1 @@
+#include "../../boot/video-mode.c"
diff --git a/arch/x86/realmode/rm/video-vesa.c b/arch/x86/realmode/rm/video-vesa.c
new file mode 100644
index 0000000..413eddd
--- /dev/null
+++ b/arch/x86/realmode/rm/video-vesa.c
@@ -0,0 +1 @@
+#include "../../boot/video-vesa.c"
diff --git a/arch/x86/realmode/rm/video-vga.c b/arch/x86/realmode/rm/video-vga.c
new file mode 100644
index 0000000..3085f5c
--- /dev/null
+++ b/arch/x86/realmode/rm/video-vga.c
@@ -0,0 +1 @@
+#include "../../boot/video-vga.c"
diff --git a/arch/x86/kernel/acpi/realmode/wakemain.c b/arch/x86/realmode/rm/wakemain.c
similarity index 98%
rename from arch/x86/kernel/acpi/realmode/wakemain.c
rename to arch/x86/realmode/rm/wakemain.c
index 883962d..91405d5 100644
--- a/arch/x86/kernel/acpi/realmode/wakemain.c
+++ b/arch/x86/realmode/rm/wakemain.c
@@ -65,7 +65,8 @@ void main(void)
 {
 	/* Kill machine if structures are wrong */
 	if (wakeup_header.real_magic != 0x12345678)
-		while (1);
+		while (1)
+			;
 
 	if (wakeup_header.realmode_flags & 4)
 		send_morse("...-");
diff --git a/arch/x86/kernel/acpi/realmode/wakeup.h b/arch/x86/realmode/rm/wakeup.h
similarity index 79%
rename from arch/x86/kernel/acpi/realmode/wakeup.h
rename to arch/x86/realmode/rm/wakeup.h
index 97a29e1..9317e00 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.h
+++ b/arch/x86/realmode/rm/wakeup.h
@@ -12,9 +12,8 @@
 /* This must match data at wakeup.S */
 struct wakeup_header {
 	u16 video_mode;		/* Video mode number */
-	u16 _jmp1;		/* ljmpl opcode, 32-bit only */
 	u32 pmode_entry;	/* Protected mode resume point, 32-bit only */
-	u16 _jmp2;		/* CS value, 32-bit only */
+	u16 pmode_cs;
 	u32 pmode_cr0;		/* Protected mode cr0 */
 	u32 pmode_cr3;		/* Protected mode cr3 */
 	u32 pmode_cr4;		/* Protected mode cr4 */
@@ -26,12 +25,6 @@ struct wakeup_header {
 	u32 pmode_behavior;	/* Wakeup routine behavior flags */
 	u32 realmode_flags;
 	u32 real_magic;
-	u16 trampoline_segment;	/* segment with trampoline code, 64-bit only */
-	u8  _pad1;
-	u8  wakeup_jmp;
-	u16 wakeup_jmp_off;
-	u16 wakeup_jmp_seg;
-	u64 wakeup_gdt[3];
 	u32 signature;		/* To check we have correct structure */
 } __attribute__((__packed__));
 
@@ -40,7 +33,6 @@ extern struct wakeup_header wakeup_header;
 
 #define WAKEUP_HEADER_OFFSET	8
 #define WAKEUP_HEADER_SIGNATURE 0x51ee1111
-#define WAKEUP_END_SIGNATURE	0x65a22c82
 
 /* Wakeup behavior bits */
 #define WAKEUP_BEHAVIOR_RESTORE_MISC_ENABLE     0
diff --git a/arch/x86/kernel/acpi/realmode/wakeup.S b/arch/x86/realmode/rm/wakeup_asm.S
similarity index 54%
rename from arch/x86/kernel/acpi/realmode/wakeup.S
rename to arch/x86/realmode/rm/wakeup_asm.S
index b4fd836..8905166 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.S
+++ b/arch/x86/realmode/rm/wakeup_asm.S
@@ -1,50 +1,47 @@
 /*
  * ACPI wakeup real mode startup stub
  */
+#include <linux/linkage.h>
 #include <asm/segment.h>
 #include <asm/msr-index.h>
 #include <asm/page_types.h>
 #include <asm/pgtable_types.h>
 #include <asm/processor-flags.h>
+#include "realmode.h"
 #include "wakeup.h"
 
 	.code16
-	.section ".jump", "ax"
-	.globl	_start
-_start:
-	cli
-	jmp	wakeup_code
 
 /* This should match the structure in wakeup.h */
-		.section ".header", "a"
-		.globl	wakeup_header
-wakeup_header:
-video_mode:	.short	0	/* Video mode number */
-pmode_return:	.byte	0x66, 0xea	/* ljmpl */
-		.long	0	/* offset goes here */
-		.short	__KERNEL_CS
-pmode_cr0:	.long	0	/* Saved %cr0 */
-pmode_cr3:	.long	0	/* Saved %cr3 */
-pmode_cr4:	.long	0	/* Saved %cr4 */
-pmode_efer:	.quad	0	/* Saved EFER */
-pmode_gdt:	.quad	0
-pmode_misc_en:	.quad	0	/* Saved MISC_ENABLE MSR */
-pmode_behavior:	.long	0	/* Wakeup behavior flags */
-realmode_flags:	.long	0
-real_magic:	.long	0
-trampoline_segment:	.word 0
-_pad1:		.byte	0
-wakeup_jmp:	.byte	0xea	/* ljmpw */
-wakeup_jmp_off:	.word	3f
-wakeup_jmp_seg:	.word	0
-wakeup_gdt:	.quad	0, 0, 0
-signature:	.long	WAKEUP_HEADER_SIGNATURE
+	.section ".data", "aw"
+
+	.balign	16
+GLOBAL(wakeup_header)
+	video_mode:	.short	0	/* Video mode number */
+	pmode_entry:	.long	0
+	pmode_cs:	.short	__KERNEL_CS
+	pmode_cr0:	.long	0	/* Saved %cr0 */
+	pmode_cr3:	.long	0	/* Saved %cr3 */
+	pmode_cr4:	.long	0	/* Saved %cr4 */
+	pmode_efer:	.quad	0	/* Saved EFER */
+	pmode_gdt:	.quad	0
+	pmode_misc_en:	.quad	0	/* Saved MISC_ENABLE MSR */
+	pmode_behavior:	.long	0	/* Wakeup behavior flags */
+	realmode_flags:	.long	0
+	real_magic:	.long	0
+	signature:	.long	WAKEUP_HEADER_SIGNATURE
+END(wakeup_header)
 
 	.text
 	.code16
-wakeup_code:
+
+	.balign	16
+ENTRY(wakeup_start)
+	cli
 	cld
 
+	LJMPW_RM(3f)
+3:
 	/* Apparently some dimwit BIOS programmers don't know how to
 	   program a PM to RM transition, and we might end up here with
 	   junk in the data segment descriptor registers.  The only way
@@ -54,8 +51,7 @@ wakeup_code:
 	movl	%cr0, %eax
 	orb	$X86_CR0_PE, %al
 	movl	%eax, %cr0
-	jmp	1f
-1:	ljmpw	$8, $2f
+	ljmpw	$8, $2f
 2:
 	movw	%cx, %ds
 	movw	%cx, %es
@@ -65,16 +61,18 @@ wakeup_code:
 
 	andb	$~X86_CR0_PE, %al
 	movl	%eax, %cr0
-	jmp	wakeup_jmp
+	LJMPW_RM(3f)
 3:
 	/* Set up segments */
 	movw	%cs, %ax
+	movw	%ax, %ss
+	movl	$rm_stack_end, %esp
 	movw	%ax, %ds
 	movw	%ax, %es
-	movw	%ax, %ss
-	lidtl	wakeup_idt
+	movw	%ax, %fs
+	movw	%ax, %gs
 
-	movl	$wakeup_stack_end, %esp
+	lidtl	wakeup_idt
 
 	/* Clear the EFLAGS */
 	pushl	$0
@@ -87,7 +85,7 @@ wakeup_code:
 
 	/* Check we really have everything... */
 	movl	end_signature, %eax
-	cmpl	$WAKEUP_END_SIGNATURE, %eax
+	cmpl	$REALMODE_END_SIGNATURE, %eax
 	jne	bogus_real_magic
 
 	/* Call the C code */
@@ -128,14 +126,13 @@ wakeup_code:
 	lgdtl	pmode_gdt
 
 	/* This really couldn't... */
-	movl	pmode_cr0, %eax
-	movl	%eax, %cr0
-	jmp	pmode_return
+	movl	pmode_entry, %eax
+	movl	pmode_cr0, %ecx
+	movl	%ecx, %cr0
+	ljmpl	$__KERNEL_CS, $pa_startup_32
+	/* -> jmp *%eax in trampoline_32.S */
 #else
-	pushw	$0
-	pushw	trampoline_segment
-	pushw	$0
-	lret
+	jmp	trampoline_start
 #endif
 
 bogus_real_magic:
@@ -143,28 +140,38 @@ bogus_real_magic:
 	hlt
 	jmp	1b
 
-	.data
+	.section ".rodata","a"
+
+	/*
+	 * Set up the wakeup GDT.  We set these up as Big Real Mode,
+	 * that is, with limits set to 4 GB.  At least the Lenovo
+	 * Thinkpad X61 is known to need this for the video BIOS
+	 * initialization quirk to work; this is likely to also
+	 * be the case for other laptops or integrated video devices.
+	 */
+
+	.balign	16
+GLOBAL(wakeup_gdt)
+	.word	3*8-1		/* Self-descriptor */
+	.long	pa_wakeup_gdt
+	.word	0
+
+	.word	0xffff		/* 16-bit code segment @ real_mode_base */
+	.long	0x9b000000 + pa_real_mode_base
+	.word	0x008f		/* big real mode */
+
+	.word	0xffff		/* 16-bit data segment @ real_mode_base */
+	.long	0x93000000 + pa_real_mode_base
+	.word	0x008f		/* big real mode */
+END(wakeup_gdt)
+
+	.section ".rodata","a"
 	.balign	8
 
 	/* This is the standard real-mode IDT */
-wakeup_idt:
+	.balign	16
+GLOBAL(wakeup_idt)
 	.word	0xffff		/* limit */
 	.long	0		/* address */
 	.word	0
-
-	.globl	HEAP, heap_end
-HEAP:
-	.long	wakeup_heap
-heap_end:
-	.long	wakeup_stack
-
-	.bss
-wakeup_heap:
-	.space	2048
-wakeup_stack:
-	.space	2048
-wakeup_stack_end:
-
-	.section ".signature","a"
-end_signature:
-	.long	WAKEUP_END_SIGNATURE
+END(wakeup_idt)
diff --git a/arch/x86/realmode/rmpiggy.S b/arch/x86/realmode/rmpiggy.S
new file mode 100644
index 0000000..204c6ec
--- /dev/null
+++ b/arch/x86/realmode/rmpiggy.S
@@ -0,0 +1,20 @@
+/*
+ * Wrapper script for the realmode binary as a transport object
+ * before copying to low memory.
+ */
+#include <linux/linkage.h>
+#include <asm/page_types.h>
+
+	.section ".init.data","aw"
+
+	.balign PAGE_SIZE
+
+GLOBAL(real_mode_blob)
+	.incbin	"arch/x86/realmode/rm/realmode.bin"
+END(real_mode_blob)
+
+GLOBAL(real_mode_blob_end);
+
+GLOBAL(real_mode_relocs)
+	.incbin	"arch/x86/realmode/rm/realmode.relocs"
+END(real_mode_relocs)
diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index b685296..5a1847d 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -78,6 +78,13 @@ static const char * const sym_regex_kernel[S_NSYMTYPES] = {
 
 static const char * const sym_regex_realmode[S_NSYMTYPES] = {
 /*
+ * These symbols are known to be relative, even if the linker marks them
+ * as absolute (typically defined outside any section in the linker script.)
+ */
+	[S_REL] =
+	"^pa_",
+
+/*
  * These are 16-bit segment symbols when compiling 16-bit code.
  */
 	[S_SEG] =
diff --git a/drivers/acpi/bgrt.c b/drivers/acpi/bgrt.c
index 8cf6c46..6680df3 100644
--- a/drivers/acpi/bgrt.c
+++ b/drivers/acpi/bgrt.c
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/sysfs.h>
+#include <linux/io.h>
 #include <acpi/acpi.h>
 #include <acpi/acpi_bus.h>
 
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index eb6fd23..0613900 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -25,6 +25,8 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
+#include <asm/realmode.h>
+
 #include "internal.h"
 #include "sleep.h"
 
@@ -91,13 +93,13 @@ static struct notifier_block tts_notifier = {
 static int acpi_sleep_prepare(u32 acpi_state)
 {
 #ifdef CONFIG_ACPI_SLEEP
+	unsigned long wakeup_pa = real_mode_header->wakeup_start;
 	/* do we have a wakeup address for S2 and S3? */
 	if (acpi_state == ACPI_STATE_S3) {
-		if (!acpi_wakeup_address) {
+		if (!wakeup_pa)
 			return -EFAULT;
-		}
 		acpi_set_firmware_waking_vector(
-				(acpi_physical_address)acpi_wakeup_address);
+				(acpi_physical_address)wakeup_pa);
 
 	}
 	ACPI_FLUSH_CPU_CACHE();
diff --git a/drivers/xen/xen-acpi-processor.c b/drivers/xen/xen-acpi-processor.c
index 0b48579..7ff2569 100644
--- a/drivers/xen/xen-acpi-processor.c
+++ b/drivers/xen/xen-acpi-processor.c
@@ -29,6 +29,7 @@
 #include <acpi/acpi_drivers.h>
 #include <acpi/processor.h>
 
+#include <xen/xen.h>
 #include <xen/interface/platform.h>
 #include <asm/xen/hypercall.h>
 
