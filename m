Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab0L2UJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 15:09:42 -0500
Received: from smtp-out.google.com ([74.125.121.67]:14484 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab0L2UJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 15:09:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=BHDmseKMNnSVGVGYahkIxUE7PF32DrXjJCG4R8eizd20Q5GobtB46otvRO2YflTu4J
         HDoQrS5pIreFFH1NwxVg==
Date: Wed, 29 Dec 2010 12:09:29 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Gurudas Pai <gurudas.pai@oracle.com>
cc: Miklos Szeredi <miklos@szeredi.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] kernel BUG at mm/truncate.c:479! on 2.6.37-rc8
In-Reply-To: <4D1AD935.1020504@oracle.com>
Message-ID: <alpine.LSU.2.00.1012291137080.6381@sister.anvils>
References: <4D1AD935.1020504@oracle.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Dec 2010, Gurudas Pai wrote:
> 
> With 2.6.37-rc8 , run a fio test over nfs, with following jobfile, and we
> hit kernel bug.

Have you tried the same test on earlier releases?
I think the bug is old, yet only recently reported.

> 
> [global]
> bs=8k
> iodepth=1024
> iodepth_batch=60
> randrepeat=1
> size=80000m
> numjobs=2
> directory=/mnt
> [job3]
> ioengine=mmap
> rw=randrw
> filename=file1:file2
> [job5]
> ioengine=sync
> rw=randrw
> filename=file1:file2
> 
> 
> my-fileserver:/vol/vol1 on /mnt type nfs
> (rw,bg,hard,nointr,tcp,nfsvers=3,timeo=600,rsize=32768,wsize=32768)
> 
> 
> ------------[ cut here ]------------
> kernel BUG at mm/truncate.c:479!
> Pid: 2820, comm: fio Not tainted 2.6.37-rc8 #1 /ProLiant DL585 G1
> RIP: 0010:[<ffffffff810d635f>]  [<ffffffff810d635f>]
> invalidate_inode_pages2_range+0x126/0x288
> Call Trace:
>  [<ffffffff810d64d5>] invalidate_inode_pages2+0x14/0x16
>  [<ffffffffa035e337>] nfs_revalidate_mapping+0x7d/0x11b [nfs]
>  [<ffffffffa035bd91>] nfs_file_read+0x9c/0xdc [nfs]
>  [<ffffffff8110ed2f>] do_sync_read+0xc7/0x10b
>  [<ffffffff8110f57f>] vfs_read+0xad/0x105
>  [<ffffffff8110f84d>] sys_read+0x4c/0x70
>  [<ffffffff8100ac42>] system_call_fastpath+0x16/0x1b

This NFS-triggered kernel BUG at mm/truncate.c:479 sounds very like
the FUSE-triggered kernel BUG at mm/truncate.c:475 on 2.6.36.1 for
which Miklos posted a patch on 14 December.  Please give his patch
(below) a try and let us know if it fixes the issue for you - thanks.

There's another of these page_mapped truncation BUGs outstanding,
that we suspect has a different cause: yours doesn't sound like that
one.  I can't explain why three people now in the space of one month
should at last hit these ancient bugs!

Hugh

---
 fs/gfs2/main.c     |    9 +--------
 fs/inode.c         |   22 +++++++++++++++-------
 fs/nilfs2/btnode.c |    5 -----
 fs/nilfs2/btnode.h |    1 -
 fs/nilfs2/mdt.c    |    4 ++--
 fs/nilfs2/page.c   |   13 -------------
 fs/nilfs2/page.h   |    1 -
 fs/nilfs2/super.c  |    2 +-
 include/linux/fs.h |    2 ++
 mm/memory.c        |    2 ++
 10 files changed, 23 insertions(+), 38 deletions(-)

Index: linux.git/mm/memory.c
===================================================================
--- linux.git.orig/mm/memory.c	2010-12-11 14:09:55.000000000 +0100
+++ linux.git/mm/memory.c	2010-12-14 11:20:47.000000000 +0100
@@ -2572,6 +2572,7 @@ void unmap_mapping_range(struct address_
 		details.last_index = ULONG_MAX;
 	details.i_mmap_lock = &mapping->i_mmap_lock;
 
+	mutex_lock(&mapping->unmap_mutex);
 	spin_lock(&mapping->i_mmap_lock);
 
 	/* Protect against endless unmapping loops */
@@ -2588,6 +2589,7 @@ void unmap_mapping_range(struct address_
 	if (unlikely(!list_empty(&mapping->i_mmap_nonlinear)))
 		unmap_mapping_range_list(&mapping->i_mmap_nonlinear, &details);
 	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->unmap_mutex);
 }
 EXPORT_SYMBOL(unmap_mapping_range);
 
