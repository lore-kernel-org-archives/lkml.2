Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab1KVNfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 08:35:32 -0500
Received: from mga14.intel.com ([143.182.124.37]:55477 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671Ab1KVNfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 08:35:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,552,1315206000"; 
   d="scan'208";a="77954506"
Date: Tue, 22 Nov 2011 21:35:24 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Hellwig <hch@lst.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] writeback: charge leaked page dirties to active
 tasks
Message-ID: <20111122133524.GA10545@localhost>
References: <20111121130342.211953629@intel.com>
 <20111121131215.772231181@intel.com>
 <20111121134929.b7008f6e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121134929.b7008f6e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 05:49:29AM +0800, Andrew Morton wrote:
> On Mon, 21 Nov 2011 21:03:44 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > It's a years long problem that a large number of short-lived dirtiers
> > (eg. gcc instances in a fast kernel build) may starve long-run dirtiers
> > (eg. dd) as well as pushing the dirty pages to the global hard limit.
> > 
> > The solution is to charge the pages dirtied by the exited gcc to the
> > other random dirtying tasks. It sounds not perfect, however should
> > behave good enough in practice, seeing as that throttled tasks aren't
> > actually running so those that are running are more likely to pick it up
> > and get throttled, therefore promoting an equal spread.
> > 
> > --- linux-next.orig/mm/page-writeback.c	2011-11-17 20:57:04.000000000 +0800
> > +++ linux-next/mm/page-writeback.c	2011-11-17 20:57:13.000000000 +0800
> > @@ -1194,6 +1194,7 @@ void set_page_dirty_balance(struct page 
> >  }
> >  
> >  static DEFINE_PER_CPU(int, bdp_ratelimits);
> > +DEFINE_PER_CPU(int, dirty_leaks) = 0;
> 
> This is a poor identifier for a global symbol.  Generally such symbols
> should at least identify what subsystem they belong to.

Yes it is, "dirty_throttle_leaks" should look better.

> Also, this would be a good site at whcih to document the global
> symbol's role.  The writeback code needs a lot of documentation. Of
> the design-level kind.

Agreed, I just added this comment:

/*
 * Normal tasks are throttled by
 *      loop {
 *              dirty tsk->nr_dirtied_pause pages;
 *              take a snap in balance_dirty_pages();
 *      }
 * However there is a worst case. If every task exit immediately when dirtied
 * (tsk->nr_dirtied_pause - 1) pages, balance_dirty_pages() will never be
 * called to throttle the page dirties. The solution is to save the not yet
 * throttled page dirties in dirty_throttle_leaks on task exit and charge them
 * randomly into the running tasks. This works well for the above worst case,
 * as the new task will pick up and accumulate the old task's leaked dirty
 * count and eventually get throttled.
 */

Thanks,
Fengguang
