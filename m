Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab1EEOGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 10:06:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:24169 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287Ab1EEOGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 10:06:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,319,1301900400"; 
   d="scan'208";a="431082365"
Date: Thu, 5 May 2011 22:06:09 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1/3] writeback: introduce wbc.tagged_sync for the
 WB_SYNC_NONE sync stage
Message-ID: <20110505140609.GB9409@localhost>
References: <20110502031750.135798606@intel.com>
 <20110502033035.537736600@intel.com>
 <20110504210059.GG6968@quack.suse.cz>
 <20110505121402.GA1294@localhost>
 <20110505135508.GE5323@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110505135508.GE5323@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 09:55:08PM +0800, Jan Kara wrote:
> On Thu 05-05-11 20:14:02, Wu Fengguang wrote:
> > On Thu, May 05, 2011 at 05:00:59AM +0800, Jan Kara wrote:
> > > On Mon 02-05-11 11:17:51, Wu Fengguang wrote:
> > > > sync(2) is performed in two stages: the WB_SYNC_NONE sync and the
> > > > WB_SYNC_ALL sync. Tag the first stage with wbc.tagged_sync and do
> > > > livelock prevention for it, too.
> > > > 
> > > > Note that writeback_inodes_sb() is called by not only sync(), they are
> > > > treated the same because the other callers need also need livelock
> > > > prevention.
> > >   I was thinking about this and could not find any - which other callers
> > > of writeback_inodes_sb() need the livelock prevention?
> > 
> > For example, the writeback_inodes_sb_if_idle() call from ext4.
> > In general anyone that pass get_nr_dirty_pages() as work->nr_pages
> > may be highly over-estimating the work set.
>   OK, I see what you mean. I agree using tagging in these cases probably
> makes sense.
> 
> > It won't be directly livelocked since ext4 won't wait for completion,
> > however there is possibility the works queued behind are delayed and
> > livelocked.
>   Actually it will, writeback_inodes_sb() waits for completion (because of
> s_umount locking). ext4 should use writeback_inodes_sb_if_idle_nr() (with
> some relatively small number) anyway to avoid the pauses.

Ah yes!

> > Ideally simple ->nr_pages works should be given lower priority and
> > even may be merged with each other, and that would be future work.
>   Merging works wanting to do the same thing would be nice. I though about
> it some time ago for a while but getting all the combinations right and
> making the merging code resonably simple was hard so I postponed it for
> later because it was not urgent.

Agreed.

Thanks,
Fengguang
