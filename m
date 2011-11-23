Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab1KWMrz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 07:47:55 -0500
Received: from mga14.intel.com ([143.182.124.37]:47502 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766Ab1KWMrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 07:47:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,559,1315206000"; 
   d="scan'208";a="78361239"
Date: Wed, 23 Nov 2011 20:47:45 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/8] readahead: replace ra->mmap_miss with ra->ra_flags
Message-ID: <20111123124745.GB7174@localhost>
References: <20111121091819.394895091@intel.com>
 <20111121093846.378529145@intel.com>
 <20111121150116.094cf194.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121150116.094cf194.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 03:01:16PM -0800, Andrew Morton wrote:
> On Mon, 21 Nov 2011 17:18:22 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > Introduce a readahead flags field and embed the existing mmap_miss in it
> > (mainly to save space).
> 
> What an ugly patch.

Indeed..

> > It will be possible to lose the flags in race conditions, however the
> > impact should be limited.  For the race to happen, there must be two
> > threads sharing the same file descriptor to be in page fault or
> > readahead at the same time.
> > 
> > Note that it has always been racy for "page faults" at the same time.
> > 
> > And if ever the race happen, we'll lose one mmap_miss++ or mmap_miss--.
> > Which may change some concrete readahead behavior, but won't really
> > impact overall I/O performance.
> > 
> > CC: Andi Kleen <andi@firstfloor.org>
> > CC: Steven Whitehouse <swhiteho@redhat.com>
> > Acked-by: Rik van Riel <riel@redhat.com>
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > ---
> >  include/linux/fs.h |   31 ++++++++++++++++++++++++++++++-
> >  mm/filemap.c       |    9 ++-------
> >  2 files changed, 32 insertions(+), 8 deletions(-)
> > 
> > --- linux-next.orig/include/linux/fs.h	2011-11-20 11:30:55.000000000 +0800
> > +++ linux-next/include/linux/fs.h	2011-11-20 11:48:53.000000000 +0800
> > @@ -945,10 +945,39 @@ struct file_ra_state {
> >  					   there are only # of pages ahead */
> >  
> >  	unsigned int ra_pages;		/* Maximum readahead window */
> > -	unsigned int mmap_miss;		/* Cache miss stat for mmap accesses */
> > +	unsigned int ra_flags;
> 
> And it doesn't actually save any space, unless ra_flags gets used for
> something else in a subsequent patch.  And if it does, perhaps ra_flags

Because it's a preparation patch. There will be more fields defined later.

> should be ulong, which is compatible with the bitops.h code.
> Or perhaps we should use a bitfield and let the compiler do the work.

What if we do

        u16     mmap_miss;
        u16     ra_flags;

That would get rid of this patch. I'd still like to pack the various
flags as well as pattern into one single ra_flags, which makes it
convenient to pass things around (as one single parameter).

> >  	loff_t prev_pos;		/* Cache last read() position */
> >  };
> >  
> > +/* ra_flags bits */
> > +#define	READAHEAD_MMAP_MISS	0x000003ff /* cache misses for mmap access */
> > +
> > +/*
> > + * Don't do ra_flags++ directly to avoid possible overflow:
> > + * the ra fields can be accessed concurrently in a racy way.
> > + */
> > +static inline unsigned int ra_mmap_miss_inc(struct file_ra_state *ra)
> > +{
> > +	unsigned int miss = ra->ra_flags & READAHEAD_MMAP_MISS;
> > +
> > +	/* the upper bound avoids banging the cache line unnecessarily */
> > +	if (miss < READAHEAD_MMAP_MISS) {
> > +		miss++;
> > +		ra->ra_flags = miss | (ra->ra_flags & ~READAHEAD_MMAP_MISS);
> > +	}
> > +	return miss;
> > +}
> > +
> > +static inline void ra_mmap_miss_dec(struct file_ra_state *ra)
> > +{
> > +	unsigned int miss = ra->ra_flags & READAHEAD_MMAP_MISS;
> > +
> > +	if (miss) {
> > +		miss--;
> > +		ra->ra_flags = miss | (ra->ra_flags & ~READAHEAD_MMAP_MISS);
> > +	}
> > +}
> 
> It's strange that ra_mmap_miss_inc() returns the new value whereas
> ra_mmap_miss_dec() returns void.

Simply because no one need to check the return value of ra_mmap_miss_dec()...
But yeah it's good to make them look symmetry.

Thanks,
Fengguang
