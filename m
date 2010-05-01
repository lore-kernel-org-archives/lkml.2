Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933312Ab0EAOoZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 10:44:25 -0400
Received: from tarap.cc.columbia.edu ([128.59.29.7]:64250 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932912Ab0EAOiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 10:38:09 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Matt Helsley <matthltc@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Oren Laadan <orenl@cs.columbia.edu>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: [PATCH v21 082/100] c/r: preliminary support mounts namespace
Date: Sat,  1 May 2010 10:16:04 -0400
Message-Id: <1272723382-19470-83-git-send-email-orenl@cs.columbia.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only allow c/r when all processes shared a single mounts ns.

We do intend to implement c/r of mounts and mounts namespaces in the
kernel.  It shouldn't be ugly or complicate locking to do so.  Just
haven't gotten around to it. A more complete solution is more than we
want to take on now for v19.

But we'd like as much as possible for everything which we don't
support, to not be checkpointable, since not doing so has in the past
invited slanderous accusations of being a toy implementation :)

Meanwhile, we get the following:
1) Checkpoint bails if not all tasks share the same mnt-ns
2) Leak detection works for full container checkpoint

On restart, all tasks inherit the same mnt-ns of the coordinator, by
default. A follow-up patch to user-cr will add a new switch to the
'restart' to request a CLONE_NEWMNT flag when creating the root-task
of the restart.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Acked-by: Oren Laadan <orenl@cs.columbia.edu>
---
 fs/namespace.c                 |   63 +++++++++++++++++++++++++++++----------
 include/linux/checkpoint.h     |    2 +-
 include/linux/checkpoint_hdr.h |    4 ++
 kernel/nsproxy.c               |   16 ++++++++--
 4 files changed, 65 insertions(+), 20 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 8174c8a..e335285 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -29,6 +29,7 @@
 #include <linux/log2.h>
 #include <linux/idr.h>
 #include <linux/fs_struct.h>
+#include <linux/checkpoint.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include "pnode.h"
@@ -2318,6 +2319,49 @@ static void __init init_mount_tree(void)
 	set_fs_root(current->fs, &root);
 }
 
+void put_mnt_ns(struct mnt_namespace *ns)
+{
+	LIST_HEAD(umount_list);
+
+	if (!atomic_dec_and_test(&ns->count))
+		return;
+	down_write(&namespace_sem);
+	spin_lock(&vfsmount_lock);
+	umount_tree(ns->root, 0, &umount_list);
+	spin_unlock(&vfsmount_lock);
+	up_write(&namespace_sem);
+	release_mounts(&umount_list);
+	kfree(ns);
+}
+EXPORT_SYMBOL(put_mnt_ns);
+
+#ifdef CONFIG_CHECKPOINT
+static int obj_mnt_ns_grab(void *ptr)
+{
+	get_mnt_ns((struct mnt_namespace *) ptr);
+	return 0;
+}
+
+static void obj_mnt_ns_drop(void *ptr, int lastref)
+{
+	put_mnt_ns((struct mnt_namespace *) ptr);
+}
+
+static int obj_mnt_ns_users(void *ptr)
+{
+	return atomic_read(&((struct mnt_namespace *) ptr)->count);
+}
+
+/* mnt_ns object */
+static const struct ckpt_obj_ops ckpt_obj_mntns_ops = {
+	.obj_name = "MOUNTS NS",
+	.obj_type = CKPT_OBJ_MNT_NS,
+	.ref_grab = obj_mnt_ns_grab,
+	.ref_drop = obj_mnt_ns_drop,
+	.ref_users = obj_mnt_ns_users,
+};
+#endif /* CONFIG_CHECKPOINT */
+
 void __init mnt_init(void)
 {
 	unsigned u;
@@ -2347,20 +2391,7 @@ void __init mnt_init(void)
 		printk(KERN_WARNING "%s: kobj create error\n", __func__);
 	init_rootfs();
 	init_mount_tree();
+#ifdef CONFIG_CHECKPOINT
+	register_checkpoint_obj(&ckpt_obj_mntns_ops);
+#endif
 }
