Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab2K0Pq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 10:46:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260Ab2K0Pq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 10:46:58 -0500
Message-ID: <50B4E032.2010206@redhat.com>
Date: Tue, 27 Nov 2012 16:45:54 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Nitin Gupta <ngupta@vflare.org>
CC: Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 2/2] zram: allocate metadata when disksize is set up
References: <1353638567-3981-1-git-send-email-minchan@kernel.org> <1353638567-3981-2-git-send-email-minchan@kernel.org> <50B44BF4.30803@vflare.org>
In-Reply-To: <50B44BF4.30803@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 06:13 AM, Nitin Gupta wrote:
> On 11/22/2012 06:42 PM, Minchan Kim wrote:
>> Lockdep complains about recursive deadlock of zram->init_lock.
>> Because zram_init_device could be called in reclaim context and
>> it requires a page with GFP_KERNEL.
>>
>> We can fix it via replacing GFP_KERNEL with GFP_NOIO.
>> But more big problem is vzalloc in zram_init_device which calls GFP_KERNEL.
>> We can change it with __vmalloc which can receive gfp_t.
>> But still we have a problem. Although __vmalloc can handle gfp_t, it calls
>> allocation of GFP_KERNEL. That's why I sent the patch.
>> https://lkml.org/lkml/2012/4/23/77
>>
>> Yes. Fundamental problem is utter crap API vmalloc.
>> If we can fix it, everyone would be happy. But life isn't simple
>> like seeing my thread of the patch.
>>
>> So next option is to give up lazy initialization and initialize it at the
>> very disksize setting time. But it makes unnecessary metadata waste until
>> zram is really used. But let's think about it.
>>
>> 1) User of zram normally do mkfs.xxx or mkswap before using
>>     the zram block device(ex, normally, do it at booting time)
>>     It ends up allocating such metadata of zram before real usage so
>>     benefit of lazy initialzation would be mitigated.
>>
>> 2) Some user want to use zram when memory pressure is high.(ie, load zram
>>     dynamically, NOT booting time). It does make sense because people don't
>>     want to waste memory until memory pressure is high(ie, where zram is really
>>     helpful time). In this case, lazy initialzation could be failed easily
>>     because we will use GFP_NOIO instead of GFP_KERNEL for avoiding deadlock.
>>     So the benefit of lazy initialzation would be mitigated, too.
>>
>> 3) Metadata overhead is not critical and Nitin has a plan to diet it.
>>     4K : 12 byte(64bit machine) -> 64G : 192M so 0.3% isn't big overhead
>>     If insane user use such big zram device up to 20, it could consume 6% of ram
>>     but efficieny of zram will cover the waste.
>>
>> So this patch gives up lazy initialization and instead we initialize metadata
>> at disksize setting time.
>>
>> Signed-off-by: Minchan Kim <minchan@kernel.org>
>> ---
>>   drivers/staging/zram/zram_drv.c   |   21 ++++-----------------
>>   drivers/staging/zram/zram_sysfs.c |    1 +
>>   2 files changed, 5 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
>> index 9ef1eca..f364fb5 100644
>> --- a/drivers/staging/zram/zram_drv.c
>> +++ b/drivers/staging/zram/zram_drv.c
>> @@ -441,16 +441,13 @@ static void zram_make_request(struct request_queue *queue, struct bio *bio)
>>   {
>>   	struct zram *zram = queue->queuedata;
>>
>> -	if (unlikely(!zram->init_done) && zram_init_device(zram))
>> -		goto error;
>> -
>>   	down_read(&zram->init_lock);
>>   	if (unlikely(!zram->init_done))
>> -		goto error_unlock;
>> +		goto error;
>>
>>   	if (!valid_io_request(zram, bio)) {
>>   		zram_stat64_inc(zram, &zram->stats.invalid_io);
>> -		goto error_unlock;
>> +		goto error;
>>   	}
>>
>>   	__zram_make_request(zram, bio, bio_data_dir(bio));
>> @@ -458,9 +455,8 @@ static void zram_make_request(struct request_queue *queue, struct bio *bio)
>>
>>   	return;
>>
>> -error_unlock:
>> -	up_read(&zram->init_lock);
>>   error:
>> +	up_read(&zram->init_lock);
>>   	bio_io_error(bio);
>>   }
>>
>> @@ -509,19 +505,12 @@ void zram_reset_device(struct zram *zram)
>>   	up_write(&zram->init_lock);
>>   }
>>
>> +/* zram->init_lock should be hold */
> 
> s/hold/held
> 
> btw, shouldn't we also change GFP_KERNEL to GFP_NOIO in is_partial_io() 
> case in both read/write handlers?

Good point. Actually, the one in zram_bvec_read() should actually be
GFP_ATOMIC because of the kmap_atomic() above (or be moved out of
kmap_atomic/kunmap_atomic nest).
Another solution would be to allocate some working buffer at device
init as it's done for compress_buffer/workmem. It would make
zram_bvec_read/write look simpler (no need to free memory or manage 
kmalloc failure).

Jerome

> 
> Rest of the patch looks good.
> 
> 
> Thanks,
> Nitin
> 
>>   int zram_init_device(struct zram *zram)
>>   {
>>   	int ret;
>>   	size_t num_pages;
>>
>> -	down_write(&zram->init_lock);
>> -	if (zram->init_done) {
>> -		up_write(&zram->init_lock);
>> -		return 0;
>> -	}
>> -
>> -	BUG_ON(!zram->disksize);
>> -
>>   	if (zram->disksize > 2 * (totalram_pages << PAGE_SHIFT)) {
>>   		pr_info(
>>   		"There is little point creating a zram of greater than "
>> @@ -570,7 +559,6 @@ int zram_init_device(struct zram *zram)
>>   	}
>>
>>   	zram->init_done = 1;
>> -	up_write(&zram->init_lock);
>>
>>   	pr_debug("Initialization done!\n");
>>   	return 0;
>> @@ -580,7 +568,6 @@ fail_no_table:
>>   	zram->disksize = 0;
>>   fail:
>>   	__zram_reset_device(zram);
>> -	up_write(&zram->init_lock);
>>   	pr_err("Initialization failed: err=%d\n", ret);
>>   	return ret;
>>   }
>> diff --git a/drivers/staging/zram/zram_sysfs.c b/drivers/staging/zram/zram_sysfs.c
>> index 4143af9..369db12 100644
>> --- a/drivers/staging/zram/zram_sysfs.c
>> +++ b/drivers/staging/zram/zram_sysfs.c
>> @@ -71,6 +71,7 @@ static ssize_t disksize_store(struct device *dev,
>>
>>   	zram->disksize = PAGE_ALIGN(disksize);
>>   	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
>> +	zram_init_device(zram);
>>   	up_write(&zram->init_lock);
>>
>>   	return len;
>>
> 

