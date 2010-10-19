Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab0JSPHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:07:08 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59208 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab0JSPHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:07:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=epKXnL94T/X8MD9Z3mVBlOmEvTHfeUlXeqqGF4TsT6gYjusCkQiDcMMccV+jz84BXR
         GdEx4M6jVvpD+VQBq+r/efDOGdVvcB0tgeX9EDURcK52dFaAs+zNqNFFjF1xyG4U4S+S
         Pdi+KZo5XHVabXAY5Lck6sXm3u/VtLTk65nQQ=
Date: Wed, 20 Oct 2010 00:05:45 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 22/22] bitops: remove minix bitops from asm/bitops.h
Message-ID: <20101019150541.GA3978@localhost.localdomain>
References: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com> <1287135981-17604-23-git-send-email-akinobu.mita@gmail.com> <201010151253.15653.arnd@arndb.de> <AANLkTi=cA=yf7NmPVKXaZdoTBYmwdmy_frk7b_feG-WG@mail.gmail.com> <m262x24j2y.fsf@igel.home> <AANLkTimHYYLZHOxgco3jotD7ikVhaPh8FVcSqeZwtrVc@mail.gmail.com> <AANLkTimtyW8AbOj+w=mjPbpP1j0LB9JXdo7cb=nQAXQ8@mail.gmail.com> <m2aamepa5s.fsf@igel.home> <AANLkTimB77RRcJfNcX-w7E+mKiKmNzR661SrP8G09y7A@mail.gmail.com> <m2wrpinn7p.fsf@igel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m2wrpinn7p.fsf@igel.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 05:58:50PM +0200, Andreas Schwab wrote:
> Akinobu Mita <akinobu.mita@gmail.com> writes:
> 
> > 2010/10/16 Andreas Schwab <schwab@linux-m68k.org>:
> >> Akinobu Mita <akinobu.mita@gmail.com> writes:
> >>
> >>> m68knommu is big-endian minixfs but m68k (mmu) is little-endian minixfs
> >>> if I read arch/m68k/include/asm/bitops_{mm,no}.h correctly.
> >>
> >> Don't be confused by ^16, this is for the 16bit/32bit indexing
> >> correction.  The nommu version uses big-endian 32bit indexing which yet
> >> another format.
> >
> > Oh, I see. I misunderstood.
> >
> > So we need a special handling for it to keep compatibility.
> 
> IMHO we only need two versions: big-endian filesystem with big-endian
> 16bit indexed bitmaps and little-endian filesystem with little-endian
> bitmaps.  The rest is just the result of careless copying.  Note that
> the minix filesystem does no byte swapping, so native byte order is the
> only sensible mode.

