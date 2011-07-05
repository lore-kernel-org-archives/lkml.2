Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab1GEWa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 18:30:27 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:47331 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204Ab1GEWaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 18:30:18 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Christoph Hellwig <hch@tuxera.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Anton Salikhmetov <alexo@tuxera.com>,
        Al Viro <viro@zeniv.linux.org.uk>, roman@ardistech.com,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH v2 2/2] hfsplus: Add error propagation for hfsplus_ext_write_extent_locked
Date: Wed,  6 Jul 2011 02:30:00 +0400
Message-Id: <1309905000-28983-3-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309905000-28983-1-git-send-email-khoroshilov@ispras.ru>
References: <20110630114242.GA9597@infradead.org>
 <1309905000-28983-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement error propagation through the callers of
hfsplus_ext_write_extent_locked().

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 fs/hfsplus/extents.c    |   26 ++++++++++++++++++--------
 fs/hfsplus/hfsplus_fs.h |    2 +-
 fs/hfsplus/super.c      |    6 +++++-
 3 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/fs/hfsplus/extents.c b/fs/hfsplus/extents.c
index 59fa09f..9235c41 100644
--- a/fs/hfsplus/extents.c
+++ b/fs/hfsplus/extents.c
@@ -119,23 +119,31 @@ static void __hfsplus_ext_write_extent(struct inode *inode,
 	set_bit(HFSPLUS_I_EXT_DIRTY, &hip->flags);
 }
 
-static void hfsplus_ext_write_extent_locked(struct inode *inode)
+static int hfsplus_ext_write_extent_locked(struct inode *inode)
 {
+	int res;
+
 	if (HFSPLUS_I(inode)->extent_state & HFSPLUS_EXT_DIRTY) {
 		struct hfs_find_data fd;
 
-		if (!hfs_find_init(HFSPLUS_SB(inode->i_sb)->ext_tree, &fd)) {
-			__hfsplus_ext_write_extent(inode, &fd);
-			hfs_find_exit(&fd);
-		}
+		res = hfs_find_init(HFSPLUS_SB(inode->i_sb)->ext_tree, &fd);
+		if (res)
+			return res;
+		__hfsplus_ext_write_extent(inode, &fd);
+		hfs_find_exit(&fd);
 	}
+	return 0;
 }
 
-void hfsplus_ext_write_extent(struct inode *inode)
+int hfsplus_ext_write_extent(struct inode *inode)
 {
+	int res;
+
 	mutex_lock(&HFSPLUS_I(inode)->extents_lock);
-	hfsplus_ext_write_extent_locked(inode);
+	res = hfsplus_ext_write_extent_locked(inode);
 	mutex_unlock(&HFSPLUS_I(inode)->extents_lock);
+
+	return res;
 }
 
 static inline int __hfsplus_ext_read_extent(struct hfs_find_data *fd,
@@ -474,7 +482,9 @@ out:
 
 insert_extent:
 	dprint(DBG_EXTENT, "insert new extent\n");
-	hfsplus_ext_write_extent_locked(inode);
+	res = hfsplus_ext_write_extent_locked(inode);
+	if (res)
+		goto out;
 
 	memset(hip->cached_extents, 0, sizeof(hfsplus_extent_rec));
 	hip->cached_extents[0].start_block = cpu_to_be32(start);
diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index d685752..0bebf74 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -374,7 +374,7 @@ extern const struct file_operations hfsplus_dir_operations;
 
 /* extents.c */
 int hfsplus_ext_cmp_key(const hfsplus_btree_key *, const hfsplus_btree_key *);
-void hfsplus_ext_write_extent(struct inode *);
+int hfsplus_ext_write_extent(struct inode *);
 int hfsplus_get_block(struct inode *, sector_t, struct buffer_head *, int);
 int hfsplus_free_fork(struct super_block *, u32,
 		struct hfsplus_fork_raw *, int);
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index 07a0502..0b41f4c 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -135,9 +135,13 @@ static int hfsplus_system_write_inode(struct inode *inode)
 static int hfsplus_write_inode(struct inode *inode,
 		struct writeback_control *wbc)
 {
+	int err;
+
 	dprint(DBG_INODE, "hfsplus_write_inode: %lu\n", inode->i_ino);
 
-	hfsplus_ext_write_extent(inode);
+	err = hfsplus_ext_write_extent(inode);
+	if (err)
+		return err;
 
 	if (inode->i_ino >= HFSPLUS_FIRSTUSER_CNID ||
 	    inode->i_ino == HFSPLUS_ROOT_CNID)
-- 
1.7.4.1

