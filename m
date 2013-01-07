Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab3AGByP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 20:54:15 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:2780 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753062Ab3AGByN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 20:54:13 -0500
X-IronPort-AV: E=Sophos;i="4.84,421,1355068800"; 
   d="scan'208";a="6532634"
Message-ID: <50EA2A8F.1000601@cn.fujitsu.com>
Date: Mon, 07 Jan 2013 09:53:19 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: akpm@linux-foundation.org, mingo@kernel.org, yinghai@kernel.org,
        liwanp@linux.vnet.ibm.com, benh@kernel.crashing.org,
        tangchen@cn.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm: memblock: optimize memblock_find_in_range_node()
 to minimize the search work
References: <1357291493-25773-1-git-send-email-linfeng@cn.fujitsu.com> <20130104150139.GB15633@mtj.dyndns.org>
In-Reply-To: <20130104150139.GB15633@mtj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/07 09:53:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/07 09:53:42,
	Serialize complete at 2013/01/07 09:53:42
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/04/2013 11:01 PM, Tejun Heo wrote:
> On Fri, Jan 04, 2013 at 05:24:53PM +0800, Lin Feng wrote:
>> The memblock array is in ascending order and we traverse the memblock array in
>> reverse order so we can add some simple check to reduce the search work.
>>
>> Tejun fix a underflow bug in 5d53cb27d8, but I think we could break there for
>> the same reason.
>>
>> Cc: Tejun Heo <tj@kernel.org>
>> Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
>> ---
>>  mm/memblock.c | 9 ++++++++-
>>  1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/memblock.c b/mm/memblock.c
>> index 6259055..a710557 100644
>> --- a/mm/memblock.c
>> +++ b/mm/memblock.c
>> @@ -111,11 +111,18 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
>>  	end = max(start, end);
>>  
>>  	for_each_free_mem_range_reverse(i, nid, &this_start, &this_end, NULL) {
>> +		/*
>> +		 * exclude the regions out of the candidate range, since it's
>> +		 * likely to find a suitable range, we ignore the worst case.
>> +		 */
>> +		if (this_start >= end)
>> +			continue;
>> +
>>  		this_start = clamp(this_start, start, end);
>>  		this_end = clamp(this_end, start, end);
>>  
>>  		if (this_end < size)
>> -			continue;
>> +			break;
> 
> I don't know.  This only saves looping when memblocks are below the
> requested size, right?  I don't think it would matter in any way and
> would prefer to keep the logic as simple as possible.
Hi Tejun,

You're right, when we hit the 'if (this_end < size)' branch, it's nearly 
the end of the whole search loops. I just got an impression that is 
there any candidate range after we hit the if clause when I first read
this code, so... ;-)

thanks,
linfeng
> 
> Thanks.
> 
