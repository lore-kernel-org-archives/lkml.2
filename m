Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab2IDHpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 03:45:44 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:53149 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542Ab2IDHpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 03:45:43 -0400
MIME-Version: 1.0
In-Reply-To: <20120903124500.GE21109@quack.suse.cz>
References: <1346431918-3691-1-git-send-email-linkinjeon@gmail.com>
	<20120903124500.GE21109@quack.suse.cz>
Date: Tue, 4 Sep 2012 16:45:42 +0900
Message-ID: <CAKYAXd8J09FPCTC-4WwfR+wSCTtfqUq1RYNh0V6=ahH4VsiASA@mail.gmail.com>
Subject: Re: [PATCH v2] udf: extent cache implementation for manipulating
 block map
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>,
        Bonggil Bak <bgbak@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/3, Jan Kara <jack@suse.cz>:
>   Hello,
>
> On Fri 31-08-12 12:51:58, Namjae Jeon wrote:
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

Hi. Jan.
>   Thanks for the patch. I like this much better than the previous one. Some
> comments are below:

Thank you~

>
>> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
>> index 1a0588e..f4cc4e0 100644
>> --- a/fs/udf/inode.c
>> +++ b/fs/udf/inode.c
>> @@ -357,8 +359,14 @@ static int udf_get_block(struct inode *inode,
>> sector_t block,
>>  	if (!phys)
>>  		goto abort;
>>
>> -	if (new)
>> +	if (new) {
>> +		unsigned char lshift = inode->i_sb->s_blocksize_bits;
>>  		set_buffer_new(bh_result);
>> +		if (iinfo->cached_extent.sanity &&
>> +		    (iinfo->cached_extent.eblock > (block << lshift)))
>> +			/* Block allocated for hole, invalidate cache */
>> +			udf_clear_extent_cache(iinfo);
>> +	}
>>  	map_bh(bh_result, inode->i_sb, phys);
>   Instead of this, you should change inode_getblk() to also use the extent
> cache (for initialization of prev_epos when appropriate) and then update
> the extent cache to the just found / created extent when the function is
> done.
Okay, I will check about your suggestion.
>
>>  abort:
>> @@ -2132,11 +2144,12 @@ int8_t inode_bmap(struct inode *inode, sector_t
>> block,
>>  	struct udf_inode_info *iinfo;
>>
>>  	iinfo = UDF_I(inode);
>> -	pos->offset = 0;
>> -	pos->block = iinfo->i_location;
>> -	pos->bh = NULL;
>> -	*elen = 0;
>> -
>> +	if (!udf_read_extent_cache(inode, bcount, &lbcount, pos)) {
>> +		pos->offset = 0;
>> +		pos->block = iinfo->i_location;
>> +		pos->bh = NULL;
>> +	}
>> +		*elen = 0;
>   There's TAB added here which doesn't make sense.
>
>>  	do {
>>  		etype = udf_next_aext(inode, pos, eloc, elen, 1);
>>  		if (etype == -1) {
> ...
>> @@ -2176,3 +2190,52 @@ long udf_block_map(struct inode *inode, sector_t
>> block)
>>  	else
>>  		return ret;
>>  }
>> +int udf_read_extent_cache(struct inode *inode, loff_t bcount,
>> +			  loff_t *lbcount, struct extent_position *pos)
>> +{
>> +	struct udf_inode_info *iinfo = UDF_I(inode);
>> +	mutex_lock(&iinfo->i_extent_cache_lock);
>> +	if ((iinfo->cached_extent.eblock <= bcount) &&
>> +	    (iinfo->cached_extent.sanity)) {
>> +		/* Cache hit */
>> +		*lbcount = iinfo->cached_extent.eblock;
>> +		memcpy(pos, &iinfo->cached_extent.epos,
>> +		       sizeof(struct extent_position));
>> +		mutex_unlock(&iinfo->i_extent_cache_lock);
>> +		return 1;
>> +	} else
>> +		udf_clear_extent_cache(iinfo);
>   It would be less confusing, if udf_read_extent_cache() didn't clear the
> cache in case of a miss. Then in udf_update_extent_cache() just clear the
> cache if it is still valid.
Okay, It is more effective!  I will change ~
>
>> +
>> +	mutex_unlock(&iinfo->i_extent_cache_lock);
>> +	return 0;
>> +}
>> +void udf_update_extent_cache(struct inode *inode, loff_t estart,
>> +			     struct extent_position *pos)
>> +{
>> +	struct udf_inode_info *iinfo = UDF_I(inode);
>> +	mutex_lock(&iinfo->i_extent_cache_lock);
>> +	if (pos->bh != NULL)
>> +		/* Increase ref count */
>> +		get_bh(pos->bh);
>> +	memcpy(&iinfo->cached_extent.epos, pos,
>> +	       sizeof(struct extent_position));
>> +	iinfo->cached_extent.eblock = estart;
>> +	iinfo->cached_extent.sanity = 1;
>> +	switch (iinfo->i_alloc_type) {
>> +	case ICBTAG_FLAG_AD_SHORT:
>> +		iinfo->cached_extent.epos.offset -= sizeof(struct short_ad);
>> +		break;
>> +	case ICBTAG_FLAG_AD_LONG:
>> +		iinfo->cached_extent.epos.offset -= sizeof(struct long_ad);
>> +	}
>> +	mutex_unlock(&iinfo->i_extent_cache_lock);
>> +}
>> +
>> +void udf_clear_extent_cache(struct udf_inode_info *iinfo)
>> +{
>> +	if (iinfo->cached_extent.sanity) {
>> +		brelse(iinfo->cached_extent.epos.bh);
>> +		memset(&iinfo->cached_extent, 0, sizeof(struct udf_ext_cache));
>> +	}
>> +}
>> +
>   I think udf_clear_entent_cache() should take i_extent_cache_lock. Or if
> you are sure it's not needed, you need a good documentation why.
Documentation ? I am a little confusing.. It means udf.txt is in
Documentation/filesystem/ ?
or comment about clear extent function ?

>
>> diff --git a/fs/udf/udf_i.h b/fs/udf/udf_i.h
>> index bb8309d..ec3878a 100644
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
>> +	/* Start logical block */
>> +	loff_t eblock;
>   Well, this is really in bytes not blocks, isn't it? Then call it like
> 'lstart' and add a comment that it's in bytes.
Yes, It is  in bytes. And I will add comment.
>
>> +	int8_t sanity;
>   Make this 'bool' and call it 'valid'. That's more common.
Okay, I will modify bool.

Thanks a lot. Jan!
>
> 								Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
