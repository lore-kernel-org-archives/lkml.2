Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab0HTO3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 10:29:20 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:53562 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752180Ab0HTO3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 10:29:17 -0400
Date: Sat, 21 Aug 2010 00:29:06 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        npiggin@kernel.dk
Subject: Re: [PATCH 0/2] radix-tree: fix writeback livelock avoidance code
Message-ID: <20100820142906.GD31488@dastard>
References: <1282281727-15088-1-git-send-email-david@fromorbit.com>
 <20100820135141.GC5716@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100820135141.GC5716@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 03:51:41PM +0200, Jan Kara wrote:
> On Fri 20-08-10 15:22:05, Dave Chinner wrote:
> > The following two patches fix bugs in the new radix tree functionality used to
> > implement the writeback livelock avoidance code. Both bugs manifest themselves
> > as stray PAGECACHE_TAG_TOWRITE tags in the mapping->page_tree radix tree
> > resulting in livelocks during tag lookups. More subtly, they also appear to
> > result in writeback tree walks occasionally terminating early and so not
> > actually writing all the pages they are supposed to.
>   Really, how that early termination could happen? I'm just wondering
> because I don't see that.. The code just mindlessly copies tags regardless
> of how target flags are set so that's why I'd think that any stale copied
> flags just don't matter...

With the debug I had in pace, I saw a couple of find_get_pages_tag
loops stop (nr_found == 0) rather than livelock when they
encountered a stray tag, which appears to result in writeback not
writing all the pages. I also saw invalidation removing pages from
the page cache that had the PAGECACHE_TAG_TOWRITE tag set, which
indicated that sometimes they weren't getting written back as they
should have been. These were quite rare - they maybe occurred once
for every 1000 livelock occurrences I saw....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
