Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372Ab2IKXWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 19:22:12 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:21149 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753881Ab2IKXWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 19:22:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgwKAATHT1B5LPyM/2dsb2JhbABFulADgQSBCIIgAQEFJxMcIxAIAxUDLhQNGAM0h34DDrJXDYlTFIoZYwtjghmDHwOUCoFUixaFCIJ4gUk
Date: Wed, 12 Sep 2012 09:21:44 +1000
From: Dave Chinner <david@fromorbit.com>
To: raghu.prabhu13@gmail.com
Cc: xfs@oss.sgi.com, Raghavendra D Prabhu <rprabhu@wnohang.net>,
        Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] XFS: Print error when unable to allocate inodes or
 out of free inodes.
Message-ID: <20120911232144.GH11511@dastard>
References: <cover.1347396641.git.rprabhu@wnohang.net>
 <93d9b37ce9ad720e14e2f9311e623a8e3e3139f5.1347396641.git.rprabhu@wnohang.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93d9b37ce9ad720e14e2f9311e623a8e3e3139f5.1347396641.git.rprabhu@wnohang.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 03:43:24AM +0530, raghu.prabhu13@gmail.com wrote:
> From: Raghavendra D Prabhu <rprabhu@wnohang.net>
> 
> When xfs_dialloc is unable to allocate required number of inodes or there are no
> AGs with free inodes, printk the error in ratelimited manner.
> 
> Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
> ---
>  fs/xfs/xfs_ialloc.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
> index e75a39d..034131b 100644
> --- a/fs/xfs/xfs_ialloc.c
> +++ b/fs/xfs/xfs_ialloc.c
> @@ -990,8 +990,11 @@ xfs_dialloc(
>  				goto out_error;
>  
>  			xfs_perag_put(pag);
> -			*inop = NULLFSINO;
> -			return 0;
> +
> +			xfs_err_ratelimited(mp,
> +				"Unable to allocate inodes in AG %d: Required %d, Current %llu, Maximum %llu",
> +				agno, XFS_IALLOC_INODES(mp), mp->m_sb.sb_icount, mp->m_maxicount);
> +			goto out_spc;

This changes the error to be returned from 0 to ENOSPC. Adding error
messages shouldn't change the logic of the code.

Also, you might want tolook at how ENOSPC is returned from
xfs_ialloc_ag_alloc(). it only occurs when:

	if (mp->m_maxicount &&
            mp->m_sb.sb_icount + newlen > mp->m_maxicount) {

i.e. it is exactly the same error case as the "noroom" error below.
It has nothing to do with being unable to allocate inodes in the
specific AG - the global inode count is too high. IOWs, the error
message is not correct.

Also, 80 columns.

>  		}
>  
>  		if (ialloced) {
> @@ -1016,11 +1019,19 @@ nextag:
>  		if (++agno == mp->m_sb.sb_agcount)
>  			agno = 0;
>  		if (agno == start_agno) {
> -			*inop = NULLFSINO;
> -			return noroom ? ENOSPC : 0;
> +			if (noroom) {
> +				xfs_err_ratelimited(mp,
> +					"Out of AGs with free inodes: Required %d, Current %llu, Maximum %llu",
> +					 XFS_IALLOC_INODES(mp), mp->m_sb.sb_icount, mp->m_maxicount);

The error message here is misleading - the error is that we've
exceeded the maximum inode count for the filesystem (same as the
above error message case), so no further allocations are allowed.

What about the !noroom case? Isn't that a real ENOSPC condition?
i.e. we've tried to allocate inodes in every AG and yet we've failed
in all of them because there is no aligned, contiguous free space in
any of the AGs. Shouldn't that emit an appropriate warning?

> +				goto out_spc;
> +			}
> +			return 0;
>  		}
>  	}
>  
> +out_spc:
> +	*inop = NULLFSINO;
> +	return ENOSPC;
>  out_alloc:
>  	*IO_agbp = NULL;
>  	return xfs_dialloc_ag(tp, agbp, parent, inop);

Default behaviour on a loop break is to allocate inodes, not return
ENOSPC.

BTW, there's no need to cc LKML for XFS specific patches. LKML is
noisy enough as it is without unnecessary cross-posts....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
