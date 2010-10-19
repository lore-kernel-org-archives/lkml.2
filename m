Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933739Ab0JSD4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 23:56:32 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:28439 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933673Ab0JSD40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:56:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEFAJyxvEx5LcB2gWdsb2JhbACUbYx6FgEBFiIiwxaFSQSFDIU+
Message-Id: <20101019034657.257982410@kernel.dk>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 14:42:33 +1100
From: npiggin@kernel.dk
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 17/35] fs: icache RCU free inodes
References: <20101019034216.319085068@kernel.dk>
Content-Disposition: inline; filename=fs-inode_rcu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RCU free the struct inode. This will allow:

- Subsequent store-free path walking patch. The inode must be consulted for
  permissions when walking, so an RCU inode reference is a must.
- sb_inode_list_lock to be moved inside i_lock because sb list walkers who want
  to take i_lock no longer need to take sb_inode_list_lock to walk the list in
  the first place. This will simplify and optimize locking.
- Could remove some nested trylock loops in dcache code
- Could potentially simplify things a bit in VM land. Do not need to take the
  page lock to follow page->mapping.

The downsides of this is the performance cost of using RCU. In a simple
creat/unlink microbenchmark, performance drops by about 10% due to inability to
reuse cache-hot slab objects. As iterations increase and RCU freeing starts
kicking over, this increases to about 20%.

In cases where inode lifetimes are longer (ie. many inodes may be allocated
during the average life span of a single inode), a lot of this cache reuse is
not applicable, so the regression caused by this patch is smaller.

The cache-hot regression could largely be avoided by using SLAB_DESTROY_BY_RCU,
however this adds some complexity to list walking and store-free path walking,
so I prefer to implement this at a later date, if it is shown to be a win in
real situations. I haven't found a regression in any non-micro benchmark so I
doubt it will be a problem.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 Documentation/filesystems/porting         |    4 
 arch/powerpc/platforms/cell/spufs/inode.c |   10 +-
 drivers/staging/pohmelfs/inode.c          |   11 ++
 fs/9p/vfs_inode.c                         |    9 +-
 fs/adfs/super.c                           |    9 +-
 fs/affs/super.c                           |    9 +-
 fs/afs/super.c                            |   10 ++
 fs/befs/linuxvfs.c                        |   10 +-
 fs/bfs/inode.c                            |    9 +-
 fs/block_dev.c                            |    9 +-
 fs/btrfs/inode.c                          |    9 +-
 fs/ceph/inode.c                           |   11 ++
 fs/cifs/cifsfs.c                          |    9 +-
 fs/coda/inode.c                           |    9 +-
 fs/ecryptfs/super.c                       |   12 ++
 fs/efs/super.c                            |    9 +-
 fs/exofs/super.c                          |    9 +-
 fs/ext2/super.c                           |    9 +-
 fs/ext3/super.c                           |    9 +-
 fs/ext4/super.c                           |    9 +-
 fs/fat/inode.c                            |    9 +-
 fs/freevxfs/vxfs_inode.c                  |    9 +-
 fs/fuse/inode.c                           |    9 +-
 fs/gfs2/super.c                           |    9 +-
 fs/hfs/super.c                            |    9 +-
 fs/hfsplus/super.c                        |    9 +-
 fs/hostfs/hostfs_kern.c                   |    9 +-
 fs/hpfs/super.c                           |    9 +-
 fs/hppfs/hppfs.c                          |    9 +-
 fs/hugetlbfs/inode.c                      |    9 +-
 fs/inode.c                                |  129 +++++++++++++++---------------
 fs/isofs/inode.c                          |    9 +-
 fs/jffs2/super.c                          |    9 +-
 fs/jfs/super.c                            |   10 ++
 fs/logfs/inode.c                          |    9 +-
 fs/minix/inode.c                          |    9 +-
 fs/ncpfs/inode.c                          |    9 +-
 fs/nfs/inode.c                            |    9 +-
 fs/nilfs2/super.c                         |    9 +-
 fs/ntfs/inode.c                           |    9 +-
 fs/ocfs2/dlmfs/dlmfs.c                    |    9 +-
 fs/ocfs2/super.c                          |    9 +-
 fs/openpromfs/inode.c                     |    9 +-
 fs/proc/inode.c                           |    9 +-
 fs/qnx4/inode.c                           |    9 +-
 fs/reiserfs/super.c                       |    9 +-
 fs/romfs/super.c                          |    9 +-
 fs/smbfs/inode.c                          |    9 +-
 fs/squashfs/super.c                       |    9 +-
 fs/sysv/inode.c                           |    9 +-
 fs/ubifs/super.c                          |   10 ++
 fs/udf/super.c                            |    9 +-
 fs/ufs/super.c                            |    9 +-
 fs/xfs/xfs_iget.c                         |   13 ++-
 include/linux/fs.h                        |    7 +
 include/linux/net.h                       |    1 
 ipc/mqueue.c                              |    9 +-
 mm/shmem.c                                |    9 +-
 net/socket.c                              |   16 +--
 net/sunrpc/rpc_pipe.c                     |   10 ++
 60 files changed, 539 insertions(+), 130 deletions(-)

