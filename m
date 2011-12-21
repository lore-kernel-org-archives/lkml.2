Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab1LUBjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 20:39:42 -0500
Received: from mga14.intel.com ([143.182.124.37]:18991 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab1LUBjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 20:39:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="87920075"
Date: Wed, 21 Dec 2011 09:29:36 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/9] readahead: add /debug/readahead/stats
Message-ID: <20111221012935.GA13231@localhost>
References: <20111129130900.628549879@intel.com>
 <20111129131456.666312513@intel.com>
 <20111129152106.GN5635@quack.suse.cz>
 <20111214063625.GA13824@localhost>
 <20111219163241.GA4107@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111219163241.GA4107@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 12:32:41AM +0800, Jan Kara wrote:
> On Wed 14-12-11 14:36:25, Wu Fengguang wrote:
> > >   This looks all inherently racy (which doesn't matter much as you suggest)
> > > so I just wanted to suggest that if you used per-cpu counters you'd get
> > > race-free and faster code at the cost of larger data structures and using
> > > percpu_counter_add() instead of ++ (which doesn't seem like a big
> > > complication to me).
> > 
> > OK, here is the incremental patch to use per-cpu counters :)
>   Thanks! This looks better. I just thought you would use per-cpu counters
> as defined in include/linux/percpu_counter.h and are used e.g. by bdi
> stats. This is more standard for statistics in the kernel than using
> per-cpu variables directly.

Ah yes, I overlooked that facility! However the percpu_counter's
ability to maintain and quickly retrieve the global value seems
unnecessary feature/overheads for readahead stats, because here we
only need to sum up the global value when the user requests it. If
switching to percpu_counter, I'm afraid every readahead(1MB) event
will lead to the update of percpu_counter global value (grabbing the
spinlock) due to 1MB > some small batch size. This actually performs
worse than the plain global array of values in the v1 patch.

Thanks,
Fengguang
