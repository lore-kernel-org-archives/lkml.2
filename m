Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab0H2QEF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 12:04:05 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40846 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab0H2QEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 12:04:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XFC2qHbbAoPEsfsnzw7J6eE0ROW9wVyVFobfPKqZiIs1/c2+oJReGUCyvPVyqQzAgK
         llZdvgtDpIF5EqXIczU8XF+Hqb0MRrrw02lggHqTlICKnoEi3eOiT5mpfORxO+dZDrrV
         bgTLzvwy+YJoH7CAlmNzcTMDV0KuOVTI3dvYk=
Date: Mon, 30 Aug 2010 01:03:54 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] writeback: Record if the congestion was unnecessary
Message-ID: <20100829160354.GA4537@barrios-desktop>
References: <1282835656-5638-1-git-send-email-mel@csn.ul.ie>
 <1282835656-5638-3-git-send-email-mel@csn.ul.ie>
 <20100826182904.GC6805@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100826182904.GC6805@cmpxchg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Hannes. 

On Thu, Aug 26, 2010 at 08:29:04PM +0200, Johannes Weiner wrote:
> On Thu, Aug 26, 2010 at 04:14:15PM +0100, Mel Gorman wrote:
> > If congestion_wait() is called when there is no congestion, the caller
> > will wait for the full timeout. This can cause unreasonable and
> > unnecessary stalls. There are a number of potential modifications that
> > could be made to wake sleepers but this patch measures how serious the
> > problem is. It keeps count of how many congested BDIs there are. If
> > congestion_wait() is called with no BDIs congested, the tracepoint will
> > record that the wait was unnecessary.
> 
> I am not convinced that unnecessary is the right word.  On a workload
> without any IO (i.e. no congestion_wait() necessary, ever), I noticed
> the VM regressing both in time and in reclaiming the right pages when
> simply removing congestion_wait() from the direct reclaim paths (the
> one in __alloc_pages_slowpath and the other one in
> do_try_to_free_pages).

Not exactly same your experiment but I had a simillar experince. 
I had a experiement about swapout. System has lots of anon pages but
almost no file pages and it already started to swap out. It means
system have no memory. In this case, I forked new process which mmap
some MB pages and touch the pages. It means VM should swapout some MB page 
for the process. And I measured the time until completing touching the pages. 

Sometime it's fast, sometime it's slow. time gap is almost two. 
Interesting thing is when it is fast, many of pages are reclaimed by kswapd. 
Ah.. I used swap to ramdisk and reserve the swap pages by touching before 
starting the experiment. So I would say it's not a _flushd_ effect.

> 
> So just being stupid and waiting for the timeout in direct reclaim
> while kswapd can make progress seemed to do a better job for that
> load.
> 
> I can not exactly pinpoint the reason for that behaviour, it would be
> nice if somebody had an idea.

I just thought the cause is direct reclaim just reclaims by 32 pages 
but kswapd could reclaim many pages by batch. But i didn't look at it any more
due to busy. Does it make sense?

-- 
Kind regards,
Minchan Kim
