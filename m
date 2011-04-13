Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933185Ab1DMV7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 17:59:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:28292 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758403Ab1DMV7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 17:59:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,207,1301900400"; 
   d="scan'208";a="628188417"
Subject: [PATCH] vfs: make vfs_mount lock scale for file systems without
 mount point
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>
Cc: Matthew Wilcox <willy@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>, Tony Luck <tony.luck@intel.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Matt Fleming <matt.fleming@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 15:00:11 -0700
Message-ID: <1302732011.2592.102.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For a number of file systems that don't have a mount point (e.g. sockfs
and pipefs), they are not marked as long term. Therefore in
mntput_no_expire, all locks in vfs_mount lock are taken instead of just
local cpu's lock to aggregate reference counts when we release
reference to file objects.  In fact, only local lock need to have been
taken to update ref counts as these file systems are in no danger of
going away unless we are ready to unregister them and we do not need to
check ref count aggregate going to 0 to free the mount structure. For an
exim mail server workload with 96 clients running on a 4 socket
Nehalem-EX system, 37% of cpu time is in contention for the
vfsmount_lock due to heavy use of mntput_no_expire when many pipes and
sockets being opened and closed.

The attached patch marks file systems without mount point as long term.
The contentions of vfs_mount lock is now completely eliminated.  

I have considered consolidating call to mnt_make_longterm from within
kern_mount.  However, there are cases like mtd_inode_fs which can
release the file system, making it necessary to make explicit call to
mnt_make_shortterm instead from somewhere like a kern_unmount before
doing the final mntput.  So I opted to leave explicit mnt_make_longterm
call after the respective file systems are registered so people will
remember to add the mnt_make_shortterm call if they decide to unregister
the file system at some point.  It is a bit ugly as Nick and Alexander's
original implementation meant to hide mnt_make_longterm and
mnt_make_shortterm.  Suggestions on better implementations are welcomed.


Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index 89accc6..3e4d5ba 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -1557,6 +1557,7 @@ init_pfm_fs(void)
 			unregister_filesystem(&pfm_fs_type);
 		else
 			err = 0;
+		mnt_make_longterm(pfm_fs_type);
 	}
 	return err;
 }
diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 145b3d0d..0e8b487 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -1187,6 +1187,7 @@ static int __init init_mtdchar(void)
 		pr_notice("Error mounting mtd_inodefs filesystem: %d\n", ret);
 		goto err_unregister_filesystem;
 	}
+	mnt_make_longterm(mtd_inode_mnt);
 	register_mtd_user(&mtdchar_notifier);
 
 	return ret;
@@ -1201,6 +1202,7 @@ err_unregister_chdev:
 static void __exit cleanup_mtdchar(void)
 {
 	unregister_mtd_user(&mtdchar_notifier);
+	mnt_make_shortterm(mtd_inode_mnt);
 	mntput(mtd_inode_mnt);
 	unregister_filesystem(&mtd_inodefs_type);
 	__unregister_chrdev(MTD_CHAR_MAJOR, 0, 1 << MINORBITS, "mtd");
diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index c5567cb..f8f3656 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -229,6 +229,7 @@ static int __init anon_inode_init(void)
 		error = PTR_ERR(anon_inode_inode);
 		goto err_mntput;
 	}
+	mnt_make_longterm(anon_inode_mnt);
 
 	return 0;
 
diff --git a/fs/block_dev.c b/fs/block_dev.c
index c1511c6..81c578d 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -501,6 +501,7 @@ void __init bdev_cache_init(void)
 	bd_mnt = kern_mount(&bd_type);
 	if (IS_ERR(bd_mnt))
 		panic("Cannot create bdev pseudo-fs");
+	mnt_make_longterm(bd_mnt);
 	/*
 	 * This vfsmount structure is only used to obtain the
 	 * blockdev_superblock, so tell kmemleak not to report it.
diff --git a/fs/namespace.c b/fs/namespace.c
index 7dba2ed..c474853 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2386,10 +2386,16 @@ static struct mnt_namespace *alloc_mnt_ns(void)
 	return new_ns;
 }
 
+/* For file systems that don't have mount point, we should call mnt_make_longterm after
+ * registering the file system so the more efficient read_lock instead of write_lock 
+ * will be taken for vfsmount_lock when we release reference to objects in the 
+ * file systems.  Before the file system is unregistered, we should call mnt_make_shortterm.
+ */
 void mnt_make_longterm(struct vfsmount *mnt)
 {
 	__mnt_make_longterm(mnt);
 }
+EXPORT_SYMBOL_GPL(mnt_make_longterm);
 
 void mnt_make_shortterm(struct vfsmount *mnt)
 {
@@ -2401,6 +2407,7 @@ void mnt_make_shortterm(struct vfsmount *mnt)
 	br_write_unlock(vfsmount_lock);
 #endif
 }
+EXPORT_SYMBOL_GPL(mnt_make_shortterm);
 
 /*
  * Allocate a new namespace structure and populate it with contents
diff --git a/fs/pipe.c b/fs/pipe.c
index da42f7d..05b38c1 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1285,12 +1285,14 @@ static int __init init_pipe_fs(void)
 			err = PTR_ERR(pipe_mnt);
 			unregister_filesystem(&pipe_fs_type);
 		}
+		mnt_make_longterm(pipe_mnt);
 	}
 	return err;
 }
 
 static void __exit exit_pipe_fs(void)
 {
+	mnt_make_shortterm(pipe_mnt);
 	unregister_filesystem(&pipe_fs_type);
 	mntput(pipe_mnt);
 }
diff --git a/include/linux/mount.h b/include/linux/mount.h
index 604f122..a7c9030 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -112,5 +112,7 @@ extern void mnt_set_expiry(struct vfsmount *mnt, struct list_head *expiry_list);
 extern void mark_mounts_for_expiry(struct list_head *mounts);
 
 extern dev_t name_to_dev_t(char *name);
+extern void mnt_make_longterm(struct vfsmount *mnt);
+extern void mnt_make_shortterm(struct vfsmount *mnt);
 
 #endif /* _LINUX_MOUNT_H */
diff --git a/net/socket.c b/net/socket.c
index 5212447..a66d034 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2423,6 +2423,7 @@ static int __init sock_init(void)
 		err = PTR_ERR(sock_mnt);
 		goto out_mount;
 	}
+	mnt_make_longterm(sock_mnt);
 
 	/* The real protocol initialization is performed in later initcalls.
 	 */



