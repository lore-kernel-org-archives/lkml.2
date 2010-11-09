Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273Ab0KIMqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 07:46:20 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:16698 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750702Ab0KIMqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 07:46:18 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAOrQ2Ex5LcZK/2dsb2JhbACiHnK/OoVKBIUQ
Date: Tue, 9 Nov 2010 23:46:10 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 1/6] fs: icache RCU free inodes
Message-ID: <20101109124610.GB11477@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So here is the inode RCU code. It's obviously not worth doing until the
actual rcu-walk path walking is in, but I'd like to get opinions on it.
It would be nice to merge it in Al's tree at some point, though.
--

RCU free the struct inode. This will allow:

- Subsequent store-free path walking patch. The inode must be consulted for
  permissions when walking, so an RCU inode reference is a must.
- Icache locking to use RCU.
- Could potentially simplify things a bit in VM land. Do not need to take the
  page lock to follow page->mapping.

The downsides of this is the performance cost of using RCU. In a simple
creat/unlink microbenchmark, performance drops by about 10% due to inability to
reuse cache-hot slab objects. As iterations increase and RCU freeing starts
kicking over, this increases to about 20%.

In cases where inode lifetimes are longer (ie. many inodes may be allocated
during the average life span of a single inode), a lot of this cache reuse is
not applicable, so the regression caused by this patch is smaller. These
cases are much more realistic in general (except perhaps sockets, which
are covered by the next patch).

The cache-hot regression can largely be avoided by using SLAB_DESTROY_BY_RCU,
however this adds complexity to list walking and store-free path walking, so
I prefer to implement this at a later date, if it is shown to be a win in real
situations. I haven't found a regression in any non-micro benchmark so I
don't think it will be a huge problem.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 Documentation/filesystems/porting         |   12 ++++++++++++
 arch/powerpc/platforms/cell/spufs/inode.c |   10 ++++++++--
 drivers/staging/pohmelfs/inode.c          |   11 +++++++++--
 fs/9p/vfs_inode.c                         |    9 ++++++++-
 fs/adfs/super.c                           |    9 ++++++++-
 fs/affs/super.c                           |    9 ++++++++-
 fs/afs/super.c                            |   10 +++++++++-
 fs/befs/linuxvfs.c                        |   10 ++++++++--
 fs/bfs/inode.c                            |    9 ++++++++-
 fs/block_dev.c                            |    9 ++++++++-
 fs/btrfs/inode.c                          |    9 ++++++++-
 fs/ceph/inode.c                           |   11 ++++++++++-
 fs/cifs/cifsfs.c                          |    9 ++++++++-
 fs/coda/inode.c                           |    9 ++++++++-
 fs/ecryptfs/super.c                       |   12 +++++++++++-
 fs/efs/super.c                            |    9 ++++++++-
 fs/exofs/super.c                          |    9 ++++++++-
 fs/ext2/super.c                           |    9 ++++++++-
 fs/ext3/super.c                           |    9 ++++++++-
 fs/ext4/super.c                           |    9 ++++++++-
 fs/fat/inode.c                            |    9 ++++++++-
 fs/freevxfs/vxfs_inode.c                  |    9 ++++++++-
 fs/fuse/inode.c                           |    9 ++++++++-
 fs/gfs2/super.c                           |    9 ++++++++-
 fs/hfs/super.c                            |    9 ++++++++-
 fs/hfsplus/super.c                        |   10 +++++++++-
 fs/hostfs/hostfs_kern.c                   |    9 ++++++++-
 fs/hpfs/super.c                           |    9 ++++++++-
 fs/hppfs/hppfs.c                          |    9 ++++++++-
 fs/hugetlbfs/inode.c                      |    9 ++++++++-
 fs/inode.c                                |   10 +++++++++-
 fs/isofs/inode.c                          |    9 ++++++++-
 fs/jffs2/super.c                          |    9 ++++++++-
 fs/jfs/super.c                            |   10 +++++++++-
 fs/logfs/inode.c                          |    9 ++++++++-
 fs/minix/inode.c                          |    9 ++++++++-
 fs/ncpfs/inode.c                          |    9 ++++++++-
 fs/nfs/inode.c                            |    9 ++++++++-
 fs/nilfs2/super.c                         |   10 +++++++++-
 fs/ntfs/inode.c                           |    9 ++++++++-
 fs/ocfs2/dlmfs/dlmfs.c                    |    9 ++++++++-
 fs/ocfs2/super.c                          |    9 ++++++++-
 fs/openpromfs/inode.c                     |    9 ++++++++-
 fs/proc/inode.c                           |    9 ++++++++-
 fs/qnx4/inode.c                           |    9 ++++++++-
 fs/reiserfs/super.c                       |    9 ++++++++-
 fs/romfs/super.c                          |    9 ++++++++-
 fs/squashfs/super.c                       |    9 ++++++++-
 fs/sysv/inode.c                           |    9 ++++++++-
 fs/ubifs/super.c                          |   10 +++++++++-
 fs/udf/super.c                            |    9 ++++++++-
 fs/ufs/super.c                            |    9 ++++++++-
 fs/xfs/xfs_iget.c                         |   13 ++++++++++++-
 include/linux/fs.h                        |    5 ++++-
 include/linux/net.h                       |    1 -
 ipc/mqueue.c                              |    9 ++++++++-
 mm/shmem.c                                |    9 ++++++++-
 net/socket.c                              |   16 ++++++++--------
 net/sunrpc/rpc_pipe.c                     |   10 +++++++++-
 59 files changed, 481 insertions(+), 68 deletions(-)

Index: linux-2.6/fs/ext2/super.c
===================================================================
--- linux-2.6.orig/fs/ext2/super.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/ext2/super.c	2010-11-09 22:11:10.000000000 +1100
@@ -161,11 +161,18 @@ static struct inode *ext2_alloc_inode(st
 	return &ei->vfs_inode;
 }
 
-static void ext2_destroy_inode(struct inode *inode)
+static void ext2_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(ext2_inode_cachep, EXT2_I(inode));
 }
 
