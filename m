Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab2BDEvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 23:51:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692Ab2BDEva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 23:51:30 -0500
Message-ID: <4F2CB928.7030001@redhat.com>
Date: Fri, 03 Feb 2012 22:50:48 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Eric Sandeen <sandeen@sandeen.net>
CC: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>, Surbhi Palande <csurbhi@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
        linux-ext4@vger.kernel.org, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>
Subject: Re: [PATCH 5/8] xfs: Protect xfs_file_aio_write() & xfs_setattr_size()
 with sb_start_write - sb_end_write
References: <1327091686-23177-1-git-send-email-jack@suse.cz> <1327091686-23177-6-git-send-email-jack@suse.cz> <4F2CB44D.4060006@sandeen.net>
In-Reply-To: <4F2CB44D.4060006@sandeen.net>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/3/12 10:30 PM, Eric Sandeen wrote:
> On 1/20/12 2:34 PM, Jan Kara wrote:
>> Replace racy xfs_wait_for_freeze() check in xfs_file_aio_write() with
>> a reliable sb_start_write() - sb_end_write() locking.
> 
> Here's what I'm running with now.  With this and my modified
> patch6, I can pass xfstests 068 on xfs.

(and I dropped patch 4, with the lock rearrangement, FWIW - so
the only xfs patches I'm running are the 2 I resent).

-Eric

> -Eric
> 
> 
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 7e5bc87..f1cacdc 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -874,11 +874,11 @@ xfs_file_aio_write(
>  	if (ocount == 0)
>  		return 0;
>  
> -	xfs_wait_for_freeze(ip->i_mount, SB_FREEZE_WRITE);
> -
>  	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
>  		return -EIO;
>  
> +	sb_start_write(inode->i_sb, SB_FREEZE_WRITE);
> +
>  	if (unlikely(file->f_flags & O_DIRECT))
>  		ret = xfs_file_dio_aio_write(iocb, iovp, nr_segs, pos, ocount);
>  	else
> @@ -895,6 +895,7 @@ xfs_file_aio_write(
>  		if (err < 0)
>  			ret = err;
>  	}
> +	sb_end_write(inode->i_sb, SB_FREEZE_WRITE);
>  
>  	return ret;
>  }
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index ab30253..7f3fa17 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -773,6 +773,7 @@ xfs_setattr_size(
>  			ATTR_MTIME_SET|ATTR_KILL_SUID|ATTR_KILL_SGID|
>  			ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
>  
> +	sb_start_write(inode->i_sb, SB_FREEZE_WRITE);
>  	lock_flags = XFS_ILOCK_EXCL;
>  	if (!(flags & XFS_ATTR_NOLOCK))
>  		lock_flags |= XFS_IOLOCK_EXCL;
> @@ -792,6 +793,7 @@ xfs_setattr_size(
>  		 * Use the regular setattr path to update the timestamps.
>  		 */
>  		xfs_iunlock(ip, lock_flags);
> +		sb_end_write(inode->i_sb, SB_FREEZE_WRITE);
>  		iattr->ia_valid &= ~ATTR_SIZE;
>  		return xfs_setattr_nonsize(ip, iattr, 0);
>  	}
> @@ -938,6 +940,7 @@ xfs_setattr_size(
>  out_unlock:
>  	if (lock_flags)
>  		xfs_iunlock(ip, lock_flags);
> +	sb_end_write(inode->i_sb, SB_FREEZE_WRITE);
>  	return error;
>  
>  out_trans_abort:
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

