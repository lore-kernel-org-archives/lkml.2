Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab1HPIzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 04:55:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:17448 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666Ab1HPIza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 04:55:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,379,1309762800"; 
   d="scan'208";a="38938772"
Date: Tue, 16 Aug 2011 16:55:26 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] writeback: dirty position control
Message-ID: <20110816085526.GB19970@localhost>
References: <20110806084447.388624428@intel.com>
 <20110806094526.733282037@intel.com>
 <1312811193.10488.33.camel@twins>
 <20110808141128.GA22080@localhost>
 <1312814501.10488.41.camel@twins>
 <20110808230535.GC7176@localhost>
 <20110810214057.GA6576@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110810214057.GA6576@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

Sorry it made such a big confusion to you. I hope Peter's 3rd order
polynomial abstraction in v9 can clarify the concepts a lot.

As for the old global control line

                       origin - dirty
           pos_ratio = --------------           (1)
                       origin - goal

where

        origin = 4 * thresh                     (2)

effectively decides the slope of the line. The use of @limit in code

        origin = max(4 * thresh, limit)         (3)

is merely to safeguard the rare case that (2) might result in negative
pos_ratio in (1).

I have another patch to add a "brake" area immediately below @limit
that will scale pos_ratio down to 0. However that's no longer
necessary with the 3rd order polynomial solution. 

Note that @limit will normally be equal to @thresh except in the rare
case that @thresh is suddenly knocked down and @limit is taking time
to follow it.

Thanks,
Fengguang

> Hi Fengguang,
> 
> Ok, so just trying to understand this pos_ratio little better.
> 
> You have following basic formula.
> 
>                      origin - dirty
>          pos_ratio = --------------
>                      origin - goal
> 
> Terminology is very confusing and following is my understanding. 
> 
> - setpoint == goal
> 
>   setpoint is the point where we would like our number of dirty pages to
>   be and at this point pos_ratio = 1. For global dirty this number seems
>   to be (thresh - thresh / DIRTY_SCOPE) 
> 
> - thresh
>   dirty page threshold calculated from dirty_ratio (Certain percentage of
>   total memory).
> 
> - Origin (seems to be equivalent of limit)
> 
>   This seems to be the reference point/limit we don't want to cross and
>   distance from this limit basically decides the pos_ratio. Closer we
>   are to limit, lower the pos_ratio and further we are higher the
>   pos_ratio.
> 
> So threshold is just a number which helps us determine goal and limit.
> 
> goal = thresh - thresh / DIRTY_SCOPE
> limit = 4*thresh
> 
> So goal is where we want to be and we start throttling the task more as
> we move away goal and approach limit. We keep the limit high enough
> so that (origin-dirty) does not become negative entity.
> 
> So we do expect to cross "thresh" otherwise thresh itself could have
> served as limit?
> 
> If my understanding is right, then can we get rid of terms "setpoint" and
> "origin". Would it be easier to understand the things if we just talk
> in terms of "goal" and "limit" and how these are derived from "thresh".
> 
> 	thresh == soft limit
> 	limit == 4*thresh (hard limit)
> 	goal = thresh - thresh / DIRTY_SCOPE (where we want system to
> 						be in steady state).
>                      limit - dirty
>          pos_ratio = --------------
>                      limit - goal
> 
> Thanks
> Vivek
