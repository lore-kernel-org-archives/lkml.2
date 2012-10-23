Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab2JWG67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 02:58:59 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:38997 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651Ab2JWG65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 02:58:57 -0400
MIME-Version: 1.0
In-Reply-To: <001801cdb0c6$35bd6430$a1382c90$%kim@samsung.com>
References: <001001cdb0c5$2ac96520$805c2f60$%kim@samsung.com>
	<001801cdb0c6$35bd6430$a1382c90$%kim@samsung.com>
Date: Tue, 23 Oct 2012 08:58:56 +0200
Message-ID: <CANGUGtASk=_xd4xz_PXA+ittW2G2Z01DXsRjH67jBgXdpiG82w@mail.gmail.com>
Subject: Re: [PATCH 08/16 v2] f2fs: add file operations
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
> This adds memory operations and file/file_inode operations.
>
> - F2FS supports fallocate(), mmap(), fsync(), and basic ioctl().
>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> ---
>  fs/f2fs/file.c |  640 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 640 insertions(+)
>  create mode 100644 fs/f2fs/file.c
>
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> new file mode 100644
> index 0000000..81b1fd0
> --- /dev/null
> +++ b/fs/f2fs/file.c
> @@ -0,0 +1,640 @@
> +/**
> + * fs/f2fs/file.c
> + *
> + * Copyright (c) 2012 Samsung Electronics Co., Ltd.
> + *             http://www.samsung.com/
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#include <linux/fs.h>
> +#include <linux/f2fs_fs.h>
> +#include <linux/stat.h>
> +#include <linux/buffer_head.h>
> +#include <linux/writeback.h>
> +#include <linux/falloc.h>
> +#include <linux/types.h>
> +#include <linux/uaccess.h>
> +#include <linux/mount.h>
> +
> +#include "f2fs.h"
> +#include "node.h"
> +#include "segment.h"
> +#include "xattr.h"
> +#include "acl.h"
> +
> +static int f2fs_vm_page_mkwrite(struct vm_area_struct *vma,
> +                                               struct vm_fault *vmf)
> +{
> +       struct page *page = vmf->page;
> +       struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
> +       struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> +       struct page *node_page;
> +       block_t old_blk_addr;
> +       struct dnode_of_data dn;
> +       int err;
> +
> +       f2fs_balance_fs(sbi);
> +
> +       sb_start_pagefault(inode->i_sb);
> +
> +       mutex_lock_op(sbi, DATA_NEW);
> +
> +       /* block allocation */
> +       set_new_dnode(&dn, inode, NULL, NULL, 0);
> +       err = get_dnode_of_data(&dn, page->index, 0);
> +       if (err) {
> +               mutex_unlock_op(sbi, DATA_NEW);
> +               goto out;
> +       }
> +
> +       old_blk_addr = dn.data_blkaddr;
> +       node_page = dn.node_page;
> +
> +       if (old_blk_addr == NULL_ADDR) {
> +               err = reserve_new_block(&dn);
> +               if (err) {
> +                       f2fs_put_dnode(&dn);
> +                       mutex_unlock_op(sbi, DATA_NEW);
> +                       goto out;
> +               }
> +       }
> +       f2fs_put_dnode(&dn);
> +
> +       mutex_unlock_op(sbi, DATA_NEW);
> +
> +       lock_page(page);
> +       if (page->mapping != inode->i_mapping ||
> +                       page_offset(page) >= i_size_read(inode) ||
> +                       !PageUptodate(page)) {
> +               unlock_page(page);
> +               err = -EFAULT;
> +               goto out;
> +       }
> +
> +       /*
> +        * check to see if the page is mapped already (no holes)
> +        */
> +       if (PageMappedToDisk(page))
> +               goto out;
> +
> +       /* fill the page */
> +       wait_on_page_writeback(page);
> +
> +       /* page is wholly or partially inside EOF */
> +       if (((page->index + 1) << PAGE_CACHE_SHIFT) > i_size_read(inode)) {
> +               unsigned offset;
> +               offset = i_size_read(inode) & ~PAGE_CACHE_MASK;
> +               zero_user_segment(page, offset, PAGE_CACHE_SIZE);
> +       }
> +       set_page_dirty(page);
> +       SetPageUptodate(page);
> +
> +       file_update_time(vma->vm_file);
> +out:
> +       sb_end_pagefault(inode->i_sb);
> +       return block_page_mkwrite_return(err);
> +}
> +
> +static const struct vm_operations_struct f2fs_file_vm_ops = {
> +       .fault        = filemap_fault,
> +       .page_mkwrite = f2fs_vm_page_mkwrite,
> +};
> +
> +static int need_to_sync_dir(struct f2fs_sb_info *sbi, struct inode *inode)
> +{
> +       struct dentry *dentry;
> +       nid_t pino;
> +
> +       inode = igrab(inode);
> +       dentry = d_find_any_alias(inode);
> +       if (!dentry) {
> +               iput(inode);
> +               return 0;
> +       }
> +       pino = dentry->d_parent->d_inode->i_ino;
> +       dput(dentry);
> +       iput(inode);
> +       return !is_checkpointed_node(sbi, pino);
> +}
> +
> +int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
> +{
> +       struct inode *inode = file->f_mapping->host;
> +       struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> +       unsigned long long cur_version;
> +       int ret = 0;
> +       bool need_cp = false;
> +       struct writeback_control wbc = {
> +               .sync_mode = WB_SYNC_ALL,
> +               .nr_to_write = LONG_MAX,
> +               .for_reclaim = 0,
> +       };
> +
> +       ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
> +       if (ret)
> +               return ret;
> +
> +       mutex_lock(&inode->i_mutex);
> +
> +       if (inode->i_sb->s_flags & MS_RDONLY)
> +               goto out;
> +       if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
> +               goto out;
> +
> +       mutex_lock(&sbi->cp_mutex);
> +       cur_version = le64_to_cpu(F2FS_CKPT(sbi)->checkpoint_ver);
> +       mutex_unlock(&sbi->cp_mutex);
> +
> +       if (F2FS_I(inode)->data_version != cur_version &&
> +                                       !(inode->i_state & I_DIRTY))
> +               goto out;
> +       F2FS_I(inode)->data_version--;
> +
> +       if (!S_ISREG(inode->i_mode) || inode->i_nlink != 1)
> +               need_cp = true;
> +       if (is_inode_flag_set(F2FS_I(inode), FI_NEED_CP))
> +               need_cp = true;
> +       if (!space_for_roll_forward(sbi))
> +               need_cp = true;
> +       if (need_to_sync_dir(sbi, inode))
> +               need_cp = true;
> +
> +       f2fs_write_inode(inode, NULL);
> +
> +       if (need_cp) {
> +               /* all the dirty node pages should be flushed for POR */
> +               ret = f2fs_sync_fs(inode->i_sb, 1);
> +               clear_inode_flag(F2FS_I(inode), FI_NEED_CP);
> +       } else {
> +               while (sync_node_pages(sbi, inode->i_ino, &wbc) == 0)
> +                       f2fs_write_inode(inode, NULL);
> +               filemap_fdatawait_range(sbi->node_inode->i_mapping,
> +                                                       0, LONG_MAX);
> +       }
> +out:
> +       mutex_unlock(&inode->i_mutex);
> +       return ret;
> +}
> +
> +static int f2fs_file_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +       file_accessed(file);
> +       vma->vm_ops = &f2fs_file_vm_ops;
> +       return 0;
> +}
> +
> +static int truncate_data_blocks_range(struct dnode_of_data *dn, int count)
> +{
> +       int nr_free = 0, ofs = dn->ofs_in_node;
> +       struct f2fs_sb_info *sbi = F2FS_SB(dn->inode->i_sb);
> +       struct f2fs_node *raw_node;
> +       __le32 *addr;
> +
> +       raw_node = page_address(dn->node_page);
> +       addr = blkaddr_in_node(raw_node) + ofs;
> +
> +       for ( ; count > 0; count--, addr++, dn->ofs_in_node++) {
> +               block_t blkaddr = le32_to_cpu(*addr);
> +               if (blkaddr == NULL_ADDR)
> +                       continue;
> +
> +               update_extent_cache(NULL_ADDR, dn);
> +               invalidate_blocks(sbi, blkaddr);
> +               dec_valid_block_count(sbi, dn->inode, 1);
> +               nr_free++;
> +       }
> +       if (nr_free) {
> +               set_page_dirty(dn->node_page);
> +               sync_inode_page(dn);
> +       }
> +       dn->ofs_in_node = ofs;
> +       return nr_free;
> +}
> +
> +void truncate_data_blocks(struct dnode_of_data *dn)
> +{
> +       truncate_data_blocks_range(dn, ADDRS_PER_BLOCK);
> +}
> +
> +static void truncate_partial_data_page(struct inode *inode, u64 from)
> +{
> +       unsigned offset = from & (PAGE_CACHE_SIZE - 1);
> +       struct page *page;
> +
> +       if (!offset)
> +               return;
> +
> +       page = find_data_page(inode, from >> PAGE_CACHE_SHIFT);
> +       if (IS_ERR(page))
> +               return;
> +
> +       lock_page(page);
> +       wait_on_page_writeback(page);
> +       zero_user(page, offset, PAGE_CACHE_SIZE - offset);
> +       set_page_dirty(page);
> +       f2fs_put_page(page, 1);
> +}
> +
> +static int truncate_blocks(struct inode *inode, u64 from)
> +{
> +       struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> +       unsigned int blocksize = inode->i_sb->s_blocksize;
> +       struct dnode_of_data dn;
> +       pgoff_t free_from;
> +       int count = 0;
> +       int err;
> +
> +       free_from = (pgoff_t)
> +                       ((from + blocksize - 1) >> (sbi->log_blocksize));
> +
> +       mutex_lock_op(sbi, DATA_TRUNC);
> +
> +       set_new_dnode(&dn, inode, NULL, NULL, 0);
> +       err = get_dnode_of_data(&dn, free_from, RDONLY_NODE);
> +       if (err) {
> +               if (err == -ENOENT)
> +                       goto free_next;
> +               mutex_unlock_op(sbi, DATA_TRUNC);
> +               return err;
> +       }
> +
> +       if (IS_INODE(dn.node_page))
> +               count = ADDRS_PER_INODE;
> +       else
> +               count = ADDRS_PER_BLOCK;
> +
> +       count -= dn.ofs_in_node;
> +       BUG_ON(count < 0);
> +       if (dn.ofs_in_node || IS_INODE(dn.node_page)) {
> +               truncate_data_blocks_range(&dn, count);
> +               free_from += count;
> +       }
> +
> +       f2fs_put_dnode(&dn);
> +free_next:
> +       err = truncate_inode_blocks(inode, free_from);
> +       mutex_unlock_op(sbi, DATA_TRUNC);
> +
> +       /* lastly zero out the first data page */
> +       truncate_partial_data_page(inode, from);
> +
> +       return err;
> +}
> +
> +void f2fs_truncate(struct inode *inode)
> +{
> +       if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
> +                               S_ISLNK(inode->i_mode)))
> +               return;
> +
> +       if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
> +               return;

