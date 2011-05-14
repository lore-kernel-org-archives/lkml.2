Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759699Ab1ENAOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 20:14:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:63255 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758425Ab1ENAOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 20:14:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,367,1301900400"; 
   d="scan'208";a="747054149"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        npiggin@kernel.dk, viro@zeniv.linux.org.uk, tim.c.chen@intel.com
Subject: [PATCH] VFS: Add VFS event counter infrastructure
Date: Fri, 13 May 2011 17:14:12 -0700
Message-Id: <1305332052-15633-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The recently discovered problem with RCU walks not working for absolute path
motivated me to add some counters for these events to the VFS. Networking
and VM has had such counters for a long time and they were always useful
to diagnose performance problems. An advantage of counters over tracepoints
is that they are always collected and are low enough overhead that
they can be always enabled (unlike tracing)

This patch implements a simple per CPU counter framework for the VFS.
The counters are per CPU and are very little overhead. The counters
are output in debugfs (/sys/kernel/fs/vfsstat)

I implemented RCU path walk and general VFS dcache events for now.

For now this doesn't aim to be complete VFS instrumentation, just
a base for hopefully future enhancements.

I would appreciate feedback particularly on the events and their
placement/usefulness.

Hopefully this will make understanding the VFS performance behaviour
easier.

Cc: npiggin@kernel.dk
Cc: viro@zeniv.linux.org.uk
Cc: tim.c.chen@intel.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/Makefile                  |    2 +-
 fs/namei.c                   |   38 +++++++++++++++++++--
 fs/vfs-counters.c            |   75 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/vfs-counters.h |   34 +++++++++++++++++++
 4 files changed, 144 insertions(+), 5 deletions(-)
 create mode 100644 fs/vfs-counters.c
 create mode 100644 include/linux/vfs-counters.h

diff --git a/fs/Makefile b/fs/Makefile
index fb68c2b..12b0090 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -11,7 +11,7 @@ obj-y :=	open.o read_write.o file_table.o super.o \
 		attr.o bad_inode.o file.o filesystems.o namespace.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o drop_caches.o splice.o sync.o utimes.o \
-		stack.o fs_struct.o statfs.o
+		stack.o fs_struct.o statfs.o vfs-counters.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
diff --git a/fs/namei.c b/fs/namei.c
index 54fc993..0ad8c25 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -32,6 +32,7 @@
 #include <linux/fcntl.h>
 #include <linux/device_cgroup.h>
 #include <linux/fs_struct.h>
+#include <linux/vfs-counters.h>
 #include <asm/uaccess.h>
 
 #include "internal.h"
@@ -442,6 +443,7 @@ err:
 err_root:
 	if (want_root)
 		spin_unlock(&fs->lock);
+	VFS_ACCOUNT(dcache_rcu_root_changed_abort);
 	return -ECHILD;
 }
 
@@ -474,13 +476,18 @@ static int nameidata_dentry_drop_rcu(struct nameidata *nd, struct dentry *dentry
 		want_root = 1;
 		spin_lock(&fs->lock);
 		if (nd->root.mnt != fs->root.mnt ||
-				nd->root.dentry != fs->root.dentry)
+		    nd->root.dentry != fs->root.dentry) {
+			VFS_ACCOUNT(dcache_rcu_root_changed_abort);
 			goto err_root;
+		}
 	}
 	spin_lock(&parent->d_lock);
 	spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
