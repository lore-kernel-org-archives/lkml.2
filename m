Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934546Ab0J1UUv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 16:20:51 -0400
Received: from king.tilera.com ([72.1.168.226]:23226 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858Ab0J1UUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 16:20:44 -0400
Message-Id: <201010282020.o9SKKe4Y007068@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 28 Oct 2010 16:07:07 -0400
Subject: [PATCH] asm-generic/stat.h: support 64-bit file time_t for stat()
In-Reply-To: <201010271612.13950.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Cc: Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>,
        Michal Simek <monstr@monstr.eu>
X-OriginalArrivalTime: 28 Oct 2010 20:20:42.0399 (UTC) FILETIME=[983A2AF0:01CB76DD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing asm-generic/stat.h specifies st_mtime, etc., as a 32-value,
and works well for 32-bit architectures (currently microblaze, score,
and 32-bit tile).  However, for 64-bit architectures it isn't sufficient
to return 32 bits of time_t; this isn't good insurance against the 2037
rollover.  (It also makes glibc support less convenient, since we can't
use glibc's handy STAT_IS_KERNEL_STAT mode.)

This change extends the two "timespec" fields for each of the three atime,
mtime, and ctime fields from "int" to "long".  As a result, on 32-bit
platforms nothing changes, and 64-bit platforms will now work as expected.

The only wrinkle is 32-bit userspace under 64-bit kernels taking advantage
of COMPAT mode.  For these, we leave the "struct stat64" definitions with
the "int" versions of the time_t and nsec fields, so that architectures
can implement compat_sys_stat64() and friends with sys_stat64(), etc.,
and get the expected 32-bit structure layout.  This requires a
field-by-field copy in the kernel, implemented by the code guarded
under __ARCH_WANT_STAT64.

This does mean that the shape of the "struct stat" and "struct stat64"
structures is different on a 64-bit kernel, but only one of the two
structures should ever be used by any given process: "struct stat"
is meant for 64-bit userspace only, and "struct stat64" for 32-bit
userspace only.  (On a 32-bit kernel the two structures continue to have
the same shape, since "long" is 32 bits.)

The alternative is keeping the two structures the same shape on 64-bit
kernels, which means a 64-bit time_t in "struct stat64" for 32-bit
processes.  This is a little unnatural since 32-bit userspace can't
do anything with 64 bits of time_t information, since time_t is just
"long", not "int64_t"; and in any case 32-bit userspace might expect
to be running under a 32-bit kernel, which can't provide the high 32
bits anyway.  In the case of a 32-bit kernel we'd then be extending the
kernel's 32-bit time_t to 64 bits, then truncating it back to 32 bits
again in userspace, for no particular reason.  And, as mentioned above,
if we have 64-bit time_t for 32-bit processes we can't easily use glibc's
STAT_IS_KERNEL_STAT, since glibc's stat structure requires an embedded
"struct timespec", which is a pair of "long" (32-bit) values in a 32-bit
userspace.  "Inventive" solutions are possible, but are pretty hacky.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/stat.h   |    3 +++
 arch/tile/include/asm/unistd.h |    1 +
 arch/tile/kernel/compat.c      |   10 +++++-----
 include/asm-generic/stat.h     |   14 +++++++-------
 4 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/arch/tile/include/asm/stat.h b/arch/tile/include/asm/stat.h
index 3dc90fa..b16e5db 100644
--- a/arch/tile/include/asm/stat.h
+++ b/arch/tile/include/asm/stat.h
@@ -1 +1,4 @@
+#ifdef CONFIG_COMPAT
+#define __ARCH_WANT_STAT64	/* Used for compat_sys_stat64() etc. */
+#endif
 #include <asm-generic/stat.h>
diff --git a/arch/tile/include/asm/unistd.h b/arch/tile/include/asm/unistd.h
index f2e3ff4..b35c2db 100644
--- a/arch/tile/include/asm/unistd.h
+++ b/arch/tile/include/asm/unistd.h
@@ -41,6 +41,7 @@ __SYSCALL(__NR_cmpxchg_badaddr, sys_cmpxchg_badaddr)
 #ifdef CONFIG_COMPAT
 #define __ARCH_WANT_SYS_LLSEEK
 #endif
+#define __ARCH_WANT_SYS_NEWFSTATAT
 #endif
 
 #endif /* _ASM_TILE_UNISTD_H */
diff --git a/arch/tile/kernel/compat.c b/arch/tile/kernel/compat.c
index 77739cd..67617a0 100644
--- a/arch/tile/kernel/compat.c
+++ b/arch/tile/kernel/compat.c
@@ -148,11 +148,11 @@ long tile_compat_sys_msgrcv(int msqid,
 #define compat_sys_readahead sys32_readahead
 #define compat_sys_sync_file_range compat_sys_sync_file_range2
 
-/* The native 64-bit "struct stat" matches the 32-bit "struct stat64". */
-#define compat_sys_stat64 sys_newstat
-#define compat_sys_lstat64 sys_newlstat
-#define compat_sys_fstat64 sys_newfstat
-#define compat_sys_fstatat64 sys_newfstatat
+/* We leverage the "struct stat64" type for 32-bit time_t/nsec. */
+#define compat_sys_stat64 sys_stat64
+#define compat_sys_lstat64 sys_lstat64
+#define compat_sys_fstat64 sys_fstat64
+#define compat_sys_fstatat64 sys_fstatat64
 
 /* The native sys_ptrace dynamically handles compat binaries. */
 #define compat_sys_ptrace sys_ptrace
diff --git a/include/asm-generic/stat.h b/include/asm-generic/stat.h
index 47e6417..bd8cad2 100644
--- a/include/asm-generic/stat.h
+++ b/include/asm-generic/stat.h
@@ -33,18 +33,18 @@ struct stat {
 	int		st_blksize;	/* Optimal block size for I/O.  */
 	int		__pad2;
 	long		st_blocks;	/* Number 512-byte blocks allocated. */
-	int		st_atime;	/* Time of last access.  */
-	unsigned int	st_atime_nsec;
-	int		st_mtime;	/* Time of last modification.  */
-	unsigned int	st_mtime_nsec;
-	int		st_ctime;	/* Time of last status change.  */
-	unsigned int	st_ctime_nsec;
+	long		st_atime;	/* Time of last access.  */
+	unsigned long	st_atime_nsec;
+	long		st_mtime;	/* Time of last modification.  */
+	unsigned long	st_mtime_nsec;
+	long		st_ctime;	/* Time of last status change.  */
+	unsigned long	st_ctime_nsec;
 	unsigned int	__unused4;
 	unsigned int	__unused5;
 };
 
-#if __BITS_PER_LONG != 64
 /* This matches struct stat64 in glibc2.1. Only used for 32 bit. */
+#if __BITS_PER_LONG != 64 || defined(__ARCH_WANT_STAT64)
 struct stat64 {
 	unsigned long long st_dev;	/* Device.  */
 	unsigned long long st_ino;	/* File serial number.  */
-- 
1.6.5.2

