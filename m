Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab1LLOXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 09:23:11 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45983 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab1LLOXI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 09:23:08 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Marek Szyprowski" <m.szyprowski@samsung.com>,
        "Mel Gorman" <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
        "Ankita Garg" <ankita@in.ibm.com>,
        "Daniel Walker" <dwalker@codeaurora.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Jesse Barker" <jesse.barker@linaro.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Shariq Hasnain" <shariq.hasnain@linaro.org>,
        "Chunsang Jeong" <chunsang.jeong@linaro.org>,
        "Dave Hansen" <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 01/11] mm: page_alloc: handle MIGRATE_ISOLATE in
 free_pcppages_bulk()
References: <1321634598-16859-1-git-send-email-m.szyprowski@samsung.com>
 <1321634598-16859-2-git-send-email-m.szyprowski@samsung.com>
 <20111212134235.GB3277@csn.ul.ie>
Date: Mon, 12 Dec 2011 15:23:02 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v6drko0p3l0zgt@mpn-glaptop>
In-Reply-To: <20111212134235.GB3277@csn.ul.ie>
User-Agent: Opera Mail/11.60 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Nov 18, 2011 at 05:43:08PM +0100, Marek Szyprowski wrote:
>> From: Michal Nazarewicz <mina86@mina86.com>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 9dd443d..58d1a2e 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -628,6 +628,18 @@ static void free_pcppages_bulk(struct zone *zone, int count,
>>  			page = list_entry(list->prev, struct page, lru);
>>  			/* must delete as __free_one_page list manipulates */
>>  			list_del(&page->lru);
>> +
>> +			/*
>> +			 * When page is isolated in set_migratetype_isolate()
>> +			 * function it's page_private is not changed since the
>> +			 * function has no way of knowing if it can touch it.
>> +			 * This means that when a page is on PCP list, it's
>> +			 * page_private no longer matches the desired migrate
>> +			 * type.
>> +			 */
>> +			if (get_pageblock_migratetype(page) == MIGRATE_ISOLATE)
>> +				set_page_private(page, MIGRATE_ISOLATE);
>> +

On Mon, 12 Dec 2011 14:42:35 +0100, Mel Gorman <mel@csn.ul.ie> wrote:
> How much of a problem is this in practice?

IIRC, this lead to allocation being made from area marked as isolated
or some such.

> [...] I'd go as far to say that it would be preferable to drain the
> per-CPU lists after you set pageblocks MIGRATE_ISOLATE. The IPIs also have
> overhead but it will be incurred for the rare rather than the common case.

I'll look into that.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
