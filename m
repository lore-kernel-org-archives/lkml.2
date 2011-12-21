Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab1LUEHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 23:07:04 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:25027 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751097Ab1LUEG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 23:06:59 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAGla8U55LL6d/2dsb2JhbABDrBGBBoFyAQEFOhwjEAgDGC4UJQMhE79iE4sZYwSUfpJH
Date: Wed, 21 Dec 2011 15:06:56 +1100
From: Dave Chinner <david@fromorbit.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/9] readahead: add /debug/readahead/stats
Message-ID: <20111221040656.GB23662@dastard>
References: <20111129130900.628549879@intel.com>
 <20111129131456.666312513@intel.com>
 <20111129152106.GN5635@quack.suse.cz>
 <20111214063625.GA13824@localhost>
 <20111219163241.GA4107@quack.suse.cz>
 <20111221012935.GA13231@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111221012935.GA13231@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 09:29:36AM +0800, Wu Fengguang wrote:
> On Tue, Dec 20, 2011 at 12:32:41AM +0800, Jan Kara wrote:
> > On Wed 14-12-11 14:36:25, Wu Fengguang wrote:
> > > >   This looks all inherently racy (which doesn't matter much as you suggest)
> > > > so I just wanted to suggest that if you used per-cpu counters you'd get
> > > > race-free and faster code at the cost of larger data structures and using
> > > > percpu_counter_add() instead of ++ (which doesn't seem like a big
> > > > complication to me).
> > > 
> > > OK, here is the incremental patch to use per-cpu counters :)
> >   Thanks! This looks better. I just thought you would use per-cpu counters
> > as defined in include/linux/percpu_counter.h and are used e.g. by bdi
> > stats. This is more standard for statistics in the kernel than using
> > per-cpu variables directly.
> 
> Ah yes, I overlooked that facility! However the percpu_counter's
> ability to maintain and quickly retrieve the global value seems
> unnecessary feature/overheads for readahead stats, because here we
> only need to sum up the global value when the user requests it. If
> switching to percpu_counter, I'm afraid every readahead(1MB) event
> will lead to the update of percpu_counter global value (grabbing the
> spinlock) due to 1MB > some small batch size. This actually performs
> worse than the plain global array of values in the v1 patch.

So use a custom batch size so that typical increments don't require
locking for every add. The bdi stat counters are an example of this
sort of setup to reduce lock contention on typical IO workloads as
concurrency increases.

All these stats have is a requirement for a different batch size to
avoid frequent lock grabs. The stats don't have to update the global
counter very often (only to prvent overflow!) so you count get away
with a batch size in the order of 2^30 without any issues....

We have a general per-cpu counter infrastructure - we should be
using it and improving it and not reinventing it a different way
every time we need a per-cpu counter.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
