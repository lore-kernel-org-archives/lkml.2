Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab2JFSGi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 14:06:38 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63904 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab2JFSGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 14:06:36 -0400
Message-ID: <1349546786.12699.36.camel@kjgkr>
Subject: Re: [PATCH 10/16] f2fs: add core inode operations
From: Jaegeuk Kim <jaegeuk.kim@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: =?euc-kr?Q?=B1=E8=C0=E7=B1=D8?= <jaegeuk.kim@samsung.com>,
        viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Date: Sun, 07 Oct 2012 03:06:26 +0900
In-Reply-To: <87mx00slyj.fsf@xmission.com>
References: <001101cda2f1$50a23c40$f1e6b4c0$%kim@samsung.com>
	 <87mx00slyj.fsf@xmission.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-10-05 (금), 13:28 -0700, Eric W. Biederman:
> 김재극 <jaegeuk.kim@samsung.com> writes:
> 
> > This adds core functions to get, read, write, and evict an inode.
> 
> As is this code won't compile if user namespace support is enabled.
> Suggested fixes below.

Ok, I'll check this out.
Thanks,

> 
> Eric
> 
> 
> > +static int do_read_inode(struct inode *inode)
> > +{
> > +	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> > +	struct f2fs_inode_info *fi = F2FS_I(inode);
> > +	struct page *node_page;
> > +	struct f2fs_node *rn;
> > +	struct f2fs_inode *ri;
> > +
> > +	/* Check if ino is within scope */
> > +	check_nid_range(sbi, inode->i_ino);
> > +
> > +	node_page = get_node_page(sbi, inode->i_ino);
> > +	if (IS_ERR(node_page))
> > +		return PTR_ERR(node_page);
> > +
> > +	rn = page_address(node_page);
> > +	ri = &(rn->i);
> > +
> > +	inode->i_mode = le16_to_cpu(ri->i_mode);
> > +	inode->i_uid = le32_to_cpu(ri->i_uid);
> > +	inode->i_gid = le32_to_cpu(ri->i_gid);
> 
> Could you make this:
> 	i_uid_write(inode, le32_to_cpu(ri->i_uid));
> 	i_gid_write(inode, le32_to_cpu(ri->i_gid));
> 
> > +	set_nlink(inode, le32_to_cpu(ri->i_links));
> > +	inode->i_size = le64_to_cpu(ri->i_size);
> > +	inode->i_blocks = le64_to_cpu(ri->i_blocks);
> > +
> > +	inode->i_atime.tv_sec = le32_to_cpu(ri->i_atime);
> > +	inode->i_ctime.tv_sec = le32_to_cpu(ri->i_ctime);
> > +	inode->i_mtime.tv_sec = le32_to_cpu(ri->i_mtime);
> > +	inode->i_atime.tv_nsec = 0;
> > +	inode->i_ctime.tv_nsec = 0;
> > +	inode->i_mtime.tv_nsec = 0;
> > +	fi->current_depth = le32_to_cpu(ri->current_depth);
> > +	fi->i_xattr_nid = le32_to_cpu(ri->i_xattr_nid);
> > +	fi->i_flags = le32_to_cpu(ri->i_flags);
> > +	fi->flags = 0;
> > +	fi->data_version = le64_to_cpu(F2FS_CKPT(sbi)->checkpoint_ver) - 1;
> > +	get_extent_info(&fi->ext, ri->i_ext);
> > +	f2fs_put_page(node_page, 1);
> > +	return 0;
> > +}
> 
> > +void update_inode(struct inode *inode, struct page *node_page)
> > +{
> > +	struct f2fs_node *rn;
> > +	struct f2fs_inode *ri;
> > +
> > +	wait_on_page_writeback(node_page);
> > +
> > +	rn = page_address(node_page);
> > +	ri = &(rn->i);
> > +
> > +	ri->i_mode = cpu_to_le16(inode->i_mode);
> > +	ri->i_uid = cpu_to_le32(inode->i_uid);
> > +	ri->i_gid = cpu_to_le32(inode->i_gid);
> And make this:
> 	i_uid_write(inode, le32_to_cpu(ri->i_uid));
> 	i_gid_write(inode, le32_to_cpu(ri->i_gid));
> 
> > +	ri->i_links = cpu_to_le32(inode->i_nlink);
> > +	ri->i_size = cpu_to_le64(i_size_read(inode));
> > +	ri->i_blocks = cpu_to_le64(inode->i_blocks);
> > +	set_raw_extent(&F2FS_I(inode)->ext, &ri->i_ext);
> > +
> > +	ri->i_ctime = cpu_to_le32(inode->i_ctime.tv_sec);
> > +	ri->i_mtime = cpu_to_le32(inode->i_mtime.tv_sec);
> > +	ri->i_atime = cpu_to_le32(inode->i_atime.tv_sec);
> > +	ri->current_depth = cpu_to_le32(F2FS_I(inode)->current_depth);
> > +	ri->i_xattr_nid = cpu_to_le32(F2FS_I(inode)->i_xattr_nid);
> > +	ri->i_flags = cpu_to_le32(F2FS_I(inode)->i_flags);
> > +	set_page_dirty(node_page);
> > +}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Jaegeuk Kim
Samsung



