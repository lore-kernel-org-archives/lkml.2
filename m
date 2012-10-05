Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375Ab2JEL62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 07:58:28 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:60352 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab2JEL6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 07:58:23 -0400
X-AuditID: cbfee61a-b7f726d000000ec7-e8-506ecb5ec7be
From: =?utf-8?B?6rmA7J6s6re5?= <jaegeuk.kim@samsung.com>
To: viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com, jaegeuk.kim@samsung.com,
        jooyoung.hwang@samsung.com
Subject: [PATCH 04/16] f2fs: add super block operations
Date: Fri, 05 Oct 2012 20:58:21 +0900
Message-id: <000b01cda2f0$b7a81870$26f84950$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2i8Ld7cO8sOTCDREKS93PucTY0xg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsVy+t9jQd2403kBBgfei1lc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MiY9XsRU8KK04vuQ9UwPj1qQuRk4OCQETidX9t1ggbDGJC/fW
	s3UxcnEICUxnlDjc8IoRwpnPJPHh4WQgh4ODTcBCov2yO0hcROAeo8SlZTOZQLqFBcwlZp+Z
	zAJSwyKgKnGyLRckzCtgK/F/VQMzhC0o8WPyPbASZgF1iSlTwEqYBeQlNq95ywwSlgAKP/qr
	CxIWEdCTaH6/hBmiRERi34t3jBMY+WchGTQLYdAsJINmIelYwMiyilE0tSC5oDgpPddQrzgx
	t7g0L10vOT93EyM49J5J7WBc2WBxiFGAg1GJhzfhYW6AEGtiWXFl7iFGCQ5mJRFe69l5AUK8
	KYmVValF+fFFpTmpxYcYpTlYlMR5mz1SAoQE0hNLUrNTUwtSi2CyTBycUg2Mh16f09+k3Fhp
	xi/PwaKcembNo/f+vYKrfd/FydzJz1NjTPq3fe7v9Kkle0PE0rSF75y3EP/Z1CabIXqQk2/R
	iYLFgjkrixYekTxZ3BRbtKa8dZd7gO0m50squ6/MmrTupfjWRzbPXuRniIoXvlxZIKFXeWn/
	6/ILp0+mxH6YUbXeb+rty9eFlViKMxINtZiLihMBeS0V+jkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the implementation of superblock operations for f2fs, which includes
