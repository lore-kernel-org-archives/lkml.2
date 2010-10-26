Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab0JZOIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:08:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:34758 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab0JZOIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 10:08:16 -0400
Message-ID: <4CC6E05A.8040508@kernel.org>
Date: Tue, 26 Oct 2010 16:06:18 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: torvalds@osdl.org, Alexander van Heukelum <heukelum@fastmail.fm>
CC: David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
        linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Mark Salter <msalter@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org, Jeff Dike <jdike@addtoit.com>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: [RFC PATCH] percpu: always align percpu output section to PAGE_SIZE
References: <4CC69B22.2050708@kernel.org> <20101025224111.7798.38960.stgit@warthog.procyon.org.uk> <12101.1288088542@redhat.com> <4CC6C62F.1000804@kernel.org> <4CC6C941.2080003@kernel.org> <4CC6CD4D.3010501@kernel.org>
In-Reply-To: <4CC6CD4D.3010501@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Oct 2010 14:06:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Percpu allocator honors alignment request upto PAGE_SIZE and both the
percpu addresses in the percpu address space and the translated kernel
addresses should be aligned accordingly.  The calculation of the
former depends on the alignment of percpu output section in the kernel
image.

The linker script macros PERCPU_VADDR() and PERCPU() are used to
define this output section and the latter takes @align parameter.
Several architectures are using @align smaller than PAGE_SIZE breaking
percpu memory alignment.

This patch removes @align parameter from PERCPU(), renames it to
PERCPU_SECTION and makes it always align to PAGE_SIZE.  While at it,
add PCPU_SETUP_BUG_ON() checks such that alignment problems are
reliably detected and remove percpu alignment comment recently added
in workqueue.c as the condition would trigger BUG way before reaching
there.

For blackfin, frv and um, this patch raises the alignment of percpu
area.  As the area is in .init, there shouldn't be any noticeable
difference.

This problem was discovered by David Howells while debugging boot
failure on mn10300.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org
Cc: David Howells <dhowells@redhat.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: user-mode-linux-devel@lists.sourceforge.net
---
Linus, please don't apply the previous revert and this patch yet.
Ingo, with mn10300 fixed, I don't think these patches are urgent.
I'll hold onto revert patch and this one for now and push them to
Linus after irqstacks is fixed on x86_32.

Thanks.

 arch/alpha/kernel/vmlinux.lds.S    |    2 +-
 arch/arm/kernel/vmlinux.lds.S      |    2 +-
 arch/blackfin/kernel/vmlinux.lds.S |    2 +-
 arch/cris/kernel/vmlinux.lds.S     |    2 +-
 arch/frv/kernel/vmlinux.lds.S      |    2 +-
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
 arch/x86/kernel/vmlinux.lds.S      |    2 +-
 arch/xtensa/kernel/vmlinux.lds.S   |    2 +-
 include/asm-generic/vmlinux.lds.h  |   19 +++++++++----------
 kernel/workqueue.c                 |    4 +---
 mm/percpu.c                        |    2 ++
 20 files changed, 29 insertions(+), 30 deletions(-)

diff --git a/arch/alpha/kernel/vmlinux.lds.S b/arch/alpha/kernel/vmlinux.lds.S
index 003ef4c..92d6d88 100644
--- a/arch/alpha/kernel/vmlinux.lds.S
+++ b/arch/alpha/kernel/vmlinux.lds.S
@@ -38,7 +38,7 @@ SECTIONS
 	__init_begin = ALIGN(PAGE_SIZE);
 	INIT_TEXT_SECTION(PAGE_SIZE)
 	INIT_DATA_SECTION(16)
-	PERCPU(PAGE_SIZE)
+	PERCPU_SECTION
 	/* Align to THREAD_SIZE rather than PAGE_SIZE here so any padding page
 	   needed for the THREAD_SIZE aligned init_task gets freed after init */
 	. = ALIGN(THREAD_SIZE);
diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index 1953e3d..092d83a 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -70,7 +70,7 @@ SECTIONS
 #endif
 	}

-	PERCPU(PAGE_SIZE)
+	PERCPU_SECTION

 #ifndef CONFIG_XIP_KERNEL
 	. = ALIGN(PAGE_SIZE);
diff --git a/arch/blackfin/kernel/vmlinux.lds.S b/arch/blackfin/kernel/vmlinux.lds.S
index 4122678..d188a7e 100644
--- a/arch/blackfin/kernel/vmlinux.lds.S
+++ b/arch/blackfin/kernel/vmlinux.lds.S
@@ -136,7 +136,7 @@ SECTIONS

 	. = ALIGN(16);
 	INIT_DATA_SECTION(16)
-	PERCPU(4)
+	PERCPU_SECTION

 	.exit.data :
 	{
diff --git a/arch/cris/kernel/vmlinux.lds.S b/arch/cris/kernel/vmlinux.lds.S
index 4422189..cbdc41d 100644
--- a/arch/cris/kernel/vmlinux.lds.S
+++ b/arch/cris/kernel/vmlinux.lds.S
@@ -107,7 +107,7 @@ SECTIONS
 #endif
 	__vmlinux_end = .;		/* Last address of the physical file. */
 #ifdef CONFIG_ETRAX_ARCH_V32
-	PERCPU(PAGE_SIZE)
+	PERCPU_SECTION

 	.init.ramfs : {
 		INIT_RAM_FS
diff --git a/arch/frv/kernel/vmlinux.lds.S b/arch/frv/kernel/vmlinux.lds.S
index 8b973f3..43e59e6 100644
--- a/arch/frv/kernel/vmlinux.lds.S
+++ b/arch/frv/kernel/vmlinux.lds.S
@@ -37,7 +37,7 @@ SECTIONS
   _einittext = .;

   INIT_DATA_SECTION(8)
-  PERCPU(4096)
+  PERCPU_SECTION

   . = ALIGN(PAGE_SIZE);
   __init_end = .;
diff --git a/arch/m32r/kernel/vmlinux.lds.S b/arch/m32r/kernel/vmlinux.lds.S
index 7da94ea..a676ecb 100644
--- a/arch/m32r/kernel/vmlinux.lds.S
+++ b/arch/m32r/kernel/vmlinux.lds.S
@@ -53,7 +53,7 @@ SECTIONS
   __init_begin = .;
   INIT_TEXT_SECTION(PAGE_SIZE)
   INIT_DATA_SECTION(16)
-  PERCPU(PAGE_SIZE)
+  PERCPU_SECTION
   . = ALIGN(PAGE_SIZE);
   __init_end = .;
   /* freed after init ends here */
diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
index f25df73..6fcf586 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -108,7 +108,7 @@ SECTIONS
 		EXIT_DATA
 	}

-	PERCPU(PAGE_SIZE)
+	PERCPU_SECTION
 	. = ALIGN(PAGE_SIZE);
 	__init_end = .;
 	/* freed after init ends here */
diff --git a/arch/mn10300/kernel/vmlinux.lds.S b/arch/mn10300/kernel/vmlinux.lds.S
index febbeee..2e7ecf9 100644
--- a/arch/mn10300/kernel/vmlinux.lds.S
+++ b/arch/mn10300/kernel/vmlinux.lds.S
@@ -70,7 +70,7 @@ SECTIONS
 	.exit.text : { EXIT_TEXT; }
 	.exit.data : { EXIT_DATA; }

-  PERCPU(PAGE_SIZE)
+  PERCPU_SECTION
   . = ALIGN(PAGE_SIZE);
   __init_end = .;
   /* freed after init ends here */
diff --git a/arch/parisc/kernel/vmlinux.lds.S b/arch/parisc/kernel/vmlinux.lds.S
index d64a6bb..8573902 100644
--- a/arch/parisc/kernel/vmlinux.lds.S
+++ b/arch/parisc/kernel/vmlinux.lds.S
@@ -145,7 +145,7 @@ SECTIONS
 		EXIT_DATA
 	}

