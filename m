Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab2FSJTF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 05:19:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:35769 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab2FSJTD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 05:19:03 -0400
Message-ID: <1340097532.21745.19.camel@twins>
Subject: Re: [PATCH] sched: Folding nohz load accounting more accurate
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Charles Wang <muming.wq@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Tao Ma <tm@tao.ma>,
        =?UTF-8?Q?=E5=90=AB=E9=BB=9B?= <handai.szj@taobao.com>,
        Doug Smythies <dsmythies@telus.net>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 19 Jun 2012 11:18:52 +0200
In-Reply-To: <20120619060824.GA31684@zhy>
References: <1339239295-18591-1-git-send-email-muming.wq@taobao.com>
	 <1339429374.30462.54.camel@twins> <4FD70D12.5030404@gmail.com>
	 <1339494970.31548.66.camel@twins> <4FDB4642.5070509@gmail.com>
	 <1340035417.15222.95.camel@twins> <20120619060824.GA31684@zhy>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-19 at 14:08 +0800, Yong Zhang wrote:

> > ---
> >  kernel/sched/core.c      |  290 ++++++++++++++++++++++++++++++++++------------
> >  kernel/sched/idle_task.c |    1 -
> >  kernel/sched/sched.h     |    2 -
> >  kernel/time/tick-sched.c |    2 +
> >  4 files changed, 220 insertions(+), 75 deletions(-)
> > 
> > + *  - When we go NO_HZ idle during the window, we can negate our sample
> > + *    contribution, causing under-accounting.
> > + *
> > + *    We avoid this by keeping two idle-delta counters and flipping them
> > + *    when the window starts, thus separating old and new NO_HZ load.
> > + *
> > + *    The only trick is the slight shift in index flip for read vs write.
> > + *
> > + *       0             5             10            15
> > + *         +10           +10           +10           +10
> > + *       |-|-----------|-|-----------|-|-----------|-|
> > + *    r:001           110           001           110
> > + *    w:011           100           011           100
> 
> I'm confused by this comments, looking at your code, index is increased by
> 1 for each samaple window.

Also looking at the code you'll find we only ever use idx & 1.

> > + *
> > + *    This ensures we'll fold the old idle contribution in this window while
> > + *    accumlating the new one.
> > + *
> > + *  - When we wake up from NO_HZ idle during the window, we push up our
> > + *    contribution, since we effectively move our sample point to a known
> > + *    busy state.
> > + *
> > + *    This is solved by pushing the window forward, and thus skipping the
> > + *    sample, for this cpu (effectively using the idle-delta for this cpu which
> > + *    was in effect at the time the window opened). This also solves the issue
> > + *    of having to deal with a cpu having been in NOHZ idle for multiple
> > + *    LOAD_FREQ intervals.
> >   *
> >   * When making the ILB scale, we should try to pull this in as well.
> >   */
> > +void calc_load_exit_idle(void)
> >  {
> > +	struct rq *this_rq = this_rq();
> >  
> >  	/*
> > +	 * If we're still outside the sample window, we're done.
> >  	 */
> > +	if (time_before(jiffies, this_rq->calc_load_update))
> > +		return;

> 	else if (time_before(jiffies, calc_load_update + 10)
> 		this_rq->calc_load_update = calc_load_update + LOAD_FREQ;
> 	else
> 		this_rq->calc_load_update = calc_load_update;
> 
> Otherwise if you woke after the sample window, we loose on sample?
> And maybe we need local variable to cache calc_load_update.

Ah indeed, although I'd write it like:

	this_rq->calc_load_update = calc_load_update;
	if (time_before(jiffies, this_rq->calc_load_update + 10)
		this_rq->calc_load_update += LOAD_FREQ;

Thanks!

