Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab1GVAYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 20:24:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:53008 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974Ab1GVAYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 20:24:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,244,1309762800"; 
   d="scan'208";a="28770033"
Subject: Re: [Patch] VFS : mount lock scalability for files systems without
 mount point   (WAS vfsmount lock issues on very large ppc64 box)
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
        Anton Blanchard <anton@samba.org>, npiggin@kernel.dk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20110721204042.GB31405@ZenIV.linux.org.uk>
References: <20110717105027.53cc3ca4@kryten>
	 <20110717010427.GC5359@parisc-linux.org>
	 <20110717084630.GC8006@one.firstfloor.org>
	 <1310977028.5756.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20110718154008.GA29593@infradead.org>
	 <20110718155141.GA11013@ZenIV.linux.org.uk>
	 <1311093158.2707.75.camel@schen9-DESK>
	 <20110721204042.GB31405@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jul 2011 17:27:32 -0700
Message-ID: <1311294452.2576.18.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-21 at 21:40 +0100, Al Viro wrote:
> On Tue, Jul 19, 2011 at 09:32:38AM -0700, Tim Chen wrote:
> > @@ -1193,6 +1193,7 @@ static void __exit cleanup_mtdchar(void)
> >  {
> >  	unregister_mtd_user(&mtdchar_notifier);
> >  	mntput(mtd_inode_mnt);
> > +	kern_unmount(mtd_inode_mnt);
> 
> Surely you want to merge that mntput() in there...
> 

I've now merged mntput found in file system exit code of mtdchar,
anon_inodes, and pipefs.  There wasn't any mntput originally in exit
code of hugetlbfs and selinux_fs.  I think the mntput in kern_unmount
for them should still be valid. 

> > +void kern_unmount(struct vfsmount *mnt)
> > +{
> > +	/* release long term mount so mount point can be released */
> > +	if (!IS_ERR_OR_NULL(mnt)) {
> > +		mnt_make_shortterm(mnt);
> > +		mntput();
> > +	}
> > +}
> 
> ... and if you pass it the argument, it'll be much happier.

I must be pretty brain dead in the morning and not tested the 
mntput tweaks in the final patch sent properly.  My apology.  
It's fixed now.

Thanks.

Tim

-------------

For a number of file systems that don't have a mount point (e.g. sockfs
and pipefs), they are not marked as long term. Therefore in
mntput_no_expire, all locks in vfs_mount lock are taken instead of just
local cpu's lock to aggregate reference counts when we release
reference to file objects.  In fact, only local lock need to have been
taken to update ref counts as these file systems are in no danger of
going away until we are ready to unregister them. 

The attached patch marks file systems using kern_mount without 
actual mount point as long term.  The contentions of 
vfs_mount lock is now eliminated.  Before un-registering such file
system, kern_unmount should be called to remove the long term flag and
make the mount point ready to be freed. 

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 3f92731..f1af222 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -1192,7 +1192,7 @@ err_unregister_chdev:
 static void __exit cleanup_mtdchar(void)
 {
 	unregister_mtd_user(&mtdchar_notifier);
-	mntput(mtd_inode_mnt);
+	kern_unmount(mtd_inode_mnt);
 	unregister_filesystem(&mtd_inodefs_type);
 	__unregister_chrdev(MTD_CHAR_MAJOR, 0, 1 << MINORBITS, "mtd");
 }
diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index c5567cb..4d433d3 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -233,7 +233,7 @@ static int __init anon_inode_init(void)
 	return 0;
 
 err_mntput:
-	mntput(anon_inode_mnt);
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
index fe59bd1..50d71a9 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2386,6 +2386,28 @@ void mnt_make_shortterm(struct vfsmount *mnt)
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
+	}
+	return mnt;
+}
+
+void kern_unmount(struct vfsmount *mnt)
+{
+	/* release long term mount so mount point can be released */
+	if (!IS_ERR_OR_NULL(mnt)) {
+		mnt_make_shortterm(mnt);
+		mntput(mnt);
+	}
+}
+
 /*
  * Allocate a new namespace structure and populate it with contents
  * copied from the namespace of the passed in task structure.
diff --git a/fs/pipe.c b/fs/pipe.c
index da42f7d..1b7f9af 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1291,8 +1291,8 @@ static int __init init_pipe_fs(void)
 
 static void __exit exit_pipe_fs(void)
 {
+	kern_unmount(pipe_mnt);
 	unregister_filesystem(&pipe_fs_type);
-	mntput(pipe_mnt);
 }
 
 fs_initcall(init_pipe_fs);
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



