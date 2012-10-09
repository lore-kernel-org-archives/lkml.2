Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab2JIRfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:35:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57847 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998Ab2JIRf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:35:28 -0400
Message-ID: <5074605C.3000301@vflare.org>
Date: Tue, 09 Oct 2012 10:35:24 -0700
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg KH <greg@kroah.com>, Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Sam Hansen <solid.se7en@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [staging][zram] Fix handling of incompressible pages
References: <1349746364-8051-1-git-send-email-ngupta@vflare.org> <20121009133128.GA3244@barrios>
In-Reply-To: <20121009133128.GA3244@barrios>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Minchan,

On 10/09/2012 06:31 AM, Minchan Kim wrote:
>
> On Mon, Oct 08, 2012 at 06:32:44PM -0700, Nitin Gupta wrote:
>> Change 130f315a introduced a bug in the handling of incompressible
>> pages which resulted in memory allocation failure for such pages.
>> The fix is to store the page as-is i.e. without compression if the
>> compressed size exceeds a threshold (max_zpage_size) and request
>> exactly PAGE_SIZE sized buffer from zsmalloc.
>
> It seems you found a bug and already fixed it with below helpers.
> But unfortunately, description isn't enough to understand the problem for me.
> Could you explain in detail?
> You said it results in memory allocation failure. What is failure?
> You mean this code by needing a few pages for zspage to meet class size?
>
>          handle = zs_malloc(zram->mem_pool, clen);
>          if (!handle) {
>                  pr_info("Error allocating memory for compressed "
>                          "page: %u, size=%zu\n", index, clen);
>                  ret = -ENOMEM;
>                  goto out;
>          }
>
> So instead of allocating more pages for incompressible page to make zspage,
> just allocate a page for PAGE_SIZE class without compression?
>

When a page expands on compression, say from 4K to 4K+30, we were trying 
to do zsmalloc(pool, 4K+30). However, the maximum size which zsmalloc 
can allocate is PAGE_SIZE (for obvious reasons), so such allocation 
requests always return failure (0).

For a page that has compressed size larger than the original size (this 
may happen with already compressed or random data), there is no point 
storing the compressed version as that would take more space and would 
also require time for decompression when needed again. So, the fix is to 
store any page, whose compressed size exceeds a threshold 
(max_zpage_size), as-it-is i.e. without compression.  Memory required 
for storing this uncompressed page can then be requested from zsmalloc 
which supports PAGE_SIZE sized allocations.

Lastly, the fix checks that we do not attempt to "decompress" the page 
which we stored in the uncompressed form -- we just memcpy() out such pages.

Thanks,
Nitin


>>
>> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
>> Reported-by: viechweg@gmail.com
>> Reported-by: paerley@gmail.com
>> Reported-by: wu.tommy@gmail.com
>> Tested-by: wu.tommy@gmail.com
>> Tested-by: michael@zugelder.org
>> ---
>>   drivers/staging/zram/zram_drv.c |   12 ++++++++++--
>>   1 file changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
>> index 653b074..6edefde 100644
>> --- a/drivers/staging/zram/zram_drv.c
>> +++ b/drivers/staging/zram/zram_drv.c
>> @@ -223,8 +223,13 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
>>   	cmem = zs_map_object(zram->mem_pool, zram->table[index].handle,
>>   				ZS_MM_RO);
>>
>> -	ret = lzo1x_decompress_safe(cmem, zram->table[index].size,
>> +	if (zram->table[index].size == PAGE_SIZE) {
>> +		memcpy(uncmem, cmem, PAGE_SIZE);
>> +		ret = LZO_E_OK;
>> +	} else {
>> +		ret = lzo1x_decompress_safe(cmem, zram->table[index].size,
>>   				    uncmem, &clen);
>> +	}
>>
>>   	if (is_partial_io(bvec)) {
>>   		memcpy(user_mem + bvec->bv_offset, uncmem + offset,
>> @@ -342,8 +347,11 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>>   		goto out;
>>   	}
>>
>> -	if (unlikely(clen > max_zpage_size))
>> +	if (unlikely(clen > max_zpage_size)) {
>>   		zram_stat_inc(&zram->stats.bad_compress);
>> +		src = uncmem;
>> +		clen = PAGE_SIZE;
>> +	}
>>
>>   	handle = zs_malloc(zram->mem_pool, clen);
>>   	if (!handle) {
>> --
>> 1.7.9.5
>>
>

