Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab0L0NeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 08:34:08 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42506 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab0L0NeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 08:34:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=kx+LRx6dD+3Gb86bI4dndZimRLOUJVST7xt42ZtiHTX/X9zzi9XW0nTYVytFEG3PGG
         TWM5VF3Ikt9LCFv4tqqinJLapl4fvOAdI0+jQ4/tTJ1qzfsMWME4WfUsfZKAg+bG2yry
         e1xo5i2EHZ5YlhlOUPlQ4u+1X4Pc1n+XqYYa8=
Date: Mon, 27 Dec 2010 14:34:00 +0100
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shaohua.li@intel.com>, Sam Ravnborg <sam@ravnborg.org>,
        lkml <linux-kernel@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, eric.dumazet@gmail.com,
        arch@vger.kernel.org
Subject: [PATCH percpu#for-next] percpu: align percpu readmostly subsection
 to cacheline
Message-ID: <20101227133400.GC488@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently percpu readmostly subsection may share cachelines with other
percpu subsections which may result in unnecessary cacheline bounce
and performance degradation.

This patch adds @cacheline parameter to PERCPU() and PERCPU_VADDR()
linker macros, makes each arch linker scripts specify its cacheline
size and use it to align percpu subsections.

This is based on Shaohua's x86 only patch.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Shaohua Li <shaohua.li@intel.com>
---
Shaohua, can you please verify this achieves the same result?  If no
one objects, I'll route it through the percpu tree.

Thanks.

 arch/alpha/kernel/vmlinux.lds.S    |    2 +-
 arch/arm/kernel/vmlinux.lds.S      |    2 +-
 arch/blackfin/kernel/vmlinux.lds.S |    2 +-
 arch/cris/kernel/vmlinux.lds.S     |    2 +-
 arch/frv/kernel/vmlinux.lds.S      |    2 +-
 arch/ia64/kernel/vmlinux.lds.S     |    2 +-
 arch/m32r/kernel/vmlinux.lds.S     |    2 +-
 arch/mips/kernel/vmlinux.lds.S     |    2 +-
 arch/mn10300/kernel/vmlinux.lds.S  |    2 +-
 arch/parisc/kernel/vmlinux.lds.S   |    2 +-
 arch/powerpc/kernel/vmlinux.lds.S  |    2 +-
 arch/s390/kernel/vmlinux.lds.S     |    2 +-
 arch/sh/kernel/vmlinux.lds.S       |    2 +-
 arch/sparc/kernel/vmlinux.lds.S    |    2 +-
 arch/tile/kernel/vmlinux.lds.S     |    2 +-
 arch/um/include/asm/common.lds.S   |    2 +-
 arch/x86/kernel/vmlinux.lds.S      |    4 ++--
 arch/xtensa/kernel/vmlinux.lds.S   |    2 +-
 include/asm-generic/vmlinux.lds.h  |   35 ++++++++++++++++++++++-------------
 19 files changed, 41 insertions(+), 32 deletions(-)

diff --git a/arch/alpha/kernel/vmlinux.lds.S b/arch/alpha/kernel/vmlinux.lds.S
index 003ef4c..173518f 100644
--- a/arch/alpha/kernel/vmlinux.lds.S
+++ b/arch/alpha/kernel/vmlinux.lds.S
@@ -38,7 +38,7 @@ SECTIONS
 	__init_begin = ALIGN(PAGE_SIZE);
 	INIT_TEXT_SECTION(PAGE_SIZE)
 	INIT_DATA_SECTION(16)
-	PERCPU(PAGE_SIZE)
+	PERCPU(64, PAGE_SIZE)
 	/* Align to THREAD_SIZE rather than PAGE_SIZE here so any padding page
 	   needed for the THREAD_SIZE aligned init_task gets freed after init */
 	. = ALIGN(THREAD_SIZE);
diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index cead889..67417d0 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -70,7 +70,7 @@ SECTIONS
 #endif
 	}
 
-	PERCPU(PAGE_SIZE)
+	PERCPU(32, PAGE_SIZE)
 
 #ifndef CONFIG_XIP_KERNEL
 	. = ALIGN(PAGE_SIZE);
diff --git a/arch/blackfin/kernel/vmlinux.lds.S b/arch/blackfin/kernel/vmlinux.lds.S
index 4122678..c40d07f 100644
--- a/arch/blackfin/kernel/vmlinux.lds.S
+++ b/arch/blackfin/kernel/vmlinux.lds.S
@@ -136,7 +136,7 @@ SECTIONS
 
 	. = ALIGN(16);
 	INIT_DATA_SECTION(16)
