Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396Ab2JEMFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 08:05:34 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:50477 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab2JEMFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 08:05:33 -0400
X-AuditID: cbfee61a-b7f726d000000ec7-d0-506ecd0b6d92
From: =?utf-8?B?6rmA7J6s6re5?= <jaegeuk.kim@samsung.com>
To: viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com, jaegeuk.kim@samsung.com,
        jooyoung.hwang@samsung.com
Subject: [PATCH 15/16] f2fs: add recovery routines for roll-forward
Date: Fri, 05 Oct 2012 21:05:31 +0900
Message-id: <001601cda2f1$b78f1cc0$26ad5640$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2i8bdz2T3fTVL2Q2GVloNnAYvuvA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsVy+t9jAV3us3kBBmtXGVlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MvT8PMBZsCa+YvG0mYwPjEbcuRk4OCQETie3rtzBB2GISF+6t
	ZwOxhQQWMUrs3SraxcgFZM9nklgy+TZQgoODTcBCov2yO0hcROAeo8SlZTPBmoUFnCXutLaB
	2SwCqhK39nwBs3kFbCUmzPvJCGELSvyYfI8FZA6zgLrElCm5IGFmAXmJzWveMoOEJYDCj/7q
	goRFBPQk1r/exQ5RIiKx78U7xgmM/LOQDJqFMGgWkkGzkHQsYGRZxSiaWpBcUJyUnmuoV5yY
	W1yal66XnJ+7iREces+kdjCubLA4xCjAwajEw5vwMDdAiDWxrLgy9xCjBAezkgiv9ey8ACHe
	lMTKqtSi/Pii0pzU4kOM0hwsSuK8zR4pAUIC6YklqdmpqQWpRTBZJg5OqQbGmK3zheYvy0g+
	0fXe67T6u6Sn7A2v3ts9n2Qu8vtk/d5CXZVbpWKJLCpya69FKNt+e6eu0B2V5rb3sMCG24f9
	H+7fvViuxSUm8GtxafW9mOuTvrTbL+DM7z+oHODpHPzW07FlWyXnldjrH2dNjN+pYFJT+GPN
	jokRP9I3JIh9CGlu9GdR3nhGiaU4I9FQi7moOBEA9GlGDzkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds roll-forward routines to recover fsynced data.

- F2FS uses basically roll-back model with checkpointing.

- In order to implement fsync(), there are two approaches as follows.

1. A roll-back model with checkpointing at every fsync()
 : This is a naive method, but suffers from very low performance.

2. A roll-forward model
 : F2FS adopts this model where all the fsynced data should be recovered, which
   were written after checkpointing was done. In order to figure out the data,
   F2FS keeps a "fsync" mark in direct node blocks. In addition, F2FS remains
   the location of next node block in each direct node block for reconstructing
   the chain of node blocks during the recovery.

- In order to enhance the performance, F2FS keeps a "dentry" mark also in direct
  node blocks. If this is set during the recovery, F2FS replays adding a dentry.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/recovery.c |  372 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 372 insertions(+)
 create mode 100644 fs/f2fs/recovery.c

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
new file mode 100644
index 0000000..95455b1
--- /dev/null
+++ b/fs/f2fs/recovery.c
@@ -0,0 +1,372 @@
+/**
+ * fs/f2fs/recovery.c
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
+#include "f2fs.h"
+#include "node.h"
+#include "segment.h"
+
+static struct kmem_cache *fsync_entry_slab;
+
+bool space_for_roll_forward(struct f2fs_sb_info *sbi)
+{
+	if (sbi->last_valid_block_count + sbi->alloc_valid_block_count
+			> sbi->user_block_count)
+		return false;
+	return true;
+}
+
+static struct fsync_inode_entry *get_fsync_inode(struct list_head *head,
+								nid_t ino)
+{
+	struct list_head *this;
+	struct fsync_inode_entry *entry;
+
+	list_for_each(this, head) {
+		entry = list_entry(this, struct fsync_inode_entry, list);
+		if (entry->inode->i_ino == ino)
+			return entry;
+	}
+	return NULL;
+}
+
+static int recover_dentry(struct page *ipage, struct inode *inode)
+{
+	struct f2fs_node *raw_node = (struct f2fs_node *)kmap(ipage);
+	struct f2fs_inode *raw_inode = &(raw_node->i);
+	struct dentry dent, parent;
+	struct f2fs_dir_entry *de;
+	struct page *page;
+	struct inode *dir;
+	int err = 0;
+
+	if (!raw_node->footer.dentry)
+		goto out;
+
+	dir = f2fs_iget(inode->i_sb, le32_to_cpu(raw_inode->i_pino));
+	if (IS_ERR(dir)) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	parent.d_inode = dir;
+	dent.d_parent = &parent;
+	dent.d_name.len = le32_to_cpu(raw_inode->i_namelen);
+	dent.d_name.name = raw_inode->i_name;
+
+	de = f2fs_find_entry(dir, &dent.d_name, &page);
+	if (de) {
+		kunmap(page);
+		f2fs_put_page(page, 0);
+	} else {
+		f2fs_add_link(&dent, inode);
+	}
+	iput(dir);
+out:
+	kunmap(ipage);
+	return err;
+}
+
+static int recover_inode(struct inode *inode, struct page *node_page)
+{
+	void *kaddr = page_address(node_page);
+	struct f2fs_node *raw_node = (struct f2fs_node *)kaddr;
+	struct f2fs_inode *raw_inode = &(raw_node->i);
+
+	inode->i_mode = le32_to_cpu(raw_inode->i_mode);
+	i_size_write(inode, le64_to_cpu(raw_inode->i_size));
+	inode->i_atime.tv_sec = le32_to_cpu(raw_inode->i_atime);
+	inode->i_ctime.tv_sec = le32_to_cpu(raw_inode->i_ctime);
+	inode->i_mtime.tv_sec = le32_to_cpu(raw_inode->i_mtime);
+
+	return recover_dentry(node_page, inode);
+}
+
+static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
+{
+	unsigned long long cp_ver = le64_to_cpu(sbi->ckpt->checkpoint_ver);
+	struct curseg_info *curseg;
+	struct page *page;
+	block_t blkaddr;
+	int err = 0;
+
+	/* get node pages in the current segment */
+	curseg = CURSEG_I(sbi, CURSEG_WARM_NODE);
+	blkaddr = START_BLOCK(sbi, curseg->segno) + curseg->next_blkoff;
+
+	/* read node page */
+	page = alloc_page(GFP_NOFS | __GFP_ZERO);
+	if (IS_ERR(page))
+		return PTR_ERR(page);
+	lock_page(page);
+
+	while (1) {
+		struct fsync_inode_entry *entry;
+
+		if (f2fs_readpage(sbi, page, blkaddr, READ_SYNC))
+			goto out;
+
+		if (cp_ver != cpver_of_node(page))
+			goto out;
+
+		if (!is_fsync_dnode(page))
+			goto next;
+
+		entry = get_fsync_inode(head, ino_of_node(page));
+		if (entry) {
+			entry->blkaddr = blkaddr;
+			if (IS_INODE(page) && is_dent_dnode(page))
+				set_inode_flag(F2FS_I(entry->inode),
+							FI_INC_LINK);
+		} else {
+			if (IS_INODE(page) && is_dent_dnode(page)) {
+				if (recover_inode_page(sbi, page)) {
+					err = -ENOMEM;
+					goto out;
+				}
+			}
+
+			/* add this fsync inode to the list */
+			entry = kmem_cache_alloc(fsync_entry_slab, GFP_NOFS);
+			if (!entry) {
+				err = -ENOMEM;
+				goto out;
+			}
+
+			INIT_LIST_HEAD(&entry->list);
+			list_add_tail(&entry->list, head);
+
+			entry->inode = f2fs_iget(sbi->sb, ino_of_node(page));
+			if (IS_ERR(entry->inode)) {
+				err = PTR_ERR(entry->inode);
+				goto out;
+			}
+			entry->blkaddr = blkaddr;
+		}
+		if (IS_INODE(page)) {
+			err = recover_inode(entry->inode, page);
+			if (err)
+				goto out;
+		}
+next:
+		/* check next segment */
+		blkaddr = next_blkaddr_of_node(page);
+		ClearPageUptodate(page);
+	}
+out:
+	unlock_page(page);
+	__free_pages(page, 0);
+	return err;
+}
+
+static void destroy_fsync_dnodes(struct f2fs_sb_info *sbi,
+					struct list_head *head)
+{
+	struct list_head *this;
+	struct fsync_inode_entry *entry;
+	list_for_each(this, head) {
+		entry = list_entry(this, struct fsync_inode_entry, list);
+		iput(entry->inode);
+		list_del(&entry->list);
+		kmem_cache_free(fsync_entry_slab, entry);
+	}
+}
+
+static void check_index_in_prev_nodes(struct f2fs_sb_info *sbi,
+						block_t blkaddr)
+{
+	struct seg_entry *sentry;
+	unsigned int segno = GET_SEGNO(sbi, blkaddr);
+	unsigned short blkoff = GET_SEGOFF_FROM_SEG0(sbi, blkaddr) &
+					(sbi->blocks_per_seg - 1);
+	struct f2fs_summary sum;
+	nid_t ino;
+	void *kaddr;
+	struct inode *inode;
+	struct page *node_page;
+	block_t bidx;
+	int i;
+
+	sentry = get_seg_entry(sbi, segno);
+	if (!f2fs_test_bit(blkoff, sentry->cur_valid_map))
+		return;
+
+	/* Get the previous summary */
+	for (i = CURSEG_WARM_DATA; i <= CURSEG_COLD_DATA; i++) {
+		struct curseg_info *curseg = CURSEG_I(sbi, i);
+		if (curseg->segno == segno) {
+			sum = curseg->sum_blk->entries[blkoff];
+			break;
+		}
+	}
+	if (i > CURSEG_COLD_DATA) {
+		struct page *sum_page = get_sum_page(sbi, segno);
+		struct f2fs_summary_block *sum_node;
+		kaddr = page_address(sum_page);
+		sum_node = (struct f2fs_summary_block *)kaddr;
+		sum = sum_node->entries[blkoff];
+		f2fs_put_page(sum_page, 1);
+	}
+
+	/* Get the node page */
+	node_page = get_node_page(sbi, le32_to_cpu(sum.nid));
+	bidx = start_bidx_of_node(ofs_of_node(node_page)) +
+				le16_to_cpu(sum.ofs_in_node);
+	ino = ino_of_node(node_page);
+	f2fs_put_page(node_page, 1);
+
+	/* Deallocate previous index in the node page */
+	inode = f2fs_iget_nowait(sbi->sb, ino);
+	truncate_hole(inode, bidx, bidx + 1);
+	iput(inode);
+}
+
+static void do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
+					struct page *page, block_t blkaddr)
+{
+	unsigned int start, end;
+	struct dnode_of_data dn;
+	struct f2fs_summary sum;
+	struct node_info ni;
+
+	start = start_bidx_of_node(ofs_of_node(page));
+	if (IS_INODE(page))
+		end = start + ADDRS_PER_INODE;
+	else
+		end = start + ADDRS_PER_BLOCK;
+
+	set_new_dnode(&dn, inode, NULL, NULL, 0);
+	if (get_dnode_of_data(&dn, start, 0))
+		return;
+
+	wait_on_page_writeback(dn.node_page);
+
+	get_node_info(sbi, dn.nid, &ni);
+	BUG_ON(ni.ino != ino_of_node(page));
+	BUG_ON(ofs_of_node(dn.node_page) != ofs_of_node(page));
+
+	for (; start < end; start++) {
+		block_t src, dest;
+
+		src = datablock_addr(dn.node_page, dn.ofs_in_node);
+		dest = datablock_addr(page, dn.ofs_in_node);
+
+		if (src != dest && dest != NEW_ADDR && dest != NULL_ADDR) {
+			if (src == NULL_ADDR) {
+				int err = reserve_new_block(&dn);
+				/* We should not get -ENOSPC */
+				BUG_ON(err);
+			}
+
+			/* Check the previous node page having this index */
+			check_index_in_prev_nodes(sbi, dest);
+
+			set_summary(&sum, dn.nid, dn.ofs_in_node, ni.version);
+
+			/* write dummy data page */
+			recover_data_page(sbi, NULL, &sum, src, dest);
+			update_extent_cache(dest, &dn);
+		}
+		dn.ofs_in_node++;
+	}
+
+	/* write node page in place */
+	set_summary(&sum, dn.nid, 0, 0);
+	if (IS_INODE(dn.node_page))
+		sync_inode_page(&dn);
+
+	copy_node_footer(dn.node_page, page);
+	fill_node_footer(dn.node_page, dn.nid, ni.ino,
+					ofs_of_node(page), false);
+	set_page_dirty(dn.node_page);
+
+	recover_node_page(sbi, dn.node_page, &sum, &ni, blkaddr);
+	f2fs_put_dnode(&dn);
+}
+
+static void recover_data(struct f2fs_sb_info *sbi,
+				struct list_head *head, int type)
+{
+	unsigned long long cp_ver = le64_to_cpu(sbi->ckpt->checkpoint_ver);
+	struct curseg_info *curseg;
+	struct page *page;
+	block_t blkaddr;
+
+	/* get node pages in the current segment */
+	curseg = CURSEG_I(sbi, type);
+	blkaddr = NEXT_FREE_BLKADDR(sbi, curseg);
+
+	/* read node page */
+	page = alloc_page(GFP_NOFS | __GFP_ZERO);
+	if (IS_ERR(page))
+		return;
+	lock_page(page);
+
+	while (1) {
+		struct fsync_inode_entry *entry;
+
+		if (f2fs_readpage(sbi, page, blkaddr, READ_SYNC))
+			goto out;
+
+		if (cp_ver != cpver_of_node(page))
+			goto out;
+
+		entry = get_fsync_inode(head, ino_of_node(page));
+		if (!entry)
+			goto next;
+
+		do_recover_data(sbi, entry->inode, page, blkaddr);
+
+		if (entry->blkaddr == blkaddr) {
+			iput(entry->inode);
+			list_del(&entry->list);
+			kmem_cache_free(fsync_entry_slab, entry);
+		}
+next:
+		/* check next segment */
+		blkaddr = next_blkaddr_of_node(page);
+		ClearPageUptodate(page);
+	}
+out:
+	unlock_page(page);
+	__free_pages(page, 0);
+
+	allocate_new_segments(sbi);
+}
+
+void recover_fsync_data(struct f2fs_sb_info *sbi)
+{
+	struct list_head inode_list;
+
+	fsync_entry_slab = f2fs_kmem_cache_create("f2fs_fsync_inode_entry",
+			sizeof(struct fsync_inode_entry), NULL);
+	if (unlikely(!fsync_entry_slab))
+		return;
+
+	INIT_LIST_HEAD(&inode_list);
+
+	/* step #1: find fsynced inode numbers */
+	if (find_fsync_dnodes(sbi, &inode_list))
+		goto out;
+
+	if (list_empty(&inode_list))
+		goto out;
+
+	/* step #2: recover data */
+	sbi->por_doing = 1;
+	recover_data(sbi, &inode_list, CURSEG_WARM_NODE);
+	sbi->por_doing = 0;
+	BUG_ON(!list_empty(&inode_list));
+out:
+	destroy_fsync_dnodes(sbi, &inode_list);
+	kmem_cache_destroy(fsync_entry_slab);
+	write_checkpoint(sbi, false, false);
+}
-- 
1.7.9.5




---
Jaegeuk Kim
Samsung



