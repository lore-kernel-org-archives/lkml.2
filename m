Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab2IFIzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 04:55:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:13524 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab2IFIzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 04:55:45 -0400
X-IronPort-AV: E=Sophos;i="4.80,379,1344182400"; 
   d="scan'208";a="5796405"
Message-ID: <5048657A.7060004@cn.fujitsu.com>
Date: Thu, 06 Sep 2012 16:57:30 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Nazarewicz <mina86@mina86.com>, Mel Gorman <mel@csn.ul.ie>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [RFC v2] memory-hotplug: remove MIGRATE_ISOLATE from free_area->free_list
References: <1346900018-14759-1-git-send-email-minchan@kernel.org> <50485B7B.3030201@cn.fujitsu.com> <20120906081818.GC16231@bbox>
In-Reply-To: <20120906081818.GC16231@bbox>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/06 16:55:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/06 16:55:19,
	Serialize complete at 2012/09/06 16:55:19
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 04:18 PM, Minchan Kim wrote:
> Hello Lai,
> 
> On Thu, Sep 06, 2012 at 04:14:51PM +0800, Lai Jiangshan wrote:
>> On 09/06/2012 10:53 AM, Minchan Kim wrote:
>>> Normally, MIGRATE_ISOLATE type is used for memory-hotplug.
>>> But it's irony type because the pages isolated would exist
>>> as free page in free_area->free_list[MIGRATE_ISOLATE] so people
>>> can think of it as allocatable pages but it is *never* allocatable.
>>> It ends up confusing NR_FREE_PAGES vmstat so it would be
>>> totally not accurate so some of place which depend on such vmstat
>>> could reach wrong decision by the context.
>>>
>>> There were already report about it.[1]
>>> [1] 702d1a6e, memory-hotplug: fix kswapd looping forever problem
>>>
>>> Then, there was other report which is other problem.[2]
>>> [2] http://www.spinics.net/lists/linux-mm/msg41251.html
>>>
>>> I believe it can make problems in future, too.
>>> So I hope removing such irony type by another design.
>>>
>>> I hope this patch solves it and let's revert [1] and doesn't need [2].
>>>
>>> * Changelog v1
>>>  * Fix from Michal's many suggestion
>>>
>>> Cc: Michal Nazarewicz <mina86@mina86.com>
>>> Cc: Mel Gorman <mel@csn.ul.ie>
>>> Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>> Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>>> Cc: Wen Congyang <wency@cn.fujitsu.com>
>>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>>> Signed-off-by: Minchan Kim <minchan@kernel.org>
>>> ---
>>
>>> @@ -180,30 +287,35 @@ int undo_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
>>>   * all pages in [start_pfn...end_pfn) must be in the same zone.
>>>   * zone->lock must be held before call this.
>>>   *
>>> - * Returns 1 if all pages in the range are isolated.
>>> + * Returns true if all pages in the range are isolated.
>>>   */
>>> -static int
>>> -__test_page_isolated_in_pageblock(unsigned long pfn, unsigned long end_pfn)
>>> +static bool
>>> +__test_page_isolated_in_pageblock(unsigned long start_pfn, unsigned long end_pfn)
>>>  {
>>> +	unsigned long pfn, next_pfn;
>>>  	struct page *page;
>>>  
>>> -	while (pfn < end_pfn) {
>>> -		if (!pfn_valid_within(pfn)) {
>>> -			pfn++;
>>> -			continue;
>>> -		}
>>> -		page = pfn_to_page(pfn);
>>> -		if (PageBuddy(page))
>>> -			pfn += 1 << page_order(page);
>>> -		else if (page_count(page) == 0 &&
>>> -				page_private(page) == MIGRATE_ISOLATE)
>>> -			pfn += 1;
>>> -		else
>>> -			break;
>>> +	list_for_each_entry(page, &isolated_pages, lru) {
>>
>>> +		if (&page->lru == &isolated_pages)
>>> +			return false;
>>
>> what's the mean of this line?
> 
> I just copied it from Michal's code but It seem to be not needed.
> I will remove it in next spin.
> 
>>
>>> +		pfn = page_to_pfn(page);
>>> +		if (pfn >= end_pfn)
>>> +			return false;



>>> +		if (pfn >= start_pfn)
>>> +			goto found;

this test is wrong.

if ((pfn <= start_pfn) && (start_pfn < pfn + (1UL << page_order(page))))
	goto found;


>>> +	}
>>> +	return false;
>>> +
>>> +	list_for_each_entry_continue(page, &isolated_pages, lru) {
>>> +		if (page_to_pfn(page) != next_pfn)
>>> +			return false;
>>
>> where is next_pfn init-ed? 
> 
> by "goto found"

don't goto inner label.

move the found label up:

+
+found:
+	next_pfn = page_to_pfn(page);
+	list_for_each_entry_from(page, &isolated_pages, lru) {
+		if (page_to_pfn(page) != next_pfn)
+			return false;
+		pfn = page_to_pfn(page);
+		next_pfn = pfn + (1UL << page_order(page));
+		if (next_pfn >= end_pfn)
+			return true;
 	}