-	PERCPU(4)
+	PERCPU(32, 4)
 
 	.exit.data :
 	{
diff --git a/arch/cris/kernel/vmlinux.lds.S b/arch/cris/kernel/vmlinux.lds.S
index 4422189..c62e134 100644
--- a/arch/cris/kernel/vmlinux.lds.S
+++ b/arch/cris/kernel/vmlinux.lds.S
@@ -107,7 +107,7 @@ SECTIONS
 #endif
 	__vmlinux_end = .;		/* Last address of the physical file. */
 #ifdef CONFIG_ETRAX_ARCH_V32
-	PERCPU(PAGE_SIZE)
+	PERCPU(32, PAGE_SIZE)
 
 	.init.ramfs : {
 		INIT_RAM_FS
diff --git a/arch/frv/kernel/vmlinux.lds.S b/arch/frv/kernel/vmlinux.lds.S
index 8b973f3..0daae8a 100644
--- a/arch/frv/kernel/vmlinux.lds.S
+++ b/arch/frv/kernel/vmlinux.lds.S
@@ -37,7 +37,7 @@ SECTIONS
   _einittext = .;
 
   INIT_DATA_SECTION(8)
-  PERCPU(4096)
+  PERCPU(L1_CACHE_BYTES, 4096)
 
   . = ALIGN(PAGE_SIZE);
   __init_end = .;
diff --git a/arch/ia64/kernel/vmlinux.lds.S b/arch/ia64/kernel/vmlinux.lds.S
index 5a4d044..787de4a 100644
--- a/arch/ia64/kernel/vmlinux.lds.S
+++ b/arch/ia64/kernel/vmlinux.lds.S
@@ -198,7 +198,7 @@ SECTIONS {
 
 	/* Per-cpu data: */
 	. = ALIGN(PERCPU_PAGE_SIZE);
-	PERCPU_VADDR(PERCPU_ADDR, :percpu)
+	PERCPU_VADDR(SMP_CACHE_BYTES, PERCPU_ADDR, :percpu)
 	__phys_per_cpu_start = __per_cpu_load;
 	/*
 	 * ensure percpu data fits
diff --git a/arch/m32r/kernel/vmlinux.lds.S b/arch/m32r/kernel/vmlinux.lds.S
index 7da94ea..c194d64 100644
--- a/arch/m32r/kernel/vmlinux.lds.S
+++ b/arch/m32r/kernel/vmlinux.lds.S
@@ -53,7 +53,7 @@ SECTIONS
   __init_begin = .;
   INIT_TEXT_SECTION(PAGE_SIZE)
   INIT_DATA_SECTION(16)
-  PERCPU(PAGE_SIZE)
+  PERCPU(32, PAGE_SIZE)
   . = ALIGN(PAGE_SIZE);
   __init_end = .;
   /* freed after init ends here */
diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
index f25df73..fd5d045 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -108,7 +108,7 @@ SECTIONS
 		EXIT_DATA
 	}
 
-	PERCPU(PAGE_SIZE)
+	PERCPU(1 << CONFIG_MIPS_L1_CACHE_SHIFT, PAGE_SIZE)
 	. = ALIGN(PAGE_SIZE);
 	__init_end = .;
 	/* freed after init ends here */
diff --git a/arch/mn10300/kernel/vmlinux.lds.S b/arch/mn10300/kernel/vmlinux.lds.S
index febbeee..968bcd2 100644
--- a/arch/mn10300/kernel/vmlinux.lds.S
+++ b/arch/mn10300/kernel/vmlinux.lds.S
@@ -70,7 +70,7 @@ SECTIONS
 	.exit.text : { EXIT_TEXT; }
 	.exit.data : { EXIT_DATA; }
 
-  PERCPU(PAGE_SIZE)
+  PERCPU(32, PAGE_SIZE)
   . = ALIGN(PAGE_SIZE);
   __init_end = .;
   /* freed after init ends here */
diff --git a/arch/parisc/kernel/vmlinux.lds.S b/arch/parisc/kernel/vmlinux.lds.S
index d64a6bb..8f1e4ef 100644
--- a/arch/parisc/kernel/vmlinux.lds.S
+++ b/arch/parisc/kernel/vmlinux.lds.S
@@ -145,7 +145,7 @@ SECTIONS
 		EXIT_DATA
 	}
 
-	PERCPU(PAGE_SIZE)
+	PERCPU(L1_CACHE_BYTES, PAGE_SIZE)
 	. = ALIGN(PAGE_SIZE);
 	__init_end = .;
 	/* freed after init ends here */
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 8a0deef..b9150f0 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -160,7 +160,7 @@ SECTIONS
 		INIT_RAM_FS
 	}
 
