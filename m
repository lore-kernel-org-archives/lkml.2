Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab1GIGBm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 02:01:42 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:50227 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754364Ab1GIGBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 02:01:39 -0400
X-Sasl-enc: 2O6Y3Ut/oydxysP9UDGDpEZ99IF5LIcuEId2nbMsh9Oj 1310191298
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Jul  8 16:01:13 2011
Message-Id: <20110708230113.061047772@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 08 Jul 2011 16:00:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Miklos Szeredi <mszeredi@suse.cz>, Hugh Dickins <hughd@google.com>
Subject: [35/35] mm: prevent concurrent unmap_mapping_range() on the same inode
In-Reply-To: <20110708230122.GA18807@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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

---
 fs/inode.c         |   22 +++++++++++++++-------
 fs/nilfs2/btnode.c |   13 -------------
 fs/nilfs2/btnode.h |    1 -
 fs/nilfs2/super.c  |    2 +-
 include/linux/fs.h |    2 ++
 mm/memory.c        |    2 ++
 6 files changed, 20 insertions(+), 22 deletions(-)

--- a/fs/inode.c
+++ b/fs/inode.c
@@ -246,6 +246,20 @@ void destroy_inode(struct inode *inode)
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
@@ -257,13 +271,7 @@ void inode_init_once(struct inode *inode
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
--- a/fs/nilfs2/btnode.h
+++ b/fs/nilfs2/btnode.h
@@ -37,7 +37,6 @@ struct nilfs_btnode_chkey_ctxt {
 	struct buffer_head *newbh;
 };
 
-void nilfs_btnode_cache_init_once(struct address_space *);
 void nilfs_btnode_cache_init(struct address_space *, struct backing_dev_info *);
 void nilfs_btnode_cache_clear(struct address_space *);
 struct buffer_head *nilfs_btnode_create_block(struct address_space *btnc,
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
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -637,6 +637,7 @@ struct address_space {
 	spinlock_t		private_lock;	/* for use by the address_space */
 	struct list_head	private_list;	/* ditto */
 	struct address_space	*assoc_mapping;	/* ditto */
+	struct mutex		unmap_mutex;    /* to protect unmapping */
 } __attribute__((aligned(sizeof(long))));
 	/*
 	 * On most architectures that alignment is already the case; but
@@ -2148,6 +2149,7 @@ extern loff_t vfs_llseek(struct file *fi
 
 extern int inode_init_always(struct super_block *, struct inode *);
 extern void inode_init_once(struct inode *);
+extern void address_space_init_once(struct address_space *mapping);
 extern void inode_add_to_lists(struct super_block *, struct inode *);
 extern void iput(struct inode *);
 extern struct inode * igrab(struct inode *);
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2459,6 +2459,7 @@ void unmap_mapping_range(struct address_
 		details.last_index = ULONG_MAX;
 	details.i_mmap_lock = &mapping->i_mmap_lock;
 
+	mutex_lock(&mapping->unmap_mutex);
 	spin_lock(&mapping->i_mmap_lock);
 
 	/* Protect against endless unmapping loops */
@@ -2475,6 +2476,7 @@ void unmap_mapping_range(struct address_
 	if (unlikely(!list_empty(&mapping->i_mmap_nonlinear)))
 		unmap_mapping_range_list(&mapping->i_mmap_nonlinear, &details);
 	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->unmap_mutex);
 }
 EXPORT_SYMBOL(unmap_mapping_range);
 


