Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab2AKQTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 11:19:47 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65449 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab2AKQTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 11:19:45 -0500
Date: Wed, 11 Jan 2012 20:19:39 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kyle Moffett <kyle@moffetthome.net>, Tejun Heo <tj@kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Subject: [RFC] on general object IDs again
Message-ID: <20120111161939.GI8752@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

here is an idea on general object IDs for kernel which could be
exported to user-space apps. The generation is done via the new
syscall __NR_gen_obj_id. The user-space application is supposed
to put a request and provide memory for encrypted data.

The patch is far from being complete and not all things are
implemented yet (and for namespaces there should be a patch
from Eric Biederman soon, so I left GEN_OBJ_ID_NS just in case,
will drop them).

What also is not yet done -- 

 - there should be a sysctl entry which would allow to completely
   disable this feature if one day we find that aes doesn't provide
   enough security or someone simply doesn't need this feature enabled

 - there should be kind of periodical cookies update routine so that
   one can't use same keys and salt forever, the time period is controlled
   by sysctl as well

 - there should be "disable updating key/salt for a series of syscalls",
   so one could be sure he got results generate with same key/salt so
   results can be sorted out in user-space, via sysctl too I think
   (ie one need to draw resources affinity for series of pids and while
    IDs are generated the key/salt should not be updated). For this sake
   gen_obj_lock is added.

 - no IDs for file descriptors yet, I thought something like -- user-space
   provides pid and array of fd, the kernel calculates IDs for every fd then

Regardless the things which are not implemented yet, I would like to hear
people *opinions* on such approach in general, and if it's acceptable at all.

Eric B., I know such approach is exactly what you mentioned as bad design
but I thought in various ways and didn't find any better solution
yet.

In turn doing everything in a manner of syscall "compare resources of two pids"
gives up very slow speed because we will have to compare every pid resources
with every other pids we're checkpointing.

Inability to restore this dynamic IDs doesn't look like a problem for me since
they are supposed to be read-only and used for sameness test.

Again, if someone has a better idea please don't hesitate to mention. Thanks!

P.S. Sorry if I forgot to CC someone who were replying me plreviously.

	Cyrill
---
 arch/x86/include/asm/unistd_64.h |    2 
 include/linux/gen_obj_id.h       |   39 ++++++++
 mm/Kconfig                       |   17 +++
 mm/Makefile                      |    1 
 mm/gen_obj_id.c                  |  183 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 242 insertions(+)

Index: linux-2.6.git/arch/x86/include/asm/unistd_64.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/unistd_64.h
+++ linux-2.6.git/arch/x86/include/asm/unistd_64.h
@@ -686,6 +686,8 @@ __SYSCALL(__NR_getcpu, sys_getcpu)
 __SYSCALL(__NR_process_vm_readv, sys_process_vm_readv)
 #define __NR_process_vm_writev			311
 __SYSCALL(__NR_process_vm_writev, sys_process_vm_writev)
+#define __NR_gen_obj_id				312
+__SYSCALL(__NR_gen_obj_id, sys_gen_obj_id)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
Index: linux-2.6.git/include/linux/gen_obj_id.h
===================================================================
--- /dev/null
+++ linux-2.6.git/include/linux/gen_obj_id.h
@@ -0,0 +1,39 @@
+#ifndef _LINUX_GEN_OBJ_ID_H
+#define _LINUX_GEN_OBJ_ID_H
+
+#include <linux/err.h>
+
+enum {
+	GEN_OBJ_ID_FILE,
+	GEN_OBJ_ID_VM,
+	GEN_OBJ_ID_FILES,
+	GEN_OBJ_ID_FS,
+	GEN_OBJ_ID_SIGHAND,
+	GEN_OBJ_ID_IO,
+	GEN_OBJ_ID_SYSVSEM,
+	GEN_OBJ_ID_NS_NET,
+	GEN_OBJ_ID_NS_PID,
+	GEN_OBJ_ID_NS_MNT,
+	GEN_OBJ_ID_NS_IPC,
+	GEN_OBJ_ID_NS_UTS,
+
+	GEN_OBJ_ID_TYPES,
+};
+
+#define GEN_OBJ_ID_MASK(type)	(1UL << (type))
+
+struct gen_obj_id_req {
+	__u64	mask;		/* request mask */
+	__u64	pid;		/* pid of a process to ask */
+	__u64	arg;		/* if needed */
+};
+
+struct gen_obj_id_fd {
+	__u32	nr_fd;
+	__u32	fd[0];
+};
+
+/* minimum bytes of buffer a user must provide */
+#define GEN_OBJ_ID_USER_SIZE	16
+
+#endif /* _LINUX_GEN_OBJ_ID_H */
Index: linux-2.6.git/mm/Kconfig
===================================================================
--- linux-2.6.git.orig/mm/Kconfig
+++ linux-2.6.git/mm/Kconfig
@@ -373,3 +373,20 @@ config CLEANCACHE
 	  in a negligible performance hit.
 
 	  If unsure, say Y to enable cleancache