Index: linux-2.6/fs/ext2/super.c
===================================================================
--- linux-2.6.orig/fs/ext2/super.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/ext2/super.c	2010-10-19 14:18:59.000000000 +1100
@@ -161,11 +161,18 @@
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
--- linux-2.6.orig/fs/inode.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-19 14:19:26.000000000 +1100
@@ -278,13 +278,20 @@
 }
 EXPORT_SYMBOL(__destroy_inode);
 
+static void i_callback(struct rcu_head *head)
+{
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
+	kmem_cache_free(inode_cachep, inode);
+}
+
 void destroy_inode(struct inode *inode)
 {
 	__destroy_inode(inode);
 	if (inode->i_sb->s_op->destroy_inode)
 		inode->i_sb->s_op->destroy_inode(inode);
 	else
-		kmem_cache_free(inode_cachep, (inode));
+		call_rcu(&inode->i_rcu, i_callback);
 }
 
 /*
@@ -328,6 +335,7 @@
 	BUG_ON(!(inode->i_state & I_FREEING));
 	BUG_ON(inode->i_state & I_CLEAR);
 	inode_sync_wait(inode);
+	/* don't need i_lock here, no concurrent mods to i_state */
 	inode->i_state = I_FREEING | I_CLEAR;
 }
 EXPORT_SYMBOL(end_writeback);
@@ -691,7 +699,7 @@
 	spin_unlock(&sb_inode_list_lock);
 	if (b) {
 		spin_lock_bucket(b);
-		hlist_bl_add_head(&inode->i_hash, &b->head);
+		hlist_bl_add_head_rcu(&inode->i_hash, &b->head);
 		spin_unlock_bucket(b);
 	}
 }
@@ -1190,42 +1198,41 @@
 	struct super_block *sb = inode->i_sb;
 	ino_t ino = inode->i_ino;
 	struct inode_hash_bucket *b = inode_hashtable + hash(sb, ino);
+	struct hlist_bl_node *node;
+	struct inode *old;
 
 	inode->i_state |= I_NEW;
