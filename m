Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829Ab2HHHWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 03:22:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757548Ab2HHHWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 03:22:10 -0400
Date: Wed, 8 Aug 2012 09:22:01 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
X-X-Sender: lukas@localhost
To: Tomas Racek <tracek@redhat.com>
cc: linux-xfs@vger.kernel.org, lczerner@redhat.com, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>,
        "supporter:XFS FILESYSTEM" <xfs@oss.sgi.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] xfs: check for possible overflow in xfs_ioc_trim
In-Reply-To: <1343828737-5324-1-git-send-email-tracek@redhat.com>
Message-ID: <alpine.LFD.2.00.1208080909330.19417@localhost>
References: <1343828737-5324-1-git-send-email-tracek@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2012, Tomas Racek wrote:

> Date: Wed,  1 Aug 2012 15:45:37 +0200
> From: Tomas Racek <tracek@redhat.com>
> To: linux-xfs@vger.kernel.org
> Cc: lczerner@redhat.com, Tomas Racek <tracek@redhat.com>,
>     Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>,
>     "supporter:XFS FILESYSTEM" <xfs@oss.sgi.com>,
>     open list <linux-kernel@vger.kernel.org>
> Subject: [PATCH v2] xfs: check for possible overflow in xfs_ioc_trim
> 
> If range.start points behind the filesystem, return invalid value error.
> This fixes possible overflow in
> 
> start = BTOBB(range.start)
> 
> when range.start is nearly ULLONG_MAX.
> 
> Signed-off-by: Tomas Racek <tracek@redhat.com>

The fix looks good to me, but I have one comment bellow.

> ---
>  fs/xfs/xfs_discard.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index f9c3fe3..33d367f 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -179,12 +179,13 @@ xfs_ioc_trim(
>  	 * used by the fstrim application.  In the end it really doesn't
>  	 * matter as trimming blocks is an advisory interface.
>  	 */
> +	if (range.start >= XFS_FSB_TO_B(mp, mp->m_sb.sb_dblocks))
> +		return -XFS_ERROR(EINVAL);
> +
>  	start = BTOBB(range.start);
>  	end = start + BTOBBT(range.len) - 1;
>  	minlen = BTOBB(max_t(u64, granularity, range.minlen));

It seems that we have the same problem here with range.minlen. It
is highly unlikely and stupid from the user space to send minlen of
such size, but it is possible.

Thanks!
-Lukas

>  
> -	if (XFS_BB_TO_FSB(mp, start) >= mp->m_sb.sb_dblocks)
> -		return -XFS_ERROR(EINVAL);
>  	if (end > XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1)
>  		end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)- 1;
>  
> 
