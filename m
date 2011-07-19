Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375Ab1GSQaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 12:30:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:34524 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092Ab1GSQaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 12:30:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,229,1309762800"; 
   d="scan'208";a="27655273"
Subject: [Patch] VFS : mount lock scalability for files systems without
 mount point   (WAS vfsmount lock issues on very large ppc64 box)
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
        Anton Blanchard <anton@samba.org>, npiggin@kernel.dk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20110718155141.GA11013@ZenIV.linux.org.uk>
References: <20110717105027.53cc3ca4@kryten>
	 <20110717010427.GC5359@parisc-linux.org>
	 <20110717084630.GC8006@one.firstfloor.org>
	 <1310977028.5756.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20110718154008.GA29593@infradead.org>
	 <20110718155141.GA11013@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jul 2011 09:32:38 -0700
Message-ID: <1311093158.2707.75.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-18 at 16:51 +0100, Al Viro wrote:

> 
> 	Careful - we need to balance that on shutdown side with
> mnt_make_shortterm() before the final mntput()...  Making it too
> easy just on the kern_mount side will lead to easy-to-miss bugs.
> For one thing, it's visible only on SMP boxen; for another there's
> a lot of such internal vfsmounts (pipefs, sockets, etc.) that
> are never shut down, so there'll be no easily copied examples of
> what should not be forgotten on __exit side of things in obvious
> places...
> 

Al,

I've respun my patch to try to address your comments. 
Any further suggestions are welcomed.

Thanks.

Tim

---------------

For a number of file systems that don't have a mount point (e.g. sockfs
and pipefs), they are not marked as long term. Therefore in
mntput_no_expire, all locks in vfs_mount lock are taken instead of just
local cpu's lock to aggregate reference counts when we release
reference to file objects.  In fact, only local lock need to have been
taken to update ref counts as these file systems are in no danger of
going away until we are ready to unregister them. 

The attached patch marks file systems using kern_mount without 
mount point as long term.  The contentions of vfs_mount lock 
is now eliminated.  Before un-registering such file system,
kern_unmount should be called to remove the long term flag and
make the mount point ready to be freed. 

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 3f92731..708e669 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -1193,6 +1193,7 @@ static void __exit cleanup_mtdchar(void)
 {
 	unregister_mtd_user(&mtdchar_notifier);
 	mntput(mtd_inode_mnt);
+	kern_unmount(mtd_inode_mnt);
 	unregister_filesystem(&mtd_inodefs_type);
 	__unregister_chrdev(MTD_CHAR_MAJOR, 0, 1 << MINORBITS, "mtd");
 }
diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index c5567cb..3b7db2b 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -234,6 +234,7 @@ static int __init anon_inode_init(void)
 
 err_mntput:
 	mntput(anon_inode_mnt);
+	kern_unmount(anon_inode_mnt);
 err_unregister_filesystem:
 	unregister_filesystem(&anon_inode_fs_type);
 err_exit:
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 7aafeb8..0b686ce 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1030,6 +1030,7 @@ static int __init init_hugetlbfs_fs(void)
 static void __exit exit_hugetlbfs_fs(void)
 {
 	kmem_cache_destroy(hugetlbfs_inode_cachep);
+	kern_unmount(hugetlbfs_vfsmount);
 	unregister_filesystem(&hugetlbfs_fs_type);
 	bdi_destroy(&hugetlbfs_backing_dev_info);
 }
diff --git a/fs/namespace.c b/fs/namespace.c
index fe59bd1..ae8c358 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2386,6 +2386,29 @@ void mnt_make_shortterm(struct vfsmount *mnt)
 #endif
 }
 
+struct vfsmount *kern_mount(struct file_system_type *type)
+{
+	struct vfsmount *mnt;
+
+	mnt = kern_mount_data(type, NULL);
+	if (!IS_ERR(mnt)) {
+		/* it is a longterm mount, don't release mnt until */
+		/* we unmount before file sys is unregistered */
+		mnt_make_longterm(mnt);
+		mntget();
+	}
+	return mnt;
+}
+
+void kern_unmount(struct vfsmount *mnt)
+{
+	/* release long term mount so mount point can be released */
+	if (!IS_ERR_OR_NULL(mnt)) {
+		mnt_make_shortterm(mnt);
+		mntput();
+	}
+}
+
 /*
  * Allocate a new namespace structure and populate it with contents
  * copied from the namespace of the passed in task structure.
diff --git a/fs/pipe.c b/fs/pipe.c
index da42f7d..26552aa 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1291,6 +1291,7 @@ static int __init init_pipe_fs(void)
 
 static void __exit exit_pipe_fs(void)
 {
+	kern_unmount(pipe_mnt);
 	unregister_filesystem(&pipe_fs_type);
 	mntput(pipe_mnt);
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b5b9792..79f2dae 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1868,7 +1868,8 @@ static inline int sb_is_dirty(struct super_block *sb)
 extern int register_filesystem(struct file_system_type *);
 extern int unregister_filesystem(struct file_system_type *);
 extern struct vfsmount *kern_mount_data(struct file_system_type *, void *data);
-#define kern_mount(type) kern_mount_data(type, NULL)
+extern struct vfsmount *kern_mount(struct file_system_type *type);
+extern void kern_unmount(struct vfsmount *mnt);
 extern int may_umount_tree(struct vfsmount *);
 extern int may_umount(struct vfsmount *);
 extern long do_mount(char *, char *, char *, unsigned long, void *);
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 3545934..de7900e 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -1984,6 +1984,7 @@ __initcall(init_sel_fs);
 void exit_sel_fs(void)
 {
 	kobject_put(selinuxfs_kobj);
+	kern_unmount(selinuxfs_mount);
 	unregister_filesystem(&sel_fs_type);
 }
 #endif


