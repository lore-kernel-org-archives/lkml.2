Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838Ab1IHBbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 21:31:44 -0400
Received: from mail-vw0-f43.google.com ([209.85.212.43]:38925 "EHLO
	mail-vw0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757812Ab1IHBbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 21:31:42 -0400
Message-ID: <4E681AFB.7040708@vflare.org>
Date: Wed, 07 Sep 2011 21:31:39 -0400
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Jerome Marchand <jmarchan@redhat.com>
CC: Greg KH <greg@kroah.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] Simplify zram disk resizing interface
References: <1314149690-3177-1-git-send-email-ngupta@vflare.org> <1314149690-3177-4-git-send-email-ngupta@vflare.org> <4E5CB734.2000103@redhat.com>
In-Reply-To: <4E5CB734.2000103@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2011 06:11 AM, Jerome Marchand wrote:
> On 08/24/2011 03:34 AM, Nitin Gupta wrote:
>> Also remove unnecessary messages.
>>
>> Signed-off-by: Nitin Gupta<ngupta@vflare.org>
>> ---
>>   drivers/staging/zram/zram_drv.c |   42 +++++++++++---------------------------
>>   drivers/staging/zram/zram_drv.h |    2 +-
>>   2 files changed, 13 insertions(+), 31 deletions(-)
>>
>> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
>> index 81d6c43..d7fb207 100644
>> --- a/drivers/staging/zram/zram_drv.c
>> +++ b/drivers/staging/zram/zram_drv.c
>> @@ -104,33 +104,16 @@ static int page_zero_filled(void *ptr)
>>   	return 1;
>>   }
>>
>> -static void zram_set_disksize(struct zram *zram, size_t totalram_bytes)
>> +static u64 zram_default_disksize_bytes(void)
>>   {
>> -	if (!zram->disksize) {
>> -		pr_info(
>> -		"disk size not provided. You can use disksize_kb module "
>> -		"param to specify size.\nUsing default: (%u%% of RAM).\n",
>> -		default_disksize_perc_ram
>> -		);
>> -		zram->disksize = default_disksize_perc_ram *
>> -					(totalram_bytes / 100);
>> -	}
>> -
>> -	if (zram->disksize>  2 * (totalram_bytes)) {
>> -		pr_info(
>> -		"There is little point creating a zram of greater than "
>> -		"twice the size of memory since we expect a 2:1 compression "
>> -		"ratio. Note that zram uses about 0.1%% of the size of "
>> -		"the disk when not in use so a huge zram is "
>> -		"wasteful.\n"
>> -		"\tMemory Size: %zu kB\n"
>> -		"\tSize you selected: %llu kB\n"
>> -		"Continuing anyway ...\n",
>> -		totalram_bytes>>  10, zram->disksize
>> -		);
>> -	}
>> -
>> -	zram->disksize&= PAGE_MASK;
>> +	return ((totalram_pages<<  PAGE_SHIFT) *
>> +		default_disksize_perc_ram / 100)&  PAGE_MASK;
>> +}
>> +
>> +static void zram_set_disksize(struct zram *zram, u64 size_bytes)
>> +{
>> +	zram->disksize = size_bytes;
>> +	set_capacity(zram->disk, size_bytes>>  SECTOR_SHIFT);
>>   }
>>
>>   static void zram_free_page(struct zram *zram, size_t index)
>> @@ -632,7 +615,8 @@ int zram_init_device(struct zram *zram)
>>   		return 0;
>>   	}
>>
>> -	zram_set_disksize(zram, totalram_pages<<  PAGE_SHIFT);
>> +	if (!zram->disksize)
>> +		zram_set_disksize(zram, zram_default_disksize_bytes());
>
> With your next patch, this will not happen anymore, unless someone explicitly sets
> the disk size to zero. If zero means default, it should be documented. It looks weird
> anyway: if something like that should be done, it probably should be done in
> disksize_store() for clarity.
> Otherwise, your next patch should remove this chunk of code.
>

Thanks for the review.  I have now removed that check in v2 patches 
since we now set some default value during initialization.

Thanks,
Nitin
