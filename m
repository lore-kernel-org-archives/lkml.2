Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936714Ab2C3W56 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:57:58 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41906 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934893Ab2C3VFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:37 -0400
Message-Id: <201203302105.q2UL54oT006286@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 29 Mar 2012 15:25:59 -0400
Subject: [PATCH] arch/tile: support <asm/cachectl.h> header for cacheflush() syscall
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:04.0522 (UTC) FILETIME=[C75E26A0:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already had a syscall that did some dcache flushing, but it was
not used in practice.  Make it MIPS compatible instead so it can
do both the DCACHE and ICACHE actions.  We have code that wants to
be able to use the ICACHE flush mode from userspace so this change
enables that.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/Kbuild     |    1 +
 arch/tile/include/asm/cachectl.h |   42 ++++++++++++++++++++++++++++++++++++++
 arch/tile/include/asm/compat.h   |    3 --
 arch/tile/include/asm/syscalls.h |    3 +-
 arch/tile/include/asm/unistd.h   |    4 +-
 arch/tile/kernel/sys.c           |   10 +++++++-
 6 files changed, 55 insertions(+), 8 deletions(-)
 create mode 100644 arch/tile/include/asm/cachectl.h

diff --git a/arch/tile/include/asm/Kbuild b/arch/tile/include/asm/Kbuild
index 6b2e681..143473e 100644
--- a/arch/tile/include/asm/Kbuild
+++ b/arch/tile/include/asm/Kbuild
@@ -2,6 +2,7 @@ include include/asm-generic/Kbuild.asm
 
 header-y += ../arch/
 
+header-y += cachectl.h
 header-y += ucontext.h
 header-y += hardwall.h
 
diff --git a/arch/tile/include/asm/cachectl.h b/arch/tile/include/asm/cachectl.h
new file mode 100644
index 0000000..af4c9f9
--- /dev/null
+++ b/arch/tile/include/asm/cachectl.h
@@ -0,0 +1,42 @@
+/*
+ * Copyright 2011 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_CACHECTL_H
+#define _ASM_TILE_CACHECTL_H
+
+/*
+ * Options for cacheflush system call.
+ *
+ * The ICACHE flush is performed on all cores currently running the
+ * current process's address space.  The intent is for user
+ * applications to be able to modify code, invoke the system call,
+ * then allow arbitrary other threads in the same address space to see
+ * the newly-modified code.  Passing a length of CHIP_L1I_CACHE_SIZE()
+ * or more invalidates the entire icache on all cores in the address
+ * spaces.  (Note: currently this option invalidates the entire icache
+ * regardless of the requested address and length, but we may choose
+ * to honor the arguments at some point.)
+ *
+ * Flush and invalidation of memory can normally be performed with the
+ * __insn_flush(), __insn_inv(), and __insn_finv() instructions from
+ * userspace.  The DCACHE option to the system call allows userspace
+ * to flush the entire L1+L2 data cache from the core.  In this case,
+ * the address and length arguments are not used.  The DCACHE flush is
+ * restricted to the current core, not all cores in the address space.
+ */
+#define	ICACHE	(1<<0)		/* invalidate L1 instruction cache */
+#define	DCACHE	(1<<1)		/* flush and invalidate data cache */
+#define	BCACHE	(ICACHE|DCACHE)	/* flush both caches               */
+
+#endif	/* _ASM_TILE_CACHECTL_H */
diff --git a/arch/tile/include/asm/compat.h b/arch/tile/include/asm/compat.h
index 4b4b289..69adc08 100644
--- a/arch/tile/include/asm/compat.h
+++ b/arch/tile/include/asm/compat.h
@@ -242,9 +242,6 @@ long compat_sys_fallocate(int fd, int mode,
 long compat_sys_sched_rr_get_interval(compat_pid_t pid,
 				      struct compat_timespec __user *interval);
 
-/* Tilera Linux syscalls that don't have "compat" versions. */
-#define compat_sys_flush_cache sys_flush_cache
-
 /* These are the intvec_64.S trampolines. */
 long _compat_sys_execve(const char __user *path,
 			const compat_uptr_t __user *argv,
diff --git a/arch/tile/include/asm/syscalls.h b/arch/tile/include/asm/syscalls.h
index 3b5507c..06f0464 100644
--- a/arch/tile/include/asm/syscalls.h
+++ b/arch/tile/include/asm/syscalls.h
@@ -43,7 +43,8 @@ long sys32_fadvise64(int fd, u32 offset_lo, u32 offset_hi,
 		     u32 len, int advice);
 int sys32_fadvise64_64(int fd, u32 offset_lo, u32 offset_hi,
 		       u32 len_lo, u32 len_hi, int advice);
-long sys_flush_cache(void);
+long sys_cacheflush(unsigned long addr, unsigned long len,
+		    unsigned long flags);
 #ifndef __tilegx__  /* No mmap() in the 32-bit kernel. */
 #define sys_mmap sys_mmap
 #endif
diff --git a/arch/tile/include/asm/unistd.h b/arch/tile/include/asm/unistd.h
index f70bf1c..a017246 100644
--- a/arch/tile/include/asm/unistd.h
+++ b/arch/tile/include/asm/unistd.h
@@ -24,8 +24,8 @@
 #include <asm-generic/unistd.h>
 
 /* Additional Tilera-specific syscalls. */
-#define __NR_flush_cache	(__NR_arch_specific_syscall + 1)
-__SYSCALL(__NR_flush_cache, sys_flush_cache)
+#define __NR_cacheflush	(__NR_arch_specific_syscall + 1)
+__SYSCALL(__NR_cacheflush, sys_cacheflush)
 
 #ifndef __tilegx__
 /* "Fast" syscalls provide atomic support for 32-bit chips. */
diff --git a/arch/tile/kernel/sys.c b/arch/tile/kernel/sys.c
index cb44ba7..b08095b 100644
--- a/arch/tile/kernel/sys.c
+++ b/arch/tile/kernel/sys.c
@@ -32,11 +32,17 @@
 #include <asm/syscalls.h>
 #include <asm/pgtable.h>
 #include <asm/homecache.h>
+#include <asm/cachectl.h>
 #include <arch/chip.h>
 
-SYSCALL_DEFINE0(flush_cache)
+SYSCALL_DEFINE3(cacheflush, unsigned long, addr, unsigned long, len,
+		unsigned long, flags)
 {
-	homecache_evict(cpumask_of(smp_processor_id()));
+	if (flags & DCACHE)
+		homecache_evict(cpumask_of(smp_processor_id()));
+	if (flags & ICACHE)
+		flush_remote(0, HV_FLUSH_EVICT_L1I, mm_cpumask(current->mm),
+			     0, 0, 0, NULL, NULL, 0);
 	return 0;
 }
 
-- 
1.6.5.2

