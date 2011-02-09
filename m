Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab1BILQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 06:16:13 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:44417 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab1BILQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 06:16:12 -0500
Message-ID: <4D527774.1090509@linux.vnet.ibm.com>
Date: Wed, 09 Feb 2011 16:46:04 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, npiggin@kernel.dk, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com,
        cl@linux.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 3/3][RESEND] Provide control over unmapped pages (v4)
References: <20110201165329.12377.13683.stgit@localhost6.localdomain6> <20110201165533.12377.11775.stgit@localhost6.localdomain6> <20110208155756.e149c3b6.akpm@linux-foundation.org>
In-Reply-To: <20110208155756.e149c3b6.akpm@linux-foundation.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2011 05:27 AM, Andrew Morton wrote:
> On Tue, 01 Feb 2011 22:25:45 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> Changelog v4
>> 1. Add max_unmapped_ratio and use that as the upper limit
>> to check when to shrink the unmapped page cache (Christoph
>> Lameter)
>>
>> Changelog v2
>> 1. Use a config option to enable the code (Andrew Morton)
>> 2. Explain the magic tunables in the code or at-least attempt
>>    to explain them (General comment)
>> 3. Hint uses of the boot parameter with unlikely (Andrew Morton)
>> 4. Use better names (balanced is not a good naming convention)
>>
>> Provide control using zone_reclaim() and a boot parameter. The
>> code reuses functionality from zone_reclaim() to isolate unmapped
>> pages and reclaim them as a priority, ahead of other mapped pages.
>> A new sysctl for max_unmapped_ratio is provided and set to 16,
>> indicating 16% of the total zone pages are unmapped, we start
>> shrinking unmapped page cache.
> 
> We'll need some documentation for sysctl_max_unmapped_ratio, please. 
> In Documentation/sysctl/vm.txt, I suppose.
> 
> It will be interesting to find out what this ratio refers to.  it
> apears to be a percentage.  We've had problem in the past where 1% was
> way too much and we had to change the kernel to provide much
> finer-grained control.
> 

Sure, I'll update the Documentation as a part of this patchset. Yes, the current
min_unmapped_ratio is a percentage and so is max_unmapped_ratio. min_unmapped_ratio
already exists, adding max_ should not affect granularity of control. It
will be worth relooking at the granularity based on user feedback and
experience. We won't break ABI if we add additional interfaces to help
granularity.


>>
>> ...
>>
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -306,7 +306,10 @@ struct zone {
>>  	/*
>>  	 * zone reclaim becomes active if more unmapped pages exist.
>>  	 */
>> +#if defined(CONFIG_UNMAPPED_PAGE_CONTROL) || defined(CONFIG_NUMA)
>>  	unsigned long		min_unmapped_pages;
>> +	unsigned long		max_unmapped_pages;
>> +#endif
> 
> This change breaks the connection between min_unmapped_pages and its
> documentation, and fails to document max_unmapped_pages.
> 

I'll fix that

> Also, afacit if CONFIG_NUMA=y and CONFIG_UNMAPPED_PAGE_CONTROL=n,
> max_unmapped_pages will be present in the kernel image and will appear
> in /proc but it won't actually do anything.  Seems screwed up and
> misleading.
> 


Good catch! In one of the emails Christoph mentioned that max_unmapped_ratio
might be helpful even in the general case (but we need to work on that later).
For now, I'll fix this and repose.


>> ...
>>
>> +#if defined(CONFIG_UNMAPPED_PAGECACHE_CONTROL)
>> +/*
>> + * Routine to reclaim unmapped pages, inspired from the code under
>> + * CONFIG_NUMA that does unmapped page and slab page control by keeping
>> + * min_unmapped_pages in the zone. We currently reclaim just unmapped
>> + * pages, slab control will come in soon, at which point this routine
>> + * should be called reclaim cached pages
>> + */
>> +unsigned long reclaim_unmapped_pages(int priority, struct zone *zone,
>> +						struct scan_control *sc)
>> +{
>> +	if (unlikely(unmapped_page_control) &&
>> +		(zone_unmapped_file_pages(zone) > zone->min_unmapped_pages)) {
>> +		struct scan_control nsc;
>> +		unsigned long nr_pages;
>> +
>> +		nsc = *sc;
>> +
>> +		nsc.swappiness = 0;
>> +		nsc.may_writepage = 0;
>> +		nsc.may_unmap = 0;
>> +		nsc.nr_reclaimed = 0;
>> +
>> +		nr_pages = zone_unmapped_file_pages(zone) -
>> +				zone->min_unmapped_pages;
>> +		/*
>> +		 * We don't want to be too aggressive with our
>> +		 * reclaim, it is our best effort to control
>> +		 * unmapped pages
>> +		 */
>> +		nr_pages >>= 3;
>> +
>> +		zone_reclaim_pages(zone, &nsc, nr_pages);
>> +		return nsc.nr_reclaimed;
>> +	}
>> +	return 0;
>> +}
> 
> This returns an undocumented ulong which is never used by callers.
> 

Good catch! I;ll remove the return value, I don't expect it to be used
to check how much we could reclaim.

Thanks for the review!

-- 
	Three Cheers,
	Balbir
