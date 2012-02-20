Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab2BTVOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:14:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37285 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab2BTVOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:14:41 -0500
Date: Mon, 20 Feb 2012 13:13:52 -0800
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-8b3d1cda4f5ff0d7c2ae910ea8fd03493996912f@git.kernel.org>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, akpm@linux-foundation.org, tony.luck@intel.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        arnd@arndb.de, akpm@linux-foundation.org, tglx@linutronix.de,
        tony.luck@intel.com
In-Reply-To: <1328677745-20121-22-git-send-email-hpa@zytor.com>
References: <1328677745-20121-22-git-send-email-hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/types] posix_types: Remove fd_set macros
Git-Commit-ID: 8b3d1cda4f5ff0d7c2ae910ea8fd03493996912f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 20 Feb 2012 13:14:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b3d1cda4f5ff0d7c2ae910ea8fd03493996912f
Gitweb:     http://git.kernel.org/tip/8b3d1cda4f5ff0d7c2ae910ea8fd03493996912f
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Tue, 7 Feb 2012 21:09:05 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 14 Feb 2012 12:47:21 -0800

posix_types: Remove fd_set macros

<asm/posix_types.h> includes a set of macros that operate on file
descriptors.  Way long ago those were exported to user space, but
nowadays they are #ifdef __KERNEL__.

However, they are nothing but standard (nonatomic) bit operations, and
we already have optimized versions of bit operations in the kernel.
We can't include <linux/bitops.h> in <asm/posix_types.h> but we can
move the definitions to <linux/time.h> and define them there in terms
of standard kernel bitops.

[ v2: folds the following fixes in:

  a) Stray space in __FD_SET(), reported by Andrew Morton
  b) #include <linux/string.h> needed for memset(), reported by Tony Luck ]

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Link: http://lkml.kernel.org/r/1328677745-20121-22-git-send-email-hpa@zytor.com
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/asm-generic/posix_types.h |   72 -------------------------------------
 include/linux/time.h              |   24 ++++++++++++
 2 files changed, 24 insertions(+), 72 deletions(-)

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
index b306178..93277a0 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -4,8 +4,11 @@
 #include <linux/types.h>
 
 #ifdef __KERNEL__
+# include <linux/bitops.h>
 # include <linux/cache.h>
+# include <linux/posix_types.h>
 # include <linux/seqlock.h>
+# include <linux/string.h>
 # include <linux/math64.h>
 #endif
 
@@ -256,6 +259,27 @@ static __always_inline void timespec_add_ns(struct timespec *a, u64 ns)
 	a->tv_sec += __iter_div_u64_rem(a->tv_nsec + ns, NSEC_PER_SEC, &ns);
 	a->tv_nsec = ns;
 }
+
+static inline void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
+{
+	__set_bit(__fd, __fdsetp->fds_bits);
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
