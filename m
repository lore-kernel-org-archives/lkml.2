Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255Ab1HGGTp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 02:19:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:19144 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063Ab1HGGTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 02:19:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,332,1309762800"; 
   d="scan'208";a="35911117"
Date: Sun, 7 Aug 2011 14:19:31 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrea Righi <arighi@develer.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] writeback: per task dirty rate limit
Message-ID: <20110807061931.GA3287@localhost>
References: <20110806084447.388624428@intel.com>
 <20110806094527.002914580@intel.com>
 <20110806143531.GA1512@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110806143531.GA1512@thinkpad>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 06, 2011 at 10:35:31PM +0800, Andrea Righi wrote:
> On Sat, Aug 06, 2011 at 04:44:51PM +0800, Wu Fengguang wrote:
> > Add two fields to task_struct.
> > 
> > 1) account dirtied pages in the individual tasks, for accuracy
> > 2) per-task balance_dirty_pages() call intervals, for flexibility
> > 
> > The balance_dirty_pages() call interval (ie. nr_dirtied_pause) will
> > scale near-sqrt to the safety gap between dirty pages and threshold.
> > 
> > XXX: The main problem of per-task nr_dirtied is, if 10k tasks start
> > dirtying pages at exactly the same time, each task will be assigned a
> > large initial nr_dirtied_pause, so that the dirty threshold will be
> > exceeded long before each task reached its nr_dirtied_pause and hence
> > call balance_dirty_pages().
> > 
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> 
> A minor nitpick below.
> 
> Reviewed-by: Andrea Righi <andrea@betterlinux.com>

Thank you.

> > +/*
> >   * balance_dirty_pages() must be called by processes which are generating dirty
> >   * data.  It looks at the number of dirty pages in the machine and will force
> >   * the caller to perform writeback if the system is over `vm_dirty_ratio'.
> 
> I think we should also fix the comment of balance_dirty_pages(), now
> that it's IO-less for the caller. Maybe something like:
> 
> /*
>  * balance_dirty_pages() must be called by processes which are generating dirty
>  * data.  It looks at the number of dirty pages in the machine and will force
>  * the caller to wait once crossing the dirty threshold. If we're over
>  * `background_thresh' then the writeback threads are woken to perform some
>  * writeout.
>  */

Good catch! I'll add this change to the next patch:

 /*
  * balance_dirty_pages() must be called by processes which are generating dirty
  * data.  It looks at the number of dirty pages in the machine and will force
- * the caller to perform writeback if the system is over `vm_dirty_ratio'.
+ * the caller to wait once crossing the (background_thresh + dirty_thresh) / 2.
  * If we're over `background_thresh' then the writeback threads are woken to
  * perform some writeout.
  */

Thanks,
Fengguang
