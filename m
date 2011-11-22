Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab1KVGlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 01:41:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:61907 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab1KVGlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 01:41:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,551,1315206000"; 
   d="scan'208";a="87991224"
Date: Tue, 22 Nov 2011 14:41:49 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] writeback: balanced_rate cannot exceed write
 bandwidth
Message-ID: <20111122064149.GA12864@localhost>
References: <20111121130342.211953629@intel.com>
 <20111121131215.645601798@intel.com>
 <20111121225049.GE4017@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121225049.GE4017@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 06:50:49AM +0800, Jan Kara wrote:
> On Mon 21-11-11 21:03:43, Wu Fengguang wrote:
> > Add an upper limit to balanced_rate according to the below inequality.
> > This filters out some rare but huge singular points, which at least
> > enables more readable gnuplot figures.
> > 
> > When there are N dd dirtiers,
> > 
> > 	balanced_dirty_ratelimit = write_bw / N
> > 
> > So it holds that
> > 
> > 	balanced_dirty_ratelimit <= write_bw
>   The change makes sense, but do we understand why there are such huge
> singular points? Are they due to errors in estimation of bandwidth or due
> to errors in dirtying rate computations (e.g. due to truncates), or
> something else?

Good point. I'll add this to the changelog:

The singular points originate from dirty_rate in the below formular:

        balanced_dirty_ratelimit = task_ratelimit * write_bw / dirty_rate
where
        dirty_rate = (number of page dirties in the past 200ms) / 200ms

In the extreme case, if all dd tasks suddenly get blocked on something 
else and hence no pages are dirtied at all, dirty_rate will be 0 and
balanced_dirty_ratelimit will be inf. This could happen in reality.

There won't be tiny singular points though, as long as the dirty pages
lie inside the dirty control area (above the freerun region).
Because there the dd tasks will be throttled by balanced_dirty_pages()
and won't be able to suddenly dirty much more pages than average.

Thanks,
Fengguang