-	while (1) {
-		struct hlist_bl_node *node;
-		struct inode *old = NULL;
 
 repeat:
-		spin_lock_bucket(b);
-		hlist_bl_for_each_entry(old, node, &b->head, i_hash) {
-			if (old->i_ino != ino)
-				continue;
-			if (old->i_sb != sb)
-				continue;
-			if (old->i_state & (I_FREEING|I_WILL_FREE))
-				continue;
-			if (!spin_trylock(&old->i_lock)) {
-				spin_unlock_bucket(b);
-				goto repeat;
-			}
-			break;
-		}
-		if (likely(!node)) {
-			hlist_bl_add_head(&inode->i_hash, &b->head);
+	spin_lock_bucket(b);
+	hlist_bl_for_each_entry(old, node, &b->head, i_hash) {
+		if (old->i_ino != ino)
+			continue;
+		if (old->i_sb != sb)
+			continue;
+		if (old->i_state & (I_FREEING|I_WILL_FREE))
+			continue;
+		if (!spin_trylock(&old->i_lock)) {
 			spin_unlock_bucket(b);
-			return 0;
-		}
-		spin_unlock_bucket(b);
-		__iget(old);
-		spin_unlock(&old->i_lock);
-		wait_on_inode(old);
-		if (unlikely(!hlist_bl_unhashed(&old->i_hash))) {
-			iput(old);
-			return -EBUSY;
+			goto repeat;
 		}
+		goto found_old;
+	}
+	hlist_bl_add_head_rcu(&inode->i_hash, &b->head);
+	spin_unlock_bucket(b);
+	return 0;
+
+found_old:
+	spin_unlock_bucket(b);
+	__iget(old);
+	spin_unlock(&old->i_lock);
+	wait_on_inode(old);
+	if (unlikely(!hlist_bl_unhashed(&old->i_hash))) {
 		iput(old);
+		return -EBUSY;
 	}
+	iput(old);
+	goto repeat;
 }
 EXPORT_SYMBOL(insert_inode_locked);
 
@@ -1234,43 +1241,43 @@
 {
 	struct super_block *sb = inode->i_sb;
 	struct inode_hash_bucket *b = inode_hashtable + hash(sb, hashval);
+	struct hlist_bl_node *node;
+	struct inode *old;
 
 	inode->i_state |= I_NEW;
 
-	while (1) {
-		struct hlist_bl_node *node;
-		struct inode *old = NULL;
-
 repeat:
-		spin_lock_bucket(b);
-		hlist_bl_for_each_entry(old, node, &b->head, i_hash) {
-			if (old->i_sb != sb)
-				continue;
-			if (!test(old, data))
-				continue;
-			if (old->i_state & (I_FREEING|I_WILL_FREE))
-				continue;
-			if (!spin_trylock(&old->i_lock)) {
-				spin_unlock_bucket(b);
-				goto repeat;
-			}
-			break;
-		}
-		if (likely(!node)) {
-			hlist_bl_add_head(&inode->i_hash, &b->head);
+	spin_lock_bucket(b);
+	hlist_bl_for_each_entry(old, node, &b->head, i_hash) {
+		if (old->i_sb != sb)
+			continue;
+		/* XXX: audit put test outside i_lock? */
+		if (!test(old, data))
+			continue;
+		if (old->i_state & (I_FREEING|I_WILL_FREE))
+			continue;
+		if (!spin_trylock(&old->i_lock)) {
 			spin_unlock_bucket(b);
-			return 0;
-		}
-		spin_unlock_bucket(b);
-		__iget(old);
-		spin_unlock(&old->i_lock);
-		wait_on_inode(old);
-		if (unlikely(!hlist_bl_unhashed(&old->i_hash))) {
-			iput(old);
-			return -EBUSY;
+			cpu_relax();
+			goto repeat;
 		}
+		goto found_old;
+	}
+	hlist_bl_add_head_rcu(&inode->i_hash, &b->head);
+	spin_unlock_bucket(b);
+	return 0;
+
+found_old:
+	spin_unlock_bucket(b);
+	__iget(old);
+	spin_unlock(&old->i_lock);
+	wait_on_inode(old);
+	if (unlikely(!hlist_bl_unhashed(&old->i_hash))) {
 		iput(old);
+		return -EBUSY;
 	}
+	iput(old);
+	goto repeat;
 }
 EXPORT_SYMBOL(insert_inode_locked4);
 
@@ -1288,7 +1295,7 @@
 
 	spin_lock(&inode->i_lock);
 	spin_lock_bucket(b);
-	hlist_bl_add_head(&inode->i_hash, &b->head);
+	hlist_bl_add_head_rcu(&inode->i_hash, &b->head);
 	spin_unlock_bucket(b);
 	spin_unlock(&inode->i_lock);
 }
@@ -1305,7 +1312,7 @@
 {
 	struct inode_hash_bucket *b = inode_hashtable + hash(inode->i_sb, inode->i_ino);
 	spin_lock_bucket(b);
-	hlist_bl_del_init(&inode->i_hash);
+	hlist_bl_del_init_rcu(&inode->i_hash);
 	spin_unlock_bucket(b);
 }
 
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/include/linux/fs.h	2010-10-19 14:19:26.000000000 +1100
@@ -380,7 +380,7 @@
 #include <linux/cache.h>
 #include <linux/kobject.h>
 #include <linux/list.h>
-#include <linux/list_bl.h>
+#include <linux/rculist_bl.h>
 #include <linux/radix-tree.h>
 #include <linux/prio_tree.h>
 #include <linux/init.h>
@@ -732,7 +732,10 @@
 	struct hlist_bl_node	i_hash;
 	struct list_head	i_list;		/* backing dev IO list */
 	struct list_head	i_sb_list;
-	struct list_head	i_dentry;
+	union {
+		struct list_head	i_dentry;
+		struct rcu_head		i_rcu;
+	};
 	unsigned long		i_ino;
 	unsigned int		i_count;
 	unsigned int		i_nlink;
Index: linux-2.6/fs/block_dev.c
===================================================================
--- linux-2.6.orig/fs/block_dev.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/block_dev.c	2010-10-19 14:19:18.000000000 +1100
@@ -395,13 +395,20 @@
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
--- linux-2.6.orig/fs/ext3/super.c	2010-10-19 14:17:21.000000000 +1100
+++ linux-2.6/fs/ext3/super.c	2010-10-19 14:18:59.000000000 +1100
@@ -485,6 +485,13 @@
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
@@ -495,7 +502,7 @@
 				false);
 		dump_stack();
 	}
