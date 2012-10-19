Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220Ab2JSEsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 00:48:53 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42031 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab2JSEsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 00:48:51 -0400
MIME-Version: 1.0
In-Reply-To: <20121018223058.GA19469@quack.suse.cz>
References: <1349795401-6497-1-git-send-email-linkinjeon@gmail.com>
	<20121018223058.GA19469@quack.suse.cz>
Date: Fri, 19 Oct 2012 13:48:49 +0900
Message-ID: <CAKYAXd_91tZ=LgaoPWMVkh6KKPKt0ctfsQo9f4FS-gjf8J77eQ@mail.gmail.com>
Subject: Re: [PATCH 5/6] udf: implement extent caching while reading-writing
 to a file
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>,
        Bonggil Bak <bgbak@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/19, Jan Kara <jack@suse.cz>:
>   Hello,
>
> On Wed 10-10-12 00:10:01, Namjae Jeon wrote:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> This patch implements extent caching.
>> Instead of reading metadata everytime from file's starting position,
>> now we read from the cached extent.
>> This speeds up the transformation of file logical offsets to
>> corresponding on-disk blocks.
>   I have some mostly minor comments to the patch. But when reading the
> extent code it is just ugly and hard to follow. So I'm thinking how to
> improve that before making things even harder with the extent cache. So
> give me a few more days please.
Hi Jan.
Okay, I see. Thanks!
>
> 								Honza
>
>>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
>> Signed-off-by: Bonggil Bak <bgbak@samsung.com>
>> ---
>>  fs/udf/ialloc.c  |    2 +
>>  fs/udf/inode.c   |  147
>> +++++++++++++++++++++++++++++++++++++++++++++++++-----
>>  fs/udf/udf_i.h   |   17 +++++++
>>  fs/udf/udfdecl.h |   10 ++--
>>  4 files changed, 159 insertions(+), 17 deletions(-)
>>
>> diff --git a/fs/udf/ialloc.c b/fs/udf/ialloc.c
>> index 7e5aae4..7dd86a4a 100644
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
>> index 6fd9dc5..38aee74 100644
>> --- a/fs/udf/inode.c
>> +++ b/fs/udf/inode.c
>> @@ -90,6 +90,7 @@ void udf_evict_inode(struct inode *inode)
>>  	}
>>  	kfree(iinfo->i_ext.i_data);
>>  	iinfo->i_ext.i_data = NULL;
>> +	udf_clear_extent_cache(iinfo);
>>  	if (want_delete) {
>>  		udf_free_inode(inode);
>>  	}
>> @@ -105,6 +106,7 @@ static void udf_write_failed(struct address_space
>> *mapping, loff_t to)
>>  		truncate_pagecache(inode, to, isize);
>>  		if (iinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB) {
>>  			down_write(&iinfo->i_data_sem);
>> +			udf_clear_extent_cache(iinfo);
>>  			udf_truncate_extents(inode);
>>  			up_write(&iinfo->i_data_sem);
>>  		}
>> @@ -588,27 +590,32 @@ static sector_t inode_getblk(struct inode *inode,
>> sector_t block,
>>  			     int *err, int *new)
>>  {
>>  	struct kernel_long_ad laarr[EXTENT_MERGE_SIZE];
>> -	struct extent_position prev_epos, cur_epos, next_epos;
>> -	int count = 0, startnum = 0, endnum = 0;
>> +	struct extent_position prev_epos, cur_epos, next_epos, cache_epos;
>> +	int count = 0, startnum = 0, endnum = 0, epos_count;
>>  	uint32_t elen = 0, tmpelen;
>>  	struct kernel_lb_addr eloc, tmpeloc;
>>  	int c = 1;
>>  	loff_t lbcount = 0, b_off = 0;
>> +	loff_t cur_ext_lbcount = 0, prev_ext_lbcount = 0;
>>  	uint32_t newblocknum, newblock;
>>  	sector_t offset = 0;
>>  	int8_t etype;
>>  	struct udf_inode_info *iinfo = UDF_I(inode);
>>  	int goal = 0, pgoal = iinfo->i_location.logicalBlockNum;
>> -	int lastblock = 0;
>> +	int lastblock = 0, check_endnum = 0;
>>  	bool isBeyondEOF;
>>
>>  	*err = 0;
>>  	*new = 0;
>> -	prev_epos.offset = udf_file_entry_alloc_offset(inode);
>> -	prev_epos.block = iinfo->i_location;
>> -	prev_epos.bh = NULL;
>> -	cur_epos = next_epos = prev_epos;
>>  	b_off = (loff_t)block << inode->i_sb->s_blocksize_bits;
>> +	if (!udf_read_extent_cache(inode, b_off, &lbcount, &prev_epos)) {
>> +		prev_epos.offset = udf_file_entry_alloc_offset(inode);
>> +		prev_epos.block = iinfo->i_location;
>> +		prev_epos.bh = NULL;
>> +	} else {
>> +		cur_ext_lbcount = prev_ext_lbcount = lbcount;
>> +	}
>> +	cur_epos = next_epos = prev_epos;
>>
>>  	/* find the extent which contains the block we are looking for.
>>  	   alternate between laarr[0] and laarr[1] for locations of the
>> @@ -626,6 +633,8 @@ static sector_t inode_getblk(struct inode *inode,
>> sector_t block,
>>  		}
>>
>>  		lbcount += elen;
>> +		prev_ext_lbcount = cur_ext_lbcount;
>> +		cur_ext_lbcount += elen;
>>
>>  		prev_epos.block = cur_epos.block;
>>  		cur_epos.block = next_epos.block;
>> @@ -649,6 +658,9 @@ static sector_t inode_getblk(struct inode *inode,
>> sector_t block,
>>
>>  		count++;
>>  	} while (lbcount + elen <= b_off);
>> +	memcpy(&cache_epos, &prev_epos, sizeof(struct extent_position));
>> +	if (cache_epos.bh != NULL)
>> +		get_bh(cache_epos.bh);
>>
>>  	b_off -= lbcount;
>>  	offset = b_off >> inode->i_sb->s_blocksize_bits;
>> @@ -669,9 +681,29 @@ static sector_t inode_getblk(struct inode *inode,
>> sector_t block,
>>  				 ~(inode->i_sb->s_blocksize - 1));
>>  			udf_write_aext(inode, &cur_epos, &eloc, elen, 1);
>>  		}
>> +		/*
>> +		 * Update extent cache, iterate over laarr[EXTENT_MERGE_SIZE]
>> +		 * to find the epos corresponding to eloc at laarr[c]
>> +		 */
>> +		epos_count = 0;
>> +		do {
>> +			etype = udf_next_aext(inode, &cache_epos, &eloc,
>> +					      &elen, 1);
>> +			if ((etype == (EXT_RECORDED_ALLOCATED >> 30))
>> +			    && (laarr[c].extLocation.logicalBlockNum ==
>> +				eloc.logicalBlockNum)
>> +			    && (laarr[c].extLocation.partitionReferenceNum ==
>> +				eloc.partitionReferenceNum)) {
>> +				udf_update_extent_cache(inode,
>> +					cur_ext_lbcount, &cache_epos, 1);
>> +				break;
>> +			}
>> +			epos_count++;
>> +		} while ((etype != -1) && (epos_count < EXTENT_MERGE_SIZE));
>>  		brelse(prev_epos.bh);
>>  		brelse(cur_epos.bh);
>>  		brelse(next_epos.bh);
>> +		brelse(cache_epos.bh);
>>  		newblock = udf_get_lb_pblock(inode->i_sb, &eloc, offset);
>>  		return newblock;
>>  	}
>> @@ -699,6 +731,7 @@ static sector_t inode_getblk(struct inode *inode,
>> sector_t block,
>>  			brelse(prev_epos.bh);
>>  			brelse(cur_epos.bh);
>>  			brelse(next_epos.bh);
>> +			brelse(cache_epos.bh);
>>  			*err = ret;
>>  			return 0;
>>  		}
>> @@ -716,6 +749,8 @@ static sector_t inode_getblk(struct inode *inode,
>> sector_t block,
>>  				inode->i_sb->s_blocksize;
>>  			memset(&laarr[c].extLocation, 0x00,
>>  				sizeof(struct kernel_lb_addr));
>> +			if (b_off != 0)
>> +				cur_ext_lbcount += b_off;
>>  			count++;
>>  		}
>>  		endnum = c + 1;
>> @@ -744,6 +779,8 @@ static sector_t inode_getblk(struct inode *inode,
>> sector_t block,
>>  			endnum++;
>>  		} else
>>  			lastblock = 1;
>> +		if (b_off != 0)
>> +			cur_ext_lbcount += b_off;
>>  	}
>>
>>  	/* if the current extent is not recorded but allocated, get the
>> @@ -766,6 +803,7 @@ static sector_t inode_getblk(struct inode *inode,
>> sector_t block,
>>  			brelse(prev_epos.bh);
>>  			brelse(cur_epos.bh);
>>  			brelse(next_epos.bh);
>> +			brelse(cache_epos.bh);
>>  			*err = -ENOSPC;
>>  			return 0;
>>  		}
>> @@ -791,16 +829,41 @@ static sector_t inode_getblk(struct inode *inode,
>> sector_t block,
>>  #endif
>>
>>  	/* merge any continuous blocks in laarr */
>> +	check_endnum = endnum;
>>  	udf_merge_extents(inode, laarr, &endnum);
>> +	if (check_endnum > endnum) {
>> +		c--;
>> +		cur_ext_lbcount = prev_ext_lbcount;
>> +	}
>>
>>  	/* write back the new extents, inserting new extents if the new number
>>  	 * of extents is greater than the old number, and deleting extents if
>>  	 * the new number of extents is less than the old number */
>>  	udf_update_extents(inode, laarr, startnum, endnum, &prev_epos);
>>
>> +	/*
>> +	 * Update extent cache, iterate over laarr[EXTENT_MERGE_SIZE] to find
>> +	 * the epos corresponding to eloc at laarr[c]
>> +	 */
>> +	epos_count = 0;
>> +	do {
>> +		etype = udf_next_aext(inode, &cache_epos, &eloc, &elen, 1);
>> +		if ((etype == (EXT_RECORDED_ALLOCATED >> 30))
>> +		    && (laarr[c].extLocation.logicalBlockNum ==
>> +			eloc.logicalBlockNum)
>> +		    && (laarr[c].extLocation.partitionReferenceNum ==
>> +			eloc.partitionReferenceNum)) {
>> +			udf_update_extent_cache(inode, cur_ext_lbcount,
>> +						&cache_epos, 1);
>> +			break;
>> +		}
>> +		epos_count++;
>> +	} while ((etype != -1) && (epos_count < EXTENT_MERGE_SIZE));
>> +
>>  	brelse(prev_epos.bh);
>>  	brelse(cur_epos.bh);
>>  	brelse(next_epos.bh);
>> +	brelse(cache_epos.bh);
>>
>>  	newblock = udf_get_pblock(inode->i_sb, newblocknum,
>>  				iinfo->i_location.partitionReferenceNum, 0);
>> @@ -1173,6 +1236,7 @@ set_size:
>>  	} else {
>>  		if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
>>  			down_write(&iinfo->i_data_sem);
>> +			udf_clear_extent_cache(iinfo);
>>  			memset(iinfo->i_ext.i_data + iinfo->i_lenEAttr + newsize,
>>  			       0x00, bsize - newsize -
>>  			       udf_file_entry_alloc_offset(inode));
>> @@ -1186,6 +1250,7 @@ set_size:
>>  		if (err)
>>  			return err;
>>  		down_write(&iinfo->i_data_sem);
>> +		udf_clear_extent_cache(iinfo);
>>  		truncate_setsize(inode, newsize);
>>  		udf_truncate_extents(inode);
>>  		up_write(&iinfo->i_data_sem);
>> @@ -1303,6 +1368,8 @@ static void udf_fill_inode(struct inode *inode,
>> struct buffer_head *bh)
>>  	iinfo->i_lenAlloc = 0;
>>  	iinfo->i_next_alloc_block = 0;
>>  	iinfo->i_next_alloc_goal = 0;
>> +	memset(&iinfo->cached_extent, 0, sizeof(struct udf_ext_cache));
>> +	mutex_init(&(iinfo->i_extent_cache_lock));
>>  	if (fe->descTag.tagIdent == cpu_to_le16(TAG_IDENT_EFE)) {
>>  		iinfo->i_efe = 1;
>>  		iinfo->i_use = 0;
>> @@ -2158,11 +2225,12 @@ int8_t inode_bmap(struct inode *inode, sector_t
>> block,
>>  	struct udf_inode_info *iinfo;
>>
>>  	iinfo = UDF_I(inode);
>> -	pos->offset = 0;
>> -	pos->block = iinfo->i_location;
>> -	pos->bh = NULL;
>> +	if (!udf_read_extent_cache(inode, bcount, &lbcount, pos)) {
>> +		pos->offset = 0;
>> +		pos->block = iinfo->i_location;
>> +		pos->bh = NULL;
>> +	}
>>  	*elen = 0;
>> -
>>  	do {
>>  		etype = udf_next_aext(inode, pos, eloc, elen, 1);
>>  		if (etype == -1) {
>> @@ -2172,7 +2240,8 @@ int8_t inode_bmap(struct inode *inode, sector_t
>> block,
>>  		}
>>  		lbcount += *elen;
>>  	} while (lbcount <= bcount);
>> -
>> +	/* update extent cache */
>> +	udf_update_extent_cache(inode, lbcount - *elen, pos, 1);
>>  	*offset = (bcount + *elen - lbcount) >> blocksize_bits;
>>
>>  	return etype;
>> @@ -2202,3 +2271,57 @@ long udf_block_map(struct inode *inode, sector_t
>> block)
>>  	else
>>  		return ret;
>>  }
>> +int udf_read_extent_cache(struct inode *inode, loff_t bcount,
>> +			  loff_t *lbcount, struct extent_position *pos)
>> +{
>> +	struct udf_inode_info *iinfo = UDF_I(inode);
>> +	mutex_lock(&iinfo->i_extent_cache_lock);
>> +	if ((iinfo->cached_extent.lstart <= bcount) &&
>> +	    (iinfo->cached_extent.valid)) {
>> +		/* Cache hit */
>> +		*lbcount = iinfo->cached_extent.lstart;
>> +		memcpy(pos, &iinfo->cached_extent.epos,
>> +		       sizeof(struct extent_position));
>> +		mutex_unlock(&iinfo->i_extent_cache_lock);
>> +		return 1;
>> +	}
>> +	mutex_unlock(&iinfo->i_extent_cache_lock);
>> +	return 0;
>> +}
>> +void udf_update_extent_cache(struct inode *inode, loff_t estart,
>> +			     struct extent_position *pos, int next_epos)
>> +{
>> +	struct udf_inode_info *iinfo = UDF_I(inode);
>> +	mutex_lock(&iinfo->i_extent_cache_lock);
>> +	udf_clear_extent_cache(iinfo);
>> +	if (pos->bh != NULL)
>> +		/* Increase ref count */
>> +		get_bh(pos->bh);
>> +	memcpy(&iinfo->cached_extent.epos, pos,
>> +	       sizeof(struct extent_position));
>> +	iinfo->cached_extent.lstart = estart;
>> +	iinfo->cached_extent.valid = 1;
>> +	if (next_epos)
>> +		switch (iinfo->i_alloc_type) {
>> +		case ICBTAG_FLAG_AD_SHORT:
>> +			iinfo->cached_extent.epos.offset -=
>> +			sizeof(struct short_ad);
>> +			break;
>> +		case ICBTAG_FLAG_AD_LONG:
>> +			iinfo->cached_extent.epos.offset -=
>> +			sizeof(struct long_ad);
>> +		}
>> +	mutex_unlock(&iinfo->i_extent_cache_lock);
>> +}
>> +
>> +/* This function should be called after i_data_sem is
>> + * held for writing OR i_extent_cache_lock is taken.
>> + */
>> +void udf_clear_extent_cache(struct udf_inode_info *iinfo)
>> +{
>> +	if (iinfo->cached_extent.valid) {
>> +		brelse(iinfo->cached_extent.epos.bh);
>> +		memset(&iinfo->cached_extent, 0, sizeof(struct udf_ext_cache));
>> +	}
>> +}
>> +
>> diff --git a/fs/udf/udf_i.h b/fs/udf/udf_i.h
>> index bb8309d..95e5e17 100644
>> --- a/fs/udf/udf_i.h
>> +++ b/fs/udf/udf_i.h
>> @@ -1,6 +1,20 @@
>>  #ifndef _UDF_I_H
>>  #define _UDF_I_H
>>
>> +struct extent_position {
>> +	struct buffer_head *bh;
>> +	uint32_t offset;
>> +	struct kernel_lb_addr block;
>> +};
>> +
>> +struct udf_ext_cache {
>> +	/* Extent position */
>> +	struct extent_position epos;
>> +	/* Start logical offset in bytes */
>> +	loff_t lstart;
>> +	bool valid;
>> +};
>> +
>>  /*
>>   * The i_data_sem and i_mutex serve for protection of allocation
>> information
>>   * of a regular files and symlinks. This includes all extents belonging
>> to
>> @@ -35,6 +49,9 @@ struct udf_inode_info {
>>  		__u8		*i_data;
>>  	} i_ext;
>>  	struct rw_semaphore	i_data_sem;
>> +	struct udf_ext_cache cached_extent;
>> +	/* Mutex for protecting extent cache */
>> +	struct mutex i_extent_cache_lock;
>>  	struct inode vfs_inode;
>>  };
>>
>> diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
>> index de038da..db4a22e 100644
>> --- a/fs/udf/udfdecl.h
>> +++ b/fs/udf/udfdecl.h
>> @@ -113,11 +113,6 @@ struct ustr {
>>  	uint8_t u_len;
>>  };
>>
>> -struct extent_position {
>> -	struct buffer_head *bh;
>> -	uint32_t offset;
>> -	struct kernel_lb_addr block;
>> -};
>>
>>  /* super.c */
>>
>> @@ -164,6 +159,11 @@ extern int8_t udf_next_aext(struct inode *, struct
>> extent_position *,
>>  			    struct kernel_lb_addr *, uint32_t *, int);
>>  extern int8_t udf_current_aext(struct inode *, struct extent_position *,
>>  			       struct kernel_lb_addr *, uint32_t *, int);
>> +int udf_read_extent_cache(struct inode *inode, loff_t bcount, loff_t
>> *lbcount,
>> +			  struct extent_position *pos);
>> +void udf_update_extent_cache(struct inode *inode, loff_t estart,
>> +			     struct extent_position *pos, int next_epos);
>> +void udf_clear_extent_cache(struct udf_inode_info *iinfo);
>>
>>  /* misc.c */
>>  extern struct buffer_head *udf_tgetblk(struct super_block *, int);
>> --
>> 1.7.9.5
>>
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
