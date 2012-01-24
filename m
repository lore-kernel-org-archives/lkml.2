Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab2AXAFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 19:05:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42557 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab2AXAFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 19:05:30 -0500
Date: Mon, 23 Jan 2012 18:05:17 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Hansen <haveblue@us.ibm.com>, sukadev@linux.vnet.ibm.com,
        Andy Whitcroft <apw@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Matt Helsley <matthltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: [RFC] fix devpts mount behavior
Message-ID: <20120124000517.GA28878@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Multiple devpts support currently behaves in a way userspace would likely
not expect.  You can mount a new devpts instance using '-o newinstance'.
However, if you subsequently mount devpts without '-o newinstance', you
will remount the global initial devpts instance.

As a result, if a container is created with a private devpts, but
has devpts in its fstab, then the container's init will end up mounting
the host's devpts.  This (a) confuses the software 'creating' the
container (which usually uses a pty for consoles), (b) confuses
userspace inside the container (especially if the ptmx from the
newinstance is bind-mounted over /dev/ptmx), and (c) is a security
risk to the host.

I've been playing for the last week with ways to fix this, and in the
end I can see two ways.  One is to pin+cache, on every newinstance devpts
mount, the new pts_fs_info at the current mount namespace.  Then if a task
does

	mount -t devpts -o newinstance d2 /mnt
	mount -t devpts devpts /dev/pts

then the new instance will be mounted at /dev/pts.

Dave Hansen commented that this basically turns the newinstance mount 
into an unshare, and that therefore perhaps we should fully support
a devpts namespace.  I actually like this better as it avoids making
awkward new relations between the mnt_namespace and pts_fs_info, and
leaves a comfy well-known 'unshare' operation between the current and
new behaviors.  However, it is behaviorally a bit awkward.  If a task
simply does

	mount -t devpts -o newinstance d2 /mnt
	mount -t devpts devpts /dev/pts

Then /dev/pts will still get the host's initial instance, but if it
does

	lxc-unshare -s MOUNT -- /bin/bash
	mount -t devpts -o newinstance d2 /mnt
	mount -t devpts devpts /dev/pts

then /dev/pts will have the new instance (in the new bash shell with
the unshared mount ns).

The other problem with this approach is that it consumes one of the
very few clone flags (we have 0x02000000 and maybe 0x00002000
available).

The patch below implements the first approach - though it's broken,
so only meant to show roughly how it might look.  If consensus is
that the second approach is best, I'll happily implement that and
gobble up 0x02000000.

Is there perhaps another option I haven't considered?

Am I wrong in even considering the current behavior bad?

BROKEN PATCH, DON'T RUN IT.

Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>

---
 fs/devpts/inode.c             |   48 +++++++++++++++++++++++++++++++++++++++-
 fs/namespace.c                |   15 ++++++++++++
 include/linux/devpts_fs.h     |    7 ++++++
 include/linux/fs.h            |    2 +
 include/linux/mnt_namespace.h |    2 +
 5 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index d5d5297..ef737af 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -25,6 +25,8 @@
 #include <linux/parser.h>
 #include <linux/fsnotify.h>
 #include <linux/seq_file.h>
