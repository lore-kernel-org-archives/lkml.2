Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab1AXQZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 11:25:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab1AXQZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 11:25:39 -0500
Message-ID: <4D3DA7F7.4010306@redhat.com>
Date: Mon, 24 Jan 2011 10:25:27 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH] ext4: Fix invalid free of cache->name after ext4_mb_init()
 error
References: <1295876547-6338-1-git-send-email-chris@chris-wilson.co.uk>
In-Reply-To: <1295876547-6338-1-git-send-email-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2011 07:42 AM, Chris Wilson wrote:
> The name allocated for the kmem_cache was being freed in the error path even
> if that name was still assigned to the newly created cache.

This code still has trouble on the module unload / uninit path;
I sent a more invasive patch to just use static patch names,
see [PATCH] ext4: make grpinfo slab cache names static
from last week.

-Eric

> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> ---
>  fs/ext4/mballoc.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 851f49b..69b90fe 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2423,7 +2423,6 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
>  	int ret;
>  	int cache_index;
>  	struct kmem_cache *cachep;
> -	char *namep = NULL;
>  
>  	i = (sb->s_blocksize_bits + 2) * sizeof(*sbi->s_mb_offsets);
>  
> @@ -2443,7 +2442,7 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
>  	cache_index = sb->s_blocksize_bits - EXT4_MIN_BLOCK_LOG_SIZE;
>  	cachep = ext4_groupinfo_caches[cache_index];
>  	if (!cachep) {
> -		char name[32];
> +		char name[32], *namep;
>  		int len = offsetof(struct ext4_group_info,
>  					bb_counters[sb->s_blocksize_bits + 2]);
>  
> @@ -2459,6 +2458,7 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
>  		cachep = kmem_cache_create(namep, len, 0,
>  					     SLAB_RECLAIM_ACCOUNT, NULL);
>  		if (!cachep) {
> +			kfree(namep);
>  			ret = -ENOMEM;
>  			goto out;
>  		}
> @@ -2520,7 +2520,6 @@ out:
>  	if (ret) {
>  		kfree(sbi->s_mb_offsets);
>  		kfree(sbi->s_mb_maxs);
> -		kfree(namep);
>  	}
>  	return ret;
>  }