-	PERCPU(PAGE_SIZE)
+	PERCPU_SECTION
 	. = ALIGN(PAGE_SIZE);
 	__init_end = .;
 	/* freed after init ends here */
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 8a0deef..e17d0b6 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -160,7 +160,7 @@ SECTIONS
 		INIT_RAM_FS
 	}

-	PERCPU(PAGE_SIZE)
+	PERCPU_SECTION

 	. = ALIGN(8);
 	.machine.desc : AT(ADDR(.machine.desc) - LOAD_OFFSET) {
diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index a68ac10..b7f26f8 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -77,7 +77,7 @@ SECTIONS
 	. = ALIGN(PAGE_SIZE);
 	INIT_DATA_SECTION(0x100)

-	PERCPU(PAGE_SIZE)
+	PERCPU_SECTION
 	. = ALIGN(PAGE_SIZE);
 	__init_end = .;		/* freed after init ends here */

diff --git a/arch/sh/kernel/vmlinux.lds.S b/arch/sh/kernel/vmlinux.lds.S
index 7f8a709..f08347a 100644
--- a/arch/sh/kernel/vmlinux.lds.S
+++ b/arch/sh/kernel/vmlinux.lds.S
@@ -66,7 +66,7 @@ SECTIONS
 		__machvec_end = .;
 	}

-	PERCPU(PAGE_SIZE)
+	PERCPU_SECTION

 	/*
 	 * .exit.text is discarded at runtime, not link time, to deal with
diff --git a/arch/sparc/kernel/vmlinux.lds.S b/arch/sparc/kernel/vmlinux.lds.S
index 0c1e678..c1ea7c4 100644
--- a/arch/sparc/kernel/vmlinux.lds.S
+++ b/arch/sparc/kernel/vmlinux.lds.S
@@ -108,7 +108,7 @@ SECTIONS
 		__sun4v_2insn_patch_end = .;
 	}

-	PERCPU(PAGE_SIZE)
+	PERCPU_SECTION

 	. = ALIGN(PAGE_SIZE);
 	__init_end = .;
diff --git a/arch/tile/kernel/vmlinux.lds.S b/arch/tile/kernel/vmlinux.lds.S
index 25fdc0c..adb8168 100644
--- a/arch/tile/kernel/vmlinux.lds.S
+++ b/arch/tile/kernel/vmlinux.lds.S
@@ -63,7 +63,7 @@ SECTIONS
     *(.init.page)
   } :data =0
   INIT_DATA_SECTION(16)
-  PERCPU(PAGE_SIZE)
+  PERCPU_SECTION
   . = ALIGN(PAGE_SIZE);
   VMLINUX_SYMBOL(_einitdata) = .;

diff --git a/arch/um/include/asm/common.lds.S b/arch/um/include/asm/common.lds.S
index ac55b9e..e8bfd8a 100644
--- a/arch/um/include/asm/common.lds.S
+++ b/arch/um/include/asm/common.lds.S
@@ -42,7 +42,7 @@
 	INIT_SETUP(0)
   }

-  PERCPU(32)
+  PERCPU_SECTION
 	
   .initcall.init : {
 	INIT_CALLS
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 38e2b67..6cfd560 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -301,7 +301,7 @@ SECTIONS
 	}

 #if !defined(CONFIG_X86_64) || !defined(CONFIG_SMP)
-	PERCPU(PAGE_SIZE)
+	PERCPU_SECTION
 #endif

 	. = ALIGN(PAGE_SIZE);
diff --git a/arch/xtensa/kernel/vmlinux.lds.S b/arch/xtensa/kernel/vmlinux.lds.S
index 9b52615..2520ac8 100644
--- a/arch/xtensa/kernel/vmlinux.lds.S
+++ b/arch/xtensa/kernel/vmlinux.lds.S
@@ -155,7 +155,7 @@ SECTIONS
     INIT_RAM_FS
   }

-  PERCPU(PAGE_SIZE)
+  PERCPU_SECTION

   /* We need this dummy segment here */

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index f4229fb..f708bdd 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -15,7 +15,7 @@
  *	HEAD_TEXT_SECTION
  *	INIT_TEXT_SECTION(PAGE_SIZE)
  *	INIT_DATA_SECTION(...)
