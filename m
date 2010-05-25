Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab0EYG6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 02:58:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52940 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab0EYG6V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 02:58:21 -0400
Subject: Re: [PATCH 2/4] perf: Add exclude_task perf event attribute
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <20100525014323.GC30395@drongo>
References: <1274450715-23955-1-git-send-regression-fweisbec@gmail.com>
	 <1274450715-23955-3-git-send-regression-fweisbec@gmail.com>
	 <20100525014323.GC30395@drongo>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 May 2010 08:58:08 +0200
Message-ID: <1274770688.5882.168.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 11:43 +1000, Paul Mackerras wrote:
> On Fri, May 21, 2010 at 04:05:13PM +0200, Frederic Weisbecker wrote:
> 
> > Excluding is useful when you want to trace only hard and softirqs.
> > 
> > For this we use a new generic perf_exclude_event() (the previous
> > one beeing turned into perf_exclude_swevent) to which you can pass
> > the preemption offset to which your events trigger.
> > 
> > Computing preempt_count() - offset gives us the preempt_count() of
> > the context that the event has interrupted, on top of which we
> > can filter the non-irq contexts.
> 
> How does this work for hardware events when we are sampling and
> getting an interrupt every N events?  It seems like the hardware is
> still counting all events and interrupting every N events, but we are
> only recording a sample if the interrupt occurred in the context we
> want.  In other words the context of the Nth event is considered to be
> the context for the N-1 events preceding that, which seems a pretty
> poor approximation.
> 
> Also, for hardware events, if we are counting rather than sampling,
> the exclude_task bit will have no effect.  So perhaps in that case the
> perf_event_open should fail rather than appear to succeed but give
> wrong data.

Right, so for hardware event we'd need to go with those irq_{enter,exit}
hooks and either fully disable the call, or do as Ingo suggested, read
the count delta and add that to period_left, so that we'll delay the
sample (and subtract from ->count, which is I think the trickiest bit as
it'll generate a non-monotonic ->count).

So I prefer the disable/enable from irq_enter/exit, however I also
suspect that that is by far the most expensive option.