+static void ext2_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, ext2_i_callback);
+}
+
 static void init_once(void *foo)
 {
 	struct ext2_inode_info *ei = (struct ext2_inode_info *) foo;
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-11-09 23:22:54.000000000 +1100
@@ -270,6 +270,13 @@ void __destroy_inode(struct inode *inode
 }
 EXPORT_SYMBOL(__destroy_inode);
 
+static void i_callback(struct rcu_head *head)
+{
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
+	kmem_cache_free(inode_cachep, inode);
+}
+
 static void destroy_inode(struct inode *inode)
 {
 	BUG_ON(!list_empty(&inode->i_lru));
@@ -277,7 +284,7 @@ static void destroy_inode(struct inode *
 	if (inode->i_sb->s_op->destroy_inode)
 		inode->i_sb->s_op->destroy_inode(inode);
 	else
-		kmem_cache_free(inode_cachep, (inode));
+		call_rcu(&inode->i_rcu, i_callback);
 }
 
 /*
@@ -430,6 +437,7 @@ void end_writeback(struct inode *inode)
 	BUG_ON(!(inode->i_state & I_FREEING));
 	BUG_ON(inode->i_state & I_CLEAR);
 	inode_sync_wait(inode);
+	/* don't need i_lock here, no concurrent mods to i_state */
 	inode->i_state = I_FREEING | I_CLEAR;
 }
 EXPORT_SYMBOL(end_writeback);
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-11-09 22:11:01.000000000 +1100
+++ linux-2.6/include/linux/fs.h	2010-11-09 23:22:54.000000000 +1100
@@ -736,7 +736,10 @@ struct inode {
 	struct list_head	i_wb_list;	/* backing dev IO list */
 	struct list_head	i_lru;		/* inode LRU list */
 	struct list_head	i_sb_list;
-	struct list_head	i_dentry;
+	union {
+		struct list_head	i_dentry;
+		struct rcu_head		i_rcu;
+	};
 	unsigned long		i_ino;
 	atomic_t		i_count;
 	unsigned int		i_nlink;
Index: linux-2.6/fs/block_dev.c
===================================================================
--- linux-2.6.orig/fs/block_dev.c	2010-11-09 22:11:01.000000000 +1100
+++ linux-2.6/fs/block_dev.c	2010-11-09 22:11:10.000000000 +1100
@@ -410,13 +410,20 @@ static struct inode *bdev_alloc_inode(st
 	return &ei->vfs_inode;
 }
 
-static void bdev_destroy_inode(struct inode *inode)
+static void bdev_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
 	struct bdev_inode *bdi = BDEV_I(inode);
 
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(bdev_cachep, bdi);
 }
 
+static void bdev_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, bdev_i_callback);
+}
+
 static void init_once(void *foo)
 {
 	struct bdev_inode *ei = (struct bdev_inode *) foo;
Index: linux-2.6/fs/ext3/super.c
===================================================================
--- linux-2.6.orig/fs/ext3/super.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/ext3/super.c	2010-11-09 22:11:10.000000000 +1100
@@ -480,6 +480,13 @@ static struct inode *ext3_alloc_inode(st
 	return &ei->vfs_inode;
 }
 
+static void ext3_i_callback(struct rcu_head *head)
+{
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
+	kmem_cache_free(ext3_inode_cachep, EXT3_I(inode));
+}
+
 static void ext3_destroy_inode(struct inode *inode)
 {
 	if (!list_empty(&(EXT3_I(inode)->i_orphan))) {
@@ -490,7 +497,7 @@ static void ext3_destroy_inode(struct in
 				false);
 		dump_stack();
 	}
-	kmem_cache_free(ext3_inode_cachep, EXT3_I(inode));
+	call_rcu(&inode->i_rcu, ext3_i_callback);
 }
 
 static void init_once(void *foo)
Index: linux-2.6/fs/hugetlbfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hugetlbfs/inode.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/hugetlbfs/inode.c	2010-11-09 22:11:10.000000000 +1100
@@ -663,11 +663,18 @@ static struct inode *hugetlbfs_alloc_ino
 	return &p->vfs_inode;
 }
 
+static void hugetlbfs_i_callback(struct rcu_head *head)
+{
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
+	kmem_cache_free(hugetlbfs_inode_cachep, HUGETLBFS_I(inode));
+}
+
 static void hugetlbfs_destroy_inode(struct inode *inode)
 {
 	hugetlbfs_inc_free_inodes(HUGETLBFS_SB(inode->i_sb));
 	mpol_free_shared_policy(&HUGETLBFS_I(inode)->policy);
-	kmem_cache_free(hugetlbfs_inode_cachep, HUGETLBFS_I(inode));
+	call_rcu(&inode->i_rcu, hugetlbfs_i_callback);
 }
 
 static const struct address_space_operations hugetlbfs_aops = {
Index: linux-2.6/fs/proc/inode.c
===================================================================
--- linux-2.6.orig/fs/proc/inode.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/proc/inode.c	2010-11-09 22:11:10.000000000 +1100
@@ -66,11 +66,18 @@ static struct inode *proc_alloc_inode(st
 	return inode;
 }
 
-static void proc_destroy_inode(struct inode *inode)
+static void proc_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(proc_inode_cachep, PROC_I(inode));
 }
 
+static void proc_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, proc_i_callback);
+}
+
 static void init_once(void *foo)
 {
 	struct proc_inode *ei = (struct proc_inode *) foo;
Index: linux-2.6/ipc/mqueue.c
===================================================================
--- linux-2.6.orig/ipc/mqueue.c	2010-11-09 22:11:01.000000000 +1100
+++ linux-2.6/ipc/mqueue.c	2010-11-09 22:11:10.000000000 +1100
@@ -237,11 +237,18 @@ static struct inode *mqueue_alloc_inode(
 	return &ei->vfs_inode;
 }
 
-static void mqueue_destroy_inode(struct inode *inode)
+static void mqueue_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(mqueue_inode_cachep, MQUEUE_I(inode));
 }
 
+static void mqueue_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, mqueue_i_callback);
+}
+
 static void mqueue_evict_inode(struct inode *inode)
 {
 	struct mqueue_inode_info *info;
Index: linux-2.6/net/socket.c
===================================================================
--- linux-2.6.orig/net/socket.c	2010-11-09 22:11:03.000000000 +1100
+++ linux-2.6/net/socket.c	2010-11-09 23:22:54.000000000 +1100
@@ -262,20 +262,20 @@ static struct inode *sock_alloc_inode(st
 }
 
 
-static void wq_free_rcu(struct rcu_head *head)
+static void sock_free_rcu(struct rcu_head *head)
 {
-	struct socket_wq *wq = container_of(head, struct socket_wq, rcu);
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	struct socket_alloc *ei = container_of(inode, struct socket_alloc,
+								vfs_inode);
 
-	kfree(wq);
+	kfree(ei->socket.wq);
+	INIT_LIST_HEAD(&inode->i_dentry);
+	kmem_cache_free(sock_inode_cachep, ei);
 }
 
 static void sock_destroy_inode(struct inode *inode)
 {
-	struct socket_alloc *ei;
-
-	ei = container_of(inode, struct socket_alloc, vfs_inode);
-	call_rcu(&ei->socket.wq->rcu, wq_free_rcu);
-	kmem_cache_free(sock_inode_cachep, ei);
+	call_rcu(&inode->i_rcu, sock_free_rcu);
 }
 
 static void init_once(void *foo)
Index: linux-2.6/fs/fat/inode.c
===================================================================
--- linux-2.6.orig/fs/fat/inode.c	2010-11-09 22:11:01.000000000 +1100
+++ linux-2.6/fs/fat/inode.c	2010-11-09 22:11:10.000000000 +1100
@@ -514,11 +514,18 @@ static struct inode *fat_alloc_inode(str
 	return &ei->vfs_inode;
 }
 
-static void fat_destroy_inode(struct inode *inode)
+static void fat_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(fat_inode_cachep, MSDOS_I(inode));
 }
 
