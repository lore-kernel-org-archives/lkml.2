Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab1LIPgL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 10:36:11 -0500
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:38629 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab1LIPgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 10:36:09 -0500
Message-Id: <201112091536.pB9Fa5f7002738@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 9 Dec 2011 10:29:07 -0500
Subject: [PATCH] ipc: provide generic compat versions of IPC syscalls
To: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "J. Bruce Fields" <bfields@redhat.com>, NeilBrown <neilb@suse.de>
X-OriginalArrivalTime: 09 Dec 2011 15:36:08.0180 (UTC) FILETIME=[45535B40:01CCB688]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several of the existing compat IPC syscalls are really just i386
compatibility, not generic compatibility.  semctl() expects a
pointer to the fourth argument, instead of the fourth argument itself.
msgsnd(), msgrcv() and shmat() expect arguments in different order.

This change adds an __ARCH_WANT_GENERIC_COMPAT_IPC define that
can be set in <asm/compat.h> to indicate that the IPC compat code
should provide exactly the same APIs to "compat" users as the
regular IPC code does to regular users.  In addition, it sets up
to always request the IPC_64 mode, since that's what the <asm-generic>
APIs always use.

The workaround code in "tile" for msgsnd() and msgrcv() is removed
with this change; it fixes the bug that shmat() and semctl() were
not also being properly converted to expect generic compat IPC.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
Back in May 2010, Arnd Bergmann wrote in reference to compat_sys_msgsnd():

> Fascinating, the existing functions are useless, because no architecture
> is actually able to call them directly from their sys_call_table.
> We should replace those with your version and change the other architectures
> accordingly.

Finding the shmat/semctl bugs in tilegx finally motivated me to go and
do the thing he suggested 18 months ago. :-)  Whether someone wants to
go a step further and actually move the i386-ish versions into arch/x86
I will leave to the x86 platform maintainers; I also don't know whether,
perhaps, some other platforms are actually using the i386 convention.

 arch/tile/include/asm/compat.h |    3 ++
 arch/tile/kernel/compat.c      |   43 ------------------------
 include/linux/compat.h         |   11 ++++++-
 ipc/compat.c                   |   70 ++++++++++++++++++++++++++++++++++++---
 4 files changed, 77 insertions(+), 50 deletions(-)

diff --git a/arch/tile/include/asm/compat.h b/arch/tile/include/asm/compat.h
index bf95f55..efe3c00 100644
--- a/arch/tile/include/asm/compat.h
+++ b/arch/tile/include/asm/compat.h
@@ -21,6 +21,9 @@
 #include <linux/types.h>
 #include <linux/sched.h>
 
+/* Use more generic variants of SysV IPC compatibility syscalls. */
+#define __ARCH_WANT_GENERIC_COMPAT_IPC
+
 #define COMPAT_USER_HZ	100
 
 /* "long" and pointer-based types are different. */
diff --git a/arch/tile/kernel/compat.c b/arch/tile/kernel/compat.c
index bf5e9d7..d67459b 100644
--- a/arch/tile/kernel/compat.c
+++ b/arch/tile/kernel/compat.c
@@ -16,7 +16,6 @@
 #define __SYSCALL_COMPAT
 
 #include <linux/compat.h>
-#include <linux/msg.h>
 #include <linux/syscalls.h>
 #include <linux/kdev_t.h>
 #include <linux/fs.h>
@@ -95,52 +94,10 @@ long compat_sys_sched_rr_get_interval(compat_pid_t pid,
 	return ret;
 }
 
