Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab3AHBps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 20:45:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52932 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753412Ab3AHBpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 20:45:47 -0500
X-IronPort-AV: E=Sophos;i="4.84,428,1355068800"; 
   d="scan'208";a="6539217"
Message-ID: <50EB7A13.7080104@cn.fujitsu.com>
Date: Tue, 08 Jan 2013 09:44:51 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: tj@kernel.org, mingo@kernel.org, yinghai@kernel.org,
        liwanp@linux.vnet.ibm.com, benh@kernel.crashing.org,
        tangchen@cn.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: memblock: fix wrong memmove size in memblock_merge_regions()
References: <1357530096-28548-1-git-send-email-linfeng@cn.fujitsu.com> <20130107132341.c8ca0060.akpm@linux-foundation.org>
In-Reply-To: <20130107132341.c8ca0060.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/08 09:45:12,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/08 09:45:14,
	Serialize complete at 2013/01/08 09:45:14
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/08/2013 05:23 AM, Andrew Morton wrote:
> On Mon, 7 Jan 2013 11:41:36 +0800
> Lin Feng <linfeng@cn.fujitsu.com> wrote:
> 
>> The memmove span covers from (next+1) to the end of the array, and the index
>> of next is (i+1), so the index of (next+1) is (i+2). So the size of remaining
>> array elements is (type->cnt - (i + 2)).
> 
> What are the user-visible effects of this bug?
Hi Andrew,

Since the remaining elements of the memblock array are move forward by one
element and there is only one additional element caused by this bug. 
So there won't be any write overflow here but read overflow. 
It may read one more element out of the array address if the array happens
to be full. Commonly it doesn't matter at all but if the array happens to
be located at the end a memblock, it may cause a invalid read operation
for the physical address doesn't exist. 

There are 2 *happens to be* here, so I think the probability is quite low,
I don't know if any guy is haunted by this bug before. 

Mostly I think it's user-invisible.

thanks,
linfeng
> 
>> --- a/mm/memblock.c
>> +++ b/mm/memblock.c
>> @@ -314,7 +314,8 @@ static void __init_memblock memblock_merge_regions(struct memblock_type *type)
>>  		}
>>  
>>  		this->size += next->size;
>> -		memmove(next, next + 1, (type->cnt - (i + 1)) * sizeof(*next));
>> +		/* move forward from next + 1, index of which is i + 2 */
>> +		memmove(next, next + 1, (type->cnt - (i + 2)) * sizeof(*next));
>>  		type->cnt--;
>>  	}
>>  }
>> -- 
>> 1.7.11.7
> 
