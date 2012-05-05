Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913Ab2EEC6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 22:58:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab2EEC6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 22:58:43 -0400
Date: Fri, 4 May 2012 22:58:32 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>
cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix compile failure on PA-RISC
Message-ID: <Pine.LNX.4.64.1205042250130.18896@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This patch fixes compile failure on PA-RISC.

BTW. if the PA-RISC port is uncompilable for all 3.4-rc versions (and 
contains two other bugs that prevent it from booting) ... does it mean 
that I'm the only one who is using PA-RISC with recent kernel?

Mikulas

---

Fix compile failure on PA-RISC

This patch fixes compile error on PA-RISC.

The problem is this:
linux/bitops.h includes asm/bitops.h. Through a chain of dependencies
asm/bitops.h includes asm/page.h and asm/page.h needs function fls and
others defined in asm/bitops.h and linux/bitops.h --- and these
functions are not yet defined because the files linux/bitops.h and
asm/bitops.h hasn't been fully processed.

I moved cpu_relax from asm/processor.h to asm/barrier.h (and I changed
asm/processor.h to include asm/barrier.h so that current users can
assume that asm/processor.h defines cpu_relax). I changed asm/spinlock.h
to include asm/barrier.h and NOT include asm/processor.h. This breaks
the circular chain of dependencies and makes the kernel compile.


  CHK     include/linux/version.h
  UPD     include/linux/version.h
  CHK     include/generated/utsrelease.h
  UPD     include/generated/utsrelease.h
  CC      scripts/mod/empty.o
  MKELF   scripts/mod/elfconfig.h
  HOSTCC  scripts/mod/file2alias.o
  CC      kernel/bounds.s
  GEN     include/generated/bounds.h
  CC      arch/parisc/kernel/asm-offsets.s
In file included from include/asm-generic/getorder.h:7:0,
                 from /usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/page.h:162,
                 from /usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/pdc.h:346,
                 from /usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/hardware.h:5,
                 from /usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/processor.h:15,
                 from /usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/spinlock.h:4,
                 from /usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/atomic.h:20,
                 from include/linux/atomic.h:4,
                 from /usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/bitops.h:11,
                 from include/linux/bitops.h:22,
                 from include/linux/kernel.h:19,
                 from include/linux/sched.h:55,
                 from arch/parisc/kernel/asm-offsets.c:31:
include/linux/log2.h: In function '__ilog2_u32':
include/linux/log2.h:34:2: error: implicit declaration of function 'fls' [-Werror=implicit-function-declaration]
include/linux/log2.h: In function '__ilog2_u64':
include/linux/log2.h:42:2: error: implicit declaration of function 'fls64' [-Werror=implicit-function-declaration]
include/linux/log2.h: In function '__roundup_pow_of_two':
include/linux/log2.h:63:2: error: implicit declaration of function 'fls_long' [-Werror=implicit-function-declaration]
In file included from /usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/atomic.h:20:0,
                 from include/linux/atomic.h:4,
                 from /usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/bitops.h:11,
                 from include/linux/bitops.h:22,
                 from include/linux/kernel.h:19,
                 from include/linux/sched.h:55,
                 from arch/parisc/kernel/asm-offsets.c:31:
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/spinlock.h: In function 'arch_spin_is_locked':
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/spinlock.h:9:2: error: implicit declaration of function '__ldcw_align' [-Werror=implicit-function-declaration]
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/spinlock.h:9:29: warning: initialization makes pointer from integer without a cast [enabled by default]
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/spinlock.h: In function 'arch_spin_lock_flags':
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/spinlock.h:22:2: error: implicit declaration of function 'mb' [-Werror=implicit-function-declaration]
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/spinlock.h:23:4: warning: assignment makes pointer from integer without a cast [enabled by default]
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/spinlock.h:24:2: error: implicit declaration of function '__ldcw' [-Werror=implicit-function-declaration]
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/spinlock.h: In function 'arch_spin_unlock':
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/spinlock.h:39:4: warning: assignment makes pointer from integer without a cast [enabled by default]
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/spinlock.h: In function 'arch_spin_trylock':
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/spinlock.h:50:4: warning: assignment makes pointer from integer without a cast [enabled by default]
In file included from include/linux/atomic.h:4:0,
                 from /usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/bitops.h:11,
                 from include/linux/bitops.h:22,
                 from include/linux/kernel.h:19,
                 from include/linux/sched.h:55,
                 from arch/parisc/kernel/asm-offsets.c:31:
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/atomic.h: At top level:
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/atomic.h:30:56: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__lock_aligned'
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/atomic.h: In function '__atomic_add_return':
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/atomic.h:66:2: error: '__atomic_hash' undeclared (first use in this function)
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/atomic.h:66:2: note: each undeclared identifier is reported only once for each function it appears in
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/atomic.h: In function 'atomic_set':
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/atomic.h:77:2: error: '__atomic_hash' undeclared (first use in this function)
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/atomic.h: In function '__atomic64_add_return':
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/atomic.h:160:2: error: '__atomic_hash' undeclared (first use in this function)
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/atomic.h: In function 'atomic64_set':
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/atomic.h:172:2: error: '__atomic_hash' undeclared (first use in this function)
In file included from include/linux/bitops.h:22:0,
                 from include/linux/kernel.h:19,
                 from include/linux/sched.h:55,
                 from arch/parisc/kernel/asm-offsets.c:31:
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/bitops.h: In function 'set_bit':
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/bitops.h:37:2: error: '__atomic_hash' undeclared (first use in this function)
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/bitops.h: In function 'clear_bit':
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/bitops.h:48:2: error: '__atomic_hash' undeclared (first use in this function)
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/bitops.h: In function 'change_bit':
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/bitops.h:59:2: error: '__atomic_hash' undeclared (first use in this function)
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/bitops.h: In function 'test_and_set_bit':
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/bitops.h:72:2: error: '__atomic_hash' undeclared (first use in this function)
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/bitops.h: In function 'test_and_clear_bit':
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/bitops.h:90:2: error: '__atomic_hash' undeclared (first use in this function)
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/bitops.h: In function 'test_and_change_bit':
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/bitops.h:107:2: error: '__atomic_hash' undeclared (first use in this function)
In file included from include/linux/bitops.h:22:0,
                 from include/linux/kernel.h:19,
                 from include/linux/sched.h:55,
                 from arch/parisc/kernel/asm-offsets.c:31:
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/bitops.h: At top level:
/usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/bitops.h:186:23: error: static declaration of 'fls' follows non-static declaration
include/linux/log2.h:34:9: note: previous implicit declaration of 'fls' was here
In file included from /usr/src/linux-3.4-rc5-fast/arch/parisc/include/asm/bitops.h:214:0,
                 from include/linux/bitops.h:22,
                 from include/linux/kernel.h:19,
                 from include/linux/sched.h:55,
                 from arch/parisc/kernel/asm-offsets.c:31:
include/asm-generic/bitops/fls64.h:26:28: error: static declaration of 'fls64' follows non-static declaration
include/linux/log2.h:42:9: note: previous implicit declaration of 'fls64' was here
In file included from include/linux/kernel.h:19:0,
                 from include/linux/sched.h:55,
                 from arch/parisc/kernel/asm-offsets.c:31:
include/linux/bitops.h:160:24: error: conflicting types for 'fls_long'
include/linux/log2.h:63:16: note: previous implicit declaration of 'fls_long' was here
cc1: some warnings being treated as errors
make[1]: *** [arch/parisc/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2
make: *** Waiting for unfinished jobs....

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 arch/parisc/include/asm/barrier.h   |    2 ++
 arch/parisc/include/asm/processor.h |    3 +--
 arch/parisc/include/asm/spinlock.h  |    3 ++-
 3 files changed, 5 insertions(+), 3 deletions(-)

Index: linux-3.4-rc5-fast/arch/parisc/include/asm/spinlock.h
===================================================================
--- linux-3.4-rc5-fast.orig/arch/parisc/include/asm/spinlock.h	2012-05-03 23:52:36.000000000 +0200
+++ linux-3.4-rc5-fast/arch/parisc/include/asm/spinlock.h	2012-05-03 23:58:09.000000000 +0200
@@ -1,8 +1,9 @@
 #ifndef __ASM_SPINLOCK_H
 #define __ASM_SPINLOCK_H
 
-#include <asm/processor.h>
+#include <asm/barrier.h>
 #include <asm/spinlock_types.h>
+#include <asm/ldcw.h>
 
 static inline int arch_spin_is_locked(arch_spinlock_t *x)
 {
Index: linux-3.4-rc5-fast/arch/parisc/include/asm/barrier.h
===================================================================
--- linux-3.4-rc5-fast.orig/arch/parisc/include/asm/barrier.h	2012-05-03 23:52:36.000000000 +0200
+++ linux-3.4-rc5-fast/arch/parisc/include/asm/barrier.h	2012-05-04 23:49:47.000000000 +0200
@@ -32,4 +32,6 @@
 
 #define set_mb(var, value)		do { var = value; mb(); } while (0)
 
+#define cpu_relax()     __asm__ __volatile__("":::"memory")
+
 #endif /* __PARISC_BARRIER_H */
Index: linux-3.4-rc5-fast/arch/parisc/include/asm/processor.h
===================================================================
--- linux-3.4-rc5-fast.orig/arch/parisc/include/asm/processor.h	2012-05-03 23:52:36.000000000 +0200
+++ linux-3.4-rc5-fast/arch/parisc/include/asm/processor.h	2012-05-03 23:58:09.000000000 +0200
@@ -17,6 +17,7 @@
 #include <asm/ptrace.h>
 #include <asm/types.h>
 #include <asm/percpu.h>
+#include <asm/barrier.h>
 
 #endif /* __ASSEMBLY__ */
 
@@ -338,8 +339,6 @@ extern unsigned long get_wchan(struct ta
 #define KSTK_EIP(tsk)	((tsk)->thread.regs.iaoq[0])
 #define KSTK_ESP(tsk)	((tsk)->thread.regs.gr[30])
 
-#define cpu_relax()	barrier()
-
 /* Used as a macro to identify the combined VIPT/PIPT cached
  * CPUs which require a guarantee of coherency (no inequivalent
  * aliases with different data, whether clean or not) to operate */
