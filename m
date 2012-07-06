Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514Ab2GFVHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 17:07:10 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60938 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758344Ab2GFVGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 17:06:39 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>
Subject: [PATCH 02/36] ipc: Add COMPAT_SHMLBA support
Date: Fri,  6 Jul 2012 22:05:43 +0100
Message-Id: <1341608777-12982-3-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 06 Jul 2012 21:07:29.0516 (UTC) FILETIME=[5A45FAC0:01CD5BBB]
X-MC-Unique: 112070622063805001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id q66L7Q40005321

From: Will Deacon <will.deacon@arm.com>

If the SHMLBA for a 64-bit applications differs from the SHMLBA for
32-bit (compat) applications, do_shmat() would need to handle both. This
patch introduces COMPAT_SHMLBA which is used only if is_compat_task().

The reason for this patch is that we want SHMLBA to be 64K on AArch64
but still provide a compat equivalent of 4K (and allow LTP tests to
pass).

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/sparc/kernel/sys_sparc_64.c |    2 +-
 arch/xtensa/kernel/syscall.c     |    2 +-
 include/linux/shm.h              |    6 ++++--
 ipc/compat.c                     |    8 ++++++--
 ipc/shm.c                        |    9 +++++----
 ipc/syscall.c                    |    2 +-
 6 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
index 275f74f..65203ff 100644
--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@ -487,7 +487,7 @@ SYSCALL_DEFINE6(sparc_ipc, unsigned int, call, int, first, unsigned long, second
 		switch (call) {
 		case SHMAT: {
 			ulong raddr;
-			err = do_shmat(first, ptr, (int)second, &raddr);
+			err = do_shmat(first, ptr, (int)second, &raddr, SHMLBA);
 			if (!err) {
 				if (put_user(raddr,
 					     (ulong __user *) third))
diff --git a/arch/xtensa/kernel/syscall.c b/arch/xtensa/kernel/syscall.c
index 816e6d0..05b3f09 100644
--- a/arch/xtensa/kernel/syscall.c
+++ b/arch/xtensa/kernel/syscall.c
@@ -44,7 +44,7 @@ asmlinkage long xtensa_shmat(int shmid, char __user *shmaddr, int shmflg)
 	unsigned long ret;
 	long err;
 
-	err = do_shmat(shmid, shmaddr, shmflg, &ret);
+	err = do_shmat(shmid, shmaddr, shmflg, &ret, SHMLBA);
 	if (err)
 		return err;
 	return (long)ret;
diff --git a/include/linux/shm.h b/include/linux/shm.h
index 92808b8..edd0868 100644
--- a/include/linux/shm.h
+++ b/include/linux/shm.h
@@ -107,12 +107,14 @@ struct shmid_kernel /* private to the kernel */
 #define SHM_NORESERVE   010000  /* don't check for reservations */
 
 #ifdef CONFIG_SYSVIPC
-long do_shmat(int shmid, char __user *shmaddr, int shmflg, unsigned long *addr);
+long do_shmat(int shmid, char __user *shmaddr, int shmflg, unsigned long *addr,
+	      unsigned long shmlba);
 extern int is_file_shm_hugepages(struct file *file);
 extern void exit_shm(struct task_struct *task);
 #else
 static inline long do_shmat(int shmid, char __user *shmaddr,
-				int shmflg, unsigned long *addr)
+			    int shmflg, unsigned long *addr,
+			    unsigned long shmlba)
 {
 	return -ENOSYS;
 }
diff --git a/ipc/compat.c b/ipc/compat.c
index a6df704..53cebdf 100644
--- a/ipc/compat.c
+++ b/ipc/compat.c
@@ -514,6 +514,10 @@ long compat_sys_msgctl(int first, int second, void __user *uptr)
 	return err;
 }
 
+#ifndef COMPAT_SHMLBA
+#define COMPAT_SHMLBA	SHMLBA
+#endif
+
 #ifdef CONFIG_ARCH_WANT_OLD_COMPAT_IPC
 long compat_sys_shmat(int first, int second, compat_uptr_t third, int version,
 			void __user *uptr)
@@ -524,7 +528,7 @@ long compat_sys_shmat(int first, int second, compat_uptr_t third, int version,
 
 	if (version == 1)
 		return -EINVAL;
-	err = do_shmat(first, uptr, second, &raddr);
+	err = do_shmat(first, uptr, second, &raddr, COMPAT_SHMLBA);
 	if (err < 0)
 		return err;
 	uaddr = compat_ptr(third);
@@ -536,7 +540,7 @@ long compat_sys_shmat(int shmid, compat_uptr_t shmaddr, int shmflg)
 	unsigned long ret;
 	long err;
 
-	err = do_shmat(shmid, compat_ptr(shmaddr), shmflg, &ret);
+	err = do_shmat(shmid, compat_ptr(shmaddr), shmflg, &ret, COMPAT_SHMLBA);
 	if (err)
 		return err;
 	force_successful_syscall_return();
diff --git a/ipc/shm.c b/ipc/shm.c
index 41c1285..00faa05 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -953,7 +953,8 @@ out:
  * "raddr" thing points to kernel space, and there has to be a wrapper around
  * this.
  */
-long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr)
+long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr,
+	      unsigned long shmlba)
 {
 	struct shmid_kernel *shp;
 	unsigned long addr;
@@ -973,9 +974,9 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr)
 	if (shmid < 0)
 		goto out;
 	else if ((addr = (ulong)shmaddr)) {
-		if (addr & (SHMLBA-1)) {
+		if (addr & (shmlba - 1)) {
 			if (shmflg & SHM_RND)
-				addr &= ~(SHMLBA-1);	   /* round down */
+				addr &= ~(shmlba - 1);	   /* round down */
 			else
 #ifndef __ARCH_FORCE_SHMLBA
 				if (addr & ~PAGE_MASK)
@@ -1107,7 +1108,7 @@ SYSCALL_DEFINE3(shmat, int, shmid, char __user *, shmaddr, int, shmflg)
 	unsigned long ret;
 	long err;
 
-	err = do_shmat(shmid, shmaddr, shmflg, &ret);
+	err = do_shmat(shmid, shmaddr, shmflg, &ret, SHMLBA);
 	if (err)
 		return err;
 	force_successful_syscall_return();
diff --git a/ipc/syscall.c b/ipc/syscall.c
index 1d6f53f..0d1e32ce 100644
--- a/ipc/syscall.c
+++ b/ipc/syscall.c
@@ -73,7 +73,7 @@ SYSCALL_DEFINE6(ipc, unsigned int, call, int, first, unsigned long, second,
 		default: {
 			unsigned long raddr;
 			ret = do_shmat(first, (char __user *)ptr,
-				       second, &raddr);
+				       second, &raddr, SHMLBA);
 			if (ret)
 				return ret;
 			return put_user(raddr, (unsigned long __user *) third);