+static void fat_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, fat_i_callback);
+}
+
 static void init_once(void *foo)
 {
 	struct msdos_inode_info *ei = (struct msdos_inode_info *)foo;
Index: linux-2.6/fs/nfs/inode.c
===================================================================
--- linux-2.6.orig/fs/nfs/inode.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/nfs/inode.c	2010-11-09 22:11:10.000000000 +1100
@@ -1437,11 +1437,18 @@ struct inode *nfs_alloc_inode(struct sup
 	return &nfsi->vfs_inode;
 }
 
-void nfs_destroy_inode(struct inode *inode)
+static void nfs_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(nfs_inode_cachep, NFS_I(inode));
 }
 
+void nfs_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, nfs_i_callback);
+}
+
 static inline void nfs4_init_once(struct nfs_inode *nfsi)
 {
 #ifdef CONFIG_NFS_V4
Index: linux-2.6/mm/shmem.c
===================================================================
--- linux-2.6.orig/mm/shmem.c	2010-11-09 22:11:01.000000000 +1100
+++ linux-2.6/mm/shmem.c	2010-11-09 22:11:10.000000000 +1100
@@ -2415,13 +2415,20 @@ static struct inode *shmem_alloc_inode(s
 	return &p->vfs_inode;
 }
 
+static void shmem_i_callback(struct rcu_head *head)
+{
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
+	kmem_cache_free(shmem_inode_cachep, SHMEM_I(inode));
+}
+
 static void shmem_destroy_inode(struct inode *inode)
 {
 	if ((inode->i_mode & S_IFMT) == S_IFREG) {
 		/* only struct inode is valid if it's an inline symlink */
 		mpol_free_shared_policy(&SHMEM_I(inode)->policy);
 	}
-	kmem_cache_free(shmem_inode_cachep, SHMEM_I(inode));
+	call_rcu(&inode->i_rcu, shmem_i_callback);
 }
 
 static void init_once(void *foo)
Index: linux-2.6/net/sunrpc/rpc_pipe.c
===================================================================
--- linux-2.6.orig/net/sunrpc/rpc_pipe.c	2010-11-09 22:11:03.000000000 +1100
+++ linux-2.6/net/sunrpc/rpc_pipe.c	2010-11-09 23:22:53.000000000 +1100
@@ -162,11 +162,19 @@ rpc_alloc_inode(struct super_block *sb)
 }
 
 static void
-rpc_destroy_inode(struct inode *inode)
+rpc_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(rpc_inode_cachep, RPC_I(inode));
 }
 
+static void
+rpc_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, rpc_i_callback);
+}
+
 static int
 rpc_pipe_open(struct inode *inode, struct file *filp)
 {
Index: linux-2.6/include/linux/net.h
===================================================================
--- linux-2.6.orig/include/linux/net.h	2010-11-09 22:11:01.000000000 +1100
+++ linux-2.6/include/linux/net.h	2010-11-09 23:22:54.000000000 +1100
@@ -120,7 +120,6 @@ enum sock_shutdown_cmd {
 struct socket_wq {
 	wait_queue_head_t	wait;
 	struct fasync_struct	*fasync_list;
-	struct rcu_head		rcu;
 } ____cacheline_aligned_in_smp;
 
 /**
Index: linux-2.6/fs/9p/vfs_inode.c
===================================================================
--- linux-2.6.orig/fs/9p/vfs_inode.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/9p/vfs_inode.c	2010-11-09 22:11:10.000000000 +1100
@@ -237,10 +237,17 @@ struct inode *v9fs_alloc_inode(struct su
  *
  */
 
-void v9fs_destroy_inode(struct inode *inode)
+static void v9fs_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(vcookie_cache, v9fs_inode2cookie(inode));
 }
+
+void v9fs_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, v9fs_i_callback);
+}
 #endif
 
 /**
Index: linux-2.6/fs/adfs/super.c
===================================================================
--- linux-2.6.orig/fs/adfs/super.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/adfs/super.c	2010-11-09 22:11:10.000000000 +1100
@@ -240,11 +240,18 @@ static struct inode *adfs_alloc_inode(st
 	return &ei->vfs_inode;
 }
 
-static void adfs_destroy_inode(struct inode *inode)
+static void adfs_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(adfs_inode_cachep, ADFS_I(inode));
 }
 
+static void adfs_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, adfs_i_callback);
+}
+
 static void init_once(void *foo)
 {
 	struct adfs_inode_info *ei = (struct adfs_inode_info *) foo;
Index: linux-2.6/fs/affs/super.c
===================================================================
--- linux-2.6.orig/fs/affs/super.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/affs/super.c	2010-11-09 22:11:10.000000000 +1100
@@ -95,11 +95,18 @@ static struct inode *affs_alloc_inode(st
 	return &i->vfs_inode;
 }
 
-static void affs_destroy_inode(struct inode *inode)
+static void affs_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(affs_inode_cachep, AFFS_I(inode));
 }
 
+static void affs_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, affs_i_callback);
+}
+
 static void init_once(void *foo)
 {
 	struct affs_inode_info *ei = (struct affs_inode_info *) foo;
Index: linux-2.6/fs/afs/super.c
===================================================================
--- linux-2.6.orig/fs/afs/super.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/afs/super.c	2010-11-09 22:11:10.000000000 +1100
@@ -498,6 +498,14 @@ static struct inode *afs_alloc_inode(str
 	return &vnode->vfs_inode;
 }
 
+static void afs_i_callback(struct rcu_head *head)
+{
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	struct afs_vnode *vnode = AFS_FS_I(inode);
+	INIT_LIST_HEAD(&inode->i_dentry);
+	kmem_cache_free(afs_inode_cachep, vnode);
+}
+
 /*
  * destroy an AFS inode struct
  */
@@ -511,7 +519,7 @@ static void afs_destroy_inode(struct ino
 
 	ASSERTCMP(vnode->server, ==, NULL);
 
-	kmem_cache_free(afs_inode_cachep, vnode);
+	call_rcu(&inode->i_rcu, afs_i_callback);
 	atomic_dec(&afs_count_active_inodes);
 }
 
