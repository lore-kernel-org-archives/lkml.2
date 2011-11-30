Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab1K3GuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 01:50:06 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55230 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab1K3GuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 01:50:02 -0500
Date: Wed, 30 Nov 2011 06:50:00 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [RFC][PATCH] trimming includes from linux/security.h
Message-ID: <20111130065000.GT2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	linux/security.h pulls a lot of garbage; most of it can be avoided
by several more struct ....; added in there, the rest is a matter of adding
explicit includes in places that (weirdly) relied on security.h to pull
what they wanted.  Plus taking round_hit_to_min() to the only place using
it (mm/mmap.c)...

	NOTE: it almost certainly won't build on some configs; it *does*
survive allmodconfig on amd64, but that's all it had been tested on.  Help
with review and (build-)testing would be very appreciated...  Fortunately,
all breakage will show up on build, which makes finding it less painful.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 1b7082d..82c5101 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/wait.h>
 #include <linux/cdev.h>
+#include <linux/idr.h>
 #include <linux/fs.h>
 
 #include <net/net_namespace.h>
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 0fd96c1..3fd1bc4 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -23,6 +23,7 @@
 #include <linux/crypto.h>
 #include <linux/completion.h>
 #include <linux/module.h>
+#include <linux/idr.h>
 #include <asm/unaligned.h>
 #include <scsi/scsi_device.h>
 #include <scsi/iscsi_proto.h>
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index daad362..ae119af 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -21,6 +21,7 @@
 #include <linux/string.h>
 #include <linux/kthread.h>
 #include <linux/crypto.h>
+#include <linux/idr.h>
 #include <scsi/iscsi_proto.h>
 #include <target/target_core_base.h>
 #include <target/target_core_transport.h>
diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 873bf00..38f4530 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -36,6 +36,7 @@
 #include <linux/inet.h>
 #include <linux/in6.h>
 #include <linux/slab.h>
+#include <linux/idr.h>
 #include <net/ipv6.h>
 #include <linux/nfs_xdr.h>
 #include <linux/sunrpc/bc_xprt.h>
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index a6b6217..67bbf6e 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -6,7 +6,9 @@
 #include <linux/poll.h>
 #include <linux/proc_fs.h>
 #include <linux/security.h>
+#include <linux/sched.h>
 #include <linux/namei.h>
+#include <linux/mm.h>
 #include "internal.h"
 
 static const struct dentry_operations proc_sys_dentry_operations;
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 5d81e92..e88b250 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -71,6 +71,7 @@
 #include <linux/module.h>
 #include <linux/proc_fs.h>
 #include <linux/security.h>
+#include <linux/sched.h>
 #include <linux/kmod.h>
 #include <linux/namei.h>
 #include <linux/capability.h>
diff --git a/fs/super.c b/fs/super.c
index 66a12f9..3577b06 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -32,6 +32,7 @@
 #include <linux/backing-dev.h>
 #include <linux/rculist_bl.h>
 #include <linux/cleancache.h>
+#include <linux/fsnotify.h>
 #include "internal.h"
 
 
diff --git a/include/linux/security.h b/include/linux/security.h
index 410ea73..fab3d99 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -22,22 +22,33 @@
 #ifndef __LINUX_SECURITY_H
 #define __LINUX_SECURITY_H
 
-#include <linux/fs.h>
-#include <linux/fsnotify.h>
-#include <linux/binfmts.h>
-#include <linux/dcache.h>
-#include <linux/signal.h>
-#include <linux/resource.h>
-#include <linux/sem.h>
-#include <linux/shm.h>
-#include <linux/mm.h> /* PAGE_ALIGN */
-#include <linux/msg.h>
-#include <linux/sched.h>
 #include <linux/key.h>
-#include <linux/xfrm.h>
+#include <linux/capability.h>
 #include <linux/slab.h>
-#include <linux/xattr.h>
-#include <net/flow.h>
+
+struct linux_binprm;
+struct cred;
+struct rlimit;
+struct siginfo;
+struct sem_array;
+struct sembuf;
+struct kern_ipc_perm;
+struct audit_context;
+struct super_block;
+struct inode;
+struct dentry;
+struct vfsmount;
+struct path;
+struct qstr;
+struct nameidata;
+struct iattr;
+struct fown_struct;
+struct file_operations;
+struct shmid_kernel;
+struct msg_msg;
+struct msg_queue;
+struct xattr;
+struct xfrm_sec_ctx;
 
 /* Maximum number of letters for an LSM name string */
 #define SECURITY_NAME_MAX	10
