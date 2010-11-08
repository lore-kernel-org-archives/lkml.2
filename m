Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab0KHH3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 02:29:52 -0500
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:57503 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753039Ab0KHH3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 02:29:48 -0500
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, paulmck@linux.vnet.ibm.com
Subject: [PATCH 2/4] fs: Convert inode slab creation to use consistent parameters
Date: Mon,  8 Nov 2010 18:28:23 +1100
Message-Id: <1289201305-14866-3-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1289201305-14866-1-git-send-email-david@fromorbit.com>
References: <1289201305-14866-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The inode slab creation functions in different filesystem don't all set up the
slab caches correctly. Add a new flag SLAB_INODES that sets all the necessary
flags for an inode slab cache and convert all the callers to use it. THis makes
it easy to change the behaviour of all the inode slab caches in one go.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 Documentation/filesystems/porting |    5 +++++
 fs/adfs/super.c                   |    3 +--
 fs/affs/super.c                   |    3 +--
 fs/afs/super.c                    |    7 +++----
 fs/befs/linuxvfs.c                |    3 +--
 fs/bfs/inode.c                    |    3 +--
 fs/btrfs/inode.c                  |    2 +-
 fs/ceph/super.c                   |    3 +--
 fs/cifs/cifsfs.c                  |    3 +--
 fs/coda/inode.c                   |    3 +--
 fs/efs/super.c                    |    3 +--
 fs/exofs/super.c                  |    3 +--
 fs/ext2/super.c                   |    3 +--
 fs/ext3/super.c                   |    3 +--
 fs/ext4/super.c                   |    3 +--
 fs/fat/inode.c                    |    3 +--
 fs/freevxfs/vxfs_super.c          |    2 +-
 fs/fuse/inode.c                   |    6 +++---
 fs/gfs2/main.c                    |    3 +--
 fs/hfs/super.c                    |    3 ++-
 fs/hfsplus/super.c                |    3 ++-
 fs/hpfs/super.c                   |    3 +--
 fs/hugetlbfs/inode.c              |    2 +-
 fs/inode.c                        |    4 +---
 fs/isofs/inode.c                  |    4 +---
 fs/jffs2/super.c                  |    3 +--
 fs/jfs/super.c                    |    3 +--
 fs/logfs/inode.c                  |    2 +-
 fs/minix/inode.c                  |    3 +--
 fs/ncpfs/inode.c                  |    3 +--
 fs/nfs/inode.c                    |    3 +--
 fs/nilfs2/super.c                 |    4 ++--
 fs/ntfs/super.c                   |    3 ++-
 fs/ocfs2/dlmfs/dlmfs.c            |    3 +--
 fs/ocfs2/super.c                  |    4 +---
 fs/openpromfs/inode.c             |    4 +---
 fs/proc/inode.c                   |    3 +--
 fs/qnx4/inode.c                   |    3 +--
 fs/reiserfs/super.c               |    7 ++-----
 fs/romfs/super.c                  |    3 +--
 fs/squashfs/super.c               |    3 ++-
 fs/sysv/inode.c                   |    3 +--
 fs/ubifs/super.c                  |    2 +-
 fs/udf/super.c                    |    3 +--
 fs/ufs/super.c                    |    3 +--
 fs/xfs/linux-2.6/kmem.h           |    1 +
 fs/xfs/linux-2.6/xfs_super.c      |    4 ++--
 include/linux/slab.h              |    6 ++++++
 ipc/mqueue.c                      |    3 ++-
 mm/shmem.c                        |    2 +-
 net/socket.c                      |    9 +++------
 net/sunrpc/rpc_pipe.c             |    5 ++---
 52 files changed, 76 insertions(+), 102 deletions(-)

diff --git a/Documentation/filesystems/porting b/Documentation/filesystems/porting
index 2da4b44..b68438b 100644
--- a/Documentation/filesystems/porting
+++ b/Documentation/filesystems/porting
@@ -319,3 +319,8 @@ if it's zero is not *and* *never* *had* *been* enough.  Final unlink() and iput(
 may happen while the inode is in the middle of ->write_inode(); e.g. if you blindly
 free the on-disk inode, you may end up doing that while ->write_inode() is writing
 to it.
