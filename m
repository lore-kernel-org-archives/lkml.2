Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab1KAXqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 19:46:46 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55815 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118Ab1KAXqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 19:46:42 -0400
From: Tejun Heo <tj@kernel.org>
To: paul@paulmenage.org, rjw@sisk.pl, lizf@cn.fujitsu.com
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, akpm@linux-foundation.org, oleg@redhat.com,
        kamezawa.hiroyu@Jp.fujitsu.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/10] cgroup: add cgroup_root_mutex
Date: Tue,  1 Nov 2011 16:46:24 -0700
Message-Id: <1320191193-8110-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1320191193-8110-1-git-send-email-tj@kernel.org>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup wants to make threadgroup stable while modifying cgroup
hierarchies which will introduce locking dependency on
cred_guard_mutex from cgroup_mutex.  This unfortunately completes
circular dependency.

 A. cgroup_mutex -> cred_guard_mutex -> s_type->i_mutex_key -> namespace_sem
 B. namespace_sem -> cgroup_mutex

B is from cgroup_show_options() and this patch breaks it by
introducing another mutex cgroup_root_mutex which nests inside
cgroup_mutex and protects cgroupfs_root.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 kernel/cgroup.c |   64 ++++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 42 insertions(+), 22 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 453100a..efa5886 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -63,7 +63,24 @@
 
 #include <linux/atomic.h>
 
+/*
+ * cgroup_mutex is the master lock.  Any modification to cgroup or its
+ * hierarchy must be performed while holding it.
+ *
+ * cgroup_root_mutex nests inside cgroup_mutex and should be held to modify
+ * cgroupfs_root of any cgroup hierarchy - subsys list, flags,
+ * release_agent_path and so on.  Modifying requires both cgroup_mutex and
+ * cgroup_root_mutex.  Readers can acquire either of the two.  This is to
+ * break the following locking order cycle.
+ *
+ *  A. cgroup_mutex -> cred_guard_mutex -> s_type->i_mutex_key -> namespace_sem
+ *  B. namespace_sem -> cgroup_mutex
+ *
+ * B happens only through cgroup_show_options() and using cgroup_root_mutex
+ * breaks it.
+ */
 static DEFINE_MUTEX(cgroup_mutex);
+static DEFINE_MUTEX(cgroup_root_mutex);
 
 /*
  * Generate an array of cgroup subsystem pointers. At boot time, this is
@@ -953,6 +970,7 @@ static int rebind_subsystems(struct cgroupfs_root *root,
 	int i;
 
 	BUG_ON(!mutex_is_locked(&cgroup_mutex));
+	BUG_ON(!mutex_is_locked(&cgroup_root_mutex));
 
 	removed_bits = root->actual_subsys_bits & ~final_bits;
 	added_bits = final_bits & ~root->actual_subsys_bits;
@@ -1043,7 +1061,7 @@ static int cgroup_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	struct cgroupfs_root *root = vfs->mnt_sb->s_fs_info;
 	struct cgroup_subsys *ss;
 
-	mutex_lock(&cgroup_mutex);
+	mutex_lock(&cgroup_root_mutex);
 	for_each_subsys(root, ss)
 		seq_printf(seq, ",%s", ss->name);
 	if (test_bit(ROOT_NOPREFIX, &root->flags))
@@ -1054,7 +1072,7 @@ static int cgroup_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_puts(seq, ",clone_children");
 	if (strlen(root->name))
 		seq_printf(seq, ",name=%s", root->name);
-	mutex_unlock(&cgroup_mutex);
+	mutex_unlock(&cgroup_root_mutex);
 	return 0;
 }
 
@@ -1269,6 +1287,7 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
 
 	mutex_lock(&cgrp->dentry->d_inode->i_mutex);
 	mutex_lock(&cgroup_mutex);
+	mutex_lock(&cgroup_root_mutex);
 
 	/* See what subsystems are wanted */
 	ret = parse_cgroupfs_options(data, &opts);
@@ -1297,6 +1316,7 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
  out_unlock:
 	kfree(opts.release_agent);
 	kfree(opts.name);
+	mutex_unlock(&cgroup_root_mutex);
 	mutex_unlock(&cgroup_mutex);
 	mutex_unlock(&cgrp->dentry->d_inode->i_mutex);
 	return ret;
