Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab0IHSm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 14:42:59 -0400
Received: from king.tilera.com ([72.1.168.226]:43250 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158Ab0IHSmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 14:42:36 -0400
Message-Id: <201009081842.o88IgZ49028131@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 8 Sep 2010 13:50:10 -0400
Subject: [PATCH] arch/tile: Miscellaneous cleanups
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
X-OriginalArrivalTime: 08 Sep 2010 18:42:35.0524 (UTC) FILETIME=[9AB8D440:01CB4F85]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Use better "punctuation" for things like VMSPLIT_3_5G.
- Reserve more memory by default for vmalloc if collecting feedback data.
- Add a warning if we try to allocate too much vmalloc memory.
- Sync up some <arch> headers from "upstream".
- Fix memcpy_fromio()/memcpy_toio() to have better signatures.
- Remove a dead definition of bpt_code.
- Fix a formatting bug in register dumps.
- Comment fixups.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig            |   11 ++++++-----
 arch/tile/Makefile           |    2 --
 arch/tile/include/asm/io.h   |    8 ++++----
 arch/tile/kernel/intvec_32.S |    9 ++-------
 arch/tile/kernel/process.c   |    9 +++++----
 arch/tile/kernel/setup.c     |    4 ++++
 6 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 1eb308c..cd758e5 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -236,9 +236,9 @@ choice
 	  If you are not absolutely sure what you are doing, leave this
 	  option alone!
 
-	config VMSPLIT_375G
+	config VMSPLIT_3_75G
 		bool "3.75G/0.25G user/kernel split (no kernel networking)"
-	config VMSPLIT_35G
+	config VMSPLIT_3_5G
 		bool "3.5G/0.5G user/kernel split"
 	config VMSPLIT_3G
 		bool "3G/1G user/kernel split"
@@ -252,8 +252,8 @@ endchoice
 
 config PAGE_OFFSET
 	hex
-	default 0xF0000000 if VMSPLIT_375G
-	default 0xE0000000 if VMSPLIT_35G
+	default 0xF0000000 if VMSPLIT_3_75G
+	default 0xE0000000 if VMSPLIT_3_5G
 	default 0xB0000000 if VMSPLIT_3G_OPT
 	default 0x80000000 if VMSPLIT_2G
 	default 0x40000000 if VMSPLIT_1G
@@ -308,7 +308,8 @@ config CMDLINE_OVERRIDE
 
 config VMALLOC_RESERVE
 	hex
-	default 0x1000000
+	default 0x1000000 if !FEEDBACK_COLLECT
+	default 0x6000000 if FEEDBACK_COLLECT
 
 config HARDWALL
 	bool "Hardwall support to allow access to user dynamic network"
diff --git a/arch/tile/Makefile b/arch/tile/Makefile
index fd8f6bb..2af261f 100644
--- a/arch/tile/Makefile
+++ b/arch/tile/Makefile
@@ -26,7 +26,6 @@ $(error Set TILERA_ROOT or CROSS_COMPILE when building $(ARCH) on $(HOST_ARCH))
   endif
 endif
 
-
 KBUILD_CFLAGS   += $(CONFIG_DEBUG_EXTRA_FLAGS)
 
 LIBGCC_PATH     := $(shell $(CC) $(KBUILD_CFLAGS) -print-libgcc-file-name)
@@ -49,6 +48,5 @@ head-y		:= arch/tile/kernel/head_$(BITS).o
 libs-y		+= arch/tile/lib/
 libs-y		+= $(LIBGCC_PATH)
 
-
 # See arch/tile/Kbuild for content of core part of the kernel
 core-y		+= arch/tile/
diff --git a/arch/tile/include/asm/io.h b/arch/tile/include/asm/io.h
index 8c95bef..ee43328 100644
--- a/arch/tile/include/asm/io.h
+++ b/arch/tile/include/asm/io.h
@@ -164,22 +164,22 @@ static inline void _tile_writeq(u64 val, unsigned long addr)
 #define iowrite32 writel
 #define iowrite64 writeq
 
-static inline void *memcpy_fromio(void *dst, void *src, int len)
+static inline void memcpy_fromio(void *dst, const volatile void __iomem *src,
+				 size_t len)
 {
 	int x;
 	BUG_ON((unsigned long)src & 0x3);
 	for (x = 0; x < len; x += 4)
 		*(u32 *)(dst + x) = readl(src + x);
-	return dst;
 }
 
-static inline void *memcpy_toio(void *dst, void *src, int len)
+static inline void memcpy_toio(volatile void __iomem *dst, const void *src,
+				size_t len)
 {
 	int x;
 	BUG_ON((unsigned long)dst & 0x3);
 	for (x = 0; x < len; x += 4)
 		writel(*(u32 *)(src + x), dst + x);
-	return dst;
 }
 
 /*
diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
index 8818721..c62c2f4 100644
--- a/arch/tile/kernel/intvec_32.S
+++ b/arch/tile/kernel/intvec_32.S
@@ -1506,13 +1506,6 @@ handle_ill:
 	}
 	STD_ENDPROC(handle_ill)
 
-	.pushsection .rodata, "a"
-	.align  8
-bpt_code:
-	bpt
-	ENDPROC(bpt_code)
-	.popsection
-
 /* Various stub interrupt handlers and syscall handlers */
 
 STD_ENTRY_LOCAL(_kernel_double_fault)
@@ -1560,6 +1553,8 @@ STD_ENTRY(_sys_clone)
  * to be available to it on entry.  It does not modify any callee-save
  * registers (including "lr").  It does not check what PL it is being
  * called at, so you'd better not call it other than at PL0.
+ * The <atomic.h> wrapper assumes it only clobbers r20-r29, so if
+ * it ever is necessary to use more registers, be aware.
  *
  * It does not use the stack, but since it might be re-interrupted by
  * a page fault which would assume the stack was valid, it does
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index cd0ee34..8604820 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -214,9 +214,10 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	/*
 	 * Copy the callee-saved registers from the passed pt_regs struct
 	 * into the context-switch callee-saved registers area.
-	 * We have to restore the callee-saved registers since we may
-	 * be cloning a userspace task with userspace register state,
-	 * and we won't be unwinding the same kernel frames to restore them.
+	 * This way when we start the interrupt-return sequence, the
+	 * callee-save registers will be correctly in registers, which
+	 * is how we assume the compiler leaves them as we start doing
+	 * the normal return-from-interrupt path after calling C code.
 	 * Zero out the C ABI save area to mark the top of the stack.
 	 */
 	ksp = (unsigned long) childregs;
@@ -658,7 +659,7 @@ void show_regs(struct pt_regs *regs)
 	       regs->regs[51], regs->regs[52], regs->tp);
 	pr_err(" sp : "REGFMT" lr : "REGFMT"\n", regs->sp, regs->lr);
 #else
-	for (i = 0; i < 52; i += 3)
+	for (i = 0; i < 52; i += 4)
 		pr_err(" r%-2d: "REGFMT" r%-2d: "REGFMT
 		       " r%-2d: "REGFMT" r%-2d: "REGFMT"\n",
 		       i, regs->regs[i], i+1, regs->regs[i+1],
diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index e7d54c7..cef4fc1 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -1334,6 +1334,10 @@ static void __init pcpu_fc_populate_pte(unsigned long addr)
 	pte_t *pte;
 
 	BUG_ON(pgd_addr_invalid(addr));
+	if (addr < VMALLOC_START || addr >= VMALLOC_END)
+		panic("PCPU addr %#lx outside vmalloc range %#lx..%#lx;"
+		      " try increasing CONFIG_VMALLOC_SIZE\n",
+		      addr, VMALLOC_START, VMALLOC_END);
 
 	pgd = swapper_pg_dir + pgd_index(addr);
 	pud = pud_offset(pgd, addr);
-- 
1.6.5.2

