Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759158Ab1CDH6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 02:58:44 -0500
Received: from mga03.intel.com ([143.182.124.21]:29613 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998Ab1CDH6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 02:58:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,263,1297065600"; 
   d="scan'208";a="397452567"
Date: Fri, 4 Mar 2011 15:57:38 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/27] btrfs: lower the dirty balance poll interval
Message-ID: <20110304075738.GA30166@localhost>
References: <20110303064505.718671603@intel.com>
 <20110303074949.419321686@intel.com>
 <20110304062217.GE25368@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304062217.GE25368@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 02:22:17PM +0800, Dave Chinner wrote:
> On Thu, Mar 03, 2011 at 02:45:11PM +0800, Wu Fengguang wrote:
> > Call balance_dirty_pages_ratelimit_nr() on every 32 pages dirtied.
> > 
> > Tests show that original larger intervals can easily make the bdi
> > dirty limit exceeded on 100 concurrent dd.
> > 
> > CC: Chris Mason <chris.mason@oracle.com>
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > ---
> >  fs/btrfs/file.c |    5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > --- linux-next.orig/fs/btrfs/file.c	2011-03-02 20:15:19.000000000 +0800
> > +++ linux-next/fs/btrfs/file.c	2011-03-02 20:35:07.000000000 +0800
> > @@ -949,9 +949,8 @@ static ssize_t btrfs_file_aio_write(stru
> >  	}
> >  
> >  	iov_iter_init(&i, iov, nr_segs, count, num_written);
> > -	nrptrs = min((iov_iter_count(&i) + PAGE_CACHE_SIZE - 1) /
> > -		     PAGE_CACHE_SIZE, PAGE_CACHE_SIZE /
> > -		     (sizeof(struct page *)));
> > +	nrptrs = min(DIV_ROUND_UP(iov_iter_count(&i), PAGE_CACHE_SIZE),
> > +		     min(32UL, PAGE_CACHE_SIZE / sizeof(struct page *)));
> 
> You're basically hardcoding the maximum to 32 pages here, because
> PAGE_CACHE_SIZE / sizeof(page *) is always going to be much larger
> than 32.
> 
> This means that you are effectively neutering the large write
> efficiencies of btrfs - you're reducing the delayed allocation sizes
> from 512 * PAGE_CACHE_SIZE down to 32 * PAGE_CACHE_SIZE. This will
> increase the overhead of the write process for btrfs for large IOs.
> 
> Also, I've got some multipage write modifications that allow 1024
> pages at a time between mapping/allocation calls with XFS - once
> again for improving the efficiencies of the extent
> mapping/allocations in the write path. If the new writeback
> throttling algorithms don't work with large numbers of pages being
> copied in a single go, then that's a problem.
> 
> As it is, if 100 concurrent dd's can overrun the dirty limit w/ 512
> pages at a time, then 1000 concurrent dd's w/ 32 pages at a time is
> just as likely to overrun it, too. We support 4096 CPU systems, so a
> few thousand concurrent writers is not out of the question. Hence I
> don't think just reducing the number of pages between dirty balance
> calls is a sufficient solution....

Yes I probably have been too nervous about temporary dirty exceeding.

I do keep an improvement patch in house. However it adds btrfs
dependency on VFS, it could be submitted to btrfs after the VFS
changes have been merged. As the 32-page limit will hurt normal
workload, I'll drop it and merge it with the below one.

Thanks,
Fengguang
---

--- linux-next.orig/fs/btrfs/file.c	2011-03-02 20:35:54.000000000 +0800
+++ linux-next/fs/btrfs/file.c	2011-03-02 20:34:07.000000000 +0800
@@ -950,7 +950,8 @@ static ssize_t btrfs_file_aio_write(stru
 
 	iov_iter_init(&i, iov, nr_segs, count, num_written);
 	nrptrs = min(DIV_ROUND_UP(iov_iter_count(&i), PAGE_CACHE_SIZE),
-		     min(32UL, PAGE_CACHE_SIZE / sizeof(struct page *)));
+		     min(PAGE_CACHE_SIZE / sizeof(struct page *),
+			 current->nr_dirtied_pause));
 	pages = kmalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
 	if (!pages) {
 		ret = -ENOMEM;
