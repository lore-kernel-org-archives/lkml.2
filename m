Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912Ab0JLPyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:54:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:40438 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932674Ab0JLPyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 11:54:10 -0400
Date: Tue, 12 Oct 2010 15:53:52 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, hch@lst.de,
        peterz@infradead.org, tglx@linutronix.de, viro@zeniv.linux.org.uk
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        hch@lst.de, peterz@infradead.org, tglx@linutronix.de,
        viro@zeniv.linux.org.uk
In-Reply-To: <20100907125056.416332114@linutronix.de>
References: <20100907125056.416332114@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] hfs: Convert tree_lock to mutex
Message-ID: <tip-4a9410355406c31695eab9daeba694d7d9714e9b@git.kernel.org>
Git-Commit-ID: 4a9410355406c31695eab9daeba694d7d9714e9b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 12 Oct 2010 15:53:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4a9410355406c31695eab9daeba694d7d9714e9b
Gitweb:     http://git.kernel.org/tip/4a9410355406c31695eab9daeba694d7d9714e9b
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 7 Sep 2010 14:33:08 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 12 Oct 2010 17:36:11 +0200

hfs: Convert tree_lock to mutex

tree_lock is used as mutex so make it a mutex.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
LKML-Reference: <20100907125056.416332114@linutronix.de>

---
 fs/hfs/bfind.c |    4 ++--
 fs/hfs/btree.c |    2 +-
 fs/hfs/btree.h |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/hfs/bfind.c b/fs/hfs/bfind.c
index 4129cdb..571abe9 100644
--- a/fs/hfs/bfind.c
+++ b/fs/hfs/bfind.c
@@ -23,7 +23,7 @@ int hfs_find_init(struct hfs_btree *tree, struct hfs_find_data *fd)
 	fd->search_key = ptr;
 	fd->key = ptr + tree->max_key_len + 2;
 	dprint(DBG_BNODE_REFS, "find_init: %d (%p)\n", tree->cnid, __builtin_return_address(0));
-	down(&tree->tree_lock);
+	mutex_lock(&tree->tree_lock);
 	return 0;
 }
 
@@ -32,7 +32,7 @@ void hfs_find_exit(struct hfs_find_data *fd)
 	hfs_bnode_put(fd->bnode);
 	kfree(fd->search_key);
 	dprint(DBG_BNODE_REFS, "find_exit: %d (%p)\n", fd->tree->cnid, __builtin_return_address(0));
-	up(&fd->tree->tree_lock);
+	mutex_unlock(&fd->tree->tree_lock);
 	fd->tree = NULL;
 }
 
diff --git a/fs/hfs/btree.c b/fs/hfs/btree.c
index 38a0a99..3ebc437 100644
--- a/fs/hfs/btree.c
+++ b/fs/hfs/btree.c
@@ -27,7 +27,7 @@ struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id, btree_keycmp ke
 	if (!tree)
 		return NULL;
 
-	init_MUTEX(&tree->tree_lock);
+	mutex_init(&tree->tree_lock);
 	spin_lock_init(&tree->hash_lock);
 	/* Set the correct compare function */
 	tree->sb = sb;
diff --git a/fs/hfs/btree.h b/fs/hfs/btree.h
index cc51905..2a1d712 100644
--- a/fs/hfs/btree.h
+++ b/fs/hfs/btree.h
@@ -33,7 +33,7 @@ struct hfs_btree {
 	unsigned int depth;
 
 	//unsigned int map1_size, map_size;
-	struct semaphore tree_lock;
+	struct mutex tree_lock;
 
 	unsigned int pages_per_bnode;
 	spinlock_t hash_lock;
