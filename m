Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab1FXHCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 03:02:50 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:42699 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab1FXHCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 03:02:49 -0400
Message-Id: <201106240702.p5O72bkH003998@acsmt358.oracle.com>
Date: Fri, 24 Jun 2011 15:02:08 +0800
From: Wengang Wang <wen.gang.wang@oracle.com>
To: stable@kernel.org
Cc: greg.marsden@oracle.com, joe.jin@oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH] mm: prevent concurrent unmap_mapping_range() on the same inode --to stable
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090205.4E043697.0021:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

        mainline commit 2aa15890f3c191326678f1bd68af61ec6b8753ec

    mm: prevent concurrent unmap_mapping_range() on the same inode

    Michael Leun reported that running parallel opens on a fuse filesystem
    can trigger a "kernel BUG at mm/truncate.c:475"

    Gurudas Pai reported the same bug on NFS.

    The reason is, unmap_mapping_range() is not prepared for more than
    one concurrent invocation per inode.  For example:

      thread1: going through a big range, stops in the middle of a vma and
         stores the restart address in vm_truncate_count.

      thread2: comes in with a small (e.g. single page) unmap request on
         the same vma, somewhere before restart_address, finds that the
         vma was already unmapped up to the restart address and happily
         returns without doing anything.

    Another scenario would be two big unmap requests, both having to
    restart the unmapping and each one setting vm_truncate_count to its
    own value.  This could go on forever without any of them being able to
    finish.

    Truncate and hole punching already serialize with i_mutex.  Other
    callers of unmap_mapping_range() do not, and it's difficult to get
    i_mutex protection for all callers.  In particular ->d_revalidate(),
    which calls invalidate_inode_pages2_range() in fuse, may be called
    with or without i_mutex.

    This patch adds a new mutex to 'struct address_space' to prevent
    running multiple concurrent unmap_mapping_range() on the same mapping.

    [ We'll hopefully get rid of all this with the upcoming mm
      preemptibility series by Peter Zijlstra, the "mm: Remove i_mmap_mutex
      lockbreak" patch in particular.  But that is for 2.6.39 ]


    Adding this patch causes Kabi breakage.

    Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
    Reported-by: Michael Leun <lkml20101129@newton.leun.net>
    Reported-by: Gurudas Pai <gurudas.pai@oracle.com>
    Tested-by: Gurudas Pai <gurudas.pai@oracle.com>
    Acked-by: Hugh Dickins <hughd@google.com>
    Cc: stable@kernel.org
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>

---
 fs/inode.c         |   22 +++++++++++++++-------
 fs/nilfs2/btnode.c |   13 -------------
 fs/nilfs2/btnode.h |    1 -
 fs/nilfs2/super.c  |    2 +-
 include/linux/fs.h |    2 ++
 mm/memory.c        |    2 ++
 6 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 4d8e3be..8bbe005 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -256,6 +256,20 @@ void destroy_inode(struct inode *inode)
 		kmem_cache_free(inode_cachep, (inode));
 }
 
