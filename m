Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab2JWGv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 02:51:27 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56799 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab2JWGvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 02:51:25 -0400
MIME-Version: 1.0
In-Reply-To: <001401cdb0c5$e9a7da30$bcf78e90$%kim@samsung.com>
References: <001001cdb0c5$2ac96520$805c2f60$%kim@samsung.com>
	<001401cdb0c5$e9a7da30$bcf78e90$%kim@samsung.com>
Date: Tue, 23 Oct 2012 08:51:21 +0200
Message-ID: <CANGUGtCoC80Z4rj7T_qrdyK8WcW2oOxm46mkorUs5abrUKLcsQ@mail.gmail.com>
Subject: Re: [PATCH 04/16 v2] f2fs: add super block operations
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, arnd@arndb.de,
        tytso@mit.edu, chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/23 Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> This adds the implementation of superblock operations for f2fs, which includes
> - init_f2fs_fs/exit_f2fs_fs
> - f2fs_mount
> - super_operations of f2fs
>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> ---
>  fs/f2fs/super.c |  590 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 590 insertions(+)
>  create mode 100644 fs/f2fs/super.c
>
> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> new file mode 100644
> index 0000000..8e608a0
> --- /dev/null
> +++ b/fs/f2fs/super.c
> @@ -0,0 +1,590 @@
> +/**
> + * fs/f2fs/super.c
> + *
> + * Copyright (c) 2012 Samsung Electronics Co., Ltd.
> + *             http://www.samsung.com/
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/fs.h>
> +#include <linux/statfs.h>
> +#include <linux/proc_fs.h>
> +#include <linux/buffer_head.h>
> +#include <linux/backing-dev.h>
> +#include <linux/kthread.h>
> +#include <linux/parser.h>
> +#include <linux/mount.h>
> +#include <linux/seq_file.h>
> +#include <linux/f2fs_fs.h>
> +
> +#include "f2fs.h"
> +#include "node.h"
> +#include "xattr.h"
> +
> +static struct kmem_cache *f2fs_inode_cachep;
> +static struct proc_dir_entry *f2fs_proc_root;
> +
> +enum {
> +       Opt_gc_background_off,
> +       Opt_disable_roll_forward,
> +       Opt_discard,
> +       Opt_noheap,
> +       Opt_nouser_xattr,
> +       Opt_noacl,
> +       Opt_active_logs,
> +       Opt_disable_ext_identify,
> +       Opt_err,
> +};
> +
> +static match_table_t f2fs_tokens = {
> +       {Opt_gc_background_off, "background_gc_off"},
> +       {Opt_disable_roll_forward, "disable_roll_forward"},
> +       {Opt_discard, "discard"},
> +       {Opt_noheap, "no_heap"},
> +       {Opt_nouser_xattr, "nouser_xattr"},
> +       {Opt_noacl, "noacl"},
> +       {Opt_active_logs, "active_logs=%u"},
> +       {Opt_disable_ext_identify, "disable_ext_identify"},
> +       {Opt_err, NULL},
> +};
> +
> +static void init_once(void *foo)
> +{
> +       struct f2fs_inode_info *fi = (struct f2fs_inode_info *) foo;
> +
> +       memset(fi, 0, sizeof(*fi));
> +       inode_init_once(&fi->vfs_inode);
> +}
> +
> +static struct inode *f2fs_alloc_inode(struct super_block *sb)
> +{
> +       struct f2fs_inode_info *fi;
> +
> +       fi = kmem_cache_alloc(f2fs_inode_cachep, GFP_NOFS | __GFP_ZERO);
> +       if (!fi)
> +               return NULL;
> +
> +       init_once((void *) fi);
> +
> +       /* Initilize f2fs-specific inode info */
> +       fi->vfs_inode.i_version = 1;
> +       atomic_set(&fi->dirty_dents, 0);
> +       fi->current_depth = 1;
> +       fi->i_advise = 0;
> +       rwlock_init(&fi->ext.ext_lock);
> +
> +       set_inode_flag(fi, FI_NEW_INODE);
> +
> +       return &fi->vfs_inode;
> +}
> +
> +static void f2fs_i_callback(struct rcu_head *head)
> +{
> +       struct inode *inode = container_of(head, struct inode, i_rcu);
> +       kmem_cache_free(f2fs_inode_cachep, F2FS_I(inode));
> +}
> +
> +void f2fs_destroy_inode(struct inode *inode)
> +{
> +       call_rcu(&inode->i_rcu, f2fs_i_callback);
> +}
> +
> +static void f2fs_put_super(struct super_block *sb)
> +{
> +       struct f2fs_sb_info *sbi = F2FS_SB(sb);
> +
> +#ifdef CONFIG_F2FS_STAT_FS
> +       if (sbi->s_proc) {
> +               f2fs_stat_exit(sbi);
> +               remove_proc_entry(sb->s_id, f2fs_proc_root);
> +       }
> +#endif
> +       stop_gc_thread(sbi);
> +
> +       write_checkpoint(sbi, false, true);
> +
> +       iput(sbi->node_inode);
> +       iput(sbi->meta_inode);
> +
> +       /* destroy f2fs internal modules */
> +       destroy_gc_manager(sbi);
> +       destroy_node_manager(sbi);
> +       destroy_segment_manager(sbi);
> +
> +       kfree(sbi->ckpt);
> +
> +       sb->s_fs_info = NULL;
> +       brelse(sbi->raw_super_buf);
> +       kfree(sbi);
> +}
> +
> +int f2fs_sync_fs(struct super_block *sb, int sync)
> +{
> +       struct f2fs_sb_info *sbi = F2FS_SB(sb);
> +       int ret = 0;
> +
> +       if (!sbi->s_dirty && !get_pages(sbi, F2FS_DIRTY_NODES))
> +               return 0;
> +
> +       if (sync)
> +               write_checkpoint(sbi, false, false);
> +
> +       return ret;
> +}
> +
> +static int f2fs_statfs(struct dentry *dentry, struct kstatfs *buf)
> +{
> +       struct super_block *sb = dentry->d_sb;
> +       struct f2fs_sb_info *sbi = F2FS_SB(sb);
> +       block_t total_count, user_block_count, start_count, ovp_count;
> +
> +       total_count = le64_to_cpu(sbi->raw_super->block_count);
> +       user_block_count = sbi->user_block_count;
> +       start_count = le32_to_cpu(sbi->raw_super->segment0_blkaddr);
> +       ovp_count = sbi->gc_info->overp_segment_count
> +                                       << sbi->log_blocks_per_seg;
> +       buf->f_type = F2FS_SUPER_MAGIC;
> +       buf->f_bsize = sbi->blocksize;
> +
> +       buf->f_blocks = total_count - start_count;
> +       buf->f_bfree = buf->f_blocks - valid_user_blocks(sbi) - ovp_count;
> +       buf->f_bavail = user_block_count - valid_user_blocks(sbi);
> +
> +       buf->f_files = valid_inode_count(sbi);
> +       buf->f_ffree = sbi->total_node_count - valid_node_count(sbi);
> +
> +       buf->f_namelen = F2FS_MAX_NAME_LEN;
> +
> +       return 0;
> +}
> +
> +static int f2fs_show_options(struct seq_file *seq, struct dentry *root)
> +{
> +       struct f2fs_sb_info *sbi = F2FS_SB(root->d_sb);
> +
> +       if (test_opt(sbi, BG_GC))
> +               seq_puts(seq, ",background_gc_on");
> +       else
> +               seq_puts(seq, ",background_gc_off");
> +       if (test_opt(sbi, DISABLE_ROLL_FORWARD))
> +               seq_puts(seq, ",disable_roll_forward");
> +       if (test_opt(sbi, DISCARD))
> +               seq_puts(seq, ",discard");
> +       if (test_opt(sbi, NOHEAP))
> +               seq_puts(seq, ",no_heap_alloc");
> +#ifdef CONFIG_F2FS_FS_XATTR
> +       if (test_opt(sbi, XATTR_USER))
> +               seq_puts(seq, ",user_xattr");
> +       else
> +               seq_puts(seq, ",nouser_xattr");
> +#endif
> +#ifdef CONFIG_F2FS_FS_POSIX_ACL
> +       if (test_opt(sbi, POSIX_ACL))
> +               seq_puts(seq, ",acl");
> +       else
> +               seq_puts(seq, ",noacl");
> +#endif
> +       if (test_opt(sbi, DISABLE_EXT_IDENTIFY))
> +               seq_puts(seq, ",disable_ext_indentify");
> +
> +       seq_printf(seq, ",active_logs=%u", sbi->active_logs);
> +
> +       return 0;
> +}
> +
> +static struct super_operations f2fs_sops = {
> +       .alloc_inode    = f2fs_alloc_inode,
> +       .destroy_inode  = f2fs_destroy_inode,
> +       .write_inode    = f2fs_write_inode,
> +       .show_options   = f2fs_show_options,
> +       .evict_inode    = f2fs_evict_inode,
> +       .put_super      = f2fs_put_super,
> +       .sync_fs        = f2fs_sync_fs,
> +       .statfs         = f2fs_statfs,
> +};
> +
> +static int parse_options(struct f2fs_sb_info *sbi, char *options)
> +{
> +       substring_t args[MAX_OPT_ARGS];
> +       char *p;
> +       int arg = 0;
> +
> +       if (!options)
> +               return 0;
> +
> +       while ((p = strsep(&options, ",")) != NULL) {
> +               int token;
> +               if (!*p)
> +                       continue;
> +               /*
> +                * Initialize args struct so we know whether arg was
> +                * found; some options take optional arguments.
> +                */
> +               args[0].to = args[0].from = NULL;
> +               token = match_token(p, f2fs_tokens, args);
> +
> +               switch (token) {
> +               case Opt_gc_background_off:
> +                       clear_opt(sbi, BG_GC);
> +                       break;
> +               case Opt_disable_roll_forward:
> +                       set_opt(sbi, DISABLE_ROLL_FORWARD);
> +                       break;
> +               case Opt_discard:
> +                       set_opt(sbi, DISCARD);
> +                       break;
> +               case Opt_noheap:
> +                       set_opt(sbi, NOHEAP);
> +                       break;
> +#ifdef CONFIG_F2FS_FS_XATTR
> +               case Opt_nouser_xattr:
> +                       clear_opt(sbi, XATTR_USER);
> +                       break;
> +#else
> +               case Opt_nouser_xattr:
> +                       pr_info("nouser_xattr options not supported\n");
> +                       break;
> +#endif
> +#ifdef CONFIG_F2FS_FS_POSIX_ACL
> +               case Opt_noacl:
> +                       clear_opt(sbi, POSIX_ACL);
> +                       break;
> +#else
> +               case Opt_noacl:
> +                       pr_info("noacl options not supported\n");
> +                       break;
> +#endif
> +               case Opt_active_logs:
> +                       if (args->from && match_int(args, &arg))
> +                               return -EINVAL;
> +                       if (arg != 2 && arg != 4 && arg != 6)
> +                               return -EINVAL;
> +                       sbi->active_logs = arg;
> +                       break;
> +               case Opt_disable_ext_identify:
> +                       set_opt(sbi, DISABLE_EXT_IDENTIFY);
> +                       break;
> +               default:
> +                       return -EINVAL;
> +               }
> +       }
> +       return 0;
> +}
> +
> +static loff_t max_file_size(unsigned bits)
> +{
> +       loff_t result = ADDRS_PER_INODE;
> +       loff_t leaf_count = ADDRS_PER_BLOCK;
> +
> +       result += (leaf_count * 2);
> +
> +       leaf_count *= NIDS_PER_BLOCK;
> +       result += (leaf_count * 2);
> +
> +       leaf_count *= NIDS_PER_BLOCK;
> +       result += (leaf_count * 2);
> +
> +       result <<= bits;
> +       return result;
> +}
> +
> +static int sanity_check_raw_super(struct f2fs_super_block *raw_super)
> +{
> +       unsigned int blocksize;
> +
> +       if (F2FS_SUPER_MAGIC != le32_to_cpu(raw_super->magic))
> +               return 1;
> +
> +       /* Currently, support only 4KB block size */
> +       blocksize = 1 << le32_to_cpu(raw_super->log_blocksize);
> +       if (blocksize != PAGE_CACHE_SIZE)
> +               return 1;
> +       if (le32_to_cpu(raw_super->log_sectorsize) != 9)
> +               return 1;
> +       if (le32_to_cpu(raw_super->log_sectors_per_block) != 3)
> +               return 1;
> +       return 0;
> +}
> +
> +static int sanity_check_ckpt(struct f2fs_super_block *raw_super,
> +                               struct f2fs_checkpoint *ckpt)
> +{
> +       unsigned int total, fsmeta;
> +
> +       total = le32_to_cpu(raw_super->segment_count);
> +       fsmeta = le32_to_cpu(raw_super->segment_count_ckpt);
> +       fsmeta += le32_to_cpu(raw_super->segment_count_sit);
> +       fsmeta += le32_to_cpu(raw_super->segment_count_nat);
> +       fsmeta += le32_to_cpu(ckpt->rsvd_segment_count);
> +       fsmeta += le32_to_cpu(raw_super->segment_count_ssa);
> +
> +       if (fsmeta >= total)
> +               return 1;
> +       return 0;
> +}
> +
> +static void init_sb_info(struct f2fs_sb_info *sbi)
> +{
> +       struct f2fs_super_block *raw_super = sbi->raw_super;
> +       int i;
> +
> +       sbi->log_sectorsize = le32_to_cpu(raw_super->log_sectorsize);
> +       sbi->log_sectors_per_block =
> +               le32_to_cpu(raw_super->log_sectors_per_block);
> +       sbi->log_blocksize = le32_to_cpu(raw_super->log_blocksize);
> +       sbi->blocksize = 1 << sbi->log_blocksize;
> +       sbi->log_blocks_per_seg = le32_to_cpu(raw_super->log_blocks_per_seg);
> +       sbi->blocks_per_seg = 1 << sbi->log_blocks_per_seg;
> +       sbi->segs_per_sec = le32_to_cpu(raw_super->segs_per_sec);
> +       sbi->secs_per_zone = le32_to_cpu(raw_super->secs_per_zone);
> +       sbi->total_sections = le32_to_cpu(raw_super->section_count);
> +       sbi->total_node_count =
> +               (le32_to_cpu(raw_super->segment_count_nat) / 2)
> +                       * sbi->blocks_per_seg * NAT_ENTRY_PER_BLOCK;
> +       sbi->root_ino_num = le32_to_cpu(raw_super->root_ino);
> +       sbi->node_ino_num = le32_to_cpu(raw_super->node_ino);
> +       sbi->meta_ino_num = le32_to_cpu(raw_super->meta_ino);
> +
> +       for (i = 0; i < NR_COUNT_TYPE; i++)
> +               atomic_set(&sbi->nr_pages[i], 0);
> +}
> +
> +static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
> +{
> +       struct f2fs_sb_info *sbi;
> +       struct f2fs_super_block *raw_super;
> +       struct buffer_head *raw_super_buf;
> +       struct inode *root;
> +       int i;
> +
> +       /* allocate memory for f2fs-specific super block info */
> +       sbi = kzalloc(sizeof(struct f2fs_sb_info), GFP_KERNEL);
> +       if (!sbi)
> +               return -ENOMEM;
> +
> +       /* set a temporary block size */
> +       if (!sb_set_blocksize(sb, F2FS_BLKSIZE))
> +               goto free_sbi;
> +
> +       /* read f2fs raw super block */
> +       raw_super_buf = sb_bread(sb, F2FS_SUPER_OFFSET);
> +       if (!raw_super_buf)
> +               goto free_sbi;
> +       raw_super = (struct f2fs_super_block *) ((char *)raw_super_buf->b_data);
> +
> +       /* init some FS parameters */
> +       sbi->active_logs = NR_CURSEG_TYPE;
> +
> +       set_opt(sbi, BG_GC);
> +
> +#ifdef CONFIG_F2FS_FS_XATTR
> +       set_opt(sbi, XATTR_USER);
> +#endif
> +#ifdef CONFIG_F2FS_FS_POSIX_ACL
> +       set_opt(sbi, POSIX_ACL);
> +#endif
> +       /* parse mount options */
> +       if (parse_options(sbi, (char *)data))
> +               goto free_sb_buf;
> +
> +       /* sanity checking of raw super */
> +       if (sanity_check_raw_super(raw_super))
> +               goto free_sb_buf;
> +
> +       sb->s_maxbytes = max_file_size(raw_super->log_blocksize);
> +       sb->s_max_links = F2FS_LINK_MAX;
> +
> +       sb->s_op = &f2fs_sops;
> +       sb->s_xattr = f2fs_xattr_handlers;
> +       sb->s_magic = F2FS_SUPER_MAGIC;
> +       sb->s_fs_info = sbi;

and s_time_gran?

Marco
