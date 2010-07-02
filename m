Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586Ab0GCCSQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 22:18:16 -0400
Received: from king.tilera.com ([72.1.168.226]:11403 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757407Ab0GCCSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 22:18:03 -0400
Message-Id: <201007030218.o632I2uv004036@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 2 Jul 2010 14:19:35 -0400
Subject: [PATCH] arch/tile: catch up on various minor cleanups.
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de
X-OriginalArrivalTime: 03 Jul 2010 02:18:02.0630 (UTC) FILETIME=[F6DB4A60:01CB1A55]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of these changes fix any actual bugs, but are just various cleanups
that fell out along the way.  In particular, some unused #defines and
includes are removed, PREFETCH_STRIDE is added (the default is right for
our shipping chips, but wrong for our next generation), our tile-specific
prefetching code is removed so the (identical) generic prefetching code
can be used instead, a comment is fixed to be proper GPL and not just a
"paste GPL here" token, a "//" comment is converted to "/* */", etc.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/cache.h       |    5 -----
 arch/tile/include/asm/irqflags.h    |    1 -
 arch/tile/include/asm/processor.h   |   24 ++++++------------------
 arch/tile/include/asm/system.h      |    2 --
 arch/tile/include/asm/thread_info.h |    5 -----
 arch/tile/include/hv/hypervisor.h   |    2 +-
 drivers/char/hvc_tile.c             |   18 +++++++++---------
 7 files changed, 16 insertions(+), 41 deletions(-)

diff --git a/arch/tile/include/asm/cache.h b/arch/tile/include/asm/cache.h
index 869a14f..f610184 100644
--- a/arch/tile/include/asm/cache.h
+++ b/arch/tile/include/asm/cache.h
@@ -21,11 +21,6 @@
 #define L1_CACHE_SHIFT		CHIP_L1D_LOG_LINE_SIZE()
 #define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
 
-/* bytes per L1 instruction cache line */
-#define L1I_CACHE_SHIFT		CHIP_L1I_LOG_LINE_SIZE()
-#define L1I_CACHE_BYTES		(1 << L1I_CACHE_SHIFT)
-#define L1I_CACHE_ALIGN(x)	(((x)+(L1I_CACHE_BYTES-1)) & -L1I_CACHE_BYTES)
-
 /* bytes per L2 cache line */
 #define L2_CACHE_SHIFT		CHIP_L2_LOG_LINE_SIZE()
 #define L2_CACHE_BYTES		(1 << L2_CACHE_SHIFT)
diff --git a/arch/tile/include/asm/irqflags.h b/arch/tile/include/asm/irqflags.h
index cf5bffd..45cf67c 100644
--- a/arch/tile/include/asm/irqflags.h
+++ b/arch/tile/include/asm/irqflags.h
@@ -15,7 +15,6 @@
 #ifndef _ASM_TILE_IRQFLAGS_H
 #define _ASM_TILE_IRQFLAGS_H
 
-#include <asm/processor.h>
 #include <arch/interrupts.h>
 #include <arch/chip.h>
 
diff --git a/arch/tile/include/asm/processor.h b/arch/tile/include/asm/processor.h
index a67076b..2133c41 100644
--- a/arch/tile/include/asm/processor.h
+++ b/arch/tile/include/asm/processor.h
@@ -267,32 +267,20 @@ extern int hash_default;
 
 /* Should kernel stack pages be hash-for-home? */
 extern int kstack_hash;
+
+/* Does MAP_ANONYMOUS return hash-for-home pages by default? */
+#define uheap_hash hash_default
+
 #else
 #define hash_default 0
 #define kstack_hash 0
+#define uheap_hash 0
 #endif
 
 /* Are we using huge pages in the TLB for kernel data? */
 extern int kdata_huge;
 
-/*
- * Note that with OLOC the prefetch will return an unused read word to
- * the issuing tile, which will cause some MDN traffic.  Benchmarking
- * should be done to see whether this outweighs prefetching.
- */
-#define ARCH_HAS_PREFETCH
-#define ARCH_HAS_PREFETCHW
-#define ARCH_HAS_SPINLOCK_PREFETCH
-
-#define prefetch(ptr) __builtin_prefetch((ptr), 0, 3)
-#define prefetchw(ptr) __builtin_prefetch((ptr), 1, 3)
-
-#ifdef CONFIG_SMP
-#define spin_lock_prefetch(ptr) prefetchw(ptr)
-#else
-/* Nothing to prefetch. */
-#define spin_lock_prefetch(lock)	do { } while (0)
-#endif
+#define PREFETCH_STRIDE CHIP_L2_LINE_SIZE()
 
 #else /* __ASSEMBLY__ */
 
diff --git a/arch/tile/include/asm/system.h b/arch/tile/include/asm/system.h
index 0935094..f749be3 100644
--- a/arch/tile/include/asm/system.h
+++ b/arch/tile/include/asm/system.h
@@ -136,8 +136,6 @@ mb_incoherent(void)
 #define set_mb(var, value) \
 	do { var = value; mb(); } while (0)
 
-#include <linux/irqflags.h>
-
 /*
  * Pause the DMA engine and static network before task switching.
  */
diff --git a/arch/tile/include/asm/thread_info.h b/arch/tile/include/asm/thread_info.h
index beec872..3872f2b 100644
--- a/arch/tile/include/asm/thread_info.h
+++ b/arch/tile/include/asm/thread_info.h
@@ -150,11 +150,6 @@ extern void cpu_idle_on_new_stack(struct thread_info *old_ti,
 #endif
 #define TS_POLLING		0x0004	/* in idle loop but not sleeping */
 #define TS_RESTORE_SIGMASK	0x0008	/* restore signal mask in do_signal */
-#define TS_EXEC_HASH_SET	0x0010	/* apply TS_EXEC_HASH_xxx flags */
-#define TS_EXEC_HASH_RO		0x0020	/* during exec, hash r/o segments */
-#define TS_EXEC_HASH_RW		0x0040	/* during exec, hash r/w segments */
-#define TS_EXEC_HASH_STACK	0x0080	/* during exec, hash the stack */
-#define TS_EXEC_HASH_FLAGS	0x00f0	/* mask for TS_EXEC_HASH_xxx flags */
 
 #define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
 
diff --git a/arch/tile/include/hv/hypervisor.h b/arch/tile/include/hv/hypervisor.h
index a90d298..59b46dc 100644
--- a/arch/tile/include/hv/hypervisor.h
+++ b/arch/tile/include/hv/hypervisor.h
@@ -547,7 +547,7 @@ void hv_assert_intr(HV_IntrMask assert_mask);
  */
 HV_Errno hv_trigger_ipi(HV_Coord tile, int interrupt);
 
-#endif // !CHIP_HAS_IPI()
+#endif /* !CHIP_HAS_IPI() */
 
 /** Store memory mapping in debug memory so that external debugger can read it.
  * A maximum of 16 entries can be stored.
diff --git a/drivers/char/hvc_tile.c b/drivers/char/hvc_tile.c
index 75715b3..c4efb55 100644
--- a/drivers/char/hvc_tile.c
+++ b/drivers/char/hvc_tile.c
@@ -1,15 +1,15 @@
 /*
- * %LINUX_LICENSE%
- *
- *
- *
- *
- *
- *
- *
- *
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
  *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
  *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
  *
  * Tilera TILE Processor hypervisor console
  */
-- 
1.6.5.2

