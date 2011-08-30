Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab1H3WhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 18:37:20 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:4749 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752618Ab1H3WhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 18:37:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhoDACNjXU55LIxDgWdsb2JhbABCqEIVAQEWJiWBQAEBBAEnExwjBQsIAw4KLhQlAyETh3K4Hw6GRgSkPA
Date: Wed, 31 Aug 2011 08:37:11 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Dave Chinner <dchinner@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] shrinker: fix a bug when callback returns -1
Message-ID: <20110830223711.GU3162@dastard>
References: <Pine.LNX.4.64.1108291534140.19003@hs20-bc2-1.build.redhat.com>
 <20110830021333.GL3162@dastard>
 <Pine.LNX.4.64.1108301511110.9551@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1108301511110.9551@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 03:52:02PM -0400, Mikulas Patocka wrote:
> On Tue, 30 Aug 2011, Dave Chinner wrote:
> 
> > On Mon, Aug 29, 2011 at 03:36:48PM -0400, Mikulas Patocka wrote:
> > > Hi
> > > 
> > > This patch fixes a lockup when shrinker callback returns -1.
> > 
> > What lockup is that? I haven't seen any bug reports, and this code
> > has been like this for several years, so I'm kind of wondering why
> > this is suddenly an issue....
> 
> I got the lockups when modifying my own dm-bufio code to use the shrinker. 
> The reason for lockups was that the variable total_scan contained 
> extremely high values.

Your new shrinker was returning -1 when nr_to_scan == 0? That's not
correct - you should be returning the count of objects (regardless
of the specified gfp_mask) or 0 if you can't get one for whatever
reason....

> The only possible way how such extreme values could be stored in 
> total_scan was this:
> 
> max_pass = do_shrinker_shrink(shrinker, shrink, 0);
> delta = (4 * nr_pages_scanned) / shrinker->seeks;
> delta *= max_pass;
> do_div(delta, lru_pages + 1);
> total_scan += delta;
> 
> --- you don't test if do_shinker_shrink retuned -1 here. The variables are 
> unsigned long, so you end up adding extreme value (approximately 
> 2^64/(lru_pages+1) to total_scan.

That's not the only way to get large values in total scan. If
you do any amount of GFP_NOFS/GFP_NOIO allocation and the shrinker
aborts when it sees this, the shrinker->nr total will aggregate
until it becomes large. total_scan contains that aggregation because
it starts from the current value of shrinker->nr.

> Note that some existing shrinkers contain workaround for this (something 
> like "return nr_to_scan ? -1 : 0",

That's not a workaround - that is exactly how the current API
expects them to operate. That is, when counting objects, you return
the count of objects. If you can't get the count, you return 0.

Did I mention I was rewriting the API to make it more sane, obvious
and simple to implement correctly?

> while some can still return -1 when 
> nr_to_scan is 0 and trigger this bug (prune_super).

prune_super() will only return -1 if grab_super_passive() fails,
which indicates that something serious is happening on the
superblock (like unmount, remount or freeze) in which case the
caches are about to or already undergoing significant change anyway.
It could be seen as a bug, but it's really a "don't care" case - it
doesn't matter what the calculated value is because it doesn't
matter what the shrinker does after such a failure - the next call
is going to fail to grab the superblock, too.

And FWIW, that wart also goes away with the shrinker API rework.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
