Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab2G3Vtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 17:49:53 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:52867 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754698Ab2G3Vtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 17:49:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqQMAD0AF1B5LJQK/2dsb2JhbABFuE4BAoEHgQiCIAEBBAEnExwjBQsIAw4KLhQlAyETiAcFuxcUizyBABWBBYRvA5VIiSyGYoJx
Date: Tue, 31 Jul 2012 07:49:46 +1000
From: Dave Chinner <david@fromorbit.com>
To: Tomas Racek <tracek@redhat.com>
Cc: linux-xfs@vger.kernel.org, lczerner@redhat.com, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>,
        "supporter:XFS FILESYSTEM" <xfs@oss.sgi.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] xfs: check for possible overflow in xfs_ioc_trim
Message-ID: <20120730214946.GG2877@dastard>
References: <1343636024-20123-1-git-send-email-tracek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343636024-20123-1-git-send-email-tracek@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 10:13:44AM +0200, Tomas Racek wrote:
> If range.start argument was between ULLONG_MAX - BBSIZE and ULLONG_MAX,
> BTOBB macro resulted in overflow which caused start to be set to 0.
> Now, invalid argument error is returned instead.
> 
> Signed-off-by: Tomas Racek <tracek@redhat.com>
> ---
>  fs/xfs/xfs_discard.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index f9c3fe3..0ef7dd4 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -179,6 +179,10 @@ xfs_ioc_trim(
>  	 * used by the fstrim application.  In the end it really doesn't
>  	 * matter as trimming blocks is an advisory interface.
>  	 */
> +
> +	if (range.start > ULLONG_MAX - BBSIZE)
> +		return -XFS_ERROR(EINVAL);
> +

There's no point checking for overflow on the range start - what we
need to check is whether it is larger than the size of the
filesystem. We do that after the conversion of range.start to basic
blocks, so that check needs to be promoted to before this. i.e.

	if (range.start >= XFS_FSB_TO_B(mp, mp->m_sb.sb_dblocks))
		return -XFS_ERROR(EINVAL);

>  	start = BTOBB(range.start);
>  	end = start + BTOBBT(range.len) - 1;
>  	minlen = BTOBB(max_t(u64, granularity, range.minlen));

And that will prevent the overflow in BTOBB() just as effectively...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
