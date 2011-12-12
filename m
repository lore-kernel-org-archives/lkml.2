Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab1LLOwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 09:52:04 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58849 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab1LLOwC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 09:52:02 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Mel Gorman" <mel@csn.ul.ie>, "Dave Hansen" <dave@linux.vnet.ibm.com>
Cc: "Marek Szyprowski" <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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
        "Chunsang Jeong" <chunsang.jeong@linaro.org>
Subject: Re: [PATCH 03/11] mm: mmzone: introduce zone_pfn_same_memmap()
References: <1321634598-16859-1-git-send-email-m.szyprowski@samsung.com>
 <1321634598-16859-4-git-send-email-m.szyprowski@samsung.com>
 <20111212141953.GD3277@csn.ul.ie> <op.v6dr4pj43l0zgt@mpn-glaptop>
 <20111212144030.GF3277@csn.ul.ie>
Date: Mon, 12 Dec 2011 15:51:55 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v6dswtfw3l0zgt@mpn-glaptop>
In-Reply-To: <20111212144030.GF3277@csn.ul.ie>
User-Agent: Opera Mail/11.60 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Nov 18, 2011 at 05:43:10PM +0100, Marek Szyprowski wrote:
>> From: Michal Nazarewicz <mina86@mina86.com>
>> diff --git a/mm/compaction.c b/mm/compaction.c
>> index 6afae0e..09c9702 100644
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -111,7 +111,10 @@ skip:
>>
>>  next:
>>  		pfn += isolated;
>> -		page += isolated;
>> +		if (zone_pfn_same_memmap(pfn - isolated, pfn))
>> +			page += isolated;
>> +		else
>> +			page = pfn_to_page(pfn);
>>  	}

On Mon, 12 Dec 2011 15:19:53 +0100, Mel Gorman <mel@csn.ul.ie> wrote:
> Is this necessary?
>
> We are isolating pages, the largest of which is a MAX_ORDER_NR_PAGES
> page.  [...]

On Mon, 12 Dec 2011 15:40:30 +0100, Mel Gorman <mel@csn.ul.ie> wrote:
> To be clear, I'm referring to a single page being isolated here. It may
> or may not be a high-order page but it's still going to be less then
> MAX_ORDER_NR_PAGES so you should be able check when a new block is
> entered and pfn_to_page is necessary.

Do you mean something like:

if (same pageblock)
	just do arithmetic;
else
	use pfn_to_page;

?

I've discussed it with Dave and he suggested that approach as an
optimisation since in some configurations zone_pfn_same_memmap()
is always true thus compiler will strip the else part, whereas
same pageblock test will be false on occasions regardless of kernel
configuration.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