-/*
- * The usual compat_sys_msgsnd() and _msgrcv() seem to be assuming
- * some different calling convention than our normal 32-bit tile code.
- */
-
-/* Already defined in ipc/compat.c, but we need it here. */
-struct compat_msgbuf {
-	compat_long_t mtype;
-	char mtext[1];
-};
-
-long tile_compat_sys_msgsnd(int msqid,
-			    struct compat_msgbuf __user *msgp,
-			    size_t msgsz, int msgflg)
-{
-	compat_long_t mtype;
-
-	if (get_user(mtype, &msgp->mtype))
-		return -EFAULT;
-	return do_msgsnd(msqid, mtype, msgp->mtext, msgsz, msgflg);
-}
-
-long tile_compat_sys_msgrcv(int msqid,
-			    struct compat_msgbuf __user *msgp,
-			    size_t msgsz, long msgtyp, int msgflg)
-{
-	long err, mtype;
-
-	err =  do_msgrcv(msqid, &mtype, msgp->mtext, msgsz, msgtyp, msgflg);
-	if (err < 0)
-		goto out;
-
-	if (put_user(mtype, &msgp->mtype))
-		err = -EFAULT;
- out:
-	return err;
-}
-
 /* Provide the compat syscall number to call mapping. */
 #undef __SYSCALL
 #define __SYSCALL(nr, call) [nr] = (call),
 
-/* The generic versions of these don't work for Tile. */
-#define compat_sys_msgrcv tile_compat_sys_msgrcv
-#define compat_sys_msgsnd tile_compat_sys_msgsnd
-
 /* See comments in sys.c */
 #define compat_sys_fadvise64_64 sys32_fadvise64_64
 #define compat_sys_readahead sys32_readahead
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 66ed067..ce26de5 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -234,13 +234,22 @@ asmlinkage long
 compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
 			   compat_size_t __user *len_ptr);
 
+#ifdef __ARCH_WANT_GENERIC_COMPAT_IPC
+long compat_sys_semctl(int semid, int semnum, int cmd, int arg);
+long compat_sys_msgsnd(int msqid, struct compat_msgbuf __user *msgp,
+		size_t msgsz, int msgflg);
+long compat_sys_msgrcv(int msqid, struct compat_msgbuf __user *msgp,
+		size_t msgsz, long msgtyp, int msgflg);
+long compat_sys_shmat(int shmid, compat_uptr_t shmaddr, int shmflg);
+#else
 long compat_sys_semctl(int first, int second, int third, void __user *uptr);
 long compat_sys_msgsnd(int first, int second, int third, void __user *uptr);
 long compat_sys_msgrcv(int first, int second, int msgtyp, int third,
 		int version, void __user *uptr);
-long compat_sys_msgctl(int first, int second, void __user *uptr);
 long compat_sys_shmat(int first, int second, compat_uptr_t third, int version,
 		void __user *uptr);
+#endif
+long compat_sys_msgctl(int first, int second, void __user *uptr);
 long compat_sys_shmctl(int first, int second, void __user *uptr);
 long compat_sys_semtimedop(int semid, struct sembuf __user *tsems,
 		unsigned nsems, const struct compat_timespec __user *timeout);
diff --git a/ipc/compat.c b/ipc/compat.c
index 845a287..9d62f17 100644
--- a/ipc/compat.c
+++ b/ipc/compat.c
@@ -27,6 +27,7 @@
 #include <linux/msg.h>
 #include <linux/shm.h>
 #include <linux/syscalls.h>
+#include <linux/ptrace.h>
 
 #include <linux/mutex.h>
 #include <asm/uaccess.h>