+#include <linux/nsproxy.h>
+#include <linux/mnt_namespace.h>
 
 #define DEVPTS_DEFAULT_MODE 0600
 /*
@@ -71,8 +73,32 @@ struct pts_fs_info {
 	struct ida allocated_ptys;
 	struct pts_mount_opts mount_opts;
 	struct dentry *ptmx_dentry;
+	struct kref kref;
 };
 
+struct pts_fs_info *get_devpts(struct pts_fs_info *i)
+{
+	if (i)
+		kref_get(&i->kref);
+	return i;
+}
+
+static void free_pts_fs_info(struct kref *kref)
+{
+	struct pts_fs_info *i = container_of(kref, struct pts_fs_info, kref);
+
+	printk(KERN_NOTICE "%s: freeing a pts_fs_info %lx\n", __func__,
+		(unsigned long) i);
+
+	kfree(i);
+}
+
+void put_devpts(struct pts_fs_info *i)
+{
+	if (i)
+		kref_put(&i->kref, free_pts_fs_info);
+}
+
 static inline struct pts_fs_info *DEVPTS_SB(struct super_block *sb)
 {
 	return sb->s_fs_info;
@@ -280,6 +306,9 @@ static void *new_pts_fs_info(void)
 	ida_init(&fsi->allocated_ptys);
 	fsi->mount_opts.mode = DEVPTS_DEFAULT_MODE;
 	fsi->mount_opts.ptmxmode = DEVPTS_DEFAULT_PTMX_MODE;
+	kref_init(&fsi->kref);
+	printk(KERN_NOTICE "%s: created a new pts_fs_info %lx\n", __func__,
+		(unsigned long) fsi);
 
 	return fsi;
 }
@@ -325,6 +354,16 @@ fail:
 #ifdef CONFIG_DEVPTS_MULTIPLE_INSTANCES
 static int compare_init_pts_sb(struct super_block *s, void *p)
 {
+	struct mnt_namespace *ns = current->nsproxy->mnt_ns;
+
+	if (ns->devpts) {
+		int ret;
+		rcu_read_lock();
+		ret = ns->devpts == DEVPTS_SB(s);
+		rcu_read_unlock();
+		return ret;
+	}
+
 	if (devpts_mnt)
 		return devpts_mnt->mnt_sb == s;
 	return 0;
@@ -382,7 +421,8 @@ static struct dentry *devpts_mount(struct file_system_type *fs_type,
 		if (error)
 			goto out_undo_sget;
 		s->s_flags |= MS_ACTIVE;
-	}
+	} else
+		get_devpts(DEVPTS_SB(s));
 
 	memcpy(&(DEVPTS_SB(s))->mount_opts, &opts, sizeof(opts));
 
@@ -390,6 +430,9 @@ static struct dentry *devpts_mount(struct file_system_type *fs_type,
 	if (error)
 		goto out_undo_sget;
 
+	if (opts.newinstance)
+		mnt_set_devpts(DEVPTS_SB(s));
+
 	return dget(s->s_root);
 
 out_undo_sget:
@@ -398,6 +441,7 @@ out_undo_sget:
 }
 
 #else
+
 /*
  * This supports only the legacy single-instance semantics (no
  * multiple-instance semantics)
@@ -413,7 +457,7 @@ static void devpts_kill_sb(struct super_block *sb)
 {
 	struct pts_fs_info *fsi = DEVPTS_SB(sb);
 
-	kfree(fsi);
+	put_devpts(fsi);
 	kill_litter_super(sb);
 }
 
diff --git a/fs/namespace.c b/fs/namespace.c
index aabfd30..953a972 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -31,6 +31,7 @@
 #include <linux/idr.h>
 #include <linux/fs_struct.h>
 #include <linux/fsnotify.h>
+#include <linux/devpts_fs.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include "pnode.h"
@@ -2458,6 +2459,7 @@ static struct mnt_namespace *dup_mnt_ns(struct mnt_namespace *mnt_ns,
 		p = next_mnt(p, mnt_ns->root);
 		q = next_mnt(q, new_ns->root);
 	}
+	new_ns->devpts = get_devpts(mnt_ns->devpts);
 	up_write(&namespace_sem);
 
 	if (rootmnt)
@@ -2764,6 +2766,7 @@ void put_mnt_ns(struct mnt_namespace *ns)
 	br_write_unlock(vfsmount_lock);
 	up_write(&namespace_sem);
 	release_mounts(&umount_list);
+	put_devpts(ns->devpts);
 	kfree(ns);
 }
 EXPORT_SYMBOL(put_mnt_ns);
@@ -2797,3 +2800,15 @@ bool our_mnt(struct vfsmount *mnt)
 {
 	return check_mnt(mnt);
 }
+
+void mnt_set_devpts(struct pts_fs_info *i)
+{
+	struct mnt_namespace *ns = current->nsproxy->mnt_ns;
+
+	down_write(&namespace_sem);
+	put_devpts(ns->devpts);
+	ns->devpts = get_devpts(i);
+	up_write(&namespace_sem);
+}
+
+EXPORT_SYMBOL(mnt_set_devpts);
diff --git a/include/linux/devpts_fs.h b/include/linux/devpts_fs.h
index 5ce0e5f..4b02091 100644
--- a/include/linux/devpts_fs.h
+++ b/include/linux/devpts_fs.h
@@ -25,6 +25,9 @@ int devpts_pty_new(struct inode *ptmx_inode, struct tty_struct *tty);
 struct tty_struct *devpts_get_tty(struct inode *pts_inode, int number);
 /* unlink */
 void devpts_pty_kill(struct tty_struct *tty);
+struct pts_fs_info;
+struct pts_fs_info * get_devpts(struct pts_fs_info *);
+void put_devpts(struct pts_fs_info *);
 
 #else
 
@@ -43,6 +46,10 @@ static inline struct tty_struct *devpts_get_tty(struct inode *pts_inode,
 }
 static inline void devpts_pty_kill(struct tty_struct *tty) { }
 
+struct pts_fs_info { };
+static inline struct pts_fs_info *get_devpts(struct pts_fs_info *i) { return NULL; } ;
+static inline void put_devpts(struct pts_fs_info *) { } ;
+
 #endif
 
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3f33826..bfeafaa 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1956,6 +1956,8 @@ extern int statfs_by_dentry(struct dentry *, struct kstatfs *);
 extern int freeze_super(struct super_block *super);
 extern int thaw_super(struct super_block *super);
 extern bool our_mnt(struct vfsmount *mnt);
+struct pts_fs_info;
+extern void mnt_set_devpts(struct pts_fs_info *i);
 
 extern int current_umask(void);
 
diff --git a/include/linux/mnt_namespace.h b/include/linux/mnt_namespace.h
index 2930485..571641c 100644
--- a/include/linux/mnt_namespace.h
+++ b/include/linux/mnt_namespace.h
@@ -6,12 +6,14 @@
 #include <linux/seq_file.h>
 #include <linux/wait.h>
 
+struct pts_fs_info;
 struct mnt_namespace {
 	atomic_t		count;
 	struct vfsmount *	root;
 	struct list_head	list;
 	wait_queue_head_t poll;
 	int event;
+	struct pts_fs_info	*devpts;
 };
 
 struct proc_mounts {
-- 
1.7.8.3

