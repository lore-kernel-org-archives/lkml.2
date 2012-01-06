Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759186Ab2AFUnH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 15:43:07 -0500
Received: from numidia.opendz.org ([98.142.220.152]:47194 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759062Ab2AFUnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 15:43:04 -0500
Date: Fri, 6 Jan 2012 21:46:01 +0100
From: Djalal Harouni <tixxdz@opendz.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Jan Kara <jack@suse.cz>
Subject: Re: linux-next: manual merge of the vfs tree with the ext4 tree
Message-ID: <20120106204601.GA26305@dztty>
References: <20120106135442.1720766a6c1510abf51b2aff@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120106135442.1720766a6c1510abf51b2aff@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(Cc'ed Jan Kara).

On Fri, Jan 06, 2012 at 01:54:42PM +1100, Stephen Rothwell wrote:
> Hi Al,
> 
> Today's linux-next merge of the vfs tree got a conflict in
> fs/ext4/ioctl.c between commits 2a415f129806 ("ext4: add missing
> ext4_resize_end on error paths") and 22cdfca56418 ("ext4: remove unneeded
> file_remove_suid() from ext4_ioctl()") from the ext4 tree and commit
There is also another commit from ext4 involved:
commit ce06c5fa14f1a ("ext{3,4}: Fix potential race when setversion ioctl
updates inode) by Jan Kara.

All these ext4 commits are fine.

> a561be7100cd ("switch a bunch of places to mnt_want_write_file()") from
> the vfs tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc fs/ext4/ioctl.c
> index f2c335b,d37b3bb..0000000
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@@ -173,11 -170,8 +173,11 @@@ flags_out
>   			err = ext4_mark_iloc_dirty(handle, inode, &iloc);
>   		}
>   		ext4_journal_stop(handle);
>  +
>  +unlock_out:
>  +		mutex_unlock(&inode->i_mutex);
This is the code related to commit: ce06c5fa14f1a

Thanks for the fix.

>   setversion_out:
> - 		mnt_drop_write(filp->f_path.mnt);
> + 		mnt_drop_write_file(filp);
>   		return err;
>   	}
>   	case EXT4_IOC_GROUP_EXTEND: {
> @@@ -197,13 -189,12 +197,13 @@@
>   			       EXT4_FEATURE_RO_COMPAT_BIGALLOC)) {
>   			ext4_msg(sb, KERN_ERR,
>   				 "Online resizing not supported with bigalloc");
>  -			return -EOPNOTSUPP;
>  +			err = -EOPNOTSUPP;
>  +			goto group_extend_out;
>   		}
>   
> - 		err = mnt_want_write(filp->f_path.mnt);
> + 		err = mnt_want_write_file(filp);
>   		if (err)
>  -			return err;
>  +			goto group_extend_out;
>   
>   		err = ext4_group_extend(sb, EXT4_SB(sb)->s_es, n_blocks_count);
>   		if (EXT4_SB(sb)->s_journal) {
> @@@ -213,10 -204,9 +213,10 @@@
>   		}
>   		if (err == 0)
>   			err = err2;
>  +
> - 		mnt_drop_write(filp->f_path.mnt);
> + 		mnt_drop_write_file(filp);
>  +group_extend_out:
>   		ext4_resize_end(sb);
>  -
>   		return err;
>   	}
>   
> @@@ -256,7 -246,9 +256,7 @@@
>   
>   		err = ext4_move_extents(filp, donor_filp, me.orig_start,
>   					me.donor_start, me.len, &me.moved_len);
> - 		mnt_drop_write(filp->f_path.mnt);
> + 		mnt_drop_write_file(filp);
>  -		if (me.moved_len > 0)
>  -			file_remove_suid(donor_filp);
>   
>   		if (copy_to_user((struct move_extent __user *)arg,
>   				 &me, sizeof(me)))
> @@@ -284,13 -274,12 +284,13 @@@ mext_out
>   			       EXT4_FEATURE_RO_COMPAT_BIGALLOC)) {
>   			ext4_msg(sb, KERN_ERR,
>   				 "Online resizing not supported with bigalloc");
>  -			return -EOPNOTSUPP;
>  +			err = -EOPNOTSUPP;
>  +			goto group_add_out;
>   		}
>   
> - 		err = mnt_want_write(filp->f_path.mnt);
> + 		err = mnt_want_write_file(filp);
>   		if (err)
>  -			return err;
>  +			goto group_add_out;
>   
>   		err = ext4_group_add(sb, &input);
>   		if (EXT4_SB(sb)->s_journal) {
> @@@ -300,10 -289,9 +300,10 @@@
>   		}
>   		if (err == 0)
>   			err = err2;
>  +
> - 		mnt_drop_write(filp->f_path.mnt);
> + 		mnt_drop_write_file(filp);
>  +group_add_out:
>   		ext4_resize_end(sb);
>  -
>   		return err;
>   	}
>   



-- 
tixxdz
http://opendz.org
