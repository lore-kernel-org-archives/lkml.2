Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933754Ab1CXIyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 04:54:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63835 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933058Ab1CXIyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 04:54:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=noTtJpTQKzReht0s5M/4kOjAlEQJYwQRKO7WCc9H7I2JLMlAtED9vf5UAaznfDOSww
         LPbHBagVInNFOw7JJeHDSnSKQG13MOTKLQHJxjxDZOLj9W5OPowlq3/CsUxQDnkXGo3J
         D4ApYNUO/+2iv/lpyOTt0b2q9XXE3Ep0AEL1Q=
Date: Thu, 24 Mar 2011 09:54:26 +0100
From: Tejun Heo <tj@kernel.org>
To: torvalds@osdl.org, Alexander van Heukelum <heukelum@fastmail.fm>
Cc: David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
        linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Mark Salter <msalter@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org, Jeff Dike <jdike@addtoit.com>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH UPDATED] percpu: always align percpu output section to
 PAGE_SIZE
Message-ID: <20110324085426.GC12038@htj.dyndns.org>
References: <4CC69B22.2050708@kernel.org>
 <20101025224111.7798.38960.stgit@warthog.procyon.org.uk>
 <12101.1288088542@redhat.com>
 <4CC6C62F.1000804@kernel.org>
 <4CC6C941.2080003@kernel.org>
 <4CC6CD4D.3010501@kernel.org>
 <4CC6E05A.8040508@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC6E05A.8040508@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
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
PERCPU_SECTION() and makes it always align to PAGE_SIZE.  While at it,
add PCPU_SETUP_BUG_ON() checks such that alignment problems are
reliably detected and remove percpu alignment comment recently added
in workqueue.c as the condition would trigger BUG way before reaching
there.

For um, this patch raises the alignment of percpu area.  As the area
is in .init, there shouldn't be any noticeable difference.

This problem was discovered by David Howells while debugging boot
failure on mn10300.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org
Cc: David Howells <dhowells@redhat.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: user-mode-linux-devel@lists.sourceforge.net
---
I'll apply this to percpu:for-2.6.40 once the blackfin fix hits
mainline.

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
 include/asm-generic/vmlinux.lds.h  |   17 ++++++++---------
 kernel/workqueue.c                 |    4 +---
 mm/percpu.c                        |    2 ++
 20 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/arch/alpha/kernel/vmlinux.lds.S b/arch/alpha/kernel/vmlinux.lds.S
index 433be2a..8d57948 100644
--- a/arch/alpha/kernel/vmlinux.lds.S
+++ b/arch/alpha/kernel/vmlinux.lds.S
@@ -39,7 +39,7 @@ SECTIONS
 	__init_begin = ALIGN(PAGE_SIZE);
 	INIT_TEXT_SECTION(PAGE_SIZE)
 	INIT_DATA_SECTION(16)
-	PERCPU(L1_CACHE_BYTES, PAGE_SIZE)
+	PERCPU_SECTION(L1_CACHE_BYTES)
 	/* Align to THREAD_SIZE rather than PAGE_SIZE here so any padding page
 	   needed for the THREAD_SIZE aligned init_task gets freed after init */
 	. = ALIGN(THREAD_SIZE);
diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index 28fea9b..62d0768 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -78,7 +78,7 @@ SECTIONS
 #endif
 	}
 
-	PERCPU(32, PAGE_SIZE)
+	PERCPU_SECTION(32)
 
 #ifndef CONFIG_XIP_KERNEL
 	. = ALIGN(PAGE_SIZE);
diff --git a/arch/blackfin/kernel/vmlinux.lds.S b/arch/blackfin/kernel/vmlinux.lds.S
index c40d07f..7c51016 100644
--- a/arch/blackfin/kernel/vmlinux.lds.S
+++ b/arch/blackfin/kernel/vmlinux.lds.S
@@ -136,7 +136,7 @@ SECTIONS
 
 	. = ALIGN(16);
 	INIT_DATA_SECTION(16)
