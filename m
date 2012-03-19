Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030184Ab2CSWsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 18:48:00 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:55905 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965149Ab2CSWr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 18:47:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EALi2Z095LOjd/2dsb2JhbABBtlaBCIIJAQEFJxMcIxAIAxUDLhQlAyETiAm3GxOPb2MElWeQKYJ6
Date: Tue, 20 Mar 2012 09:47:53 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        xfs-masters@oss.sgi.com
Subject: Re: [PATCH 05/11] XFS: Fix lock ASSERT on UP
Message-ID: <20120319224753.GC3592@dastard>
References: <1331924464-18023-1-git-send-email-andi@firstfloor.org>
 <1331924464-18023-6-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331924464-18023-6-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 12:00:58PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> ASSERT(!spin_is_locked()) doesn't work on UP builds. Replace with a standard
> lockdep_assert_held()
> 
> Cc: xfs-masters@oss.sgi.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  fs/xfs/xfs_iget.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
> index 8c3e463..8654d78 100644
> --- a/fs/xfs/xfs_iget.c
> +++ b/fs/xfs/xfs_iget.c
> @@ -76,7 +76,7 @@ xfs_inode_alloc(
>  	}
>  
>  	ASSERT(atomic_read(&ip->i_pincount) == 0);
> -	ASSERT(!spin_is_locked(&ip->i_flags_lock));
> +	lockdep_assert_held(&ip->i_flags_lock);
>  	ASSERT(!xfs_isiflocked(ip));
>  	ASSERT(ip->i_ino == 0);
>  
> @@ -147,7 +147,7 @@ xfs_inode_free(
>  
>  	/* asserts to verify all state is correct here */
>  	ASSERT(atomic_read(&ip->i_pincount) == 0);
> -	ASSERT(!spin_is_locked(&ip->i_flags_lock));
> +	lockdep_assert_held(&ip->i_flags_lock);
>  	ASSERT(!xfs_isiflocked(ip));

So this means we only ever check that the spinlock is held when
lockdep is turned on instead of whenever CONFIG_XFS_DEBUG is set?
That means it will rarely get checked during development instead of
all the time. That's not an improvement IMO....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
