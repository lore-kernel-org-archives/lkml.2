Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab1LITDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 14:03:40 -0500
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:40120 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab1LITDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 14:03:39 -0500
Message-Id: <201112091903.pB9J39pd031553@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 9 Dec 2011 10:29:07 -0500
Subject: [PATCH v2] ipc: provide generic compat versions of IPC syscalls
References: <201112091536.pB9Fa5f7002738@farm-0002.internal.tilera.com>, <201112091602.31325.arnd@arndb.de>
In-Reply-To: <201112091602.31325.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>, Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Christoph Hellwig <hch@lst.de>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "J. Bruce Fields" <bfields@redhat.com>, NeilBrown <neilb@suse.de>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org
X-OriginalArrivalTime: 09 Dec 2011 19:03:37.0663 (UTC) FILETIME=[41CBB4F0:01CCB6A5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using the "compat" APIs, architectures will generally want to
be able to make direct syscalls to msgsnd(), shmctl(), etc., and
in the kernel we would want them to be handled directly by
compat_sys_xxx() functions, as is true for other compat syscalls.

However, for historical reasons, several of the existing compat IPC
syscalls do not do this.  semctl() expects a pointer to the fourth
argument, instead of the fourth argument itself.  msgsnd(), msgrcv()
and shmat() expect arguments in different order.

This change adds an __ARCH_WANT_OLD_COMPAT_IPC define that can be
set in <asm/compat.h> to preserve this behavior for ports that use it
(x86, sparc, powerpc, s390, and mips).  No actual semantics are changed
for those architectures, and there is only a minimal amount of code
refactoring in ipc/compat.c.

Newer architectures like tile (and perhaps future architectures such
as arm64 and unicore64) should not supply this define, and thus can
avoid having any IPC-specific code at all in their architecture-specific
compat layer.  In the same vein, if this define is omitted, IPC_64 mode
is assumed, since that's what the <asm-generic> headers expect.

The workaround code in "tile" for msgsnd() and msgrcv() is removed
with this change; it also fixes the bug that shmat() and semctl() were
not being properly handled.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
The first version used an "__ARCH_WANT_GENERIC_COMPAT_IPC" define that
was set by tile, and presumably would be set by all future architectures.
Arnd Bergmann observed:

> I like the patch, but I think the __ARCH_WANT_GENERIC_COMPAT_IPC
> should be defined as the opposite, so all "old" architectures
> have to set it while tile (and future architectures like arm64
> and unicore64) just get the default. [...]
> We have powerpc, mips, s390, sparc and
> x86 using the legacy method, while only parisc and tile get it right
> and use the syscalls directly.

 arch/mips/include/asm/compat.h    |    3 ++
 arch/powerpc/include/asm/compat.h |    3 ++
 arch/s390/include/asm/compat.h    |    3 ++
 arch/sparc/include/asm/compat.h   |    3 ++
 arch/tile/include/asm/compat.h    |   11 ------
 arch/tile/kernel/compat.c         |   43 ----------------------
 arch/x86/include/asm/compat.h     |    3 ++
 include/linux/compat.h            |   12 ++++++-
 ipc/compat.c                      |   70 +++++++++++++++++++++++++++++++++---
 9 files changed, 90 insertions(+), 61 deletions(-)

diff --git a/arch/mips/include/asm/compat.h b/arch/mips/include/asm/compat.h
index b77df03..41a57cb 100644
--- a/arch/mips/include/asm/compat.h
+++ b/arch/mips/include/asm/compat.h
@@ -8,6 +8,9 @@
 #include <asm/page.h>
 #include <asm/ptrace.h>
 
+/* Use different 32-bit syscall convention than 64-bit for some syscalls. */
+#define __ARCH_WANT_OLD_COMPAT_IPC
+
 #define COMPAT_USER_HZ		100
 #define COMPAT_UTS_MACHINE	"mips\0\0\0"
 
diff --git a/arch/powerpc/include/asm/compat.h b/arch/powerpc/include/asm/compat.h
index 88e602f..450a976 100644
--- a/arch/powerpc/include/asm/compat.h
+++ b/arch/powerpc/include/asm/compat.h
@@ -7,6 +7,9 @@
 #include <linux/types.h>
 #include <linux/sched.h>
 
+/* Use different 32-bit syscall convention than 64-bit for some syscalls. */
+#define __ARCH_WANT_OLD_COMPAT_IPC
+
 #define COMPAT_USER_HZ		100
 #define COMPAT_UTS_MACHINE	"ppc\0\0"
 
diff --git a/arch/s390/include/asm/compat.h b/arch/s390/include/asm/compat.h
index 2e49748..9a38bae 100644
--- a/arch/s390/include/asm/compat.h
+++ b/arch/s390/include/asm/compat.h
@@ -7,6 +7,9 @@
 #include <linux/sched.h>
 #include <linux/thread_info.h>
 
+/* Use different 32-bit syscall convention than 64-bit for some syscalls. */
+#define __ARCH_WANT_OLD_COMPAT_IPC
+
 #define PSW32_MASK_PER		0x40000000UL
 #define PSW32_MASK_DAT		0x04000000UL
 #define PSW32_MASK_IO		0x02000000UL
diff --git a/arch/sparc/include/asm/compat.h b/arch/sparc/include/asm/compat.h
index b8be20d..bfd3d8b 100644
--- a/arch/sparc/include/asm/compat.h
+++ b/arch/sparc/include/asm/compat.h
@@ -5,6 +5,9 @@
  */
 #include <linux/types.h>
 
+/* Use different 32-bit syscall convention than 64-bit for some syscalls. */
+#define __ARCH_WANT_OLD_COMPAT_IPC
+
 #define COMPAT_USER_HZ		100
 #define COMPAT_UTS_MACHINE	"sparc\0\0"
 
diff --git a/arch/tile/include/asm/compat.h b/arch/tile/include/asm/compat.h
index bf95f55..4b4b289 100644
--- a/arch/tile/include/asm/compat.h
+++ b/arch/tile/include/asm/compat.h
@@ -242,17 +242,6 @@ long compat_sys_fallocate(int fd, int mode,
 long compat_sys_sched_rr_get_interval(compat_pid_t pid,
 				      struct compat_timespec __user *interval);
 
-/* Versions of compat functions that differ from generic Linux. */
-struct compat_msgbuf;
-long tile_compat_sys_msgsnd(int msqid,
-			    struct compat_msgbuf __user *msgp,
-			    size_t msgsz, int msgflg);
-long tile_compat_sys_msgrcv(int msqid,
-			    struct compat_msgbuf __user *msgp,
-			    size_t msgsz, long msgtyp, int msgflg);
-long tile_compat_sys_ptrace(compat_long_t request, compat_long_t pid,
-			    compat_long_t addr, compat_long_t data);
-
 /* Tilera Linux syscalls that don't have "compat" versions. */
 #define compat_sys_flush_cache sys_flush_cache
 
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
diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
index 30d737e..a72cbe4 100644
--- a/arch/x86/include/asm/compat.h
+++ b/arch/x86/include/asm/compat.h
@@ -8,6 +8,9 @@
 #include <linux/sched.h>
 #include <asm/user32.h>
 
+/* Use different 32-bit syscall convention than 64-bit for some syscalls. */
+#define __ARCH_WANT_OLD_COMPAT_IPC
+
 #define COMPAT_USER_HZ		100
 #define COMPAT_UTS_MACHINE	"i686\0\0"
 
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 66ed067..472e66c 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -224,6 +224,7 @@ struct compat_sysinfo;
 struct compat_sysctl_args;
 struct compat_kexec_segment;
 struct compat_mq_attr;
+struct compat_msgbuf;
 
 extern void compat_exit_robust_list(struct task_struct *curr);
 
@@ -234,13 +235,22 @@ asmlinkage long
 compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
 			   compat_size_t __user *len_ptr);
 
+#ifdef __ARCH_WANT_OLD_COMPAT_IPC
 long compat_sys_semctl(int first, int second, int third, void __user *uptr);
 long compat_sys_msgsnd(int first, int second, int third, void __user *uptr);
 long compat_sys_msgrcv(int first, int second, int msgtyp, int third,
 		int version, void __user *uptr);
-long compat_sys_msgctl(int first, int second, void __user *uptr);
 long compat_sys_shmat(int first, int second, compat_uptr_t third, int version,
 		void __user *uptr);
+#else
+long compat_sys_semctl(int semid, int semnum, int cmd, int arg);
+long compat_sys_msgsnd(int msqid, struct compat_msgbuf __user *msgp,
+		size_t msgsz, int msgflg);
+long compat_sys_msgrcv(int msqid, struct compat_msgbuf __user *msgp,
+		size_t msgsz, long msgtyp, int msgflg);
+long compat_sys_shmat(int shmid, compat_uptr_t shmaddr, int shmflg);
+#endif
+long compat_sys_msgctl(int first, int second, void __user *uptr);
 long compat_sys_shmctl(int first, int second, void __user *uptr);
 long compat_sys_semtimedop(int semid, struct sembuf __user *tsems,
 		unsigned nsems, const struct compat_timespec __user *timeout);
diff --git a/ipc/compat.c b/ipc/compat.c
index 845a287..94ee136 100644
--- a/ipc/compat.c
+++ b/ipc/compat.c
@@ -27,6 +27,7 @@
 #include <linux/msg.h>
 #include <linux/shm.h>
 #include <linux/syscalls.h>
+#include <linux/ptrace.h>
 
 #include <linux/mutex.h>
 #include <asm/uaccess.h>
@@ -117,6 +118,7 @@ extern int sem_ctls[];
 
 static inline int compat_ipc_parse_version(int *cmd)
 {
+#ifdef __ARCH_WANT_OLD_COMPAT_IPC
 	int version = *cmd & IPC_64;
 
 	/* this is tricky: architectures that have support for the old
@@ -128,6 +130,10 @@ static inline int compat_ipc_parse_version(int *cmd)
 	*cmd &= ~IPC_64;
 #endif
 	return version;
+#else
+	/* With the asm-generic APIs, we always use the 64-bit versions. */
+	return IPC_64;
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
@@ -305,6 +306,18 @@ long compat_sys_semctl(int first, int second, int third, void __user *uptr)
 	return err;
 }
 
+#ifdef __ARCH_WANT_OLD_COMPAT_IPC
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
@@ -353,6 +366,37 @@ long compat_sys_msgrcv(int first, int second, int msgtyp, int third,
 out:
 	return err;
 }
+#else
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
+#endif
 
 static inline int get_compat_msqid64(struct msqid64_ds *m64,
 				     struct compat_msqid64_ds __user *up64)
@@ -470,6 +514,7 @@ long compat_sys_msgctl(int first, int second, void __user *uptr)
 	return err;
 }
 
+#ifdef __ARCH_WANT_OLD_COMPAT_IPC
 long compat_sys_shmat(int first, int second, compat_uptr_t third, int version,
 			void __user *uptr)
 {
@@ -485,6 +530,19 @@ long compat_sys_shmat(int first, int second, compat_uptr_t third, int version,
 	uaddr = compat_ptr(third);
 	return put_user(raddr, uaddr);
 }
+#else
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
+#endif
 
 static inline int get_compat_shmid64_ds(struct shmid64_ds *s64,
 					struct compat_shmid64_ds __user *up64)
-- 
1.6.5.2

