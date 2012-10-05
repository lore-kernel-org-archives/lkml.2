Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab2JEU2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 16:28:22 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:56687 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab2JEU2T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 16:28:19 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: =?utf-8?B?6rmA7J6s6re5?= <jaegeuk.kim@samsung.com>
Cc: viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <001101cda2f1$50a23c40$f1e6b4c0$%kim@samsung.com>
Date: Fri, 05 Oct 2012 13:28:04 -0700
In-Reply-To: <001101cda2f1$50a23c40$f1e6b4c0$%kim@samsung.com>
 (=?utf-8?B?Iuq5gOyerOq3uSIncw==?=
	message of "Fri, 05 Oct 2012 21:02:38 +0900")
Message-ID: <87mx00slyj.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/v4WI0JVGNx3ceePEc82lh+e+1snoqfxE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 
X-Spam-Combo: =?ISO-8859-1?Q?;=ea=b9=80=ec=9e=ac=ea=b7=b9 <jaegeuk.kim@samsung.com>?=
X-Spam-Relay-Country: 
Subject: Re: [PATCH 10/16] f2fs: add core inode operations
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

김재극 <jaegeuk.kim@samsung.com> writes:

> This adds core functions to get, read, write, and evict an inode.

As is this code won't compile if user namespace support is enabled.
Suggested fixes below.

Eric


> +static int do_read_inode(struct inode *inode)
> +{
> +	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> +	struct f2fs_inode_info *fi = F2FS_I(inode);
> +	struct page *node_page;
> +	struct f2fs_node *rn;
> +	struct f2fs_inode *ri;
> +
> +	/* Check if ino is within scope */
> +	check_nid_range(sbi, inode->i_ino);
> +
> +	node_page = get_node_page(sbi, inode->i_ino);
> +	if (IS_ERR(node_page))
> +		return PTR_ERR(node_page);
> +
> +	rn = page_address(node_page);
> +	ri = &(rn->i);
> +
> +	inode->i_mode = le16_to_cpu(ri->i_mode);
> +	inode->i_uid = le32_to_cpu(ri->i_uid);
> +	inode->i_gid = le32_to_cpu(ri->i_gid);

Could you make this:
	i_uid_write(inode, le32_to_cpu(ri->i_uid));
	i_gid_write(inode, le32_to_cpu(ri->i_gid));

> +	set_nlink(inode, le32_to_cpu(ri->i_links));
> +	inode->i_size = le64_to_cpu(ri->i_size);
> +	inode->i_blocks = le64_to_cpu(ri->i_blocks);
> +
> +	inode->i_atime.tv_sec = le32_to_cpu(ri->i_atime);
> +	inode->i_ctime.tv_sec = le32_to_cpu(ri->i_ctime);
> +	inode->i_mtime.tv_sec = le32_to_cpu(ri->i_mtime);
> +	inode->i_atime.tv_nsec = 0;
> +	inode->i_ctime.tv_nsec = 0;
> +	inode->i_mtime.tv_nsec = 0;
> +	fi->current_depth = le32_to_cpu(ri->current_depth);
> +	fi->i_xattr_nid = le32_to_cpu(ri->i_xattr_nid);
> +	fi->i_flags = le32_to_cpu(ri->i_flags);
> +	fi->flags = 0;
> +	fi->data_version = le64_to_cpu(F2FS_CKPT(sbi)->checkpoint_ver) - 1;
> +	get_extent_info(&fi->ext, ri->i_ext);
> +	f2fs_put_page(node_page, 1);
> +	return 0;
> +}

> +void update_inode(struct inode *inode, struct page *node_page)
> +{
> +	struct f2fs_node *rn;
> +	struct f2fs_inode *ri;
> +
> +	wait_on_page_writeback(node_page);
> +
> +	rn = page_address(node_page);
> +	ri = &(rn->i);
> +
> +	ri->i_mode = cpu_to_le16(inode->i_mode);
> +	ri->i_uid = cpu_to_le32(inode->i_uid);
> +	ri->i_gid = cpu_to_le32(inode->i_gid);
And make this:
	i_uid_write(inode, le32_to_cpu(ri->i_uid));
	i_gid_write(inode, le32_to_cpu(ri->i_gid));

> +	ri->i_links = cpu_to_le32(inode->i_nlink);
> +	ri->i_size = cpu_to_le64(i_size_read(inode));
> +	ri->i_blocks = cpu_to_le64(inode->i_blocks);
> +	set_raw_extent(&F2FS_I(inode)->ext, &ri->i_ext);
> +
> +	ri->i_ctime = cpu_to_le32(inode->i_ctime.tv_sec);
> +	ri->i_mtime = cpu_to_le32(inode->i_mtime.tv_sec);
> +	ri->i_atime = cpu_to_le32(inode->i_atime.tv_sec);
> +	ri->current_depth = cpu_to_le32(F2FS_I(inode)->current_depth);
> +	ri->i_xattr_nid = cpu_to_le32(F2FS_I(inode)->i_xattr_nid);
> +	ri->i_flags = cpu_to_le32(F2FS_I(inode)->i_flags);
> +	set_page_dirty(node_page);
> +}