- *	PERCPU(PAGE_SIZE)
+ *	PERCPU_SECTION
  *	__init_end = .;
  *
  *	_stext = .;
@@ -679,7 +679,7 @@
  *
  * Note that this macros defines __per_cpu_load as an absolute symbol.
  * If there is no need to put the percpu section at a predetermined
- * address, use PERCPU().
+ * address, use PERCPU_SECTION.
  */
 #define PERCPU_VADDR(vaddr, phdr)					\
 	VMLINUX_SYMBOL(__per_cpu_load) = .;				\
@@ -697,20 +697,19 @@
 	. = VMLINUX_SYMBOL(__per_cpu_load) + SIZEOF(.data..percpu);

 /**
- * PERCPU - define output section for percpu area, simple version
- * @align: required alignment
+ * PERCPU_SECTION - define output section for percpu area, simple version
  *
- * Align to @align and outputs output section for percpu area.  This
- * macro doesn't maniuplate @vaddr or @phdr and __per_cpu_load and
+ * Align to PAGE_SIZE and output section for percpu area.  This macro
+ * doesn't manipulate @vaddr or @phdr and __per_cpu_load and
  * __per_cpu_start will be identical.
  *
- * This macro is equivalent to ALIGN(align); PERCPU_VADDR( , ) except
- * that __per_cpu_load is defined as a relative symbol against
+ * This macro is equivalent to ALIGN(PAGE_SIZE); PERCPU_VADDR( , )
+ * except that __per_cpu_load is defined as a relative symbol against
  * .data..percpu which is required for relocatable x86_32
  * configuration.
  */
-#define PERCPU(align)							\
-	. = ALIGN(align);						\
+#define PERCPU_SECTION							\
+	. = ALIGN(PAGE_SIZE);						\
 	.data..percpu	: AT(ADDR(.data..percpu) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__per_cpu_load) = .;			\
 		VMLINUX_SYMBOL(__per_cpu_start) = .;			\
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e5ff2cb..30acdb7 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2791,9 +2791,7 @@ static int alloc_cwqs(struct workqueue_struct *wq)
 		}
 	}

-	/* just in case, make sure it's actually aligned
-	 * - this is affected by PERCPU() alignment in vmlinux.lds.S
-	 */
+	/* just in case, make sure it's actually aligned */
 	BUG_ON(!IS_ALIGNED(wq->cpu_wq.v, align));
 	return wq->cpu_wq.v ? 0 : -ENOMEM;
 }
diff --git a/mm/percpu.c b/mm/percpu.c
index efe8168..1aa65d3 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1220,8 +1220,10 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	PCPU_SETUP_BUG_ON(ai->nr_groups <= 0);
 #ifdef CONFIG_SMP
 	PCPU_SETUP_BUG_ON(!ai->static_size);
+	PCPU_SETUP_BUG_ON((unsigned long)__per_cpu_start & ~PAGE_MASK);
 #endif
 	PCPU_SETUP_BUG_ON(!base_addr);
+	PCPU_SETUP_BUG_ON((unsigned long)base_addr & ~PAGE_MASK);
 	PCPU_SETUP_BUG_ON(ai->unit_size < size_sum);
 	PCPU_SETUP_BUG_ON(ai->unit_size & ~PAGE_MASK);
 	PCPU_SETUP_BUG_ON(ai->unit_size < PCPU_MIN_UNIT_SIZE);
