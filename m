Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab0GZMj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 08:39:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:12461 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658Ab0GZMj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 08:39:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,261,1278313200"; 
   d="scan'208";a="589720006"
Date: Mon, 26 Jul 2010 20:39:37 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Mel Gorman <mel@csn.ul.ie>,
        Chris Mason <chris.mason@oracle.com>,
        Jens Axboe <jens.axboe@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 5/6] writeback: try more writeback as long as something
 was written
Message-ID: <20100726123937.GB11947@localhost>
References: <20100722050928.653312535@intel.com>
 <20100722061823.050523298@intel.com>
 <20100723173953.GB20540@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100723173953.GB20540@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 24, 2010 at 01:39:54AM +0800, Jan Kara wrote:
> On Thu 22-07-10 13:09:33, Wu Fengguang wrote:
> > writeback_inodes_wb()/__writeback_inodes_sb() are not agressive in that
> > they only populate b_io when necessary at entrance time. When the queued
> > set of inodes are all synced, they just return, possibly with
> > wbc.nr_to_write > 0.
> > 
> > For kupdate and background writeback, there may be more eligible inodes
> > sitting in b_dirty when the current set of b_io inodes are completed. So
> > it is necessary to try another round of writeback as long as we made some
> > progress in this round. When there are no more eligible inodes, no more
> > inodes will be enqueued in queue_io(), hence nothing could/will be
> > synced and we may safely bail.
> > 
> > This will livelock sync when there are heavy dirtiers. However in that case
> > sync will already be livelocked w/o this patch, as the current livelock
> > avoidance code is virtually a no-op (for one thing, wb_time should be
> > set statically at sync start time and be used in move_expired_inodes()).
> > The sync livelock problem will be addressed in other patches.
>   Hmm, any reason why you don't solve this problem by just removing the
> condition before queue_io()? It would also make the logic simpler - always

Yeah I'll remove queue_io() in the coming sync livelock patchset.
This patchset does the below. Though awkward, it avoids unnecessary
behavior changes for non-background cases.

-       if (!wbc->for_kupdate || list_empty(&wb->b_io))
+       if (!(wbc->for_kupdate || wbc->for_background) || list_empty(&wb->b_io))
                queue_io(wb, wbc);


> queue all inodes that are eligible for writeback...

Thanks,
Fengguang
