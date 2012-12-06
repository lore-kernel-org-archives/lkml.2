Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965001Ab2LFJMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 04:12:32 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:59046 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab2LFJM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 04:12:29 -0500
Message-ID: <1354785141.4593.109.camel@marge.simpson.net>
Subject: Re: weakness of runnable load tracking?
From: Mike Galbraith <bitbucket@online.de>
To: Alex Shi <alex.shi@intel.com>
Cc: Alex Shi <lkml.alex@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Tejun Heo <tj@kernel.org>
Date: Thu, 06 Dec 2012 10:12:21 +0100
In-Reply-To: <50C05201.7090900@intel.com>
References: <CAGjg+kFZ2+tzxOS4SVo3PTzEDJJ=B0gZJ0aEOhNHvTycFuVT6Q@mail.gmail.com>
	 <50C00D41.1010800@intel.com> <1354773465.4593.61.camel@marge.simpson.net>
	 <50C05201.7090900@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:4+h+HAg8E/dDI2VhFFLKVtVg3ss8CvZ//bg139NUrXf
 ZP18JegRsKn0yZoyLqrxA5Qc4CT5c9zatifbfRbcx1bmJIPA+7
 0iPMKlYF6fTF2s1d0Q3Ni8+z1JvouGfQ6e+sYfDveEX4Gl5FG0
 ZsTLmi+Lv2aNnWQl6k/QALfYYck1F95kw7G8a0LMhrvZhUZA9+
 qkjUqDDMcciBhQlQEvG/1YpM3klRLRHsXycl5qXWpxikq3HnnB
 w/av6fuCrWZaf1f/vusbXRa7NRVWvqAktcMS5jZvXnqupQJg3B
 z51k1bMwWrRI1tyaAjJ6z16010F2nwlk3Z7ye2SNetXA6YZ4pE
 y5pSdH1B79VRsPY8kE89KrmrJFhnpmJ6KfVkdIEvDY1s0VWquP
 rfoDEFwzGgbtg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-06 at 16:06 +0800, Alex Shi wrote: 
> >>
> >> Hi Paul & Ingo:
> >>
> >> In a short word of this issue: burst forking/waking tasks have no time
> >> accumulate the load contribute, their runnable load are taken as zero.
> >> that make select_task_rq do a wrong decision on which group is idlest.
> > 
> > As you pointed out above, new tasks can (and imho should) be born with
> > full weight.  Tasks _may_ become thin, but they're all born hungry.
> 
> Thanks for comments. I think so. :)
> > 
> >> There is still 3 kinds of solution is helpful for this issue.
> >>
> >> a, set a unzero minimum value for the long time sleeping task. but it
> >> seems unfair for other tasks these just sleep a short while.
> >>
> >> b, just use runnable load contrib in load balance. Still using
> >> nr_running to judge idlest group in select_task_rq_fair. but that may
> >> cause a bit more migrations in future load balance.
> >>
> >> c, consider both runnable load and nr_running in the group: like in the
> >> searching domain, the nr_running number increased a certain number, like
> >> double of the domain span, in a certain time. we will think it's a burst
> >> forking/waking happened, then just count the nr_running as the idlest
> >> group criteria.
> >>
> >> IMHO, I like the 3rd one a bit more. as to the certain time to judge if
> >> a burst happened, since we will calculate the runnable avg at very tick,
> >> so if increased nr_running is beyond sd->span_weight in 2 ticks, means
> >> burst happening. What's your opinion of this?
> >>
> >> Any comments are appreciated!
> > 
> > IMHO, for fork and bursty wake balancing, the only thing meaningful is
> > the here and now state of runqueues tasks are being dumped into.
> > 
> > Just because tasks are historically short running, you don't necessarily
> > want to take a gaggle and wedge them into a too small group just to even
> > out load averages.  If there was a hole available that you passed up by
> > using average load, you lose utilization.  I can see how this load
> > tracking stuff can average out to a win on a ~heavily loaded box, but
> > bursty stuff I don't see how it can do anything but harm, so imho, the
> > user should choose which is best for his box, instantaneous or history.
> 
> Do you mean the system administrator need to do this choice?

That's my gut feeling just from pondering potential pitfalls.

> It's may a hard decision.  :)

Yup, very hard.

> Any suggestions of decision basis?

Same as most buttons.. poke it and <cringe> see what happens :) 

> > WRT burst detection: any window you define can be longer than the burst.
> 
> Maybe we can define 2 waking on same cpu in 1 tick is a burst happened,
> and if the cpu had taken a waking task. we'd better skip this cpu. :)
> Anyway, the hard point is we can not predict future.

No matter what the metric, you'll be reacting after the fact.

Somebody needs to code up that darn omniscience algorithm.  In a pinch,
a simple undo the past will suffice :)

-Mike

