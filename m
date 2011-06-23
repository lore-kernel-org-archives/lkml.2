Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933754Ab1FWRtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:49:42 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:62939 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651Ab1FWRtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:49:40 -0400
Subject: Re: [34-longterm 238/247] xfs: prevent leaking uninitialized stack
 memory in FSGEOMETRY_V1
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, stable-review@kernel.org,
        Alex Elder <aelder@sgi.com>
In-Reply-To: <1308850515-15242-179-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
	 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
	 <1308850515-15242-179-git-send-email-paul.gortmaker@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Jun 2011 13:49:26 -0400
Message-ID: <1308851366.5295.1.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-23 at 13:35 -0400, Paul Gortmaker wrote:
> From: Dan Rosenberg <drosenberg@vsecurity.com>
> 
>                    -------------------
>     This is a commit scheduled for the next v2.6.34 longterm release.
>     If you see a problem with using this for longterm, please comment.
>                    -------------------
> 
> commit 3a3675b7f23f83ca8c67c9c2b6edf707fd28d1ba upstream.
> 
> The FSGEOMETRY_V1 ioctl (and its compat equivalent) calls out to
> xfs_fs_geometry() with a version number of 3.  This code path does not
> fill in the logsunit member of the passed xfs_fsop_geom_t, leading to
> the leaking of four bytes of uninitialized stack data to potentially
> unprivileged callers.
> 
> v2 switches to memset() to avoid future issues if structure members
> change, on suggestion of Dave Chinner.
> 
> Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
> Reviewed-by: Eugene Teo <eugeneteo@kernel.org>
> Signed-off-by: Alex Elder <aelder@sgi.com>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
>  fs/xfs/xfs_fsops.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 37a6f62..4e7f02b 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -57,6 +57,9 @@ xfs_fs_geometry(
>  	xfs_fsop_geom_t		*geo,
>  	int			new_version)
>  {
> +
> +	memset(geo, 0, sizeof(*geo));
> +
>  	geo->blocksize = mp->m_sb.sb_blocksize;
>  	geo->rtextsize = mp->m_sb.sb_rextsize;
>  	geo->agblocks = mp->m_sb.sb_agblocks;
> -- 
> 1.7.4.4

This introduced a regression which was fixed by commit
af24ee9ea8d532e16883251a6684dfa1be8eec29.

-Dan

