Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab2AAQGz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 11:06:55 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57951 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab2AAQGy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 11:06:54 -0500
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <op.v7ew5cvg3l0zgt@mpn-glaptop>
References: <1325162352-24709-1-git-send-email-m.szyprowski@samsung.com>
	<1325162352-24709-2-git-send-email-m.szyprowski@samsung.com>
	<CAOtvUMeAVgDwRNsDTcG07ChYnAuNgNJjQ+sKALJ79=Ezikos-A@mail.gmail.com>
	<op.v7ew5cvg3l0zgt@mpn-glaptop>
Date: Sun, 1 Jan 2012 18:06:53 +0200
Message-ID: <CAOtvUMfKDiLwxaH5FCS6wC=CgPiDz3ZAPbVv4b=Oxdx4ZpMCYw@mail.gmail.com>
Subject: Re: [PATCH 01/11] mm: page_alloc: set_migratetype_isolate: drain PCP
 prior to isolating
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daniel Walker <dwalker@codeaurora.org>, Mel Gorman <mel@csn.ul.ie>,
        Arnd Bergmann <arnd@arndb.de>, Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shariq Hasnain <shariq.hasnain@linaro.org>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/1 Michal Nazarewicz <mina86@mina86.com>:
>> On Thu, Dec 29, 2011 at 2:39 PM, Marek Szyprowski
>> <m.szyprowski@samsung.com> wrote:

...
> On Sun, 01 Jan 2012 08:49:13 +0100, Gilad Ben-Yossef <gilad@benyossef.com>
> wrote:
>>
>> Please consider whether sending an IPI to all processors in the system
>> and interrupting them is appropriate here.
>>
>> You seem to assume that it is probable that each CPU of the possibly
>> 4,096 (MAXSMP on x86) has a per-cpu page for the specified zone,
>
>
> I'm not really assuming that (in fact I expect what you fear, ie. that
> most CPUs won't have pages from specified zone an PCP list), however,
> I really need to make sure to get them off all PCP lists.
>

True, the question is whether or not you have to send a global IPI to do that.

>
>> otherwise you're just interrupting them out of doing something useful,
>> or save power idle for nothing.
>
>
> Exactly what's happening now anyway.
>
>

Indeed.

>> While that may or may not be a reasonable assumption for the general
>> drain_all_pages that drains pcps from all zones, I feel it is less
>> likely to be the right thing once you limit the drain to a single
>> zone.
>
>
> Currently, set_migratetype_isolate() seem to do more then it needs to,
> ie. it drains all the pages even though all it cares about is a single
>
> zone.

I agree your patch is better then current state. I just did want to add
yet another global IPI I'll have to chase afterwards.. :-)
>
>> Some background on my attempt to reduce "IPI noise" in the system in
>> this context is probably useful here as
>> well: https://lkml.org/lkml/2011/11/22/133
>
>
> Looks interesting, I'm not entirely sure why it does not end up a race
> condition, but in case of __zone_drain_all_pages() we already hold

If a page is in the PCP list when we check, you'll send the IPI and all is well.

If it isn't when we check and gets added later you could just the same have
situation where we send the IPI, try to do try an empty PCP list and then
the page gets added. So we are not adding a race condition that is not there
already :-)

> zone->lock, so my fears are somehow gone..  I'll give it a try, and prepare
> a patch for __zone_drain_all_pages().
>

I plan to send V5 of the IPI noise patch after some testing. It has a new
version of the drain_all_pages, with no allocation in the reclaim path
and no locking. You might want to wait till that one is out to base on it.


Thank you for considering my feedback :-)

Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"Unfortunately, cache misses are an equal opportunity pain provider."
-- Mike Galbraith, LKML
