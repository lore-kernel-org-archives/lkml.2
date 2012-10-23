Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754Ab2JWHjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 03:39:46 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:41713 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab2JWHjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 03:39:45 -0400
MIME-Version: 1.0
In-Reply-To: <009b01cdb0f0$6ad18cd0$4074a670$%kim@samsung.com>
References: <001001cdb0c5$2ac96520$805c2f60$%kim@samsung.com>
	<001801cdb0c6$35bd6430$a1382c90$%kim@samsung.com>
	<CANGUGtASk=_xd4xz_PXA+ittW2G2Z01DXsRjH67jBgXdpiG82w@mail.gmail.com>
	<009b01cdb0f0$6ad18cd0$4074a670$%kim@samsung.com>
Date: Tue, 23 Oct 2012 09:39:44 +0200
Message-ID: <CANGUGtDCV28y=aO6rrPEbsY+u4hMq_r8+HDVeCdRE_9Yd2i0ow@mail.gmail.com>
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
>> > +void f2fs_truncate(struct inode *inode)
>> > +{
>> > +       if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
>> > +                               S_ISLNK(inode->i_mode)))
>> > +               return;
>> > +
>> > +       if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
>> > +               return;
>>
>> No truncate for an append only file? You call f2fs_truncate from
>> evict_inode, so no block freeing when this kind of inode is deleted.
>
> Agreed.
>
>>
>> > +
>> > +       if (!truncate_blocks(inode, i_size_read(inode))) {
>> > +               inode->i_mtime = inode->i_ctime = CURRENT_TIME;
>> > +               mark_inode_dirty(inode);
>> > +       }
>> > +
>> > +       f2fs_balance_fs(F2FS_SB(inode->i_sb));
>> > +}
>> > +
>> > +static int f2fs_getattr(struct vfsmount *mnt,
>> > +                        struct dentry *dentry, struct kstat *stat)
>> > +{
>> > +       struct inode *inode = dentry->d_inode;
>> > +       generic_fillattr(inode, stat);
>> > +       stat->blocks <<= 3;
>> > +       return 0;
>> > +}
>> > +
>> > +#ifdef CONFIG_F2FS_FS_POSIX_ACL
>> > +static void __setattr_copy(struct inode *inode, const struct iattr *attr)
>> > +{
>> > +       struct f2fs_inode_info *fi = F2FS_I(inode);
>> > +       unsigned int ia_valid = attr->ia_valid;
>> > +
>> > +       if (ia_valid & ATTR_UID)
>> > +               inode->i_uid = attr->ia_uid;
>> > +       if (ia_valid & ATTR_GID)
>> > +               inode->i_gid = attr->ia_gid;
>> > +       if (ia_valid & ATTR_ATIME)
>> > +               inode->i_atime = timespec_trunc(attr->ia_atime,
>> > +                                               inode->i_sb->s_time_gran);
>> > +       if (ia_valid & ATTR_MTIME)
>> > +               inode->i_mtime = timespec_trunc(attr->ia_mtime,
>> > +                                               inode->i_sb->s_time_gran);
>> > +       if (ia_valid & ATTR_CTIME)
>> > +               inode->i_ctime = timespec_trunc(attr->ia_ctime,
>> > +                                               inode->i_sb->s_time_gran);
>> > +       if (ia_valid & ATTR_MODE) {
>> > +               umode_t mode = attr->ia_mode;
>> > +
>> > +               if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
>> > +                       mode &= ~S_ISGID;
>> > +               set_acl_inode(fi, mode);
>> > +       }
>> > +}
>> > +#else
>> > +#define __setattr_copy setattr_copy
>> > +#endif
>> > +
>> > +int f2fs_setattr(struct dentry *dentry, struct iattr *attr)
>> > +{
>> > +       struct inode *inode = dentry->d_inode;
>> > +       struct f2fs_inode_info *fi = F2FS_I(inode);
>> > +       int err;
>> > +
>> > +       err = inode_change_ok(inode, attr);
>> > +       if (err)
>> > +               return err;
>> > +
>> > +       if ((attr->ia_valid & ATTR_SIZE) &&
>> > +                       attr->ia_size != i_size_read(inode)) {
>> > +               truncate_setsize(inode, attr->ia_size);
>> > +               f2fs_truncate(inode);
>>
>> No need to call truncate_pagecache & co.?
>
> truncate_setsize() calls truncate_pagecache().
> Any comment?

Yep, I didn't get my coffee yet :)

Marco
