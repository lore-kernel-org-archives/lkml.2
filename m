Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab2LPDDT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 22:03:19 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:54808 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751523Ab2LPDDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 22:03:18 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak4MABA5zVB5LIoV/2dsb2JhbABFhVKyeoYGF3OCHgEBBTocIxAIAw4KFRkUJQMhE4gSuxkUjEmBDoM1A5YJkEmDBw
Date: Sun, 16 Dec 2012 14:03:02 +1100
From: Dave Chinner <david@fromorbit.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fadvise: perform WILLNEED readahead in a workqueue
Message-ID: <20121216030302.GI9806@dastard>
References: <20121215005448.GA7698@dcvr.yhbt.net>
 <20121215223448.08272fd5@pyramind.ukuu.org.uk>
 <20121216002549.GA19402@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121216002549.GA19402@dcvr.yhbt.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 12:25:49AM +0000, Eric Wong wrote:
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > On Sat, 15 Dec 2012 00:54:48 +0000
> > Eric Wong <normalperson@yhbt.net> wrote:
> > 
> > > Applications streaming large files may want to reduce disk spinups and
> > > I/O latency by performing large amounts of readahead up front
> > 
> > How does it compare benchmark wise with a user thread or using the
> > readahead() call ?
> 
> Very well.
> 
> My main concern is for the speed of the initial pread()/read() call
> after open().
> 
> Setting EARLY_EXIT means my test program _exit()s immediately after the
> first pread().  In my test program (below), I wait for the background
> thread to become ready before open() so I would not take overhead from
> pthread_create() into account.
> 
> RA=1 uses a pthread + readahead()
> Not setting RA uses fadvise (with my patch)

And if you don't use fadvise/readahead at all?

> # readahead + pthread.
> $ EARLY_EXIT=1 RA=1 time  ./first_read 1G
> 0.00user 0.05system 0:01.37elapsed 3%CPU (0avgtext+0avgdata 600maxresident)k
> 0inputs+0outputs (1major+187minor)pagefaults 0swaps
> 
> # patched fadvise
> $ EARLY_EXIT=1 time ./first_read 1G
> 0.00user 0.00system 0:00.01elapsed 0%CPU (0avgtext+0avgdata 564maxresident)k
> 0inputs+0outputs (1major+178minor)pagefaults 0swaps

You're not timing how long the first pread() takes at all. You're
timing the entire set of operations, including cloning a thread and
for the readahead(2) call and messages to be passed back and forth
through the eventfd interface to read the entire file.

Why even bother with another thread for readahead()? It implements
*exactly* the same operation as fadvise(WILL_NEED) (ie.
force_page_cache_readahead), so should perform identically when
called in exactly the same manner...

But again, you are interesting in the latency of the first read of
16k from the file, but you are asking to readahead 1GB of data.
Perhaps your shoul dbe asking for readahead of something more
appropriate to what you care about - the first read....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
