Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab1CAThU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:37:20 -0500
Received: from 206.83.70.71.ptr.us.xo.net ([206.83.70.71]:52545 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757153Ab1CAThR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:37:17 -0500
Message-Id: <201103011934.p21JYbHc010296@farm-0010.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Sun, 27 Feb 2011 18:52:24 -0500
Subject: [PATCH] arch/tile: catch up with section naming convention in 2.6.35
To: linux-kernel@vger.kernel.org
In-Reply-To: <201103011931.p21JVtqp010237@farm-0010.internal.tilera.com>
X-OriginalArrivalTime: 01 Mar 2011 19:34:37.0232 (UTC) FILETIME=[B3482B00:01CBD847]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The convention changed to, e.g., ".data..page_aligned".  This commit
fixes the places in the tile architecture that were still using the
old convention.  One tile-specific section (.init.page) was dropped
in favor of just using an "aligned" attribute.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/cache.h  |    2 +-
 arch/tile/kernel/head_32.S     |    4 ++--
 arch/tile/kernel/vmlinux.lds.S |    5 +----
 arch/tile/lib/atomic_32.c      |    2 +-
 arch/tile/mm/init.c            |    2 +-
 5 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/tile/include/asm/cache.h b/arch/tile/include/asm/cache.h
index 08a2815..392e533 100644
--- a/arch/tile/include/asm/cache.h
+++ b/arch/tile/include/asm/cache.h
@@ -40,7 +40,7 @@
 #define INTERNODE_CACHE_BYTES   L2_CACHE_BYTES
 
 /* Group together read-mostly things to avoid cache false sharing */
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
+#define __read_mostly __attribute__((__section__(".data..read_mostly")))
 
 /*
  * Attribute for data that is kept read/write coherent until the end of
diff --git a/arch/tile/kernel/head_32.S b/arch/tile/kernel/head_32.S
index 90e7c44..fc49b62 100644
--- a/arch/tile/kernel/head_32.S
+++ b/arch/tile/kernel/head_32.S
@@ -133,7 +133,7 @@ ENTRY(_start)
 	}
 	ENDPROC(_start)
 
-.section ".bss.page_aligned","w"
+.section ".bss..page_aligned","w"
 	.align PAGE_SIZE
 ENTRY(empty_zero_page)
 	.fill PAGE_SIZE,1,0
@@ -148,7 +148,7 @@ ENTRY(empty_zero_page)
 	.word (\bits1) | (HV_CPA_TO_PFN(\cpa) << HV_PTE_INDEX_PFN)
 	.endm
 
-.section ".data.page_aligned","wa"
+.section ".data..page_aligned","wa"
 	.align PAGE_SIZE
 ENTRY(swapper_pg_dir)
 	/*
diff --git a/arch/tile/kernel/vmlinux.lds.S b/arch/tile/kernel/vmlinux.lds.S
index 25fdc0c..4e211c1 100644
--- a/arch/tile/kernel/vmlinux.lds.S
+++ b/arch/tile/kernel/vmlinux.lds.S
@@ -59,10 +59,7 @@ SECTIONS
 
   . = ALIGN(PAGE_SIZE);
   VMLINUX_SYMBOL(_sinitdata) = .;
-  .init.page : AT (ADDR(.init.page) - LOAD_OFFSET) {
-    *(.init.page)
-  } :data =0
-  INIT_DATA_SECTION(16)
+  INIT_DATA_SECTION(16) :data =0
   PERCPU(PAGE_SIZE)
   . = ALIGN(PAGE_SIZE);
   VMLINUX_SYMBOL(_einitdata) = .;
diff --git a/arch/tile/lib/atomic_32.c b/arch/tile/lib/atomic_32.c
index 7a5cc70..59e3a02 100644
--- a/arch/tile/lib/atomic_32.c
+++ b/arch/tile/lib/atomic_32.c
@@ -47,7 +47,7 @@ struct atomic_locks_on_cpu *atomic_lock_ptr[ATOMIC_HASH_L1_SIZE]
 
 /* This page is remapped on startup to be hash-for-home. */
 int atomic_locks[PAGE_SIZE / sizeof(int) /* Only ATOMIC_HASH_SIZE is used */]
-  __attribute__((aligned(PAGE_SIZE), section(".bss.page_aligned")));
+  __attribute__((aligned(PAGE_SIZE), section(".bss..page_aligned")));
 
 #endif /* ATOMIC_LOCKS_FOUND_VIA_TABLE() */
 
diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index 0b9ce69..e34597e 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -445,7 +445,7 @@ static pmd_t *__init get_pmd(pgd_t pgtables[], unsigned long va)
 
 /* Temporary page table we use for staging. */
 static pgd_t pgtables[PTRS_PER_PGD]
- __attribute__((section(".init.page")));
+ __attribute__((aligned(HV_PAGE_TABLE_ALIGN)));
 
 /*
  * This maps the physical memory to kernel virtual address space, a total
-- 
1.6.5.2

