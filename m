Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933422Ab1ERSH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:07:26 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:26559 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933365Ab1ERSHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:07:15 -0400
Message-Id: <201105181807.p4II7BNZ015223@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 17 May 2011 15:52:22 -0400
Subject: [PATCH] arch/tile: cleanups for tilegx compat mode
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 18 May 2011 18:07:11.0915 (UTC) FILETIME=[690CCFB0:01CC1586]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These changes make the syscall table line up correctly for
tilegx compat mode, and remove the stale sys32_fadvise64() function,
which isn't actually used by any syscall table.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/unistd.h |    2 +-
 arch/tile/kernel/compat.c      |   11 -----------
 arch/tile/kernel/sys.c         |    9 ---------
 3 files changed, 1 insertions(+), 21 deletions(-)

diff --git a/arch/tile/include/asm/unistd.h b/arch/tile/include/asm/unistd.h
index b35c2db..f70bf1c 100644
--- a/arch/tile/include/asm/unistd.h
+++ b/arch/tile/include/asm/unistd.h
@@ -15,7 +15,7 @@
 #if !defined(_ASM_TILE_UNISTD_H) || defined(__SYSCALL)
 #define _ASM_TILE_UNISTD_H
 
-#ifndef __LP64__
+#if !defined(__LP64__) || defined(__SYSCALL_COMPAT)
 /* Use the flavor of this syscall that matches the 32-bit API better. */
 #define __ARCH_WANT_SYNC_FILE_RANGE2
 #endif
diff --git a/arch/tile/kernel/compat.c b/arch/tile/kernel/compat.c
index e35a397..bf5e9d7 100644
--- a/arch/tile/kernel/compat.c
+++ b/arch/tile/kernel/compat.c
@@ -142,19 +142,8 @@ long tile_compat_sys_msgrcv(int msqid,
 #define compat_sys_msgsnd tile_compat_sys_msgsnd
 
 /* See comments in sys.c */
-#define compat_sys_fadvise64 sys32_fadvise64
 #define compat_sys_fadvise64_64 sys32_fadvise64_64
 #define compat_sys_readahead sys32_readahead
-#define compat_sys_sync_file_range compat_sys_sync_file_range2
-
-/* We leverage the "struct stat64" type for 32-bit time_t/nsec. */
-#define compat_sys_stat64 sys_stat64
-#define compat_sys_lstat64 sys_lstat64
-#define compat_sys_fstat64 sys_fstat64
-#define compat_sys_fstatat64 sys_fstatat64
-
-/* The native sys_ptrace dynamically handles compat binaries. */
-#define compat_sys_ptrace sys_ptrace
 
 /* Call the trampolines to manage pt_regs where necessary. */
 #define compat_sys_execve _compat_sys_execve
diff --git a/arch/tile/kernel/sys.c b/arch/tile/kernel/sys.c
index e2187d2..cb44ba7 100644
--- a/arch/tile/kernel/sys.c
+++ b/arch/tile/kernel/sys.c
@@ -56,13 +56,6 @@ ssize_t sys32_readahead(int fd, u32 offset_lo, u32 offset_hi, u32 count)
 	return sys_readahead(fd, ((loff_t)offset_hi << 32) | offset_lo, count);
 }
 
-long sys32_fadvise64(int fd, u32 offset_lo, u32 offset_hi,
-		     u32 len, int advice)
-{
-	return sys_fadvise64_64(fd, ((loff_t)offset_hi << 32) | offset_lo,
-				len, advice);
-}
-
 int sys32_fadvise64_64(int fd, u32 offset_lo, u32 offset_hi,
 		       u32 len_lo, u32 len_hi, int advice)
 {
@@ -103,10 +96,8 @@ SYSCALL_DEFINE6(mmap, unsigned long, addr, unsigned long, len,
 
 #ifndef __tilegx__
 /* See comments at the top of the file. */
-#define sys_fadvise64 sys32_fadvise64
 #define sys_fadvise64_64 sys32_fadvise64_64
 #define sys_readahead sys32_readahead
-#define sys_sync_file_range sys_sync_file_range2
 #endif
 
 /* Call the trampolines to manage pt_regs where necessary. */
-- 
1.6.5.2

