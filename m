Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab1GSKY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 06:24:28 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:64064 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752088Ab1GSKY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 06:24:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArIDAB9YJU55LCkBgWdsb2JhbABTp0kVAQEWJiWIfMQjDoYuBJsUiD8
Date: Tue, 19 Jul 2011 20:24:22 +1000
From: Dave Chinner <david@fromorbit.com>
To: Josef Bacik <josef@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@ZenIV.linux.org.uk, hch@infradead.org
Subject: Re: [PATCH] fs: push i_mutex and filemap_write_and_wait down into
 ->fsync() handlers
Message-ID: <20110719102422.GO30254@dastard>
References: <1309275310-10987-1-git-send-email-josef@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309275310-10987-1-git-send-email-josef@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 11:35:10AM -0400, Josef Bacik wrote:
> Btrfs needs to be able to control how filemap_write_and_wait_range() is called
> in fsync to make it less of a painful operation, so push down taking i_mutex and
> the calling of filemap_write_and_wait() down into the ->fsync() handlers.  Some
> file systems can drop taking the i_mutex altogether it seems, like ext3 and
> ocfs2.  For correctness sake I just pushed everything down in all cases to make
> sure that we keep the current behavior the same for everybody, and then each
> individual fs maintainer can make up their mind about what to do from there.
> Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>

.....

> diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
> index 7f782af..9183f75 100644
> --- a/fs/xfs/linux-2.6/xfs_file.c
> +++ b/fs/xfs/linux-2.6/xfs_file.c
> @@ -127,6 +127,8 @@ xfs_iozero(
>  STATIC int
>  xfs_file_fsync(
>  	struct file		*file,
> +	loff_t			start,
> +	loff_t			end,
>  	int			datasync)
>  {
>  	struct inode		*inode = file->f_mapping->host;
> @@ -138,8 +140,16 @@ xfs_file_fsync(
>  
>  	trace_xfs_file_fsync(ip);
>  
> -	if (XFS_FORCED_SHUTDOWN(mp))
> +	error = filemap_write_and_wait_range(inode->i_mapping, start, end);
> +	if (error)
> +		return error;
> +
> +	mutex_lock(&inode->i_mutex);
> +
> +	if (XFS_FORCED_SHUTDOWN(mp)) {
> +		mutex_unlock(&inode->i_mutex);
>  		return -XFS_ERROR(EIO);
> +	}
>  
>  	xfs_iflags_clear(ip, XFS_ITRUNCATED);

Josef, FYI, this causes deadlocks in XFS.

You cannot take the i_mutex in this function as it violates locking
order when called from xfs_file_aio_write() for O_SYNC buffered
IO. We already hold the i_mutex when calling the function, and I
don't think we can drop it without violating sync write atomicity...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
