Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab2HVKC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 06:02:29 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46186 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2HVKC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 06:02:27 -0400
MIME-Version: 1.0
In-Reply-To: <20120821090810.GC7537@quack.suse.cz>
References: <1345283903-7960-1-git-send-email-linkinjeon@gmail.com>
	<20120821090810.GC7537@quack.suse.cz>
Date: Wed, 22 Aug 2012 19:02:26 +0900
Message-ID: <CAKYAXd_odZxzXqn91Q517BuRRFHP3O4pkVgN8uK6QTeFEqaEdg@mail.gmail.com>
Subject: Re: [PATCH RESEND] udf: extent cache implementation for manipulating
 block map
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>,
        Bonggil Bak <bgbak@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/21, Jan Kara <jack@suse.cz>:
>   Hello,
>
>   first, I'm sorry for a late reply. I was on a long vacation and then it
> took me a while to catch up with stuff.
>
> On Sat 18-08-12 05:58:22, Namjae Jeon wrote:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> While mapping logical blocks of a file to physical blocks on the
>> partition,
>> everytime UDF read file metadata from the begining which decrease
>> preformance.
>> The drawback of this scheme is more prominent while reading large files.
>> For example, while reading a large file of ~5GB, read speed will
>> gradually become less as we near the end of file because of the time
>> taken in calculating the corresponding physical block.
>>
>> This patch implements caching and remembers the location of the last read
>> extent. Instead of reading file metadata from begining, start from the
>> cached location.
>   I agree this functionality is useful. Thanks for implementing it! I have
> some comments regarding the implementation below:
>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
>> Signed-off-by: Bonggil Bak <bgbak@samsung.com>
>> ---
>>  fs/udf/ialloc.c  |    2 ++
>>  fs/udf/inode.c   |   83
>> ++++++++++++++++++++++++++++++++++++++++++++++++++----
>>  fs/udf/udf_i.h   |   13 +++++++++
>>  fs/udf/udfdecl.h |   13 +++++++++
>>  4 files changed, 105 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/udf/ialloc.c b/fs/udf/ialloc.c
>> index 7e5aae4..7dd86a4 100644
>> --- a/fs/udf/ialloc.c
>> +++ b/fs/udf/ialloc.c
>> @@ -117,6 +117,8 @@ struct inode *udf_new_inode(struct inode *dir, umode_t
>> mode, int *err)
>>  	iinfo->i_lenAlloc = 0;
>>  	iinfo->i_use = 0;
>>  	iinfo->i_checkpoint = 1;
>> +	memset(&iinfo->cached_extent, 0, sizeof(struct udf_ext_cache));
>> +	mutex_init(&(iinfo->i_extent_cache_lock));
>>  	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_AD_IN_ICB))
>>  		iinfo->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
>>  	else if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_SHORT_AD))
>> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
>> index fafaad7..cf34dec 100644
>> --- a/fs/udf/inode.c
>> +++ b/fs/udf/inode.c
>> @@ -345,7 +345,7 @@ static int udf_get_block(struct inode *inode, sector_t
>> block,
>>  		iinfo->i_next_alloc_goal++;
>>  	}
>>
>> -
>> +	udf_clear_extent_cache(iinfo);
>>  	phys = inode_getblk(inode, block, &err, &new);
>>  	if (!phys)
>>  		goto abort;
>   This is certainly the easiest thing to do. But it nags me that simple
> appending writes are not able to use the extent cache. It even needn't be
> that complicated if we carefully pick the things to cache - see below.
>
> ...
>> diff --git a/fs/udf/udf_i.h b/fs/udf/udf_i.h
>> index bb8309d..ec168a9 100644
>> --- a/fs/udf/udf_i.h
>> +++ b/fs/udf/udf_i.h
>> @@ -1,6 +1,16 @@
>>  #ifndef _UDF_I_H
>>  #define _UDF_I_H
>>
>> +struct udf_ext_cache {
>> +	struct kernel_lb_addr epos;
>> +	uint32_t offset;
>> +	uint32_t p_block_nr;
>> +	struct kernel_lb_addr eloc;
>> +	uint32_t elen;
>> +	int8_t etype;
>> +	loff_t last_block;
>> +};
>> +
>   Umm, I think caching things slightly differently might make things
> easier. I'd do:
> struct udf_ext_cache {
> 	/*
> 	 * Buffer head with extent or NULL if the extent is in inode
> 	 * (need to have buffer reference via get_bh!)
> 	 */
> 	struct buffer_head *extent_bh;
> 	/*
> 	 * Extent position - this is somewhat redundant since we have the
> 	 * bh but code in block mapping functions expects to have this
> 	 */
> 	struct kernel_lb_addr epos;
> 	/* Offset of cached extent in the buffer head / inode */
> 	uint32_t offset;
> 	/* Logical block where cached extent starts */
> 	sector_t block;
> };
>
> So you cache extent position, bh, and it's logical position within inode.
> udf_read_extent_cache() would check whether queried logical block is after
> our cached logical block. If yes, we would decode extent from our bh /
> inode and proceed as you did.
>
> The advantage I see in this approach is that we cache a bit less, don't
> have to lookup the buffer head (although that is pinned in memory now so
> total memory consumption might be higher in some cases), and we don't have
> to invalidate the cache when the cached logical block is before the block
> we write to (which nicely catches also extending writes).
>
> What do you think?
Hi. Jan.
Okay, We are trying to do it from your comment.
1. Change udf_ext_cache structure to following which would also include *bh.
struct udf_ext_cache {

/* Position of the cached extent */
struct extent_position epos;

/* Logical block where cached extent starts */
sector_t block;
};

2. Remove call to brelse(epos.bh) from all the callers of inode_bmap()
and move it to udf_evict_inode()

3. As now we are not caching elen, etype and eloc, we have to change
the cache_hit logic in inode_bmap.
The call to function udf_next_aext is now necessary from inode_bmap.

4. Remove call to udf_clear_extent_cache() from udf_get_block as with
new scheme, it is not required.

Please let us know in case of any sugguestion or queries.

Thanks.

>
>>  /*
>>   * The i_data_sem and i_mutex serve for protection of allocation
>> information
>>   * of a regular files and symlinks. This includes all extents belonging
>> to
>> @@ -35,6 +45,9 @@ struct udf_inode_info {
>>  		__u8		*i_data;
>>  	} i_ext;
>>  	struct rw_semaphore	i_data_sem;
>> +	struct udf_ext_cache cached_extent;
>> +	/* Mutex for protecting extent cache */
>> +	struct mutex i_extent_cache_lock;
>>  	struct inode vfs_inode;
>>  };
>
> 								Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