-	PERCPU(32, 4)
+	PERCPU_SECTION(32)
 
 	.exit.data :
 	{
diff --git a/arch/cris/kernel/vmlinux.lds.S b/arch/cris/kernel/vmlinux.lds.S
index 728bbd9..a6990cb 100644
--- a/arch/cris/kernel/vmlinux.lds.S
+++ b/arch/cris/kernel/vmlinux.lds.S
@@ -102,7 +102,7 @@ SECTIONS
 #endif
 	__vmlinux_end = .;		/* Last address of the physical file. */
 #ifdef CONFIG_ETRAX_ARCH_V32
-	PERCPU(32, PAGE_SIZE)
+	PERCPU_SECTION(32)
 
 	.init.ramfs : {
 		INIT_RAM_FS
diff --git a/arch/frv/kernel/vmlinux.lds.S b/arch/frv/kernel/vmlinux.lds.S
index 0daae8a..7e958d8 100644
--- a/arch/frv/kernel/vmlinux.lds.S
+++ b/arch/frv/kernel/vmlinux.lds.S
@@ -37,7 +37,7 @@ SECTIONS
   _einittext = .;
 
   INIT_DATA_SECTION(8)
-  PERCPU(L1_CACHE_BYTES, 4096)
+  PERCPU_SECTION(L1_CACHE_BYTES)
 
   . = ALIGN(PAGE_SIZE);
   __init_end = .;
diff --git a/arch/m32r/kernel/vmlinux.lds.S b/arch/m32r/kernel/vmlinux.lds.S
index c194d64..2e7ccf7 100644
--- a/arch/m32r/kernel/vmlinux.lds.S
+++ b/arch/m32r/kernel/vmlinux.lds.S
@@ -53,7 +53,7 @@ SECTIONS
   __init_begin = .;
   INIT_TEXT_SECTION(PAGE_SIZE)
   INIT_DATA_SECTION(16)
-  PERCPU(32, PAGE_SIZE)
+  PERCPU_SECTION(32)
   . = ALIGN(PAGE_SIZE);
   __init_end = .;
   /* freed after init ends here */
diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
index 832afbb..8616709 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -115,7 +115,7 @@ SECTIONS
 		EXIT_DATA
 	}
 
-	PERCPU(1 << CONFIG_MIPS_L1_CACHE_SHIFT, PAGE_SIZE)
+	PERCPU_SECTION(1 << CONFIG_MIPS_L1_CACHE_SHIFT)
 	. = ALIGN(PAGE_SIZE);
 	__init_end = .;
 	/* freed after init ends here */
diff --git a/arch/mn10300/kernel/vmlinux.lds.S b/arch/mn10300/kernel/vmlinux.lds.S
index 968bcd2..6f702a6 100644
--- a/arch/mn10300/kernel/vmlinux.lds.S
+++ b/arch/mn10300/kernel/vmlinux.lds.S
@@ -70,7 +70,7 @@ SECTIONS
 	.exit.text : { EXIT_TEXT; }
 	.exit.data : { EXIT_DATA; }
 
-  PERCPU(32, PAGE_SIZE)
+  PERCPU_SECTION(32)
   . = ALIGN(PAGE_SIZE);
   __init_end = .;
   /* freed after init ends here */
diff --git a/arch/parisc/kernel/vmlinux.lds.S b/arch/parisc/kernel/vmlinux.lds.S
index 8f1e4ef..85b8661 100644
--- a/arch/parisc/kernel/vmlinux.lds.S
+++ b/arch/parisc/kernel/vmlinux.lds.S
@@ -145,7 +145,7 @@ SECTIONS
 		EXIT_DATA
 	}
 
-	PERCPU(L1_CACHE_BYTES, PAGE_SIZE)
+	PERCPU_SECTION(L1_CACHE_BYTES)
 	. = ALIGN(PAGE_SIZE);
 	__init_end = .;
 	/* freed after init ends here */
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index b9150f0..920276c 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -160,7 +160,7 @@ SECTIONS
 		INIT_RAM_FS
 	}
 
-	PERCPU(L1_CACHE_BYTES, PAGE_SIZE)
+	PERCPU_SECTION(L1_CACHE_BYTES)
 
 	. = ALIGN(8);
 	.machine.desc : AT(ADDR(.machine.desc) - LOAD_OFFSET) {
diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index 1bc18cd..56fe6bc 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -77,7 +77,7 @@ SECTIONS
 	. = ALIGN(PAGE_SIZE);
 	INIT_DATA_SECTION(0x100)
 
-	PERCPU(0x100, PAGE_SIZE)
+	PERCPU_SECTION(0x100)
 	. = ALIGN(PAGE_SIZE);
 	__init_end = .;		/* freed after init ends here */
 
diff --git a/arch/sh/kernel/vmlinux.lds.S b/arch/sh/kernel/vmlinux.lds.S
index af4d461..731c10c 100644
--- a/arch/sh/kernel/vmlinux.lds.S
+++ b/arch/sh/kernel/vmlinux.lds.S
@@ -66,7 +66,7 @@ SECTIONS
 		__machvec_end = .;
 	}
 
