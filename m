Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab3ACWiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 17:38:24 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21576 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab3ACWiS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 17:38:18 -0500
MIME-Version: 1.0
Message-ID: <ac37f7ce-b15a-40f8-9da7-858dea3651b9@default>
Date: Thu, 3 Jan 2013 14:37:01 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: RE: [PATCH 7/8] zswap: add to mm/
References: <1355262966-15281-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1355262966-15281-8-git-send-email-sjenning@linux.vnet.ibm.com>
 <0e91c1e5-7a62-4b89-9473-09fff384a334@default>
 <50E32255.60901@linux.vnet.ibm.com> <50E4588E.6080001@linux.vnet.ibm.com>
 <28a63847-7659-44c4-9c33-87f5d50b2ea0@default>
 <50E479AD.9030502@linux.vnet.ibm.com>
 <9955b9e0-731b-4cbf-9db0-683fcd32f944@default>
 <20130103073339.GF3120@dastard>
In-Reply-To: <20130103073339.GF3120@dastard>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Dave Chinner [mailto:david@fromorbit.com]
> Subject: Re: [PATCH 7/8] zswap: add to mm/
> 
> <much useful info from Dave deleted>

OK, I have suitably proven how little I know about slab
and have received some needed education from your
response... Thanks for that Dave.

So let me ask some questions instead of making
stupid assumptions.

> Thinking that there is a fixed amount of memory that you should
> reserve for some subsystem is simply the wrong approach to take.
> caches are dynamic and the correct system balance should result of
> the natural behaviour of the reclaim algorithms.
>
> The shrinker infrastructure doesn't set any set size goals - it
> simply tries to balance the reclaim across all the shrinkers and
> relative to the page cache... 

First, it's important to note that zcache/zswap is not
really a subsystem.  It's simply a way of increasing
the number of anonymous pages (zswap and zcache) and
pagecache pages (zcache only) in RAM by using compression.
Because compressed pages can't be byte-addressed directly,
pages enter zcache/zswap through a "transformation"
process I've likened to a Fourier transform:  In
their compressed state, they must be managed differently
than normal whole pages.  Compressed anonymous pages must
transition back to uncompressed before they can be used.
Compressed pagecache pages (zcache only) can be either
uncompressed when needed or gratuitously discarded (eventually)
when not needed.

So I've been proceeding with the assumption that it is the
sum of wholepages used by both compressed-anonymous pages
and uncompressed-anonymous pages that must be managed/balanced,
and that this sum should be managed similarly to the non-zxxxx
case of the total number of anonymous pages in the system
(and similarly for compressed+uncompressed pagecache pages).

Are you suggesting that slab can/should be used instead?

> And so the two subsystems need different reclaim implementations.
> And, well, that's exactly what we have shrinkers for - implmenting
> subsystem specific reclaim policy. The shrinker infrastructure is
> responsible for them keeping balance between all the caches that
> have shrinkers and the size of the page cache...

Given the above, do you think either compressed-anonymous-pages or
compressed-pagecache-pages are suitable candidates for the shrinker
infrastructure?

Note that compressed anonymous pages are always dirty so
cannot be "reclaimed" as such.  But the mechanism that Seth
and I are working on causes compressed anonymous pages to
be decompressed and then sent to backing store, which does
(eventually, after I/O latency) free up pageframes.

Currently zcache does use the shrinker API for reclaiming
pageframes-used-for-compressed-pagecache-pages.  Since
these _are_ a form of pagecache pages, is the shrinker suitable?
 
> There are also cases where we've moved metadata caches out of the
> page cache into shrinker controlled caches because the page cache
> reclaim is too simplistic to handle the complex relationships
> between filesystem metadata. We've done this in XFS, and IIRC btrfs
> did this recently as well...

So although the objects in zswap/zcache are less than one page,
they are still "data" not "metadata", true?  In your opinion,
then, should they be managed by core MM, or by shrinker-controlled
caches, by some combination, or independently of either?

> > In any case, I would posit that both the nature of zpages and their
> > average size relative to a whole page is quite unusual compared to slab.
> 
> Doesn't sound at all unusual.

I think I've addressed the different "nature" above, so let
me ask about the size...

Can slab today suitably manage "larger" objects that exceed
half-PAGESIZE?  Or "larger" objects, such as 35%-PAGESIZE where
there would be a great deal of fragmentation?

If so, we should definitely consider slab as an alternative
for zpage allocation.

> > So while there may be some useful comparisons between zswap
> > and slab, the differences may warrant dramatically different policy.
> 
> There may be differences, but it doesn't sound like there's anything
> you can't implment with an appropriate shrinker implmentation....

Depending on your answers above, we may definitely need to
consider that as well!

Thanks,
Dan
