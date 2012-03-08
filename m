Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065Ab2CHXUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 18:20:47 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:54432 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753165Ab2CHXUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 18:20:44 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EACs8WU95LFyt/2dsb2JhbABDtSiBCIIKAQEFOhwjEAgDDgouFCUDIROICbovE5BDBJVEkBmCdw
Date: Fri, 9 Mar 2012 10:20:41 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, dchinner@redhat.com,
        sandeen@redhat.com, Kamal Mostafa <kamal@canonical.com>,
        Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>,
        xfs@oss.sgi.com
Subject: Re: [PATCH 11/19] xfs: Convert to new freezing code
Message-ID: <20120308232041.GU3592@dastard>
References: <1330963277-26336-1-git-send-email-jack@suse.cz>
 <1330963277-26336-12-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330963277-26336-12-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 05:01:09PM +0100, Jan Kara wrote:
> Generic code now blocks all writers from standard write paths. So we block all
> writers coming from ioctl and replace blocking of transactions on frozen
> filesystem with a debugging check. As a bonus, we get a protection of ioctl
> against racing remount read-only. We also convert xfs_file_aio_write() to a
> non-racy freeze protection.
....
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 329b06a..6468a2a 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -577,7 +577,6 @@ xfs_trans_alloc(
>  	xfs_mount_t	*mp,
>  	uint		type)
>  {
> -	xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
>  	return _xfs_trans_alloc(mp, type, KM_SLEEP);
>  }

So what is there to stop internal XFS threads from starting
transactions when the filesystem is frozen? Previously this
SB_FREEZE_TRANS would guarantee even internal fucntions would get
stopped, but now there's nothing?

I do beleive that ext4 has the same problem (the issue reported with
the lazy inode init background thread), and I can see that any other
filesystem that can make modifications via internal triggers will
see the same problem - freeze doesn't block them any more...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
