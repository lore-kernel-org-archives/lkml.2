Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555Ab1LERCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:02:50 -0500
Received: from gimli.pitney-fabs.co.uk ([87.106.140.52]:35468 "EHLO
	gimli.pitney-fabs.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522Ab1LERCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:02:49 -0500
Date: Mon, 5 Dec 2011 17:02:45 +0000
From: Andrew Walrond <andrew@walrond.org>
To: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] Use tmpfs rather tham ramfs for rootfs when available
Message-ID: <20111205170244.GA16014@golden.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make rootfs an instance of tmpfs instead of ramfs when tmpfs is available.

Documentation/filesystems/ramfs-rootfs-initramfs.txt says:
"Rootfs is a special instance of ramfs (or tmpfs, if that's enabled)"
but it has always been a lie, until now.

This patch is based upon one proposed by Bodo Eggert in 2008.
---
 fs/ramfs/inode.c |    6 ++++++
 mm/shmem.c       |   31 +++++++++++++++++++++++++++----
 2 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index 462ceb3..e8a5c7f 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -260,11 +260,13 @@ struct dentry *ramfs_mount(struct file_system_type *fs_type,
 	return mount_nodev(fs_type, flags, data, ramfs_fill_super);
 }
 
+#if !(defined CONFIG_SHMEM && defined CONFIG_TMPFS)
 static struct dentry *rootfs_mount(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
 {
 	return mount_nodev(fs_type, flags|MS_NOUSER, data, ramfs_fill_super);
 }
+#endif
 
 static void ramfs_kill_sb(struct super_block *sb)
 {
@@ -277,11 +279,13 @@ static struct file_system_type ramfs_fs_type = {
 	.mount		= ramfs_mount,
 	.kill_sb	= ramfs_kill_sb,
 };
+#if !(defined CONFIG_SHMEM && defined CONFIG_TMPFS)
 static struct file_system_type rootfs_fs_type = {
 	.name		= "rootfs",
 	.mount		= rootfs_mount,
 	.kill_sb	= kill_litter_super,
 };
+#endif
 
 static int __init init_ramfs_fs(void)
 {
@@ -289,6 +293,7 @@ static int __init init_ramfs_fs(void)
 }
 module_init(init_ramfs_fs)
 
+#if !(defined CONFIG_SHMEM && defined CONFIG_TMPFS)
 int __init init_rootfs(void)
 {
 	int err;
@@ -303,3 +308,4 @@ int __init init_rootfs(void)
 
 	return err;
 }
+#endif
diff --git a/mm/shmem.c b/mm/shmem.c
index d672250..9b7af22 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2220,7 +2220,7 @@ failed:
 	return err;
 }
 
-static struct kmem_cache *shmem_inode_cachep;
+static struct kmem_cache *shmem_inode_cachep = NULL;
 
 static struct inode *shmem_alloc_inode(struct super_block *sb)
 {
@@ -2253,9 +2253,11 @@ static void shmem_init_inode(void *foo)
 
 static int shmem_init_inodecache(void)
 {
-	shmem_inode_cachep = kmem_cache_create("shmem_inode_cache",
-				sizeof(struct shmem_inode_info),
-				0, SLAB_PANIC, shmem_init_inode);
+	if (!shmem_inode_cachep)
+		shmem_inode_cachep =
+			kmem_cache_create("shmem_inode_cache",
+					  sizeof(struct shmem_inode_info),
+					  0, SLAB_PANIC, shmem_init_inode);
 	return 0;
 }
 
@@ -2407,6 +2409,27 @@ out4:
 	return error;
 }
 
+#ifdef CONFIG_TMPFS
+static struct dentry *rootfs_mount(struct file_system_type *fs_type,
+				   int flags, const char *dev_name, void *data)
+{
+	return mount_nodev(fs_type, flags|MS_NOUSER, data, shmem_fill_super);
+}
+
+static struct file_system_type rootfs_fs_type = {
+	.name		= "rootfs",
+	.mount	        = rootfs_mount,
+	.kill_sb	= kill_litter_super,
+};
+
+int __init init_rootfs(void)
+{
+	if (shmem_init_inodecache())
+		panic("Rootfs - Can't initialize shm inode cache");
+	return register_filesystem(&rootfs_fs_type);
+}
+#endif
+
 #else /* !CONFIG_SHMEM */
 
 /*
-- 
1.7.2.3

