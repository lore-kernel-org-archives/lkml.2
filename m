Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab0FXDQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:16:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36019 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168Ab0FXDPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:50 -0400
Message-Id: <20100624030731.710413510@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:50 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 38/52] fs: icache RCU free inodes
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-inode_rcu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RCU free the struct inode. This will allow:

- sb_inode_list_lock to be moved inside i_lock because sb list walkers who want
  to take i_lock no longer need to take sb_inode_list_lock to walk the list in
  the first place. This will simplify and optimize locking.
- eventually, completely write-free RCU path walking. The inode must be
  consulted for permissions when walking, so a write-free reference (ie.
  RCU is helpful).
- can potentially simplify things a bit in VM land. May not need to take the
  page lock to get back to the page->mapping.
- can remove some nested trylock loops in dcache code
- Could remove the 'wq' allocation from socket now that the entire thing is
  rcu freed.

todo: convert all filesystems
---
 fs/block_dev.c        |    9 ++++++++-
 fs/ext2/super.c       |    9 ++++++++-
 fs/ext3/super.c       |    9 ++++++++-
 fs/fat/inode.c        |    9 ++++++++-
 fs/hugetlbfs/inode.c  |    9 ++++++++-
 fs/inode.c            |    9 ++++++++-
 fs/nfs/inode.c        |    9 ++++++++-
 fs/proc/inode.c       |    9 ++++++++-
 include/linux/fs.h    |    5 ++++-
 ipc/mqueue.c          |    9 ++++++++-
 mm/shmem.c            |    9 ++++++++-
 net/socket.c          |    9 ++++++++-
 net/sunrpc/rpc_pipe.c |   10 +++++++++-
 13 files changed, 101 insertions(+), 13 deletions(-)

Index: linux-2.6/fs/ext2/super.c
===================================================================
--- linux-2.6.orig/fs/ext2/super.c
+++ linux-2.6/fs/ext2/super.c
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
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -277,13 +277,20 @@ void __destroy_inode(struct inode *inode
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
@@ -346,6 +353,7 @@ void clear_inode(struct inode *inode)
 		bd_forget(inode);
 	if (S_ISCHR(inode->i_mode) && inode->i_cdev)
 		cd_forget(inode);
+	/* don't need i_lock here */
 	inode->i_state = I_CLEAR;
 }
 EXPORT_SYMBOL(clear_inode);
@@ -661,7 +669,7 @@ __inode_add_to_lists(struct super_block
 	spin_unlock(&sb_inode_list_lock);
 	if (b) {
 		spin_lock_bucket(b);
-		hlist_bl_add_head(&inode->i_hash, &b->head);
+		hlist_bl_add_head_rcu(&inode->i_hash, &b->head);
 		spin_unlock_bucket(b);
 	}
 }
@@ -713,6 +721,7 @@ struct inode *new_inode(struct super_blo
 
 	inode = alloc_inode(sb);
 	if (inode) {
+		/* XXX: init as locked for speedup */
 		spin_lock(&sb_inode_list_lock);
 		spin_lock(&inode->i_lock);
 		inode->i_ino = atomic_inc_return(&last_ino);
@@ -870,6 +879,7 @@ static int test_inode_iunique(struct sup
 			spin_unlock_bucket(b);
 			return 0;
 		}
+		/* XXX: test for I_FREEING|I_CLEAR|etc? */
 	}
 	spin_unlock_bucket(b);
 	return 1;
@@ -1156,42 +1166,41 @@ int insert_inode_locked(struct inode *in
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
-			if (old->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE))
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
+		if (old->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE))
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
 
@@ -1200,43 +1209,44 @@ int insert_inode_locked4(struct inode *i
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
-			if (old->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE))
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
+		if (old->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE))
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
 
@@ -1254,7 +1264,7 @@ void __insert_inode_hash(struct inode *i
 
 	spin_lock(&inode->i_lock);
 	spin_lock_bucket(b);
-	hlist_bl_add_head(&inode->i_hash, &b->head);
+	hlist_bl_add_head_rcu(&inode->i_hash, &b->head);
 	spin_unlock_bucket(b);
 	spin_unlock(&inode->i_lock);
 }
@@ -1271,7 +1281,7 @@ void __remove_inode_hash(struct inode *i
 {
 	struct inode_hash_bucket *b = inode_hashtable + hash(inode->i_sb, inode->i_ino);
 	spin_lock_bucket(b);
-	hlist_bl_del_init(&inode->i_hash);
+	hlist_bl_del_init_rcu(&inode->i_hash);
 	spin_unlock_bucket(b);
 }
 
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -726,7 +726,10 @@ struct inode {
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
--- linux-2.6.orig/fs/block_dev.c
+++ linux-2.6/fs/block_dev.c
@@ -397,13 +397,20 @@ static struct inode *bdev_alloc_inode(st
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
--- linux-2.6.orig/fs/ext3/super.c
+++ linux-2.6/fs/ext3/super.c
@@ -485,6 +485,13 @@ static struct inode *ext3_alloc_inode(st
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
@@ -495,7 +502,7 @@ static void ext3_destroy_inode(struct in
 				false);
 		dump_stack();
 	}
-	kmem_cache_free(ext3_inode_cachep, EXT3_I(inode));
+	call_rcu(&inode->i_rcu, ext3_i_callback);
 }
 
 static void init_once(void *foo)
Index: linux-2.6/fs/hugetlbfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hugetlbfs/inode.c
+++ linux-2.6/fs/hugetlbfs/inode.c
@@ -665,11 +665,18 @@ static struct inode *hugetlbfs_alloc_ino
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
--- linux-2.6.orig/fs/proc/inode.c
+++ linux-2.6/fs/proc/inode.c
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
--- linux-2.6.orig/ipc/mqueue.c
+++ linux-2.6/ipc/mqueue.c
@@ -236,11 +236,18 @@ static struct inode *mqueue_alloc_inode(
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
 static void mqueue_delete_inode(struct inode *inode)
 {
 	struct mqueue_inode_info *info;
Index: linux-2.6/net/socket.c
===================================================================
--- linux-2.6.orig/net/socket.c
+++ linux-2.6/net/socket.c
@@ -271,20 +271,20 @@ static struct inode *sock_alloc_inode(st
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
--- linux-2.6.orig/fs/fat/inode.c
+++ linux-2.6/fs/fat/inode.c
@@ -520,11 +520,18 @@ static struct inode *fat_alloc_inode(str
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
--- linux-2.6.orig/fs/nfs/inode.c
+++ linux-2.6/fs/nfs/inode.c
@@ -1365,11 +1365,18 @@ struct inode *nfs_alloc_inode(struct sup
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
--- linux-2.6.orig/mm/shmem.c
+++ linux-2.6/mm/shmem.c
@@ -2389,13 +2389,20 @@ static struct inode *shmem_alloc_inode(s
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
--- linux-2.6.orig/net/sunrpc/rpc_pipe.c
+++ linux-2.6/net/sunrpc/rpc_pipe.c
@@ -163,11 +163,19 @@ rpc_alloc_inode(struct super_block *sb)
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
--- linux-2.6.orig/include/linux/net.h
+++ linux-2.6/include/linux/net.h
@@ -120,7 +120,6 @@ enum sock_shutdown_cmd {
 struct socket_wq {
 	wait_queue_head_t	wait;
 	struct fasync_struct	*fasync_list;
-	struct rcu_head		rcu;
 } ____cacheline_aligned_in_smp;
 
 /**