@@ -1481,6 +1501,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 	int ret = 0;
 	struct super_block *sb;
 	struct cgroupfs_root *new_root;
+	struct inode *inode;
 
 	/* First find the desired set of subsystems */
 	mutex_lock(&cgroup_mutex);
@@ -1514,7 +1535,6 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		/* We used the new root structure, so this is a new hierarchy */
 		struct list_head tmp_cg_links;
 		struct cgroup *root_cgrp = &root->top_cgroup;
-		struct inode *inode;
 		struct cgroupfs_root *existing_root;
 		const struct cred *cred;
 		int i;
@@ -1528,18 +1548,14 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 
 		mutex_lock(&inode->i_mutex);
 		mutex_lock(&cgroup_mutex);
+		mutex_lock(&cgroup_root_mutex);
 
-		if (strlen(root->name)) {
-			/* Check for name clashes with existing mounts */
-			for_each_active_root(existing_root) {
-				if (!strcmp(existing_root->name, root->name)) {
-					ret = -EBUSY;
-					mutex_unlock(&cgroup_mutex);
-					mutex_unlock(&inode->i_mutex);
-					goto drop_new_super;
-				}
-			}
-		}
+		/* Check for name clashes with existing mounts */
+		ret = -EBUSY;
+		if (strlen(root->name))
+			for_each_active_root(existing_root)
+				if (!strcmp(existing_root->name, root->name))
+					goto unlock_drop;
 
 		/*
 		 * We're accessing css_set_count without locking
@@ -1549,18 +1565,13 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		 * have some link structures left over
 		 */
 		ret = allocate_cg_links(css_set_count, &tmp_cg_links);
-		if (ret) {
-			mutex_unlock(&cgroup_mutex);
-			mutex_unlock(&inode->i_mutex);
-			goto drop_new_super;
-		}
+		if (ret)
+			goto unlock_drop;
 
 		ret = rebind_subsystems(root, root->subsys_bits);
 		if (ret == -EBUSY) {
-			mutex_unlock(&cgroup_mutex);
-			mutex_unlock(&inode->i_mutex);
 			free_cg_links(&tmp_cg_links);
-			goto drop_new_super;
+			goto unlock_drop;
 		}
 		/*
 		 * There must be no failure case after here, since rebinding
@@ -1599,6 +1610,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		cred = override_creds(&init_cred);
 		cgroup_populate_dir(root_cgrp);
 		revert_creds(cred);
+		mutex_unlock(&cgroup_root_mutex);
 		mutex_unlock(&cgroup_mutex);
 		mutex_unlock(&inode->i_mutex);
 	} else {
@@ -1615,6 +1627,10 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 	kfree(opts.name);
 	return dget(sb->s_root);
 
+ unlock_drop:
+	mutex_unlock(&cgroup_root_mutex);
+	mutex_unlock(&cgroup_mutex);
+	mutex_unlock(&inode->i_mutex);
  drop_new_super:
 	deactivate_locked_super(sb);
  drop_modules:
@@ -1639,6 +1655,7 @@ static void cgroup_kill_sb(struct super_block *sb) {
 	BUG_ON(!list_empty(&cgrp->sibling));
 
 	mutex_lock(&cgroup_mutex);
+	mutex_lock(&cgroup_root_mutex);
 
 	/* Rebind all subsystems back to the default hierarchy */
 	ret = rebind_subsystems(root, 0);
@@ -1664,6 +1681,7 @@ static void cgroup_kill_sb(struct super_block *sb) {
 		root_count--;
 	}
 
+	mutex_unlock(&cgroup_root_mutex);
 	mutex_unlock(&cgroup_mutex);
 
 	kill_litter_super(sb);
@@ -2308,7 +2326,9 @@ static int cgroup_release_agent_write(struct cgroup *cgrp, struct cftype *cft,
 		return -EINVAL;
 	if (!cgroup_lock_live_group(cgrp))
 		return -ENODEV;
+	mutex_lock(&cgroup_root_mutex);
 	strcpy(cgrp->root->release_agent_path, buffer);
+	mutex_unlock(&cgroup_root_mutex);
 	cgroup_unlock();
 	return 0;
 }
-- 
1.7.3.1

