Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab2IGRb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 13:31:58 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:43401 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab2IGRb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 13:31:56 -0400
Message-ID: <504A2F64.10006@linux.vnet.ibm.com>
Date: Fri, 07 Sep 2012 12:31:16 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [RFC] mm: add support for zsmalloc and zcache
References: <<1346794486-12107-1-git-send-email-sjenning@linux.vnet.ibm.com>> <e33a2c0e-3b51-4d89-a2b2-c1ed9c8f862c@default>
In-Reply-To: <e33a2c0e-3b51-4d89-a2b2-c1ed9c8f862c@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090717-2398-0000-0000-00000A6E8D6A
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00172122; UDB=6.00039029; UTC=2012-09-07
 17:31:52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 03:37 PM, Dan Magenheimer wrote:
> In response to this RFC for zcache promotion, I've been asked to summarize
> the concerns and objections which led me to NACK the previous zcache
> promotion request.  While I see great potential in zcache, I think some
> significant design challenges exist, many of which are already resolved in
> the new codebase ("zcache2").  These design issues include:
> 
> A) Andrea Arcangeli pointed out and, after some deep thinking, I came
>    to agree that zcache _must_ have some "backdoor exit" for frontswap
>    pages [2], else bad things will eventually happen in many workloads.
>    This requires some kind of reaper of frontswap'ed zpages[1] which "evicts"
>    the data to the actual swap disk.  This reaper must ensure it can reclaim
>    _full_ pageframes (not just zpages) or it has little value.  Further the
>    reaper should determine which pageframes to reap based on an LRU-ish
>    (not random) approach.

This is a limitation of the design, I admit.  However, in
the case that frontswap/zcache is able to capture all pages
submitted to it and there is no overflow to the swap device,
it doesn't make a difference.

In the case that zcache is not able to allocate memory for
the persistent compressed memory pool (frontswap's pool) or
in the case the memory pool is as large as it is allowed to
be, this makes a difference, since it will overflow more
recently used pages into the swap device.

Keep in mind though that the "difference" is that frontswap
may not offer as much benefit, not that frontswap will
degrade performance relative to the case with only the swap
device.

This is a feature-add that keeps coming up so I'll add it to
the TODO.

I am interested to know from the mm maintainers, would the
absence of this feature be an obstacle for promotion or not?
 The reason I ask is it would be pretty complex and invasive
to implement.

> B) Zsmalloc has potentially far superior density vs zbud because zsmalloc can
>    pack more zpages into each pageframe and allows for zpages that cross pageframe
>    boundaries.  But, (i) this is very data dependent... the average compression
>    for LZO is about 2x.  The frontswap'ed pages in the kernel compile benchmark
>    compress to about 4x, which is impressive but probably not representative of
>    a wide range of zpages and workloads.

"the average compression for LZO is about 2x". "...probably
not representative of a wide range of zpages and workloads".
 Evidence?

>    And (ii) there are many historical
>    discussions going back to Knuth and mainframes about tight packing of data...
>    high density has some advantages but also brings many disadvantages related to
>    fragmentation and compaction.  Zbud is much less aggressive (max two zpages
>    per pageframe) but has a similar density on average data, without the
>    disadvantages of high density.

What is "average data"?  The context seems to define it in
terms of the desired outcome, i.e. 50% LZO compressibility
with little zbud fragmentation.

>    So zsmalloc may blow zbud away on a kernel compile benchmark but, if both were
>    runners, zsmalloc is a sprinter and zbud is a marathoner.  Perhaps the best
>    solution is to offer both?

Since frontswap pages are not reclaimable, density matters a
lot and reclaimability doesn't matter at all.  In what case,
would zbud work better that zsmalloc in this code?

> C) Zcache uses zbud(v1) for cleancache pages and includes a shrinker which
>    reclaims pairs of zpages to release whole pageframes, but there is
>    no attempt to shrink/reclaim cleanache pageframes in LRU order.
>    It would also be nice if single-cleancache-pageframe reclaim could
>    be implemented.

zbud does try to reclaim pages in an LRU-ish order.

There are three lists: the unused list, the unbuddied list,
and the buddied list.  The reclaim is done in density order
first (unused -> unbuddied -> buddied) to maximize the
number of compressed pages zbud can keep around.  But each
list is in LRU-ish order since new zpages are added at the
tail and reclaim starts from the head.  I say LRU-ish order
because the zpages can move between the unbuddied and
buddied lists as single buddies are added or removed which
causes them to lose their LRU order in the lists.  So it's
not purely LRU, but it's not random either.

Not sure what you mean by "single-cleancache-pageframe
reclaim".  Is that zbud_evict_pages(1)?

> D) Ramster is built on top of zcache, but required a handful of changes
>    (on the order of 100 lines).  Due to various circumstances, ramster was
>    submitted as a fork of zcache with the intent to unfork as soon as
>    possible.  The proposal to promote the older zcache perpetuates that fork,

It doesn't perpetuate the fork.  It encourages incremental
change to zcache to accommodate new features, namely
Ramster, as opposed to a unilateral rewrite of zcache.

>    requiring fixes in multiple places, whereas the new codebase supports
>    ramster and provides clearly defined boundaries between the two.
> 
> The new codebase (zcache) just submitted as part of drivers/staging/ramster
> resolves these problems (though (A) is admittedly still a work in progress).
> Before other key mm maintainers read and comment on zcache

I have no information on the acceptability of this code in
the mm community.  I'm _really_ hoping for the discussion to
expand beyond Dan and me.

> I think
> it would be most wise to move to a codebase which resolves the known design
> problems or, at least to thoroughly discuss and debunk the design issues
> described above.  OR... it may be possible to identify and pursue some
> compromise plan.

I'd be happy to discuss a compromise.  However, you
expressed that you were not willing to break down your
ramster + zcache rewrite into functionally separate patches:

https://lkml.org/lkml/2012/8/16/617

For example, I would like to measure if the changes made in
zbud improve cleancache performance, but I can't do that
because there isn't a patch(set) that makes only those changes.

Can we agree that any changes would have to be in
functionally separate patches?

> In any case, I believe the promotion proposal is premature.

This isn't a promotion patch anymore, it's an RFC.  I'm just
wanting comments on the code in order to create a TODO.

--
Seth

