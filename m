Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab0JOJsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 05:48:22 -0400
Received: from [150.82.175.143] ([150.82.175.143]:37650 "EHLO
	dhcpa11143.tky.aist.go.jp" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755408Ab0JOJop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 05:44:45 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 22/22] bitops: remove minix bitops from asm/bitops.h
Date: Fri, 15 Oct 2010 18:46:21 +0900
Message-Id: <1287135981-17604-23-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.1.231.gd0b16
In-Reply-To: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com>
References: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

minix bit operations are only used by minix filesystem and useless
by other modules. Because byte order of inode and block bitmap is
defferent on each architectures.

This provides new config option CONFIG_MINIX_FS_LITTLE_ENDIAN and
CONFIG_MINIX_FS_NATIVE_ENDIAN that each architecture selects one of which.
Then we can remove minix bit operations from asm/bitops.h from all
architectures by making them minix filesystem local macros.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/Kconfig                          |    6 +++++
 arch/alpha/Kconfig                    |    1 +
 arch/alpha/include/asm/bitops.h       |    2 -
 arch/arm/Kconfig                      |    1 +
 arch/arm/include/asm/bitops.h         |   14 ------------
 arch/avr32/Kconfig                    |    1 +
 arch/avr32/include/asm/bitops.h       |    1 -
 arch/blackfin/Kconfig                 |    1 +
 arch/blackfin/include/asm/bitops.h    |    1 -
 arch/cris/Kconfig                     |    1 +
 arch/cris/include/asm/bitops.h        |    1 -
 arch/frv/Kconfig                      |    1 +
 arch/frv/include/asm/bitops.h         |    2 -
 arch/h8300/Kconfig                    |    1 +
 arch/h8300/include/asm/bitops.h       |    1 -
 arch/ia64/Kconfig                     |    1 +
 arch/ia64/include/asm/bitops.h        |    1 -
 arch/m32r/Kconfig                     |    1 +
 arch/m32r/include/asm/bitops.h        |    1 -
 arch/m68k/Kconfig                     |    1 +
 arch/m68k/include/asm/bitops_mm.h     |   14 ------------
 arch/m68knommu/Kconfig                |    1 +
 arch/microblaze/Kconfig               |    1 +
 arch/mips/Kconfig                     |    1 +
 arch/mips/include/asm/bitops.h        |    1 -
 arch/mn10300/Kconfig                  |    1 +
 arch/mn10300/include/asm/bitops.h     |    1 -
 arch/parisc/Kconfig                   |    1 +
 arch/parisc/include/asm/bitops.h      |    2 -
 arch/powerpc/Kconfig                  |    1 +
 arch/powerpc/include/asm/bitops.h     |   14 ------------
 arch/s390/Kconfig                     |    1 +
 arch/s390/include/asm/bitops.h        |    1 -
 arch/score/Kconfig                    |    3 ++
 arch/sh/Kconfig                       |    1 +
 arch/sh/include/asm/bitops.h          |    1 -
 arch/sparc/Kconfig                    |    1 +
 arch/sparc/include/asm/bitops_32.h    |    1 -
 arch/sparc/include/asm/bitops_64.h    |    2 -
 arch/tile/Kconfig                     |    1 +
 arch/tile/include/asm/bitops.h        |    1 -
 arch/x86/Kconfig                      |    1 +
 arch/x86/include/asm/bitops.h         |    2 -
 arch/xtensa/Kconfig                   |    1 +
 arch/xtensa/include/asm/bitops.h      |    1 -
 fs/minix/minix.h                      |   37 +++++++++++++++++++++++++++++++++
 include/asm-generic/bitops.h          |    1 -
 include/asm-generic/bitops/minix-le.h |   15 -------------
 include/asm-generic/bitops/minix.h    |   15 -------------
 49 files changed, 68 insertions(+), 96 deletions(-)
 delete mode 100644 include/asm-generic/bitops/minix-le.h
 delete mode 100644 include/asm-generic/bitops/minix.h

diff --git a/arch/Kconfig b/arch/Kconfig
index fe48fc7..c4be275 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -159,3 +159,9 @@ config HAVE_PERF_EVENTS_NMI
 	  to determine how many clock cycles in a given period.
 
 source "kernel/gcov/Kconfig"
+
+config MINIX_FS_NATIVE_ENDIAN
+	bool
+
+config MINIX_FS_LITTLE_ENDIAN
+	bool
diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index b9647bb..4b892cc 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -11,6 +11,7 @@ config ALPHA
 	select HAVE_SYSCALL_WRAPPERS
 	select HAVE_PERF_EVENTS
 	select HAVE_DMA_ATTRS
+	select MINIX_FS_NATIVE_ENDIAN
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
diff --git a/arch/alpha/include/asm/bitops.h b/arch/alpha/include/asm/bitops.h
index 822433a..85b8152 100644
--- a/arch/alpha/include/asm/bitops.h
+++ b/arch/alpha/include/asm/bitops.h
@@ -459,8 +459,6 @@ sched_find_first_bit(const unsigned long b[2])
 #define ext2_set_bit_atomic(l,n,a)   test_and_set_bit(n,a)
 #define ext2_clear_bit_atomic(l,n,a) test_and_clear_bit(n,a)
 
-#include <asm-generic/bitops/minix.h>
-
 #endif /* __KERNEL__ */
 
 #endif /* _ALPHA_BITOPS_H */
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 9c26ba7..a1c86d4 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -26,6 +26,7 @@ config ARM
 	select HAVE_PERF_EVENTS
 	select PERF_USE_VMALLOC
 	select HAVE_REGS_AND_STACK_ACCESS_API
+	select MINIX_FS_LITTLE_ENDIAN
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
diff --git a/arch/arm/include/asm/bitops.h b/arch/arm/include/asm/bitops.h
index e656a85..559756f 100644
--- a/arch/arm/include/asm/bitops.h
+++ b/arch/arm/include/asm/bitops.h
@@ -332,20 +332,6 @@ static inline int fls(int x)
 #define ext2_clear_bit_atomic(lock,nr,p)        \
 		test_and_clear_le_bit(nr, (unsigned long *)(p))
 
-/*
- * Minix is defined to use little-endian byte ordering.
- * These do not need to be atomic.
- */
-#define minix_set_bit(nr,p)			\
-		__set_le_bit(nr, (unsigned long *)(p))
-#define minix_test_bit(nr,p)			\
-		test_le_bit(nr, (unsigned long *)(p))
-#define minix_test_and_set_bit(nr,p)		\
-		__test_and_set_le_bit(nr, (unsigned long *)(p))
-#define minix_test_and_clear_bit(nr,p)		\
-		__test_and_clear_le_bit(nr, (unsigned long *)(p))
-#define minix_find_first_zero_bit(p,sz)		\
-		find_first_zero_le_bit((unsigned long *)(p), sz)
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index f515727..0e49785 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -13,6 +13,7 @@ config AVR32
 	select HAVE_CLK
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select MINIX_FS_LITTLE_ENDIAN
 	help
 	  AVR32 is a high-performance 32-bit RISC microprocessor core,
 	  designed for cost-sensitive embedded applications, with particular
diff --git a/arch/avr32/include/asm/bitops.h b/arch/avr32/include/asm/bitops.h
index 73a163a..72444d9 100644
--- a/arch/avr32/include/asm/bitops.h
+++ b/arch/avr32/include/asm/bitops.h
@@ -301,6 +301,5 @@ static inline int ffs(unsigned long word)
 
 #include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-atomic.h>
-#include <asm-generic/bitops/minix-le.h>
 
 #endif /* __ASM_AVR32_BITOPS_H */
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 5a3152b..61fc4d5 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -37,6 +37,7 @@ config BLACKFIN
 	select HAVE_KERNEL_LZO if RAMKERNEL
 	select HAVE_OPROFILE
 	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select MINIX_FS_NATIVE_ENDIAN
 
 config GENERIC_CSUM
 	def_bool y
diff --git a/arch/blackfin/include/asm/bitops.h b/arch/blackfin/include/asm/bitops.h
index 2c549f7..68843fa 100644
--- a/arch/blackfin/include/asm/bitops.h
+++ b/arch/blackfin/include/asm/bitops.h
@@ -27,7 +27,6 @@
 
 #include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-atomic.h>
-#include <asm-generic/bitops/minix.h>
 
 #ifndef CONFIG_SMP
 #include <linux/irqflags.h>
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index aefe3b1..71380b5 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -61,6 +61,7 @@ config CRIS
 	bool
 	default y
 	select HAVE_IDE
+	select MINIX_NATIVE_ENDIAN
 
 config HZ
 	int
diff --git a/arch/cris/include/asm/bitops.h b/arch/cris/include/asm/bitops.h
index 71bea40..310e0de 100644
--- a/arch/cris/include/asm/bitops.h
+++ b/arch/cris/include/asm/bitops.h
@@ -159,7 +159,6 @@ static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
 #define ext2_set_bit_atomic(l,n,a)   test_and_set_bit(n,a)
 #define ext2_clear_bit_atomic(l,n,a) test_and_clear_bit(n,a)
 
-#include <asm-generic/bitops/minix.h>
 #include <asm-generic/bitops/sched.h>
 
 #endif /* __KERNEL__ */
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index 16399bd..3328e9a 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -8,6 +8,7 @@ config FRV
 	select HAVE_IDE
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_PERF_EVENTS
+	select MINIX_FS_LITTLE_ENDIAN
 
 config ZONE_DMA
 	bool
diff --git a/arch/frv/include/asm/bitops.h b/arch/frv/include/asm/bitops.h
index e3ea644..a1d00b0 100644
--- a/arch/frv/include/asm/bitops.h
+++ b/arch/frv/include/asm/bitops.h
@@ -406,8 +406,6 @@ int __ilog2_u64(u64 n)
 #define ext2_set_bit_atomic(lock,nr,addr)	test_and_set_bit  ((nr) ^ 0x18, (addr))
 #define ext2_clear_bit_atomic(lock,nr,addr)	test_and_clear_bit((nr) ^ 0x18, (addr))
 
-#include <asm-generic/bitops/minix-le.h>
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_BITOPS_H */
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 988b6ff..bf9099c 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -9,6 +9,7 @@ config H8300
 	bool
 	default y
 	select HAVE_IDE
+	select MINIX_FS_NATIVE_ENDIAN
 
 config SYMBOL_PREFIX
 	string
diff --git a/arch/h8300/include/asm/bitops.h b/arch/h8300/include/asm/bitops.h
index 23cea66..e856c1b 100644
--- a/arch/h8300/include/asm/bitops.h
+++ b/arch/h8300/include/asm/bitops.h
@@ -202,7 +202,6 @@ static __inline__ unsigned long __ffs(unsigned long word)
 #include <asm-generic/bitops/lock.h>
 #include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-atomic.h>
-#include <asm-generic/bitops/minix.h>
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index ba22849..b3649b7 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -29,6 +29,7 @@ config IA64
 	select HAVE_KVM
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_DMA_API_DEBUG
+	select MINIX_FS_NATIVE_ENDIAN
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
diff --git a/arch/ia64/include/asm/bitops.h b/arch/ia64/include/asm/bitops.h
index 336984a..b76f7e0 100644
--- a/arch/ia64/include/asm/bitops.h
+++ b/arch/ia64/include/asm/bitops.h
@@ -461,7 +461,6 @@ static __inline__ unsigned long __arch_hweight64(unsigned long x)
 #define ext2_set_bit_atomic(l,n,a)	test_and_set_bit(n,a)
 #define ext2_clear_bit_atomic(l,n,a)	test_and_clear_bit(n,a)
 
-#include <asm-generic/bitops/minix.h>
 #include <asm-generic/bitops/sched.h>
 
 #endif /* __KERNEL__ */
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index 836abbb..078324c 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -14,6 +14,7 @@ config M32R
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
+	select MINIX_FS_NATIVE_ENDIAN
 
 config SBUS
 	bool
diff --git a/arch/m32r/include/asm/bitops.h b/arch/m32r/include/asm/bitops.h
index cdfb4c8..6300f22 100644
--- a/arch/m32r/include/asm/bitops.h
+++ b/arch/m32r/include/asm/bitops.h
@@ -268,7 +268,6 @@ static __inline__ int test_and_change_bit(int nr, volatile void * addr)
 
 #include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-atomic.h>
-#include <asm-generic/bitops/minix.h>
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 8030e24..5605acc 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -8,6 +8,7 @@ config M68K
 	select HAVE_AOUT
 	select HAVE_IDE
 	select GENERIC_ATOMIC64
+	select MINIX_FS_LITTLE_ENDIAN
 
 config MMU
 	bool
diff --git a/arch/m68k/include/asm/bitops_mm.h b/arch/m68k/include/asm/bitops_mm.h
index 2451f7f..7011223 100644
--- a/arch/m68k/include/asm/bitops_mm.h
+++ b/arch/m68k/include/asm/bitops_mm.h
@@ -325,20 +325,6 @@ static inline int __fls(int x)
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
 
-/* Bitmap functions for the minix filesystem */
-
-#define minix_find_first_zero_bit(vaddr, size)	\
-	find_first_zero_le_bit(vaddr, (size))
-
-#define minix_test_and_set_bit(nr, addr)	\
-	__test_and_set_le_bit((nr), (unsigned long *)(addr))
-#define minix_set_bit(nr, addr)	\
-	__set_le_bit((nr), (unsigned long *)(addr))
-#define minix_test_and_clear_bit(nr, addr)	\
-	__test_and_clear_le_bit((nr), (unsigned long *)(addr))
-
-#define minix_test_bit(nr, addr)	test_le_bit(nr, addr)
-
 /* Bitmap functions for little endian. */
 
 #define __set_le_bit(nr, addr)	\
diff --git a/arch/m68knommu/Kconfig b/arch/m68knommu/Kconfig
index 2609c39..fdd9e4c 100644
--- a/arch/m68knommu/Kconfig
+++ b/arch/m68knommu/Kconfig
@@ -9,6 +9,7 @@ config M68K
 	bool
 	default y
 	select HAVE_IDE
+	select MINIX_NATIVE_ENDIAN
 
 config MMU
 	bool
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 692fdfc..1cfbaad 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -20,6 +20,7 @@ config MICROBLAZE
 	select TRACING_SUPPORT
 	select OF
 	select OF_FLATTREE
+	select MINIX_FS_NATIVE_ENDIAN
 
 config SWAP
 	def_bool n
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 5526faa..e64530c 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -14,6 +14,7 @@ config MIPS
 	select HAVE_KRETPROBES
 	select RTC_LIB if !MACH_LOONGSON
 	select GENERIC_ATOMIC64 if !64BIT
+	select MINIX_FS_NATIVE_ENDIAN
 
 mainmenu "Linux/MIPS Kernel Configuration"
 
diff --git a/arch/mips/include/asm/bitops.h b/arch/mips/include/asm/bitops.h
index 07ce5aa..6a2202c 100644
--- a/arch/mips/include/asm/bitops.h
+++ b/arch/mips/include/asm/bitops.h
@@ -706,7 +706,6 @@ static inline int ffs(int word)
 
 #include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-atomic.h>
-#include <asm-generic/bitops/minix.h>
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 7c2a2f7..674b503 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -8,6 +8,7 @@ mainmenu "Linux Kernel Configuration"
 config MN10300
 	def_bool y
 	select HAVE_OPROFILE
+	select MINIX_FS_LITTLE_ENDIAN
 
 config AM33
 	def_bool y
diff --git a/arch/mn10300/include/asm/bitops.h b/arch/mn10300/include/asm/bitops.h
index e1a9768..94ee844 100644
--- a/arch/mn10300/include/asm/bitops.h
+++ b/arch/mn10300/include/asm/bitops.h
@@ -234,7 +234,6 @@ int ffs(int x)
 	test_and_clear_bit((nr), (addr))
 
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/minix-le.h>
 
 #endif /* __KERNEL__ */
 #endif /* __ASM_BITOPS_H */
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 907417d..99e3164 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -18,6 +18,7 @@ config PARISC
 	select BUG
 	select HAVE_PERF_EVENTS
 	select GENERIC_ATOMIC64 if !64BIT
+	select MINIX_FS_LITTLE_ENDIAN
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
 	  in many of their workstations & servers (HP9000 700 and 800 series,
diff --git a/arch/parisc/include/asm/bitops.h b/arch/parisc/include/asm/bitops.h
index 919d7ed..43c516f 100644
--- a/arch/parisc/include/asm/bitops.h
+++ b/arch/parisc/include/asm/bitops.h
@@ -234,6 +234,4 @@ static __inline__ int fls(int x)
 
 #endif	/* __KERNEL__ */
 
-#include <asm-generic/bitops/minix-le.h>
-
 #endif /* _PARISC_BITOPS_H */
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 631e5a0..fe166fe 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -141,6 +141,7 @@ config PPC
 	select HAVE_PERF_EVENTS
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS && PPC_BOOK3S_64
+	select MINIX_FS_LITTLE_ENDIAN
 
 config EARLY_PRINTK
 	bool
diff --git a/arch/powerpc/include/asm/bitops.h b/arch/powerpc/include/asm/bitops.h
index eb9ce7f..bf5ccfc 100644
--- a/arch/powerpc/include/asm/bitops.h
+++ b/arch/powerpc/include/asm/bitops.h
@@ -308,20 +308,6 @@ unsigned long find_next_le_bit(const unsigned long *addr,
 #define ext2_clear_bit_atomic(lock, nr, addr) \
 	test_and_clear_le_bit((nr), (unsigned long*)addr)
 
-/* Bitmap functions for the minix filesystem.  */
-
-#define minix_test_and_set_bit(nr,addr) \
-	__test_and_set_le_bit(nr, (unsigned long *)addr)
-#define minix_set_bit(nr,addr) \
-	__set_le_bit(nr, (unsigned long *)addr)
-#define minix_test_and_clear_bit(nr,addr) \
-	__test_and_clear_le_bit(nr, (unsigned long *)addr)
-#define minix_test_bit(nr,addr) \
-	test_le_bit(nr, (unsigned long *)addr)
-
-#define minix_find_first_zero_bit(addr,size) \
-	find_first_zero_le_bit((unsigned long *)addr, size)
-
 #include <asm-generic/bitops/sched.h>
 
 #endif /* __KERNEL__ */
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index f0777a4..1fbb039 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -128,6 +128,7 @@ config S390
 	select ARCH_INLINE_WRITE_UNLOCK_BH
 	select ARCH_INLINE_WRITE_UNLOCK_IRQ
 	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
+	select MINIX_FS_NATIVE_ENDIAN
 
 config SCHED_OMIT_FRAME_POINTER
 	bool
diff --git a/arch/s390/include/asm/bitops.h b/arch/s390/include/asm/bitops.h
index 2ac6819..7f3ec8e 100644
--- a/arch/s390/include/asm/bitops.h
+++ b/arch/s390/include/asm/bitops.h
@@ -842,7 +842,6 @@ static inline int find_next_le_bit(void *vaddr, unsigned long size,
 #define ext2_clear_bit_atomic(lock, nr, addr)     \
 	test_and_clear_le_bit((nr), (unsigned long *)(addr))
 
-#include <asm-generic/bitops/minix.h>
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/score/Kconfig b/arch/score/Kconfig
index be4a155..42bd444 100644
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -64,6 +64,9 @@ config GENERIC_HARDIRQS_NO__DO_IRQ
 config GENERIC_SYSCALL_TABLE
 	def_bool y
 
+config MINIX_FS_NATIVE_ENDIAN
+	def_bool y
+
 config SCORE_L1_CACHE_SHIFT
 	int
 	default "4"
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 33990fa..04e4f7a 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -25,6 +25,7 @@ config SUPERH
 	select HAVE_SYSCALL_TRACEPOINTS
 	select RTC_LIB
 	select GENERIC_ATOMIC64
+	select MINIX_FS_NATIVE_ENDIAN
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
 	  and consumer electronics; it was also used in the Sega Dreamcast
diff --git a/arch/sh/include/asm/bitops.h b/arch/sh/include/asm/bitops.h
index fc5cd5b..90fa3e4 100644
--- a/arch/sh/include/asm/bitops.h
+++ b/arch/sh/include/asm/bitops.h
@@ -96,7 +96,6 @@ static inline unsigned long ffz(unsigned long word)
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-atomic.h>
-#include <asm-generic/bitops/minix.h>
 #include <asm-generic/bitops/fls.h>
 #include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 491e9d6..6a9ceff 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -30,6 +30,7 @@ config SPARC
 	select PERF_USE_VMALLOC
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_API_DEBUG
+	select MINIX_FS_NATIVE_ENDIAN
 
 config SPARC32
 	def_bool !64BIT
diff --git a/arch/sparc/include/asm/bitops_32.h b/arch/sparc/include/asm/bitops_32.h
index 75da6f8..25a6766 100644
--- a/arch/sparc/include/asm/bitops_32.h
+++ b/arch/sparc/include/asm/bitops_32.h
@@ -105,7 +105,6 @@ static inline void change_bit(unsigned long nr, volatile unsigned long *addr)
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-atomic.h>
-#include <asm-generic/bitops/minix.h>
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/sparc/include/asm/bitops_64.h b/arch/sparc/include/asm/bitops_64.h
index 66db28e..38e9aa1 100644
--- a/arch/sparc/include/asm/bitops_64.h
+++ b/arch/sparc/include/asm/bitops_64.h
@@ -96,8 +96,6 @@ static inline unsigned int __arch_hweight8(unsigned int w)
 #define ext2_clear_bit_atomic(lock,nr,addr) \
 	test_and_clear_bit((nr) ^ 0x38,(unsigned long *)(addr))
 
-#include <asm-generic/bitops/minix.h>
-
 #endif /* __KERNEL__ */
 
 #endif /* defined(_SPARC64_BITOPS_H) */
diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 1eb308c..f05edeb 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -100,6 +100,7 @@ config TILE
 	select GENERIC_FIND_NEXT_BIT
 	select USE_GENERIC_SMP_HELPERS
 	select CC_OPTIMIZE_FOR_SIZE
+	select MINIX_FS_NATIVE_ENDIAN
 
 # FIXME: investigate whether we need/want these options.
 #	select HAVE_IOREMAP_PROT
diff --git a/arch/tile/include/asm/bitops.h b/arch/tile/include/asm/bitops.h
index 5447add..132e6bb 100644
--- a/arch/tile/include/asm/bitops.h
+++ b/arch/tile/include/asm/bitops.h
@@ -123,6 +123,5 @@ static inline unsigned long __arch_hweight64(__u64 w)
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/minix.h>
 
 #endif /* _ASM_TILE_BITOPS_H */
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cea0cd9..3a8c961 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -59,6 +59,7 @@ config X86
 	select ANON_INODES
 	select HAVE_ARCH_KMEMCHECK
 	select HAVE_USER_RETURN_NOTIFIER
+	select MINIX_FS_NATIVE_ENDIAN
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 3c95e07..69d5813 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -463,7 +463,5 @@ static inline int fls(int x)
 #define ext2_clear_bit_atomic(lock, nr, addr)			\
 	test_and_clear_bit((nr), (unsigned long *)(addr))
 
-#include <asm-generic/bitops/minix.h>
-
 #endif /* __KERNEL__ */
 #endif /* _ASM_X86_BITOPS_H */
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index 0859bfd..ed7dd53 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -12,6 +12,7 @@ config ZONE_DMA
 config XTENSA
 	def_bool y
 	select HAVE_IDE
+	select MINIX_FS_NATIVE_ENDIAN
 	help
 	  Xtensa processors are 32-bit RISC machines designed by Tensilica
 	  primarily for embedded systems.  These processors are both
diff --git a/arch/xtensa/include/asm/bitops.h b/arch/xtensa/include/asm/bitops.h
index a56b7b5..c8fac8d 100644
--- a/arch/xtensa/include/asm/bitops.h
+++ b/arch/xtensa/include/asm/bitops.h
@@ -125,7 +125,6 @@ static inline unsigned long __fls(unsigned long word)
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
 #include <asm-generic/bitops/sched.h>
-#include <asm-generic/bitops/minix.h>
 
 #endif	/* __KERNEL__ */
 
diff --git a/fs/minix/minix.h b/fs/minix/minix.h
index 407b1c8..41c1bba 100644
--- a/fs/minix/minix.h
+++ b/fs/minix/minix.h
@@ -88,4 +88,41 @@ static inline struct minix_inode_info *minix_i(struct inode *inode)
 	return list_entry(inode, struct minix_inode_info, vfs_inode);
 }
 
+#if defined(CONFIG_MINIX_FS_NATIVE_ENDIAN) && \
+	defined(CONFIG_MINIX_FS_LITTLE_ENDIAN)
+
+#error Minix file system byte order broken
+
+#elif defined(CONFIG_MINIX_FS_NATIVE_ENDIAN)
+
+#define minix_test_and_set_bit(nr, addr)	\
+	__test_and_set_bit((nr), (unsigned long *)(addr))
+#define minix_set_bit(nr, addr)		\
+	__set_bit((nr), (unsigned long *)(addr))
+#define minix_test_and_clear_bit(nr, addr) \
+	__test_and_clear_bit((nr), (unsigned long *)(addr))
+#define minix_test_bit(nr, addr)		\
+	test_bit((nr), (unsigned long *)(addr))
+#define minix_find_first_zero_bit(addr, size) \
+	find_first_zero_bit((unsigned long *)(addr), (size))
+
+#elif defined(CONFIG_MINIX_FS_LITTLE_ENDIAN)
+
+#define minix_test_and_set_bit(nr, addr)	\
+	__test_and_set_le_bit((nr), (unsigned long *)(addr))
+#define minix_set_bit(nr, addr)		\
+	__set_le_bit((nr), (unsigned long *)(addr))
+#define minix_test_and_clear_bit(nr, addr) \
+	__test_and_clear_le_bit((nr), (unsigned long *)(addr))
+#define minix_test_bit(nr, addr)		\
+	test_le_bit((nr), (unsigned long *)(addr))
+#define minix_find_first_zero_bit(addr, size) \
+	find_first_zero_le_bit((unsigned long *)(addr), (size))
+
+#else
+
+#error Minix file system byte order undefined
+
+#endif
+
 #endif /* FS_MINIX_H */
diff --git a/include/asm-generic/bitops.h b/include/asm-generic/bitops.h
index dd7c014..280ca7a 100644
--- a/include/asm-generic/bitops.h
+++ b/include/asm-generic/bitops.h
@@ -40,6 +40,5 @@
 #include <asm-generic/bitops/non-atomic.h>
 #include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-atomic.h>
-#include <asm-generic/bitops/minix.h>
 
 #endif /* __ASM_GENERIC_BITOPS_H */
diff --git a/include/asm-generic/bitops/minix-le.h b/include/asm-generic/bitops/minix-le.h
deleted file mode 100644
index f366cfa..0000000
--- a/include/asm-generic/bitops/minix-le.h
+++ /dev/null
@@ -1,15 +0,0 @@
-#ifndef _ASM_GENERIC_BITOPS_MINIX_LE_H_
-#define _ASM_GENERIC_BITOPS_MINIX_LE_H_
-
-#define minix_test_and_set_bit(nr,addr)	\
-	__test_and_set_le_bit((nr), (unsigned long *)(addr))
-#define minix_set_bit(nr,addr)		\
-	__set_le_bit((nr), (unsigned long *)(addr))
-#define minix_test_and_clear_bit(nr,addr) \
-	__test_and_clear_le_bit((nr), (unsigned long *)(addr))
-#define minix_test_bit(nr,addr)		\
-	test_le_bit((nr), (unsigned long *)(addr))
-#define minix_find_first_zero_bit(addr,size) \
-	find_first_zero_le_bit((unsigned long *)(addr), (size))
-
-#endif /* _ASM_GENERIC_BITOPS_MINIX_LE_H_ */
diff --git a/include/asm-generic/bitops/minix.h b/include/asm-generic/bitops/minix.h
deleted file mode 100644
index 91f42e8..0000000
--- a/include/asm-generic/bitops/minix.h
+++ /dev/null
@@ -1,15 +0,0 @@
-#ifndef _ASM_GENERIC_BITOPS_MINIX_H_
-#define _ASM_GENERIC_BITOPS_MINIX_H_
-
-#define minix_test_and_set_bit(nr,addr)	\
-	__test_and_set_bit((nr),(unsigned long *)(addr))
-#define minix_set_bit(nr,addr)		\
-	__set_bit((nr),(unsigned long *)(addr))
-#define minix_test_and_clear_bit(nr,addr) \
-	__test_and_clear_bit((nr),(unsigned long *)(addr))
-#define minix_test_bit(nr,addr)		\
-	test_bit((nr),(unsigned long *)(addr))
-#define minix_find_first_zero_bit(addr,size) \
-	find_first_zero_bit((unsigned long *)(addr),(size))
-
-#endif /* _ASM_GENERIC_BITOPS_MINIX_H_ */
-- 
1.7.1.231.gd0b16

