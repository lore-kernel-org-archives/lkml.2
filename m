Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab2JEMCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 08:02:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:48932 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224Ab2JEMCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 08:02:40 -0400
X-AuditID: cbfee61b-b7f2b6d000000f14-9c-506ecc5e00df
From: =?utf-8?B?6rmA7J6s6re5?= <jaegeuk.kim@samsung.com>
To: viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com, jaegeuk.kim@samsung.com,
        jooyoung.hwang@samsung.com
Subject: [PATCH 10/16] f2fs: add core inode operations
Date: Fri, 05 Oct 2012 21:02:38 +0900
Message-id: <001101cda2f1$50a23c40$f1e6b4c0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2i8VCCHiKt7bFKSRqeW9Zt6Pok0Q==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKLMWRmVeSWpSXmKPExsVy+t9jQd34M3kBBk9a2Cwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG78brbAWNthVbJ/YxNzA+Mepi5OCQEDCRON7t0sXICWSKSVy4
	t56ti5GLQ0hgOqPEsffb2SGc+UwS/37eZgVpYBOwkGi/7A4SFxG4xyhxadlMJpBuYQEzid9P
	9zGC2CwCqhIN/1rA4rwCthJrNrSyQdiCEj8m32MBmcMsoC4xZUouSJhZQF5i85q3zBD3qEs8
	+qsLYooI6Encn54PUSEise/FO8YJjPyzkMyZhTBnFpI5s5B0LGBkWcUomlqQXFCclJ5rpFec
	mFtcmpeul5yfu4kRHHjPpHcwrmqwOMQowMGoxMMr8Cw3QIg1say4MvcQowQHs5IIr/XsvAAh
	3pTEyqrUovz4otKc1OJDjNIcLErivM0eKQFCAumJJanZqakFqUUwWSYOTqkGRm5XRclnfR6P
	/V7NmFAeoaeaXLpiKidzwsNXtgwMUlrTu26ttwzXfGUVmbp7Z3dwBnebdPEpsdC+2X/NXOqf
	3Ove1r+aK7Fjn9WJjqfStVqJV/9od5/xe7p727fl9xZc219kuXC5UD13XbKws49Qr8rNgus1
	5wUnq/88basuvKS94c1f5jo1JZbijERDLeai4kQAEiTSoTgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds core functions to get, read, write, and evict an inode.

