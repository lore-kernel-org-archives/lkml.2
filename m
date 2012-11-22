Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab2KVTIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:08:42 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56278 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab2KVTIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:08:39 -0500
Message-ID: <50AE5007.2000702@gmail.com>
Date: Fri, 23 Nov 2012 00:17:11 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Wen Congyang <wency@cn.fujitsu.com>, David Rientjes <rientjes@google.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Chris Clayton <chris2553@googlemail.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFT PATCH v1 4/5] mm: provide more accurate estimation of pages
 occupied by memmap
References: <20121115112454.e582a033.akpm@linux-foundation.org> <1353254850-27336-1-git-send-email-jiang.liu@huawei.com> <1353254850-27336-5-git-send-email-jiang.liu@huawei.com> <20121119154240.91efcc53.akpm@linux-foundation.org> <50AB9F4A.5050500@gmail.com> <20121120111942.c9596d3f.akpm@linux-foundation.org> <50ACEAAD.60306@gmail.com> <20121121113515.3fa5a60c.akpm@linux-foundation.org>
In-Reply-To: <20121121113515.3fa5a60c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2012 03:35 AM, Andrew Morton wrote:
> On Wed, 21 Nov 2012 22:52:29 +0800
> Jiang Liu <liuj97@gmail.com> wrote:
> 
>> On 11/21/2012 03:19 AM, Andrew Morton wrote:
>>> On Tue, 20 Nov 2012 23:18:34 +0800
>>> Jiang Liu <liuj97@gmail.com> wrote:
>>>
>>>>>> +static unsigned long calc_memmap_size(unsigned long spanned_pages,
>>>>>> +				      unsigned long present_pages)
>>>>>> +{
>>>>>> +	unsigned long pages = spanned_pages;
>>>>>> +
>>>>>> +	/*
>>>>>> +	 * Provide a more accurate estimation if there are big holes within
>>>>>> +	 * the zone and SPARSEMEM is in use.
>>>>>> +	 */
>>>>>> +	if (spanned_pages > present_pages + (present_pages >> 4) &&
>>>>>> +	    IS_ENABLED(CONFIG_SPARSEMEM))
>>>>>> +		pages = present_pages;
>>>>>> +
>>>>>> +	return PAGE_ALIGN(pages * sizeof(struct page)) >> PAGE_SHIFT;
>>>>>> +}
>>>>>
>>>>> Please explain the ">> 4" heuristc more completely - preferably in both
>>>>> the changelog and code comments.  Why can't we calculate this
>>>>> requirement exactly?  That might require a second pass, but that's OK for
>>>>> code like this?
>>>> Hi Andrew,
>>>> 	A normal x86 platform always have some holes within the DMA ZONE,
>>>> so the ">> 4" heuristic is to avoid applying this adjustment to the DMA
>>>> ZONE on x86 platforms. 
>>>> 	Because the memmap_size is just an estimation, I feel it's OK to
>>>> remove the ">> 4" heuristic, that shouldn't affect much.
>>>
>>> Again: why can't we calculate this requirement exactly?  That might
>>> require a second pass, but that's OK for code like this?
>>
>> Hi Andrew,
>> 	If there are holes within a zone, it may cost us one or two extra pages
>> for each populated region within the zone due to alignment because memmap for 
>> each populated regions may not naturally aligned on page boundary.
> 
> Right.  So with an additional pass across the zone and a bit of
> arithmetic, we can calculate the exact space requirement for memmap?
> No need for kludgy heuristics?
Hi Andrew:
	Happy Thanksgiving!

The way to calculate the exact space requirement for memmap seems a little
complex, it depends on:
CONFIG_SPARSEMEM_VMEMMAP
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
arch implemenation of alloc_remap()

Actually the original motivation is to reduce the deviation on a platform
such as:
node 0: 0-2G,4G-255G (a 2G hole between 2-4G)
node 1: 256G - 511G
node 2: 512G - 767G
node 3: 768G - 1023G
node 0: 1024G - 1026G (memory recovered from the hole)

So I just tried to reduce the deviation instead of accurate calculation of memmap.

Regards!
Gerry