Index: linux.git/fs/gfs2/main.c
===================================================================
--- linux.git.orig/fs/gfs2/main.c	2010-11-26 10:52:16.000000000 +0100
+++ linux.git/fs/gfs2/main.c	2010-12-14 11:15:53.000000000 +0100
@@ -59,14 +59,7 @@ static void gfs2_init_gl_aspace_once(voi
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
Index: linux.git/fs/inode.c
===================================================================
--- linux.git.orig/fs/inode.c	2010-11-26 10:52:16.000000000 +0100
+++ linux.git/fs/inode.c	2010-12-14 11:21:49.000000000 +0100
@@ -280,6 +280,20 @@ static void destroy_inode(struct inode *
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
@@ -293,13 +307,7 @@ void inode_init_once(struct inode *inode
 	INIT_LIST_HEAD(&inode->i_devices);
 	INIT_LIST_HEAD(&inode->i_wb_list);
 	INIT_LIST_HEAD(&inode->i_lru);
-	INIT_RADIX_TREE(&inode->i_data.page_tree, GFP_ATOMIC);
-	spin_lock_init(&inode->i_data.tree_lock);
-	spin_lock_init(&inode->i_data.i_mmap_lock);
-	INIT_LIST_HEAD(&inode->i_data.private_list);
-	spin_lock_init(&inode->i_data.private_lock);
-	INIT_RAW_PRIO_TREE_ROOT(&inode->i_data.i_mmap);
-	INIT_LIST_HEAD(&inode->i_data.i_mmap_nonlinear);
+	address_space_init_once(&inode->i_data);
 	i_size_ordered_init(inode);
 #ifdef CONFIG_FSNOTIFY
 	INIT_HLIST_HEAD(&inode->i_fsnotify_marks);
Index: linux.git/fs/nilfs2/btnode.c
===================================================================
--- linux.git.orig/fs/nilfs2/btnode.c	2010-11-26 10:52:17.000000000 +0100
+++ linux.git/fs/nilfs2/btnode.c	2010-12-14 11:19:52.000000000 +0100
@@ -35,11 +35,6 @@
 #include "btnode.h"
 
 
-void nilfs_btnode_cache_init_once(struct address_space *btnc)
-{
-	nilfs_mapping_init_once(btnc);
-}
-
 static const struct address_space_operations def_btnode_aops = {
 	.sync_page		= block_sync_page,
 };
Index: linux.git/fs/nilfs2/btnode.h
===================================================================
--- linux.git.orig/fs/nilfs2/btnode.h	2010-10-05 18:49:12.000000000 +0200
+++ linux.git/fs/nilfs2/btnode.h	2010-12-14 11:20:01.000000000 +0100
@@ -37,7 +37,6 @@ struct nilfs_btnode_chkey_ctxt {
 	struct buffer_head *newbh;
 };
 
-void nilfs_btnode_cache_init_once(struct address_space *);
 void nilfs_btnode_cache_init(struct address_space *, struct backing_dev_info *);
 void nilfs_btnode_cache_clear(struct address_space *);
 struct buffer_head *nilfs_btnode_create_block(struct address_space *btnc,
Index: linux.git/fs/nilfs2/mdt.c
===================================================================
--- linux.git.orig/fs/nilfs2/mdt.c	2010-11-26 10:52:17.000000000 +0100
+++ linux.git/fs/nilfs2/mdt.c	2010-12-14 11:18:18.000000000 +0100
@@ -460,9 +460,9 @@ int nilfs_mdt_setup_shadow_map(struct in
 	struct backing_dev_info *bdi = inode->i_sb->s_bdi;
 
 	INIT_LIST_HEAD(&shadow->frozen_buffers);
-	nilfs_mapping_init_once(&shadow->frozen_data);
+	address_space_init_once(&shadow->frozen_data);
 	nilfs_mapping_init(&shadow->frozen_data, bdi, &shadow_map_aops);
-	nilfs_mapping_init_once(&shadow->frozen_btnodes);
+	address_space_init_once(&shadow->frozen_btnodes);
 	nilfs_mapping_init(&shadow->frozen_btnodes, bdi, &shadow_map_aops);
 	mi->mi_shadow = shadow;
 	return 0;
Index: linux.git/fs/nilfs2/page.c
===================================================================
--- linux.git.orig/fs/nilfs2/page.c	2010-11-26 10:52:17.000000000 +0100
+++ linux.git/fs/nilfs2/page.c	2010-12-14 11:17:26.000000000 +0100
@@ -492,19 +492,6 @@ unsigned nilfs_page_count_clean_buffers(
 	return nc;
 }
  
-void nilfs_mapping_init_once(struct address_space *mapping)
-{
-	memset(mapping, 0, sizeof(*mapping));
-	INIT_RADIX_TREE(&mapping->page_tree, GFP_ATOMIC);
-	spin_lock_init(&mapping->tree_lock);
-	INIT_LIST_HEAD(&mapping->private_list);
-	spin_lock_init(&mapping->private_lock);
-
-	spin_lock_init(&mapping->i_mmap_lock);
-	INIT_RAW_PRIO_TREE_ROOT(&mapping->i_mmap);
-	INIT_LIST_HEAD(&mapping->i_mmap_nonlinear);
-}
-
 void nilfs_mapping_init(struct address_space *mapping,
 			struct backing_dev_info *bdi,
 			const struct address_space_operations *aops)
Index: linux.git/fs/nilfs2/page.h
===================================================================
--- linux.git.orig/fs/nilfs2/page.h	2010-11-26 10:52:17.000000000 +0100
+++ linux.git/fs/nilfs2/page.h	2010-12-14 11:17:35.000000000 +0100
@@ -61,7 +61,6 @@ void nilfs_free_private_page(struct page
 int nilfs_copy_dirty_pages(struct address_space *, struct address_space *);
 void nilfs_copy_back_pages(struct address_space *, struct address_space *);
 void nilfs_clear_dirty_pages(struct address_space *);
-void nilfs_mapping_init_once(struct address_space *mapping);
 void nilfs_mapping_init(struct address_space *mapping,
 			struct backing_dev_info *bdi,
 			const struct address_space_operations *aops);
Index: linux.git/fs/nilfs2/super.c
===================================================================
--- linux.git.orig/fs/nilfs2/super.c	2010-11-26 10:52:17.000000000 +0100
+++ linux.git/fs/nilfs2/super.c	2010-12-14 11:20:19.000000000 +0100
@@ -1262,7 +1262,7 @@ static void nilfs_inode_init_once(void *
 #ifdef CONFIG_NILFS_XATTR
 	init_rwsem(&ii->xattr_sem);
 #endif
-	nilfs_btnode_cache_init_once(&ii->i_btnode_cache);
+	address_space_init_once(&ii->i_btnode_cache);
 	ii->i_bmap = &ii->i_bmap_data;
 	inode_init_once(&ii->vfs_inode);
 }
Index: linux.git/include/linux/fs.h
===================================================================
--- linux.git.orig/include/linux/fs.h	2010-12-07 20:17:55.000000000 +0100
+++ linux.git/include/linux/fs.h	2010-12-14 11:21:30.000000000 +0100
@@ -645,6 +645,7 @@ struct address_space {
 	spinlock_t		private_lock;	/* for use by the address_space */
 	struct list_head	private_list;	/* ditto */
 	struct address_space	*assoc_mapping;	/* ditto */
+	struct mutex		unmap_mutex;    /* to protect unmapping */
 } __attribute__((aligned(sizeof(long))));
 	/*
 	 * On most architectures that alignment is already the case; but
@@ -2205,6 +2206,7 @@ extern loff_t vfs_llseek(struct file *fi
 
 extern int inode_init_always(struct super_block *, struct inode *);
 extern void inode_init_once(struct inode *);
+extern void address_space_init_once(struct address_space *mapping);
 extern void ihold(struct inode * inode);
 extern void iput(struct inode *);
 extern struct inode * igrab(struct inode *);
