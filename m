Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab2HRVj0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 17:39:26 -0400
Received: from mail.nonattached.net ([193.160.39.60]:53391 "EHLO
	mail.nonattached.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab2HRVjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 17:39:20 -0400
From: Dan Luedtke <mail@danrl.de>
To: linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, mail@danrl.de, akpm@linux-foundation.org,
        chaosman@ontika.net, muthur@gmail.com, kerolasa@iki.fi,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fs: Introducing Lanyard Filesystem
Date: Sun, 19 Aug 2012 01:38:37 +0200
Message-Id: <1345333117-2826-1-git-send-email-mail@danrl.de>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the Lanyard Filesystem (LanyFS), a filesystem
for highly mobile and removable storage devices.

Signed-off-by: Dan Luedtke <mail@danrl.de>
---
"Release early, release often" they said. Here is my work of the
past weeks. This is a RFC patch, so please comment, criticize, suggest
and test test test. Of course patches are welcome, too.

LanyFS specification and further documentation as long as essential
filesystem utilities can be found at https://www.nonattached.net/lanyfs/

  Dan
---
 fs/Kconfig             |    1 +
 fs/Makefile            |    5 +-
 fs/lanyfs/Kconfig      |   19 ++
 fs/lanyfs/Makefile     |   12 +
 fs/lanyfs/btree.c      |  405 +++++++++++++++++++++++++++++++++++
 fs/lanyfs/chain.c      |  173 +++++++++++++++
 fs/lanyfs/dir.c        |  393 ++++++++++++++++++++++++++++++++++
 fs/lanyfs/extender.c   |  352 +++++++++++++++++++++++++++++++
 fs/lanyfs/file.c       |  114 ++++++++++
 fs/lanyfs/icache.c     |  113 ++++++++++
 fs/lanyfs/inode.c      |  357 +++++++++++++++++++++++++++++++
 fs/lanyfs/lanyfs_km.c  |   60 ++++++
 fs/lanyfs/lanyfs_km.h  |  234 ++++++++++++++++++++
 fs/lanyfs/lanyfs_lnx.h |  306 +++++++++++++++++++++++++++
 fs/lanyfs/misc.c       |  129 +++++++++++
 fs/lanyfs/msg.c        |   99 +++++++++
 fs/lanyfs/super.c      |  549 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/magic.h  |    1 +
 18 files changed, 3320 insertions(+), 2 deletions(-)
 create mode 100644 fs/lanyfs/Kconfig
 create mode 100644 fs/lanyfs/Makefile
 create mode 100644 fs/lanyfs/btree.c
 create mode 100644 fs/lanyfs/chain.c
 create mode 100644 fs/lanyfs/dir.c
 create mode 100644 fs/lanyfs/extender.c
 create mode 100644 fs/lanyfs/file.c
 create mode 100644 fs/lanyfs/icache.c
 create mode 100644 fs/lanyfs/inode.c
 create mode 100644 fs/lanyfs/lanyfs_km.c
 create mode 100644 fs/lanyfs/lanyfs_km.h
 create mode 100644 fs/lanyfs/lanyfs_lnx.h
 create mode 100644 fs/lanyfs/misc.c
 create mode 100644 fs/lanyfs/msg.c
 create mode 100644 fs/lanyfs/super.c

diff --git a/fs/Kconfig b/fs/Kconfig
index f95ae3a..4001e30 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -206,6 +206,7 @@ source "fs/efs/Kconfig"
 source "fs/jffs2/Kconfig"
 # UBIFS File system configuration
 source "fs/ubifs/Kconfig"
+source "fs/lanyfs/Kconfig"
 source "fs/logfs/Kconfig"
 source "fs/cramfs/Kconfig"
 source "fs/squashfs/Kconfig"
diff --git a/fs/Makefile b/fs/Makefile
index 2fb9779..31f0642 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -3,7 +3,7 @@
 #
 # 14 Sep 2000, Christoph Hellwig <hch@infradead.org>
 # Rewritten to use lists instead of if-statements.
-# 
+#
 
 obj-y :=	open.o read_write.o file_table.o super.o \
 		char_dev.o stat.o exec.o pipe.o namei.o fcntl.o \
@@ -60,7 +60,7 @@ obj-y				+= devpts/
 
 obj-$(CONFIG_PROFILING)		+= dcookies.o
 obj-$(CONFIG_DLM)		+= dlm/
- 
+
 # Do not add any filesystems before this line
 obj-$(CONFIG_FSCACHE)		+= fscache/
 obj-$(CONFIG_REISERFS_FS)	+= reiserfs/
@@ -97,6 +97,7 @@ obj-$(CONFIG_NTFS_FS)		+= ntfs/
 obj-$(CONFIG_UFS_FS)		+= ufs/
 obj-$(CONFIG_EFS_FS)		+= efs/
 obj-$(CONFIG_JFFS2_FS)		+= jffs2/
+obj-$(CONFIG_LANYFS_FS)		+= lanyfs/
 obj-$(CONFIG_LOGFS)		+= logfs/
 obj-$(CONFIG_UBIFS_FS)		+= ubifs/
 obj-$(CONFIG_AFFS_FS)		+= affs/
diff --git a/fs/lanyfs/Kconfig b/fs/lanyfs/Kconfig
new file mode 100644
index 0000000..f4307bf
--- /dev/null
+++ b/fs/lanyfs/Kconfig
@@ -0,0 +1,19 @@
+config LANYFS_FS
+	tristate "Lanyard file system (LanyFS) (EXPERIMENTAL)"
+	help
+	  The lanyard file system (LanyFS) is designed for removable storage
+	  devices, particularly those small gadgets one would carry around
+	  using a lanyard.
+
+	  LanyFS is highly experimental.
+
+	  If unsure, say N.
+
+config LANYFS_DEBUG
+	bool "LanyFS debugging support"
+	depends on LANYFS_FS
+	help
+	  Enables debugging for the lanyard file system (LanyFS).
+
+	  Selecting Y will produce a lot of kernel messages and it will slow
+	  down the system while accessing LanyFS-formatted devices.
diff --git a/fs/lanyfs/Makefile b/fs/lanyfs/Makefile
new file mode 100644
index 0000000..f7adf51
--- /dev/null
+++ b/fs/lanyfs/Makefile
@@ -0,0 +1,12 @@
+#
+# Makefile for the linux lanyard filesystem routines.
+#
+
+obj-$(CONFIG_LANYFS_FS) += lanyfs.o
+
+lanyfs-y := msg.o misc.o icache.o inode.o \
+	    btree.o dir.o extender.o file.o \
+	    chain.o super.o lanyfs_km.o
+
+ccflags-$(CONFIG_LANYFS_DEBUG) += -DLANYFS_DEBUG
+
diff --git a/fs/lanyfs/btree.c b/fs/lanyfs/btree.c
new file mode 100644
index 0000000..024f48d
--- /dev/null
+++ b/fs/lanyfs/btree.c
@@ -0,0 +1,405 @@
+/*
+ * btree.c - Lanyard Filesystem Binary Tree Operations
+ *
+ * Copyright (C) 2012  Dan Luedtke <mail@danrl.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ */
+
+#include "lanyfs_km.h"
+
+/**
+ * lanyfs_btree_any_link() - Returns left or right link of an inode.
+ * @inode:			inode
+ *
+ * Left link will be preferred, returns 0 if no link is found.
+ */
+static lanyfs_blk_t lanyfs_btree_any_link(struct inode *inode)
+{
+	struct lanyfs_lii *lii;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	lii = LANYFS_I(inode);
+	if (lii->left)
+		return lii->left;
+	else
+		return lii->right;
+}
+
+/**
+ * lanyfs_btree_set_left() - Sets left link of inode to given address.
+ * @inode:			inode
+ * @addr:			new target address of link
+ */
+static void lanyfs_btree_set_left(struct inode *inode, lanyfs_blk_t addr)
+{
+	struct lanyfs_lii *lii;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	lii = LANYFS_I(inode);
+	spin_lock(&lii->lock);
+	lii->left = addr;
+	spin_unlock(&lii->lock);
+	mark_inode_dirty(inode);
+}
+
+/**
+ * lanyfs_btree_set_right() - Sets right link of inode to given address.
+ * @inode:			inode
+ * @addr:			new target address of link
+ */
+static void lanyfs_btree_set_right(struct inode *inode, lanyfs_blk_t addr)
+{
+	struct lanyfs_lii *lii;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	lii = LANYFS_I(inode);
+	spin_lock(&lii->lock);
+	lii->right = addr;
+	spin_unlock(&lii->lock);
+	mark_inode_dirty(inode);
+}
+
+/**
+ * lanyfs_btree_rpl_link() - Replaces a link of an inode.
+ * @inode:			inode
+ * @old:			link to be replaced
+ * @new:			replacement
+ *
+ * Only one link will be replaced even if both links match @old. Left link
+ * is always preferred.
+ */
+static void lanyfs_btree_rpl_link(struct inode *inode, lanyfs_blk_t old,
+				   lanyfs_blk_t new)
+{
+	struct lanyfs_lii *lii;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	lii = LANYFS_I(inode);
+	if (lii->left == old) {
+		spin_lock(&lii->lock);
+		lii->left = new;
+		spin_unlock(&lii->lock);
+	} else if (lii->right == old) {
+		spin_lock(&lii->lock);
+		lii->right = new;
+		spin_unlock(&lii->lock);
+	}
+	mark_inode_dirty(inode);
+}
+
+/**
+ * lanyfs_btree_set_subtree() - Sets subtree of a directory.
+ * @dir:			directory to modify
+ * @addr:			new address for subtree
+ */
+static void lanyfs_btree_set_subtree(struct inode *dir, lanyfs_blk_t addr)
+{
+	struct lanyfs_lii *lii;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	lii = LANYFS_I(dir);
+	spin_lock(&lii->lock);
+	lii->subtree = addr;
+	spin_unlock(&lii->lock);
+	mark_inode_dirty(dir);
+}
+
+/**
+ * __lanyfs_btree_add_inode() - Adds an inode to a binary tree.
+ * @cur:			current inode
+ * @rookie:			inode to be added
+ *
+ * This function is internal and is best be called by its wrapper function.
+ */
+static int __lanyfs_btree_add_inode(struct inode *cur, struct inode *rookie)
+{
+	struct lanyfs_lii *lii_cur;
+	struct lanyfs_lii *lii_rki;
+	struct inode *tmp;
+	int cmp;
+	int ret;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	lii_cur = LANYFS_I(cur);
+	lii_rki = LANYFS_I(rookie);
+	cmp = strncmp(lii_cur->name, lii_rki->name, LANYFS_NAME_LENGTH);
+
+	/* insert node or dig deeper if necessary */
+	ret = 0;
+	if (cmp < 0) {
+		if (lii_cur->left) {
+			tmp = lanyfs_iget(cur->i_sb, lii_cur->left);
+			if (!tmp)
+				return -EINVAL;
+			ret = __lanyfs_btree_add_inode(tmp, rookie);
+			iput(tmp);
+		} else {
+			lanyfs_btree_set_left(cur, rookie->i_ino);
+		}
+	} else if (cmp > 0) {
+		if (lii_cur->right) {
+			tmp = lanyfs_iget(cur->i_sb, lii_cur->right);
+			if (!tmp)
+				return -EINVAL;
+			ret = __lanyfs_btree_add_inode(tmp, rookie);
+			iput(tmp);
+		} else {
+			lanyfs_btree_set_right(cur, rookie->i_ino);
+		}
+	} else {
+		ret = -EEXIST;
+	}
+	return ret;
+}
+
+/**
+ * lanyfs_btree_add_inode() - Adds an inode to a binary tree.
+ * @dir:			directory to insert inode into
+ * @rookie:			inode to be added
+ */
+int lanyfs_btree_add_inode(struct inode *dir, struct inode *rookie)
+{
+	struct lanyfs_lii *lii;
+	struct inode *root;
+	int ret;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	lii = LANYFS_I(dir);
+	ret = 0;
+	if (lii->subtree) {
+		ret = -EINVAL;
+		root = lanyfs_iget(dir->i_sb, lii->subtree);
+		if (root) {
+			ret = __lanyfs_btree_add_inode(root, rookie);
+			iput(root);
+		}
+	} else {
+		lanyfs_btree_set_subtree(dir, rookie->i_ino);
+	}
+	return ret;
+}
+
+/**
+ * __lanyfs_btree_del_inode() - Removes an inode from a binary tree.
+ * @dir:			directory containing the tree
+ * @par:			parent inode of @cur in tree
+ * @cur:			node to be tested for liquidation
+ * @name:			directory or file name of inode to be removed
+ *
+ * This function is internal and is best be called by its wrapper function.
+ */
+static int __lanyfs_btree_del_inode(struct inode *dir, struct inode *par,
+				    struct inode *cur, const char *name)
+{
+	struct inode *lm; /* left-most inode of right subtree */
+	struct inode *lmp; /* left-most's parent */
+	struct inode *tmp;
+	struct lanyfs_lii *lii_cur;
+	struct lanyfs_lii *lii_lm;
+	int cmp;
+	int ret;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	lm = lmp = tmp = NULL;
+	lii_cur = LANYFS_I(cur);
+	cmp = strncmp(lii_cur->name, name, LANYFS_NAME_LENGTH);
+	if (cmp < 0 && lii_cur->left) {
+		/* object we are looking for must be in left subtree */
+		tmp = lanyfs_iget(dir->i_sb, lii_cur->left);
+		if (tmp) {
+			ret = __lanyfs_btree_del_inode(dir, cur, tmp, name);
+			iput(tmp);
+			return ret;
+		}
+	} else if (cmp > 0 && lii_cur->right) {
+		/* object we are looking for must be in right subtree */
+		tmp = lanyfs_iget(dir->i_sb, lii_cur->right);
+		if (tmp) {
+			ret = __lanyfs_btree_del_inode(dir, cur, tmp, name);
+			iput(tmp);
+			return ret;
+		}
+	} else if (cmp == 0 && !lii_cur->left && !lii_cur->right) {
+		/* case I: node is a leaf */
+		if (par) {
+			/* inode has parent */
+			lanyfs_btree_rpl_link(par, cur->i_ino, 0);
+		} else {
+			/* last inode in tree just died */
+			lanyfs_btree_set_subtree(dir, 0);
+		}
+	} else if (cmp == 0 && lii_cur->left && lii_cur->right) {
+		/* case II: node has two subtrees */
+
+		/* find leftmost in right subtree of p */
+		lmp = cur;
+		lm = lanyfs_iget(dir->i_sb, lii_cur->right);
+		if (!lm)
+			goto exit_clean;
+		lii_lm = LANYFS_I(lm);
+		while (lii_lm->left) {
+			if (lmp != cur)
+				iput(lmp);
+			lmp = lm;
+			lm = lanyfs_iget(dir->i_sb, lii_lm->left);
+			lii_lm = LANYFS_I(lm);
+		}
+
+		if (lmp != cur) {
+			/* get left-most's child */
+			tmp = lanyfs_iget(dir->i_sb, lanyfs_btree_any_link(lm));
+			if (!tmp)
+				goto exit_clean;
+			lanyfs_btree_rpl_link(lmp, lm->i_ino, tmp->i_ino);
+			lanyfs_btree_set_right(lm, lii_cur->right);
+			iput(tmp);
+		}
+		lanyfs_btree_set_left(lm, lii_cur->left);
+
+		if (par)
+			lanyfs_btree_rpl_link(par, cur->i_ino, lm->i_ino);
+		else
+			lanyfs_btree_set_subtree(dir, lm->i_ino);
+		iput(lm);
+	} else if (cmp == 0 && (lii_cur->left || lii_cur->right)) {
+		/* case III: node has one subtree */
+		tmp = lanyfs_iget(dir->i_sb, lanyfs_btree_any_link(cur));
+		if (!tmp)
+			goto exit_clean;
+		if (par)
+			lanyfs_btree_rpl_link(par, cur->i_ino, tmp->i_ino);
+		else
+			lanyfs_btree_set_subtree(dir, tmp->i_ino);
+		iput(tmp);
+	} else {
+		return -ENOENT;
+	}
+	return 0;
+exit_clean:
+	if (tmp)
+		iput(tmp);
+	if (lmp && lmp != cur)
+		iput(lmp);
+	if (lm)
+		iput(lm);
+	return -ENOENT;
+}
+
+/**
+ * lanyfs_btree_del_inode() - Removes an inode from a binary tree.
+ * @dir:			directory containing victim inode
+ * @name:			directory or file name of inode to be removed
+ *
+ * Deleting a node from a binary tree often leads to resorting the tree.
+ * Sometimes the root node changes, and this is why we have @dir as argument.
+ * It will automatically be updated by this function to ensure proper directory
+ * listings and overall consistency.
+ */
+int lanyfs_btree_del_inode(struct inode *dir, const char *name)
+{
+	struct lanyfs_lii *lii;
+	struct inode *root;
+	int ret;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	ret = -ENOENT;
+	lii = LANYFS_I(dir);
+	if (lii->subtree) {
+		root = lanyfs_iget(dir->i_sb, lii->subtree);
+		if (root) {
+			ret = __lanyfs_btree_del_inode(dir, NULL, root, name);
+			iput(root);
+		} else {
+			ret = -ENOMEM;
+		}
+	}
+	return ret;
+}
+
+/**
+ * __lanyfs_btree_lookup() - Looks up a inode in a binary tree by name.
+ * @cur:			current inode in binary search tree
+ * @name:			name to look up
+ *
+ * This function is internal and is best be called by its wrapper function.
+ */
+static struct inode *__lanyfs_btree_lookup(struct inode *cur, const char *name)
+{
+	struct lanyfs_lii *lii;
+	struct inode *next;
+	struct inode *ret;
+	int cmp;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	lii = LANYFS_I(cur);
+	cmp = strncmp(lii->name, name, LANYFS_NAME_LENGTH);
+	ret = NULL;
+	if (cmp < 0 && lii->left) {
+		/* left tree */
+		next = lanyfs_iget(cur->i_sb, lii->left);
+		if (next) {
+			ret =  __lanyfs_btree_lookup(next, name);
+			if (ret != next)
+				iput(next);
+		}
+	} else if (cmp > 0 && lii->right) {
+		/* right tree */
+		next = lanyfs_iget(cur->i_sb, lii->right);
+		if (next) {
+			ret = __lanyfs_btree_lookup(next, name);
+			if (ret != next)
+				iput(next);
+		}
+	} else if (cmp == 0) {
+		/* we found it */
+		return cur;
+	}
+	return ret;
+}
+
+/**
+ * lanyfs_btree_lookup() - Looks up an inode in a directory by name.
+ * @dir:			directory to look into
+ * @name:			name to look up
+ *
+ * Returns inode with increased reference count.
+ */
+struct inode *lanyfs_btree_lookup(struct inode *dir, const char *name)
+{
+	struct lanyfs_lii *lii;
+	struct inode *root;
+	struct inode *ret;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	lii = LANYFS_I(dir);
+	if (lii->subtree) {
+		root = lanyfs_iget(dir->i_sb, lii->subtree);
+		if (root) {
+			ret = __lanyfs_btree_lookup(root, name);
+			if (ret != root)
+				iput(root);
+			return ret;
+		}
+	}
+	return NULL;
+}
+
+/**
+ * lanyfs_btree_clear_inode() - Sets all links of an inode to 0.
+ * @inode:			inode to clear
+ */
+void lanyfs_btree_clear_inode(struct inode *inode)
+{
+	struct lanyfs_lii *lii;
+	lanyfs_debug_function(__FILE__, __func__);
+	lii = LANYFS_I(inode);
+	spin_lock(&lii->lock);
+	lii->left = 0;
+	lii->right = 0;
+	spin_unlock(&lii->lock);
+	mark_inode_dirty(inode);
+}
diff --git a/fs/lanyfs/chain.c b/fs/lanyfs/chain.c
new file mode 100644
index 0000000..ada35d9
--- /dev/null
+++ b/fs/lanyfs/chain.c
@@ -0,0 +1,173 @@
+/*
+ * chain.c - Lanyard Filesystem Chain Operations
+ *
+ * Copyright (C) 2012  Dan Luedtke <mail@danrl.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ */
+
+#include "lanyfs_km.h"
+
+/**
+ * lanyfs_chain_set_next() - Sets a chain block's successor.
+ * @sb:				superblock
+ * @addr:			address of chain block to manipulate
+ * @next:			address of next chain block in chain
+ */
+int lanyfs_chain_set_next(struct super_block *sb, lanyfs_blk_t addr,
+			   lanyfs_blk_t next)
+{
+	struct buffer_head *bh;
+	struct lanyfs_chain *chain;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	bh = sb_bread(sb, addr);
+	if (unlikely(!bh)) {
+		lanyfs_err(sb, "block #%llu read error", (u64) addr);
+		return -EIO;
+	}
+	chain = (struct lanyfs_chain *) bh->b_data;
+	lock_buffer(bh);
+	chain->next = next;
+	le16_add_cpu(&chain->wrcnt, 1);
+	unlock_buffer(bh);
+	mark_buffer_dirty(bh);
+	if (LANYFS_SB(sb)->opts.flush)
+		sync_dirty_buffer(bh);
+	brelse(bh);
+	return 0;
+}
+
+/**
+ * lanyfs_chain_create() - Creates a new chain block.
+ * @sb:				superblock
+ * @addr:			address of empty block
+ */
+int lanyfs_chain_create(struct super_block *sb, lanyfs_blk_t addr)
+{
+	struct lanyfs_fsi *fsi;
+	struct buffer_head *bh;
+	struct lanyfs_chain *chain;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	fsi = LANYFS_SB(sb);
+	bh = sb_bread(sb, addr);
+	if (unlikely(!bh)) {
+		lanyfs_err(sb, "block #%llu read error", (u64) addr);
+		return -EIO;
+	}
+	chain = (struct lanyfs_chain *) bh->b_data;
+	lock_buffer(bh);
+	memset(chain, 0x00, 1 << fsi->blocksize);
+	chain->type = LANYFS_TYPE_CHAIN;
+	unlock_buffer(bh);
+	mark_buffer_dirty(bh);
+	if (LANYFS_SB(sb)->opts.flush)
+		sync_dirty_buffer(bh);
+	brelse(bh);
+	return 0;
+}
+
+/**
+ * lanyfs_chain_pop() - Gets address in first non-empty slot of a chain block.
+ * @sb:				superblock
+ * @addr:			address of chain block to read
+ * @res:			result (address popped from chain block)
+ */
+int lanyfs_chain_pop(struct super_block *sb, lanyfs_blk_t addr,
+		     lanyfs_blk_t *res)
+{
+	struct lanyfs_fsi *fsi;
+	struct buffer_head *bh;
+	struct lanyfs_chain *chain;
+	unsigned char *p;
+	unsigned char *end;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	fsi = LANYFS_SB(sb);
+	bh = sb_bread(sb, addr);
+	if (unlikely(!bh)) {
+		lanyfs_err(sb, "block #%llu read error", (u64) addr);
+		return -EIO;
+	}
+	chain = (struct lanyfs_chain *) bh->b_data;
+	p = &chain->stream;
+	end = p + ((fsi->chainmax - 1) * fsi->addrlen);
+	lock_buffer(bh);
+	while (p < end) {
+		*res = 0;
+		memcpy(res, p, fsi->addrlen);
+		*res = le64_to_cpu(*res);
+		if (*res) {
+			memset(p, 0x00, fsi->addrlen);
+			le16_add_cpu(&chain->wrcnt, 1);
+			break;
+		}
+		p += fsi->addrlen;
+	}
+	unlock_buffer(bh);
+	if (!*res) {
+		*res = le64_to_cpu(chain->next);
+		bforget(bh);
+		return -LANYFS_ENOTAKEN;
+	}
+	mark_buffer_dirty(bh);
+	if (fsi->opts.flush)
+		sync_dirty_buffer(bh);
+	brelse(bh);
+	return 0;
+}
+
+/**
+ * lanyfs_chain_push() - Stores an address at first empty slot of a chain block.
+ * @sb:				superblock
+ * @addr:			address of chain block to manipulate
+ * @rookie:			address to store
+ */
+int lanyfs_chain_push(struct super_block *sb, lanyfs_blk_t addr,
+		      lanyfs_blk_t rookie)
+{
+	struct lanyfs_fsi *fsi;
+	struct buffer_head *bh;
+	struct lanyfs_chain *chain;
+	unsigned char *p;
+	unsigned char *end;
+	lanyfs_blk_t tmp;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	fsi = LANYFS_SB(sb);
+	bh = sb_bread(sb, addr);
+	if (unlikely(!bh)) {
+		lanyfs_err(sb, "block #%llu read error", (u64) addr);
+		return -EIO;
+	}
+	chain = (struct lanyfs_chain *) bh->b_data;
+	p = &chain->stream;
+	end = p + ((fsi->chainmax - 1) * fsi->addrlen);
+	lock_buffer(bh);
+	while (p < end) {
+		tmp = 0;
+		memcpy(&tmp, p, fsi->addrlen);
+		tmp = le64_to_cpu(tmp);
+		if (!tmp) {
+			rookie = cpu_to_le64(rookie);
+			memcpy(p, &rookie, fsi->addrlen);
+			le16_add_cpu(&chain->wrcnt, 1);
+			break;
+		}
+		p += fsi->addrlen;
+	}
+	unlock_buffer(bh);
+	if (tmp) {
+		bforget(bh);
+		return -LANYFS_ENOEMPTY;
+	}
+	mark_buffer_dirty(bh);
+	if (fsi->opts.flush)
+		sync_dirty_buffer(bh);
+	brelse(bh);
+	return 0;
+}
diff --git a/fs/lanyfs/dir.c b/fs/lanyfs/dir.c
new file mode 100644
index 0000000..76b31d1
--- /dev/null
+++ b/fs/lanyfs/dir.c
@@ -0,0 +1,393 @@
+/*
+ * dir.c - Lanyard Filesystem Directory Operations
+ *
+ * Copyright (C) 2012  Dan Luedtke <mail@danrl.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ */
+
+#include "lanyfs_km.h"
+
+/**
+ * lanyfs_empty() - Test wether a directory is empty or not.
+ * @inode:			directory inode to test
+ */
+static int lanyfs_empty(struct inode *inode)
+{
+	lanyfs_debug_function(__FILE__, __func__);
+
+	if (unlikely(!inode) || unlikely(!S_ISDIR(inode->i_mode)))
+		return 0;
+	return !LANYFS_I(inode)->subtree;
+}
+
+/**
+ * __lanyfs_readdir() - Lists directory contents using recursion.
+ * @n:				root node of tree to list
+ * @fp:				file pointer
+ * @dirent:			pointer to directory entry
+ * @filldir:			function pointer, provides function 'filldir'
+ *
+ * This function is internal and is best be called by its wrapper function.
+ */
+static int __lanyfs_readdir(lanyfs_blk_t n, struct file *fp, void *dirent,
+			    filldir_t filldir)
+{
+	struct inode *inode;
+	struct lanyfs_lii *lii;
+	int err;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	/* this entry */
+	err = 0;
+	inode = lanyfs_iget(fp->f_dentry->d_sb, n);
+	if (!inode)
+		return -ENOMEM;
+	lii = LANYFS_I(inode);
+	err = filldir(dirent, lii->name, lii->len, fp->f_pos, inode->i_ino,
+		      (inode->i_mode >> 12) & 0xF);
+	if (err)
+		goto exit_err;
+	fp->f_pos++;
+	/* left entry */
+	if (lii->left)
+		__lanyfs_readdir(lii->left, fp, dirent, filldir);
+	/* right entry */
+	if (lii->right)
+		__lanyfs_readdir(lii->right, fp, dirent, filldir);
+exit_err:
+	iput(inode);
+	return err;
+}
+
+/**
+ * lanyfs_readdir() - Lists directory contents.
+ * @fp:				file pointer
+ * @dirent:			pointer to directory entry
+ * @filldir:			function pointer, provides function 'filldir'
+ */
+static int lanyfs_readdir(struct file *fp, void *dirent, filldir_t filldir)
+{
+	ino_t ino;
+	lanyfs_blk_t subtree;
+	int err;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	switch (fp->f_pos) {
+	case 0:
+		/* this dir */
+		ino = fp->f_dentry->d_inode->i_ino;
+		err = filldir(dirent, ".", 1, fp->f_pos, ino, DT_DIR);
+		if (err)
+			return err;
+		fp->f_pos++;
+		/* fall through */
+	case 1:
+		/* parent dir */
+		ino = parent_ino(fp->f_dentry);
+		err = filldir(dirent, "..", 2, fp->f_pos, ino, DT_DIR);
+		if (err)
+			return err;
+		fp->f_pos++;
+		/* fall through */
+	case 2:
+		/* this dir's entries */
+		subtree = LANYFS_I(fp->f_dentry->d_inode)->subtree;
+		if (subtree)
+			__lanyfs_readdir(subtree, fp, dirent, filldir);
+		break;
+	default:
+		return -ENOENT;
+		break;
+	}
+	return 0;
+}
+
+/**
+ * lanyfs_mkdir() - Creates a new directory.
+ * @pdir:			current directory
+ * @dentry:			directory to create
+ * @mode:			requested mode of new directory
+ */
+static int lanyfs_mkdir(struct inode *pdir, struct dentry *dentry, umode_t mode)
+{
+	struct super_block *sb;
+	lanyfs_blk_t addr;
+	struct buffer_head *bh;
+	struct lanyfs_dir *dir;
+	struct inode *inode;
+	int err;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	/* length check */
+	if (dentry->d_name.len >= LANYFS_NAME_LENGTH)
+		return -ENAMETOOLONG;
+
+	sb = pdir->i_sb;
+	/* get free block */
+	addr = lanyfs_enslave(sb);
+	if (!addr)
+		return -ENOSPC;
+
+	/* create directory block */
+	bh = sb_bread(sb, addr);
+
+	if (!bh) {
+		lanyfs_err(sb, "error reading block #%llu", (u64) addr);
+		err = -EIO;
+		goto exit_release;
+	}
+	dir = (struct lanyfs_dir *) bh->b_data;
+
+	lock_buffer(bh);
+	memset(bh->b_data, 0x00, 1 << LANYFS_SB(sb)->blocksize);
+	dir->type = LANYFS_TYPE_DIR;
+	lanyfs_time_lts_now(&dir->meta.created);
+	dir->meta.modified = dir->meta.created;
+	dir->meta.attr = lanyfs_mode_to_attr(mode, 0);
+	strncpy(dir->meta.name, dentry->d_name.name, LANYFS_NAME_LENGTH - 1);
+	unlock_buffer(bh);
+	mark_buffer_dirty(bh);
+	if (LANYFS_SB(sb)->opts.flush)
+		sync_dirty_buffer(bh);
+	brelse(bh);
+
+	inode = lanyfs_iget(sb, addr);
+	if (!inode) {
+		err = -ENOMEM;
+		goto exit_release;
+	}
+	err = lanyfs_btree_add_inode(pdir, inode);
+	if (err)
+		goto exit_ino;
+	inc_nlink(inode);
+	d_instantiate(dentry, inode);
+	mark_inode_dirty(inode);
+	return 0;
+
+exit_ino:
+	drop_nlink(inode);
+	iput(inode);
+exit_release:
+	lanyfs_release(sb, addr);
+	return err;
+}
+
+/**
+ * lanyfs_rmdir() - Deletes a directory.
+ * @dir:		parent directory
+ * @dentry:		directory to remove
+ */
+static int lanyfs_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	lanyfs_blk_t addr;
+	int err;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	/* length check */
+	if (dentry->d_name.len >= LANYFS_NAME_LENGTH)
+		return -ENAMETOOLONG;
+
+	/* empty check */
+	if (!lanyfs_empty(dentry->d_inode))
+		return -ENOTEMPTY;
+
+	addr = dentry->d_inode->i_ino;
+
+	/* remove block from binary tree */
+	err = lanyfs_btree_del_inode(dir, dentry->d_name.name);
+	if (err)
+		return err;
+	drop_nlink(dir);
+	clear_nlink(dentry->d_inode);
+	d_delete(dentry);
+
+	/* set block free */
+	lanyfs_release(dir->i_sb, addr);
+	return 0;
+}
+
+/**
+ * lanyfs_unlink() - Deletes a file.
+ * @dir:			containing directory
+ * @dentry:			directory entry to remove
+ */
+static int lanyfs_unlink(struct inode *dir, struct dentry *dentry)
+{
+	struct super_block *sb;
+	struct inode *inode;
+	lanyfs_blk_t addr;
+	int err;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	sb = dir->i_sb;
+	inode = dentry->d_inode;
+	addr = inode->i_ino;
+
+	/* free space used by inode */
+	err = vmtruncate(inode, 0);
+	if (err)
+		return err;
+
+	err = lanyfs_btree_del_inode(dir, dentry->d_name.name);
+	if (err)
+		return err;
+
+	drop_nlink(inode);
+	lanyfs_inode_poke(dir);
+	lanyfs_release(sb, addr);
+	return 0;
+}
+
+/**
+ * lanyfs_rename() - Renames and/or moves a directory or file.
+ * @old_dir:			old directory
+ * @old_dentry:			old directory entry
+ * @new_dir:			new directory
+ * @new_dentry:			new directory entry
+ *
+ * Case I:
+ * Just rename a/foo to a/bar.
+ *
+ * Case II:
+ * Just move a/foo to b/foo.
+ *
+ * Case III:
+ * Rename and move a/foo to b/bar.
+ *
+ * Caution:
+ * Operations may overwrite existing objects!
+ */
+static int lanyfs_rename(struct inode *old_dir, struct dentry *old_dentry,
+			 struct inode *new_dir, struct dentry *new_dentry)
+{
+	struct super_block *sb;
+	const char *old_name;
+	const char *new_name;
+	struct inode *old_inode;
+	struct inode *new_inode;
+	int err;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	sb = old_dir->i_sb;
+	old_name = old_dentry->d_name.name;
+	new_name = new_dentry->d_name.name;
+	old_inode = old_dentry->d_inode;
+	new_inode = new_dentry->d_inode;
+
+	/* remove target if it exists */
+	if (new_inode) {
+		if (S_ISDIR(old_inode->i_mode)) {
+			if (!lanyfs_empty(new_inode))
+				return -ENOTEMPTY;
+			lanyfs_rmdir(new_dir, new_dentry);
+		} else {
+			lanyfs_unlink(new_dir, new_dentry);
+		}
+	}
+
+	/* remove node from old binary tree */
+	lanyfs_btree_del_inode(old_dir, old_name);
+	lanyfs_btree_clear_inode(old_inode);
+
+	/* change name */
+	lanyfs_inode_rename(old_inode, new_name);
+
+	/* add node to new binary tree */
+	err = lanyfs_btree_add_inode(new_dir, old_inode);
+	if (err)
+		return err;
+	lanyfs_inode_poke(old_inode);
+	lanyfs_inode_poke(old_dir);
+	lanyfs_inode_poke(new_dir);
+	return 0;
+}
+
+/**
+ * lanyfs_create() - Creates a new file.
+ * @dir:			parent directory
+ * @dentry:			directory entry of file to create
+ * @mode:			file mode
+ * @excl:			exclusive flag
+ *
+ * Creates a new file in @dir with mode @mode and the name requested in @dentry.
+ * @excl is ignored by LanyFS. There are not many filesystems
+ * using the flag at all. This was nameidata before 3.5 which LanyFS
+ * did not use either.
+ */
+static int lanyfs_create(struct inode *dir, struct dentry *dentry,
+			 umode_t mode, bool excl)
+{
+	struct super_block *sb;
+	struct lanyfs_fsi *fsi;
+	lanyfs_blk_t addr;
+	struct buffer_head *bh;
+	struct inode *inode;
+	struct lanyfs_file *file;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	sb = dir->i_sb;
+	fsi = LANYFS_SB(sb);
+
+	/* length check */
+	if (dentry->d_name.len >= LANYFS_NAME_LENGTH)
+		return -ENAMETOOLONG;
+
+	/* get free block */
+	addr = lanyfs_enslave(sb);
+	if (!addr)
+		return -ENOSPC;
+
+	/* create file block */
+	bh = sb_bread(sb, addr);
+	if (!bh) {
+		lanyfs_err(sb, "error reading block #%llu", (u64) addr);
+		return -EIO;
+	}
+	file = (struct lanyfs_file *) bh->b_data;
+	lock_buffer(bh);
+	memset(bh->b_data, 0x00, 1 << fsi->blocksize);
+	file->type = LANYFS_TYPE_FILE;
+	lanyfs_time_lts_now(&file->meta.created);
+	file->meta.modified = file->meta.created;
+	file->meta.attr = lanyfs_mode_to_attr(mode, 0);
+	strncpy(file->meta.name, dentry->d_name.name, LANYFS_NAME_LENGTH - 1);
+	unlock_buffer(bh);
+	mark_buffer_dirty(bh);
+	if (fsi->opts.flush)
+		sync_dirty_buffer(bh);
+	brelse(bh);
+
+	/* VFS */
+	inode = lanyfs_iget(sb, addr);
+	if (!inode) {
+		dput(dentry);
+		drop_nlink(inode);
+		iput(inode);
+		lanyfs_release(sb, addr);
+		return -ENOMEM;
+	}
+	lanyfs_btree_add_inode(dir, inode);
+	d_instantiate(dentry, inode);
+	mark_inode_dirty(inode);
+	return 0;
+}
+
+/* lanyfs dir operations */
+const struct file_operations lanyfs_dir_operations = {
+	.readdir		= lanyfs_readdir,
+};
+
+/* lanyfs dir inode operations */
+const struct inode_operations lanyfs_dir_inode_operations = {
+	.lookup			= lanyfs_lookup,
+	.create			= lanyfs_create,
+	.mkdir			= lanyfs_mkdir,
+	.rmdir			= lanyfs_rmdir,
+	.rename			= lanyfs_rename,
+	.unlink			= lanyfs_unlink,
+};
+
diff --git a/fs/lanyfs/extender.c b/fs/lanyfs/extender.c
new file mode 100644
index 0000000..6dcd378
--- /dev/null
+++ b/fs/lanyfs/extender.c
@@ -0,0 +1,352 @@
+/*
+ * extender.c - Lanyard Filesystem Extender Operations
+ *
+ * Copyright (C) 2012  Dan Luedtke <mail@danrl.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ */
+
+#include "lanyfs_km.h"
+
+/**
+ * intpow() - Simple exponentiation function.
+ * @b:				base
+ * @n:				exponent
+ *
+ * This function does not cover special cases where @n equals zero and @b does
+ * not equal zero.
+ */
+static inline int intpow(int b, int n)
+{
+	if (!n)
+		return 1;
+	while (n--)
+		b *= b;
+	return b;
+}
+
+/**
+ * lanyfs_ext_get_slot() - Returns the address stored in an extender block slot.
+ * @ext:			extender block to read from
+ * @addrlen:			address length
+ * @slot:			number of slot to read
+ */
+static inline lanyfs_blk_t lanyfs_ext_get_slot(struct lanyfs_ext *ext,
+					       unsigned int addrlen,
+					       unsigned int slot)
+{
+	lanyfs_blk_t addr;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	addr = 0;
+	memcpy(&addr, &ext->stream + (slot * addrlen), addrlen);
+	return le64_to_cpu(addr);
+}
+
+/**
+ * lanyfs_ext_set_slot() - Stores an address in an extender block slot.
+ * @ext:			extender block to write to
+ * @addrlen:			address length
+ * @slot:			number of slot to write
+ * @addr:			address to store
+ */
+static inline void lanyfs_ext_set_slot(struct lanyfs_ext *ext,
+				       unsigned int addrlen,
+				       unsigned int slot, lanyfs_blk_t addr)
+{
+	lanyfs_debug_function(__FILE__, __func__);
+
+	addr = cpu_to_le64(addr);
+	memcpy(&ext->stream + (slot * addrlen), &addr, addrlen);
+}
+
+/**
+ * lanyfs_ext_kill_slot() - Resets the slot of an extender block to zero.
+ * @ext:			extender block to write to
+ * @addrlen:			address length
+ * @slot:			number of slot to kill
+ */
+static inline void lanyfs_ext_kill_slot(struct lanyfs_ext *ext,
+					unsigned int addrlen,
+					unsigned int slot)
+{
+	lanyfs_debug_function(__FILE__, __func__);
+
+	memset(&ext->stream + (slot * addrlen), 0x00, addrlen);
+}
+
+/**
+ * lanyfs_ext_iblock() - Gets the address of data block in a file.
+ * @sb:				superblock
+ * @addr:			address of extender block to read
+ * @iblock:			file-internal block number
+ * @res:			pointer to result storage
+ *
+ * Mapping a file-internal block (called iblock) to the correct on-disk block
+ * requires reading its address from an extender block. Larger files use
+ * multiple levels of extender blocks, so this function sometimes calls itselfs
+ * when going down extender blocks level by level. On-disk addresses are always
+ * stored in extender blocks of level 0. Once the on-disk address is found it is
+ * saved to @res.
+ */
+int lanyfs_ext_iblock(struct super_block *sb, lanyfs_blk_t addr,
+		      lanyfs_blk_t iblock, lanyfs_blk_t *res)
+{
+	struct lanyfs_fsi *fsi;
+	struct buffer_head *bh;
+	struct lanyfs_ext *ext;
+	unsigned int slot;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	if (unlikely(!addr))
+		return -EINVAL;
+
+	fsi = LANYFS_SB(sb);
+	bh = sb_bread(sb, addr);
+	if (unlikely(!bh)) {
+		lanyfs_err(sb, "block #%llu read error", (u64) addr);
+		return -EIO;
+	}
+	ext = (struct lanyfs_ext *) bh->b_data;
+	if (ext->level) {
+		slot = (iblock / intpow(fsi->extmax, ext->level)) % fsi->extmax;
+		addr = lanyfs_ext_get_slot(ext, fsi->addrlen, slot);
+		brelse(bh);
+		if (addr)
+			return lanyfs_ext_iblock(sb, addr, iblock, res);
+		return -EINVAL;
+	}
+	*res = lanyfs_ext_get_slot(ext, fsi->addrlen, (iblock % fsi->extmax));
+	brelse(bh);
+	return 0;
+}
+
+/**
+ * lanyfs_ext_truncate() - Sets the on-disk size of a file.
+ * @sb:				superblock
+ * @addr:			address of extender block to read
+ * @iblock:			new size in file-internal blocks
+ *
+ * Once again recursion is used to walk through all levels of extender blocks.
+ * Blocks that are not needed anymore are returned to the free blocks pool by
+ * this function. This is the lowest level of file size changes and usually
+ * happens after VFS has already truncated the file's in-memory representation.
+ */
+int lanyfs_ext_truncate(struct super_block *sb, lanyfs_blk_t addr,
+			lanyfs_blk_t iblock)
+{
+	struct lanyfs_fsi *fsi;
+	struct buffer_head *bh;
+	struct lanyfs_ext *ext;
+	unsigned int slot;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	if (unlikely(!addr))
+		return -EINVAL;
+
+	fsi = LANYFS_SB(sb);
+	bh = sb_bread(sb, addr);
+	if (unlikely(!bh)) {
+		lanyfs_err(sb, "block #%llu read error", (u64) addr);
+		return -EIO;
+	}
+	ext = (struct lanyfs_ext *) bh->b_data;
+	slot = (iblock / intpow(fsi->extmax, ext->level)) % fsi->extmax;
+	lock_buffer(bh);
+	while (slot < fsi->extmax) {
+		addr = lanyfs_ext_get_slot(ext, fsi->addrlen, slot);
+		if (addr) {
+			if (ext->level) {
+				/* barrier below this slot */
+				lanyfs_ext_truncate(sb, addr, iblock);
+				iblock = 0;
+			} else {
+				lanyfs_ext_kill_slot(ext, fsi->addrlen, slot);
+				lanyfs_release(sb, addr);
+			}
+		}
+		slot++;
+	}
+	le16_add_cpu(&ext->wrcnt, 1);
+	unlock_buffer(bh);
+	mark_buffer_dirty(bh);
+	if (fsi->opts.flush)
+		sync_dirty_buffer(bh);
+	brelse(bh);
+	return 0;
+}
+
+/**
+ * lanyfs_ext_create() - Creates a new extender block.
+ * @sb:				superblock
+ * @level:			level of new extender block
+ */
+lanyfs_blk_t lanyfs_ext_create(struct super_block *sb, unsigned short level)
+{
+	struct lanyfs_fsi *fsi;
+	struct buffer_head *bh;
+	struct lanyfs_ext *ext;
+	lanyfs_blk_t addr;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	fsi = LANYFS_SB(sb);
+
+	addr = lanyfs_enslave(sb);
+	if (!addr)
+		return 0;
+	bh = sb_bread(sb, addr);
+	if (unlikely(!bh)) {
+		lanyfs_err(sb, "block #%llu read error", (u64) addr);
+		return 0;
+	}
+	ext = (struct lanyfs_ext *) bh->b_data;
+	lock_buffer(bh);
+	memset(ext, 0x00, 1 << fsi->blocksize);
+	ext->type = LANYFS_TYPE_EXT;
+	ext->level = level;
+	unlock_buffer(bh);
+	mark_buffer_dirty(bh);
+	if (fsi->opts.flush)
+		sync_dirty_buffer(bh);
+	brelse(bh);
+	return addr;
+}
+
+/**
+ * __lanyfs_ext_grow() - Increases the on-disk size of a file.
+ * @sb:				superblock
+ * @addr:			address of extender block to start at
+ *
+ * This function is internal and is best be called by its wrapper function.
+ */
+static int __lanyfs_ext_grow(struct super_block *sb, lanyfs_blk_t addr)
+{
+	struct lanyfs_fsi *fsi;
+	struct buffer_head *bh;
+	struct lanyfs_ext *ext;
+	unsigned int slot;
+	lanyfs_blk_t new;
+	lanyfs_blk_t tmp;
+	int ret;
+	lanyfs_debug_function(__FILE__, __func__);
+
+
+	if (unlikely(!addr))
+		return -LANYFS_EPROTECTED;
+
+	fsi = LANYFS_SB(sb);
+	ret = -LANYFS_ENOTAKEN;
+	bh = sb_bread(sb, addr);
+	if (unlikely(!bh)) {
+		lanyfs_err(sb, "block #%llu read error", (u64) addr);
+		return -EIO;
+	}
+	ext = (struct lanyfs_ext *) bh->b_data;
+	if (ext->level) {
+		for (slot = fsi->extmax; slot; slot--) {
+			tmp = lanyfs_ext_get_slot(ext, fsi->addrlen, slot - 1);
+			if (!tmp && slot > 1)
+				continue;
+			ret = __lanyfs_ext_grow(sb, tmp);
+			if (ret != -LANYFS_ENOEMPTY)
+				goto exit_ret;
+			if (slot >= fsi->extmax) {
+				ret = -LANYFS_ENOEMPTY;
+				goto exit_ret;
+			}
+			new = lanyfs_ext_create(sb, ext->level - 1);
+			if (!new) {
+				ret = -ENOSPC;
+				goto exit_ret;
+			}
+			lock_buffer(bh);
+			lanyfs_ext_set_slot(ext, fsi->addrlen, slot, new);
+			unlock_buffer(bh);
+			mark_buffer_dirty(bh);
+			slot++;
+		}
+	} else {
+		for (slot = 0; slot < fsi->extmax; slot++) {
+			tmp = lanyfs_ext_get_slot(ext, fsi->addrlen, slot);
+			if (tmp)
+				continue;
+			new = lanyfs_enslave(sb);
+			if (!new) {
+				ret = -ENOSPC;
+				goto exit_ret;
+			}
+			lock_buffer(bh);
+			lanyfs_ext_set_slot(ext, fsi->addrlen, slot, new);
+			unlock_buffer(bh);
+			mark_buffer_dirty(bh);
+			ret = 0;
+			goto exit_ret;
+		}
+		ret = -LANYFS_ENOEMPTY;
+	}
+exit_ret:
+	if (fsi->opts.flush)
+		sync_dirty_buffer(bh);
+	brelse(bh);
+	return ret;
+}
+
+/**
+ * lanyfs_ext_grow() - Increases the on-disk size of a file by one block.
+ * @sb:				superblock
+ * @addr:			address of top-level extender block
+ *
+ * If all slots of all extender blocks of a file are occupied, a new level of
+ * extender blocks has to be introduced. The new level extender block becomes
+ * the new entry point thus changing the corresponding inodes private data. If
+ * a new entry point is created, its address is stored in @addr. Upper layer
+ * functions must update inode private data accordingly.
+ */
+int lanyfs_ext_grow(struct super_block *sb, lanyfs_blk_t *addr)
+{
+	struct lanyfs_fsi *fsi;
+	struct buffer_head *bh;
+	struct lanyfs_ext *ext;
+	lanyfs_blk_t new;
+	int ret;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	if (unlikely(!*addr))
+		return -LANYFS_EPROTECTED;
+
+	fsi = LANYFS_SB(sb);
+	ret = __lanyfs_ext_grow(sb, *addr);
+
+	if (ret == -LANYFS_ENOEMPTY) {
+		/* all extender blocks are occupied, go one level up */
+		bh = sb_bread(sb, *addr);
+		if (unlikely(!bh)) {
+			lanyfs_err(sb, "block #%llu read error", (u64) *addr);
+			return -EIO;
+		}
+		ext = (struct lanyfs_ext *) bh->b_data;
+		brelse(bh);
+
+		new = lanyfs_ext_create(sb, ext->level + 1);
+		if (!new)
+			return -ENOSPC;
+		bh = sb_bread(sb, new);
+		if (unlikely(!bh)) {
+			lanyfs_err(sb, "block #%llu read error", (u64) new);
+			return -EIO;
+		}
+		ext = (struct lanyfs_ext *) bh->b_data;
+		lock_buffer(bh);
+		lanyfs_ext_set_slot(ext, fsi->addrlen, 0, *addr);
+		unlock_buffer(bh);
+		mark_buffer_dirty(bh);
+		if (fsi->opts.flush)
+			sync_dirty_buffer(bh);
+		brelse(bh);
+		*addr = new;
+	}
+	return ret;
+}
diff --git a/fs/lanyfs/file.c b/fs/lanyfs/file.c
new file mode 100644
index 0000000..236f4fe
--- /dev/null
+++ b/fs/lanyfs/file.c
@@ -0,0 +1,114 @@
+/*
+ * file.c - Lanyard Filesystem File Operations
+ *
+ * Copyright (C) 2012  Dan Luedtke <mail@danrl.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ */
+
+#include "lanyfs_km.h"
+
+/**
+ * lanyfs_getblk() - Maps a file-internal block to a on-disk block.
+ * @inode:			file inode
+ * @iblock:			file-internal block
+ * @bh_result:			buffer head for result
+ * @create:			create the requested block
+ */
+static int lanyfs_getblk(struct inode *inode, sector_t iblock,
+			 struct buffer_head *bh_result, int create)
+{
+	struct super_block *sb;
+	struct lanyfs_fsi *fsi;
+	struct lanyfs_lii *lii;
+	lanyfs_blk_t addr;
+	int err;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	sb = inode->i_sb;
+	fsi = LANYFS_SB(sb);
+	lii = LANYFS_I(inode);
+
+	if (!lii->data) {
+		spin_lock(&lii->lock);
+		lii->data = lanyfs_ext_create(sb, 0);
+		spin_unlock(&lii->lock);
+		if (!lii->data)
+			return -ENOSPC;
+	}
+	if (create) {
+		spin_lock(&lii->lock);
+		lanyfs_ext_grow(sb, &lii->data);
+		spin_unlock(&lii->lock);
+		set_buffer_new(bh_result);
+		inode_add_bytes(inode, sb->s_blocksize);
+		mark_inode_dirty(inode);
+	}
+	err = lanyfs_ext_iblock(sb, lii->data, iblock, &addr);
+	if (err)
+		return err;
+	map_bh(bh_result, sb, addr);
+	return 0;
+}
+
+/**
+ * lanyfs_writepage() - Writes a full page to disk.
+ * @page:			page to write
+ * @wbc:			writeback control
+ */
+static int lanyfs_writepage(struct page *page, struct writeback_control *wbc)
+{
+	lanyfs_debug_function(__FILE__, __func__);
+
+	return block_write_full_page(page, lanyfs_getblk, wbc);
+}
+
+/**
+ * lanyfs_readpage() - Reads a full page from disk.
+ * @fp:				file pointer
+ * @page:			page to read
+ */
+static int lanyfs_readpage(struct file *fp, struct page *page)
+{
+	lanyfs_debug_function(__FILE__, __func__);
+
+	return block_read_full_page(page, lanyfs_getblk);
+}
+
+/**
+ * lanyfs_bmap() - Maps an on-disk block to a page.
+ * @mapping:			address space mapping information
+ * @block:			block to map
+ */
+static sector_t lanyfs_bmap(struct address_space *mapping, sector_t block)
+{
+	lanyfs_debug_function(__FILE__, __func__);
+
+	return generic_block_bmap(mapping, block, lanyfs_getblk);
+}
+
+/* lanyfs address space operations */
+const struct address_space_operations lanyfs_address_space_operations = {
+	.readpage	= lanyfs_readpage,
+	.writepage	= lanyfs_writepage,
+	.write_begin	= simple_write_begin,
+	.write_end	= simple_write_end,
+	.bmap		= lanyfs_bmap,
+};
+
+/* lanyfs file operations */
+const struct file_operations lanyfs_file_operations = {
+	.open		= generic_file_open,
+	.read		= do_sync_read,
+	.write		= do_sync_write,
+	.aio_read	= generic_file_aio_read,
+	.aio_write	= generic_file_aio_write,
+	.mmap		= generic_file_mmap,
+	.fsync		= generic_file_fsync,
+	.splice_read	= generic_file_splice_read,
+/*	.release	= generic_file_release, */
+	.llseek		= generic_file_llseek,
+};
diff --git a/fs/lanyfs/icache.c b/fs/lanyfs/icache.c
new file mode 100644
index 0000000..25641bd
--- /dev/null
+++ b/fs/lanyfs/icache.c
@@ -0,0 +1,113 @@
+/*
+ * icache.c - Lanyard Filesystem Inode Cache
+ *
+ * Copyright (C) 2012  Dan Luedtke <mail@danrl.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ */
+
+#include "lanyfs_km.h"
+
+/**
+ * DOC: LanyFS Inode Cache
+ *
+ * LanyFS uses the Kernel's slab cache API for maintaining a common cache for
+ * VFS inodes and LanyFS inode private data.
+ */
+
+/* inode cache pointer */
+static struct kmem_cache *lanyfs_inode_cachep;
+
+/**
+ * LANYFS_I() - Returns pointer to inode's private data.
+ * @inode:			vfs inode
+ */
+struct lanyfs_lii *LANYFS_I(struct inode *inode)
+{
+	lanyfs_debug_function(__FILE__, __func__);
+
+	return list_entry(inode, struct lanyfs_lii, vfs_inode);
+}
+
+/**
+ * lanyfs_inodecache_kcminit() - Initializes an inode cache element.
+ *
+ * This function has to take care of initializing the inode pointed to by
+ * vfs_inode! Also, this is not the inodecache initialization function, only
+ * single elements are initialzed here.
+ *
+ * @ptr:			pointer to inode private data
+ */
+static void lanyfs_inodecache_kmcinit(void *ptr)
+{
+	lanyfs_debug_function(__FILE__, __func__);
+
+	inode_init_once(&((struct lanyfs_lii *) ptr)->vfs_inode);
+}
+
+/**
+ * lanyfs_inodecache_init() - Initializes the inode cache.
+ *
+ * If compiled with debug enabled, the cache is initialized with special flags
+ * set. Mostly to catch references to uninitialized memory and to check for
+ * buffer overruns.
+ */
+int lanyfs_inodecache_init(void)
+{
+	lanyfs_debug_function(__FILE__, __func__);
+
+	lanyfs_inode_cachep = kmem_cache_create("lanyfs_inode_cache",
+		sizeof(struct lanyfs_lii),
+		0,
+#ifdef LANYFS_DEBUG
+		(SLAB_RED_ZONE | SLAB_POISON),
+#else
+		0,
+#endif /* LANYFS_DEBUG */
+		lanyfs_inodecache_kmcinit);
+	if (!lanyfs_inode_cachep)
+		return -ENOMEM;
+	return 0;
+}
+
+/**
+ * lanyfs_inodecache_destroy() - Destroys the inode cache.
+ */
+void lanyfs_inodecache_destroy(void)
+{
+	lanyfs_debug_function(__FILE__, __func__);
+
+	kmem_cache_destroy(lanyfs_inode_cachep);
+}
+
+/**
+ * lanyfs_alloc_inode() - Allocates an inode using the inode cache.
+ * @sb:				superblock
+ */
+struct inode *lanyfs_alloc_inode(struct super_block *sb)
+{
+	struct lanyfs_lii *lii;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	lii = kmem_cache_alloc(lanyfs_inode_cachep, GFP_NOFS);
+	if (!lii)
+		return NULL;
+	spin_lock_init(&lii->lock);
+	return &lii->vfs_inode;
+}
+
+/**
+ * lanyfs_destroy_inode() - Removes an inode from inode cache.
+ * @inode:			inode
+ */
+void lanyfs_destroy_inode(struct inode *inode)
+{
+	struct lanyfs_lii *lii;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	lii = LANYFS_I(inode);
+	kmem_cache_free(lanyfs_inode_cachep, lii);
+}
diff --git a/fs/lanyfs/inode.c b/fs/lanyfs/inode.c
new file mode 100644
index 0000000..5bb8f9a
--- /dev/null
+++ b/fs/lanyfs/inode.c
@@ -0,0 +1,357 @@
+/*
+ * inode.c - Lanyard Filesystem Inode Operations
+ *
+ * Copyright (C) 2012  Dan Luedtke <mail@danrl.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ */
+
+#include "lanyfs_km.h"
+
+static const struct inode_operations lanyfs_file_inode_operations;
+
+/**
+ * lanyfs_inode_poke() - Updates all timestamps of an inode.
+ * @inode:			inode to update
+ *
+ * Don't do this to unhashed inodes.
+ */
+void lanyfs_inode_poke(struct inode *inode)
+{
+	lanyfs_debug_function(__FILE__, __func__);
+
+	if (inode) {
+		spin_lock(&inode->i_lock);
+		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+		spin_unlock(&inode->i_lock);
+		mark_inode_dirty(inode);
+	}
+}
+
+/**
+ * lanyfs_inode_rename() - Sets name of a directory or file.
+ * @inode:			inode to rename
+ * @name:			new name
+ *
+ * Attention! Callers must remove the inode from any binary tree *before*
+ * setting a new name otherwise the tree will break.
+ */
+void lanyfs_inode_rename(struct inode *inode, const char *name)
+{
+	struct lanyfs_lii *lii;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	lii = LANYFS_I(inode);
+	spin_lock(&lii->lock);
+	spin_lock(&inode->i_lock);
+	memset(lii->name, 0x00, LANYFS_NAME_LENGTH);
+	strncpy(lii->name, name, LANYFS_NAME_LENGTH - 1);
+	lii->len = strlen(lii->name);
+	spin_unlock(&inode->i_lock);
+	spin_unlock(&lii->lock);
+}
+
+/**
+ * lanyfs_iget() - Turns a file or directory block into an inode.
+ * @sb:				superblock
+ * @addr:			number of block to awake
+ *
+ * Checks for inode state, thus overloading an inode already woken up will
+ * will just return that inode with increased reference count. Make sure to
+ * always decrease the reference count after use. VFS recklessly kills all
+ * referenced inodes on unmount which may lead to data loss.
+ * Real overloading would endanger consistency.
+ */
+struct inode *lanyfs_iget(struct super_block *sb, lanyfs_blk_t addr)
+{
+	struct lanyfs_fsi *fsi;
+	struct lanyfs_lii *lii;
+	struct buffer_head *bh;
+	union lanyfs_b *b;
+	struct inode *inode;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	if (!addr)
+		return NULL;
+	fsi = LANYFS_SB(sb);
+	inode = iget_locked(sb, addr); /* !: implicit cast to unsigned long */
+	if (!inode)
+		return NULL;
+	if (!(inode->i_state & I_NEW))
+		return inode;
+	lii = LANYFS_I(inode);
+	bh = sb_bread(sb, addr);
+	if (!bh) {
+		lanyfs_debug("error reading block #%llu", (u64) addr);
+		iget_failed(inode);
+		return NULL;
+	}
+	b = (union lanyfs_b *) bh->b_data;
+	switch (b->raw.type) {
+	case LANYFS_TYPE_DIR:
+		/* directory specific fields */
+		lii->subtree = le64_to_cpu(b->dir.subtree);
+		inode->i_op = &lanyfs_dir_inode_operations;
+		inode->i_fop = &lanyfs_dir_operations;
+		inode->i_mode = lanyfs_attr_to_mode(sb,
+			le16_to_cpu(b->vi_meta.attr), S_IFDIR);
+		inode->i_size = 1 << fsi->blocksize;
+		break;
+	case LANYFS_TYPE_FILE:
+		/* file specific fields */
+		lii->data = le64_to_cpu(b->file.data);
+		inode->i_op = &lanyfs_file_inode_operations;
+		inode->i_fop = &lanyfs_file_operations;
+		inode->i_mapping->a_ops = &lanyfs_address_space_operations;
+		inode->i_mode = lanyfs_attr_to_mode(sb,
+			le16_to_cpu(b->vi_meta.attr), S_IFREG);
+		inode->i_size = le64_to_cpu(b->file.size);
+		break;
+	default:
+		brelse(bh);
+		iget_failed(inode);
+		return NULL;
+		break;
+	}
+	/* binary tree */
+	lii->left = le64_to_cpu(b->vi_btree.left);
+	lii->right = le64_to_cpu(b->vi_btree.right);
+	/* times */
+	lanyfs_time_lts_to_kts(&b->vi_meta.modified, &inode->i_mtime);
+	inode->i_atime = inode->i_ctime = inode->i_mtime;
+	lanyfs_time_lts_to_kts(&b->vi_meta.created, &lii->created);
+	/* name */
+	memset(lii->name, 0x00, LANYFS_NAME_LENGTH);
+	strncpy(lii->name, b->vi_meta.name, LANYFS_NAME_LENGTH - 1);
+	lii->len = strlen(lii->name);
+	/* uid, gid */
+	inode->i_uid = fsi->opts.uid;
+	inode->i_gid = fsi->opts.gid;
+	/* blksize */
+	inode->i_blkbits = fsi->blocksize;
+	unlock_new_inode(inode);
+	brelse(bh);
+	return inode;
+}
+
+/**
+ * lanyfs_lookup() - Looks up an inode in a directory by name.
+ * @dir:			inode of containing directory
+ * @dentry:			directory entry to look up
+ * @flags:			lookup flags
+ *
+ * The @flags are ignored by LanyFS. There are not many filesystems
+ * using the flags at all. This was nameidata before 3.5 which LanyFS
+ * did not use either.
+ */
+struct dentry *lanyfs_lookup(struct inode *dir, struct dentry *dentry,
+			     unsigned int flags)
+{
+	struct inode *inode;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	/* length check */
+	if (dentry->d_name.len >= LANYFS_NAME_LENGTH)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	inode = lanyfs_btree_lookup(dir, dentry->d_name.name);
+	if (inode)
+		return d_splice_alias(inode, dentry);
+	return NULL;
+}
+
+/**
+ * lanyfs_write_inode() - Writes inode to disk.
+ * @inode:			VFS inode
+ * @wbc:			writeback control (unused)
+ */
+int lanyfs_write_inode(struct inode *inode, struct writeback_control *wbc)
+{
+	struct buffer_head *bh;
+	struct lanyfs_lii *lii;
+	union lanyfs_b *b;
+	u16 attr;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	if (!inode->i_nlink)
+		return 0;
+
+	lii = LANYFS_I(inode);
+	bh = sb_bread(inode->i_sb, inode->i_ino);
+	if (!bh) {
+		lanyfs_debug("error reading block #%llu", (u64) inode->i_ino);
+		return -EIO;
+	}
+	b = (union lanyfs_b *) bh->b_data;
+	spin_lock(&lii->lock);
+	spin_lock(&inode->i_lock);
+	lock_buffer(bh);
+	switch (b->raw.type) {
+	case LANYFS_TYPE_DIR:
+		/* directory specific fields */
+		b->dir.subtree = cpu_to_le64(lii->subtree);
+		break;
+	case LANYFS_TYPE_FILE:
+		/* file specific fields */
+		b->file.data = cpu_to_le64(lii->data);
+		b->file.size = cpu_to_le64(inode->i_size);
+		break;
+	default:
+		spin_unlock(&inode->i_lock);
+		spin_unlock(&lii->lock);
+		unlock_buffer(bh);
+		bforget(bh);
+		return -EINVAL;
+		break;
+	}
+	/* name */
+	memset(b->vi_meta.name, 0x00, LANYFS_NAME_LENGTH);
+	strncpy(b->vi_meta.name, lii->name, LANYFS_NAME_LENGTH - 1);
+	/* latest time *anything* changed always becomes modification time */
+	lanyfs_time_sync_inode(inode);
+	lanyfs_time_kts_to_lts(&inode->i_mtime, &b->vi_meta.modified);
+	/* mode */
+	attr = le16_to_cpu(b->vi_meta.attr);
+	attr = lanyfs_mode_to_attr(inode->i_mode, attr);
+	b->vi_meta.attr = cpu_to_le16(attr);
+	/* binary tree */
+	b->vi_btree.left = cpu_to_le64(lii->left);
+	b->vi_btree.right = cpu_to_le64(lii->right);
+	/* write counter */
+	le16_add_cpu(&b->raw.wrcnt, 1);
+
+	spin_unlock(&inode->i_lock);
+	spin_unlock(&lii->lock);
+	unlock_buffer(bh);
+	mark_buffer_dirty(bh);
+	if (LANYFS_SB(inode->i_sb)->opts.flush)
+		sync_dirty_buffer(bh);
+	brelse(bh);
+	return 0;
+}
+
+/**
+ * lanyfs_setattr() - Sets the attributes of an directory entry.
+ * @dentry:			directory entry to manipulate
+ * @attr:			new attributes
+ *
+ * This is the point where VFS tells us what it likes to change. We can then
+ * decide what changes we like and what changes we would like to reject.
+ * File size changes are also invoked from here and delegated to vmtruncate,
+ * which in turn calls lanyfs_truncate() after some checks.
+ */
+static int lanyfs_setattr(struct dentry *dentry, struct iattr *attr)
+{
+	struct lanyfs_fsi *fsi;
+	struct inode *inode;
+	int err;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	inode = dentry->d_inode;
+	fsi = LANYFS_SB(inode->i_sb);
+
+/*
+ * TODO
+	if ((err = inode_change_ok(inode, attr)));
+		return err;
+*/
+	/* no uid changes */
+	if ((attr->ia_valid & ATTR_UID) &&
+	    (attr->ia_uid != fsi->opts.uid))
+		return 0;
+	/* no gid changes */
+	if ((attr->ia_valid & ATTR_GID) &&
+	    (attr->ia_gid != fsi->opts.gid))
+		return 0;
+	/* directories and files can be set read-only */
+	if (attr->ia_valid & ATTR_MODE) {
+		if (attr->ia_mode & S_IWUSR)
+			attr->ia_mode = inode->i_mode | S_IWUGO;
+		else
+			attr->ia_mode = inode->i_mode & ~S_IWUGO;
+	}
+	/* files can be set non-executable */
+	if ((attr->ia_valid & ATTR_MODE) && !S_ISDIR(inode->i_mode)) {
+		if (attr->ia_mode & S_IXUSR)
+			attr->ia_mode = inode->i_mode | S_IXUGO;
+		else
+			attr->ia_mode = inode->i_mode & ~S_IXUGO;
+	}
+	/* apply masks */
+	if (S_ISDIR(inode->i_mode))
+		attr->ia_mode &= ~fsi->opts.dmask;
+	else
+		attr->ia_mode &= ~fsi->opts.fmask;
+	/* size change */
+	if ((attr->ia_valid & ATTR_SIZE) &&
+	    attr->ia_size != i_size_read(inode)) {
+		inode_dio_wait(inode);
+		err = vmtruncate(inode, attr->ia_size);
+		if (err)
+			return err;
+	}
+	setattr_copy(inode, attr);
+	mark_inode_dirty(inode);
+	return 0;
+}
+
+/** lanyfs_getattr() - Gets directory entry attributes.
+ * @mnt:			VFS mount
+ * @dentry:			directory entry to read
+ * @kstat:			pointer to result storage
+ *
+ * This function does not differ much from the standard VFS getattr() currently.
+ */
+static int lanyfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
+			  struct kstat *kstat)
+{
+	struct inode *inode;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	inode = dentry->d_inode;
+	kstat->dev = inode->i_sb->s_dev;
+	kstat->ino = inode->i_ino;
+	kstat->mode = inode->i_mode;
+	kstat->nlink = inode->i_nlink;
+	kstat->uid = inode->i_uid;
+	kstat->gid = inode->i_gid;
+	kstat->rdev = inode->i_rdev;
+	kstat->size = i_size_read(inode);
+	kstat->atime = inode->i_atime;
+	kstat->mtime = inode->i_mtime;
+	kstat->ctime = inode->i_ctime;
+	kstat->blksize = (1 << inode->i_blkbits);
+	kstat->blocks = inode->i_blocks;
+	return 0;
+}
+
+/** lanyfs_truncate() - Truncates a file.
+ * @inode:			inode of file to truncate
+ */
+static void lanyfs_truncate(struct inode *inode)
+{
+	struct lanyfs_fsi *fsi;
+	struct lanyfs_lii *lii;
+	lanyfs_blk_t iblock;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	lii = LANYFS_I(inode);
+	if (!lii->data)
+		return;
+	fsi = LANYFS_SB(inode->i_sb);
+	iblock = inode->i_size / (1 << fsi->blocksize);
+	if (inode->i_size % (1 << fsi->blocksize))
+		iblock++;
+	lanyfs_ext_truncate(inode->i_sb, lii->data, iblock);
+}
+
+/* lanyfs file inode operations */
+static const struct inode_operations lanyfs_file_inode_operations = {
+	.lookup		= lanyfs_lookup,
+	.setattr	= lanyfs_setattr,
+	.getattr	= lanyfs_getattr,
+	.truncate	= lanyfs_truncate,
+};
diff --git a/fs/lanyfs/lanyfs_km.c b/fs/lanyfs/lanyfs_km.c
new file mode 100644
index 0000000..d7bd4e0
--- /dev/null
+++ b/fs/lanyfs/lanyfs_km.c
@@ -0,0 +1,60 @@
+/*
+ * lanyfs_km.c - Lanyard Filesystem Kernel Module
+ *
+ * Copyright (C) 2012  Dan Luedtke <mail@danrl.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ */
+
+#include "lanyfs_km.h"
+
+/**
+ * lanyfs_init() - Initialize LanyFS module.
+ *
+ * Initializes the inode cache and registers the filesystem.
+ */
+static int __init lanyfs_init(void)
+{
+	int err;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	pr_info("lanyfs: register filesystem\n");
+	lanyfs_debug("debug=enabled");
+	err = lanyfs_inodecache_init();
+	if (err)
+		goto exit_err;
+	err = register_filesystem(&lanyfs_file_system_type);
+	if (err)
+		goto exit_ino;
+	return 0;
+
+exit_ino:
+	lanyfs_inodecache_destroy();
+exit_err:
+	pr_err("lanyfs: register filesystem failed\n");
+	return err;
+}
+
+/**
+ * lanyfs_exit() - Exit LanyFS module.
+ *
+ * Takes care of destroying inode cache and unregistering the filesystem.
+ */
+static void __exit lanyfs_exit(void)
+{
+	lanyfs_debug_function(__FILE__, __func__);
+	pr_info("lanyfs: unregister filesystem\n");
+
+	lanyfs_inodecache_destroy();
+	unregister_filesystem(&lanyfs_file_system_type);
+}
+
+module_init(lanyfs_init);
+module_exit(lanyfs_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Dan Luedtke <mail@danrl.de>");
+MODULE_DESCRIPTION("Lanyard Filesystem (LanyFS)");
diff --git a/fs/lanyfs/lanyfs_km.h b/fs/lanyfs/lanyfs_km.h
new file mode 100644
index 0000000..9c4bd07
--- /dev/null
+++ b/fs/lanyfs/lanyfs_km.h
@@ -0,0 +1,234 @@
+/*
+ * lanyfs_km.h - Lanyard Filesystem Header for Kernel Module
+ *
+ * Copyright (C) 2012  Dan Luedtke <mail@danrl.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ */
+
+#ifndef __LANYFS_KM_H_
+#define __LANYFS_KM_H_
+
+#include <linux/module.h>
+#include <linux/slab.h>		/* kmemcache */
+#include <linux/types.h>
+#include <linux/fs.h>
+#include <linux/buffer_head.h>
+#include <linux/magic.h>	/* LANYFS_SUPER_MAGIC */
+#include <linux/writeback.h>	/* current_uid() etc. */
+#include <linux/parser.h>	/* mount option parser */
+#include <linux/blkdev.h>	/* issue discard */
+#include <linux/statfs.h>	/* struct kstatfs */
+#include <linux/seq_file.h>	/* seq_puts() */
+#include <linux/namei.h>	/* struct nameidata */
+#include <linux/spinlock.h>
+
+#include "lanyfs_lnx.h"		/* kernel space data structures */
+
+/*
+ * error codes
+ * lanyfs uses standard error codes whenever possible
+ */
+#define LANYFS_ERRNO_BASE	2050
+#define LANYFS_EPROTECTED	(LANYFS_ERRNO_BASE + 0)
+#define LANYFS_ENOEMPTY		(LANYFS_ERRNO_BASE + 1)
+#define LANYFS_ENOTAKEN		(LANYFS_ERRNO_BASE + 2)
+
+/* messaging */
+#define lanyfs_info(sb, fmt, ...)					\
+	{								\
+		if (sb)							\
+			pr_info("lanyfs (%s): " pr_fmt(fmt) "\n",	\
+				sb->s_id, ##__VA_ARGS__);		\
+	}
+#define lanyfs_err(sb, fmt, ...)					\
+	{								\
+		if (sb)							\
+			pr_err("lanyfs (%s): " pr_fmt(fmt) "\n",	\
+			       sb->s_id, ##__VA_ARGS__);		\
+	}
+#define lanyfs_warn(sb, fmt, ...)					\
+	{								\
+		if (sb)							\
+			pr_warn("lanyfs (%s): " pr_fmt(fmt) "\n",	\
+				sb->s_id, ##__VA_ARGS__);		\
+	}
+
+/* debug messaging */
+#ifdef LANYFS_DEBUG
+#define lanyfs_debug(fmt, ...)						\
+	printk(KERN_DEBUG "lanyfs: " pr_fmt(fmt) "\n", ##__VA_ARGS__)
+#else
+#define lanyfs_debug(fmt, ...)						\
+	do { } while (0)
+#endif /* !LANYFS_DEBUG */
+
+/**
+ * typedef lanyfs_blk_t - the address of a logical block
+ *
+ * Every time you typedef without need, a kitten dies somewhere!
+ * However, sector_t assumes 512-byte sectors and blkcnt_t is for the number
+ * of total blocks. Please eliminate this typedef if you find a reasonable type.
+ * May equal sector in some configurations, so basically it is like sector_t,
+ * but not the same.
+ */
+typedef u64 lanyfs_blk_t;
+
+/**
+ * struct lanyfs_opts - mount options
+ * @uid:			userid of all files and directories
+ * @gid:			grouid of all files and direcotries
+ * @dmask:			directory mask
+ * @fmask:			file mask
+ * @discard:			issue discard requests on block freeing
+ * @flush:			force instant writing of changed data
+ */
+struct lanyfs_opts {
+	uid_t			uid;
+	gid_t			gid;
+	unsigned int		dmask;
+	unsigned int		fmask;
+	unsigned int		discard:1,
+				flush:1;
+};
+
+/**
+ * struct lanyfs_fsi - filesystem private data
+ * @blocksize:			blocksize (exponent to base 2)
+ * @addrlen:			address length in bytes
+ * @rootdir:			address of root directory
+ * @blocks:			number of good blocks on the device
+ * @freehead:			address of first extender for free blocks
+ * @freetail:			address of last extender for free blocks
+ * @freeblocks:			number of free blocks
+ * @updated:			date and time of last superblock field change
+ * @chainmax:			maximum number of slots per chain block
+ * @extmax:			maximum number of slots per extender block
+ * @opts:			mount options
+ * @lock:			spinlock for filesystem private data
+ *
+ * Elements @freehead, @freetail, @blocks, @freeblocks, and @updated will be
+ * written back to disk on change or when VFS is syncing superblocks.
+ * Other elements are informational and must not be changed, but even if
+ * changed, their values won't be written back to disk.
+ */
+struct lanyfs_fsi {
+	unsigned int		blocksize;
+	unsigned int		addrlen;
+	lanyfs_blk_t		rootdir;
+	lanyfs_blk_t		blocks;
+	lanyfs_blk_t		freehead;
+	lanyfs_blk_t		freetail;
+	lanyfs_blk_t		freeblocks;
+	struct timespec		updated;
+	unsigned int		chainmax;
+	unsigned int		extmax;
+	struct lanyfs_opts	opts;
+	spinlock_t		lock;
+};
+
+/**
+ * struct lanyfs_lii - inode private data
+ * @left:			address of left node of binary tree
+ * @right:			address of right node of binary tree
+ * @subtree:			binary tree root (directory only)
+ * @data:			address of first extender (file only)
+ * @created:			directory or file creation time
+ * @name:			directory or file name
+ * @len:			length of directory or file name
+ * @vfs_inode:			virtual filesystem inode
+ * @lock:			spinlock for inode private data
+ *
+ * Field @created is not synced back to disk, even if changed.
+ *
+ * We could save up to 8 byte of memory per inode if we union @subtree and
+ * @data, but then we must distinct between directory and file when destroying
+ * inode private data. Maybe later :)
+ */
+struct lanyfs_lii {
+	lanyfs_blk_t		left;
+	lanyfs_blk_t		right;
+	union {
+		lanyfs_blk_t	subtree;	/* directory only */
+		lanyfs_blk_t	data;		/* file only */
+	};
+	struct timespec		created;
+	char			name[LANYFS_NAME_LENGTH];
+	unsigned int		len;
+	struct inode		vfs_inode;
+	spinlock_t		lock;
+};
+
+/* msg.c */
+extern void lanyfs_debug_function(const char *, const char *);
+extern void lanyfs_debug_ts(const char *, struct lanyfs_ts *);
+extern void lanyfs_debug_block(union lanyfs_b *);
+
+/* misc.c */
+extern void lanyfs_time_lts_now(struct lanyfs_ts *);
+extern void lanyfs_time_kts_to_lts(struct timespec *, struct lanyfs_ts *);
+extern void lanyfs_time_lts_to_kts(struct lanyfs_ts *, struct timespec *);
+extern void lanyfs_time_poke_inode(struct inode *);
+extern void lanyfs_time_sync_inode(struct inode *);
+extern umode_t lanyfs_attr_to_mode(struct super_block *, u16, umode_t);
+extern u16 lanyfs_mode_to_attr(mode_t, u16);
+
+/* icache.c */
+extern struct lanyfs_lii *LANYFS_I(struct inode *);
+extern int lanyfs_inodecache_init(void);
+extern void lanyfs_inodecache_destroy(void);
+extern struct inode *lanyfs_alloc_inode(struct super_block *);
+extern void lanyfs_destroy_inode(struct inode *);
+
+/* inode.c */
+extern void lanyfs_inode_poke(struct inode *inode);
+extern void lanyfs_inode_rename(struct inode *inode, const char *name);
+extern struct inode *lanyfs_iget(struct super_block *sb, lanyfs_blk_t ino);
+extern struct dentry *lanyfs_lookup(struct inode *dir, struct dentry *dentry,
+				    unsigned int flags);
+extern int lanyfs_write_inode(struct inode *inode,
+			      struct writeback_control *wbc);
+
+/* btree.c */
+extern int lanyfs_btree_add_inode(struct inode *dir, struct inode *rookie);
+extern int lanyfs_btree_del_inode(struct inode *dir, const char *name);
+extern struct inode *lanyfs_btree_lookup(struct inode *dir, const char *name);
+extern void lanyfs_btree_clear_inode(struct inode *inode);
+
+/* dir.c */
+extern const struct file_operations lanyfs_dir_operations;
+extern const struct inode_operations lanyfs_dir_inode_operations;
+
+/* extender.c */
+extern int lanyfs_ext_iblock(struct super_block *sb, lanyfs_blk_t addr,
+			     lanyfs_blk_t iblock, lanyfs_blk_t *res);
+extern int lanyfs_ext_truncate(struct super_block *sb, lanyfs_blk_t addr,
+			       lanyfs_blk_t iblock);
+extern lanyfs_blk_t lanyfs_ext_create(struct super_block *sb,
+				      unsigned short level);
+extern int lanyfs_ext_grow(struct super_block *sb, lanyfs_blk_t *addr);
+
+/* file.c */
+extern const struct address_space_operations lanyfs_address_space_operations;
+extern const struct file_operations lanyfs_file_operations;
+
+/* chain.c */
+extern int lanyfs_chain_set_next(struct super_block *sb, lanyfs_blk_t addr,
+				 lanyfs_blk_t next);
+extern int lanyfs_chain_create(struct super_block *sb, lanyfs_blk_t addr);
+extern int lanyfs_chain_pop(struct super_block *sb, lanyfs_blk_t addr,
+			    lanyfs_blk_t *res);
+extern int lanyfs_chain_push(struct super_block *sb, lanyfs_blk_t addr,
+			     lanyfs_blk_t rookie);
+
+/* super.c */
+extern struct lanyfs_fsi *LANYFS_SB(struct super_block *sb);
+extern lanyfs_blk_t lanyfs_enslave(struct super_block *sb);
+extern int lanyfs_release(struct super_block *sb, lanyfs_blk_t addr);
+extern const struct super_operations lanyfs_super_operations;
+extern struct file_system_type lanyfs_file_system_type;
+
+#endif /* __LANYFS_KM_H_ */
diff --git a/fs/lanyfs/lanyfs_lnx.h b/fs/lanyfs/lanyfs_lnx.h
new file mode 100644
index 0000000..5c670e7
--- /dev/null
+++ b/fs/lanyfs/lanyfs_lnx.h
@@ -0,0 +1,306 @@
+/*
+ * lanyfs_lnx.h - Lanyard Filesystem Header for Linux Kernel
+ *
+ * Copyright (C) 2012  Dan Luedtke <mail@danrl.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ */
+
+#ifndef __LANYFS_LNX_H_
+#define __LANYFS_LNX_H_
+
+/* filesystem version */
+#define LANYFS_MAJOR_VERSION	1
+#define LANYFS_MINOR_VERSION	4
+
+/* important numbers */
+#define LANYFS_SUPERBLOCK	0	/* address of on-disk superblock */
+#define LANYFS_MIN_ADDRLEN	1	/* mimimun address length (in bytes) */
+#define LANYFS_MAX_ADDRLEN	8	/* maximum address length (in bytes) */
+#define LANYFS_MIN_BLOCKSIZE	9	/* mimimun blocksize 2**9 */
+#define LANYFS_MAX_BLOCKSIZE	12	/* maximum blocksize 2**12 */
+#define LANYFS_NAME_LENGTH	256	/* maximum length of label/name */
+
+/* block type identifiers */
+#define LANYFS_TYPE_DIR		0x10
+#define LANYFS_TYPE_FILE	0x20
+#define LANYFS_TYPE_CHAIN	0x70
+#define LANYFS_TYPE_EXT		0x80
+#define LANYFS_TYPE_SB		0xD0
+
+/* directory and file attributes */
+#define LANYFS_ATTR_NOWRITE	(1<<0)
+#define LANYFS_ATTR_NOEXEC	(1<<1)
+#define LANYFS_ATTR_HIDDEN	(1<<2)
+#define LANYFS_ATTR_ARCHIVE	(1<<3)
+
+/**
+ * struct lanyfs_ts - ISO8601-like LanyFS timestamp
+ * @year:			gregorian year (0 to 9999)
+ * @mon:			month of year (1 to 12)
+ * @day:			day of month (1 to 31)
+ * @hour:			hour of day (0 to 23)
+ * @min:			minute of hour (0 to 59)
+ * @sec:			second of minute (0 to 59 normal, 0 to 60 if
+ *				leap second)
+ * @__reserved_0:		reserved
+ * @nsec:			nanosecond (0 to 10^9)
+ * @offset:			signed UTC offset in minutes
+ * @__reserved_1:		reserved
+ */
+struct lanyfs_ts {
+	__le16			year;
+	__u8			mon;
+	__u8			day;
+	__u8			hour;
+	__u8			min;
+	__u8			sec;
+	unsigned char		__reserved_0[1];
+	__le32			nsec;
+	__s16			offset;
+	unsigned char		__reserved_1[2];
+};
+
+/**
+ * struct lanyfs_raw - LanyFS raw block
+ * @type:			identifies the blocks purpose
+ * @__reserved_0:		reserved
+ * @wrcnt:			write counter
+ * @data:			first byte of data
+ */
+struct lanyfs_raw {
+	__u8			type;
+	unsigned char		__reserved_0;
+	__le16			wrcnt;
+	unsigned char		data;
+};
+
+/**
+ * struct lanyfs_sb - LanyFS superblock
+ * @type:			identifies the blocks purpose
+ * @__reserved_0:		reserved
+ * @wrcnt:			write counter
+ * @major:			major version of filesystem
+ * @__reserved_1:		reserved
+ * @minor:			minor version of filesystem
+ * @__reserved_2:		reserved
+ * @magic:			identifies the filesystem
+ * @blocksize:			blocksize (exponent to base 2)
+ * @__reserved_3:		reserved
+ * @addrlen:			length of block addresses in bytes
+ * @__reserved_4:		reserved
+ * @rootdir:			address of root directory block
+ * @blocks:			number of blocks on the device
+ * @freehead:			start of free blocks chain
+ * @freetail:			end of free blocks chain
+ * @freeblocks:			number of free blocks
+ * @created:			date and time of filesystem creation
+ * @updated:			date and time of last superblock field change
+ * @checked:			date and time of last successful filesystem
+ *				check
+ * @badblocks:			start of bad blocks chain
+ * @__reserved_5:		reserved
+ * @label:			optional label for the filesystem
+ */
+struct lanyfs_sb {
+	__u8			type;
+	unsigned char		__reserved_0;
+	__le16			wrcnt;
+	__le32			magic;
+	__u8			major;
+	unsigned char		__reserved_1;
+	__u8			minor;
+	unsigned char		__reserved_2;
+	__u8			blocksize;
+	unsigned char		__reserved_3;
+	__u8			addrlen;
+	unsigned char		__reserved_4;
+	__le64			rootdir;
+	__le64			blocks;
+	__le64			freehead;
+	__le64			freetail;
+	__le64			freeblocks;
+	struct lanyfs_ts	created;
+	struct lanyfs_ts	updated;
+	struct lanyfs_ts	checked;
+	__le64			badblocks;
+	unsigned char		__reserved_5[8];
+	char			label[LANYFS_NAME_LENGTH];
+};
+
+/**
+ * struct lanyfs_btree - binary tree components
+ * @left:			address of left node of binary tree
+ * @right:			address of right node of binary tree
+ */
+struct lanyfs_btree {
+	__le64			left;
+	__le64			right;
+};
+
+/**
+ * struct lanyfs_vi_btree - aligned binary tree components
+ * @__padding_0:		padding
+ * @left:			address of left node of binary tree
+ * @right:			address of right node of binary tree
+ *
+ * Used to access binary tree components independent from underlying block type.
+ * This creates a virtual block.
+ */
+struct lanyfs_vi_btree	{
+	unsigned char		__padding_0[8];
+	__le64			left;
+	__le64			right;
+};
+
+/**
+ * struct lanyfs_meta - lanyfs metadata
+ * @created:			date and time of creation
+ * @modified:			date and time of last modification
+ * @__reserved_0:		reserved
+ * @attr:			directory or file attributes
+ * @name:			name of file or directory
+ */
+struct lanyfs_meta {
+	struct lanyfs_ts	created;
+	struct lanyfs_ts	modified;
+	unsigned char		__reserved_0[14];
+	__le16			attr;
+	char			name[LANYFS_NAME_LENGTH];
+};
+
+/**
+ * struct lanyfs_vi_meta - aligned lanyfs metadata
+ * @__padding_0:		padding
+ * @created:			date and time of creation
+ * @modified:			date and time of last modification
+ * @__reserved_0:		reserved
+ * @attr:			directory or file attributes
+ * @name:			name of file or directory
+ *
+ * Used to access meta data independent from underlying block type.
+ * This creates a virtual block.
+ */
+struct lanyfs_vi_meta	{
+	unsigned char		__padding_0[56];
+	struct lanyfs_ts	created;
+	struct lanyfs_ts	modified;
+	unsigned char		__reserved_0[14];
+	__le16			attr;
+	unsigned char		name[LANYFS_NAME_LENGTH];
+};
+
+/**
+ * struct lanyfs_dir - LanyFS directory block
+ * @type:			identifies the blocks purpose
+ * @__reserved_0:		reserved
+ * @wrcnt:			write counter
+ * @__reserved_1:		reserved
+ * @btree:			binary tree components
+ * @subtree:			binary tree root of directory's contents
+ * @__reserved_2:		reserved
+ * @meta:			directory metadata
+ */
+struct lanyfs_dir {
+	__u8			type;
+	unsigned char		__reserved_0;
+	__le16			wrcnt;
+	unsigned char		__reserved_1[4];
+	struct lanyfs_btree	btree;
+	__le64			subtree;
+	unsigned char		__reserved_2[24];
+	struct lanyfs_meta	meta;
+};
+
+/**
+ * struct lanyfs_file - LanyFS file block
+ * @type:			identifies the blocks purpose
+ * @__reserved_0:		reserved
+ * @wrcnt:			write counter
+ * @__reserved_1:		reserved
+ * @btree:			binary tree components
+ * @data:			address of extender for data blocks
+  * @size:			size of file in bytes
+ * @__reserved_2:		reserved
+ * @meta:			file metadata
+ */
+struct lanyfs_file {
+	__u8			type;
+	unsigned char		__reserved_0;
+	__le16			wrcnt;
+	unsigned char		__reserved_1[4];
+	struct lanyfs_btree	btree;
+	__le64			data;
+	__le64			size;
+	unsigned char		__reserved_2[16];
+	struct lanyfs_meta	meta;
+};
+
+/**
+ * struct lanyfs_chain - LanyFS chain block (size-independent)
+ * @type:			identifies the blocks purpose
+ * @__reserved_0:		reserved
+ * @wrcnt:			write counter
+ * @__reserved_1:		reserved
+ * @next:			address of next chain block
+ * @stream:			start of block address stream
+ */
+struct lanyfs_chain {
+	__u8			type;
+	unsigned char		__reserved_0;
+	__le16			wrcnt;
+	unsigned char		__reserved_1[4];
+	__le64			next;
+	unsigned char		stream;
+};
+
+/**
+ * struct lanyfs_ext - LanyFS extender block (size-independent)
+ * @type:			identifies the blocks purpose
+ * @__reserved_0:		reserved
+ * @wrcnt:			write counter
+ * @level:			depth of indirection
+ * @stream:			start of block address stream
+ */
+struct lanyfs_ext {
+	__u8			type;
+	unsigned char		__reserved_0;
+	__le16			wrcnt;
+	__u8			level;
+	unsigned char		stream;
+};
+
+/**
+ * struct lanyfs_data - LanyFS data block
+ * @stream:			start of data stream
+ */
+struct lanyfs_data {
+	unsigned char		stream;
+};
+
+/** union lanyfs_b - lanyfs block
+ * @raw:			raw block
+ * @sb:				superblock
+ * @dir:			directory block
+ * @file:			file block
+ * @ext:			extender block
+ * @data:			data block
+ * @vi_btree:			binary tree virtual block
+ * @vi_meta:			metadata virtual block
+ */
+union lanyfs_b {
+	struct lanyfs_raw	raw;
+	struct lanyfs_sb	sb;
+	struct lanyfs_dir	dir;
+	struct lanyfs_file	file;
+	struct lanyfs_chain	chain;
+	struct lanyfs_ext	ext;
+	struct lanyfs_data	data;
+	struct lanyfs_vi_btree	vi_btree;
+	struct lanyfs_vi_meta	vi_meta;
+};
+
+#endif /* __LANYFS_LNX_H */
diff --git a/fs/lanyfs/misc.c b/fs/lanyfs/misc.c
new file mode 100644
index 0000000..fcb1238
--- /dev/null
+++ b/fs/lanyfs/misc.c
@@ -0,0 +1,129 @@
+/*
+ * misc.c - Lanyard Filesystem Miscellaneous Operations
+ *
+ * Copyright (C) 2012  Dan Luedtke <mail@danrl.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ */
+
+#include "lanyfs_km.h"
+
+/* --- time ----------------------------------------------------------------- */
+
+/**
+ * lanyfs_time_lts_to_kts() - Converts LanyFS timestamp to Kernel timespec.
+ * @lts:			lanyfs timestamp (source)
+ * @kts:			kernel timespec (target)
+ *
+ * WARNING: This function will overflow on 2106-02-07 06:28:16 on
+ * machines where long is only 32-bit! Replace mktime() before that date!
+ */
+void lanyfs_time_lts_to_kts(struct lanyfs_ts *lts, struct timespec *kts)
+{
+	lanyfs_debug_function(__FILE__, __func__);
+
+	kts->tv_sec = mktime(le16_to_cpu(lts->year), lts->mon, lts->day,
+			     lts->hour, lts->min, lts->sec);
+	kts->tv_sec += le16_to_cpu(lts->offset) * 60;
+	kts->tv_nsec = le32_to_cpu(lts->nsec);
+}
+
+/**
+ * lanyfs_time_kts_to_lts() - Converts Kernel timespec to LanyFS timestamp.
+ * @kts:			kernel timespec (source)
+ * @lts:			lanyfs timestamp (target)
+ *
+ * Depends on global variable 'sys_tz' of type 'timezone'.
+ */
+void lanyfs_time_kts_to_lts(struct timespec *kts, struct lanyfs_ts *lts)
+{
+	struct tm tm;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	time_to_tm(kts->tv_sec, 0, &tm);
+	lts->year = cpu_to_le16(tm.tm_year + 1900);
+	lts->mon = tm.tm_mon + 1;
+	lts->day = tm.tm_mday;
+	lts->hour = tm.tm_hour;
+	lts->min = tm.tm_min;
+	lts->sec = tm.tm_sec;
+	lts->nsec = cpu_to_le32(kts->tv_nsec);
+	lts->offset = cpu_to_le16(sys_tz.tz_minuteswest * -1);
+}
+
+/**
+ * lanyfs_time_lts_now() - Convert current time to LanyFS timestamp.
+ * @lts:			lanyfs timestamp (target)
+ */
+void lanyfs_time_lts_now(struct lanyfs_ts *lts)
+{
+	struct timespec now;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	now = current_kernel_time();
+	lanyfs_time_kts_to_lts(&now, lts);
+}
+
+/**
+ * lanyfs_time_sync_inode() - Syncs inode's timestamps.
+ * @inode:			inode to sync
+ *
+ * All times (atime, mtime, ctime) will be set to the latest timestamp.
+ */
+void lanyfs_time_sync_inode(struct inode *inode)
+{
+	if (!inode)
+		return;
+	if (timespec_compare(&inode->i_mtime, &inode->i_ctime) > 0)
+		inode->i_ctime = inode->i_mtime;
+	else
+		inode->i_mtime = inode->i_ctime;
+	if (timespec_compare(&inode->i_atime, &inode->i_mtime) > 0)
+		inode->i_mtime = inode->i_ctime = inode->i_atime;
+	else
+		inode->i_atime = inode->i_mtime;
+}
+
+/* --- mode ----------------------------------------------------------------- */
+
+/**
+ * lanyfs_attr_to_mode() - Converts LanyFS metadata attributes to unix mode.
+ * @sb:				superblock
+ * @attr:			lanyfs metadata attributes
+ * @t:				type of file (S_IFDIR, S_IFREG)
+ */
+umode_t lanyfs_attr_to_mode(struct super_block *sb, u16 attr, umode_t t)
+{
+	umode_t mode;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	mode = S_IRWXUGO;
+	if (attr & LANYFS_ATTR_NOWRITE)
+		mode &= ~S_IWUGO;
+	if (attr & LANYFS_ATTR_NOEXEC)
+		mode &= ~S_IXUGO;
+	if (t == S_IFDIR)
+		mode &= ~LANYFS_SB(sb)->opts.dmask;
+	else if (t == S_IFREG)
+		mode &= ~LANYFS_SB(sb)->opts.fmask;
+	return mode | t;
+}
+
+/**
+ * lanyfs_mode_to_attr() - Convert unix mode to LanyFS metadata attributes.
+ * @mode:			mode to convert
+ * @base:			lanyfs metadata attributes to preserve
+ */
+inline u16 lanyfs_mode_to_attr(mode_t mode, u16 base)
+{
+	lanyfs_debug_function(__FILE__, __func__);
+
+	if (!(mode & S_IWUGO))
+		base |= LANYFS_ATTR_NOWRITE;
+	if (!(mode & S_IXUGO))
+		base |= LANYFS_ATTR_NOEXEC;
+	return base;
+}
diff --git a/fs/lanyfs/msg.c b/fs/lanyfs/msg.c
new file mode 100644
index 0000000..2d7212e
--- /dev/null
+++ b/fs/lanyfs/msg.c
@@ -0,0 +1,99 @@
+/*
+ * msg.c - Lanyard Filesystem Log Message Handling
+ *
+ * Copyright (C) 2012  Dan Luedtke <mail@danrl.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ */
+
+#include "lanyfs_km.h"
+
+/**
+ * lanyfs_debug_function() - Prints the currents function name and file.
+ * @file:			file name
+ * @func:			function name
+ *
+ * Produces call traces that help debugging a lot.
+ */
+void lanyfs_debug_function(const char *file, const char *func)
+{
+	/* reverse order of arguments is intended */
+	lanyfs_debug("%s (%s)", func, file);
+}
+
+/**
+ * lanyfs_debug_ts() - Prints human readable LanyFS timestamp.
+ * @lts:			timestamp
+ * @desc:			description
+ */
+void lanyfs_debug_ts(const char *desc, struct lanyfs_ts *lts)
+{
+	lanyfs_debug("%s=%04u-%02u-%02uT%02u:%02u:%02u.%u%+03d:%02ld",
+		     desc, le16_to_cpu(lts->year), lts->mon, lts->day,
+		     lts->hour, lts->min, lts->sec, lts->nsec,
+		     lts->offset / 60, abs(lts->offset % 60));
+}
+
+/**
+ * lanyfs_debug_block() - Prints block's type and content.
+ * @b:				block
+ *
+ * This is probably the most useful debug function. Use it to dump blocks
+ * whenever you are unsure of its contents. It will slow down the
+ * filesystem, though.
+ */
+void lanyfs_debug_block(union lanyfs_b *b)
+{
+	lanyfs_debug("dumping block at %p", b);
+	lanyfs_debug("type=0x%x", b->raw.type);
+	lanyfs_debug("wrcnt=%u", le16_to_cpu(b->raw.wrcnt));
+	/* sb */
+	if (b->raw.type == LANYFS_TYPE_SB) {
+		lanyfs_debug("magic=0x%x", le32_to_cpu(b->sb.magic));
+		lanyfs_debug("major_version=%u", b->sb.major);
+		lanyfs_debug("minor_version=%u", b->sb.minor);
+		lanyfs_debug("address_length=%u", b->sb.addrlen);
+		lanyfs_debug("blocksize=%u", b->sb.blocksize);
+		lanyfs_debug("root_directory=%llu", le64_to_cpu(b->sb.rootdir));
+		lanyfs_debug("total_blocks=%llu", le64_to_cpu(b->sb.blocks));
+		lanyfs_debug("free_head=%llu", le64_to_cpu(b->sb.freehead));
+		lanyfs_debug("free_tail=%llu", le64_to_cpu(b->sb.freetail));
+		lanyfs_debug("free_blocks=%llu", le64_to_cpu(b->sb.freeblocks));
+		lanyfs_debug_ts("created", &b->sb.created);
+		lanyfs_debug_ts("checked", &b->sb.checked);
+		lanyfs_debug_ts("updated", &b->sb.updated);
+		lanyfs_debug("volume_label=%s", b->sb.label);
+	}
+	/* chain */
+	if (b->raw.type == LANYFS_TYPE_CHAIN)
+		lanyfs_debug("next=%llu", le64_to_cpu(b->chain.next));
+	/* extender */
+	if (b->raw.type == LANYFS_TYPE_EXT)
+		lanyfs_debug("level=%u", b->ext.level);
+	/* btree */
+	if (b->raw.type == LANYFS_TYPE_DIR ||
+	    b->raw.type == LANYFS_TYPE_FILE) {
+		lanyfs_debug("btree_left=%llu", le64_to_cpu(b->vi_btree.left));
+		lanyfs_debug("btree_right=%llu",
+			     le64_to_cpu(b->vi_btree.right));
+	}
+	/* file */
+	if (b->raw.type == LANYFS_TYPE_FILE) {
+		lanyfs_debug("data=%llu", le64_to_cpu(b->file.data));
+		lanyfs_debug("size=%llu", le64_to_cpu(b->file.size));
+	}
+	/* dir */
+	if (b->raw.type == LANYFS_TYPE_DIR)
+		lanyfs_debug("subtree=%llu", le64_to_cpu(b->dir.subtree));
+	/* meta */
+	if (b->raw.type == LANYFS_TYPE_DIR ||
+	    b->raw.type == LANYFS_TYPE_FILE) {
+		lanyfs_debug_ts("meta_created", &b->vi_meta.created);
+		lanyfs_debug_ts("meta_modified", &b->vi_meta.modified);
+		lanyfs_debug("meta_attr=%u", le16_to_cpu(b->vi_meta.attr));
+		lanyfs_debug("meta_name=%s", b->vi_meta.name);
+	}
+}
diff --git a/fs/lanyfs/super.c b/fs/lanyfs/super.c
new file mode 100644
index 0000000..aa6c14b
--- /dev/null
+++ b/fs/lanyfs/super.c
@@ -0,0 +1,549 @@
+/*
+ * super.c - Lanyard Filesystem Superblock Operations
+ *
+ * Copyright (C) 2012  Dan Luedtke <mail@danrl.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ */
+
+#include "lanyfs_km.h"
+
+/**
+ * LANYFS_SB() - Returns pointer to filesystem private data.
+ * @sb:				superblock
+ */
+struct lanyfs_fsi *LANYFS_SB(struct super_block *sb)
+{
+	/*
+	 * Disabled by default, it produces a lot of noise.
+	 * lanyfs_debug_function(__FILE__, __func__);
+	 */
+	return (struct lanyfs_fsi *) sb->s_fs_info;
+}
+
+/* --- mount options -------------------------------------------------------- */
+
+enum {
+	Opt_uid,
+	Opt_gid,
+	Opt_dmask,
+	Opt_fmask,
+	Opt_discard,
+	Opt_nodiscard,
+	Opt_flush,
+	Opt_noflush,
+	Opt_err
+};
+
+static const match_table_t lanyfs_super_tokens = {
+	{Opt_uid,		"uid=%u"},
+	{Opt_gid,		"gid=%u"},
+	{Opt_dmask,		"dmask=%u"},
+	{Opt_fmask,		"fmask=%u"},
+	{Opt_discard,		"discard"},
+	{Opt_nodiscard,		"nodiscard"},
+	{Opt_flush,		"flush"},
+	{Opt_noflush,		"noflush"},
+	{Opt_err,		NULL}
+};
+
+/**
+ * lanyfs_super_options() - Parses and saves mount options.
+ * @sb:				superblock
+ * @data:			mount options raw data string
+ * @silent:			whether or not to be silent on error
+ */
+static int lanyfs_super_options(struct super_block *sb, char *data, int silent)
+{
+	struct lanyfs_opts *opts;
+	char *p;
+	substring_t args[MAX_OPT_ARGS];
+	int option;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	opts = &(LANYFS_SB(sb)->opts);
+
+	/* defaults */
+	opts->uid = current_uid();
+	opts->uid = current_gid();
+	opts->dmask = 0;
+	opts->fmask = 0;
+	opts->discard = 0;
+	opts->flush = 0;
+
+	/* no options given */
+	if (!data)
+		goto exit_ok;
+
+	/* parse and apply given options */
+	while ((p = strsep(&data, ",")) != NULL) {
+		if (!*p)
+			continue;
+		switch (match_token(p, lanyfs_super_tokens, args)) {
+		case Opt_uid:
+			if (match_int(&args[0], &option))
+				goto exit_invalid;
+			opts->uid = option;
+			break;
+		case Opt_gid:
+			if (match_int(&args[0], &option))
+				goto exit_invalid;
+			opts->gid = option;
+			break;
+		case Opt_dmask:
+			if (match_int(&args[0], &option))
+				goto exit_invalid;
+			opts->dmask = option;
+			break;
+		case Opt_fmask:
+			if (match_int(&args[0], &option))
+				goto exit_invalid;
+			opts->fmask = option;
+			break;
+		case Opt_discard:
+			opts->discard = 1;
+			break;
+		case Opt_nodiscard:
+			opts->discard = 0;
+			break;
+		case Opt_flush:
+			opts->flush = 1;
+			break;
+		case Opt_noflush:
+			opts->flush = 0;
+			break;
+		default:
+			goto exit_invalid;
+			break;
+		}
+	}
+exit_ok:
+	lanyfs_debug("option_uid=%u", opts->uid);
+	lanyfs_debug("option_gid=%u", opts->gid);
+	lanyfs_debug("option_dmask=%u", opts->dmask);
+	lanyfs_debug("option_fmask=%u", opts->fmask);
+	lanyfs_debug("option_discard=%u", opts->discard);
+	lanyfs_debug("option_flush=%u", opts->flush);
+	return 0;
+exit_invalid:
+	if (!silent)
+		lanyfs_err(sb,
+			   "invalid mount option or bad parameter \"%s\"", p);
+	return -EINVAL;
+}
+
+/* --- superblock ----------------------------------------------------------- */
+
+/**
+ * lanyfs_super_sync() - Syncs the superblock to disk.
+ * @sb:				superblock
+ *
+ * This function does the same as old VFS write_super(), back in the days
+ * when VFS invoked the syncing by looking for ->sb_dirt every five seconds.
+ * Today this function is invoked by LanyFS itself whenever it seems reasonable.
+ */
+static void lanyfs_super_sync(struct super_block *sb)
+{
+	struct lanyfs_fsi *fsi;
+	struct buffer_head *bh;
+	struct lanyfs_sb *rawsb;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	fsi = LANYFS_SB(sb);
+	bh = sb_bread(sb, LANYFS_SUPERBLOCK);
+	if (!bh) {
+		lanyfs_err(sb, "error reading block #%llu",
+			   (u64) LANYFS_SUPERBLOCK);
+		return;
+	}
+	rawsb = (struct lanyfs_sb *) bh->b_data;
+	fsi->updated = current_kernel_time();
+	lock_buffer(bh);
+	le16_add_cpu(&rawsb->wrcnt, 1);
+	rawsb->freehead = cpu_to_le64(fsi->freehead);
+	rawsb->freetail = cpu_to_le64(fsi->freetail);
+	rawsb->freeblocks = cpu_to_le64(fsi->freeblocks);
+	/*
+	 * number of valid blocks is not synced back at the moment, but it may
+	 * as soon as a reliable badblocks-detection is implemented
+	 * lanysb->blocks = cpu_to_le64(fsi->blocks);
+	 */
+	lanyfs_time_kts_to_lts(&fsi->updated, &rawsb->updated);
+	unlock_buffer(bh);
+	mark_buffer_dirty(bh);
+	if (fsi->opts.flush)
+		sync_dirty_buffer(bh);
+	brelse(bh);
+}
+
+/**
+ * lanyfs_put_super() - Prepare the superblock for unmounting.
+ * @sb:				superblock
+ *
+ * This function is called by VFS with the superblock lock held.
+ */
+static void lanyfs_put_super(struct super_block *sb)
+{
+	lanyfs_debug_function(__FILE__, __func__);
+
+	lanyfs_super_sync(sb);
+	kfree(sb->s_fs_info);
+	sb->s_fs_info = NULL;
+}
+
+/**
+ * lanyfs_kill_super() - Safely closes the filesystem.
+ * @sb:				superblock
+ *
+ * Cleanup of filesystem private data is done in lanyfs_put_super().
+ */
+static void lanyfs_kill_super(struct super_block *sb)
+{
+	lanyfs_debug_function(__FILE__, __func__);
+
+	kill_block_super(sb);
+}
+
+
+/**
+ * lanyfs_fill_super() - Initialize the superblock.
+ * @sb:				superblock
+ * @options:			arbitrary mount options
+ * @silent:			whether or not to be silent on error
+ *
+ * This is the most important function for LanyFS since all device-specific
+ * configuration like address length and blocksize takes place here. It is also
+ * an implementation as close to the specifications as possible, thus serving
+ * as an example implementation for other operating systems or alternate kernel
+ * modules.
+ */
+static int lanyfs_fill_super(struct super_block *sb, void *options, int silent)
+{
+	struct lanyfs_fsi *fsi;
+	struct buffer_head *bh;
+	struct lanyfs_sb *lanysb;
+	struct inode *inode;
+	int err;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	inode = NULL;
+	err = 0;
+
+	/* allocate filesystem private data */
+	fsi = kzalloc(sizeof(*fsi), GFP_KERNEL);
+	if (!fsi)
+		return -ENOMEM;
+	spin_lock_init(&fsi->lock);
+	sb->s_fs_info = fsi;
+
+	/* set blocksize to minimum size for fetching superblock */
+	if (!sb_set_blocksize(sb, 1 << LANYFS_MIN_BLOCKSIZE)) {
+		if (!silent)
+			lanyfs_err(sb, "error setting blocksize to %d bytes",
+				   1 << LANYFS_MIN_BLOCKSIZE);
+		return -EIO;
+	}
+
+	/* fetch superblock */
+	bh = sb_bread(sb, LANYFS_SUPERBLOCK);
+	if (!bh) {
+		if (!silent)
+			lanyfs_err(sb, "error reading superblock");
+		return -EIO;
+	}
+	lanysb = (struct lanyfs_sb *) bh->b_data;
+
+	/* check magic */
+	if (lanysb->magic != cpu_to_le32(LANYFS_SUPER_MAGIC)) {
+		if (!silent)
+			lanyfs_info(sb, "bad magic 0x%x",
+				    lanysb->magic);
+		goto exit_invalid;
+	}
+	sb->s_magic = LANYFS_SUPER_MAGIC;
+
+	/* check block type */
+	if (lanysb->type != LANYFS_TYPE_SB) {
+		if (!silent)
+			lanyfs_err(sb, "bad block type 0x%x", lanysb->type);
+		goto exit_invalid;
+	}
+
+	/* check version */
+	if (lanysb->major > LANYFS_MAJOR_VERSION) {
+		if (!silent)
+			lanyfs_err(sb, "major version mismatch");
+		goto exit_invalid;
+	}
+
+	/* check address length */
+	if (lanysb->addrlen < LANYFS_MIN_ADDRLEN ||
+	    lanysb->addrlen > LANYFS_MAX_ADDRLEN) {
+		if (!silent)
+			lanyfs_err(sb, "unsupported address length");
+		goto exit_invalid;
+	}
+	fsi->addrlen = lanysb->addrlen;
+
+	/* check blocksize */
+	if (lanysb->blocksize < LANYFS_MIN_BLOCKSIZE ||
+	    lanysb->blocksize > LANYFS_MAX_BLOCKSIZE) {
+		if (!silent)
+			lanyfs_err(sb, "unsupported blocksize");
+		goto exit_invalid;
+	}
+	fsi->blocksize = lanysb->blocksize;
+
+	/* more filesystem private data */
+	fsi->rootdir = le64_to_cpu(lanysb->rootdir);
+	fsi->freehead = le64_to_cpu(lanysb->freehead);
+	fsi->freetail = le64_to_cpu(lanysb->freehead);
+	fsi->freeblocks = le64_to_cpu(lanysb->freeblocks);
+	fsi->blocks = le64_to_cpu(lanysb->blocks);
+	fsi->chainmax = ((1 << fsi->blocksize) \
+			- offsetof(struct lanyfs_chain, stream)) / fsi->addrlen;
+	fsi->extmax = ((1 << fsi->blocksize) \
+		      - offsetof(struct lanyfs_ext, stream)) / fsi->addrlen;
+	lanyfs_time_lts_to_kts(&lanysb->updated, &fsi->updated);
+
+	/* superblock debug messages */
+	lanyfs_debug_block((union lanyfs_b *) bh->b_data);
+
+	/* release block buffer */
+	brelse(bh);
+
+	/* parse mount options */
+	save_mount_options(sb, options);
+	err = lanyfs_super_options(sb, (char *) options, silent);
+	if (err)
+		return err;
+
+	/* set blocksize to correct size */
+	if (!sb_set_blocksize(sb, 1 << fsi->blocksize)) {
+		if (!silent)
+			lanyfs_err(sb, "error setting blocksize to %d bytes",
+				   1 << fsi->blocksize);
+		return -EIO;
+	}
+	/* default flags */
+	sb->s_maxbytes = 0xffffffff; /* TODO: hmmmmm */
+	sb->s_op = &lanyfs_super_operations;
+	sb->s_time_gran = 1;
+	sb->s_flags = MS_NOSUID | MS_NOATIME | MS_NODIRATIME;
+
+	/* make root directory */
+	inode = lanyfs_iget(sb, fsi->rootdir);
+	if (!inode)
+		return -ENOMEM;
+
+	sb->s_root = d_make_root(inode);
+	if (!sb->s_root) {
+		iput(inode);
+		return -ENOMEM;
+	}
+	return 0;
+
+exit_invalid:
+	brelse(bh);
+	if (!silent)
+		lanyfs_info(sb, "no valid lanyard filesystem found");
+	return -EINVAL;
+}
+
+/**
+ * lanyfs_mount() - Mounts a LanyFS device.
+ * @fs_type:			describes the filesystem
+ * @flags:			mount flags
+ * @device_name:		the device name we are mounting
+ * @data:			arbitrary mount options
+ */
+static struct dentry *lanyfs_mount(struct file_system_type *fs_type, int flags,
+				   const char *device_name, void *data)
+{
+	lanyfs_debug_function(__FILE__, __func__);
+
+	return mount_bdev(fs_type, flags, device_name, data, lanyfs_fill_super);
+}
+
+/* --- free space management ------------------------------------------------ */
+
+/**
+ * lanyfs_enslave() - Picks a block from the free blocks pool.
+ * @sb:				superblock
+ *
+ * Returns zero on error, e.g. on ENOSPC.
+ */
+lanyfs_blk_t lanyfs_enslave(struct super_block *sb)
+{
+	struct lanyfs_fsi *fsi;
+	lanyfs_blk_t addr;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	fsi = LANYFS_SB(sb);
+	if (unlikely(!fsi->freehead || !fsi->freetail || !fsi->freeblocks))
+		return 0;
+
+	spin_lock(&fsi->lock);
+	switch (lanyfs_chain_pop(sb, fsi->freehead, &addr)) {
+	case -LANYFS_ENOTAKEN:
+		/* no occupied slot left, enslave chain block itself instead */
+		swap(addr, fsi->freehead);
+		if (addr == fsi->freetail)
+			fsi->freetail = fsi->freehead;
+		/* fall through */
+	case 0:
+		fsi->freeblocks--;
+		spin_unlock(&fsi->lock);
+		lanyfs_super_sync(sb);
+		lanyfs_debug("enslaved block #%llu on %s", addr, sb->s_id);
+		return addr;
+		break;
+	default:
+		spin_unlock(&fsi->lock);
+		break;
+	}
+	return 0;
+
+}
+
+/**
+ * lanyfs_release() - Returns a block to the free blocks pool.
+ * @sb:				superblock
+ * @addr:			address of block to be returned
+ *
+ * Blocks are literally recycled, blocks remain unused as long as possible to
+ * distribute write cycles all over the device.
+ */
+int lanyfs_release(struct super_block *sb, lanyfs_blk_t addr)
+{
+	struct lanyfs_fsi *fsi;
+	int err;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	if (!likely(addr))
+		return -LANYFS_EPROTECTED;
+
+	fsi = LANYFS_SB(sb);
+
+	/* device was full, released block becomes chain block */
+	if (unlikely(!fsi->freehead || !fsi->freetail || !fsi->freeblocks)) {
+		err = lanyfs_chain_create(sb, addr);
+		if (err)
+			goto exit_err;
+		spin_lock(&fsi->lock);
+		fsi->freehead = fsi->freetail = addr;
+		fsi->freeblocks = 0;
+		spin_unlock(&fsi->lock);
+		goto exit_ok;
+	}
+
+	/* append block to existing chain */
+	err = lanyfs_chain_push(sb, fsi->freetail, addr);
+	if (err == -LANYFS_ENOEMPTY) {
+		/* chain block was full, create a new one and append it */
+		err = lanyfs_chain_create(sb, addr);
+		if (err)
+			goto exit_err;
+		err = lanyfs_chain_set_next(sb, fsi->freetail, addr);
+		spin_lock(&fsi->lock);
+		fsi->freetail = addr;
+		spin_unlock(&fsi->lock);
+		goto exit_ok;
+	} else if (err) {
+		goto exit_err;
+	}
+exit_ok:
+	spin_lock(&fsi->lock);
+	fsi->freeblocks++;
+	spin_unlock(&fsi->lock);
+	lanyfs_super_sync(sb);
+	lanyfs_debug("released block #%llu on %s", addr, sb->s_id);
+	return 0;
+exit_err:
+	lanyfs_err(sb, "error freeing block #%llu", (u64) addr);
+	return err;
+}
+
+/* --- statistics ----------------------------------------------------------- */
+
+/**
+ * lanyfs_show_stats() - Eventually shows extended filesystem statistics.
+ * @m:				seq-file to write to
+ * @dentry:			root directory entry
+ *
+ * This function is still in development.
+ * Currently unknown: Where does the output (read: seq_file writes) of this
+ * function show up?
+ */
+static int lanyfs_show_stats(struct seq_file *m, struct dentry *dentry)
+{
+	lanyfs_debug_function(__FILE__, __func__);
+
+	seq_printf(m, "Can we try with real bullets now? (Mathilda)\n");
+	return 0;
+}
+
+/**
+ * lanyfs_statfs() - Provides filesystem statistics.
+ * @dentry:			directory entry
+ * @buf:			buffer for filesystem statistics
+ */
+static int lanyfs_statfs(struct dentry *dentry, struct kstatfs *buf)
+{
+	struct lanyfs_fsi *fsi;
+	u64 fsid;
+	lanyfs_debug_function(__FILE__, __func__);
+
+	fsi = LANYFS_SB(dentry->d_sb);
+	fsid = huge_encode_dev(dentry->d_sb->s_bdev->bd_dev);
+	buf->f_type = LANYFS_SUPER_MAGIC;
+	buf->f_bsize = 1 << fsi->blocksize;
+	buf->f_blocks = fsi->blocks;
+	buf->f_bfree = fsi->freeblocks;
+	buf->f_bavail = buf->f_bfree;
+	buf->f_files = fsi->blocks;
+	buf->f_ffree = fsi->freeblocks;
+	/* Nobody knows what f_fsid is supposed to contain, cp. statfs(2)! */
+	buf->f_fsid.val[0] = (u32) fsid;
+	buf->f_fsid.val[1] = (u32) (fsid >> 32);
+	buf->f_namelen = LANYFS_NAME_LENGTH;
+	return 0;
+}
+
+/* --- vfs interface -------------------------------------------------------- */
+
+/* lanyfs filesystem type */
+struct file_system_type lanyfs_file_system_type = {
+	.name			= "lanyfs",
+	.fs_flags		= FS_REQUIRES_DEV,
+	.mount			= lanyfs_mount,
+	.kill_sb		= lanyfs_kill_super,
+	.owner			= THIS_MODULE,
+};
+
+/* lanyfs superblock operations */
+const struct super_operations lanyfs_super_operations = {
+	.alloc_inode		= lanyfs_alloc_inode,
+	.destroy_inode		= lanyfs_destroy_inode,
+	.dirty_inode		= NULL,
+	.write_inode		= lanyfs_write_inode,
+	.drop_inode		= generic_drop_inode, /* generic is fine */
+	.evict_inode		= NULL,
+	.put_super		= lanyfs_put_super,
+	.sync_fs		= NULL,
+	.freeze_fs		= NULL, /* for LVM */
+	.unfreeze_fs		= NULL, /* for LVM */
+	.statfs			= lanyfs_statfs,
+	.remount_fs		= NULL,
+	.umount_begin		= NULL,
+	.show_options		= generic_show_options, /* generic is fine */
+	.show_devname		= NULL, /* default is fine for lanyfs */
+	.show_path		= NULL, /* default is fine for lanyfs */
+	.show_stats		= lanyfs_show_stats,
+	.bdev_try_to_free_page	= NULL,
+	.nr_cached_objects	= NULL, /* for sb cache shrinking */
+	.free_cached_objects	= NULL, /* for sb cache shrinking */
+};
diff --git a/include/linux/magic.h b/include/linux/magic.h
index e15192c..6569ee3 100644
--- a/include/linux/magic.h
+++ b/include/linux/magic.h
@@ -27,6 +27,7 @@
 #define ISOFS_SUPER_MAGIC	0x9660
 #define JFFS2_SUPER_MAGIC	0x72b6
 #define PSTOREFS_MAGIC		0x6165676C
+#define LANYFS_SUPER_MAGIC	0x594e414c	/* le16 LANY */
 
 #define MINIX_SUPER_MAGIC	0x137F		/* minix v1 fs, 14 char names */
 #define MINIX_SUPER_MAGIC2	0x138F		/* minix v1 fs, 30 char names */
-- 
1.7.8.6

