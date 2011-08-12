Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab1HLLH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 07:07:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:20111 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587Ab1HLLHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 07:07:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,361,1309762800"; 
   d="scan'208";a="37801597"
Date: Fri, 12 Aug 2011 19:07:18 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] writeback: dirty position control
Message-ID: <20110812110718.GA8016@localhost>
References: <20110806084447.388624428@intel.com>
 <20110806094526.733282037@intel.com>
 <1312811193.10488.33.camel@twins>
 <20110808141128.GA22080@localhost>
 <1312814501.10488.41.camel@twins>
 <20110808230535.GC7176@localhost>
 <1313103367.26866.39.camel@twins>
 <20110812024353.GA11606@localhost>
 <20110812054528.GA10524@localhost>
 <1313142333.6576.8.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313142333.6576.8.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 05:45:33PM +0800, Peter Zijlstra wrote:
> On Fri, 2011-08-12 at 13:45 +0800, Wu Fengguang wrote:
> > Code is
> > 
> >         unsigned long freerun = (thresh + bg_thresh) / 2;
> > 
> >         setpoint = (limit + freerun) / 2;
> >         pos_ratio = abs(dirty - setpoint);
> >         pos_ratio <<= BANDWIDTH_CALC_SHIFT;
> >         do_div(pos_ratio, limit - setpoint + 1);
> 
> Why do you use do_div()? from the code those things are unsigned long,
> and you can divide that just fine.

Because pos_ratio was "unsigned long long"..

> Also, there's div64_s64 that can do signed divides for s64 types.
> That'll loose the extra conditionals you used for abs and putting the
> sign back.

Ah ok, good to know that :)

> >         x = pos_ratio;
> >         pos_ratio = pos_ratio * x >> BANDWIDTH_CALC_SHIFT;
> >         pos_ratio = pos_ratio * x >> BANDWIDTH_CALC_SHIFT;
> 
> So on 32bit with unsigned long that gets 32=2*(10+b) bits for x, that
> solves to 6, which isn't going to be enough I figure since
> (dirty-setpoint) !< 64.
> 
> So you really need to use u64/s64 types here, unsigned long just won't
> do, with u64 you have 64=2(10+b) 22 bits for x, which should fit.

Sure, here is the updated code:

        long long pos_ratio;            /* for scaling up/down the rate limit */
        long x;
       
        if (unlikely(dirty >= limit))
                return 0;

        /*
         * global setpoint
         *
         *                  setpoint - dirty 3
         * f(dirty) := 1 + (----------------)
         *                  limit - setpoint
         *
         * it's a 3rd order polynomial that subjects to
         *
         * (1) f(freerun)  = 2.0 => rampup base_rate reasonably fast
         * (2) f(setpoint) = 1.0 => the balance point
         * (3) f(limit)    = 0   => the hard limit
         * (4) df/dx < 0         => negative feedback control
         * (5) the closer to setpoint, the smaller |df/dx| (and the reverse),
         *     => fast response on large errors; small oscillation near setpoint
         */
        setpoint = (limit + freerun) / 2;
        pos_ratio = (setpoint - dirty) << RATELIMIT_CALC_SHIFT;
        pos_ratio = div_s64(pos_ratio, limit - setpoint + 1);
        x = pos_ratio;
        pos_ratio = pos_ratio * x >> RATELIMIT_CALC_SHIFT;
        pos_ratio = pos_ratio * x >> RATELIMIT_CALC_SHIFT;
        pos_ratio += 1 << RATELIMIT_CALC_SHIFT;

Thanks,
Fengguang
