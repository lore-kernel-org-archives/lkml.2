Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab1G0Vws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:52:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:51521 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755755Ab1G0Vtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="32274963"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: mszeredi@suse.cz, gurudas.pai@oracle.com, hughd@google.com,
        torvalds@linux-foundation.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [95/99] mm: prevent concurrent unmap_mapping_range() on the same
Message-Id: <20110727214935.063242403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:49:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Miklos Szeredi <mszeredi@suse.cz>

commit 2aa15890f3c191326678f1bd68af61ec6b8753ec upstream.

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

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Reported-by: Michael Leun <lkml20101129@newton.leun.net>
Reported-by: Gurudas Pai <gurudas.pai@oracle.com>
Tested-by: Gurudas Pai <gurudas.pai@oracle.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/inode.c         |   22 +++++++++++++++-------
 fs/nilfs2/btnode.c |   13 -------------
 fs/nilfs2/btnode.h |    1 -
 fs/nilfs2/super.c  |    2 +-
 include/linux/fs.h |    2 ++
 mm/memory.c        |    2 ++
 6 files changed, 20 insertions(+), 22 deletions(-)

Index: linux-2.6.35.y/fs/inode.c
===================================================================
--- linux-2.6.35.y.orig/fs/inode.c
+++ linux-2.6.35.y/fs/inode.c
@@ -245,6 +245,20 @@ void destroy_inode(struct inode *inode)
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
@@ -256,13 +270,7 @@ void inode_init_once(struct inode *inode
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
Index: linux-2.6.35.y/fs/nilfs2/btnode.c
===================================================================
--- linux-2.6.35.y.orig/fs/nilfs2/btnode.c
+++ linux-2.6.35.y/fs/nilfs2/btnode.c
@@ -35,19 +35,6 @@
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
Index: linux-2.6.35.y/fs/nilfs2/btnode.h
===================================================================
--- linux-2.6.35.y.orig/fs/nilfs2/btnode.h
+++ linux-2.6.35.y/fs/nilfs2/btnode.h
@@ -37,7 +37,6 @@ struct nilfs_btnode_chkey_ctxt {
 	struct buffer_head *newbh;
 };
 
-void nilfs_btnode_cache_init_once(struct address_space *);
 void nilfs_btnode_cache_init(struct address_space *, struct backing_dev_info *);
 void nilfs_btnode_cache_clear(struct address_space *);
 struct buffer_head *nilfs_btnode_create_block(struct address_space *btnc,
Index: linux-2.6.35.y/fs/nilfs2/super.c
===================================================================
--- linux-2.6.35.y.orig/fs/nilfs2/super.c
+++ linux-2.6.35.y/fs/nilfs2/super.c
@@ -1120,7 +1120,7 @@ static void nilfs_inode_init_once(void *
 #ifdef CONFIG_NILFS_XATTR
 	init_rwsem(&ii->xattr_sem);
 #endif
-	nilfs_btnode_cache_init_once(&ii->i_btnode_cache);
+	address_space_init_once(&ii->i_btnode_cache);
 	ii->i_bmap = (struct nilfs_bmap *)&ii->i_bmap_union;
 	inode_init_once(&ii->vfs_inode);
 }
Index: linux-2.6.35.y/include/linux/fs.h
===================================================================
--- linux-2.6.35.y.orig/include/linux/fs.h
+++ linux-2.6.35.y/include/linux/fs.h
@@ -639,6 +639,7 @@ struct address_space {
 	spinlock_t		private_lock;	/* for use by the address_space */
 	struct list_head	private_list;	/* ditto */
 	struct address_space	*assoc_mapping;	/* ditto */
+	struct mutex		unmap_mutex;    /* to protect unmapping */
 } __attribute__((aligned(sizeof(long))));
 	/*
 	 * On most architectures that alignment is already the case; but
@@ -2160,6 +2161,7 @@ extern loff_t vfs_llseek(struct file *fi
 
 extern int inode_init_always(struct super_block *, struct inode *);
 extern void inode_init_once(struct inode *);
+extern void address_space_init_once(struct address_space *mapping);
 extern void inode_add_to_lists(struct super_block *, struct inode *);
 extern void iput(struct inode *);
 extern struct inode * igrab(struct inode *);
Index: linux-2.6.35.y/mm/memory.c
===================================================================
--- linux-2.6.35.y.orig/mm/memory.c
+++ linux-2.6.35.y/mm/memory.c
@@ -2573,6 +2573,7 @@ void unmap_mapping_range(struct address_
 		details.last_index = ULONG_MAX;
 	details.i_mmap_lock = &mapping->i_mmap_lock;
 
+	mutex_lock(&mapping->unmap_mutex);
 	spin_lock(&mapping->i_mmap_lock);
 
 	/* Protect against endless unmapping loops */
@@ -2589,6 +2590,7 @@ void unmap_mapping_range(struct address_
 	if (unlikely(!list_empty(&mapping->i_mmap_nonlinear)))
 		unmap_mapping_range_list(&mapping->i_mmap_nonlinear, &details);
 	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->unmap_mutex);
 }
 EXPORT_SYMBOL(unmap_mapping_range);
 
