Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab0FGBi6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 21:38:58 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:64473 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab0FGBi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 21:38:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ldmfEBT8fb43WnhcvJJYkh/sS4z7yty8p9oZ2C07bIS34JjJCdU2TgMAMKNZIZ59n4
         55rBZlS5qg76cnXoGBBe1kWccHEdNIuXqEkCP2sBIyLVJzdS6ddEW7A8/hog9p5ym1R1
         9w6zhHqw1E+F773oXVHH7c0Cb1cXYMY6UjWA0=
Date: Mon, 7 Jun 2010 03:38:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/4] perf: Add exclude_task perf event attribute
Message-ID: <20100607013848.GA11837@nowhere>
References: <1274450715-23955-1-git-send-regression-fweisbec@gmail.com> <1274450715-23955-3-git-send-regression-fweisbec@gmail.com> <20100525014323.GC30395@drongo> <1274770688.5882.168.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274770688.5882.168.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 08:58:08AM +0200, Peter Zijlstra wrote:
> On Tue, 2010-05-25 at 11:43 +1000, Paul Mackerras wrote:
> > On Fri, May 21, 2010 at 04:05:13PM +0200, Frederic Weisbecker wrote:
> > 
> > > Excluding is useful when you want to trace only hard and softirqs.
> > > 
> > > For this we use a new generic perf_exclude_event() (the previous
> > > one beeing turned into perf_exclude_swevent) to which you can pass
> > > the preemption offset to which your events trigger.
> > > 
> > > Computing preempt_count() - offset gives us the preempt_count() of
> > > the context that the event has interrupted, on top of which we
> > > can filter the non-irq contexts.
> > 
> > How does this work for hardware events when we are sampling and
> > getting an interrupt every N events?  It seems like the hardware is
> > still counting all events and interrupting every N events, but we are
> > only recording a sample if the interrupt occurred in the context we
> > want.  In other words the context of the Nth event is considered to be
> > the context for the N-1 events preceding that, which seems a pretty
> > poor approximation.
> > 
> > Also, for hardware events, if we are counting rather than sampling,
> > the exclude_task bit will have no effect.  So perhaps in that case the
> > perf_event_open should fail rather than appear to succeed but give
> > wrong data.
> 
> Right, so for hardware event we'd need to go with those irq_{enter,exit}
> hooks and either fully disable the call, or do as Ingo suggested, read
> the count delta and add that to period_left, so that we'll delay the
> sample (and subtract from ->count, which is I think the trickiest bit as
> it'll generate a non-monotonic ->count).
> 
> So I prefer the disable/enable from irq_enter/exit, however I also
> suspect that that is by far the most expensive option.


Playing with that, it's easy to contain the counting on the filtered
contexts: I can just flush (event->read()) when we enter/exit a context
but filter the update of event->count depending on exclude_* things.

There are several problems with that though:

- overflow interrupts continue, we can block them, but still...
- periods become randomly async as the interrupts happen. We
  could save the period_left on context enter to solve this


It would be certainly easier and clearer to use stop/start things on context
enter/exit.

And the only thing that seem to happen in these paths is a write
to the event config register.
Is it what is going to be too slow?
If you compare that to all the reads on the counter,
the interrupts that still need to be serviced and filtered with the
other solution, may be the stop/start solution is eventually better
in contrast.

How much time approximately does it take to write in this config register?

Thanks.

