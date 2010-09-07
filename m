Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274Ab0IGOeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:34:09 -0400
Received: from www.tglx.de ([62.245.132.106]:43921 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932114Ab0IGOdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:33:52 -0400
Message-Id: <20100907125056.323550324@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 14:33:00 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: [patch 17/30] hpfsplus: Convert tree_lock to mutex
References: <20100907124636.880953480@linutronix.de>
Content-Disposition: inline; filename=hpfs-plus-sema-to-mutex.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tree_lock is used as mutex so make it a mutex.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org

---
 fs/hfsplus/bfind.c      |    4 ++--
 fs/hfsplus/btree.c      |    2 +-
 fs/hfsplus/hfsplus_fs.h |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/fs/hfsplus/bfind.c
===================================================================
--- linux-2.6.orig/fs/hfsplus/bfind.c
+++ linux-2.6/fs/hfsplus/bfind.c
@@ -23,7 +23,7 @@ int hfs_find_init(struct hfs_btree *tree
 	fd->search_key = ptr;
 	fd->key = ptr + tree->max_key_len + 2;
 	dprint(DBG_BNODE_REFS, "find_init: %d (%p)\n", tree->cnid, __builtin_return_address(0));
-	down(&tree->tree_lock);
+	mutex_lock(&tree->tree_lock);
 	return 0;
 }
 
@@ -32,7 +32,7 @@ void hfs_find_exit(struct hfs_find_data 
 	hfs_bnode_put(fd->bnode);
 	kfree(fd->search_key);
 	dprint(DBG_BNODE_REFS, "find_exit: %d (%p)\n", fd->tree->cnid, __builtin_return_address(0));
-	up(&fd->tree->tree_lock);
+	mutex_unlock(&fd->tree->tree_lock);
 	fd->tree = NULL;
 }
 
Index: linux-2.6/fs/hfsplus/btree.c
===================================================================
--- linux-2.6.orig/fs/hfsplus/btree.c
+++ linux-2.6/fs/hfsplus/btree.c
@@ -30,7 +30,7 @@ struct hfs_btree *hfs_btree_open(struct 
 	if (!tree)
 		return NULL;
 
-	init_MUTEX(&tree->tree_lock);
+	mutex_init(&tree->tree_lock);
 	spin_lock_init(&tree->hash_lock);
 	tree->sb = sb;
 	tree->cnid = id;
Index: linux-2.6/fs/hfsplus/hfsplus_fs.h
===================================================================
--- linux-2.6.orig/fs/hfsplus/hfsplus_fs.h
+++ linux-2.6/fs/hfsplus/hfsplus_fs.h
@@ -62,7 +62,7 @@ struct hfs_btree {
 	unsigned int depth;
 
 	//unsigned int map1_size, map_size;
-	struct semaphore tree_lock;
+	struct mutex tree_lock;
 
 	unsigned int pages_per_bnode;
 	spinlock_t hash_lock;


