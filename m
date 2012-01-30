Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab2A3NGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 08:06:54 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57889 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab2A3NGx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 08:06:53 -0500
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
        "Daniel Walker" <dwalker@codeaurora.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Jesse Barker" <jesse.barker@linaro.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Shariq Hasnain" <shariq.hasnain@linaro.org>,
        "Chunsang Jeong" <chunsang.jeong@linaro.org>,
        "Dave Hansen" <dave@linux.vnet.ibm.com>,
        "Benjamin Gaignard" <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH 08/15] mm: mmzone: MIGRATE_CMA migration type added
References: <1327568457-27734-1-git-send-email-m.szyprowski@samsung.com>
 <1327568457-27734-9-git-send-email-m.szyprowski@samsung.com>
 <20120130123542.GL25268@csn.ul.ie>
Date: Mon, 30 Jan 2012 14:06:50 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v8wepotk3l0zgt@mpn-glaptop>
In-Reply-To: <20120130123542.GL25268@csn.ul.ie>
User-Agent: Opera Mail/11.61 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Jan 26, 2012 at 10:00:50AM +0100, Marek Szyprowski wrote:
>> From: Michal Nazarewicz <mina86@mina86.com>
>> @@ -875,10 +895,15 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
>>   * This array describes the order lists are fallen back to when
>>   * the free lists for the desirable migrate type are depleted
>>   */
>> -static int fallbacks[MIGRATE_TYPES][3] = {
>> +static int fallbacks[MIGRATE_TYPES][4] = {
>>  	[MIGRATE_UNMOVABLE]   = { MIGRATE_RECLAIMABLE, MIGRATE_MOVABLE,   MIGRATE_RESERVE },
>>  	[MIGRATE_RECLAIMABLE] = { MIGRATE_UNMOVABLE,   MIGRATE_MOVABLE,   MIGRATE_RESERVE },
>> +#ifdef CONFIG_CMA
>> +	[MIGRATE_MOVABLE]     = { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE, MIGRATE_CMA    , MIGRATE_RESERVE },

On Mon, 30 Jan 2012 13:35:42 +0100, Mel Gorman <mel@csn.ul.ie> wrote:
> This is a curious choice. MIGRATE_CMA is allowed to contain movable
> pages. By using MIGRATE_RECLAIMABLE and MIGRATE_UNMOVABLE for movable
> pages instead of MIGRATE_CMA, you increase the changes that unmovable
> pages will need to use MIGRATE_MOVABLE in the future which impacts
> fragmentation avoidance. I would recommend that you change this to
>
> { MIGRATE_CMA, MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE, MIGRATE_RESERVE }

At the beginning the idea was to try hard not to get pages from MIGRATE_CMA
allocated at all, thus it was put at the end of the fallbacks list, but on
a busy system this probably won't help anyway, so I'll change it per your
suggestion.

>> @@ -1017,11 +1049,14 @@ __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
>>  			rmv_page_order(page);
>>
>>  			/* Take ownership for orders >= pageblock_order */
>> -			if (current_order >= pageblock_order)
>> +			if (current_order >= pageblock_order &&
>> +			    !is_pageblock_cma(page))
>>  				change_pageblock_range(page, current_order,
>>  							start_migratetype);
>>
>> -			expand(zone, page, order, current_order, area, migratetype);
>> +			expand(zone, page, order, current_order, area,
>> +			       is_migrate_cma(start_migratetype)
>> +			     ? start_migratetype : migratetype);
>>
>
> What is this check meant to be doing?
>
> start_migratetype is determined by allocflags_to_migratetype() and
> that never will be MIGRATE_CMA so is_migrate_cma(start_migratetype)
> should always be false.

Right, thanks!  This should be the other way around, ie.:

+			expand(zone, page, order, current_order, area,
+			       is_migrate_cma(migratetype)
+			     ? migratetype : start_migratetype);

I'll fix this and the calls to is_pageblock_cma().

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