-	if (!__d_rcu_to_refcount(dentry, nd->seq))
+	if (!__d_rcu_to_refcount(dentry, nd->seq)){
+		VFS_ACCOUNT(dcache_rcu_dir_changed_abort);
 		goto err;
+	}
+
 	/*
 	 * If the sequence check on the child dentry passed, then the child has
 	 * not been removed from its parent. This means the parent dentry must
@@ -560,6 +567,7 @@ err_unlock:
 	spin_unlock(&dentry->d_lock);
 	rcu_read_unlock();
 	br_read_unlock(vfsmount_lock);
+	VFS_ACCOUNT(dcache_rcu_dir_changed_abort);
 	return -ECHILD;
 }
 
@@ -668,8 +676,10 @@ static inline int exec_permission(struct inode *inode, unsigned int flags)
 	}
 	if (likely(!ret))
 		goto ok;
-	if (ret == -ECHILD)
+	if (ret == -ECHILD) {
+		VFS_ACCOUNT(dcache_rcu_permission_abort);
 		return ret;
+	}
 
 	if (ns_capable(ns, CAP_DAC_OVERRIDE) ||
 			ns_capable(ns, CAP_DAC_READ_SEARCH))
@@ -715,6 +725,7 @@ static __always_inline int __vfs_follow_link(struct nameidata *nd, const char *l
 		nd->path = nd->root;
 		path_get(&nd->root);
 		nd->flags |= LOOKUP_JUMPED;
+		VFS_ACCOUNT(dcache_root_walks);
 	}
 	nd->inode = nd->path.dentry->d_inode;
 
@@ -1073,6 +1084,7 @@ failed:
 		nd->root.mnt = NULL;
 	rcu_read_unlock();
 	br_read_unlock(vfsmount_lock);
+	VFS_ACCOUNT(dcache_rcu_dir_changed_abort);
 	return -ECHILD;
 }
 
@@ -1211,6 +1223,8 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
 	int status = 1;
 	int err;
 
+	VFS_ACCOUNT(dcache_fs_lookup);
+
 	/*
 	 * Rename seqlock is not required here because in the off chance
 	 * of a false negative due to a concurrent rename, we're going to
@@ -1224,8 +1238,10 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
 			goto unlazy;
 
 		/* Memory barrier in read_seqcount_begin of child is enough */
-		if (__read_seqcount_retry(&parent->d_seq, nd->seq))
+		if (__read_seqcount_retry(&parent->d_seq, nd->seq)) {
+			VFS_ACCOUNT(dcache_rcu_dir_changed_abort);
 			return -ECHILD;
+		}
 		nd->seq = seq;
 
 		if (unlikely(dentry->d_flags & DCACHE_OP_REVALIDATE)) {
@@ -1253,6 +1269,7 @@ unlazy:
 	}
 
 retry:
+	VFS_ACCOUNT(dcache_miss);
 	if (unlikely(!dentry)) {
 		struct inode *dir = parent->d_inode;
 		BUG_ON(nd->inode != dir);
@@ -1260,6 +1277,7 @@ retry:
 		mutex_lock(&dir->i_mutex);
 		dentry = d_lookup(parent, name);
 		if (likely(!dentry)) {
+			VFS_ACCOUNT(dcache_create);
 			dentry = d_alloc_and_lookup(parent, name, nd);
 			if (IS_ERR(dentry)) {
 				mutex_unlock(&dir->i_mutex);
@@ -1282,6 +1300,7 @@ retry:
 			dput(dentry);
 			dentry = NULL;
 			need_reval = 1;
+			VFS_ACCOUNT(dcache_fs_lookup_retry);
 			goto retry;
 		}
 	}
@@ -1352,6 +1371,7 @@ static inline int walk_component(struct nameidata *nd, struct path *path,
 		return err;
 	}
 	if (!inode) {
+		VFS_ACCOUNT(dcache_lookup_no_inode);
 		path_to_nameidata(path, nd);
 		terminate_walk(nd);
 		return -ENOENT;
@@ -1528,22 +1548,28 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 			br_read_lock(vfsmount_lock);
 			rcu_read_lock();
 			nd->seq = __read_seqcount_begin(&nd->path.dentry->d_seq);
+			VFS_ACCOUNT(dcache_rcu_walks);
 		} else {
 			path_get(&nd->path);
+			VFS_ACCOUNT(dcache_ref_walks);
 		}
+		VFS_ACCOUNT(dcache_root_walks);
 		return 0;
 	}
 
 	nd->root.mnt = NULL;
 
 	if (*name=='/') {
+		VFS_ACCOUNT(dcache_root_walks);
 		if (flags & LOOKUP_RCU) {
 			br_read_lock(vfsmount_lock);
 			rcu_read_lock();
 			set_root_rcu(nd);
+			VFS_ACCOUNT(dcache_rcu_walks);
 		} else {
 			set_root(nd);
 			path_get(&nd->root);
+			VFS_ACCOUNT(dcache_ref_walks);
 		}
 		nd->path = nd->root;
 	} else if (dfd == AT_FDCWD) {
@@ -1559,8 +1585,10 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 				nd->path = fs->pwd;
 				nd->seq = __read_seqcount_begin(&nd->path.dentry->d_seq);
 			} while (read_seqcount_retry(&fs->seq, seq));
