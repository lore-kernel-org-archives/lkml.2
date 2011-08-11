Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab1HKW4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 18:56:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58883 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab1HKW4w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 18:56:52 -0400
Subject: Re: [PATCH 2/5] writeback: dirty position control
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Date: Fri, 12 Aug 2011 00:56:06 +0200
References: <20110806084447.388624428@intel.com>
	 <20110806094526.733282037@intel.com> <1312811193.10488.33.camel@twins>
	 <20110808141128.GA22080@localhost> <1312814501.10488.41.camel@twins>
	 <20110808230535.GC7176@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1313103367.26866.39.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-09 at 19:20 +0200, Peter Zijlstra wrote:
> So going by:
> 
>                                          write_bw
>   ref_bw = dirty_ratelimit * pos_ratio * --------
>                                          dirty_bw
> 
> pos_ratio seems to be the feedback on the deviation of the dirty pages
> around its setpoint. So we adjust the reference bw (or rather ratelimit)
> to take account of the shift in output vs input capacity as well as the
> shift in dirty pages around its setpoint.
> 
> From that we derive the condition that: 
> 
>   pos_ratio(setpoint) := 1
> 
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

Ok, so I think that pos_ratio(limit) := 0, is a stronger condition than
your negative slope (df/dx < 0), simply because it implies your
condition and because it expresses our hard stop at limit.

Also, while I know this is totally over the top, but..

I saw you added a ramp and brake area in future patches, so have you
considered using a third order polynomial instead?

The simple:

 f(x) = -x^3 

has the 'right' shape, all we need is move it so that:

 f(s) = 1

and stretch it to put the single root at our limit. You'd get something
like:

               s - x 3
 f(x) :=  1 + (-----)
                 d

Which, as required, is 1 at our setpoint and the factor d stretches the
middle bit. Which has a single (real) root at: 

  x = s + d, 

by setting that to our limit, we get:

  d = l - s

Making our final function look like:

               s - x 3
 f(x) :=  1 + (-----)
               l - s

You can clamp it at [0,2] or so. The implementation wouldn't be too
horrid either, something like:

unsigned long bdi_pos_ratio(..)
{
	if (dirty > limit)
		return 0;

	if (dirty < 2*setpoint - limit)
		return 2 * SCALE;

	x = SCALE * (setpoint - dirty) / (limit - setpoint);
	xx = (x * x) / SCALE;
	xxx = (xx * x) / SCALE;

	return xxx;
}

