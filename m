Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759108Ab2JKSLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 14:11:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40558 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758555Ab2JKSLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 14:11:41 -0400
Date: Thu, 11 Oct 2012 20:11:39 +0200
From: Jan Kara <jack@suse.cz>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: Re: [PATCH 2/6] udf: don't increment lenExtents while writing to a
 hole
Message-ID: <20121011181139.GD18391@quack.suse.cz>
References: <1349795352-6389-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349795352-6389-1-git-send-email-linkinjeon@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 10-10-12 00:09:12, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> Incrementing lenExtents even while writing to a hole is bad
> for performance as calls to udf_discard_prealloc and
> udf_truncate_tail_extent would not return from start if
> isize != lenExtents
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
  Thanks. I've merged the patch.

							Honza
> ---
>  fs/udf/inode.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
> index 2b77593..8266f2e 100644
> --- a/fs/udf/inode.c
> +++ b/fs/udf/inode.c
> @@ -601,6 +601,7 @@ static sector_t inode_getblk(struct inode *inode, sector_t block,
>  	struct udf_inode_info *iinfo = UDF_I(inode);
>  	int goal = 0, pgoal = iinfo->i_location.logicalBlockNum;
>  	int lastblock = 0;
> +	bool isBeyondEOF;
>  
>  	*err = 0;
>  	*new = 0;
> @@ -680,7 +681,7 @@ static sector_t inode_getblk(struct inode *inode, sector_t block,
>  	/* Are we beyond EOF? */
>  	if (etype == -1) {
>  		int ret;
> -
> +		isBeyondEOF = 1;
>  		if (count) {
>  			if (c)
>  				laarr[0] = laarr[1];
> @@ -723,6 +724,7 @@ static sector_t inode_getblk(struct inode *inode, sector_t block,
>  		endnum = c + 1;
>  		lastblock = 1;
>  	} else {
> +		isBeyondEOF = 0;
>  		endnum = startnum = ((count > 2) ? 2 : count);
>  
>  		/* if the current extent is in position 0,
> @@ -770,7 +772,8 @@ static sector_t inode_getblk(struct inode *inode, sector_t block,
>  			*err = -ENOSPC;
>  			return 0;
>  		}
> -		iinfo->i_lenExtents += inode->i_sb->s_blocksize;
> +		if (isBeyondEOF)
> +			iinfo->i_lenExtents += inode->i_sb->s_blocksize;
>  	}
>  
>  	/* if the extent the requsted block is located in contains multiple
> -- 
> 1.7.9.5
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