-	PERCPU(PAGE_SIZE)
+	PERCPU(L1_CACHE_BYTES, PAGE_SIZE)
 
 	. = ALIGN(8);
 	.machine.desc : AT(ADDR(.machine.desc) - LOAD_OFFSET) {
diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index a68ac10..1bc18cd 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -77,7 +77,7 @@ SECTIONS
 	. = ALIGN(PAGE_SIZE);
 	INIT_DATA_SECTION(0x100)
 
-	PERCPU(PAGE_SIZE)
+	PERCPU(0x100, PAGE_SIZE)
 	. = ALIGN(PAGE_SIZE);
 	__init_end = .;		/* freed after init ends here */
 
diff --git a/arch/sh/kernel/vmlinux.lds.S b/arch/sh/kernel/vmlinux.lds.S
index 7f8a709..af4d461 100644
--- a/arch/sh/kernel/vmlinux.lds.S
+++ b/arch/sh/kernel/vmlinux.lds.S
@@ -66,7 +66,7 @@ SECTIONS
 		__machvec_end = .;
 	}
 
-	PERCPU(PAGE_SIZE)
+	PERCPU(L1_CACHE_BYTES, PAGE_SIZE)
 
 	/*
 	 * .exit.text is discarded at runtime, not link time, to deal with
diff --git a/arch/sparc/kernel/vmlinux.lds.S b/arch/sparc/kernel/vmlinux.lds.S
index 0c1e678..92b557a 100644
--- a/arch/sparc/kernel/vmlinux.lds.S
+++ b/arch/sparc/kernel/vmlinux.lds.S
@@ -108,7 +108,7 @@ SECTIONS
 		__sun4v_2insn_patch_end = .;
 	}
 
-	PERCPU(PAGE_SIZE)
+	PERCPU(SMP_CACHE_BYTES, PAGE_SIZE)
 
 	. = ALIGN(PAGE_SIZE);
 	__init_end = .;
diff --git a/arch/tile/kernel/vmlinux.lds.S b/arch/tile/kernel/vmlinux.lds.S
index 25fdc0c..c6ce378 100644
--- a/arch/tile/kernel/vmlinux.lds.S
+++ b/arch/tile/kernel/vmlinux.lds.S
@@ -63,7 +63,7 @@ SECTIONS
     *(.init.page)
   } :data =0
   INIT_DATA_SECTION(16)
-  PERCPU(PAGE_SIZE)
+  PERCPU(L2_CACHE_BYTES, PAGE_SIZE)
   . = ALIGN(PAGE_SIZE);
   VMLINUX_SYMBOL(_einitdata) = .;
 
diff --git a/arch/um/include/asm/common.lds.S b/arch/um/include/asm/common.lds.S
index ac55b9e..34bede8 100644
--- a/arch/um/include/asm/common.lds.S
+++ b/arch/um/include/asm/common.lds.S
@@ -42,7 +42,7 @@
 	INIT_SETUP(0)
   }
 
-  PERCPU(32)
+  PERCPU(32, 32)
 	
   .initcall.init : {
 	INIT_CALLS
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index e03530a..68cf1c0 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -226,7 +226,7 @@ SECTIONS
 	 * output PHDR, so the next output section - .init.text - should
 	 * start another segment - init.
 	 */
-	PERCPU_VADDR(0, :percpu)
+	PERCPU_VADDR(INTERNODE_CACHE_BYTES, 0, :percpu)
 #endif
 
 	INIT_TEXT_SECTION(PAGE_SIZE)
@@ -301,7 +301,7 @@ SECTIONS
 	}
 
 #if !defined(CONFIG_X86_64) || !defined(CONFIG_SMP)
-	PERCPU(THREAD_SIZE)
+	PERCPU(INTERNODE_CACHE_BYTES, THREAD_SIZE)
 #endif
 
 	. = ALIGN(PAGE_SIZE);
diff --git a/arch/xtensa/kernel/vmlinux.lds.S b/arch/xtensa/kernel/vmlinux.lds.S
index 9b52615..a282006 100644
--- a/arch/xtensa/kernel/vmlinux.lds.S
+++ b/arch/xtensa/kernel/vmlinux.lds.S
@@ -155,7 +155,7 @@ SECTIONS
     INIT_RAM_FS
   }
 