Index: linux-2.6/fs/befs/linuxvfs.c
===================================================================
--- linux-2.6.orig/fs/befs/linuxvfs.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/befs/linuxvfs.c	2010-11-09 22:11:10.000000000 +1100
@@ -284,12 +284,18 @@ befs_alloc_inode(struct super_block *sb)
         return &bi->vfs_inode;
 }
 
-static void
-befs_destroy_inode(struct inode *inode)
+static void befs_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
         kmem_cache_free(befs_inode_cachep, BEFS_I(inode));
 }
 
+static void befs_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, befs_i_callback);
+}
+
 static void init_once(void *foo)
 {
         struct befs_inode_info *bi = (struct befs_inode_info *) foo;
Index: linux-2.6/fs/bfs/inode.c
===================================================================
--- linux-2.6.orig/fs/bfs/inode.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/bfs/inode.c	2010-11-09 22:11:10.000000000 +1100
@@ -248,11 +248,18 @@ static struct inode *bfs_alloc_inode(str
 	return &bi->vfs_inode;
 }
 
-static void bfs_destroy_inode(struct inode *inode)
+static void bfs_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(bfs_inode_cachep, BFS_I(inode));
 }
 
+static void bfs_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, bfs_i_callback);
+}
+
 static void init_once(void *foo)
 {
 	struct bfs_inode_info *bi = foo;
Index: linux-2.6/fs/btrfs/inode.c
===================================================================
--- linux-2.6.orig/fs/btrfs/inode.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/btrfs/inode.c	2010-11-09 23:22:53.000000000 +1100
@@ -6322,6 +6322,13 @@ struct inode *btrfs_alloc_inode(struct s
 	return inode;
 }
 
+static void btrfs_i_callback(struct rcu_head *head)
+{
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
+	kmem_cache_free(btrfs_inode_cachep, BTRFS_I(inode));
+}
+
 void btrfs_destroy_inode(struct inode *inode)
 {
 	struct btrfs_ordered_extent *ordered;
@@ -6391,7 +6398,7 @@ void btrfs_destroy_inode(struct inode *i
 	inode_tree_del(inode);
 	btrfs_drop_extent_cache(inode, 0, (u64)-1, 0);
 free:
-	kmem_cache_free(btrfs_inode_cachep, BTRFS_I(inode));
+	call_rcu(&inode->i_rcu, btrfs_i_callback);
 }
 
 int btrfs_drop_inode(struct inode *inode)
Index: linux-2.6/fs/ceph/inode.c
===================================================================
--- linux-2.6.orig/fs/ceph/inode.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/ceph/inode.c	2010-11-09 22:11:10.000000000 +1100
@@ -369,6 +369,15 @@ struct inode *ceph_alloc_inode(struct su
 	return &ci->vfs_inode;
 }
 
+static void ceph_i_callback(struct rcu_head *head)
+{
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	struct ceph_inode_info *ci = ceph_inode(inode);
+
+	INIT_LIST_HEAD(&inode->i_dentry);
+	kmem_cache_free(ceph_inode_cachep, ci);
+}
+
 void ceph_destroy_inode(struct inode *inode)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
@@ -408,7 +417,7 @@ void ceph_destroy_inode(struct inode *in
 	if (ci->i_xattrs.prealloc_blob)
 		ceph_buffer_put(ci->i_xattrs.prealloc_blob);
 
-	kmem_cache_free(ceph_inode_cachep, ci);
+	call_rcu(&inode->i_rcu, ceph_i_callback);
 }
 
 
Index: linux-2.6/fs/cifs/cifsfs.c
===================================================================
--- linux-2.6.orig/fs/cifs/cifsfs.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/cifs/cifsfs.c	2010-11-09 22:11:10.000000000 +1100
@@ -334,10 +334,17 @@ cifs_alloc_inode(struct super_block *sb)
 	return &cifs_inode->vfs_inode;
 }
 
+static void cifs_i_callback(struct rcu_head *head)
+{
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
+	kmem_cache_free(cifs_inode_cachep, CIFS_I(inode));
+}
+
 static void
 cifs_destroy_inode(struct inode *inode)
 {
-	kmem_cache_free(cifs_inode_cachep, CIFS_I(inode));
+	call_rcu(&inode->i_rcu, cifs_i_callback);
 }
 
 static void
Index: linux-2.6/fs/coda/inode.c
===================================================================
--- linux-2.6.orig/fs/coda/inode.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/coda/inode.c	2010-11-09 22:11:10.000000000 +1100
@@ -56,11 +56,18 @@ static struct inode *coda_alloc_inode(st
 	return &ei->vfs_inode;
 }
 
-static void coda_destroy_inode(struct inode *inode)
+static void coda_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(coda_inode_cachep, ITOC(inode));
 }
 
+static void coda_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, coda_i_callback);
+}
+
 static void init_once(void *foo)
 {
 	struct coda_inode_info *ei = (struct coda_inode_info *) foo;
Index: linux-2.6/fs/ecryptfs/super.c
===================================================================
--- linux-2.6.orig/fs/ecryptfs/super.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/ecryptfs/super.c	2010-11-09 22:11:10.000000000 +1100
@@ -63,6 +63,16 @@ static struct inode *ecryptfs_alloc_inod
 	return inode;
 }
 