Signed-off-by: Changman Lee <cm224.lee@samsung.com>
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/inode.c |  258 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 258 insertions(+)
 create mode 100644 fs/f2fs/inode.c

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
new file mode 100644
index 0000000..1e409c2
--- /dev/null
+++ b/fs/f2fs/inode.c
@@ -0,0 +1,258 @@
+/**
+ * fs/f2fs/inode.c
+ *
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *             http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/fs.h>
+#include <linux/f2fs_fs.h>
+#include <linux/buffer_head.h>
+#include <linux/writeback.h>
+
+#include "f2fs.h"
+#include "node.h"
+
+struct f2fs_iget_args {
+	u64 ino;
+	int on_free;
+};
+
+void f2fs_set_inode_flags(struct inode *inode)
+{
+	unsigned int flags = F2FS_I(inode)->i_flags;
+
+	inode->i_flags &= ~(S_SYNC | S_APPEND | S_IMMUTABLE |
+			S_NOATIME | S_DIRSYNC);
+
+	if (flags & FS_SYNC_FL)
+		inode->i_flags |= S_SYNC;
+	if (flags & FS_APPEND_FL)
+		inode->i_flags |= S_APPEND;
+	if (flags & FS_IMMUTABLE_FL)
+		inode->i_flags |= S_IMMUTABLE;
+	if (flags & FS_NOATIME_FL)
+		inode->i_flags |= S_NOATIME;
+	if (flags & FS_DIRSYNC_FL)
+		inode->i_flags |= S_DIRSYNC;
+}
+
+static int f2fs_iget_test(struct inode *inode, void *data)
+{
+	struct f2fs_iget_args *args = data;
+
+	if (inode->i_ino != args->ino)
+		return 0;
+	if (inode->i_state & (I_FREEING | I_WILL_FREE)) {
+		args->on_free = 1;
+		return 0;
+	}
+	return 1;
+}
+
+struct inode *f2fs_iget_nowait(struct super_block *sb, unsigned long ino)
+{
+	struct f2fs_iget_args args = {
+		.ino = ino,
+		.on_free = 0
+	};
+	struct inode *inode = ilookup5(sb, ino, f2fs_iget_test, &args);
+
+	if (inode)
+		return inode;
+	if (!args.on_free)
+		return f2fs_iget(sb, ino);
+	return ERR_PTR(-ENOENT);
+}
+
+static int do_read_inode(struct inode *inode)
+{
+	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_inode_info *fi = F2FS_I(inode);
+	struct page *node_page;
+	struct f2fs_node *rn;
+	struct f2fs_inode *ri;
+
+	/* Check if ino is within scope */
+	check_nid_range(sbi, inode->i_ino);
+
+	node_page = get_node_page(sbi, inode->i_ino);
+	if (IS_ERR(node_page))
+		return PTR_ERR(node_page);
+
+	rn = page_address(node_page);
+	ri = &(rn->i);
+
+	inode->i_mode = le16_to_cpu(ri->i_mode);
+	inode->i_uid = le32_to_cpu(ri->i_uid);
+	inode->i_gid = le32_to_cpu(ri->i_gid);
+	set_nlink(inode, le32_to_cpu(ri->i_links));
+	inode->i_size = le64_to_cpu(ri->i_size);
+	inode->i_blocks = le64_to_cpu(ri->i_blocks);
+
+	inode->i_atime.tv_sec = le32_to_cpu(ri->i_atime);
+	inode->i_ctime.tv_sec = le32_to_cpu(ri->i_ctime);
+	inode->i_mtime.tv_sec = le32_to_cpu(ri->i_mtime);
+	inode->i_atime.tv_nsec = 0;
+	inode->i_ctime.tv_nsec = 0;
+	inode->i_mtime.tv_nsec = 0;
+	fi->current_depth = le32_to_cpu(ri->current_depth);
+	fi->i_xattr_nid = le32_to_cpu(ri->i_xattr_nid);
+	fi->i_flags = le32_to_cpu(ri->i_flags);
+	fi->flags = 0;
+	fi->data_version = le64_to_cpu(F2FS_CKPT(sbi)->checkpoint_ver) - 1;
+	get_extent_info(&fi->ext, ri->i_ext);
+	f2fs_put_page(node_page, 1);
+	return 0;
+}
+
+struct inode *f2fs_iget(struct super_block *sb, unsigned long ino)
+{
+	struct f2fs_sb_info *sbi = F2FS_SB(sb);
+	struct inode *inode;
+	int ret;
+
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
+	if (ino == F2FS_NODE_INO(sbi) || ino == F2FS_META_INO(sbi))
+		goto make_now;
+
+	ret = do_read_inode(inode);
+	if (ret)
+		goto bad_inode;
+
+	if (!sbi->por_doing && inode->i_nlink == 0) {
+		ret = -ENOENT;
+		goto bad_inode;
+	}
+
+make_now:
+	if (ino == F2FS_NODE_INO(sbi)) {
+		inode->i_mapping->a_ops = &f2fs_node_aops;
+		mapping_set_gfp_mask(inode->i_mapping, GFP_F2FS_MOVABLE);
+	} else if (ino == F2FS_META_INO(sbi)) {
+		inode->i_mapping->a_ops = &f2fs_meta_aops;
+		mapping_set_gfp_mask(inode->i_mapping, GFP_F2FS_MOVABLE);
+	} else if (S_ISREG(inode->i_mode)) {
+		inode->i_op = &f2fs_file_inode_operations;
+		inode->i_fop = &f2fs_file_operations;
+		inode->i_mapping->a_ops = &f2fs_dblock_aops;
+	} else if (S_ISDIR(inode->i_mode)) {
+		inode->i_op = &f2fs_dir_inode_operations;
+		inode->i_fop = &f2fs_dir_operations;
+		inode->i_mapping->a_ops = &f2fs_dblock_aops;
+		mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER_MOVABLE |
+				__GFP_ZERO);
+	} else if (S_ISLNK(inode->i_mode)) {
+		inode->i_op = &f2fs_symlink_inode_operations;
+		inode->i_mapping->a_ops = &f2fs_dblock_aops;
+	} else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode) ||
+			S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
+		inode->i_op = &f2fs_special_inode_operations;
+		init_special_inode(inode, inode->i_mode, inode->i_rdev);
+	} else {
+		ret = -EIO;
+		goto bad_inode;
+	}
+	unlock_new_inode(inode);
+
+	return inode;
+
+bad_inode:
+	iget_failed(inode);
+	return ERR_PTR(ret);
+}
+
+void update_inode(struct inode *inode, struct page *node_page)
+{
+	struct f2fs_node *rn;
+	struct f2fs_inode *ri;
+
+	wait_on_page_writeback(node_page);
+
+	rn = page_address(node_page);
+	ri = &(rn->i);
+
+	ri->i_mode = cpu_to_le16(inode->i_mode);
+	ri->i_uid = cpu_to_le32(inode->i_uid);
+	ri->i_gid = cpu_to_le32(inode->i_gid);
+	ri->i_links = cpu_to_le32(inode->i_nlink);
+	ri->i_size = cpu_to_le64(i_size_read(inode));
+	ri->i_blocks = cpu_to_le64(inode->i_blocks);
+	set_raw_extent(&F2FS_I(inode)->ext, &ri->i_ext);
+
+	ri->i_ctime = cpu_to_le32(inode->i_ctime.tv_sec);
+	ri->i_mtime = cpu_to_le32(inode->i_mtime.tv_sec);
+	ri->i_atime = cpu_to_le32(inode->i_atime.tv_sec);
+	ri->current_depth = cpu_to_le32(F2FS_I(inode)->current_depth);
+	ri->i_xattr_nid = cpu_to_le32(F2FS_I(inode)->i_xattr_nid);
+	ri->i_flags = cpu_to_le32(F2FS_I(inode)->i_flags);
+	set_page_dirty(node_page);
+}
+
+int f2fs_write_inode(struct inode *inode, struct writeback_control *wbc)
+{
+	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct page *node_page;
+	bool need_lock = false;
+
+	if (inode->i_ino == F2FS_NODE_INO(sbi) ||
+			inode->i_ino == F2FS_META_INO(sbi))
+		return 0;
+
+	node_page = get_node_page(sbi, inode->i_ino);
+	if (IS_ERR(node_page))
+		return PTR_ERR(node_page);
+
+	if (!PageDirty(node_page)) {
+		need_lock = true;
+		f2fs_put_page(node_page, 1);
+		mutex_lock(&sbi->write_inode);
+		node_page = get_node_page(sbi, inode->i_ino);
+		if (IS_ERR(node_page)) {
+			mutex_unlock(&sbi->write_inode);
+			return PTR_ERR(node_page);
+		}
+	}
+	update_inode(inode, node_page);
+	f2fs_put_page(node_page, 1);
+	if (need_lock)
+		mutex_unlock(&sbi->write_inode);
+	return 0;
+}
+
+/**
+ * Called at the last iput() if i_nlink is zero
+ */
+void f2fs_evict_inode(struct inode *inode)
+{
+	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+
+	truncate_inode_pages(&inode->i_data, 0);
+
+	if (inode->i_ino == F2FS_NODE_INO(sbi) ||
+			inode->i_ino == F2FS_META_INO(sbi))
+		goto no_delete;
+
+	BUG_ON(atomic_read(&F2FS_I(inode)->dirty_dents));
+	remove_dirty_dir_inode(inode);
+
+	if (inode->i_nlink || is_bad_inode(inode))
+		goto no_delete;
+
+	set_inode_flag(F2FS_I(inode), FI_NO_ALLOC);
+	i_size_write(inode, 0);
+
+	if (F2FS_HAS_BLOCKS(inode))
+		f2fs_truncate(inode);
+
+	remove_inode_page(inode);
+no_delete:
+	clear_inode(inode);
+}
-- 
1.7.9.5




---
Jaegeuk Kim
Samsung