-  PERCPU(PAGE_SIZE)
+  PERCPU(XCHAL_ICACHE_LINESIZE, PAGE_SIZE)
 
   /* We need this dummy segment here */
 
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index bd69d79..aa1339e 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -15,7 +15,7 @@
  *	HEAD_TEXT_SECTION
  *	INIT_TEXT_SECTION(PAGE_SIZE)
  *	INIT_DATA_SECTION(...)
- *	PERCPU(PAGE_SIZE)
+ *	PERCPU(CACHELINE_SIZE, PAGE_SIZE)
  *	__init_end = .;
  *
  *	_stext = .;
@@ -666,13 +666,18 @@
 
 /**
  * PERCPU_VADDR - define output section for percpu area
+ * @cacheline: cacheline size
  * @vaddr: explicit base address (optional)
  * @phdr: destination PHDR (optional)
  *
- * Macro which expands to output section for percpu area.  If @vaddr
- * is not blank, it specifies explicit base address and all percpu
- * symbols will be offset from the given address.  If blank, @vaddr
- * always equals @laddr + LOAD_OFFSET.
+ * Macro which expands to output section for percpu area.
+ *
+ * @cacheline is used to align subsections to avoid false cacheline
+ * sharing between subsections for different purposes.
+ *
+ * If @vaddr is not blank, it specifies explicit base address and all
+ * percpu symbols will be offset from the given address.  If blank,
+ * @vaddr always equals @laddr + LOAD_OFFSET.
  *
  * @phdr defines the output PHDR to use if not blank.  Be warned that
  * output PHDR is sticky.  If @phdr is specified, the next output
@@ -683,7 +688,7 @@
  * If there is no need to put the percpu section at a predetermined
  * address, use PERCPU().
  */
-#define PERCPU_VADDR(vaddr, phdr)					\
+#define PERCPU_VADDR(cacheline, vaddr, phdr)				\
 	VMLINUX_SYMBOL(__per_cpu_load) = .;				\
 	.data..percpu vaddr : AT(VMLINUX_SYMBOL(__per_cpu_load)		\
 				- LOAD_OFFSET) {			\
@@ -691,7 +696,9 @@
 		*(.data..percpu..first)					\
 		. = ALIGN(PAGE_SIZE);					\
 		*(.data..percpu..page_aligned)				\
+		. = ALIGN(cacheline);					\
 		*(.data..percpu..readmostly)				\
+		. = ALIGN(cacheline);					\
 		*(.data..percpu)					\
 		*(.data..percpu..shared_aligned)			\
 		VMLINUX_SYMBOL(__per_cpu_end) = .;			\
@@ -700,18 +707,18 @@
 
 /**
  * PERCPU - define output section for percpu area, simple version
+ * @cacheline: cacheline size
  * @align: required alignment
  *
- * Align to @align and outputs output section for percpu area.  This
- * macro doesn't maniuplate @vaddr or @phdr and __per_cpu_load and
+ * Align to @align and outputs output section for percpu area.  This macro
+ * doesn't manipulate @vaddr or @phdr and __per_cpu_load and
  * __per_cpu_start will be identical.
  *
- * This macro is equivalent to ALIGN(align); PERCPU_VADDR( , ) except
- * that __per_cpu_load is defined as a relative symbol against
- * .data..percpu which is required for relocatable x86_32
- * configuration.
+ * This macro is equivalent to ALIGN(@align); PERCPU_VADDR(@cacheline,,)
+ * except that __per_cpu_load is defined as a relative symbol against
+ * .data..percpu which is required for relocatable x86_32 configuration.
  */
-#define PERCPU(align)							\
+#define PERCPU(cacheline, align)					\
 	. = ALIGN(align);						\
 	.data..percpu	: AT(ADDR(.data..percpu) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__per_cpu_load) = .;			\
@@ -719,7 +726,9 @@
 		*(.data..percpu..first)					\
 		. = ALIGN(PAGE_SIZE);					\
 		*(.data..percpu..page_aligned)				\
+		. = ALIGN(cacheline);					\
 		*(.data..percpu..readmostly)				\
+		. = ALIGN(cacheline);					\
 		*(.data..percpu)					\
 		*(.data..percpu..shared_aligned)			\
 		VMLINUX_SYMBOL(__per_cpu_end) = .;			\
