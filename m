Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529Ab0JFSGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 14:06:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53851 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759448Ab0JFSGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 14:06:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5/8] arm: generalize asm/posix_types.h
Date: Wed,  6 Oct 2010 20:06:17 +0200
Message-Id: <1286388380-20646-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286388380-20646-1-git-send-email-arnd@arndb.de>
References: <1286388380-20646-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:d43uJXTNEgHkcRHVuwM9ZFMUEanHyXLNmrmgNh0uXDW
 vJsXORHFBdvX18gVlaHugx8/2IR608hAEQCVx6uO298TIILvVJ
 nd6W8Nwpy8ZAoR0NijS+jcTsQTgVWCGARpWcxzismDPwMkfLFe
 O8vJxYKcZ991qcaq5tf9jcUh2UcxrEF8bjZ+V48SNrVFJqowCn
 +Xm18ful0b4m0AgPBtvcg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the arm version of asm/posix_types.h a variant
of the asm-generic version, which allows overriding parts
of the type definitions while using the common parts.

The definitions that still need to differ to maintain
the user space ABI are:

__kernel_mode_t
__kernel_nlink_t
__kernel_ipc_pid_t
__kernel_uid_t
__kernel_gid_t
__kernel_uid32_t
__kernel_gid32_t
__kernel_old_uid_t
__kernel_old_gid_t
__kernel_old_dev_t

These get defined to their traditional values before
the common code.

The definitions of __FD_SET/__FD_CLR__FD_ISSET/__FD_ZERO
all get replaced by the slightly different definitions
from the asm-generic file, which are more type safe.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/include/asm/posix_types.h |  207 ++++++++++++++++++++++++++++++------
 1 files changed, 172 insertions(+), 35 deletions(-)

diff --git a/arch/arm/include/asm/posix_types.h b/arch/arm/include/asm/posix_types.h
index 2446d23..558cf4b 100644
--- a/arch/arm/include/asm/posix_types.h
+++ b/arch/arm/include/asm/posix_types.h
@@ -14,64 +14,201 @@
 #define __ARCH_ARM_POSIX_TYPES_H
 
 /*
- * This file is generally used by user-level software, so you need to
- * be a little careful about namespace pollution etc.  Also, we cannot
- * assume GCC is being used.
+ * These are ARM specific overrides for types that
+ * we traditionally define differently from the
+ * generic types.
  */
-
-typedef unsigned long		__kernel_ino_t;
 typedef unsigned short		__kernel_mode_t;
+#define __kernel_mode_t		__kernel_mode_t
+
 typedef unsigned short		__kernel_nlink_t;
-typedef long			__kernel_off_t;
-typedef int			__kernel_pid_t;
+#define __kernel_nlink_t	__kernel_nlink_t
+
 typedef unsigned short		__kernel_ipc_pid_t;
+#define __kernel_ipc_pid_t	__kernel_ipc_pid_t
+
 typedef unsigned short		__kernel_uid_t;
+#define __kernel_uid_t		__kernel_uid_t
+
 typedef unsigned short		__kernel_gid_t;
-typedef unsigned int		__kernel_size_t;
-typedef int			__kernel_ssize_t;
-typedef int			__kernel_ptrdiff_t;
-typedef long			__kernel_time_t;
-typedef long			__kernel_suseconds_t;
-typedef long			__kernel_clock_t;
-typedef int			__kernel_timer_t;
-typedef int			__kernel_clockid_t;
-typedef int			__kernel_daddr_t;
-typedef char *			__kernel_caddr_t;
-typedef unsigned short		__kernel_uid16_t;
-typedef unsigned short		__kernel_gid16_t;
+#define __kernel_gid_t		__kernel_gid_t
+
 typedef unsigned int		__kernel_uid32_t;
+#define __kernel_uid32_t	__kernel_uid32_t
+
 typedef unsigned int		__kernel_gid32_t;
+#define __kernel_gid32_t	__kernel_gid32_t
 
 typedef unsigned short		__kernel_old_uid_t;
+#define __kernel_old_uid_t	__kernel_old_uid_t
+
 typedef unsigned short		__kernel_old_gid_t;
+#define __kernel_old_gid_t	__kernel_old_gid_t
+
 typedef unsigned short		__kernel_old_dev_t;
+#define __kernel_old_dev_t	__kernel_old_dev_t
+
+/* generic contents from here */
+
+#include <asm/bitsperlong.h>
+/*
+ * This file is generally used by user-level software, so you need to
+ * be a little careful about namespace pollution etc.
+ *
+ * First the types that are often defined in different ways across
+ * architectures, so that you can override them.
+ */
+
+#ifndef __kernel_ino_t
+typedef unsigned long	__kernel_ino_t;
+#endif
+
+#ifndef __kernel_mode_t
+typedef unsigned int	__kernel_mode_t;
+#endif
+
+#ifndef __kernel_nlink_t
+typedef unsigned long	__kernel_nlink_t;
+#endif
+
+#ifndef __kernel_pid_t
+typedef int		__kernel_pid_t;
+#endif
+
+#ifndef __kernel_ipc_pid_t
+typedef int		__kernel_ipc_pid_t;
+#endif
+
+#ifndef __kernel_uid_t
+typedef unsigned int	__kernel_uid_t;
+typedef unsigned int	__kernel_gid_t;
+#endif
+
+#ifndef __kernel_suseconds_t
+typedef long		__kernel_suseconds_t;
+#endif
+
+#ifndef __kernel_daddr_t
+typedef int		__kernel_daddr_t;
+#endif
 