@@ -117,6 +118,10 @@ extern int sem_ctls[];
 
 static inline int compat_ipc_parse_version(int *cmd)
 {
+#ifdef __ARCH_WANT_GENERIC_COMPAT_IPC
+	/* With the asm-generic APIs, we always use the 64-bit versions. */
+	return IPC_64;
+#else
 	int version = *cmd & IPC_64;
 
 	/* this is tricky: architectures that have support for the old
@@ -128,6 +133,7 @@ static inline int compat_ipc_parse_version(int *cmd)
 	*cmd &= ~IPC_64;
 #endif
 	return version;
+#endif
 }
 
 static inline int __get_compat_ipc64_perm(struct ipc64_perm *p64,
@@ -232,10 +238,9 @@ static inline int put_compat_semid_ds(struct semid64_ds *s,
 	return err;
 }
 
-long compat_sys_semctl(int first, int second, int third, void __user *uptr)
+static long do_compat_semctl(int first, int second, int third, u32 pad)
 {
 	union semun fourth;
-	u32 pad;
 	int err, err2;
 	struct semid64_ds s64;
 	struct semid64_ds __user *up64;
@@ -243,10 +248,6 @@ long compat_sys_semctl(int first, int second, int third, void __user *uptr)
 
 	memset(&s64, 0, sizeof(s64));
 
-	if (!uptr)
-		return -EINVAL;
-	if (get_user(pad, (u32 __user *) uptr))
-		return -EFAULT;
 	if ((third & (~IPC_64)) == SETVAL)
 		fourth.val = (int) pad;
 	else
@@ -305,6 +306,48 @@ long compat_sys_semctl(int first, int second, int third, void __user *uptr)
 	return err;
 }
 
+#ifdef __ARCH_WANT_GENERIC_COMPAT_IPC
+long compat_sys_semctl(int semid, int semnum, int cmd, int arg)
+{
+	return do_compat_semctl(semid, semnum, cmd, arg);
+}
+
+long compat_sys_msgsnd(int msqid, struct compat_msgbuf __user *msgp,
+		       size_t msgsz, int msgflg)
+{
+	compat_long_t mtype;
+
+	if (get_user(mtype, &msgp->mtype))
+		return -EFAULT;
+	return do_msgsnd(msqid, mtype, msgp->mtext, msgsz, msgflg);
+}
+
+long compat_sys_msgrcv(int msqid, struct compat_msgbuf __user *msgp,
+		       size_t msgsz, long msgtyp, int msgflg)
+{
+	long err, mtype;
+
+	err =  do_msgrcv(msqid, &mtype, msgp->mtext, msgsz, msgtyp, msgflg);
+	if (err < 0)
+		goto out;
+
+	if (put_user(mtype, &msgp->mtype))
+		err = -EFAULT;
+ out:
+	return err;
+}
+#else
+long compat_sys_semctl(int first, int second, int third, void __user *uptr)
+{
+	u32 pad;
+
+	if (!uptr)
+		return -EINVAL;
+	if (get_user(pad, (u32 __user *) uptr))
+		return -EFAULT;
+	return do_compat_semctl(first, second, third, pad);
+}
+
 long compat_sys_msgsnd(int first, int second, int third, void __user *uptr)
 {
 	struct compat_msgbuf __user *up = uptr;
@@ -353,6 +396,7 @@ long compat_sys_msgrcv(int first, int second, int msgtyp, int third,
 out:
 	return err;
 }
+#endif
 
 static inline int get_compat_msqid64(struct msqid64_ds *m64,
 				     struct compat_msqid64_ds __user *up64)
@@ -470,6 +514,19 @@ long compat_sys_msgctl(int first, int second, void __user *uptr)
 	return err;
 }
 
+#ifdef __ARCH_WANT_GENERIC_COMPAT_IPC
+long compat_sys_shmat(int shmid, compat_uptr_t shmaddr, int shmflg)
+{
+	unsigned long ret;
+	long err;
+
+	err = do_shmat(shmid, compat_ptr(shmaddr), shmflg, &ret);
+	if (err)
+		return err;
+	force_successful_syscall_return();
+	return (long)ret;
+}
+#else
 long compat_sys_shmat(int first, int second, compat_uptr_t third, int version,
 			void __user *uptr)
 {
@@ -485,6 +542,7 @@ long compat_sys_shmat(int first, int second, compat_uptr_t third, int version,
 	uaddr = compat_ptr(third);
 	return put_user(raddr, uaddr);
 }
+#endif
 
 static inline int get_compat_shmid64_ds(struct shmid64_ds *s64,
 					struct compat_shmid64_ds __user *up64)
-- 
1.6.5.2

