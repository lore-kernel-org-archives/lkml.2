Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab1HLNUC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 09:20:02 -0400
Received: from mga14.intel.com ([143.182.124.37]:32207 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793Ab1HLNUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 09:20:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,362,1309762800"; 
   d="scan'208";a="37833697"
Date: Fri, 12 Aug 2011 21:19:54 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] writeback: dirty position control
Message-ID: <20110812131954.GA17781@localhost>
References: <20110806084447.388624428@intel.com>
 <20110806094526.733282037@intel.com>
 <1312811193.10488.33.camel@twins>
 <20110808141128.GA22080@localhost>
 <1312814501.10488.41.camel@twins>
 <20110808230535.GC7176@localhost>
 <1312910427.1083.68.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312910427.1083.68.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 01:20:27AM +0800, Peter Zijlstra wrote:
> On Tue, 2011-08-09 at 12:32 +0200, Peter Zijlstra wrote:
> > >                     origin - dirty
> > >         pos_ratio = --------------
> > >                     origin - goal 
> > 
> > > which comes from the below [*] control line, so that when (dirty == goal),
> > > pos_ratio == 1.0:
> > 
> > OK, so basically you want a linear function for which:
> > 
> > f(goal) = 1 and has a root somewhere > goal.
> > 
> > (that one line is much more informative than all your graphs put
> > together, one can start from there and derive your function)
> > 
> > That does indeed get you the above function, now what does it mean? 
> 
> So going by:
> 
>                                          write_bw
>   ref_bw = dirty_ratelimit * pos_ratio * --------
>                                          dirty_bw
> 
> pos_ratio seems to be the feedback on the deviation of the dirty pages
> around its setpoint.

Yes.

> So we adjust the reference bw (or rather ratelimit)
> to take account of the shift in output vs input capacity as well as the
> shift in dirty pages around its setpoint.

However the above function should better be interpreted as

                                            write_bw
    ref_bw = task_ratelimit_in_past_200ms * --------
                                            dirty_bw

where
        task_ratelimit_in_past_200ms ~= dirty_ratelimit * pos_ratio

It would be highly confusing if trying to find the direct "logical"
relationships between ref_bw and pos_ratio in the above equation.

> From that we derive the condition that: 
> 
>   pos_ratio(setpoint) := 1

Right.

> Now in order to create a linear function we need one more condition. We
> get one from the fact that once we hit the limit we should hard throttle
> our writers. We get that by setting the ratelimit to 0, because, after
> all, pause = nr_dirtied / ratelimit would yield inf. in that case. Thus:
> 
>   pos_ratio(limit) := 0
> 
> Using these two conditions we can solve the equations and get your:
> 
>                         limit - dirty
>   pos_ratio(dirty) =  ----------------
>                       limit - setpoint
> 
> Now, for some reason you chose not to use limit, but something like
> min(limit, 4*thresh) something to do with the slope affecting the rate
> of adjustment. This wants a comment someplace.

Thanks to your reasoning that lead to the more elegant 

                            setpoint - dirty 3
   pos_ratio(dirty) := 1 + (----------------)
                            limit - setpoint

Thanks,
Fengguang
