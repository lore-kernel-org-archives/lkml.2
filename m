Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab0HWNCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 09:02:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805Ab0HWNCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 09:02:36 -0400
Date: Mon, 23 Aug 2010 09:02:25 -0400
From: Josef Bacik <josef@redhat.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Chris Mason <chris.mason@oracle.com>, Josef Bacik <josef@redhat.com>,
        linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] btrfs: fix threshold calculation for block groups
	smaller than 1GB
Message-ID: <20100823130224.GA2404@localhost.localdomain>
References: <4C71CD4B.10606@cn.fujitsu.com> <4C71CD60.5050507@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C71CD60.5050507@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 09:22:40AM +0800, Li Zefan wrote:
> If a block group is smaller than 1GB, the extent entry threadhold
> calculation will always set the threshold to 0.
> 
> So as free space gets fragmented, btrfs will switch to use bitmap
> to manage free space, but then will never switch back to extents
> due to this bug.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  fs/btrfs/free-space-cache.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index f488fac..7edbef6 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -263,14 +263,18 @@ static void recalculate_thresholds(struct btrfs_block_group_cache *block_group)
>  	u64 max_bytes;
>  	u64 bitmap_bytes;
>  	u64 extent_bytes;
> +	u64 size = block_group->key.offset;
>  
>  	/*
>  	 * The goal is to keep the total amount of memory used per 1gb of space
>  	 * at or below 32k, so we need to adjust how much memory we allow to be
>  	 * used by extent based free space tracking
>  	 */
> -	max_bytes = MAX_CACHE_BYTES_PER_GIG *
> -		(div64_u64(block_group->key.offset, 1024 * 1024 * 1024));
> +	if (size < 1024 * 1024 * 1024)
> +		max_bytes = MAX_CACHE_BYTES_PER_GIG;
> +	else
> +		max_bytes = MAX_CACHE_BYTES_PER_GIG *
> +			div64_u64(size, 1024 * 1024 * 1024);
>  
>  	/*
>  	 * we want to account for 1 more bitmap than what we have so we can make
> -- 
> 1.7.0.1
> 

Reviewed-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef
