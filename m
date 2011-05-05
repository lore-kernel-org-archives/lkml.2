Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab1EEMOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 08:14:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:62499 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667Ab1EEMOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 08:14:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,319,1301900400"; 
   d="scan'208";a="638436132"
Date: Thu, 5 May 2011 20:14:02 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1/3] writeback: introduce wbc.tagged_sync for the
 WB_SYNC_NONE sync stage
Message-ID: <20110505121402.GA1294@localhost>
References: <20110502031750.135798606@intel.com>
 <20110502033035.537736600@intel.com>
 <20110504210059.GG6968@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504210059.GG6968@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 05:00:59AM +0800, Jan Kara wrote:
> On Mon 02-05-11 11:17:51, Wu Fengguang wrote:
> > sync(2) is performed in two stages: the WB_SYNC_NONE sync and the
> > WB_SYNC_ALL sync. Tag the first stage with wbc.tagged_sync and do
> > livelock prevention for it, too.
> > 
> > Note that writeback_inodes_sb() is called by not only sync(), they are
> > treated the same because the other callers need also need livelock
> > prevention.
>   I was thinking about this and could not find any - which other callers
> of writeback_inodes_sb() need the livelock prevention?

For example, the writeback_inodes_sb_if_idle() call from ext4.
In general anyone that pass get_nr_dirty_pages() as work->nr_pages
may be highly over-estimating the work set.

It won't be directly livelocked since ext4 won't wait for completion,
however there is possibility the works queued behind are delayed and
livelocked.

Ideally simple ->nr_pages works should be given lower priority and
even may be merged with each other, and that would be future work.

Thanks,
Fengguang