+static void ecryptfs_i_callback(struct rcu_head *head)
+{
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	struct ecryptfs_inode_info *inode_info;
+	inode_info = ecryptfs_inode_to_private(inode);
+
+	INIT_LIST_HEAD(&inode->i_dentry);
+	kmem_cache_free(ecryptfs_inode_info_cache, inode_info);
+}
+
 /**
  * ecryptfs_destroy_inode
  * @inode: The ecryptfs inode
@@ -89,7 +99,7 @@ static void ecryptfs_destroy_inode(struc
 		}
 	}
 	ecryptfs_destroy_crypt_stat(&inode_info->crypt_stat);
-	kmem_cache_free(ecryptfs_inode_info_cache, inode_info);
+	call_rcu(&inode->i_rcu, ecryptfs_i_callback);
 }
 
 /**
Index: linux-2.6/fs/efs/super.c
===================================================================
--- linux-2.6.orig/fs/efs/super.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/efs/super.c	2010-11-09 22:11:10.000000000 +1100
@@ -65,11 +65,18 @@ static struct inode *efs_alloc_inode(str
 	return &ei->vfs_inode;
 }
 
-static void efs_destroy_inode(struct inode *inode)
+static void efs_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(efs_inode_cachep, INODE_INFO(inode));
 }
 
+static void efs_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, efs_i_callback);
+}
+
 static void init_once(void *foo)
 {
 	struct efs_inode_info *ei = (struct efs_inode_info *) foo;
Index: linux-2.6/fs/exofs/super.c
===================================================================
--- linux-2.6.orig/fs/exofs/super.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/exofs/super.c	2010-11-09 22:11:10.000000000 +1100
@@ -150,12 +150,19 @@ static struct inode *exofs_alloc_inode(s
 	return &oi->vfs_inode;
 }
 
+static void exofs_i_callback(struct rcu_head *head)
+{
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
+	kmem_cache_free(exofs_inode_cachep, exofs_i(inode));
+}
+
 /*
  * Remove an inode from the cache
  */
 static void exofs_destroy_inode(struct inode *inode)
 {
-	kmem_cache_free(exofs_inode_cachep, exofs_i(inode));
+	call_rcu(&inode->i_rcu, exofs_i_callback);
 }
 
 /*
Index: linux-2.6/fs/ext4/super.c
===================================================================
--- linux-2.6.orig/fs/ext4/super.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/ext4/super.c	2010-11-09 22:11:10.000000000 +1100
@@ -841,6 +841,13 @@ static int ext4_drop_inode(struct inode
 	return drop;
 }
 
+static void ext4_i_callback(struct rcu_head *head)
+{
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
+	kmem_cache_free(ext4_inode_cachep, EXT4_I(inode));
+}
+
 static void ext4_destroy_inode(struct inode *inode)
 {
 	ext4_ioend_wait(inode);
@@ -853,7 +860,7 @@ static void ext4_destroy_inode(struct in
 				true);
 		dump_stack();
 	}
-	kmem_cache_free(ext4_inode_cachep, EXT4_I(inode));
+	call_rcu(&inode->i_rcu, ext4_i_callback);
 }
 
 static void init_once(void *foo)
Index: linux-2.6/fs/freevxfs/vxfs_inode.c
===================================================================
--- linux-2.6.orig/fs/freevxfs/vxfs_inode.c	2010-11-09 22:11:01.000000000 +1100
+++ linux-2.6/fs/freevxfs/vxfs_inode.c	2010-11-09 22:11:10.000000000 +1100
@@ -337,6 +337,13 @@ vxfs_iget(struct super_block *sbp, ino_t
 	return ip;
 }
 
+static void vxfs_i_callback(struct rcu_head *head)
+{
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
+	kmem_cache_free(vxfs_inode_cachep, inode->i_private);
+}
+
 /**
  * vxfs_evict_inode - remove inode from main memory
  * @ip:		inode to discard.
@@ -350,5 +357,5 @@ vxfs_evict_inode(struct inode *ip)
 {
 	truncate_inode_pages(&ip->i_data, 0);
 	end_writeback(ip);
-	kmem_cache_free(vxfs_inode_cachep, ip->i_private);
+	call_rcu(&ip->i_rcu, vxfs_i_callback);
 }
Index: linux-2.6/fs/fuse/inode.c
===================================================================
--- linux-2.6.orig/fs/fuse/inode.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/fuse/inode.c	2010-11-09 22:11:10.000000000 +1100
@@ -99,6 +99,13 @@ static struct inode *fuse_alloc_inode(st
 	return inode;
 }
 
+static void fuse_i_callback(struct rcu_head *head)
+{
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
+	kmem_cache_free(fuse_inode_cachep, inode);
+}
+
 static void fuse_destroy_inode(struct inode *inode)
 {
 	struct fuse_inode *fi = get_fuse_inode(inode);
@@ -106,7 +113,7 @@ static void fuse_destroy_inode(struct in
 	BUG_ON(!list_empty(&fi->queued_writes));
 	if (fi->forget_req)
 		fuse_request_free(fi->forget_req);
-	kmem_cache_free(fuse_inode_cachep, inode);
+	call_rcu(&inode->i_rcu, fuse_i_callback);
 }
 
 void fuse_send_forget(struct fuse_conn *fc, struct fuse_req *req,
Index: linux-2.6/fs/gfs2/super.c
===================================================================
--- linux-2.6.orig/fs/gfs2/super.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/gfs2/super.c	2010-11-09 22:11:10.000000000 +1100
@@ -1405,11 +1405,18 @@ static struct inode *gfs2_alloc_inode(st
 	return &ip->i_inode;
 }
 
-static void gfs2_destroy_inode(struct inode *inode)
+static void gfs2_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(gfs2_inode_cachep, inode);
 }
 
+static void gfs2_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, gfs2_i_callback);
+}
+
 const struct super_operations gfs2_super_ops = {
 	.alloc_inode		= gfs2_alloc_inode,
 	.destroy_inode		= gfs2_destroy_inode,
Index: linux-2.6/fs/hfs/super.c
===================================================================
--- linux-2.6.orig/fs/hfs/super.c	2010-11-09 22:11:01.000000000 +1100
+++ linux-2.6/fs/hfs/super.c	2010-11-09 22:11:10.000000000 +1100
@@ -167,11 +167,18 @@ static struct inode *hfs_alloc_inode(str
 	return i ? &i->vfs_inode : NULL;
 }
 
-static void hfs_destroy_inode(struct inode *inode)
+static void hfs_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(hfs_inode_cachep, HFS_I(inode));
 }
 
+static void hfs_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, hfs_i_callback);
+}
+
 static const struct super_operations hfs_super_operations = {
 	.alloc_inode	= hfs_alloc_inode,
 	.destroy_inode	= hfs_destroy_inode,
Index: linux-2.6/fs/hfsplus/super.c
===================================================================
--- linux-2.6.orig/fs/hfsplus/super.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/hfsplus/super.c	2010-11-09 22:11:10.000000000 +1100
@@ -488,11 +488,19 @@ static struct inode *hfsplus_alloc_inode
 	return i ? &i->vfs_inode : NULL;
 }
 
-static void hfsplus_destroy_inode(struct inode *inode)
+static void hfsplus_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(hfsplus_inode_cachep, HFSPLUS_I(inode));
 }
 
+static void hfsplus_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, hfsplus_i_callback);
+}
+
 #define HFSPLUS_INODE_SIZE	sizeof(struct hfsplus_inode_info)
 
 static struct dentry *hfsplus_mount(struct file_system_type *fs_type,
Index: linux-2.6/fs/hpfs/super.c
===================================================================
--- linux-2.6.orig/fs/hpfs/super.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/hpfs/super.c	2010-11-09 22:11:10.000000000 +1100
@@ -177,11 +177,18 @@ static struct inode *hpfs_alloc_inode(st
 	return &ei->vfs_inode;
 }
 
-static void hpfs_destroy_inode(struct inode *inode)
+static void hpfs_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(hpfs_inode_cachep, hpfs_i(inode));
 }
 
+static void hpfs_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, hpfs_i_callback);
+}
+
 static void init_once(void *foo)
 {
 	struct hpfs_inode_info *ei = (struct hpfs_inode_info *) foo;
Index: linux-2.6/fs/isofs/inode.c
===================================================================
--- linux-2.6.orig/fs/isofs/inode.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/isofs/inode.c	2010-11-09 23:22:51.000000000 +1100
@@ -65,11 +65,18 @@ static struct inode *isofs_alloc_inode(s
 	return &ei->vfs_inode;
 }
 
-static void isofs_destroy_inode(struct inode *inode)
+static void isofs_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(isofs_inode_cachep, ISOFS_I(inode));
 }
 
+static void isofs_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, isofs_i_callback);
+}
+
 static void init_once(void *foo)
 {
 	struct iso_inode_info *ei = foo;
Index: linux-2.6/fs/jffs2/super.c
===================================================================
--- linux-2.6.orig/fs/jffs2/super.c	2010-11-09 22:11:01.000000000 +1100
+++ linux-2.6/fs/jffs2/super.c	2010-11-09 22:11:10.000000000 +1100
@@ -40,11 +40,18 @@ static struct inode *jffs2_alloc_inode(s
 	return &f->vfs_inode;
 }
 
-static void jffs2_destroy_inode(struct inode *inode)
+static void jffs2_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(jffs2_inode_cachep, JFFS2_INODE_INFO(inode));
 }
 
+static void jffs2_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, jffs2_i_callback);
+}
+
 static void jffs2_i_init_once(void *foo)
 {
 	struct jffs2_inode_info *f = foo;
Index: linux-2.6/fs/jfs/super.c
===================================================================
--- linux-2.6.orig/fs/jfs/super.c	2010-11-09 22:11:03.000000000 +1100
+++ linux-2.6/fs/jfs/super.c	2010-11-09 22:11:10.000000000 +1100
@@ -115,6 +115,14 @@ static struct inode *jfs_alloc_inode(str
 	return &jfs_inode->vfs_inode;
 }
 
+static void jfs_i_callback(struct rcu_head *head)
+{
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	struct jfs_inode_info *ji = JFS_IP(inode);
+	INIT_LIST_HEAD(&inode->i_dentry);
+	kmem_cache_free(jfs_inode_cachep, ji);
+}
+
 static void jfs_destroy_inode(struct inode *inode)
 {
 	struct jfs_inode_info *ji = JFS_IP(inode);
@@ -128,7 +136,7 @@ static void jfs_destroy_inode(struct ino
 		ji->active_ag = -1;
 	}
 	spin_unlock_irq(&ji->ag_lock);
-	kmem_cache_free(jfs_inode_cachep, ji);
+	call_rcu(&inode->i_rcu, jfs_i_callback);
 }
 
 static int jfs_statfs(struct dentry *dentry, struct kstatfs *buf)
Index: linux-2.6/fs/logfs/inode.c
===================================================================
--- linux-2.6.orig/fs/logfs/inode.c	2010-11-09 22:11:01.000000000 +1100
+++ linux-2.6/fs/logfs/inode.c	2010-11-09 22:11:10.000000000 +1100
@@ -141,13 +141,20 @@ struct inode *logfs_safe_iget(struct sup
 	return __logfs_iget(sb, ino);
 }
 
+static void logfs_i_callback(struct rcu_head *head)
+{
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
+	kmem_cache_free(logfs_inode_cache, logfs_inode(inode));
+}
+
 static void __logfs_destroy_inode(struct inode *inode)
 {
 	struct logfs_inode *li = logfs_inode(inode);
 
 	BUG_ON(li->li_block);
 	list_del(&li->li_freeing_list);
-	kmem_cache_free(logfs_inode_cache, li);
+	call_rcu(&inode->i_rcu, logfs_i_callback);
 }
 
 static void logfs_destroy_inode(struct inode *inode)
Index: linux-2.6/fs/minix/inode.c
===================================================================
--- linux-2.6.orig/fs/minix/inode.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/minix/inode.c	2010-11-09 22:11:10.000000000 +1100
@@ -68,11 +68,18 @@ static struct inode *minix_alloc_inode(s
 	return &ei->vfs_inode;
 }
 
-static void minix_destroy_inode(struct inode *inode)
+static void minix_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(minix_inode_cachep, minix_i(inode));
 }
 
+static void minix_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, minix_i_callback);
+}
+
 static void init_once(void *foo)
 {
 	struct minix_inode_info *ei = (struct minix_inode_info *) foo;
Index: linux-2.6/fs/ncpfs/inode.c
===================================================================
--- linux-2.6.orig/fs/ncpfs/inode.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/ncpfs/inode.c	2010-11-09 22:11:10.000000000 +1100
@@ -59,11 +59,18 @@ static struct inode *ncp_alloc_inode(str
 	return &ei->vfs_inode;
 }
 
-static void ncp_destroy_inode(struct inode *inode)
+static void ncp_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(ncp_inode_cachep, NCP_FINFO(inode));
 }
 
+static void ncp_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, ncp_i_callback);
+}
+
 static void init_once(void *foo)
 {
 	struct ncp_inode_info *ei = (struct ncp_inode_info *) foo;
Index: linux-2.6/fs/nilfs2/super.c
===================================================================
--- linux-2.6.orig/fs/nilfs2/super.c	2010-11-09 22:11:01.000000000 +1100
+++ linux-2.6/fs/nilfs2/super.c	2010-11-09 22:11:10.000000000 +1100
@@ -162,10 +162,13 @@ struct inode *nilfs_alloc_inode(struct s
 	return &ii->vfs_inode;
 }
 
-void nilfs_destroy_inode(struct inode *inode)
+static void nilfs_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
 	struct nilfs_mdt_info *mdi = NILFS_MDT(inode);
 
+	INIT_LIST_HEAD(&inode->i_dentry);
+
 	if (mdi) {
 		kfree(mdi->mi_bgl); /* kfree(NULL) is safe */
 		kfree(mdi);
