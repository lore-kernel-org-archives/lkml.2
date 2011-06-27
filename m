Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759877Ab1F0NLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 09:11:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57967 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264Ab1F0NKO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 09:10:14 -0400
Subject: Re: [tip:perf/urgent] perf: Fix SIGIO handling
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1307441757.2322.244.camel@twins>
References: <tip-2euus3f3x3dyvdk52cjxw8zu@git.kernel.org>
	 <alpine.DEB.2.00.1106011516480.5384@cl320.eecs.utk.edu>
	 <1307441757.2322.244.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 27 Jun 2011 15:09:16 +0200
Message-ID: <1309180156.6701.105.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 12:15 +0200, Peter Zijlstra wrote:
> On Wed, 2011-06-01 at 15:41 -0400, Vince Weaver wrote:
> > On Sat, 28 May 2011, tip-bot for Peter Zijlstra wrote:
> > 
> > > Commit-ID:  f506b3dc0ec454a16d40cab9ee5d75435b39dc50
> > > Gitweb:     http://git.kernel.org/tip/f506b3dc0ec454a16d40cab9ee5d75435b39dc50
> > > Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > AuthorDate: Thu, 26 May 2011 17:02:53 +0200
> > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > CommitDate: Sat, 28 May 2011 17:04:59 +0200
> > > 
> > > perf: Fix SIGIO handling
> > > 
> > > Vince noticed that unless we mmap() a buffer, SIGIO gets lost. So
> > > explicitly push the wakeup (including signals) when requested.
> > > 
> > > Reported-by: Vince Weaver <vweaver1@eecs.utk.edu>
> > > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Cc: <stable@kernel.org>
> > > Link: http://lkml.kernel.org/n/tip-2euus3f3x3dyvdk52cjxw8zu@git.kernel.org
> > > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > > ---
> > >  kernel/events/core.c |    8 ++++++++
> > >  1 files changed, 8 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > > index c09767f..d863b3c 100644
> > > --- a/kernel/events/core.c
> > > +++ b/kernel/events/core.c
> > > @@ -5028,6 +5028,14 @@ static int __perf_event_overflow(struct perf_event *event, int nmi,
> > >  	else
> > >  		perf_event_output(event, nmi, data, regs);
> > >  
> > > +	if (event->fasync && event->pending_kill) {
> > > +		if (nmi) {
> > > +			event->pending_wakeup = 1;
> > > +			irq_work_queue(&event->pending);
> > > +		} else
> > > +			perf_event_wakeup(event);
> > > +	}
> > > +
> > >  	return ret;
> > >  }
> > 
> > there is something strange about this commit.  
> > 
> > With it I get many more overflows than expected (on the order of 40x more)
> > when I am using PERF_IOC_REFRESH,1 to restart the sampled counter
> > from the end of the signal handler.
> > 
> > Also if you use PERF_IOC_REFRESH with a value other than 1, the value
> > seems to be ignored and all of the counts are POLL_IN rather than
> > POLL_HUP as I'd expect.
> 
> OK, so what semantics do we expect?
> 
> Currently (with this patch) when a SIGIO is registered, every event
> overflow (sample) generates a POLL_IN SIGIO, except when event_limit
> disables the counter, in which case its a POLL_HUP.
> 
> Without the patch, we used to send POLL_IN on every wakeup that would
> wake poll() and POLL_HUP every time event_limit was reached.
> 
> event_limit is incremented using IOC_REFRESH, when its non-zero its
> decremented on every overflow, and when it reaches 0 again it fires
> SIGIO-POLL_HUP and disables the event.

Also, I realized we could get the current behaviour by setting
attr.wakeup_events = 1.

So what should we do, revert the above patch?
