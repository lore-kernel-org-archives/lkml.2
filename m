Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab2KUOxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 09:53:00 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45061 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871Ab2KUOw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 09:52:59 -0500
Message-ID: <50ACEAAD.60306@gmail.com>
Date: Wed, 21 Nov 2012 22:52:29 +0800
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
References: <20121115112454.e582a033.akpm@linux-foundation.org> <1353254850-27336-1-git-send-email-jiang.liu@huawei.com> <1353254850-27336-5-git-send-email-jiang.liu@huawei.com> <20121119154240.91efcc53.akpm@linux-foundation.org> <50AB9F4A.5050500@gmail.com> <20121120111942.c9596d3f.akpm@linux-foundation.org>
In-Reply-To: <20121120111942.c9596d3f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2012 03:19 AM, Andrew Morton wrote:
> On Tue, 20 Nov 2012 23:18:34 +0800
> Jiang Liu <liuj97@gmail.com> wrote:
> 
>>>> +static unsigned long calc_memmap_size(unsigned long spanned_pages,
>>>> +				      unsigned long present_pages)
>>>> +{
>>>> +	unsigned long pages = spanned_pages;
>>>> +
>>>> +	/*
>>>> +	 * Provide a more accurate estimation if there are big holes within
>>>> +	 * the zone and SPARSEMEM is in use.
>>>> +	 */
>>>> +	if (spanned_pages > present_pages + (present_pages >> 4) &&
>>>> +	    IS_ENABLED(CONFIG_SPARSEMEM))
>>>> +		pages = present_pages;
>>>> +
>>>> +	return PAGE_ALIGN(pages * sizeof(struct page)) >> PAGE_SHIFT;
>>>> +}
>>>
>>> Please explain the ">> 4" heuristc more completely - preferably in both
>>> the changelog and code comments.  Why can't we calculate this
>>> requirement exactly?  That might require a second pass, but that's OK for
>>> code like this?
>> Hi Andrew,
>> 	A normal x86 platform always have some holes within the DMA ZONE,
>> so the ">> 4" heuristic is to avoid applying this adjustment to the DMA
>> ZONE on x86 platforms. 
>> 	Because the memmap_size is just an estimation, I feel it's OK to
>> remove the ">> 4" heuristic, that shouldn't affect much.
> 
> Again: why can't we calculate this requirement exactly?  That might
> require a second pass, but that's OK for code like this?

Hi Andrew,
	If there are holes within a zone, it may cost us one or two extra pages
for each populated region within the zone due to alignment because memmap for 
each populated regions may not naturally aligned on page boundary.
	Originally the ">> 4" heuristic is to trade off these extra memmap pages,
especially for small zones linke DMA zone.
	Thanks!