-	PERCPU(L1_CACHE_BYTES, PAGE_SIZE)
+	PERCPU_SECTION(L1_CACHE_BYTES)
 
 	/*
 	 * .exit.text is discarded at runtime, not link time, to deal with
diff --git a/arch/sparc/kernel/vmlinux.lds.S b/arch/sparc/kernel/vmlinux.lds.S
index 92b557a..c022075 100644
--- a/arch/sparc/kernel/vmlinux.lds.S
+++ b/arch/sparc/kernel/vmlinux.lds.S
@@ -108,7 +108,7 @@ SECTIONS
 		__sun4v_2insn_patch_end = .;
 	}
 
-	PERCPU(SMP_CACHE_BYTES, PAGE_SIZE)
+	PERCPU_SECTION(SMP_CACHE_BYTES)
 
 	. = ALIGN(PAGE_SIZE);
 	__init_end = .;
diff --git a/arch/tile/kernel/vmlinux.lds.S b/arch/tile/kernel/vmlinux.lds.S
index c6ce378..c2feb64 100644
--- a/arch/tile/kernel/vmlinux.lds.S
+++ b/arch/tile/kernel/vmlinux.lds.S
@@ -63,7 +63,7 @@ SECTIONS
     *(.init.page)
   } :data =0
   INIT_DATA_SECTION(16)
-  PERCPU(L2_CACHE_BYTES, PAGE_SIZE)
+  PERCPU_SECTION(L2_CACHE_BYTES)
   . = ALIGN(PAGE_SIZE);
   VMLINUX_SYMBOL(_einitdata) = .;
 
diff --git a/arch/um/include/asm/common.lds.S b/arch/um/include/asm/common.lds.S
index 34bede8..4938de5 100644
--- a/arch/um/include/asm/common.lds.S
+++ b/arch/um/include/asm/common.lds.S
@@ -42,7 +42,7 @@
 	INIT_SETUP(0)
   }
 
-  PERCPU(32, 32)
+  PERCPU_SECTION(32)
 	
   .initcall.init : {
 	INIT_CALLS
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index cef446f..b61d6bb 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -305,7 +305,7 @@ SECTIONS
 	}
 
 #if !defined(CONFIG_X86_64) || !defined(CONFIG_SMP)
-	PERCPU(INTERNODE_CACHE_BYTES, THREAD_SIZE)
+	PERCPU_SECTION(INTERNODE_CACHE_BYTES)
 #endif
 
 	. = ALIGN(PAGE_SIZE);
diff --git a/arch/xtensa/kernel/vmlinux.lds.S b/arch/xtensa/kernel/vmlinux.lds.S
index a282006..88ecea3 100644
--- a/arch/xtensa/kernel/vmlinux.lds.S
+++ b/arch/xtensa/kernel/vmlinux.lds.S
@@ -155,7 +155,7 @@ SECTIONS
     INIT_RAM_FS
   }
 
-  PERCPU(XCHAL_ICACHE_LINESIZE, PAGE_SIZE)
+  PERCPU_SECTION(XCHAL_ICACHE_LINESIZE)
 
   /* We need this dummy segment here */
 
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 22d3342..a8c386c 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -15,7 +15,7 @@
  *	HEAD_TEXT_SECTION
  *	INIT_TEXT_SECTION(PAGE_SIZE)
  *	INIT_DATA_SECTION(...)
- *	PERCPU(CACHELINE_SIZE, PAGE_SIZE)
+ *	PERCPU_SECTION(CACHELINE_SIZE)
  *	__init_end = .;
  *
  *	_stext = .;
@@ -703,7 +703,7 @@
  *
  * Note that this macros defines __per_cpu_load as an absolute symbol.
  * If there is no need to put the percpu section at a predetermined
- * address, use PERCPU().
+ * address, use PERCPU_SECTION.
  */
 #define PERCPU_VADDR(cacheline, vaddr, phdr)				\
 	VMLINUX_SYMBOL(__per_cpu_load) = .;				\
@@ -723,20 +723,19 @@
 	. = VMLINUX_SYMBOL(__per_cpu_load) + SIZEOF(.data..percpu);
 
 /**
- * PERCPU - define output section for percpu area, simple version
+ * PERCPU_SECTION - define output section for percpu area, simple version
  * @cacheline: cacheline size
- * @align: required alignment
  *
- * Align to @align and outputs output section for percpu area.  This macro
- * doesn't manipulate @vaddr or @phdr and __per_cpu_load and
+ * Align to PAGE_SIZE and outputs output section for percpu area.  This
+ * macro doesn't manipulate @vaddr or @phdr and __per_cpu_load and
  * __per_cpu_start will be identical.
  *
- * This macro is equivalent to ALIGN(@align); PERCPU_VADDR(@cacheline,,)
+ * This macro is equivalent to ALIGN(PAGE_SIZE); PERCPU_VADDR(@cacheline,,)
  * except that __per_cpu_load is defined as a relative symbol against
  * .data..percpu which is required for relocatable x86_32 configuration.
  */
-#define PERCPU(cacheline, align)					\
-	. = ALIGN(align);						\
+#define PERCPU_SECTION(cacheline)					\
+	. = ALIGN(PAGE_SIZE);						\
 	.data..percpu	: AT(ADDR(.data..percpu) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__per_cpu_load) = .;			\
 		VMLINUX_SYMBOL(__per_cpu_start) = .;			\
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index ee6578b..0ef7b43 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2850,9 +2850,7 @@ static int alloc_cwqs(struct workqueue_struct *wq)
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
index 8a11cd2..8eb5366 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1216,8 +1216,10 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
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