@@ -173,6 +176,11 @@ void nilfs_destroy_inode(struct inode *i
 	kmem_cache_free(nilfs_inode_cachep, NILFS_I(inode));
 }
 
+void nilfs_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, nilfs_i_callback);
+}
+
 static int nilfs_sync_super(struct nilfs_sb_info *sbi, int flag)
 {
 	struct the_nilfs *nilfs = sbi->s_nilfs;
Index: linux-2.6/fs/ntfs/inode.c
===================================================================
--- linux-2.6.orig/fs/ntfs/inode.c	2010-11-09 22:11:01.000000000 +1100
+++ linux-2.6/fs/ntfs/inode.c	2010-11-09 22:11:10.000000000 +1100
@@ -332,6 +332,13 @@ struct inode *ntfs_alloc_big_inode(struc
 	return NULL;
 }
 
+static void ntfs_i_callback(struct rcu_head *head)
+{
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
+	kmem_cache_free(ntfs_big_inode_cache, NTFS_I(inode));
+}
+
 void ntfs_destroy_big_inode(struct inode *inode)
 {
 	ntfs_inode *ni = NTFS_I(inode);
@@ -340,7 +347,7 @@ void ntfs_destroy_big_inode(struct inode
 	BUG_ON(ni->page);
 	if (!atomic_dec_and_test(&ni->count))
 		BUG();
-	kmem_cache_free(ntfs_big_inode_cache, NTFS_I(inode));
+	call_rcu(&inode->i_rcu, ntfs_i_callback);
 }
 
 static inline ntfs_inode *ntfs_alloc_extent_inode(void)
Index: linux-2.6/fs/ocfs2/dlmfs/dlmfs.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/dlmfs/dlmfs.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/ocfs2/dlmfs/dlmfs.c	2010-11-09 22:11:10.000000000 +1100
@@ -351,11 +351,18 @@ static struct inode *dlmfs_alloc_inode(s
 	return &ip->ip_vfs_inode;
 }
 
-static void dlmfs_destroy_inode(struct inode *inode)
+static void dlmfs_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(dlmfs_inode_cache, DLMFS_I(inode));
 }
 
+static void dlmfs_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, dlmfs_i_callback);
+}
+
 static void dlmfs_evict_inode(struct inode *inode)
 {
 	int status;
Index: linux-2.6/fs/ocfs2/super.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/super.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/ocfs2/super.c	2010-11-09 22:11:10.000000000 +1100
@@ -570,11 +570,18 @@ static struct inode *ocfs2_alloc_inode(s
 	return &oi->vfs_inode;
 }
 
-static void ocfs2_destroy_inode(struct inode *inode)
+static void ocfs2_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(ocfs2_inode_cachep, OCFS2_I(inode));
 }
 