@@ -132,18 +143,6 @@ struct request_sock;
 #define LSM_UNSAFE_PTRACE_CAP	4
 
 #ifdef CONFIG_MMU
-/*
- * If a hint addr is less than mmap_min_addr change hint to be as
- * low as possible but still greater than mmap_min_addr
- */
-static inline unsigned long round_hint_to_min(unsigned long hint)
-{
-	hint &= PAGE_MASK;
-	if (((void *)hint != NULL) &&
-	    (hint < mmap_min_addr))
-		return PAGE_ALIGN(mmap_min_addr);
-	return hint;
-}
 extern int mmap_min_addr_handler(struct ctl_table *table, int write,
 				 void __user *buffer, size_t *lenp, loff_t *ppos);
 #endif
diff --git a/ipc/msgutil.c b/ipc/msgutil.c
index 8b5ce5d3..68cf82f 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -13,7 +13,9 @@
 #include <linux/security.h>
 #include <linux/slab.h>
 #include <linux/ipc.h>
+#include <linux/msg.h>
 #include <linux/ipc_namespace.h>
+#include <linux/utsname.h>
 #include <asm/uaccess.h>
 
 #include "util.h"
diff --git a/kernel/cred.c b/kernel/cred.c
index 5791612..97b36ee 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -16,6 +16,7 @@
 #include <linux/keyctl.h>
 #include <linux/init_task.h>
 #include <linux/security.h>
+#include <linux/binfmts.h>
 #include <linux/cn_proc.h>
 
 #if 0
diff --git a/kernel/exit.c b/kernel/exit.c
index d0b7d98..416b804 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -51,6 +51,7 @@
 #include <trace/events/sched.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/oom.h>
+#include <linux/shm.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
diff --git a/kernel/sched.c b/kernel/sched.c
index 9d30d1d..d2508ad 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -71,6 +71,7 @@
 #include <linux/ctype.h>
 #include <linux/ftrace.h>
 #include <linux/slab.h>
+#include <linux/binfmts.h>
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index ae27196..eb10bea 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -58,6 +58,7 @@
 #include <linux/oom.h>
 #include <linux/kmod.h>
 #include <linux/capability.h>
+#include <linux/binfmts.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
diff --git a/mm/mmap.c b/mm/mmap.c
index eae90af..28efb6d 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -936,6 +936,19 @@ void vm_stat_account(struct mm_struct *mm, unsigned long flags,
 #endif /* CONFIG_PROC_FS */
 
 /*
+ * If a hint addr is less than mmap_min_addr change hint to be as
+ * low as possible but still greater than mmap_min_addr
+ */
+static inline unsigned long round_hint_to_min(unsigned long hint)
+{
+	hint &= PAGE_MASK;
+	if (((void *)hint != NULL) &&
+	    (hint < mmap_min_addr))
+		return PAGE_ALIGN(mmap_min_addr);
+	return hint;
+}
+
+/*
  * The caller must hold down_write(&current->mm->mmap_sem).
  */
 
diff --git a/security/commoncap.c b/security/commoncap.c
index ee4f848..938d525 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -28,6 +28,7 @@
 #include <linux/prctl.h>
 #include <linux/securebits.h>
 #include <linux/user_namespace.h>
+#include <linux/binfmts.h>
 
 /*
  * If a non-root user executes a setuid-root binary in
diff --git a/security/security.c b/security/security.c
index 06007d7..f5f2df2 100644
--- a/security/security.c
+++ b/security/security.c
@@ -19,6 +19,8 @@
 #include <linux/integrity.h>
 #include <linux/ima.h>
 #include <linux/evm.h>
+#include <linux/fsnotify.h>
+#include <net/flow.h>
 
 #define MAX_LSM_EVM_XATTR	2
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 4def4d9..eb71f3b 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -81,6 +81,7 @@
 #include <linux/syslog.h>
 #include <linux/user_namespace.h>
 #include <linux/export.h>
+#include <linux/msg.h>
 
 #include "avc.h"
 #include "objsec.h"
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 7db62b4..0c917c7 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -36,6 +36,9 @@
 #include <linux/magic.h>
 #include <linux/dcache.h>
 #include <linux/personality.h>
+#include <linux/msg.h>
+#include <linux/shm.h>
+#include <linux/binfmts.h>
 #include "smack.h"
 
 #define task_security(task)	(task_cred_xxx((task), security))