+			VFS_ACCOUNT(dcache_rcu_walks);
 		} else {
 			get_fs_pwd(current->fs, &nd->path);
+			VFS_ACCOUNT(dcache_ref_walks);
 		}
 	} else {
 		struct dentry *dentry;
@@ -1589,9 +1617,11 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 			nd->seq = __read_seqcount_begin(&nd->path.dentry->d_seq);
 			br_read_lock(vfsmount_lock);
 			rcu_read_lock();
+			VFS_ACCOUNT(dcache_rcu_walks);
 		} else {
 			path_get(&file->f_path);
 			fput_light(file, fput_needed);
+			VFS_ACCOUNT(dcache_ref_walks);
 		}
 	}
 
diff --git a/fs/vfs-counters.c b/fs/vfs-counters.c
new file mode 100644
index 0000000..4a77b62
--- /dev/null
+++ b/fs/vfs-counters.c
@@ -0,0 +1,75 @@
+/* 
+ * Simple event counter infrastructure for the VFS.
+ * Accounts performance relevant events in the VFS for easier diagnosibility.
+ * Similar in spirit to the VM and NET counters.
+ * Right now everything is accounted globally.
+ * 
+ * Started in 2011 by Andi Kleen.
+ */
+#include <linux/kernel.h>
+#include <linux/vfs-counters.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+DEFINE_PER_CPU(struct vfs_counters, vfs_counters);
+
+/* Keep in sync with vfs-counters.h */
+static const char *vfsstat_names[] = {
+	"dcache_rcu_walks",
+	"dcache_ref_walks",
+	"dcache_root_walks",
+	"dcache_rcu_root_changed_abort",
+	"dcache_rcu_dir_changed_abort",
+	"dcache_rcu_permission_abort",
+	"dcache_miss",
+	"dcache_no_inode",
+	"dcache_create",
+	"dcache_fs_lookup",
+	"dcache_fs_lookup_retry",
+	"dcache_lookup_no_inode"
+};
+
+static unsigned sum_vfsstat(int i)
+{
+	int cpu;
+	unsigned n = 0;
+
+	for_each_online_cpu (cpu)
+		n += per_cpu(vfs_counters, cpu).count[i];
+	return n;
+}
+
+static int vfsstat_show(struct seq_file *m, void *arg)
+{
+	int i;
+
+	for (i = 0; i < vfs_account_end; i++)
+		seq_printf(m, "%s: %u\n", vfsstat_names[i], sum_vfsstat(i));
+	return 0;
+}
+
+static int vfsstat_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, vfsstat_show, NULL);
+}
+
+static const struct file_operations vfsstat_fops = {
+	.open		= vfsstat_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+int __init vfs_counters_init(void)
+{
+	struct dentry *fs;
+
+	BUILD_BUG_ON(ARRAY_SIZE(vfsstat_names) != vfs_account_end);
+	fs = debugfs_create_dir("fs", NULL);
+	if (fs)
+		debugfs_create_file("vfsstat", 0444, fs, NULL, &vfsstat_fops);
+	return 0;
+}
+module_init(vfs_counters_init);
diff --git a/include/linux/vfs-counters.h b/include/linux/vfs-counters.h
new file mode 100644
index 0000000..c293d54
--- /dev/null
+++ b/include/linux/vfs-counters.h
@@ -0,0 +1,34 @@
+#ifndef _LINUX_VFS_COUNTERS_H
+#define _LINUX_VFS_COUNTERS_H 1
+
+#include <linux/percpu.h>
+
+/* Update the names in fs/vfs-counters.c too */
+enum {
+	/* dcache RCU aborts: */	
+	dcache_rcu_walks,		/* dcache RCU fastpath walks */
+	dcache_ref_walks,		/* dcache refpath slowpath walks */
+	dcache_root_walks,		/* dcache walks from root */	
+	dcache_rcu_root_changed_abort,  /* abort: Root changed during RCU walk */
+	dcache_rcu_dir_changed_abort,   /* abort: dir changed during RCU walk */
+	dcache_rcu_permission_abort,	/* abort: too fancy permission */
+	/* misc dcache conditions */
+	dcache_miss,			/* didn't find something in dcache */
+	dcache_no_inode,		/* dentry without inode found */
+	dcache_create,			/* creating new dentry during lookup */
+	dcache_fs_lookup,		/* looking up dentry in FS directory */
+	dcache_fs_lookup_retry,		/* retry of fs lookup */
+	dcache_lookup_no_inode,		/* dcache lookup found no inode */
+
+	vfs_account_end,
+};
+
+struct vfs_counters {
+	unsigned count[vfs_account_end];
+};
+
+DECLARE_PER_CPU(struct vfs_counters, vfs_counters);
+
+#define VFS_ACCOUNT(name) this_cpu_inc(vfs_counters.count[name])
+
+#endif
-- 
1.7.4.4

