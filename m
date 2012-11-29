Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab2K2Bkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 20:40:52 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38152 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab2K2Bkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 20:40:51 -0500
Message-ID: <50B6BD20.2080308@vflare.org>
Date: Wed, 28 Nov 2012 17:40:48 -0800
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jerome Marchand <jmarchan@redhat.com>
CC: Greg KH <greg@kroah.com>, Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Hansen <solid.se7en@gmail.com>, Tomas M <tomas@slax.org>,
        Mihail Kasadjikov <hamer.mk@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] zram: reduce metadata overhead
References: <1354001201-25537-1-git-send-email-ngupta@vflare.org> <1354001201-25537-2-git-send-email-ngupta@vflare.org> <50B4E8AF.7050808@redhat.com>
In-Reply-To: <50B4E8AF.7050808@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 08:22 AM, Jerome Marchand wrote:
> On 11/27/2012 08:26 AM, Nitin Gupta wrote:
>> For every allocated object, zram maintains the the handle, size,
>> flags and count fields. Of these, only the handle is required
>> since zsmalloc now provides the object size given the handle.
>> The flags field was needed only to mark a given page as zero-filled.
>> Instead of this field, we now use an invalid value (-1) to mark such
> Since the handle is unsigned, is this really an invalid value?
>

Great catch. -1 is not always invalid but +1 definitely is. I will fix this.

>> pages. Lastly, the count field was unused, so was simply removed.
>>
>> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
>> ---
>>   drivers/staging/zram/zram_drv.c |   80 ++++++++++++++-------------------------
>>   drivers/staging/zram/zram_drv.h |   18 +--------
>>   2 files changed, 31 insertions(+), 67 deletions(-)
>>
>> [...]
>> @@ -222,8 +202,8 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
>>   
>>   	page = bvec->bv_page;
>>   
>> -	if (unlikely(!zram->table[index].handle) ||
>> -			zram_test_flag(zram, index, ZRAM_ZERO)) {
>> +	if (unlikely(!zram->handle[index]) ||
>> +			(zram->handle[index] == zero_page_handle)) {
> This kind of comparison appears often. To my taste, an is_zero_page()
> helper would be welcome.

Actually, I was hit by assignment-instead-of-comparison bug once
during these changes, so this helper really should be there.

>>   		handle_zero_page(bvec);
>>   		return 0;
>>   	}
>> [...]
>> @@ -573,8 +551,8 @@ int zram_init_device(struct zram *zram)
>>   	}
>>   
>>   	num_pages = zram->disksize >> PAGE_SHIFT;
>> -	zram->table = vzalloc(num_pages * sizeof(*zram->table));
>> -	if (!zram->table) {
>> +	zram->handle = vzalloc(num_pages * sizeof(*zram->handle));
>> +	if (!zram->handle) {
>>   		pr_err("Error allocating zram address table\n");
>>   		ret = -ENOMEM;
>>   		goto fail_no_table;
> Since the table goes away, for readability sake, we'd better remove all
> reference to it in messages, labels and comment and write "handle"
> instead.

Missed those messages, will fix that.

> Otherwise, the patch looks good to me.

Thanks for the review.
Nitin

>
>> diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
>> index df2eec4..8aa733c 100644
>> --- a/drivers/staging/zram/zram_drv.h
>> +++ b/drivers/staging/zram/zram_drv.h
>> @@ -54,24 +54,10 @@ static const size_t max_zpage_size = PAGE_SIZE / 4 * 3;
>>   #define ZRAM_SECTOR_PER_LOGICAL_BLOCK	\
>>   	(1 << (ZRAM_LOGICAL_BLOCK_SHIFT - SECTOR_SHIFT))
>>   
>> -/* Flags for zram pages (table[page_no].flags) */
>> -enum zram_pageflags {
>> -	/* Page consists entirely of zeros */
>> -	ZRAM_ZERO,
>> -
>> -	__NR_ZRAM_PAGEFLAGS,
>> -};
>> +static const unsigned long zero_page_handle = (unsigned long)(-1);
>>   
>>   /*-- Data structures */
>>   
>> -/* Allocated for each disk page */
>> -struct table {
>> -	unsigned long handle;
>> -	u16 size;	/* object size (excluding header) */
>> -	u8 count;	/* object ref count (not yet used) */
>> -	u8 flags;
>> -} __aligned(4);
>> -
>>   struct zram_stats {
>>   	u64 compr_size;		/* compressed size of pages stored */
>>   	u64 num_reads;		/* failed + successful */
>> @@ -90,7 +76,7 @@ struct zram {
>>   	struct zs_pool *mem_pool;
>>   	void *compress_workmem;
>>   	void *compress_buffer;
>> -	struct table *table;
>> +	unsigned long *handle;	/* memory handle for each disk page */
>>   	spinlock_t stat64_lock;	/* protect 64-bit stats */
>>   	struct rw_semaphore lock; /* protect compression buffers and table
>>   				   * against concurrent read and writes */
>>

