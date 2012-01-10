Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab2AJMB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 07:01:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44567 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398Ab2AJMBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 07:01:25 -0500
Date: Tue, 10 Jan 2012 13:01:22 +0100
From: Jan Kara <jack@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: manual merge of the ext3 tree with Linus' tree
Message-ID: <20120110120122.GB4516@quack.suse.cz>
References: <20120110122215.a63256b9b640b8ef458e58f8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120110122215.a63256b9b640b8ef458e58f8@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Stephen,

On Tue 10-01-12 12:22:15, Stephen Rothwell wrote:
> Today's linux-next merge of the ext3 tree got a conflict in
> fs/ext2/ioctl.c between commit 2a79f17e4a64 ("vfs: mnt_drop_write_file
> ()") from Linus' tree and commit 6e85201ff4f4 ("ext2: protect inode
> changes in the SETVERSION and SETFLAGS ioctls") from the ext3 tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.
  Thanks. I now rebased my for_next branch on top of Linus's tree and
resolved the conflict so things should be OK from tomorrow.

							Honza

> diff --cc fs/ext2/ioctl.c
> index 1089f76,b7f931f..0000000
> --- a/fs/ext2/ioctl.c
> +++ b/fs/ext2/ioctl.c
> @@@ -80,28 -80,38 +80,38 @@@ long ext2_ioctl(struct file *filp, unsi
>   
>   		ext2_set_inode_flags(inode);
>   		inode->i_ctime = CURRENT_TIME_SEC;
> + 		mutex_unlock(&inode->i_mutex);
> + 
>   		mark_inode_dirty(inode);
>   setflags_out:
>  -		mnt_drop_write(filp->f_path.mnt);
>  +		mnt_drop_write_file(filp);
>   		return ret;
>   	}
>   	case EXT2_IOC_GETVERSION:
>   		return put_user(inode->i_generation, (int __user *) arg);
> - 	case EXT2_IOC_SETVERSION:
> + 	case EXT2_IOC_SETVERSION: {
> + 		__u32 generation;
> + 
>   		if (!inode_owner_or_capable(inode))
>   			return -EPERM;
>  -		ret = mnt_want_write(filp->f_path.mnt);
>  +		ret = mnt_want_write_file(filp);
>   		if (ret)
>   			return ret;
> - 		if (get_user(inode->i_generation, (int __user *) arg)) {
> + 		if (get_user(generation, (int __user *) arg)) {
>   			ret = -EFAULT;
> - 		} else {
> - 			inode->i_ctime = CURRENT_TIME_SEC;
> - 			mark_inode_dirty(inode);
> + 			goto setversion_out;
>   		}
> + 
> + 		mutex_lock(&inode->i_mutex);
> + 		inode->i_ctime = CURRENT_TIME_SEC;
> + 		inode->i_generation = generation;
> + 		mutex_unlock(&inode->i_mutex);
> + 
> + 		mark_inode_dirty(inode);
> + setversion_out:
>  -		mnt_drop_write(filp->f_path.mnt);
>  +		mnt_drop_write_file(filp);
>   		return ret;
> + 	}
>   	case EXT2_IOC_GETRSVSZ:
>   		if (test_opt(inode->i_sb, RESERVATION)
>   			&& S_ISREG(inode->i_mode)


-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
