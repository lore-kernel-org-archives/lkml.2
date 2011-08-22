Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab1HVPih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 11:38:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33963 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab1HVPie convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 11:38:34 -0400
Subject: Re: [PATCH 2/5] writeback: dirty position control
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 22 Aug 2011 17:38:07 +0200
In-Reply-To: <20110812142020.GB17781@localhost>
References: <20110806084447.388624428@intel.com>
	 <20110806094526.733282037@intel.com> <1312811193.10488.33.camel@twins>
	 <20110808141128.GA22080@localhost> <1312814501.10488.41.camel@twins>
	 <20110808230535.GC7176@localhost> <1313154259.6576.42.camel@twins>
	 <20110812142020.GB17781@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314027488.24275.74.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-12 at 22:20 +0800, Wu Fengguang wrote:
> On Fri, Aug 12, 2011 at 09:04:19PM +0800, Peter Zijlstra wrote:
> > On Tue, 2011-08-09 at 19:20 +0200, Peter Zijlstra wrote:
> 
> To start with,
> 
>                                                 write_bw
>         ref_bw = task_ratelimit_in_past_200ms * --------
>                                                 dirty_bw
> 
> where
>         task_ratelimit_in_past_200ms ~= dirty_ratelimit * pos_ratio
> 
> > > Now all of the above would seem to suggest:
> > > 
> > >   dirty_ratelimit := ref_bw
> 
> Right, ideally ref_bw is the balanced dirty ratelimit. I actually
> started with exactly the above equation when I got choked by pure
> pos_bw based feedback control (as mentioned in the reply to Jan's
> email) and introduced the ref_bw estimation as the way out.
> 
> But there are some imperfections in ref_bw, too. Which makes it not
> suitable for direct use:
> 
> 1) large fluctuations

OK, understood.

> 2) due to truncates and fs redirties, the (write_bw <=> dirty_bw)
> becomes unbalanced match, which leads to large systematical errors
> in ref_bw. The truncates, due to its possibly bumpy nature, can hardly
> be compensated smoothly.

OK.

> 3) since we ultimately want to
> 
> - keep the dirty pages around the setpoint as long time as possible
> - keep the fluctuations of task ratelimit as small as possible

Fair enough ;-)

> the update policy used for (2) also serves the above goals nicely:
> if for some reason the dirty pages are high (pos_bw < dirty_ratelimit),
> and dirty_ratelimit is low (dirty_ratelimit < ref_bw), there is no
> point to bring up dirty_ratelimit in a hurry and to hurt both the
> above two goals.

Right, so still I feel somewhat befuddled, so we have:

	dirty_ratelimit - rate at which we throttle dirtiers as
			  estimated upto 200ms ago.

	pos_ratio	- ratio adjusting the dirty_ratelimit
			  for variance in dirty pages around its target

	bw_ratio	- ratio adjusting the dirty_ratelimit
			  for variance in input/output bandwidth

and we need to basically do:

	dirty_ratelimit *= pos_ratio * bw_ratio

to update the dirty_ratelimit to reflect the current state. However per
1) and 2) bw_ratio is crappy and hard to fix.

So you propose to update dirty_ratelimit only if both pos_ratio and
bw_ratio point in the same direction, however that would result in:

  if (pos_ratio < UNIT && bw_ratio < UNIT ||
      pos_ratio > UNIT && bw_ratio > UNIT) {
	dirty_ratelimit = (dirty_ratelimit * pos_ratio) / UNIT;
	dirty_ratelimit = (dirty_ratelimit * bw_ratio) / UNIT;
  }

> > > However for that you use:
> > > 
> > >   if (pos_bw < dirty_ratelimit && ref_bw < dirty_ratelimit)
> > >         dirty_ratelimit = max(ref_bw, pos_bw);
> > > 
> > >   if (pos_bw > dirty_ratelimit && ref_bw > dirty_ratelimit)
> > >         dirty_ratelimit = min(ref_bw, pos_bw);
> 
> The above are merely constraints to the dirty_ratelimit update.
> It serves to
> 
> 1) stop adjusting the rate when it's against the position control
>    target (the adjusted rate will slow down the progress of dirty
>    pages going back to setpoint).

Not strictly speaking, suppose pos_ratio = 0.5 and bw_ratio = 1.1, then
they point in different directions however:

 0.5 < 1 &&  0.5 * 1.1 < 1

so your code will in fact update the dirty_ratelimit, even though the
two factors point in opposite directions.

> 2) limit the step size. pos_bw is changing values step by step,
>    leaving a consistent trace comparing to the randomly jumping
>    ref_bw. pos_bw also has smaller errors in stable state and normally
>    have larger errors when there are big errors in rate. So it's a
>    pretty good limiting factor for the step size of dirty_ratelimit.

OK, so that's the min/max stuff, however it only works because you use
pos_bw and ref_bw instead of the fully separated factors.

> Hope the above elaboration helps :)

A little.. 