- init_f2fs_fs/exit_f2fs_fs
- f2fs_mount
- super_operations of f2fs

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/super.c |  550 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 550 insertions(+)
 create mode 100644 fs/f2fs/super.c

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
new file mode 100644
index 0000000..54f0207
--- /dev/null
+++ b/fs/f2fs/super.c
@@ -0,0 +1,550 @@
+/**
+ * fs/f2fs/super.c
+ *
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *             http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/fs.h>
+#include <linux/statfs.h>
+#include <linux/proc_fs.h>
+#include <linux/buffer_head.h>
+#include <linux/backing-dev.h>
+#include <linux/kthread.h>
+#include <linux/parser.h>
+#include <linux/mount.h>
+#include <linux/seq_file.h>
+#include <linux/f2fs_fs.h>
+
+#include "f2fs.h"
+#include "node.h"
+#include "xattr.h"
+
+static struct kmem_cache *f2fs_inode_cachep;
+static struct proc_dir_entry *f2fs_proc_root;
+
+enum {
+	Opt_gc_background_off,
+	Opt_disable_roll_forward,
+	Opt_discard,
+	Opt_noheap,
+	Opt_nouser_xattr,
+	Opt_noacl,
+	Opt_err,
+};
+
+static match_table_t f2fs_tokens = {
+	{Opt_gc_background_off, "background_gc_off"},
+	{Opt_disable_roll_forward, "disable_roll_forward"},
+	{Opt_discard, "discard"},
+	{Opt_noheap, "no_heap"},
+	{Opt_nouser_xattr, "nouser_xattr"},
+	{Opt_noacl, "noacl"},
+	{Opt_err, NULL},
+};
+
+static void init_once(void *foo)
+{
+	struct f2fs_inode_info *fi = (struct f2fs_inode_info *) foo;
+
+	memset(fi, 0, sizeof(*fi));
+	inode_init_once(&fi->vfs_inode);
+}
+
+static struct inode *f2fs_alloc_inode(struct super_block *sb)
+{
+	struct f2fs_inode_info *fi;
+
+	fi = kmem_cache_alloc(f2fs_inode_cachep, GFP_NOFS | __GFP_ZERO);
+	if (!fi)
+		return NULL;
+
+	init_once((void *) fi);
+
+	/* Initilize f2fs-specific inode info */
+	fi->vfs_inode.i_version = 1;
+	atomic_set(&fi->dirty_dents, 0);
+	fi->current_depth = 1;
+	fi->is_cold = 0;
+	rwlock_init(&fi->ext.ext_lock);
+
+	set_inode_flag(fi, FI_NEW_INODE);
+
+	return &fi->vfs_inode;
+}
+
+static void f2fs_i_callback(struct rcu_head *head)
+{
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	kmem_cache_free(f2fs_inode_cachep, F2FS_I(inode));
+}
+
+void f2fs_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, f2fs_i_callback);
+}
+
+static void f2fs_put_super(struct super_block *sb)
+{
+	struct f2fs_sb_info *sbi = F2FS_SB(sb);
+
+#ifdef CONFIG_F2FS_STAT_FS
+	if (sbi->s_proc) {
+		f2fs_stat_exit(sbi);
+		remove_proc_entry(sb->s_id, f2fs_proc_root);
+	}
+#endif
+	stop_gc_thread(sbi);
+
+	write_checkpoint(sbi, false, true);
+
+	iput(sbi->node_inode);
+	iput(sbi->meta_inode);
+
+	/* destroy f2fs internal modules */
+	destroy_gc_manager(sbi);
+	destroy_node_manager(sbi);
+	destroy_segment_manager(sbi);
+
+	kfree(sbi->ckpt);
+
+	sb->s_fs_info = NULL;
+	brelse(sbi->raw_super_buf);
+	kfree(sbi);
+}
+
+int f2fs_sync_fs(struct super_block *sb, int sync)
+{
+	struct f2fs_sb_info *sbi = F2FS_SB(sb);
+	int ret = 0;
+
+	if (!sbi->s_dirty && !get_pages(sbi, F2FS_DIRTY_NODES))
+		return 0;
+
+	if (sync)
+		write_checkpoint(sbi, false, false);
+
+	return ret;
+}
+
+static int f2fs_statfs(struct dentry *dentry, struct kstatfs *buf)
+{
+	struct super_block *sb = dentry->d_sb;
+	struct f2fs_sb_info *sbi = F2FS_SB(sb);
+	block_t total_count, user_block_count, start_count, ovp_count;
+
+	total_count = le64_to_cpu(sbi->raw_super->block_count);
+	user_block_count = sbi->user_block_count;
+	start_count = le64_to_cpu(sbi->raw_super->segment0_blkaddr);
+	ovp_count = sbi->gc_info->overp_segment_count
+					<< sbi->log_blocks_per_seg;
+	buf->f_type = F2FS_SUPER_MAGIC;
+	buf->f_bsize = sbi->blocksize;
+
+	buf->f_blocks = total_count - start_count;
+	buf->f_bfree = buf->f_blocks - valid_user_blocks(sbi) - ovp_count;
+	buf->f_bavail = user_block_count - valid_user_blocks(sbi);
+
+	buf->f_files = valid_inode_count(sbi);
+	buf->f_ffree = sbi->total_node_count - valid_node_count(sbi);
+
+	buf->f_namelen = F2FS_MAX_NAME_LEN;
+
+	return 0;
+}
+
+static int f2fs_show_options(struct seq_file *seq, struct dentry *root)
+{
+	struct f2fs_sb_info *sbi = F2FS_SB(root->d_sb);
+
+	if (test_opt(sbi, BG_GC))
+		seq_puts(seq, ",background_gc_on");
+	else
+		seq_puts(seq, ",background_gc_off");
+	if (test_opt(sbi, DISABLE_ROLL_FORWARD))
+		seq_puts(seq, ",disable_roll_forward");
+	if (test_opt(sbi, DISCARD))
+		seq_puts(seq, ",discard");
+	if (test_opt(sbi, NOHEAP))
+		seq_puts(seq, ",no_heap_alloc");
+#ifdef CONFIG_F2FS_FS_XATTR
+	if (test_opt(sbi, XATTR_USER))
+		seq_puts(seq, ",user_xattr");
+	else
+		seq_puts(seq, ",nouser_xattr");
+#endif
+#ifdef CONFIG_F2FS_FS_POSIX_ACL
+	if (test_opt(sbi, POSIX_ACL))
+		seq_puts(seq, ",acl");
+	else
+		seq_puts(seq, ",noacl");
+#endif
+	return 0;
+}
+
+static struct super_operations f2fs_sops = {
+	.alloc_inode	= f2fs_alloc_inode,
+	.destroy_inode	= f2fs_destroy_inode,
+	.write_inode	= f2fs_write_inode,
+	.show_options	= f2fs_show_options,
+	.evict_inode	= f2fs_evict_inode,
+	.put_super	= f2fs_put_super,
+	.sync_fs	= f2fs_sync_fs,
+	.statfs		= f2fs_statfs,
+};
+
+static int parse_options(struct f2fs_sb_info *sbi, char *options)
+{
+	substring_t args[MAX_OPT_ARGS];
+	char *p;
+
+	if (!options)
+		return 0;
+
+	while ((p = strsep(&options, ",")) != NULL) {
+		int token;
+		if (!*p)
+			continue;
+		token = match_token(p, f2fs_tokens, args);
+		switch (token) {
+		case Opt_gc_background_off:
+			clear_opt(sbi, BG_GC);
+			break;
+		case Opt_disable_roll_forward:
+			set_opt(sbi, DISABLE_ROLL_FORWARD);
+			break;
+		case Opt_discard:
+			set_opt(sbi, DISCARD);
+			break;
+		case Opt_noheap:
+			set_opt(sbi, NOHEAP);
+			break;
+#ifdef CONFIG_F2FS_FS_XATTR
+		case Opt_nouser_xattr:
+			clear_opt(sbi, XATTR_USER);
+			break;
+#else
+		case Opt_nouser_xattr:
+			pr_info("nouser_xattr options not supported\n");
+			break;
+#endif
+#ifdef CONFIG_F2FS_FS_POSIX_ACL
+		case Opt_noacl:
+			clear_opt(sbi, POSIX_ACL);
+			break;
+#else
+		case Opt_noacl:
+			pr_info("noacl options not supported\n");
+			break;
+#endif
+		default:
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+static loff_t max_file_size(unsigned bits)
+{
+	loff_t result = ADDRS_PER_INODE;
+	loff_t leaf_count = ADDRS_PER_BLOCK;
+
+	result += (leaf_count * 2);
+
+	leaf_count *= NIDS_PER_BLOCK;
+	result += (leaf_count * 2);
+
+	leaf_count *= NIDS_PER_BLOCK;
+	result += (leaf_count * 2);
+
+	result <<= bits;
+	return result;
+}
+
+static int sanity_check_raw_super(struct f2fs_super_block *raw_super)
+{
+	unsigned int blocksize;
+
+	if (F2FS_SUPER_MAGIC != le32_to_cpu(raw_super->magic))
+		return 1;
+	blocksize = 1 << le32_to_cpu(raw_super->log_blocksize);
+	if (blocksize != PAGE_CACHE_SIZE)
+		return 1;
+	return 0;
+}
+
+static int sanity_check_ckpt(struct f2fs_super_block *raw_super,
+				struct f2fs_checkpoint *ckpt)
+{
+	unsigned int total, fsmeta;
+
+	total = le32_to_cpu(raw_super->segment_count);
+	fsmeta = le32_to_cpu(raw_super->segment_count_ckpt);
+	fsmeta += le32_to_cpu(raw_super->segment_count_sit);
+	fsmeta += le32_to_cpu(raw_super->segment_count_nat);
+	fsmeta += le32_to_cpu(ckpt->rsvd_segment_count);
+	fsmeta += le32_to_cpu(raw_super->segment_count_ssa);
+
+	if (fsmeta >= total)
+		return 1;
+	return 0;
+}
+
+static void init_sb_info(struct f2fs_sb_info *sbi)
+{
+	struct f2fs_super_block *raw_super = sbi->raw_super;
+	int i;
+
+	sbi->log_sectorsize = le32_to_cpu(raw_super->log_sectorsize);
+	sbi->log_sectors_per_block =
+		le32_to_cpu(raw_super->log_sectors_per_block);
+	sbi->log_blocksize = le32_to_cpu(raw_super->log_blocksize);
+	sbi->blocksize = 1 << sbi->log_blocksize;
+	sbi->log_blocks_per_seg = le32_to_cpu(raw_super->log_blocks_per_seg);
+	sbi->blocks_per_seg = 1 << sbi->log_blocks_per_seg;
+	sbi->log_segs_per_sec = le32_to_cpu(raw_super->log_segs_per_sec);
+	sbi->segs_per_sec = 1 << sbi->log_segs_per_sec;
+	sbi->secs_per_zone = le32_to_cpu(raw_super->secs_per_zone);
+	sbi->total_sections = le32_to_cpu(raw_super->section_count);
+	sbi->total_node_count =
+		(le32_to_cpu(raw_super->segment_count_nat) / 2)
+			* sbi->blocks_per_seg * NAT_ENTRY_PER_BLOCK;
+	sbi->root_ino_num = le32_to_cpu(raw_super->root_ino);
+	sbi->node_ino_num = le32_to_cpu(raw_super->node_ino);
+	sbi->meta_ino_num = le32_to_cpu(raw_super->meta_ino);
+
+	for (i = 0; i < NR_COUNT_TYPE; i++)
+		atomic_set(&sbi->nr_pages[i], 0);
+}
+
+static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
+{
+	struct f2fs_sb_info *sbi;
+	struct f2fs_super_block *raw_super;
+	struct buffer_head *raw_super_buf;
+	struct inode *root;
+	int i;
+
+	/* allocate memory for f2fs-specific super block info */
+	sbi = kzalloc(sizeof(struct f2fs_sb_info), GFP_KERNEL);
+	if (!sbi)
+		return -ENOMEM;
+
+	/* set a temporary block size */
+	if (!sb_set_blocksize(sb, F2FS_BLKSIZE))
+		goto free_sbi;
+
+	/* read f2fs raw super block */
+	raw_super_buf = sb_bread(sb, F2FS_SUPER_OFFSET);
+	if (!raw_super_buf)
+		goto free_sbi;
+	raw_super = (struct f2fs_super_block *) ((char *)raw_super_buf->b_data);
+
+	/* init some FS parameters */
+	set_opt(sbi, BG_GC);
+
+#ifdef CONFIG_F2FS_FS_XATTR
+	set_opt(sbi, XATTR_USER);
+#endif
+#ifdef CONFIG_F2FS_FS_POSIX_ACL
+	set_opt(sbi, POSIX_ACL);
+#endif
+	/* parse mount options */
+	if (parse_options(sbi, (char *)data))
+		goto free_sb_buf;
+
+	/* sanity checking of raw super */
+	if (sanity_check_raw_super(raw_super))
+		goto free_sb_buf;
+
+	sb->s_maxbytes = max_file_size(raw_super->log_blocksize);
+	sb->s_op = &f2fs_sops;
+	sb->s_xattr = f2fs_xattr_handlers;
+	sb->s_magic = F2FS_SUPER_MAGIC;
+	sb->s_fs_info = sbi;
+	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
+		(test_opt(sbi, POSIX_ACL) ? MS_POSIXACL : 0);
+
+	/* init f2fs-specific super block info */
+	sbi->sb = sb;
+	sbi->raw_super = raw_super;
+	sbi->raw_super_buf = raw_super_buf;
+	mutex_init(&sbi->gc_mutex);
+	mutex_init(&sbi->write_inode);
+	mutex_init(&sbi->writepages);
+	mutex_init(&sbi->cp_mutex);
+	for (i = 0; i < NR_LOCK_TYPE; i++)
+		mutex_init(&sbi->fs_lock[i]);
+	sbi->por_doing = 0;
+	spin_lock_init(&sbi->stat_lock);
+	init_rwsem(&sbi->bio_sem);
+	init_sb_info(sbi);
+
+	/* get an inode for meta space */
+	sbi->meta_inode = f2fs_iget(sb, F2FS_META_INO(sbi));
+	if (IS_ERR(sbi->meta_inode))
+		goto free_sb_buf;
+
+	if (get_valid_checkpoint(sbi))
+		goto free_meta_inode;
+
+	/* sanity checking of checkpoint */
+	if (sanity_check_ckpt(raw_super, sbi->ckpt))
+		goto free_cp;
+
+	sbi->total_valid_node_count =
+				le32_to_cpu(sbi->ckpt->valid_node_count);
+	sbi->total_valid_inode_count =
+				le32_to_cpu(sbi->ckpt->valid_inode_count);
+	sbi->user_block_count = le64_to_cpu(sbi->ckpt->user_block_count);
+	sbi->total_valid_block_count =
+				le64_to_cpu(sbi->ckpt->valid_block_count);
+	sbi->last_valid_block_count = sbi->total_valid_block_count;
+	sbi->alloc_valid_block_count = 0;
+	INIT_LIST_HEAD(&sbi->dir_inode_list);
+	spin_lock_init(&sbi->dir_inode_lock);
+
+	/* init super block */
+	if (!sb_set_blocksize(sb, sbi->blocksize))
+		goto free_cp;
+
+	init_orphan_info(sbi);
+
+	/* setup f2fs internal modules */
+	if (build_segment_manager(sbi))
+		goto free_sm;
+	if (build_node_manager(sbi))
+		goto free_nm;
+	if (build_gc_manager(sbi))
+		goto free_gc;
+
+	/* get an inode for node space */
+	sbi->node_inode = f2fs_iget(sb, F2FS_NODE_INO(sbi));
+	if (IS_ERR(sbi->node_inode))
+		goto free_gc;
+
+	/* if there are nt orphan nodes free them */
+	if (recover_orphan_inodes(sbi))
+		goto free_node_inode;
+
+	/* read root inode and dentry */
+	root = f2fs_iget(sb, F2FS_ROOT_INO(sbi));
+	if (IS_ERR(root))
+		goto free_node_inode;
+	if (!S_ISDIR(root->i_mode) || !root->i_blocks || !root->i_size)
+		goto free_root_inode;
+
+	sb->s_root = d_make_root(root); /* allocate root dentry */
+	if (!sb->s_root)
+		goto free_root_inode;
+
+	/* recover fsynced data */
+	if (!test_opt(sbi, DISABLE_ROLL_FORWARD))
+		recover_fsync_data(sbi);
+
+	/* After POR, we can run background GC thread */
+	if (start_gc_thread(sbi))
+		goto fail;
+
+#ifdef CONFIG_F2FS_STAT_FS
+	if (f2fs_proc_root) {
+		sbi->s_proc = proc_mkdir(sb->s_id, f2fs_proc_root);
+		if (f2fs_stat_init(sbi))
+			goto fail;
+	}
+#endif
+	return 0;
+fail:
+	stop_gc_thread(sbi);
+free_root_inode:
+	make_bad_inode(root);
+	iput(root);
+free_node_inode:
+	make_bad_inode(sbi->node_inode);
+	iput(sbi->node_inode);
+free_gc:
+	destroy_gc_manager(sbi);
+free_nm:
+	destroy_node_manager(sbi);
+free_sm:
+	destroy_segment_manager(sbi);
+free_cp:
+	kfree(sbi->ckpt);
+free_meta_inode:
+	make_bad_inode(sbi->meta_inode);
+	iput(sbi->meta_inode);
+free_sb_buf:
+	brelse(raw_super_buf);
+free_sbi:
+	kfree(sbi);
+	return -EINVAL;
+}
+
+static struct dentry *f2fs_mount(struct file_system_type *fs_type, int flags,
+			const char *dev_name, void *data)
+{
+	return mount_bdev(fs_type, flags, dev_name, data, f2fs_fill_super);
+}
+
+static struct file_system_type f2fs_fs_type = {
+	.owner		= THIS_MODULE,
+	.name		= "f2fs",
+	.mount		= f2fs_mount,
+	.kill_sb	= kill_block_super,
+	.fs_flags	= FS_REQUIRES_DEV,
+};
+
+static int init_inodecache(void)
+{
+	f2fs_inode_cachep = f2fs_kmem_cache_create("f2fs_inode_cache",
+			sizeof(struct f2fs_inode_info), NULL);
+	if (f2fs_inode_cachep == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+static void destroy_inodecache(void)
+{
+	kmem_cache_destroy(f2fs_inode_cachep);
+}
+
+static int __init init_f2fs_fs(void)
+{
+	if (init_inodecache())
+		goto fail;
+	if (create_node_manager_caches())
+		goto fail;
+	if (create_gc_caches())
+		goto fail;
+	if (create_checkpoint_caches())
+		goto fail;
+	if (register_filesystem(&f2fs_fs_type))
+		return -EBUSY;
+
+	f2fs_proc_root = proc_mkdir("fs/f2fs", NULL);
+	return 0;
+fail:
+	return -ENOMEM;
+}
+
+static void __exit exit_f2fs_fs(void)
+{
+	remove_proc_entry("fs/f2fs", NULL);
+	unregister_filesystem(&f2fs_fs_type);
+	destroy_checkpoint_caches();
+	destroy_gc_caches();
+	destroy_node_manager_caches();
+	destroy_inodecache();
+}
+
+module_init(init_f2fs_fs)
+module_exit(exit_f2fs_fs)
+
+MODULE_AUTHOR("Samsung Electronics's Praesto Team");
+MODULE_DESCRIPTION("Flash Friendly File System");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5




---
Jaegeuk Kim
Samsung