No truncate for an append only file? You call f2fs_truncate from
evict_inode, so no block freeing when this kind of inode is deleted.

> +
> +       if (!truncate_blocks(inode, i_size_read(inode))) {
> +               inode->i_mtime = inode->i_ctime = CURRENT_TIME;
> +               mark_inode_dirty(inode);
> +       }
> +
> +       f2fs_balance_fs(F2FS_SB(inode->i_sb));
> +}
> +
> +static int f2fs_getattr(struct vfsmount *mnt,
> +                        struct dentry *dentry, struct kstat *stat)
> +{
> +       struct inode *inode = dentry->d_inode;
> +       generic_fillattr(inode, stat);
> +       stat->blocks <<= 3;
> +       return 0;
> +}
> +
> +#ifdef CONFIG_F2FS_FS_POSIX_ACL
> +static void __setattr_copy(struct inode *inode, const struct iattr *attr)
> +{
> +       struct f2fs_inode_info *fi = F2FS_I(inode);
> +       unsigned int ia_valid = attr->ia_valid;
> +
> +       if (ia_valid & ATTR_UID)
> +               inode->i_uid = attr->ia_uid;
> +       if (ia_valid & ATTR_GID)
> +               inode->i_gid = attr->ia_gid;
> +       if (ia_valid & ATTR_ATIME)
> +               inode->i_atime = timespec_trunc(attr->ia_atime,
> +                                               inode->i_sb->s_time_gran);
> +       if (ia_valid & ATTR_MTIME)
> +               inode->i_mtime = timespec_trunc(attr->ia_mtime,
> +                                               inode->i_sb->s_time_gran);
> +       if (ia_valid & ATTR_CTIME)
> +               inode->i_ctime = timespec_trunc(attr->ia_ctime,
> +                                               inode->i_sb->s_time_gran);
> +       if (ia_valid & ATTR_MODE) {
> +               umode_t mode = attr->ia_mode;
> +
> +               if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
> +                       mode &= ~S_ISGID;
> +               set_acl_inode(fi, mode);
> +       }
> +}
> +#else
> +#define __setattr_copy setattr_copy
> +#endif
> +
> +int f2fs_setattr(struct dentry *dentry, struct iattr *attr)
> +{
> +       struct inode *inode = dentry->d_inode;
> +       struct f2fs_inode_info *fi = F2FS_I(inode);
> +       int err;
> +
> +       err = inode_change_ok(inode, attr);
> +       if (err)
> +               return err;
> +
> +       if ((attr->ia_valid & ATTR_SIZE) &&
> +                       attr->ia_size != i_size_read(inode)) {
> +               truncate_setsize(inode, attr->ia_size);
> +               f2fs_truncate(inode);

No need to call truncate_pagecache & co.?

Marco
