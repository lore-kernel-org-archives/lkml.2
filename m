Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514Ab0JFSGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 14:06:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50351 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab0JFSG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 14:06:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/8] arm: generalize IPC header files
Date: Wed,  6 Oct 2010 20:06:13 +0200
Message-Id: <1286388380-20646-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286388380-20646-1-git-send-email-arnd@arndb.de>
References: <1286388380-20646-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:IoxKzU0iCGf/Usg1jId6YaKayF500+679NyQMu0NquI
 xR1q+dPuMyeuH5oTiXXSahXK1f61Hxo1FUN+clnLtdURWZQJUM
 1Xlo1PrvaikvbYfzy9OMT6Ped99xv5426TEG7nUartM4i3trM+
 MeJ8orHzGhLLgMTYs14OGWyjSsl6nWl5mYE3oRlUhP0jBgBk85
 tYp4rlyFxONhsl/YSy2lw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IPC structure definitions in ARM are all compatible
with the generic definitions. Make them look identical
as a preparation for actually using the files in
include/asm-generic.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/include/asm/ipcbuf.h |   15 ++++++++++-----
 arch/arm/include/asm/msgbuf.h |   20 ++++++++++++++++++--
 arch/arm/include/asm/sembuf.h |   27 ++++++++++++++++++++-------
 arch/arm/include/asm/shmbuf.h |   21 +++++++++++++++++++--
 4 files changed, 67 insertions(+), 16 deletions(-)

diff --git a/arch/arm/include/asm/ipcbuf.h b/arch/arm/include/asm/ipcbuf.h
index 9768397..40e492d 100644
--- a/arch/arm/include/asm/ipcbuf.h
+++ b/arch/arm/include/asm/ipcbuf.h
@@ -2,24 +2,29 @@
 #define __ASMARM_IPCBUF_H
 
 /*
- * The ipc64_perm structure for arm architecture.
+ * The generic ipc64_perm structure:
  * Note extra padding because this structure is passed back and forth
  * between kernel and user space.
  *
+ * ipc64_perm was originally meant to be architecture specific, but
+ * everyone just ended up making identical copies without specific
+ * optimizations, so we may just as well all use the same one.
+ *
  * Pad space is left for:
- * - 32-bit mode_t and seq
+ * - 32-bit mode_t on architectures that only had 16 bit
+ * - 32-bit seq
  * - 2 miscellaneous 32-bit values
  */
 
