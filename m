Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab0INIeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 04:34:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:25106 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab0INId5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 04:33:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,363,1280732400"; 
   d="scan'208";a="606709607"
Date: Tue, 14 Sep 2010 16:33:38 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Neil Brown <neilb@suse.de>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
        Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@lst.de>,
        "Li, Shaohua" <shaohua.li@intel.com>
Subject: Re: [PATCH 05/17] writeback: quit throttling when signal pending
Message-ID: <20100914083338.GA20295@localhost>
References: <20100913132116.3917e5d5@notabene>
 <20100913034808.GA9196@localhost>
 <20100914172028.C9B2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100914172028.C9B2.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 04:23:56PM +0800, KOSAKI Motohiro wrote:
> > Subject: writeback: quit throttling when fatal signal pending
> > From: Wu Fengguang <fengguang.wu@intel.com>
> > Date: Wed Sep 08 17:40:22 CST 2010
> > 
> > This allows quick response to Ctrl-C etc. for impatient users.
> > 
> > It mainly helps the rare bdi/global dirty exceeded cases.
> > In the normal case of not exceeded, it will quit the loop anyway. 
> > 
> > CC: Neil Brown <neilb@suse.de>
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > ---
> >  mm/page-writeback.c |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > --- linux-next.orig/mm/page-writeback.c	2010-09-12 13:25:23.000000000 +0800
> > +++ linux-next/mm/page-writeback.c	2010-09-13 11:39:33.000000000 +0800
> > @@ -552,6 +552,9 @@ static void balance_dirty_pages(struct a
> >  		__set_current_state(TASK_INTERRUPTIBLE);
> >  		io_schedule_timeout(pause);
> >  
> > +		if (fatal_signal_pending(current))
> > +			break;
> > +
> >  check_exceeded:
> >  		/*
> >  		 * The bdi thresh is somehow "soft" limit derived from the
> 
> I think we need to change callers (e.g. generic_perform_write) too.
> Otherwise, plenty write + SIGKILL combination easily exceed dirty limit.
> It mean we can see strange OOM.

If it's dangerous, we can do without this patch.  The users can still
get quick response in normal case after all.

However, I suspect the process is guaranteed to exit on
fatal_signal_pending, so it won't dirty more pages :)

Thanks,
Fengguang
