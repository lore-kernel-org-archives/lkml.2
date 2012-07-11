Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab2GKPcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:32:41 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51559 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755463Ab2GKPcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:32:39 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: davem@davemloft.net, chris@zankel.net, catalin.marinas@arm.com,
        arnd@arndb.de, cmetcalf@tilera.com, akpm@linux-foundation.org,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 1/3] ipc: add COMPAT_SHMLBA support
Date: Wed, 11 Jul 2012 16:32:19 +0100
Message-Id: <1342020741-12758-2-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1342020741-12758-1-git-send-email-will.deacon@arm.com>
References: <1342020741-12758-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the SHMLBA definition for a native task differs from the definition
for a compat task, the do_shmat() function would need to handle both.

This patch introduces COMPAT_SHMLBA, which is used by the compat shmat
syscall when calling the ipc code and allows architectures such as
AArch64 (where the native SHMLBA is 64k but the compat (AArch32)
definition is 16k) to provide the correct semantics for compat IPC
system calls.

Cc: David S. Miller <davem@davemloft.net>
Cc: Chris Zankel <chris@zankel.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
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
-- 
1.7.4.1