I'm going to fix it by adding another two config options.
(based on the Arnd's suggestion in the earlier reply in this thread)

config MINIX_FS_NATIVE_ENDIAN
	def_bool MINIX_FS
	depends on H8300 || M32R || MICROBLAZE || MIPS || S390 || SUPERH || SPARC || XTENSA || (M68K && !MMU)

config MINIX_FS_BIG_ENDIAN_16BIT_INDEXED
	def_bool MINIX_FS
	depends on M68K && MMU

The architectures which always use little-endian bitmaps do not select
these options.

---
 arch/alpha/include/asm/bitops.h       |    2 -
 arch/arm/include/asm/bitops.h         |   14 ------
 arch/avr32/include/asm/bitops.h       |    1 -
 arch/blackfin/include/asm/bitops.h    |    1 -
 arch/cris/include/asm/bitops.h        |    1 -
 arch/frv/include/asm/bitops.h         |    2 -
 arch/h8300/include/asm/bitops.h       |    1 -
 arch/ia64/include/asm/bitops.h        |    1 -
 arch/m32r/include/asm/bitops.h        |    1 -
 arch/m68k/include/asm/bitops_mm.h     |   30 ------------
 arch/mips/include/asm/bitops.h        |    1 -
 arch/mn10300/include/asm/bitops.h     |    1 -
 arch/parisc/include/asm/bitops.h      |    2 -
 arch/powerpc/include/asm/bitops.h     |   14 ------
 arch/s390/include/asm/bitops.h        |    1 -
 arch/sh/include/asm/bitops.h          |    1 -
 arch/sparc/include/asm/bitops_32.h    |    1 -
 arch/sparc/include/asm/bitops_64.h    |    2 -
 arch/tile/include/asm/bitops.h        |    1 -
 arch/x86/include/asm/bitops.h         |    2 -
 arch/xtensa/include/asm/bitops.h      |    1 -
 fs/minix/Kconfig                      |    8 +++
 fs/minix/minix.h                      |   79 +++++++++++++++++++++++++++++++++
 include/asm-generic/bitops.h          |    1 -
 include/asm-generic/bitops/minix-le.h |   15 ------
 include/asm-generic/bitops/minix.h    |   15 ------
 26 files changed, 87 insertions(+), 112 deletions(-)
 delete mode 100644 include/asm-generic/bitops/minix-le.h
 delete mode 100644 include/asm-generic/bitops/minix.h

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
diff --git a/arch/arm/include/asm/bitops.h b/arch/arm/include/asm/bitops.h
index ac2edb4..59a2a2b 100644
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
 
diff --git a/arch/avr32/include/asm/bitops.h b/arch/avr32/include/asm/bitops.h
index 73a163a..72444d9 100644
--- a/arch/avr32/include/asm/bitops.h
+++ b/arch/avr32/include/asm/bitops.h
@@ -301,6 +301,5 @@ static inline int ffs(unsigned long word)
 
 #include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-atomic.h>
-#include <asm-generic/bitops/minix-le.h>
 
 #endif /* __ASM_AVR32_BITOPS_H */
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
diff --git a/arch/m32r/include/asm/bitops.h b/arch/m32r/include/asm/bitops.h
index cdfb4c8..6300f22 100644
--- a/arch/m32r/include/asm/bitops.h
+++ b/arch/m32r/include/asm/bitops.h
@@ -268,7 +268,6 @@ static __inline__ int test_and_change_bit(int nr, volatile void * addr)
 
 #include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-atomic.h>
-#include <asm-generic/bitops/minix.h>
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/m68k/include/asm/bitops_mm.h b/arch/m68k/include/asm/bitops_mm.h
index f31ed5a..5f06275 100644
--- a/arch/m68k/include/asm/bitops_mm.h
+++ b/arch/m68k/include/asm/bitops_mm.h
@@ -325,36 +325,6 @@ static inline int __fls(int x)
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
 
-/* Bitmap functions for the minix filesystem */
-
-static inline int minix_find_first_zero_bit(const void *vaddr, unsigned size)
-{
-	const unsigned short *p = vaddr, *addr = vaddr;
-	unsigned short num;
-
-	if (!size)
-		return 0;
-
-	size = (size >> 4) + ((size & 15) > 0);
-	while (*p++ == 0xffff) {
-		if (--size == 0)
-			return (p - addr) << 4;
-	}
-
-	num = *--p;
-	return ((p - addr) << 4) + ffz(num);
-}
-
-#define minix_test_and_set_bit(nr, addr)	__test_and_set_bit((nr) ^ 16, (unsigned long *)(addr))
-#define minix_set_bit(nr,addr)			__set_bit((nr) ^ 16, (unsigned long *)(addr))
-#define minix_test_and_clear_bit(nr, addr)	__test_and_clear_bit((nr) ^ 16, (unsigned long *)(addr))
-
-static inline int minix_test_bit(int nr, const void *vaddr)
-{
-	const unsigned short *p = vaddr;
-	return (p[nr >> 4] & (1U << (nr & 15))) != 0;
-}
-
 /* Bitmap functions for little endian. */
 
 #define __set_le_bit(nr, addr)	\
diff --git a/arch/mips/include/asm/bitops.h b/arch/mips/include/asm/bitops.h
index 07ce5aa..6a2202c 100644
--- a/arch/mips/include/asm/bitops.h
+++ b/arch/mips/include/asm/bitops.h
@@ -706,7 +706,6 @@ static inline int ffs(int word)
 
 #include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-atomic.h>
-#include <asm-generic/bitops/minix.h>
 
 #endif /* __KERNEL__ */
 
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
diff --git a/arch/parisc/include/asm/bitops.h b/arch/parisc/include/asm/bitops.h
index 919d7ed..43c516f 100644
--- a/arch/parisc/include/asm/bitops.h
+++ b/arch/parisc/include/asm/bitops.h
@@ -234,6 +234,4 @@ static __inline__ int fls(int x)
 
 #endif	/* __KERNEL__ */
 
-#include <asm-generic/bitops/minix-le.h>
-
 #endif /* _PARISC_BITOPS_H */
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
diff --git a/arch/s390/include/asm/bitops.h b/arch/s390/include/asm/bitops.h
index 1bd1e11..e537613 100644
--- a/arch/s390/include/asm/bitops.h
+++ b/arch/s390/include/asm/bitops.h
@@ -842,7 +842,6 @@ static inline int find_next_le_bit(void *vaddr, unsigned long size,
 #define ext2_clear_bit_atomic(lock, nr, addr)     \
 	test_and_clear_le_bit((nr), (unsigned long *)(addr))
 
-#include <asm-generic/bitops/minix.h>
 
 #endif /* __KERNEL__ */
 
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
 
diff --git a/fs/minix/Kconfig b/fs/minix/Kconfig
index 0fd7ca9..6624684 100644
--- a/fs/minix/Kconfig
+++ b/fs/minix/Kconfig
@@ -15,3 +15,11 @@ config MINIX_FS
 	  module will be called minix.  Note that the file system of your root
 	  partition (the one containing the directory /) cannot be compiled as
 	  a module.
+
+config MINIX_FS_NATIVE_ENDIAN
+	def_bool MINIX_FS
+	depends on H8300 || M32R || MICROBLAZE || MIPS || S390 || SUPERH || SPARC || XTENSA || (M68K && !MMU)
+
+config MINIX_FS_BIG_ENDIAN_16BIT_INDEXED
+	def_bool MINIX_FS
+	depends on M68K && MMU
diff --git a/fs/minix/minix.h b/fs/minix/minix.h
index 407b1c8..9dfd62c 100644
--- a/fs/minix/minix.h
+++ b/fs/minix/minix.h
@@ -88,4 +88,83 @@ static inline struct minix_inode_info *minix_i(struct inode *inode)
 	return list_entry(inode, struct minix_inode_info, vfs_inode);
 }
 
+#if defined(CONFIG_MINIX_FS_NATIVE_ENDIAN) && \
+	defined(CONFIG_MINIX_FS_BIG_ENDIAN_16BIT_INDEXED)
+
+#error Minix file system byte order broken
+
+#elif defined(CONFIG_MINIX_FS_NATIVE_ENDIAN)
+
+/*
+ * big-endian 32 or 64 bit indexed bitmaps on big-endian system or
+ * little-endian bitmaps on little-endian system
+ */
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
+#elif defined(CONFIG_MINIX_FS_BIG_ENDIAN_16BIT_INDEXED)
+
+/*
+ * big-endian 16bit indexed bitmaps
+ */
+
+static inline int minix_find_first_zero_bit(const void *vaddr, unsigned size)
+{
+	const unsigned short *p = vaddr, *addr = vaddr;
+	unsigned short num;
+
+	if (!size)
+		return 0;
+
+	size = (size >> 4) + ((size & 15) > 0);
+	while (*p++ == 0xffff) {
+		if (--size == 0)
+			return (p - addr) << 4;
+	}
+
+	num = *--p;
+	return ((p - addr) << 4) + ffz(num);
+}
+
+#define minix_test_and_set_bit(nr, addr)	\
+	__test_and_set_bit((nr) ^ 16, (unsigned long *)(addr))
+#define minix_set_bit(nr, addr)	\
+	__set_bit((nr) ^ 16, (unsigned long *)(addr))
+#define minix_test_and_clear_bit(nr, addr)	\
+	__test_and_clear_bit((nr) ^ 16, (unsigned long *)(addr))
+
+static inline int minix_test_bit(int nr, const void *vaddr)
+{
+	const unsigned short *p = vaddr;
+	return (p[nr >> 4] & (1U << (nr & 15))) != 0;
+}
+
+#else
+
+/*
+ * little-endian bitmaps
+ */
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

