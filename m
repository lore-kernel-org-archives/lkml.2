Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab0JODo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 23:44:57 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:20006 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755950Ab0JODoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 23:44:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAOhqt0x5Ld+3/2dsb2JhbAChIXK/cIVIBI9F
Date: Fri, 15 Oct 2010 14:44:51 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
Message-ID: <20101015034451.GA6827@amd>
References: <1286515292-15882-18-git-send-email-david@fromorbit.com>
 <20101013072058.GA3121@amd>
 <20101013112552.GB16422@infradead.org>
 <20101013123008.GA6067@amd>
 <20101013232319.GZ4681@dastard>
 <20101014090609.GB3144@amd>
 <20101014144159.GA11972@infradead.org>
 <20101015001443.GA3146@amd>
 <20101015031343.GG4681@dastard>
 <20101015033017.GA6750@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101015033017.GA6750@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 02:30:17PM +1100, Nick Piggin wrote:
> On Fri, Oct 15, 2010 at 02:13:43PM +1100, Dave Chinner wrote:
> >  You've shown it can be done, and that's great - it shows
> > us the impact of making those changes, but they need to be analysed
> > separately and treated on own their merits, not lumped with core
> > locking changes necessary for store-free path walking.
> 
> Actually I didn't see anyone else object to doing this. Everybody
> else it seems acknowledges that it needs to be done, and it gets
> done naturally as a side effect of fine grained locking.

Let's just get back to this part, which seems to be one you have
the most issues with maybe?

You're objecting to per-zone locks and per-zone LRUs for inode and
dcache?

Well I have told you why per-zone LRUs are needed, I can expand on
any of the reasons if that is unclear. Per-zone locks I think come
naturally at the same time and they will expose some fs bottlenecks,
but that is simply how scalability development works.

So, do you object to per-zone LRUs in particular, or per-zone locks?
(Ie. the potentially changed reclaim pattern, or the increased
parallelism).

When you looked at this initially, you didn't understand how
reclaim works. It will not fill up a zone with inodes and then start
reclaiming all those inodes, leaving other nodes empty (unless that
is how you configure the machine, but it isn't the default). It
fills up inodes from all nodes (same as today) and it will start
reclaiming from all nodes at about the same pressure when there is
a shortage.

Reclaim basically approximates LRU by scanning a little from the top
of each LRU. When you have many thousands of objects, and reclaim is
a really failable and dumb process anyway, then the perturbation of
the reclaim pattern doesn't matter much. Our zone based page reclaim
works exactly the same way.

I don't think you can possibly be arguing against more scalable
locking in reclaim, so perhaps you are also worried about increased
parallelism in the filesystem callbacks from reclaim? I really can't
see this being a big problem, any more than any other increased
paralellism on fses or other subsystems caused by scaling vfs.

There might be some interesting issues with different locking
designs being hit in different ways, but really we can't stop
progress and test all loads on all filesystems. The way forward is
to fix the bottleneck in the filesystem, or the filesystem sucks
so bad it can't handle it, then just put a lock in there and not
peanalise others.

It's not like I haven't tested it, I've spent the better part of
the past year testing things. The I_FREEING batching stuff is one
example where I found and fixed a small problem exposed by the
reclaim changes.


