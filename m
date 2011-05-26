Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587Ab1EZXKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 19:10:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:55670 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820Ab1EZXKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 19:10:48 -0400
Date: Fri, 27 May 2011 01:10:45 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/18] writeback: sync expired inodes first in
 background writeback
Message-ID: <20110526231045.GN5123@quack.suse.cz>
References: <20110524051411.924582719@intel.com>
 <20110524051858.972440561@intel.com>
 <20110524155205.GC5390@quack.suse.cz>
 <20110525143857.GA25536@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110525143857.GA25536@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 25-05-11 22:38:57, Wu Fengguang wrote:
> > and I was wondering: Assume there is one continuously redirtied file and
> > untar starts in parallel. With the new logic, background writeback will
> > never consider inodes that are not expired in this situation (we never
> > switch to "all dirty inodes" phase - or even if we switched, we would just
> > queue all inodes and then return back to queueing only expired inodes). So
> > the net effect is that for 30 seconds we will be only continuously writing
> > pages of the continuously dirtied file instead of (possibly older) pages of
> > other files that are written. Is this really desirable? Wasn't the old
> > behavior simpler and not worse than the new one?
> 
> Good question! Yes sadly in this case the new behavior could be worse
> than the old one.
> 
> In fact this patch do not improve the small files (< 4MB) case at all,
> except for the side effect that less unexpired inodes will leave in
> s_io when the background work quit and the later kupdate work will
> write less unexpired inodes.
> 
> And for the mixed small/large files case, it actually results in worse
> behavior on your mentioned case.
> 
> However the root cause here is the file being _actively_ written to,
> somehow a livelock scheme. We could add a simple livelock prevention
> scheme that works for the common case of file appending:
> 
> - save i_size when the range_cyclic writeback starts from 0, for
>   limiting the writeback scope
  Hmm, but for this we'd have to store additional 'unsigned long' (page
index) for each inode. Not sure if it's really worth it.

> - when range_cyclic writeback hits the saved i_size, quit the current
>   inode instead of immediately restarting from 0. This will not only
>   avoid a possible extra seek, but also redirty_tail() the inode and
>   hence get out of possible livelock.
  But I like the idea of doing redirty_tail() when we write out some inode
for too long. Maybe we could just do redirty_tail() instead of requeue_io()
whenever write_cache_pages() had to wrap the index? We could communicate
this by setting a flag in wbc in write_cache_pages()...

> The livelock prevention scheme may not only eliminate the undesirable
> behavior you observed for this patch, but also prevent the "some old
> pages may not get the chance to get written to disk in an actively
> dirtied file" data security issue discussed in an old email. What do
> you think?
  So my scheme would not solve this but it does not require per-inode
overhead...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
