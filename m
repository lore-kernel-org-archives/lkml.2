Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab0DFXMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 19:12:08 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:42643 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757084Ab0DFXMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 19:12:00 -0400
Date: Wed, 7 Apr 2010 09:11:44 +1000
From: Dave Chinner <david@fromorbit.com>
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: linux-kernel@vger.kernel.org, opensuse-kernel@opensuse.org,
       xfs@oss.sgi.com
Subject: Re: 2.6.34-rc3: simple du (on a big xfs tree) triggers oom killer
 [bisected: 57817c68229984818fea9e614d6f95249c3fb098]
Message-ID: <20100406231144.GF11036@dastard>
References: <201004050049.17952.hpj@urpla.net>
 <201004051335.41857.hpj@urpla.net>
 <20100405230600.GA3335@dastard>
 <201004061652.58189.hpj@urpla.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004061652.58189.hpj@urpla.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 04:52:57PM +0200, Hans-Peter Jansen wrote:
> Hi Dave,
> 
> On Tuesday 06 April 2010, 01:06:00 Dave Chinner wrote:
> > On Mon, Apr 05, 2010 at 01:35:41PM +0200, Hans-Peter Jansen wrote:
> > > >
> > > > Oh, this is a highmem box. You ran out of low memory, I think, which
> > > > is where all the inodes are cached. Seems like a VM problem or a
> > > > highmem/lowmem split config problem to me, not anything to do with
> > > > XFS...

[snip]

> Dave, I really don't want to disappoint you, but a lengthy bisection session 
> points to:
> 
> 57817c68229984818fea9e614d6f95249c3fb098 is the first bad commit
> commit 57817c68229984818fea9e614d6f95249c3fb098
> Author: Dave Chinner <david@fromorbit.com>
> Date:   Sun Jan 10 23:51:47 2010 +0000
> 
>     xfs: reclaim all inodes by background tree walks

Interesting. I did a fair bit of low memory testing when i made that
change (admittedly none on a highmem i386 box), and since then I've
done lots of "millions of files" tree creates, traversals and destroys on
limited memory machines without triggering problems when memory is
completely full of inodes.

Let me try to reproduce this on a small VM and I'll get back to you.

> diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
> index 52e06b4..a76fc01 100644
> --- a/fs/xfs/linux-2.6/xfs_super.c
> +++ b/fs/xfs/linux-2.6/xfs_super.c
> @@ -954,14 +954,16 @@ xfs_fs_destroy_inode(
>  	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIM));
>  
>  	/*
> -	 * We always use background reclaim here because even if the
> -	 * inode is clean, it still may be under IO and hence we have
> -	 * to take the flush lock. The background reclaim path handles
> -	 * this more efficiently than we can here, so simply let background
> -	 * reclaim tear down all inodes.
> +	 * If we have nothing to flush with this inode then complete the
> +	 * teardown now, otherwise delay the flush operation.
>  	 */
> +	if (!xfs_inode_clean(ip)) {
> +		xfs_inode_set_reclaim_tag(ip);
> +		return;
> +	}
> +
>  out_reclaim:
> -	xfs_inode_set_reclaim_tag(ip);
> +	xfs_ireclaim(ip);
>  }

I don't think that will work as expected in all situations - the
inode clean check there is not completely valid as the XFS inode
locks aren't held, so it can race with other operations that need
to complete before reclaim is done. This was one of the reasons for
pushing reclaim into the background....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
