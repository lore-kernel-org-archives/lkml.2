Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab2BHFKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 00:10:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44030 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab2BHFJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 00:09:49 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 21/21] posix_types: Remove fd_set macros
Date: Tue,  7 Feb 2012 21:09:05 -0800
Message-Id: <1328677745-20121-22-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1328677745-20121-1-git-send-email-hpa@zytor.com>
References: <1328677745-20121-1-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

<asm/posix_types.h> includes a set of macros that operate on file
descriptors.  Way long ago those were exported to user space, but
nowadays they are #ifdef __KERNEL__.

However, they are nothing but standard (nonatomic) bit operations, and
we already have optimized versions of bit operations in the kernel.
We can't include <linux/bitops.h> in <asm/posix_types.h> but we can
move the definitions to <linux/time.h> and define them there in terms
of standard kernel bitops.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/posix_types.h |   72 -------------------------------------
 include/linux/time.h              |   23 ++++++++++++
 2 files changed, 23 insertions(+), 72 deletions(-)

diff --git a/include/asm-generic/posix_types.h b/include/asm-generic/posix_types.h
index ac21760..e294fe6 100644
--- a/include/asm-generic/posix_types.h
+++ b/include/asm-generic/posix_types.h
@@ -92,76 +92,4 @@ typedef char *		__kernel_caddr_t;
 typedef unsigned short	__kernel_uid16_t;
 typedef unsigned short	__kernel_gid16_t;
 
-#ifdef __KERNEL__
-
-#undef __FD_SET
-static inline void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
-{
-	unsigned long __tmp = __fd / __NFDBITS;
-	unsigned long __rem = __fd % __NFDBITS;
-	__fdsetp->fds_bits[__tmp] |= (1UL<<__rem);
-}
-
-#undef __FD_CLR
-static inline void __FD_CLR(unsigned long __fd, __kernel_fd_set *__fdsetp)
-{
-	unsigned long __tmp = __fd / __NFDBITS;
-	unsigned long __rem = __fd % __NFDBITS;
-	__fdsetp->fds_bits[__tmp] &= ~(1UL<<__rem);
-}
-
-#undef __FD_ISSET
-static inline int __FD_ISSET(unsigned long __fd, const __kernel_fd_set *__p)
-{
-	unsigned long __tmp = __fd / __NFDBITS;
-	unsigned long __rem = __fd % __NFDBITS;
-	return (__p->fds_bits[__tmp] & (1UL<<__rem)) != 0;
-}
-
-/*
- * This will unroll the loop for the normal constant case (8 ints,
- * for a 256-bit fd_set)
- */
-#undef __FD_ZERO
-static inline void __FD_ZERO(__kernel_fd_set *__p)
-{
-	unsigned long *__tmp = __p->fds_bits;
-	int __i;
-
-	if (__builtin_constant_p(__FDSET_LONGS)) {
-		switch (__FDSET_LONGS) {
-		case 16:
-			__tmp[ 0] = 0; __tmp[ 1] = 0;
-			__tmp[ 2] = 0; __tmp[ 3] = 0;
-			__tmp[ 4] = 0; __tmp[ 5] = 0;
-			__tmp[ 6] = 0; __tmp[ 7] = 0;
-			__tmp[ 8] = 0; __tmp[ 9] = 0;
-			__tmp[10] = 0; __tmp[11] = 0;
-			__tmp[12] = 0; __tmp[13] = 0;
-			__tmp[14] = 0; __tmp[15] = 0;
-			return;
-
-		case 8:
-			__tmp[ 0] = 0; __tmp[ 1] = 0;
-			__tmp[ 2] = 0; __tmp[ 3] = 0;
-			__tmp[ 4] = 0; __tmp[ 5] = 0;
-			__tmp[ 6] = 0; __tmp[ 7] = 0;
-			return;
-
-		case 4:
-			__tmp[ 0] = 0; __tmp[ 1] = 0;
-			__tmp[ 2] = 0; __tmp[ 3] = 0;
-			return;
-		}
-	}
-	__i = __FDSET_LONGS;
-	while (__i) {
-		__i--;
-		*__tmp = 0;
-		__tmp++;
-	}
-}
-
-#endif /* __KERNEL__ */
-
 #endif /* __ASM_GENERIC_POSIX_TYPES_H */
diff --git a/include/linux/time.h b/include/linux/time.h
index b306178..ca9b1e6 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -4,7 +4,9 @@
 #include <linux/types.h>
 
 #ifdef __KERNEL__
+# include <linux/bitops.h>
 # include <linux/cache.h>
+# include <linux/posix_types.h>
 # include <linux/seqlock.h>
 # include <linux/math64.h>
 #endif
@@ -256,6 +258,27 @@ static __always_inline void timespec_add_ns(struct timespec *a, u64 ns)
 	a->tv_sec += __iter_div_u64_rem(a->tv_nsec + ns, NSEC_PER_SEC, &ns);
 	a->tv_nsec = ns;
 }
+
+static inline void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
+{
+	__set_bit( __fd, __fdsetp->fds_bits);
+}
+
+static inline void __FD_CLR(unsigned long __fd, __kernel_fd_set *__fdsetp)
+{
+	__clear_bit(__fd, __fdsetp->fds_bits);
+}
+
+static inline int __FD_ISSET(unsigned long __fd, const __kernel_fd_set *__fdsetp)
+{
+	return test_bit(__fd, __fdsetp->fds_bits);
+}
+
+static inline void __FD_ZERO(__kernel_fd_set *__fdsetp)
+{
+	memset(__fdsetp->fds_bits, 0, sizeof __fdsetp->fds_bits);
+}
+
 #endif /* __KERNEL__ */
 
 #define NFDBITS			__NFDBITS
-- 
1.7.6.5