-
-void put_mnt_ns(struct mnt_namespace *ns)
-{
-	LIST_HEAD(umount_list);
-
-	if (!atomic_dec_and_test(&ns->count))
-		return;
-	down_write(&namespace_sem);
-	spin_lock(&vfsmount_lock);
-	umount_tree(ns->root, 0, &umount_list);
-	spin_unlock(&vfsmount_lock);
-	up_write(&namespace_sem);
-	release_mounts(&umount_list);
-	kfree(ns);
-}
-EXPORT_SYMBOL(put_mnt_ns);
diff --git a/include/linux/checkpoint.h b/include/linux/checkpoint.h
index c1079b7..6560f63 100644
--- a/include/linux/checkpoint.h
+++ b/include/linux/checkpoint.h
@@ -10,7 +10,7 @@
  *  distribution for more details.
  */
 
-#define CHECKPOINT_VERSION  4
+#define CHECKPOINT_VERSION  5
 
 /* checkpoint user flags */
 #define CHECKPOINT_SUBTREE	0x1
diff --git a/include/linux/checkpoint_hdr.h b/include/linux/checkpoint_hdr.h
index 8dbd6e9..e74d668 100644
--- a/include/linux/checkpoint_hdr.h
+++ b/include/linux/checkpoint_hdr.h
@@ -98,6 +98,8 @@ enum {
 #define CKPT_HDR_UTS_NS CKPT_HDR_UTS_NS
 	CKPT_HDR_IPC_NS,
 #define CKPT_HDR_IPC_NS CKPT_HDR_IPC_NS
+	CKPT_HDR_MNT_NS,
+#define CKPT_HDR_MNT_NS CKPT_HDR_MNT_NS
 	CKPT_HDR_CAPABILITIES,
 #define CKPT_HDR_CAPABILITIES CKPT_HDR_CAPABILITIES
 	CKPT_HDR_USER_NS,
@@ -224,6 +226,8 @@ enum obj_type {
 #define CKPT_OBJ_UTS_NS CKPT_OBJ_UTS_NS
 	CKPT_OBJ_IPC_NS,
 #define CKPT_OBJ_IPC_NS CKPT_OBJ_IPC_NS
+	CKPT_OBJ_MNT_NS,
+#define CKPT_OBJ_MNT_NS CKPT_OBJ_MNT_NS
 	CKPT_OBJ_USER_NS,
 #define CKPT_OBJ_USER_NS CKPT_OBJ_USER_NS
 	CKPT_OBJ_CRED,
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 67a1456..5bdce9e 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -268,11 +268,18 @@ int ckpt_collect_ns(struct ckpt_ctx *ctx, struct task_struct *t)
 	 * ipc_ns (shm) may keep references to files: if this is the
 	 * first time we see this ipc_ns (ret > 0), proceed inside.
 	 */
-	if (ret)
+	if (ret) {
 		ret = ckpt_collect_ipc_ns(ctx, nsproxy->ipc_ns);
+		if (ret < 0)
+			goto out;
+	}
 #endif
 
-	/* TODO: collect other namespaces here */
+	ret = ckpt_obj_collect(ctx, nsproxy->mnt_ns, CKPT_OBJ_MNT_NS);
+	if (ret < 0)
+		goto out;
+
+	ret = 0;
  out:
 	put_nsproxy(nsproxy);
 	return ret;
@@ -301,7 +308,10 @@ static int checkpoint_ns(struct ckpt_ctx *ctx, void *ptr)
 #endif	/* CONFIG_IPC_NS */
 	h->ipc_objref = ret;
 
-	/* TODO: Write other namespaces here */
+	/* FIXME: for now, only marked visited to pacify leaks */
+	ret = ckpt_obj_visit(ctx, nsproxy->mnt_ns, CKPT_OBJ_MNT_NS);
+	if (ret < 0)
+		goto out;
 
 	ret = ckpt_write_obj(ctx, &h->h);
  out:
-- 
1.6.3.3

