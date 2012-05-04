Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab2EDC1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 22:27:24 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:46325 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab2EDC1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 22:27:23 -0400
X-AuditID: 9c930179-b7c19ae000000486-89-4fa33e8a94ae
Message-ID: <4FA33E89.6080206@kernel.org>
Date: Fri, 04 May 2012 11:27:21 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Nitin Gupta <ngupta@vflare.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 4/4] zsmalloc: zsmalloc: align cache line size
References: <1336027242-372-1-git-send-email-minchan@kernel.org> <1336027242-372-4-git-send-email-minchan@kernel.org> <4FA28EFD.5070002@vflare.org>
In-Reply-To: <4FA28EFD.5070002@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 10:58 PM, Nitin Gupta wrote:

> On 5/3/12 2:40 AM, Minchan Kim wrote:
>> It's a overkill to align pool size with PAGE_SIZE to avoid
>> false-sharing. This patch aligns it with just cache line size.
>>
>> Signed-off-by: Minchan Kim<minchan@kernel.org>
>> ---
>>   drivers/staging/zsmalloc/zsmalloc-main.c |    6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c
>> b/drivers/staging/zsmalloc/zsmalloc-main.c
>> index 51074fa..3991b03 100644
>> --- a/drivers/staging/zsmalloc/zsmalloc-main.c
>> +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
>> @@ -489,14 +489,14 @@ fail:
>>
>>   struct zs_pool *zs_create_pool(const char *name, gfp_t flags)
>>   {
>> -    int i, error, ovhd_size;
>> +    int i, error;
>>       struct zs_pool *pool;
>>
>>       if (!name)
>>           return NULL;
>>
>> -    ovhd_size = roundup(sizeof(*pool), PAGE_SIZE);
>> -    pool = kzalloc(ovhd_size, GFP_KERNEL);
>> +    pool = kzalloc(ALIGN(sizeof(*pool), cache_line_size()),
>> +                GFP_KERNEL);
> 
> a basic question:
>  Is rounding off allocation size to cache_line_size enough to ensure
> that the object is cache-line-aligned? Isn't it possible that even
> though the object size is multiple of cache-line, it may still not be
> properly aligned and end up sharing cache line with some other
> read-mostly object?


AFAIK, SLAB allocates object aligned cache-size so I think that problem cannot happen.
But needs double check.
Cced Pekka.

> 
> Thanks,
> Nitin
> 
> 
>>       if (!pool)
>>           return NULL;
>>
> 
> -- 
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign
> http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 



-- 
Kind regards,
Minchan Kim