-struct ipc64_perm
-{
+struct ipc64_perm {
 	__kernel_key_t		key;
 	__kernel_uid32_t	uid;
 	__kernel_gid32_t	gid;
 	__kernel_uid32_t	cuid;
 	__kernel_gid32_t	cgid;
 	__kernel_mode_t		mode;
-	unsigned short		__pad1;
+				/* pad if mode_t is u16: */
+	unsigned char		__pad1[4 - sizeof(__kernel_mode_t)];
 	unsigned short		seq;
 	unsigned short		__pad2;
 	unsigned long		__unused1;
diff --git a/arch/arm/include/asm/msgbuf.h b/arch/arm/include/asm/msgbuf.h
index 33b35b9..ca4e383 100644
--- a/arch/arm/include/asm/msgbuf.h
+++ b/arch/arm/include/asm/msgbuf.h
@@ -1,11 +1,21 @@
 #ifndef _ASMARM_MSGBUF_H
 #define _ASMARM_MSGBUF_H
 
-/* 
- * The msqid64_ds structure for arm architecture.
+#include <asm/bitsperlong.h>
+/*
+ * generic msqid64_ds structure.
+ *
  * Note extra padding because this structure is passed back and forth
  * between kernel and user space.
  *
+ * msqid64_ds was originally meant to be architecture specific, but
+ * everyone just ended up making identical copies without specific
+ * optimizations, so we may just as well all use the same one.
+ *
+ * 64 bit architectures typically define a 64 bit __kernel_time_t,
+ * so they do not need the first three padding words.
+ * On big-endian systems, the padding is in the wrong place.
+ *
  * Pad space is left for:
  * - 64-bit time_t to solve y2038 problem
  * - 2 miscellaneous 32-bit values
@@ -14,11 +24,17 @@
 struct msqid64_ds {
 	struct ipc64_perm msg_perm;
 	__kernel_time_t msg_stime;	/* last msgsnd time */
+#if __BITS_PER_LONG != 64
 	unsigned long	__unused1;
+#endif
 	__kernel_time_t msg_rtime;	/* last msgrcv time */
+#if __BITS_PER_LONG != 64
 	unsigned long	__unused2;
+#endif
 	__kernel_time_t msg_ctime;	/* last change time */
+#if __BITS_PER_LONG != 64
 	unsigned long	__unused3;
+#endif
 	unsigned long  msg_cbytes;	/* current number of bytes on queue */
 	unsigned long  msg_qnum;	/* number of messages in queue */
 	unsigned long  msg_qbytes;	/* max number of bytes on queue */
diff --git a/arch/arm/include/asm/sembuf.h b/arch/arm/include/asm/sembuf.h
index 1c02839..f7131b7 100644
--- a/arch/arm/include/asm/sembuf.h
+++ b/arch/arm/include/asm/sembuf.h
@@ -1,23 +1,36 @@
 #ifndef _ASMARM_SEMBUF_H
 #define _ASMARM_SEMBUF_H
 
-/* 
- * The semid64_ds structure for arm architecture.
+#include <asm/bitsperlong.h>
+
+/*
+ * The semid64_ds structure for x86 architecture.
  * Note extra padding because this structure is passed back and forth
  * between kernel and user space.
  *
+ * semid64_ds was originally meant to be architecture specific, but
+ * everyone just ended up making identical copies without specific
+ * optimizations, so we may just as well all use the same one.
+ *
+ * 64 bit architectures typically define a 64 bit __kernel_time_t,
+ * so they do not need the first two padding words.
+ * On big-endian systems, the padding is in the wrong place.
+ *
  * Pad space is left for:
  * - 64-bit time_t to solve y2038 problem
  * - 2 miscellaneous 32-bit values
  */
-
 struct semid64_ds {
-	struct ipc64_perm sem_perm;		/* permissions .. see ipc.h */
-	__kernel_time_t	sem_otime;		/* last semop time */
+	struct ipc64_perm sem_perm;	/* permissions .. see ipc.h */
+	__kernel_time_t	sem_otime;	/* last semop time */
+#if __BITS_PER_LONG != 64
 	unsigned long	__unused1;
-	__kernel_time_t	sem_ctime;		/* last change time */
+#endif
+	__kernel_time_t	sem_ctime;	/* last change time */
+#if __BITS_PER_LONG != 64
 	unsigned long	__unused2;
-	unsigned long	sem_nsems;		/* no. of semaphores in array */
+#endif
+	unsigned long	sem_nsems;	/* no. of semaphores in array */
 	unsigned long	__unused3;
 	unsigned long	__unused4;
 };
diff --git a/arch/arm/include/asm/shmbuf.h b/arch/arm/include/asm/shmbuf.h
index 2e5c67b..39b1ab0 100644
--- a/arch/arm/include/asm/shmbuf.h
+++ b/arch/arm/include/asm/shmbuf.h
@@ -1,11 +1,22 @@
 #ifndef _ASMARM_SHMBUF_H
 #define _ASMARM_SHMBUF_H
 
-/* 
- * The shmid64_ds structure for arm architecture.
+#include <asm/bitsperlong.h>
+
+/*
+ * The shmid64_ds structure for x86 architecture.
  * Note extra padding because this structure is passed back and forth
  * between kernel and user space.
  *
+ * shmid64_ds was originally meant to be architecture specific, but
+ * everyone just ended up making identical copies without specific
+ * optimizations, so we may just as well all use the same one.
+ *
+ * 64 bit architectures typically define a 64 bit __kernel_time_t,
+ * so they do not need the first two padding words.
+ * On big-endian systems, the padding is in the wrong place.
+ *
+ *
  * Pad space is left for:
  * - 64-bit time_t to solve y2038 problem
  * - 2 miscellaneous 32-bit values
@@ -15,11 +26,17 @@ struct shmid64_ds {
 	struct ipc64_perm	shm_perm;	/* operation perms */
 	size_t			shm_segsz;	/* size of segment (bytes) */
 	__kernel_time_t		shm_atime;	/* last attach time */
+#if __BITS_PER_LONG != 64
 	unsigned long		__unused1;
+#endif
 	__kernel_time_t		shm_dtime;	/* last detach time */
+#if __BITS_PER_LONG != 64
 	unsigned long		__unused2;
+#endif
 	__kernel_time_t		shm_ctime;	/* last change time */
+#if __BITS_PER_LONG != 64
 	unsigned long		__unused3;
+#endif
 	__kernel_pid_t		shm_cpid;	/* pid of creator */
 	__kernel_pid_t		shm_lpid;	/* pid of last operator */
 	unsigned long		shm_nattch;	/* no. of current attaches */
-- 
1.7.1

