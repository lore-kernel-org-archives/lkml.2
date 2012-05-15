Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965412Ab2EOCsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:48:31 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53422 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964876Ab2EOCRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:25 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 105/179] mm: prevent concurrent unmap_mapping_range() on the same inode
Date: Mon, 14 May 2012 22:13:21 -0400
Message-ID: <1337048075-6132-106-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
[PG: Some chunks dropped, since no ebdfed4dc5 in 34; came in at 2.6.37]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/gfs2/main.c     |    9 +--------
 fs/inode.c         |   22 +++++++++++++++-------
 fs/nilfs2/btnode.c |   14 --------------
 fs/nilfs2/btnode.h |    1 -
 fs/nilfs2/super.c  |    2 +-
 include/linux/fs.h |    2 ++
 mm/memory.c        |    2 ++
 7 files changed, 21 insertions(+), 31 deletions(-)

diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index a88fadc..79ebf86 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -58,14 +58,7 @@ static void gfs2_init_gl_aspace_once(void *foo)
 	struct address_space *mapping = (struct address_space *)(gl + 1);
 
 	gfs2_init_glock_once(gl);
-	memset(mapping, 0, sizeof(*mapping));
-	INIT_RADIX_TREE(&mapping->page_tree, GFP_ATOMIC);
-	spin_lock_init(&mapping->tree_lock);
-	spin_lock_init(&mapping->i_mmap_lock);
-	INIT_LIST_HEAD(&mapping->private_list);
-	spin_lock_init(&mapping->private_lock);
-	INIT_RAW_PRIO_TREE_ROOT(&mapping->i_mmap);
-	INIT_LIST_HEAD(&mapping->i_mmap_nonlinear);
+	address_space_init_once(mapping);
 }
 
 /**
diff --git a/fs/inode.c b/fs/inode.c
index 407bf39..f84377a 100644
--- a/fs/inode.c
+++ b/fs/inode.c
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
@@ -256,13 +270,7 @@ void inode_init_once(struct inode *inode)
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
index 447ce47..bebb9a9 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -34,20 +34,6 @@
 #include "page.h"
 #include "btnode.h"
 
-
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
index 07da83f..fa2f1e6 100644
--- a/fs/nilfs2/btnode.h
+++ b/fs/nilfs2/btnode.h
@@ -37,7 +37,6 @@ struct nilfs_btnode_chkey_ctxt {
 	struct buffer_head *newbh;
 };
 
-void nilfs_btnode_cache_init_once(struct address_space *);
 void nilfs_btnode_cache_init(struct address_space *, struct backing_dev_info *);
 void nilfs_btnode_cache_clear(struct address_space *);
 struct buffer_head *nilfs_btnode_create_block(struct address_space *btnc,
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index fadefe1..bce4109 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -163,7 +163,7 @@ static void init_once(void *obj)
 #ifdef CONFIG_NILFS_XATTR
 	init_rwsem(&ii->xattr_sem);
 #endif
-	nilfs_btnode_cache_init_once(&ii->i_btnode_cache);
+	address_space_init_once(&ii->i_btnode_cache);
 	ii->i_bmap = (struct nilfs_bmap *)&ii->i_bmap_union;
 	inode_init_once(&ii->vfs_inode);
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8aa6bd9..2e97c2c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -638,6 +638,7 @@ struct address_space {
 	spinlock_t		private_lock;	/* for use by the address_space */
 	struct list_head	private_list;	/* ditto */
 	struct address_space	*assoc_mapping;	/* ditto */
+	struct mutex		unmap_mutex;    /* to protect unmapping */
 } __attribute__((aligned(sizeof(long))));
 	/*
 	 * On most architectures that alignment is already the case; but
@@ -2145,6 +2146,7 @@ extern loff_t vfs_llseek(struct file *file, loff_t offset, int origin);
 
 extern int inode_init_always(struct super_block *, struct inode *);
 extern void inode_init_once(struct inode *);
+extern void address_space_init_once(struct address_space *mapping);
 extern void inode_add_to_lists(struct super_block *, struct inode *);
 extern void iput(struct inode *);
 extern struct inode * igrab(struct inode *);
diff --git a/mm/memory.c b/mm/memory.c
index 3410236..43dc216 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2564,6 +2564,7 @@ void unmap_mapping_range(struct address_space *mapping,
 		details.last_index = ULONG_MAX;
 	details.i_mmap_lock = &mapping->i_mmap_lock;
 
+	mutex_lock(&mapping->unmap_mutex);
 	spin_lock(&mapping->i_mmap_lock);
 
 	/* Protect against endless unmapping loops */
@@ -2580,6 +2581,7 @@ void unmap_mapping_range(struct address_space *mapping,
 	if (unlikely(!list_empty(&mapping->i_mmap_nonlinear)))
 		unmap_mapping_range_list(&mapping->i_mmap_nonlinear, &details);
 	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->unmap_mutex);
 }
 EXPORT_SYMBOL(unmap_mapping_range);
 
-- 
1.7.9.6

