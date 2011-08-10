Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab1HJOHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 10:07:23 -0400
Received: from mga14.intel.com ([143.182.124.37]:41860 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902Ab1HJOHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 10:07:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,350,1309762800"; 
   d="scan'208";a="37067172"
Date: Wed, 10 Aug 2011 22:07:14 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] writeback: dirty rate control
Message-ID: <20110810140714.GB29724@localhost>
References: <20110806084447.388624428@intel.com>
 <20110806094526.878435971@intel.com>
 <20110809155046.GD6482@redhat.com>
 <1312906591.1083.43.camel@twins>
 <1312906772.1083.45.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312906772.1083.45.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 12:19:32AM +0800, Peter Zijlstra wrote:
> On Tue, 2011-08-09 at 18:16 +0200, Peter Zijlstra wrote:
> > On Tue, 2011-08-09 at 11:50 -0400, Vivek Goyal wrote:
> > > 
> > > So IIUC, bdi->dirty_ratelimit is the dynmically adjusted desired rate
> > > limit (based on postion ratio, dirty_bw and write_bw). But this seems
> > > to be overall bdi limit and does not seem to take into account the
> > > number of tasks doing IO to that bdi (as your comment suggests). So
> > > it probably will track write_bw as opposed to write_bw/N. What am
> > > I missing? 
> > 
> > I think the per task thing comes from him using the pages_dirtied
> > argument to balance_dirty_pages() to compute the sleep time. Although
> > I'm not quite sure how he keeps fairness in light of the sleep time
> > bounding to MAX_PAUSE.
> 
> Furthermore, there's of course the issue that current->nr_dirtied is
> computed over all BDIs it dirtied pages from, and the sleep time is
> computed for the BDI it happened to do the overflowing write on.
> 
> Assuming an task (mostly) writes to a single bdi, or equally to all, it
> should all work out.

Right. That's one pitfall I forgot to mention, sorry.

If _really_ necessary, the above imperfection can be avoided by adding
tsk->last_dirty_bdi and tsk->to_pause, and to do so when switching to
another bdi:

        to_pause += nr_dirtied / task_ratelimit
        if (to_pause > reasonable_large_pause_time) {
                sleep(to_pause)
                to_pause = 0
        }
        nr_dirtied  = 0

Thanks,
Fengguang