+
+config GENERIC_OBJECT_ID
+	bool "Enable generic object ID infrastructure"
+	depends on CHECKPOINT_RESTORE
+	depends on CRYPTO_SHA1
+	default n
+	help
+	  Turn on functionality that can generate IDs for kernel objects,
+	  which are exported to the userspace.
+
+	  It is useful if you need to examine kernel objects and test
+	  if they are shared between several tasks. These IDs should never
+	  be used for anything but the "sameness" test. The IDs are dynamic
+	  and valid only while object is alive. Once it get freed or kernel
+	  is rebooted, the IDs will be changed.
+
+	  If unsure, say N here.
Index: linux-2.6.git/mm/Makefile
===================================================================
--- linux-2.6.git.orig/mm/Makefile
+++ linux-2.6.git/mm/Makefile
@@ -51,3 +51,4 @@ obj-$(CONFIG_HWPOISON_INJECT) += hwpoiso
 obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o
 obj-$(CONFIG_DEBUG_KMEMLEAK_TEST) += kmemleak-test.o
 obj-$(CONFIG_CLEANCACHE) += cleancache.o
+obj-$(CONFIG_GENERIC_OBJECT_ID) += gen_obj_id.o
Index: linux-2.6.git/mm/gen_obj_id.c
===================================================================
--- /dev/null
+++ linux-2.6.git/mm/gen_obj_id.c
@@ -0,0 +1,183 @@
+#include <linux/kernel.h>
+#include <linux/capability.h>
+#include <linux/rwsem.h>
+#include <linux/bitops.h>
+#include <linux/scatterlist.h>
+#include <linux/syscalls.h>
+#include <linux/crypto.h>
+#include <crypto/aes.h>
+#include <linux/rwlock.h>
+#include <linux/rwsem.h>
+#include <linux/sysctl.h>
+#include <linux/string.h>
+#include <linux/random.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/cache.h>
+#include <linux/bug.h>
+#include <linux/err.h>
+
+#include <linux/gen_obj_id.h>
+
+static u8 gen_obj_cookie[GEN_OBJ_ID_TYPES][2][AES_KEYSIZE_128] __read_mostly;
+
+#define COOKIE_KEY(type)	&gen_obj_cookie[type][0][0]
+#define	COOKIE_ID(type)		&gen_obj_cookie[type][1][0]
+
+static DECLARE_RWSEM(gen_obj_lock);
+
+/*
+ * TODO
+ *
+ *  - enable/disable via sysfs
+ *  - cookie update interval (kthread ???)
+ *  - cookie lock/unlock if updating
+ *  - lock when a process does a series of syscalls,
+ *    when unlocked after that -- update all cookies
+ *    immediately
+ */
+
+static void gen_obj_refresh_cookies(void)
+{
+	int i;
+	for (i = 0; i < GEN_OBJ_ID_TYPES; i++) {
+		get_random_bytes(COOKIE_KEY(i), AES_KEYSIZE_128);
+		get_random_bytes(COOKIE_ID(i), AES_KEYSIZE_128);
+	}
+}
+
+static int encrypt_obj_id(int type, struct crypto_cipher *tfm,
+			  unsigned long obj_id, void __user *buf)
+{
+	__u8 ciphertext[AES_KEYSIZE_128];
+	__u8 expanded[AES_KEYSIZE_128];
+	int ret = 0;
+
+	memcpy(expanded, COOKIE_ID(type), AES_KEYSIZE_128);
+	*(unsigned long *)expanded += obj_id;
+
+	ret = crypto_cipher_setkey(tfm, COOKIE_KEY(type), AES_KEYSIZE_128);
+	if (ret)
+		goto err;
+
+	crypto_cipher_encrypt_one(tfm, ciphertext, expanded);
+	ret = copy_to_user(buf, ciphertext, AES_KEYSIZE_128);
+
+err:
+	return ret;
+}
+
+SYSCALL_DEFINE3(gen_obj_id, struct gen_obj_id_req __user *, request, void, __user *buf, long, len)
+{
+	struct task_struct *task;
+	struct crypto_cipher *tfm;
+	struct gen_obj_id_req req;
+	unsigned long obj_id;
+	unsigned long mask;
+	int ret = 0;
+	int bit;
+
+	BUILD_BUG_ON(GEN_OBJ_ID_TYPES < (sizeof(long) / BITS_PER_BYTE));
+	BUILD_BUG_ON(GEN_OBJ_ID_USER_SIZE < AES_BLOCK_SIZE);
+
+	if (len < GEN_OBJ_ID_USER_SIZE)
+		return -EINVAL;
+
+	if (copy_from_user(&req, (void __user *)request, sizeof(req)))
+		return -EFAULT;
+
+	tfm = crypto_alloc_cipher("aes", 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(tfm)) {
+		ret = PTR_ERR(tfm);
+		return ret;
+	}
+
+	rcu_read_lock();
+	task = find_task_by_vpid((pid_t)req.pid);
+	if (!task) {
+		rcu_read_unlock();
+		return -ENOENT;
+	}
+	get_task_struct(task);
+	rcu_read_unlock();
+
+	if (!ptrace_may_access(task, PTRACE_MODE_READ)) {
+		ret = -EACCES;
+		goto err;
+	}
+
+	mask = (unsigned long)req.mask;
+	if (!mask) {
+		ret = -ENOENT;
+		goto err;
+	}
+
+	down_read(&gen_obj_lock);
+
+	for_each_set_bit(bit, &mask, sizeof(mask)) {
+
+		obj_id = 0;
+
+		switch (bit) {
+		case GEN_OBJ_ID_FILE:
+			break;
+		case GEN_OBJ_ID_VM:
+			obj_id = (unsigned long)task->mm;
+			break;
+		case GEN_OBJ_ID_FILES:
+			obj_id = (unsigned long)task->files;
+			break;
+		case GEN_OBJ_ID_FS:
+			obj_id = (unsigned long)task->fs;
+			break;
+		case GEN_OBJ_ID_SIGHAND:
+			obj_id = (unsigned long)task->sighand;
+			break;
+		case GEN_OBJ_ID_IO:
+			obj_id = (unsigned long)task->io_context;
+			break;
+		case GEN_OBJ_ID_SYSVSEM:
+#ifdef CONFIG_SYSVIPC
+			obj_id = (unsigned long)task->sysvsem.undo_list;
+#endif
+			break;
+		case GEN_OBJ_ID_NS_NET:
+		case GEN_OBJ_ID_NS_PID:
+		case GEN_OBJ_ID_NS_MNT:
+		case GEN_OBJ_ID_NS_IPC:
+		case GEN_OBJ_ID_NS_UTS:
+		default:
+			ret = -EINVAL;
+			goto err_unlock;
+		}
+
+		if (obj_id) {
+			ret = encrypt_obj_id(bit, tfm, obj_id, buf);
+			if (ret)
+				goto err_unlock;
+		}
+
+		if (len < GEN_OBJ_ID_USER_SIZE) {
+			ret = -ENOSPC;
+			goto err_unlock;
+		}
+
+		buf += GEN_OBJ_ID_USER_SIZE;
+		len -= GEN_OBJ_ID_USER_SIZE;
+	}
+
+err_unlock:
+	up_read(&gen_obj_lock);
+err:
+	crypto_free_cipher(tfm);
+	put_task_struct(task);
+
+	return ret;
+}
+
+static __init int gen_obj_cookie_init(void)
+{
+	gen_obj_refresh_cookies();
+	return 0;
+}
+late_initcall(gen_obj_cookie_init);
