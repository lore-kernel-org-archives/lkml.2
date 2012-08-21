Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab2HUT2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 15:28:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456Ab2HUT2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 15:28:04 -0400
Date: Tue, 21 Aug 2012 22:28:52 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rafael Aquini <aquini@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v8 1/5] mm: introduce a common interface for balloon
 pages mobility
Message-ID: <20120821192852.GB9027@redhat.com>
References: <cover.1345519422.git.aquini@redhat.com>
 <e24f3073ef539985dea52943dcb84762213a0857.1345519422.git.aquini@redhat.com>
 <20120821135223.GA7117@redhat.com>
 <1345562166.23018.109.camel@twins>
 <20120821154142.GA8268@redhat.com>
 <20120821174251.GB12294@t510.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120821174251.GB12294@t510.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 02:42:52PM -0300, Rafael Aquini wrote:
> On Tue, Aug 21, 2012 at 06:41:42PM +0300, Michael S. Tsirkin wrote:
> > On Tue, Aug 21, 2012 at 05:16:06PM +0200, Peter Zijlstra wrote:
> > > On Tue, 2012-08-21 at 16:52 +0300, Michael S. Tsirkin wrote:
> > > > > +             rcu_read_lock();
> > > > > +             mapping = rcu_dereference(page->mapping);
> > > > > +             if (mapping_balloon(mapping))
> > > > > +                     ret = true;
> > > > > +             rcu_read_unlock();
> > > > 
> > > > This looks suspicious: you drop rcu_read_unlock
> > > > so can't page switch from balloon to non balloon? 
> > > 
> > > RCU read lock is a non-exclusive lock, it cannot avoid anything like
> > > that.
> > 
> > You are right, of course. So even keeping rcu_read_lock across both test
> > and operation won't be enough - you need to make this function return
> > the mapping and pass it to isolate_page/putback_page so that it is only
> > dereferenced once.
> >
> No, I need to dereference page->mapping to check ->mapping flags here, before
> returning. Remember this function is used at MM's compaction/migration inner
> circles to identify ballooned pages and decide what's the next step. This
> function is doing the right thing, IMHO.

Yes but the calling code is not doing the right thing.

What Peter pointed out here is that two calls to rcu dereference pointer
can return different values: rcu critical section is not a lock.
So the test for balloon page is not effective: it can change
after the fact.

To fix, get the pointer once and then pass the mapping
around.


> Also, looking at how compaction/migration work, we verify the only critical path
> for this function is the page isolation step. The other steps (migration and
> putback) perform their work on private lists previouly isolated from a given
> source.

I vaguely understand but it would be nice to document this properly.
The interaction between page->lru handling in balloon and in mm
is especially confusing.

> So, we just need to make sure that the isolation part does not screw things up
> by isolating pages that balloon driver is about to release. That's why there are
> so many checkpoints down the page isolation path assuring we really are
> isolating a balloon page. 

Well, testing same thing multiple times is just confusing.  It is very
hard to make sure there are no races with so much complexity,
and the requirements from the balloon driver are unclear to me -
it very much looks like it is poking in mm internals.

-- 
MST