+static void ocfs2_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, ocfs2_i_callback);
+}
+
 static unsigned long long ocfs2_max_file_offset(unsigned int bbits,
 						unsigned int cbits)
 {
Index: linux-2.6/fs/openpromfs/inode.c
===================================================================
--- linux-2.6.orig/fs/openpromfs/inode.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/openpromfs/inode.c	2010-11-09 22:11:10.000000000 +1100
@@ -343,11 +343,18 @@ static struct inode *openprom_alloc_inod
 	return &oi->vfs_inode;
 }
 
-static void openprom_destroy_inode(struct inode *inode)
+static void openprom_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(op_inode_cachep, OP_I(inode));
 }
 
+static void openprom_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, openprom_i_callback);
+}
+
 static struct inode *openprom_iget(struct super_block *sb, ino_t ino)
 {
 	struct inode *inode;
Index: linux-2.6/fs/qnx4/inode.c
===================================================================
--- linux-2.6.orig/fs/qnx4/inode.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/qnx4/inode.c	2010-11-09 22:11:10.000000000 +1100
@@ -425,11 +425,18 @@ static struct inode *qnx4_alloc_inode(st
 	return &ei->vfs_inode;
 }
 
-static void qnx4_destroy_inode(struct inode *inode)
+static void qnx4_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(qnx4_inode_cachep, qnx4_i(inode));
 }
 
+static void qnx4_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, qnx4_i_callback);
+}
+
 static void init_once(void *foo)
 {
 	struct qnx4_inode_info *ei = (struct qnx4_inode_info *) foo;
Index: linux-2.6/fs/reiserfs/super.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/super.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/reiserfs/super.c	2010-11-09 22:11:10.000000000 +1100
@@ -530,11 +530,18 @@ static struct inode *reiserfs_alloc_inod
 	return &ei->vfs_inode;
 }
 
-static void reiserfs_destroy_inode(struct inode *inode)
+static void reiserfs_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(reiserfs_inode_cachep, REISERFS_I(inode));
 }
 
+static void reiserfs_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, reiserfs_i_callback);
+}
+
 static void init_once(void *foo)
 {
 	struct reiserfs_inode_info *ei = (struct reiserfs_inode_info *)foo;
Index: linux-2.6/fs/romfs/super.c
===================================================================
--- linux-2.6.orig/fs/romfs/super.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/romfs/super.c	2010-11-09 22:11:10.000000000 +1100
@@ -400,11 +400,18 @@ static struct inode *romfs_alloc_inode(s
 /*
  * return a spent inode to the slab cache
  */
-static void romfs_destroy_inode(struct inode *inode)
+static void romfs_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(romfs_inode_cachep, ROMFS_I(inode));
 }
 
+static void romfs_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, romfs_i_callback);
+}
+
 /*
  * get filesystem statistics
  */
Index: linux-2.6/fs/squashfs/super.c
===================================================================
--- linux-2.6.orig/fs/squashfs/super.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/squashfs/super.c	2010-11-09 22:11:10.000000000 +1100
@@ -440,11 +440,18 @@ static struct inode *squashfs_alloc_inod
 }
 
 
-static void squashfs_destroy_inode(struct inode *inode)
+static void squashfs_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(squashfs_inode_cachep, squashfs_i(inode));
 }
 
+static void squashfs_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, squashfs_i_callback);
+}
+
 
 static struct file_system_type squashfs_fs_type = {
 	.owner = THIS_MODULE,
Index: linux-2.6/fs/sysv/inode.c
===================================================================
--- linux-2.6.orig/fs/sysv/inode.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/sysv/inode.c	2010-11-09 22:11:10.000000000 +1100
@@ -333,11 +333,18 @@ static struct inode *sysv_alloc_inode(st
 	return &si->vfs_inode;
 }
 
-static void sysv_destroy_inode(struct inode *inode)
+static void sysv_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(sysv_inode_cachep, SYSV_I(inode));
 }
 
