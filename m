Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab0IGIwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 04:52:51 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46339 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab0IGIws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 04:52:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 7 Sep 2010 17:47:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@csn.ul.ie>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] big continuous memory allocator v2
Message-Id: <20100907174743.2efa34bd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTintQqzx50Jp_zyKQMaAfhSEFah3HhseNmNfNMjB@mail.gmail.com>
References: <20100907114505.fc40ea3d.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTintQqzx50Jp_zyKQMaAfhSEFah3HhseNmNfNMjB@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Sep 2010 01:37:27 -0700
Minchan Kim <minchan.kim@gmail.com> wrote:

> Nice cleanup.
> There are some comments in below.
> 
> On Mon, Sep 6, 2010 at 7:45 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >
> > This is a page allcoator based on memory migration/hotplug code.
> > passed some small tests, and maybe easier to read than previous one.
> >
> > ==
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >
> > This patch as a memory allocator for contiguous memory larger than MAX_ORDER.
> >
> >  alloc_contig_pages(hint, size, node);
> 
> I have thought this patch is to be good for dumb device drivers which
> want big contiguous
> memory. So if some device driver want big memory and they can tolerate
> latency or fail,
> this is good solution, I think.
> And some device driver can't tolerate fail, they have to use MOVABLE zone.
> 
> For it, I hope we have a option like ALLOC_FIXED(like MAP_FIXED).
> That's because embedded people wanted to aware BANK of memory.
> So if they get free page which they don't want, it can be pointless.
> 
Okay.


> In addition, I hope it can support CROSS_ZONE migration mode.
> Most of small system can't support swap system. So if we can't migrate
> anon pages into other zones, external fragment problem still happens.
> 
Now, this code migrates pages to somewhere, including crossing zone, node etc..
(because it just use GFP_HIGHUSER_MOVABLE)

> I think reclaim(ex, discard file-backed pages) can become one option to prevent
> the problem. But it's more cost so we can support it by calling mode.
> (But it could be trivial since caller should know this function is very cost)
> 

> ex) alloc_contig_pages(hint, size, node, ALLOC_FIXED|ALLOC_RECLAIM);
> 

This migration's page allocation code will cause memory reclaim and
kswapd wakeup if memory is in short. But hmm, there are no codes as

 reclaim_memory_within(start, end).

But I guess if there are LRU pages within the range which cannot be migrated,
they can't be dropped. In another consideration, 

  shrink_slab_within(start, end)
will be able to make success-rate better. (and this is good for memory hotplug, too)

I'll start from adding ALLOC_FIXED.

Thanks,
-Kame