+void address_space_init_once(struct address_space *mapping)
+{
+	memset(mapping, 0, sizeof(*mapping));
+	INIT_RADIX_TREE(&mapping->page_tree, GFP_ATOMIC);
+	spin_lock_init(&mapping->tree_lock);
+	spin_lock_init(&mapping->i_mmap_lock);
+	INIT_LIST_HEAD(&mapping->private_list);
+	spin_lock_init(&mapping->private_lock);
+	INIT_RAW_PRIO_TREE_ROOT(&mapping->i_mmap);
+	INIT_LIST_HEAD(&mapping->i_mmap_nonlinear);
+	mutex_init(&mapping->unmap_mutex);
+}
+EXPORT_SYMBOL(address_space_init_once);
+
 /*
  * These are initializations that only need to be done
  * once, because the fields are idempotent across use
@@ -267,13 +281,7 @@ void inode_init_once(struct inode *inode)
 	INIT_HLIST_NODE(&inode->i_hash);
 	INIT_LIST_HEAD(&inode->i_dentry);
 	INIT_LIST_HEAD(&inode->i_devices);
-	INIT_RADIX_TREE(&inode->i_data.page_tree, GFP_ATOMIC);
-	spin_lock_init(&inode->i_data.tree_lock);
-	spin_lock_init(&inode->i_data.i_mmap_lock);
-	INIT_LIST_HEAD(&inode->i_data.private_list);
-	spin_lock_init(&inode->i_data.private_lock);
-	INIT_RAW_PRIO_TREE_ROOT(&inode->i_data.i_mmap);
-	INIT_LIST_HEAD(&inode->i_data.i_mmap_nonlinear);
+	address_space_init_once(&inode->i_data);
 	i_size_ordered_init(inode);
 #ifdef CONFIG_INOTIFY
 	INIT_LIST_HEAD(&inode->inotify_watches);
diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index 84c2538..8dff317 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -34,19 +34,6 @@
 #include "btnode.h"
 
 
-void nilfs_btnode_cache_init_once(struct address_space *btnc)
-{
-	memset(btnc, 0, sizeof(*btnc));
-	INIT_RADIX_TREE(&btnc->page_tree, GFP_ATOMIC);
-	spin_lock_init(&btnc->tree_lock);
-	INIT_LIST_HEAD(&btnc->private_list);
-	spin_lock_init(&btnc->private_lock);
-
-	spin_lock_init(&btnc->i_mmap_lock);
-	INIT_RAW_PRIO_TREE_ROOT(&btnc->i_mmap);
-	INIT_LIST_HEAD(&btnc->i_mmap_nonlinear);
-}
-
 static const struct address_space_operations def_btnode_aops = {
 	.sync_page		= block_sync_page,
 };
diff --git a/fs/nilfs2/btnode.h b/fs/nilfs2/btnode.h
index 3e22751..067913e 100644
--- a/fs/nilfs2/btnode.h
+++ b/fs/nilfs2/btnode.h
@@ -37,7 +37,6 @@ struct nilfs_btnode_chkey_ctxt {
 	struct buffer_head *newbh;
 };
 
-void nilfs_btnode_cache_init_once(struct address_space *);
 void nilfs_btnode_cache_init(struct address_space *, struct backing_dev_info *);
 void nilfs_btnode_cache_clear(struct address_space *);
 int nilfs_btnode_submit_block(struct address_space *, __u64, sector_t,
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 63e7b10..93c11af 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -166,7 +166,7 @@ static void init_once(void *obj)
 #ifdef CONFIG_NILFS_XATTR
 	init_rwsem(&ii->xattr_sem);
 #endif
-	nilfs_btnode_cache_init_once(&ii->i_btnode_cache);
+	address_space_init_once(&ii->i_btnode_cache);
 	ii->i_bmap = (struct nilfs_bmap *)&ii->i_bmap_union;
 	inode_init_once(&ii->vfs_inode);
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1ff0962..1b9a47a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -635,6 +635,7 @@ struct address_space {
 	spinlock_t		private_lock;	/* for use by the address_space */
 	struct list_head	private_list;	/* ditto */
 	struct address_space	*assoc_mapping;	/* ditto */
+	struct mutex		unmap_mutex;    /* to protect unmapping */
 } __attribute__((aligned(sizeof(long))));
 	/*
 	 * On most architectures that alignment is already the case; but
@@ -2158,6 +2159,7 @@ extern loff_t vfs_llseek(struct file *file, loff_t offset, int origin);
 
 extern int inode_init_always(struct super_block *, struct inode *);
 extern void inode_init_once(struct inode *);
+extern void address_space_init_once(struct address_space *mapping);
 extern void inode_add_to_lists(struct super_block *, struct inode *);
 extern void iput(struct inode *);
 extern struct inode * igrab(struct inode *);
diff --git a/mm/memory.c b/mm/memory.c
index 53c1da0..6c836d3 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2454,6 +2454,7 @@ void unmap_mapping_range(struct address_space *mapping,
 		details.last_index = ULONG_MAX;
 	details.i_mmap_lock = &mapping->i_mmap_lock;
 
+	mutex_lock(&mapping->unmap_mutex);
 	spin_lock(&mapping->i_mmap_lock);
 
 	/* Protect against endless unmapping loops */
@@ -2470,6 +2471,7 @@ void unmap_mapping_range(struct address_space *mapping,
 	if (unlikely(!list_empty(&mapping->i_mmap_nonlinear)))
 		unmap_mapping_range_list(&mapping->i_mmap_nonlinear, &details);
 	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->unmap_mutex);
 }
 EXPORT_SYMBOL(unmap_mapping_range);
 
-- 
1.7.5.2

