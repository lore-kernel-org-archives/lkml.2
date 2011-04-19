Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab1DSJ6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 05:58:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:34528 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803Ab1DSJ6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 05:58:43 -0400
Date: Tue, 19 Apr 2011 11:57:40 +0200
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mel@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH 3/6] writeback: sync expired inodes first in background
 writeback
Message-ID: <20110419095740.GC5257@quack.suse.cz>
References: <20110419030003.108796967@intel.com>
 <20110419030532.515923886@intel.com>
 <20110419073523.GF23985@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110419073523.GF23985@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 19-04-11 17:35:23, Dave Chinner wrote:
> On Tue, Apr 19, 2011 at 11:00:06AM +0800, Wu Fengguang wrote:
> > A background flush work may run for ever. So it's reasonable for it to
> > mimic the kupdate behavior of syncing old/expired inodes first.
> > 
> > The policy is
> > - enqueue all newly expired inodes at each queue_io() time
> > - enqueue all dirty inodes if there are no more expired inodes to sync
> > 
> > This will help reduce the number of dirty pages encountered by page
> > reclaim, eg. the pageout() calls. Normally older inodes contain older
> > dirty pages, which are more close to the end of the LRU lists. So
> > syncing older inodes first helps reducing the dirty pages reached by
> > the page reclaim code.
> 
> Once again I think this is the wrong place to be changing writeback
> policy decisions. for_background writeback only goes through
> wb_writeback() and writeback_inodes_wb() (same as for_kupdate
> writeback), so a decision to change from expired inodes to fresh
> inodes, IMO, should be made in wb_writeback.
> 
> That is, for_background and for_kupdate writeback start with the
> same policy (older_than_this set) to writeback expired inodes first,
> then when background writeback runs out of expired inodes, it should
> switch to all remaining inodes by clearing older_than_this instead
> of refreshing it for the next loop.
  Yes, I agree with this and my impression is that Fengguang is trying to
achieve exactly this behavior.

> This keeps all the policy decisions in the one place, all using the
> same (existing) mechanism, and all relatively simple to understand,
> and easy to tracepoint for debugging.  Changing writeback policy
> deep in the writeback stack is not a good idea as it will make
> extending writeback policies in future (e.g. for cgroup awareness)
> very messy.
  Hmm, I see. I agree the policy decisions should be at one place if
reasonably possible. Fengguang moves them from wb_writeback() to inode
queueing code which looks like a logical place to me as well - there we
have the largest control over what inodes do we decide to write and don't
have to pass all the detailed 'instructions' down in wbc structure. So if
we later want to add cgroup awareness to writeback, I imagine we just add
the knowledge to inode queueing code.

> > @@ -585,7 +597,8 @@ void writeback_inodes_wb(struct bdi_writ
> >  	if (!wbc->wb_start)
> >  		wbc->wb_start = jiffies; /* livelock avoidance */
> >  	spin_lock(&inode_wb_list_lock);
> > -	if (!wbc->for_kupdate || list_empty(&wb->b_io))
> > +
> > +	if (list_empty(&wb->b_io))
> >  		queue_io(wb, wbc);
> >  
> >  	while (!list_empty(&wb->b_io)) {
> > @@ -612,7 +625,7 @@ static void __writeback_inodes_sb(struct
> >  	WARN_ON(!rwsem_is_locked(&sb->s_umount));
> >  
> >  	spin_lock(&inode_wb_list_lock);
> > -	if (!wbc->for_kupdate || list_empty(&wb->b_io))
> > +	if (list_empty(&wb->b_io))
> >  		queue_io(wb, wbc);
> >  	writeback_sb_inodes(sb, wb, wbc, true);
> >  	spin_unlock(&inode_wb_list_lock);
> 
> That changes the order in which we queue inodes for writeback.
> Instead of calling every time to move b_more_io inodes onto the b_io
> list and expiring more aged inodes, we only ever do it when the list
> is empty. That is, it seems to me that this will tend to give
> b_more_io inodes a smaller share of writeback because they are being
> moved back to the b_io list less frequently where there are lots of
> other inodes being dirtied. Have you tested the impact of this
> change on mixed workload performance? Indeed, can you starve
> writeback of a large file simply by creating lots of small files in
> another thread?
  Yeah, this change looks suspicious to me as well.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