-	kmem_cache_free(ext3_inode_cachep, EXT3_I(inode));
+	call_rcu(&inode->i_rcu, ext3_i_callback);
 }
 
 static void init_once(void *foo)
Index: linux-2.6/fs/hugetlbfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hugetlbfs/inode.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/hugetlbfs/inode.c	2010-10-19 14:18:59.000000000 +1100
@@ -648,11 +648,18 @@
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
--- linux-2.6.orig/fs/proc/inode.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/proc/inode.c	2010-10-19 14:18:59.000000000 +1100
@@ -66,11 +66,18 @@
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
--- linux-2.6.orig/ipc/mqueue.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/ipc/mqueue.c	2010-10-19 14:19:18.000000000 +1100
@@ -236,11 +236,18 @@
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
--- linux-2.6.orig/net/socket.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/net/socket.c	2010-10-19 14:19:26.000000000 +1100
@@ -262,20 +262,20 @@
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
--- linux-2.6.orig/fs/fat/inode.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/fat/inode.c	2010-10-19 14:18:59.000000000 +1100
@@ -519,11 +519,18 @@
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
--- linux-2.6.orig/fs/nfs/inode.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/nfs/inode.c	2010-10-19 14:19:16.000000000 +1100
@@ -1434,11 +1434,18 @@
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
--- linux-2.6.orig/mm/shmem.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/mm/shmem.c	2010-10-19 14:19:18.000000000 +1100
@@ -2416,13 +2416,20 @@
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
--- linux-2.6.orig/net/sunrpc/rpc_pipe.c	2010-10-19 14:17:21.000000000 +1100
+++ linux-2.6/net/sunrpc/rpc_pipe.c	2010-10-19 14:18:59.000000000 +1100
@@ -163,11 +163,19 @@
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
--- linux-2.6.orig/include/linux/net.h	2010-10-19 14:17:19.000000000 +1100
+++ linux-2.6/include/linux/net.h	2010-10-19 14:19:26.000000000 +1100
@@ -120,7 +120,6 @@
 struct socket_wq {
 	wait_queue_head_t	wait;
 	struct fasync_struct	*fasync_list;
-	struct rcu_head		rcu;
 } ____cacheline_aligned_in_smp;
 
 /**
Index: linux-2.6/fs/9p/vfs_inode.c
===================================================================
--- linux-2.6.orig/fs/9p/vfs_inode.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/9p/vfs_inode.c	2010-10-19 14:19:18.000000000 +1100
@@ -231,10 +231,17 @@
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
--- linux-2.6.orig/fs/adfs/super.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/adfs/super.c	2010-10-19 14:18:59.000000000 +1100
@@ -240,11 +240,18 @@
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
--- linux-2.6.orig/fs/affs/super.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/affs/super.c	2010-10-19 14:18:59.000000000 +1100
@@ -100,11 +100,18 @@
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
--- linux-2.6.orig/fs/afs/super.c	2010-10-19 14:17:21.000000000 +1100
+++ linux-2.6/fs/afs/super.c	2010-10-19 14:18:59.000000000 +1100
@@ -508,6 +508,14 @@
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
@@ -521,7 +529,7 @@
 
 	ASSERTCMP(vnode->server, ==, NULL);
 
-	kmem_cache_free(afs_inode_cachep, vnode);
+	call_rcu(&inode->i_rcu, afs_i_callback);
 	atomic_dec(&afs_count_active_inodes);
 }
 
Index: linux-2.6/fs/befs/linuxvfs.c
===================================================================
--- linux-2.6.orig/fs/befs/linuxvfs.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/befs/linuxvfs.c	2010-10-19 14:18:59.000000000 +1100
@@ -284,12 +284,18 @@
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
--- linux-2.6.orig/fs/bfs/inode.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/bfs/inode.c	2010-10-19 14:18:59.000000000 +1100
@@ -253,11 +253,18 @@
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
--- linux-2.6.orig/fs/btrfs/inode.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/btrfs/inode.c	2010-10-19 14:19:18.000000000 +1100
@@ -6286,6 +6286,13 @@
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
@@ -6340,7 +6347,7 @@
 	inode_tree_del(inode);
 	btrfs_drop_extent_cache(inode, 0, (u64)-1, 0);
 free:
-	kmem_cache_free(btrfs_inode_cachep, BTRFS_I(inode));
+	call_rcu(&inode->i_rcu, btrfs_i_callback);
 }
 
 int btrfs_drop_inode(struct inode *inode)
Index: linux-2.6/fs/ceph/inode.c
===================================================================
--- linux-2.6.orig/fs/ceph/inode.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/ceph/inode.c	2010-10-19 14:18:59.000000000 +1100
@@ -368,6 +368,15 @@
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
@@ -407,7 +416,7 @@
 	if (ci->i_xattrs.prealloc_blob)
 		ceph_buffer_put(ci->i_xattrs.prealloc_blob);
 
-	kmem_cache_free(ceph_inode_cachep, ci);
+	call_rcu(&inode->i_rcu, ceph_i_callback);
 }
 
 
Index: linux-2.6/fs/cifs/cifsfs.c
===================================================================
--- linux-2.6.orig/fs/cifs/cifsfs.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/cifs/cifsfs.c	2010-10-19 14:18:59.000000000 +1100
@@ -322,10 +322,17 @@
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
--- linux-2.6.orig/fs/coda/inode.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/coda/inode.c	2010-10-19 14:18:59.000000000 +1100
@@ -54,11 +54,18 @@
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
--- linux-2.6.orig/fs/ecryptfs/super.c	2010-10-19 14:17:21.000000000 +1100
+++ linux-2.6/fs/ecryptfs/super.c	2010-10-19 14:18:59.000000000 +1100
@@ -63,6 +63,16 @@
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
@@ -89,7 +99,7 @@
 		}
 	}
 	ecryptfs_destroy_crypt_stat(&inode_info->crypt_stat);
-	kmem_cache_free(ecryptfs_inode_info_cache, inode_info);
+	call_rcu(&inode->i_rcu, ecryptfs_i_callback);
 }
 
 /**
Index: linux-2.6/fs/efs/super.c
===================================================================
--- linux-2.6.orig/fs/efs/super.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/efs/super.c	2010-10-19 14:18:59.000000000 +1100
@@ -65,11 +65,18 @@
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
--- linux-2.6.orig/fs/exofs/super.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/exofs/super.c	2010-10-19 14:18:59.000000000 +1100
@@ -150,12 +150,19 @@
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
--- linux-2.6.orig/fs/ext4/super.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/ext4/super.c	2010-10-19 14:18:59.000000000 +1100
@@ -825,6 +825,13 @@
 	return &ei->vfs_inode;
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
 	if (!list_empty(&(EXT4_I(inode)->i_orphan))) {
@@ -836,7 +843,7 @@
 				true);
 		dump_stack();
 	}
-	kmem_cache_free(ext4_inode_cachep, EXT4_I(inode));
+	call_rcu(&inode->i_rcu, ext4_i_callback);
 }
 
 static void init_once(void *foo)
Index: linux-2.6/fs/freevxfs/vxfs_inode.c
===================================================================
--- linux-2.6.orig/fs/freevxfs/vxfs_inode.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/freevxfs/vxfs_inode.c	2010-10-19 14:18:59.000000000 +1100
@@ -336,6 +336,13 @@
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
@@ -349,5 +356,5 @@
 {
 	truncate_inode_pages(&ip->i_data, 0);
 	end_writeback(ip);
-	kmem_cache_free(vxfs_inode_cachep, ip->i_private);
+	call_rcu(&ip->i_rcu, vxfs_i_callback);
 }
Index: linux-2.6/fs/fuse/inode.c
===================================================================
--- linux-2.6.orig/fs/fuse/inode.c	2010-10-19 14:17:21.000000000 +1100
+++ linux-2.6/fs/fuse/inode.c	2010-10-19 14:18:59.000000000 +1100
@@ -99,6 +99,13 @@
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
@@ -106,7 +113,7 @@
 	BUG_ON(!list_empty(&fi->queued_writes));
 	if (fi->forget_req)
 		fuse_request_free(fi->forget_req);
-	kmem_cache_free(fuse_inode_cachep, inode);
+	call_rcu(&inode->i_rcu, fuse_i_callback);
 }
 
 void fuse_send_forget(struct fuse_conn *fc, struct fuse_req *req,
Index: linux-2.6/fs/gfs2/super.c
===================================================================
--- linux-2.6.orig/fs/gfs2/super.c	2010-10-19 14:17:21.000000000 +1100
+++ linux-2.6/fs/gfs2/super.c	2010-10-19 14:18:59.000000000 +1100
@@ -1414,11 +1414,18 @@
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
--- linux-2.6.orig/fs/hfs/super.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/hfs/super.c	2010-10-19 14:18:59.000000000 +1100
@@ -172,11 +172,18 @@
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
--- linux-2.6.orig/fs/hfsplus/super.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/hfsplus/super.c	2010-10-19 14:18:59.000000000 +1100
@@ -484,11 +484,18 @@
 	return i ? &i->vfs_inode : NULL;
 }
 
-static void hfsplus_destroy_inode(struct inode *inode)
+static void hfsplus_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(hfsplus_inode_cachep, &HFSPLUS_I(inode));
 }
 
+static void hfsplus_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, hfsplus_i_callback);
+}
+
 #define HFSPLUS_INODE_SIZE	sizeof(struct hfsplus_inode_info)
 
 static int hfsplus_get_sb(struct file_system_type *fs_type,
Index: linux-2.6/fs/hpfs/super.c
===================================================================
--- linux-2.6.orig/fs/hpfs/super.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/hpfs/super.c	2010-10-19 14:18:59.000000000 +1100
@@ -177,11 +177,18 @@
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
--- linux-2.6.orig/fs/isofs/inode.c	2010-10-19 14:17:21.000000000 +1100
+++ linux-2.6/fs/isofs/inode.c	2010-10-19 14:18:59.000000000 +1100
@@ -70,11 +70,18 @@
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
--- linux-2.6.orig/fs/jffs2/super.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/jffs2/super.c	2010-10-19 14:18:59.000000000 +1100
@@ -41,11 +41,18 @@
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
--- linux-2.6.orig/fs/jfs/super.c	2010-10-19 14:17:21.000000000 +1100
+++ linux-2.6/fs/jfs/super.c	2010-10-19 14:18:59.000000000 +1100
@@ -116,6 +116,14 @@
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
@@ -129,7 +137,7 @@
 		ji->active_ag = -1;
 	}
 	spin_unlock_irq(&ji->ag_lock);
-	kmem_cache_free(jfs_inode_cachep, ji);
+	call_rcu(&inode->i_rcu, jfs_i_callback);
 }
 
 static int jfs_statfs(struct dentry *dentry, struct kstatfs *buf)
Index: linux-2.6/fs/logfs/inode.c
===================================================================
--- linux-2.6.orig/fs/logfs/inode.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/logfs/inode.c	2010-10-19 14:18:59.000000000 +1100
@@ -141,13 +141,20 @@
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
--- linux-2.6.orig/fs/minix/inode.c	2010-10-19 14:17:21.000000000 +1100
+++ linux-2.6/fs/minix/inode.c	2010-10-19 14:18:59.000000000 +1100
@@ -68,11 +68,18 @@
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
--- linux-2.6.orig/fs/ncpfs/inode.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/ncpfs/inode.c	2010-10-19 14:18:59.000000000 +1100
@@ -59,11 +59,18 @@
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
--- linux-2.6.orig/fs/nilfs2/super.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/nilfs2/super.c	2010-10-19 14:18:59.000000000 +1100
@@ -166,11 +166,18 @@
 	return nilfs_alloc_inode_common(NILFS_SB(sb)->s_nilfs);
 }
 
-void nilfs_destroy_inode(struct inode *inode)
+static void nilfs_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
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
--- linux-2.6.orig/fs/ntfs/inode.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/ntfs/inode.c	2010-10-19 14:19:16.000000000 +1100
@@ -332,6 +332,13 @@
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
@@ -340,7 +347,7 @@
 	BUG_ON(ni->page);
 	if (!atomic_dec_and_test(&ni->count))
 		BUG();
-	kmem_cache_free(ntfs_big_inode_cache, NTFS_I(inode));
+	call_rcu(&inode->i_rcu, ntfs_i_callback);
 }
 
 static inline ntfs_inode *ntfs_alloc_extent_inode(void)
Index: linux-2.6/fs/ocfs2/dlmfs/dlmfs.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/dlmfs/dlmfs.c	2010-10-19 14:17:21.000000000 +1100
+++ linux-2.6/fs/ocfs2/dlmfs/dlmfs.c	2010-10-19 14:18:59.000000000 +1100
@@ -351,11 +351,18 @@
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
--- linux-2.6.orig/fs/ocfs2/super.c	2010-10-19 14:17:21.000000000 +1100
+++ linux-2.6/fs/ocfs2/super.c	2010-10-19 14:18:59.000000000 +1100
@@ -550,11 +550,18 @@
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
--- linux-2.6.orig/fs/openpromfs/inode.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/openpromfs/inode.c	2010-10-19 14:18:59.000000000 +1100
@@ -343,11 +343,18 @@
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
--- linux-2.6.orig/fs/qnx4/inode.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/qnx4/inode.c	2010-10-19 14:18:59.000000000 +1100
@@ -431,11 +431,18 @@
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
--- linux-2.6.orig/fs/reiserfs/super.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/reiserfs/super.c	2010-10-19 14:18:59.000000000 +1100
@@ -530,11 +530,18 @@
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
--- linux-2.6.orig/fs/romfs/super.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/romfs/super.c	2010-10-19 14:18:59.000000000 +1100
@@ -399,11 +399,18 @@
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
Index: linux-2.6/fs/smbfs/inode.c
===================================================================
--- linux-2.6.orig/fs/smbfs/inode.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/smbfs/inode.c	2010-10-19 14:19:16.000000000 +1100
@@ -62,11 +62,18 @@
 	return &ei->vfs_inode;
 }
 
-static void smb_destroy_inode(struct inode *inode)
+static void smb_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(smb_inode_cachep, SMB_I(inode));
 }
 
+static void smb_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, smb_i_callback);
+}
+
 static void init_once(void *foo)
 {
 	struct smb_inode_info *ei = (struct smb_inode_info *) foo;
Index: linux-2.6/fs/squashfs/super.c
===================================================================
--- linux-2.6.orig/fs/squashfs/super.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/squashfs/super.c	2010-10-19 14:18:59.000000000 +1100
@@ -447,11 +447,18 @@
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
--- linux-2.6.orig/fs/sysv/inode.c	2010-10-19 14:17:21.000000000 +1100
+++ linux-2.6/fs/sysv/inode.c	2010-10-19 14:18:59.000000000 +1100
@@ -333,11 +333,18 @@
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
--- linux-2.6.orig/fs/ubifs/super.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/ubifs/super.c	2010-10-19 14:19:16.000000000 +1100
@@ -272,12 +272,20 @@
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
--- linux-2.6.orig/fs/udf/super.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/udf/super.c	2010-10-19 14:18:59.000000000 +1100
@@ -140,11 +140,18 @@
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
--- linux-2.6.orig/fs/ufs/super.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/ufs/super.c	2010-10-19 14:18:59.000000000 +1100
@@ -1407,11 +1407,18 @@
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
Index: linux-2.6/Documentation/filesystems/porting
===================================================================
--- linux-2.6.orig/Documentation/filesystems/porting	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/Documentation/filesystems/porting	2010-10-19 14:18:59.000000000 +1100
@@ -326,3 +326,7 @@
 particular things. Most of the time, a filesystem only needs ->i_lock, which
 protects *all* the inode state and its membership on lists that was
 previously protected with inode_lock.
+
+--
+[mandatory]
+	Filessystems must RCU-free their inodes. Lots of examples.
Index: linux-2.6/arch/powerpc/platforms/cell/spufs/inode.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/spufs/inode.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/arch/powerpc/platforms/cell/spufs/inode.c	2010-10-19 14:18:59.000000000 +1100
@@ -71,12 +71,18 @@
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
--- linux-2.6.orig/drivers/staging/pohmelfs/inode.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/drivers/staging/pohmelfs/inode.c	2010-10-19 14:19:16.000000000 +1100
@@ -826,6 +826,14 @@
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
@@ -842,8 +850,7 @@
 
 	dprintk("%s: pi: %p, inode: %p, ino: %llu.\n",
 		__func__, pi, &pi->vfs_inode, pi->ino);
-	kmem_cache_free(pohmelfs_inode_cache, pi);
-	atomic_long_dec(&psb->total_inodes);
+	call_rcu(&inode->i_rcu, pohmelfs_i_callback);
 }
 
 /*
Index: linux-2.6/fs/hostfs/hostfs_kern.c
===================================================================
--- linux-2.6.orig/fs/hostfs/hostfs_kern.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/hostfs/hostfs_kern.c	2010-10-19 14:18:59.000000000 +1100
@@ -251,11 +251,18 @@
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
--- linux-2.6.orig/fs/hppfs/hppfs.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/hppfs/hppfs.c	2010-10-19 14:18:59.000000000 +1100
@@ -631,11 +631,18 @@
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
--- linux-2.6.orig/fs/xfs/xfs_iget.c	2010-10-19 14:17:20.000000000 +1100
+++ linux-2.6/fs/xfs/xfs_iget.c	2010-10-19 14:18:59.000000000 +1100
@@ -91,6 +91,17 @@
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
@@ -134,7 +145,7 @@
 	ASSERT(!spin_is_locked(&ip->i_flags_lock));
 	ASSERT(completion_done(&ip->i_flush));
 
-	kmem_zone_free(xfs_inode_zone, ip);
+	call_rcu(&ip->i_vnode.i_rcu, xfs_inode_free_callback);
 }
 
 /*