-#ifdef __GNUC__
-typedef long long		__kernel_loff_t;
+#ifndef __kernel_uid32_t
+typedef __kernel_uid_t	__kernel_uid32_t;
+typedef __kernel_gid_t	__kernel_gid32_t;
 #endif
 
+#ifndef __kernel_old_uid_t
+typedef __kernel_uid_t	__kernel_old_uid_t;
+typedef __kernel_gid_t	__kernel_old_gid_t;
+#endif
+
+#ifndef __kernel_old_dev_t
+typedef unsigned int	__kernel_old_dev_t;
+#endif
+
+/*
+ * Most 32 bit architectures use "unsigned int" size_t,
+ * and all 64 bit architectures use "unsigned long" size_t.
+ */
+#ifndef __kernel_size_t
+#if __BITS_PER_LONG != 64
+typedef unsigned int	__kernel_size_t;
+typedef int		__kernel_ssize_t;
+typedef int		__kernel_ptrdiff_t;
+#else
+typedef unsigned long	__kernel_size_t;
+typedef long		__kernel_ssize_t;
+typedef long		__kernel_ptrdiff_t;
+#endif
+#endif
+
+/*
+ * anything below here should be completely generic
+ */
+typedef long		__kernel_off_t;
+typedef long long	__kernel_loff_t;
+typedef long		__kernel_time_t;
+typedef long		__kernel_clock_t;
+typedef int		__kernel_timer_t;
+typedef int		__kernel_clockid_t;
+typedef char *		__kernel_caddr_t;
+typedef unsigned short	__kernel_uid16_t;
+typedef unsigned short	__kernel_gid16_t;
+
 typedef struct {
 	int	val[2];
 } __kernel_fsid_t;
 
-#if defined(__KERNEL__)
+#ifdef __KERNEL__
 
-#undef	__FD_SET
-#define __FD_SET(fd, fdsetp) \
-		(((fd_set *)(fdsetp))->fds_bits[(fd) >> 5] |= (1<<((fd) & 31)))
+#undef __FD_SET
+static inline void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
+{
+	unsigned long __tmp = __fd / __NFDBITS;
+	unsigned long __rem = __fd % __NFDBITS;
+	__fdsetp->fds_bits[__tmp] |= (1UL<<__rem);
+}
 
-#undef	__FD_CLR
-#define __FD_CLR(fd, fdsetp) \
-		(((fd_set *)(fdsetp))->fds_bits[(fd) >> 5] &= ~(1<<((fd) & 31)))
+#undef __FD_CLR
+static inline void __FD_CLR(unsigned long __fd, __kernel_fd_set *__fdsetp)
+{
+	unsigned long __tmp = __fd / __NFDBITS;
+	unsigned long __rem = __fd % __NFDBITS;
+	__fdsetp->fds_bits[__tmp] &= ~(1UL<<__rem);
+}
 
-#undef	__FD_ISSET
-#define __FD_ISSET(fd, fdsetp) \
-		((((fd_set *)(fdsetp))->fds_bits[(fd) >> 5] & (1<<((fd) & 31))) != 0)
+#undef __FD_ISSET
+static inline int __FD_ISSET(unsigned long __fd, const __kernel_fd_set *__p)
+{
+	unsigned long __tmp = __fd / __NFDBITS;
+	unsigned long __rem = __fd % __NFDBITS;
+	return (__p->fds_bits[__tmp] & (1UL<<__rem)) != 0;
+}
 
-#undef	__FD_ZERO
-#define __FD_ZERO(fdsetp) \
-		(memset (fdsetp, 0, sizeof (*(fd_set *)(fdsetp))))
+/*
+ * This will unroll the loop for the normal constant case (8 ints,
+ * for a 256-bit fd_set)
+ */
+#undef __FD_ZERO
+static inline void __FD_ZERO(__kernel_fd_set *__p)
+{
+	unsigned long *__tmp = __p->fds_bits;
+	int __i;
 
-#endif
+	if (__builtin_constant_p(__FDSET_LONGS)) {
+		switch (__FDSET_LONGS) {
+		case 16:
+			__tmp[ 0] = 0; __tmp[ 1] = 0;
+			__tmp[ 2] = 0; __tmp[ 3] = 0;
+			__tmp[ 4] = 0; __tmp[ 5] = 0;
+			__tmp[ 6] = 0; __tmp[ 7] = 0;
+			__tmp[ 8] = 0; __tmp[ 9] = 0;
+			__tmp[10] = 0; __tmp[11] = 0;
+			__tmp[12] = 0; __tmp[13] = 0;
+			__tmp[14] = 0; __tmp[15] = 0;
+			return;
+
+		case 8:
+			__tmp[ 0] = 0; __tmp[ 1] = 0;
+			__tmp[ 2] = 0; __tmp[ 3] = 0;
+			__tmp[ 4] = 0; __tmp[ 5] = 0;
+			__tmp[ 6] = 0; __tmp[ 7] = 0;
+			return;
+
+		case 4:
+			__tmp[ 0] = 0; __tmp[ 1] = 0;
+			__tmp[ 2] = 0; __tmp[ 3] = 0;
+			return;
+		}
+	}
+	__i = __FDSET_LONGS;
+	while (__i) {
+		__i--;
+		*__tmp = 0;
+		__tmp++;
+	}
+}
+
+#endif /* __KERNEL__ */
 
 #endif
-- 
1.7.1

