Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab1LSBns (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 20:43:48 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:37545 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752079Ab1LSBnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 20:43:47 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAEGU7k55LOCn/2dsb2JhbABDq1iBBoFyAQEEATocIwULCAMYLhQlAyETh3q2VBOLcQSUfYkbiSg
Date: Mon, 19 Dec 2011 12:43:43 +1100
From: Dave Chinner <david@fromorbit.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Djalal Harouni <tixxdz@opendz.org>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
        Neil Brown <neilb@suse.de>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mm: add missing mutex lock arround notify_change
Message-ID: <20111219014343.GK23662@dastard>
References: <20111216112534.GA13147@dztty>
 <20111216125556.db2bf308.akpm@linux-foundation.org>
 <20111217214137.GY2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111217214137.GY2203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 17, 2011 at 09:41:37PM +0000, Al Viro wrote:
> On Fri, Dec 16, 2011 at 12:55:56PM -0800, Andrew Morton wrote:
> 
....
> 
> We have a shitload of deadlocks on very common paths with that patch.  What
> of the paths that do lead to file_remove_suid() without i_mutex?
> *	xfs_file_aio_write_checks(): we drop i_mutex (via xfs_rw_iunlock())
> just before calling file_remove_suid().  Racy, the fix is obvious - move
> file_remove_suid() call before unlocking.

Not exactly. xfs_rw_iunlock() is not doing what you think it's doing
there.....

> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 753ed9b..33705b1 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -750,17 +750,16 @@ restart:
>  		*new_sizep = new_size;
>  	}
>  
> -	xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
> -	if (error)
> -		return error;
> -
>  	/*
>  	 * If we're writing the file then make sure to clear the setuid and
>  	 * setgid bits if the process is not being run by root.  This keeps
>  	 * people from modifying setuid and setgid binaries.
>  	 */
> -	return file_remove_suid(file);
> +	if (!error)
> +		error = file_remove_suid(file);
>  
> +	xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
                               ^^^^^
> +	return error;

Wrong lock.  That's dropping the internal XFS inode metadata lock,
but the VFS i_mutex is associated with the internal XFS inode IO
lock, which is accessed via XFS_IOLOCK_*. Only if we take the iolock
via XFS_IOLOCK_EXCL do we actually take the i_mutex.

Now it gets complex. For buffered IO, we are guaranteed to already
be holding the i_mutex because we do:

        *iolock = XFS_IOLOCK_EXCL;
        xfs_rw_ilock(ip, *iolock);

        ret = xfs_file_aio_write_checks(file, &pos, &count, new_size, iolock);

So that is safe and non-racy right now.

For direct IO, however, we don't always take the IOLOCK exclusively.
Indeed, we try really, really hard not to do this so we can do
concurrent reads and writes to the inode, and that results
in a bunch of lock juggling when we actually need the IOLOCK
exclusive (like in xfs_file_aio_write_checks()). It sounds like we
need to know if we are going to have to remove the SUID bit ahead of
time so that we can  take the correct lock up front. I haven't
looked at what is needed to do that yet.

As it is, Christoph has a patch set out that I've already reviewed
for 3.3 that significantly changes the logic and flow of the locking
through this path, so we probably should fix this in that series as
for most applications it is already OK and non-racy.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