+static void sysv_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, sysv_i_callback);
+}
+
 static void init_once(void *p)
 {
 	struct sysv_inode_info *si = (struct sysv_inode_info *)p;
Index: linux-2.6/fs/ubifs/super.c
===================================================================
--- linux-2.6.orig/fs/ubifs/super.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/ubifs/super.c	2010-11-09 22:11:10.000000000 +1100
@@ -272,12 +272,20 @@ static struct inode *ubifs_alloc_inode(s
 	return &ui->vfs_inode;
 };
 
+static void ubifs_i_callback(struct rcu_head *head)
+{
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	struct ubifs_inode *ui = ubifs_inode(inode);
+	INIT_LIST_HEAD(&inode->i_dentry);
+	kmem_cache_free(ubifs_inode_slab, ui);
+}
+
 static void ubifs_destroy_inode(struct inode *inode)
 {
 	struct ubifs_inode *ui = ubifs_inode(inode);
 
 	kfree(ui->data);
-	kmem_cache_free(ubifs_inode_slab, inode);
+	call_rcu(&inode->i_rcu, ubifs_i_callback);
 }
 
 /*
Index: linux-2.6/fs/udf/super.c
===================================================================
--- linux-2.6.orig/fs/udf/super.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/udf/super.c	2010-11-09 22:11:10.000000000 +1100
@@ -139,11 +139,18 @@ static struct inode *udf_alloc_inode(str
 	return &ei->vfs_inode;
 }
 
-static void udf_destroy_inode(struct inode *inode)
+static void udf_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(udf_inode_cachep, UDF_I(inode));
 }
 
+static void udf_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, udf_i_callback);
+}
+
 static void init_once(void *foo)
 {
 	struct udf_inode_info *ei = (struct udf_inode_info *)foo;
Index: linux-2.6/fs/ufs/super.c
===================================================================
--- linux-2.6.orig/fs/ufs/super.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/ufs/super.c	2010-11-09 22:11:10.000000000 +1100
@@ -1412,11 +1412,18 @@ static struct inode *ufs_alloc_inode(str
 	return &ei->vfs_inode;
 }
 
-static void ufs_destroy_inode(struct inode *inode)
+static void ufs_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(ufs_inode_cachep, UFS_I(inode));
 }
 
+static void ufs_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, ufs_i_callback);
+}
+
 static void init_once(void *foo)
 {
 	struct ufs_inode_info *ei = (struct ufs_inode_info *) foo;
Index: linux-2.6/arch/powerpc/platforms/cell/spufs/inode.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/spufs/inode.c	2010-11-09 22:11:01.000000000 +1100
+++ linux-2.6/arch/powerpc/platforms/cell/spufs/inode.c	2010-11-09 22:11:10.000000000 +1100
@@ -71,12 +71,18 @@ spufs_alloc_inode(struct super_block *sb
 	return &ei->vfs_inode;
 }
 
-static void
-spufs_destroy_inode(struct inode *inode)
+static void spufs_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(spufs_inode_cache, SPUFS_I(inode));
 }
 
+static void spufs_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, spufs_i_callback);
+}
+
 static void
 spufs_init_once(void *p)
 {
Index: linux-2.6/drivers/staging/pohmelfs/inode.c
===================================================================
--- linux-2.6.orig/drivers/staging/pohmelfs/inode.c	2010-11-09 22:11:01.000000000 +1100
+++ linux-2.6/drivers/staging/pohmelfs/inode.c	2010-11-09 22:11:10.000000000 +1100
@@ -826,6 +826,14 @@ const struct address_space_operations po
 	.set_page_dirty 	= __set_page_dirty_nobuffers,
 };
 
+static void pohmelfs_i_callback(struct rcu_head *head)
+{
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
+	kmem_cache_free(pohmelfs_inode_cache, POHMELFS_I(inode));
+	atomic_long_dec(&psb->total_inodes);
+}
+
 /*
  * ->detroy_inode() callback. Deletes inode from the caches
  *  and frees private data.
@@ -842,8 +850,7 @@ static void pohmelfs_destroy_inode(struc
 
 	dprintk("%s: pi: %p, inode: %p, ino: %llu.\n",
 		__func__, pi, &pi->vfs_inode, pi->ino);
-	kmem_cache_free(pohmelfs_inode_cache, pi);
-	atomic_long_dec(&psb->total_inodes);
+	call_rcu(&inode->i_rcu, pohmelfs_i_callback);
 }
 
 /*
Index: linux-2.6/fs/hostfs/hostfs_kern.c
===================================================================
--- linux-2.6.orig/fs/hostfs/hostfs_kern.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/hostfs/hostfs_kern.c	2010-11-09 23:22:53.000000000 +1100
@@ -251,11 +251,18 @@ static void hostfs_evict_inode(struct in
 	}
 }
 
-static void hostfs_destroy_inode(struct inode *inode)
+static void hostfs_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kfree(HOSTFS_I(inode));
 }
 
+static void hostfs_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, hostfs_i_callback);
+}
+
 static int hostfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
 {
 	const char *root_path = vfs->mnt_sb->s_fs_info;
Index: linux-2.6/fs/hppfs/hppfs.c
===================================================================
--- linux-2.6.orig/fs/hppfs/hppfs.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/hppfs/hppfs.c	2010-11-09 22:11:10.000000000 +1100
@@ -632,11 +632,18 @@ void hppfs_evict_inode(struct inode *ino
 	mntput(ino->i_sb->s_fs_info);
 }
 
-static void hppfs_destroy_inode(struct inode *inode)
+static void hppfs_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kfree(HPPFS_I(inode));
 }
 
+static void hppfs_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, hppfs_i_callback);
+}
+
 static const struct super_operations hppfs_sbops = {
 	.alloc_inode	= hppfs_alloc_inode,
 	.destroy_inode	= hppfs_destroy_inode,
Index: linux-2.6/fs/xfs/xfs_iget.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_iget.c	2010-11-09 22:11:02.000000000 +1100
+++ linux-2.6/fs/xfs/xfs_iget.c	2010-11-09 22:11:10.000000000 +1100
@@ -91,6 +91,17 @@ xfs_inode_alloc(
 	return ip;
 }
 
+STATIC void
+xfs_inode_free_callback(
+	struct rcu_head		*head)
+{
+	struct inode		*inode = container_of(head, struct inode, i_rcu);
+	struct xfs_inode	*ip = XFS_I(inode);
+
+	INIT_LIST_HEAD(&inode->i_dentry);
+	kmem_zone_free(xfs_inode_zone, ip);
+}
+
 void
 xfs_inode_free(
 	struct xfs_inode	*ip)
@@ -134,7 +145,7 @@ xfs_inode_free(
 	ASSERT(!spin_is_locked(&ip->i_flags_lock));
 	ASSERT(completion_done(&ip->i_flush));
 
-	kmem_zone_free(xfs_inode_zone, ip);
+	call_rcu(&ip->i_vnode.i_rcu, xfs_inode_free_callback);
 }
 
 /*
Index: linux-2.6/Documentation/filesystems/porting
===================================================================
--- linux-2.6.orig/Documentation/filesystems/porting	2010-11-09 22:11:01.000000000 +1100
+++ linux-2.6/Documentation/filesystems/porting	2010-11-09 23:22:52.000000000 +1100
@@ -318,3 +318,15 @@ if it's zero is not *and* *never* *had*
 may happen while the inode is in the middle of ->write_inode(); e.g. if you blindly
 free the on-disk inode, you may end up doing that while ->write_inode() is writing
 to it.
+
+--
+[mandatory]
+
+	Filesystems must RCU-free their inodes, if they can have been accessed via
+rcu-walk path walk (basically, if the file can have had a path name in the vfs
+namespace).
+
+	i_dentry and i_rcu share storage in a union, and the vfs expects i_dentry
+to be reinitialized before it is freed, so INIT_LIST_HEAD(&inode->i_dentry)
+must be done in the RCU callback.
+
