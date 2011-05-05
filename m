Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab1EENzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 09:55:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34621 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911Ab1EENzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 09:55:11 -0400
Date: Thu, 5 May 2011 15:55:08 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1/3] writeback: introduce wbc.tagged_sync for the
 WB_SYNC_NONE sync stage
Message-ID: <20110505135508.GE5323@quack.suse.cz>
References: <20110502031750.135798606@intel.com>
 <20110502033035.537736600@intel.com>
 <20110504210059.GG6968@quack.suse.cz>
 <20110505121402.GA1294@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110505121402.GA1294@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 05-05-11 20:14:02, Wu Fengguang wrote:
> On Thu, May 05, 2011 at 05:00:59AM +0800, Jan Kara wrote:
> > On Mon 02-05-11 11:17:51, Wu Fengguang wrote:
> > > sync(2) is performed in two stages: the WB_SYNC_NONE sync and the
> > > WB_SYNC_ALL sync. Tag the first stage with wbc.tagged_sync and do
> > > livelock prevention for it, too.
> > > 
> > > Note that writeback_inodes_sb() is called by not only sync(), they are
> > > treated the same because the other callers need also need livelock
> > > prevention.
> >   I was thinking about this and could not find any - which other callers
> > of writeback_inodes_sb() need the livelock prevention?
> 
> For example, the writeback_inodes_sb_if_idle() call from ext4.
> In general anyone that pass get_nr_dirty_pages() as work->nr_pages
> may be highly over-estimating the work set.
  OK, I see what you mean. I agree using tagging in these cases probably
makes sense.

> It won't be directly livelocked since ext4 won't wait for completion,
> however there is possibility the works queued behind are delayed and
> livelocked.
  Actually it will, writeback_inodes_sb() waits for completion (because of
s_umount locking). ext4 should use writeback_inodes_sb_if_idle_nr() (with
some relatively small number) anyway to avoid the pauses.

> Ideally simple ->nr_pages works should be given lower priority and
> even may be merged with each other, and that would be future work.
  Merging works wanting to do the same thing would be nice. I though about
it some time ago for a while but getting all the combinations right and
making the merging code resonably simple was hard so I postponed it for
later because it was not urgent.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