+
+[mandatory]
+	Inodes must be allocated via a slab cache created with the
+SLAB_INODE_CACHE flag set. This sets all the necessary slab cache flags for
+correct operation and control of the cache across the system.
diff --git a/fs/adfs/super.c b/fs/adfs/super.c
index 959dbff..bcdf6cc 100644
--- a/fs/adfs/super.c
+++ b/fs/adfs/super.c
@@ -256,8 +256,7 @@ static int init_inodecache(void)
 {
 	adfs_inode_cachep = kmem_cache_create("adfs_inode_cache",
 					     sizeof(struct adfs_inode_info),
-					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+					     0, SLAB_INODE_CACHE,
 					     init_once);
 	if (adfs_inode_cachep == NULL)
 		return -ENOMEM;
diff --git a/fs/affs/super.c b/fs/affs/super.c
index 0cf7f43..cb335c6 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -113,8 +113,7 @@ static int init_inodecache(void)
 {
 	affs_inode_cachep = kmem_cache_create("affs_inode_cache",
 					     sizeof(struct affs_inode_info),
-					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+					     0, SLAB_INODE_CACHE,
 					     init_once);
 	if (affs_inode_cachep == NULL)
 		return -ENOMEM;
diff --git a/fs/afs/super.c b/fs/afs/super.c
index 27201cf..8995f48 100644
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -87,10 +87,9 @@ int __init afs_fs_init(void)
 
 	ret = -ENOMEM;
 	afs_inode_cachep = kmem_cache_create("afs_inode_cache",
-					     sizeof(struct afs_vnode),
-					     0,
-					     SLAB_HWCACHE_ALIGN,
-					     afs_i_init_once);
+					sizeof(struct afs_vnode), 0,
+					SLAB_HWCACHE_ALIGN | SLAB_INODE_CACHE,
+					afs_i_init_once);
 	if (!afs_inode_cachep) {
 		printk(KERN_NOTICE "kAFS: Failed to allocate inode cache\n");
 		return ret;
diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index aa4e7c7..d95dab2 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -431,8 +431,7 @@ befs_init_inodecache(void)
 {
 	befs_inode_cachep = kmem_cache_create("befs_inode_cache",
 					      sizeof (struct befs_inode_info),
-					      0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+					      0, SLAB_INODE_CACHE,
 					      init_once);
 	if (befs_inode_cachep == NULL) {
 		printk(KERN_ERR "befs_init_inodecache: "
diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index 76db6d7..c76a689 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -264,8 +264,7 @@ static int init_inodecache(void)
 {
 	bfs_inode_cachep = kmem_cache_create("bfs_inode_cache",
 					     sizeof(struct bfs_inode_info),
-					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+					     0, SLAB_INODE_CACHE,
 					     init_once);
 	if (bfs_inode_cachep == NULL)
 		return -ENOMEM;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 64f99cf..80d0a64 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6369,7 +6369,7 @@ int btrfs_init_cachep(void)
 {
 	btrfs_inode_cachep = kmem_cache_create("btrfs_inode_cache",
 			sizeof(struct btrfs_inode), 0,
-			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, init_once);
+			SLAB_INODE_CACHE, init_once);
 	if (!btrfs_inode_cachep)
 		goto fail;
 
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 08b460a..72e40f0 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -521,8 +521,7 @@ static int __init init_caches(void)
 	ceph_inode_cachep = kmem_cache_create("ceph_inode_info",
 				      sizeof(struct ceph_inode_info),
 				      __alignof__(struct ceph_inode_info),
-				      (SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD),
-				      ceph_inode_init_once);
+				      SLAB_INODE_CACHE, ceph_inode_init_once);
 	if (ceph_inode_cachep == NULL)
 		return -ENOMEM;
 
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 8bd5c2c..34fc2b5 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -784,8 +784,7 @@ cifs_init_inodecache(void)
 {
 	cifs_inode_cachep = kmem_cache_create("cifs_inode_cache",
 					      sizeof(struct cifsInodeInfo),
-					      0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+					      0, SLAB_INODE_CACHE,
 					      cifs_init_once);
 	if (cifs_inode_cachep == NULL)
 		return -ENOMEM;
diff --git a/fs/coda/inode.c b/fs/coda/inode.c
index 5ea57c8..fc0f4a1 100644
--- a/fs/coda/inode.c
+++ b/fs/coda/inode.c
@@ -72,8 +72,7 @@ int coda_init_inodecache(void)
 {
 	coda_inode_cachep = kmem_cache_create("coda_inode_cache",
 				sizeof(struct coda_inode_info),
-				0, SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD,
-				init_once);
+				0, SLAB_INODE_CACHE, init_once);
 	if (coda_inode_cachep == NULL)
 		return -ENOMEM;
 	return 0;
diff --git a/fs/efs/super.c b/fs/efs/super.c
index 5073a07..c6ee8eb 100644
--- a/fs/efs/super.c
+++ b/fs/efs/super.c
@@ -81,8 +81,7 @@ static int init_inodecache(void)
 {
 	efs_inode_cachep = kmem_cache_create("efs_inode_cache",
 				sizeof(struct efs_inode_info),
-				0, SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD,
-				init_once);
+				0, SLAB_INODE_CACHE, init_once);
 	if (efs_inode_cachep == NULL)
 		return -ENOMEM;
 	return 0;
diff --git a/fs/exofs/super.c b/fs/exofs/super.c
index 79c3ae6..cd5e908 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -175,8 +175,7 @@ static int init_inodecache(void)
 {
 	exofs_inode_cachep = kmem_cache_create("exofs_inode_cache",
 				sizeof(struct exofs_i_info), 0,
-				SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
-				exofs_init_once);
+				SLAB_INODE_CACHE, exofs_init_once);
 	if (exofs_inode_cachep == NULL)
 		return -ENOMEM;
 	return 0;
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index d89e0b6..87bdcee 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -182,8 +182,7 @@ static int init_inodecache(void)
 {
 	ext2_inode_cachep = kmem_cache_create("ext2_inode_cache",
 					     sizeof(struct ext2_inode_info),
-					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+					     0, SLAB_INODE_CACHE,
 					     init_once);
 	if (ext2_inode_cachep == NULL)
 		return -ENOMEM;
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 2fedaf8..3cd2e00 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -509,8 +509,7 @@ static int init_inodecache(void)
 {
 	ext3_inode_cachep = kmem_cache_create("ext3_inode_cache",
 					     sizeof(struct ext3_inode_info),
-					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+					     0, SLAB_INODE_CACHE,
 					     init_once);
 	if (ext3_inode_cachep == NULL)
 		return -ENOMEM;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 40131b7..ee94fbc3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -862,8 +862,7 @@ static int init_inodecache(void)
 {
 	ext4_inode_cachep = kmem_cache_create("ext4_inode_cache",
 					     sizeof(struct ext4_inode_info),
-					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+					     0, SLAB_INODE_CACHE,
 					     init_once);
 	if (ext4_inode_cachep == NULL)
 		return -ENOMEM;
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index ad6998a..84d8cde 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -535,8 +535,7 @@ static int __init fat_init_inodecache(void)
 {
 	fat_inode_cachep = kmem_cache_create("fat_inode_cache",
 					     sizeof(struct msdos_inode_info),
-					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+					     0, SLAB_INODE_CACHE,
 					     init_once);
 	if (fat_inode_cachep == NULL)
 		return -ENOMEM;
diff --git a/fs/freevxfs/vxfs_super.c b/fs/freevxfs/vxfs_super.c
index 9d1c995..225f18a 100644
--- a/fs/freevxfs/vxfs_super.c
+++ b/fs/freevxfs/vxfs_super.c
@@ -267,7 +267,7 @@ vxfs_init(void)
 
 	vxfs_inode_cachep = kmem_cache_create("vxfs_inode",
 			sizeof(struct vxfs_inode_info), 0,
-			SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD, NULL);
+			SLAB_INODE_CACHE, NULL);
 	if (!vxfs_inode_cachep)
 		return -ENOMEM;
 	rv = register_filesystem(&vxfs_fs_type);
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index cfce3ad..df9c272 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1138,9 +1138,9 @@ static int __init fuse_fs_init(void)
 		goto out_unreg;
 
 	fuse_inode_cachep = kmem_cache_create("fuse_inode",
-					      sizeof(struct fuse_inode),
-					      0, SLAB_HWCACHE_ALIGN,
-					      fuse_inode_init_once);
+					sizeof(struct fuse_inode), 0,
+					SLAB_HWCACHE_ALIGN | SLAB_INODE_CACHE,
+					fuse_inode_init_once);
 	err = -ENOMEM;
 	if (!fuse_inode_cachep)
 		goto out_unreg2;
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index ebef7ab..3100429 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -108,8 +108,7 @@ static int __init init_gfs2_fs(void)
 
 	gfs2_inode_cachep = kmem_cache_create("gfs2_inode",
 					      sizeof(struct gfs2_inode),
-					      0,  SLAB_RECLAIM_ACCOUNT|
-					          SLAB_MEM_SPREAD,
+					      0, SLAB_INODE_CACHE,
 					      gfs2_init_inode_once);
 	if (!gfs2_inode_cachep)
 		goto fail;
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index 4824c27..dc1a909 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -467,7 +467,8 @@ static int __init init_hfs_fs(void)
 	int err;
 
 	hfs_inode_cachep = kmem_cache_create("hfs_inode_cache",
-		sizeof(struct hfs_inode_info), 0, SLAB_HWCACHE_ALIGN,
+		sizeof(struct hfs_inode_info), 0,
+		SLAB_HWCACHE_ALIGN | SLAB_INODE_CACHE,
 		hfs_init_once);
 	if (!hfs_inode_cachep)
 		return -ENOMEM;
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index 52cc746..ecce369 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -521,7 +521,8 @@ static int __init init_hfsplus_fs(void)
 	int err;
 
 	hfsplus_inode_cachep = kmem_cache_create("hfsplus_icache",
-		HFSPLUS_INODE_SIZE, 0, SLAB_HWCACHE_ALIGN,
+		HFSPLUS_INODE_SIZE, 0,
+		SLAB_HWCACHE_ALIGN | SLAB_INODE_CACHE,
 		hfsplus_init_once);
 	if (!hfsplus_inode_cachep)
 		return -ENOMEM;
diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index bb69389..2fba9e0 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -195,8 +195,7 @@ static int init_inodecache(void)
 {
 	hpfs_inode_cachep = kmem_cache_create("hpfs_inode_cache",
 					     sizeof(struct hpfs_inode_info),
-					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+					     0, SLAB_INODE_CACHE,
 					     init_once);
 	if (hpfs_inode_cachep == NULL)
 		return -ENOMEM;
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index d6cfac1..8170b8d 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -996,7 +996,7 @@ static int __init init_hugetlbfs_fs(void)
 
 	hugetlbfs_inode_cachep = kmem_cache_create("hugetlbfs_inode_cache",
 					sizeof(struct hugetlbfs_inode_info),
-					0, 0, init_once);
+					0, SLAB_INODE_CACHE, init_once);
 	if (hugetlbfs_inode_cachep == NULL)
 		goto out2;
 
diff --git a/fs/inode.c b/fs/inode.c
index fc3b0a5..5592d74 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1697,9 +1697,7 @@ void __init inode_init(void)
 	/* inode slab cache */
 	inode_cachep = kmem_cache_create("inode_cache",
 					 sizeof(struct inode),
-					 0,
-					 (SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|
-					 SLAB_MEM_SPREAD),
+					 0, SLAB_INODE_CACHE | SLAB_PANIC,
 					 init_once);
 	register_shrinker(&icache_shrinker);
 	percpu_counter_init(&nr_inodes, 0);
diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index bfdeb82..32e2adf 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -81,9 +81,7 @@ static int init_inodecache(void)
 {
 	isofs_inode_cachep = kmem_cache_create("isofs_inode_cache",
 					sizeof(struct iso_inode_info),
-					0, (SLAB_RECLAIM_ACCOUNT|
-					SLAB_MEM_SPREAD),
-					init_once);
+					0, SLAB_INODE_CACHE, init_once);
 	if (isofs_inode_cachep == NULL)
 		return -ENOMEM;
 	return 0;
diff --git a/fs/jffs2/super.c b/fs/jffs2/super.c
index c86041b..b056fd1 100644
--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -259,8 +259,7 @@ static int __init init_jffs2_fs(void)
 
 	jffs2_inode_cachep = kmem_cache_create("jffs2_i",
 					     sizeof(struct jffs2_inode_info),
-					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+					     0, SLAB_INODE_CACHE,
 					     jffs2_i_init_once);
 	if (!jffs2_inode_cachep) {
 		printk(KERN_ERR "JFFS2 error: Failed to initialise inode cache\n");
diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 0669fc1..87d8ecc 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -795,8 +795,7 @@ static int __init init_jfs_fs(void)
 
 	jfs_inode_cachep =
 	    kmem_cache_create("jfs_ip", sizeof(struct jfs_inode_info), 0,
-			    SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD,
-			    init_once);
+					     SLAB_INODE_CACHE, init_once);
 	if (jfs_inode_cachep == NULL)
 		return -ENOMEM;
 
diff --git a/fs/logfs/inode.c b/fs/logfs/inode.c
index 38c559e..ab812c2 100644
--- a/fs/logfs/inode.c
+++ b/fs/logfs/inode.c
@@ -385,7 +385,7 @@ const struct super_operations logfs_super_operations = {
 int logfs_init_inode_cache(void)
 {
 	logfs_inode_cache = kmem_cache_create("logfs_inode_cache",
-			sizeof(struct logfs_inode), 0, SLAB_RECLAIM_ACCOUNT,
+			sizeof(struct logfs_inode), 0, SLAB_INODE_CACHE,
 			logfs_init_once);
 	if (!logfs_inode_cache)
 		return -ENOMEM;
diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index fb20208..cb0a7f8 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -84,8 +84,7 @@ static int init_inodecache(void)
 {
 	minix_inode_cachep = kmem_cache_create("minix_inode_cache",
 					     sizeof(struct minix_inode_info),
-					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+					     0, SLAB_INODE_CACHE,
 					     init_once);
 	if (minix_inode_cachep == NULL)
 		return -ENOMEM;
diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
index d290545..bf4394f 100644
--- a/fs/ncpfs/inode.c
+++ b/fs/ncpfs/inode.c
@@ -76,8 +76,7 @@ static int init_inodecache(void)
 {
 	ncp_inode_cachep = kmem_cache_create("ncp_inode_cache",
 					     sizeof(struct ncp_inode_info),
-					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+					     0, SLAB_INODE_CACHE,
 					     init_once);
 	if (ncp_inode_cachep == NULL)
 		return -ENOMEM;
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 314f571..5f3ca89 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1474,8 +1474,7 @@ static int __init nfs_init_inodecache(void)
 {
 	nfs_inode_cachep = kmem_cache_create("nfs_inode_cache",
 					     sizeof(struct nfs_inode),
-					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+					     0, SLAB_INODE_CACHE,
 					     init_once);
 	if (nfs_inode_cachep == NULL)
 		return -ENOMEM;
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index f804d41..19696af 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1287,8 +1287,8 @@ static void nilfs_destroy_cachep(void)
 static int __init nilfs_init_cachep(void)
 {
 	nilfs_inode_cachep = kmem_cache_create("nilfs2_inode_cache",
-			sizeof(struct nilfs_inode_info), 0,
-			SLAB_RECLAIM_ACCOUNT, nilfs_inode_init_once);
+			sizeof(struct nilfs_inode_info), 0, SLAB_INODE_CACHE,
+			nilfs_inode_init_once);
 	if (!nilfs_inode_cachep)
 		goto fail;
 
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index a30ecacc..1922450 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -3136,9 +3136,10 @@ static int __init init_ntfs_fs(void)
 		goto inode_err_out;
 	}
 
+	/* ntfs_big_inode_cache is the inode cache used for VFS level inodes */
 	ntfs_big_inode_cache = kmem_cache_create(ntfs_big_inode_cache_name,
 			sizeof(big_ntfs_inode), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD,
+			SLAB_HWCACHE_ALIGN | SLAB_INODE_CACHE,
 			ntfs_big_inode_init_once);
 	if (!ntfs_big_inode_cache) {
 		printk(KERN_CRIT "NTFS: Failed to create %s!\n",
diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index b2df490..1eb031e 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -669,8 +669,7 @@ static int __init init_dlmfs_fs(void)
 
 	dlmfs_inode_cache = kmem_cache_create("dlmfs_inode_cache",
 				sizeof(struct dlmfs_inode_private),
-				0, (SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|
-					SLAB_MEM_SPREAD),
+				0, (SLAB_HWCACHE_ALIGN|SLAB_INODE_CACHE),
 				dlmfs_init_once);
 	if (!dlmfs_inode_cache) {
 		status = -ENOMEM;
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index f02c0ef..1a15357 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1791,9 +1791,7 @@ static int ocfs2_initialize_mem_caches(void)
 {
 	ocfs2_inode_cachep = kmem_cache_create("ocfs2_inode_cache",
 				       sizeof(struct ocfs2_inode_info),
-				       0,
-				       (SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+				       0, (SLAB_HWCACHE_ALIGN|SLAB_INODE_CACHE),
 				       ocfs2_inode_init_once);
 	ocfs2_dquot_cachep = kmem_cache_create("ocfs2_dquot_cache",
 					sizeof(struct ocfs2_dquot),
diff --git a/fs/openpromfs/inode.c b/fs/openpromfs/inode.c
index ddb1f41..87763f8 100644
--- a/fs/openpromfs/inode.c
+++ b/fs/openpromfs/inode.c
@@ -441,9 +441,7 @@ static int __init init_openprom_fs(void)
 
 	op_inode_cachep = kmem_cache_create("op_inode_cache",
 					    sizeof(struct op_inode_info),
-					    0,
-					    (SLAB_RECLAIM_ACCOUNT |
-					     SLAB_MEM_SPREAD),
+					    0, SLAB_INODE_CACHE,
 					    op_inode_init_once);
 	if (!op_inode_cachep)
 		return -ENOMEM;
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 9c2b5f4..ef1c2b3 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -82,8 +82,7 @@ void __init proc_init_inodecache(void)
 {
 	proc_inode_cachep = kmem_cache_create("proc_inode_cache",
 					     sizeof(struct proc_inode),
-					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD|SLAB_PANIC),
+					     0, SLAB_INODE_CACHE | SLAB_PANIC,
 					     init_once);
 }
 
diff --git a/fs/qnx4/inode.c b/fs/qnx4/inode.c
index fcada42..692c74d3 100644
--- a/fs/qnx4/inode.c
+++ b/fs/qnx4/inode.c
@@ -441,8 +441,7 @@ static int init_inodecache(void)
 {
 	qnx4_inode_cachep = kmem_cache_create("qnx4_inode_cache",
 					     sizeof(struct qnx4_inode_info),
-					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+					     0, SLAB_INODE_CACHE,
 					     init_once);
 	if (qnx4_inode_cachep == NULL)
 		return -ENOMEM;
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 3bf7a64..4fc388d 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -546,11 +546,8 @@ static void init_once(void *foo)
 static int init_inodecache(void)
 {
 	reiserfs_inode_cachep = kmem_cache_create("reiser_inode_cache",
-						  sizeof(struct
-							 reiserfs_inode_info),
-						  0, (SLAB_RECLAIM_ACCOUNT|
-							SLAB_MEM_SPREAD),
-						  init_once);
+					sizeof(struct reiserfs_inode_info),
+					0, SLAB_INODE_CACHE, init_once);
 	if (reiserfs_inode_cachep == NULL)
 		return -ENOMEM;
 	return 0;
diff --git a/fs/romfs/super.c b/fs/romfs/super.c
index 6647f90..6ac84bc 100644
--- a/fs/romfs/super.c
+++ b/fs/romfs/super.c
@@ -618,8 +618,7 @@ static int __init init_romfs_fs(void)
 	romfs_inode_cachep =
 		kmem_cache_create("romfs_i",
 				  sizeof(struct romfs_inode_info), 0,
-				  SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
-				  romfs_i_init_once);
+				  SLAB_INODE_CACHE, romfs_i_init_once);
 
 	if (!romfs_inode_cachep) {
 		printk(KERN_ERR
diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 24de30b..c7495fe 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -392,7 +392,8 @@ static int __init init_inodecache(void)
 {
 	squashfs_inode_cachep = kmem_cache_create("squashfs_inode_cache",
 		sizeof(struct squashfs_inode_info), 0,
-		SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT, init_once);
+		SLAB_HWCACHE_ALIGN | SLAB_INODE_CACHE,
+		init_once);
 
 	return squashfs_inode_cachep ? 0 : -ENOMEM;
 }
diff --git a/fs/sysv/inode.c b/fs/sysv/inode.c
index de44d06..8c96780 100644
--- a/fs/sysv/inode.c
+++ b/fs/sysv/inode.c
@@ -360,8 +360,7 @@ const struct super_operations sysv_sops = {
 int __init sysv_init_icache(void)
 {
 	sysv_inode_cachep = kmem_cache_create("sysv_inode_cache",
-			sizeof(struct sysv_inode_info), 0,
-			SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD,
+			sizeof(struct sysv_inode_info), 0, SLAB_INODE_CACHE,
 			init_once);
 	if (!sysv_inode_cachep)
 		return -ENOMEM;
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 91fac54..38c8395 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -2191,7 +2191,7 @@ static int __init ubifs_init(void)
 	err = -ENOMEM;
 	ubifs_inode_slab = kmem_cache_create("ubifs_inode_slab",
 				sizeof(struct ubifs_inode), 0,
-				SLAB_MEM_SPREAD | SLAB_RECLAIM_ACCOUNT,
+				SLAB_INODE_CACHE,
 				&inode_slab_ctor);
 	if (!ubifs_inode_slab)
 		goto out_reg;
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 4a5c7c6..0e1c5d7 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -156,8 +156,7 @@ static int init_inodecache(void)
 {
 	udf_inode_cachep = kmem_cache_create("udf_inode_cache",
 					     sizeof(struct udf_inode_info),
-					     0, (SLAB_RECLAIM_ACCOUNT |
-						 SLAB_MEM_SPREAD),
+					     0, SLAB_INODE_CACHE,
 					     init_once);
 	if (!udf_inode_cachep)
 		return -ENOMEM;
diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 2c47dae..df8020b 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -1428,8 +1428,7 @@ static int init_inodecache(void)
 {
 	ufs_inode_cachep = kmem_cache_create("ufs_inode_cache",
 					     sizeof(struct ufs_inode_info),
-					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+					     0, SLAB_INODE_CACHE,
 					     init_once);
 	if (ufs_inode_cachep == NULL)
 		return -ENOMEM;
diff --git a/fs/xfs/linux-2.6/kmem.h b/fs/xfs/linux-2.6/kmem.h
index f7c8f7a..4e6b372 100644
--- a/fs/xfs/linux-2.6/kmem.h
+++ b/fs/xfs/linux-2.6/kmem.h
@@ -82,6 +82,7 @@ extern void *kmem_zalloc_greedy(size_t *, size_t, size_t);
 #define KM_ZONE_HWALIGN	SLAB_HWCACHE_ALIGN
 #define KM_ZONE_RECLAIM	SLAB_RECLAIM_ACCOUNT
 #define KM_ZONE_SPREAD	SLAB_MEM_SPREAD
+#define KM_ZONE_INODES	SLAB_INODE_CACHE
 
 #define kmem_zone	kmem_cache
 #define kmem_zone_t	struct kmem_cache
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 9f3a78f..53ab47f 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1718,8 +1718,8 @@ xfs_init_zones(void)
 
 	xfs_inode_zone =
 		kmem_zone_init_flags(sizeof(xfs_inode_t), "xfs_inode",
-			KM_ZONE_HWALIGN | KM_ZONE_RECLAIM | KM_ZONE_SPREAD,
-			xfs_fs_inode_init_once);
+					KM_ZONE_HWALIGN | KM_ZONE_INODES,
+					xfs_fs_inode_init_once);
 	if (!xfs_inode_zone)
 		goto out_destroy_efi_zone;
 
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 59260e2..dca23c5 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -93,6 +93,12 @@
 				(unsigned long)ZERO_SIZE_PTR)
 
 /*
+ * Set the default flags necessary for inode caches manipulated by the VFS.
+ */
+#define SLAB_INODE_CACHE	(SLAB_MEM_SPREAD | \
+				 SLAB_RECLAIM_ACCOUNT)
+
+/*
  * struct kmem_cache related prototypes
  */
 void __init kmem_cache_init(void);
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 035f439..82dfa7c 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -1268,7 +1268,8 @@ static int __init init_mqueue_fs(void)
 
 	mqueue_inode_cachep = kmem_cache_create("mqueue_inode_cache",
 				sizeof(struct mqueue_inode_info), 0,
-				SLAB_HWCACHE_ALIGN, init_once);
+				SLAB_HWCACHE_ALIGN | SLAB_INODE_CACHE,
+				init_once);
 	if (mqueue_inode_cachep == NULL)
 		return -ENOMEM;
 
diff --git a/mm/shmem.c b/mm/shmem.c
index 47fdeeb..9a3bd83 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2435,7 +2435,7 @@ static int init_inodecache(void)
 {
 	shmem_inode_cachep = kmem_cache_create("shmem_inode_cache",
 				sizeof(struct shmem_inode_info),
-				0, SLAB_PANIC, init_once);
+				0, SLAB_INODE_CACHE|SLAB_PANIC, init_once);
 	return 0;
 }
 
diff --git a/net/socket.c b/net/socket.c
index 5247ae1..1f1563d 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -288,12 +288,9 @@ static void init_once(void *foo)
 static int init_inodecache(void)
 {
 	sock_inode_cachep = kmem_cache_create("sock_inode_cache",
-					      sizeof(struct socket_alloc),
-					      0,
-					      (SLAB_HWCACHE_ALIGN |
-					       SLAB_RECLAIM_ACCOUNT |
-					       SLAB_MEM_SPREAD),
-					      init_once);
+			      sizeof(struct socket_alloc), 0,
+			      SLAB_HWCACHE_ALIGN | SLAB_INODE_CACHE,
+			      init_once);
 	if (sock_inode_cachep == NULL)
 		return -ENOMEM;
 	return 0;
diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index 10a17a3..68733fb 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -1056,9 +1056,8 @@ int register_rpc_pipefs(void)
 	int err;
 
 	rpc_inode_cachep = kmem_cache_create("rpc_inode_cache",
-				sizeof(struct rpc_inode),
-				0, (SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+				sizeof(struct rpc_inode), 0,
+				SLAB_HWCACHE_ALIGN|SLAB_INODE_CACHE,
 				init_once);
 	if (!rpc_inode_cachep)
 		return -ENOMEM;
-- 
1.7.2.3

