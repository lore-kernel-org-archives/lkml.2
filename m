Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab1HJOAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 10:00:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:12655 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab1HJOAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 10:00:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,350,1309762800"; 
   d="scan'208";a="37064192"
Date: Wed, 10 Aug 2011 22:00:02 +0800
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
Message-ID: <20110810140002.GA29724@localhost>
References: <20110806084447.388624428@intel.com>
 <20110806094526.878435971@intel.com>
 <20110809155046.GD6482@redhat.com>
 <1312906591.1083.43.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312906591.1083.43.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 12:16:30AM +0800, Peter Zijlstra wrote:
> On Tue, 2011-08-09 at 11:50 -0400, Vivek Goyal wrote:
> > 
> > So IIUC, bdi->dirty_ratelimit is the dynmically adjusted desired rate
> > limit (based on postion ratio, dirty_bw and write_bw). But this seems
> > to be overall bdi limit and does not seem to take into account the
> > number of tasks doing IO to that bdi (as your comment suggests).
> > So it probably will track write_bw as opposed to write_bw/N. What
> > am I missing? 

In normal situation (near the setpoints),

   task_ratelimit ~= bdi->dirty_ratelimit ~= write_bw / N

Yes, dirty_ratelimit is a per-bdi variable, because all tasks share
roughly the same dirty ratelimit for the obvious reason of fairness.
 
> I think the per task thing comes from him using the pages_dirtied
> argument to balance_dirty_pages() to compute the sleep time.

Yeah. Ultimately it will allow different tasks to be throttled at
different (user specified) rates.

> Although I'm not quite sure how he keeps fairness in light of the
> sleep time bounding to MAX_PAUSE.

Firstly, MAX_PAUSE will only be applied when the dirty pages rush
high (dirty exceeded).  Secondly, the dirty exceeded state is global
to all tasks, in which case each task will sleep for MAX_PAUSE equally.
So the fairness is still maintained in dirty exceeded state.

Thanks,
Fengguang
