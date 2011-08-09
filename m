Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab1HIRVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 13:21:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:60074 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab1HIRVO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 13:21:14 -0400
Subject: Re: [PATCH 2/5] writeback: dirty position control
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 09 Aug 2011 19:20:27 +0200
References: <20110806084447.388624428@intel.com>
	 <20110806094526.733282037@intel.com> <1312811193.10488.33.camel@twins>
	 <20110808141128.GA22080@localhost> <1312814501.10488.41.camel@twins>
	 <20110808230535.GC7176@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1312910427.1083.68.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-09 at 12:32 +0200, Peter Zijlstra wrote:
> >                     origin - dirty
> >         pos_ratio = --------------
> >                     origin - goal 
> 
> > which comes from the below [*] control line, so that when (dirty == goal),
> > pos_ratio == 1.0:
> 
> OK, so basically you want a linear function for which:
> 
> f(goal) = 1 and has a root somewhere > goal.
> 
> (that one line is much more informative than all your graphs put
> together, one can start from there and derive your function)
> 
> That does indeed get you the above function, now what does it mean? 

So going by:

                                         write_bw
  ref_bw = dirty_ratelimit * pos_ratio * --------
                                         dirty_bw

pos_ratio seems to be the feedback on the deviation of the dirty pages
around its setpoint. So we adjust the reference bw (or rather ratelimit)
to take account of the shift in output vs input capacity as well as the
shift in dirty pages around its setpoint.

>From that we derive the condition that: 

  pos_ratio(setpoint) := 1

Now in order to create a linear function we need one more condition. We
get one from the fact that once we hit the limit we should hard throttle
our writers. We get that by setting the ratelimit to 0, because, after
all, pause = nr_dirtied / ratelimit would yield inf. in that case. Thus:

  pos_ratio(limit) := 0

Using these two conditions we can solve the equations and get your:

                        limit - dirty
  pos_ratio(dirty) =  ----------------
                      limit - setpoint

Now, for some reason you chose not to use limit, but something like
min(limit, 4*thresh) something to do with the slope affecting the rate
of adjustment. This wants a comment someplace.


Now all of the above would seem to suggest:

  dirty_ratelimit := ref_bw

However for that you use:

  if (pos_bw < dirty_ratelimit && ref_bw < dirty_ratelimit)
	dirty_ratelimit = max(ref_bw, pos_bw);

  if (pos_bw > dirty_ratelimit && ref_bw > dirty_ratelimit)
	dirty_ratelimit = min(ref_bw, pos_bw);

You have:

  pos_bw = dirty_ratelimit * pos_ratio

Which is ref_bw without the write_bw/dirty_bw factor, this confuses me..
why are you ignoring the shift in output vs input rate there?



