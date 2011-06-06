Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab1FFEY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 00:24:56 -0400
Received: from smtp-out.google.com ([74.125.121.67]:21140 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab1FFEYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 00:24:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=LoD5T0N2w9hXWg5TrHAd0D2CEdcDZ7295LuOXHB9sIKJJ2C7v7962FmHVHPyUCc0Sb
         ucKdPY+1y3dr/b6z7Bfw==
Date: Sun, 5 Jun 2011 21:24:53 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 2/14] mm: move shmem prototypes to shmem_fs.h
In-Reply-To: <alpine.LSU.2.00.1106052116350.17116@sister.anvils>
Message-ID: <alpine.LSU.2.00.1106052123310.17116@sister.anvils>
References: <alpine.LSU.2.00.1106052116350.17116@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before adding any more global entry points into shmem.c, gather such
prototypes into shmem_fs.h.  Remove mm's own declarations from swap.h,
but for now leave the ones in mm.h: because shmem_file_setup() and
shmem_zero_setup() are called from various places, and we should not
force other subsystems to update immediately.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
---
 include/linux/shmem_fs.h |   17 +++++++++++++++++
 include/linux/swap.h     |   10 ----------
 mm/memcontrol.c          |    1 +
 mm/swapfile.c            |    2 +-
 4 files changed, 19 insertions(+), 11 deletions(-)

--- linux.orig/include/linux/shmem_fs.h	2011-06-05 17:16:33.313740660 -0700
+++ linux/include/linux/shmem_fs.h	2011-06-05 17:38:03.100136227 -0700
@@ -5,6 +5,13 @@
 #include <linux/mempolicy.h>
 #include <linux/percpu_counter.h>
 
+struct page;
+struct file;
+struct inode;
+struct super_block;
+struct user_struct;
+struct vm_area_struct;
+
 /* inode in-kernel data */
 
 #define SHMEM_NR_DIRECT 16
@@ -45,7 +52,17 @@ static inline struct shmem_inode_info *S
 	return container_of(inode, struct shmem_inode_info, vfs_inode);
 }
 
+/*
+ * Functions in mm/shmem.c called directly from elsewhere:
+ */
 extern int init_tmpfs(void);
 extern int shmem_fill_super(struct super_block *sb, void *data, int silent);
+extern struct file *shmem_file_setup(const char *name,
+					loff_t size, unsigned long flags);
+extern int shmem_zero_setup(struct vm_area_struct *);
+extern int shmem_lock(struct file *file, int lock, struct user_struct *user);
+extern int shmem_unuse(swp_entry_t entry, struct page *page);
+extern void mem_cgroup_get_shmem_target(struct inode *inode, pgoff_t pgoff,
+					struct page **pagep, swp_entry_t *ent);
 
 #endif
--- linux.orig/include/linux/swap.h	2011-06-05 17:16:33.317740677 -0700
+++ linux/include/linux/swap.h	2011-06-05 17:25:19.748351090 -0700
@@ -300,16 +300,6 @@ static inline void scan_unevictable_unre
 extern int kswapd_run(int nid);
 extern void kswapd_stop(int nid);
 
-#ifdef CONFIG_MMU
-/* linux/mm/shmem.c */
-extern int shmem_unuse(swp_entry_t entry, struct page *page);
-#endif /* CONFIG_MMU */
-
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
-extern void mem_cgroup_get_shmem_target(struct inode *inode, pgoff_t pgoff,
-					struct page **pagep, swp_entry_t *ent);
-#endif
-
 #ifdef CONFIG_SWAP
 /* linux/mm/page_io.c */
 extern int swap_readpage(struct page *);
--- linux.orig/mm/memcontrol.c	2011-06-05 17:16:33.317740677 -0700
+++ linux/mm/memcontrol.c	2011-06-05 17:25:19.748351090 -0700
@@ -35,6 +35,7 @@
 #include <linux/limits.h>
 #include <linux/mutex.h>
 #include <linux/rbtree.h>
+#include <linux/shmem_fs.h>
 #include <linux/slab.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
--- linux.orig/mm/swapfile.c	2011-06-05 17:16:33.317740677 -0700
+++ linux/mm/swapfile.c	2011-06-05 17:25:19.748351090 -0700
@@ -14,7 +14,7 @@
 #include <linux/vmalloc.h>
 #include <linux/pagemap.h>
 #include <linux/namei.h>
-#include <linux/shm.h>
+#include <linux/shmem_fs.h>
 #include <linux/blkdev.h>
 #include <linux/random.h>
 #include <linux/writeback.h>
