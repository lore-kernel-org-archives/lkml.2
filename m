Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab0EYKGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 06:06:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62676 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392Ab0EYKGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 06:06:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eAxxpBMIA/QRqPD5hMaeOL+2x8l/T+8QrWg73OlDgeeeE/tKoaw7znzzhM3SdnF/F5
         IA5Iyn8Y186pZpm6g/JZcpuG8muYSjMryiU7mYdNuE1wppctcg2yjSelB1o5U/8Ahy5G
         uG0iAiZ6+VAq1a33T2HE+ZiG7nuNzqvlFnuTQ=
Date: Tue, 25 May 2010 12:06:49 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 2/4] perf: Add exclude_task perf event attribute
Message-ID: <20100525100646.GA5286@nowhere>
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


Ingo proposed me another trick while discussing other details: having
a per context count instead of a single whole one.

So instead of having event->count, we can have event->task_count/softirq_count
and hardirq_count. Each time we enter irq_enter() (non-nested), we read the count
register and we compute the difference on irq_exit() and add the result on
event->hardirq_count. (similar kind of tricks for task and softirq counts).

So when we want to get the total, we just need to compute the sum, wrt the 
exclude_* options we have.

Now that still requires to keep the samples proxy. And the samples will stay
a bit async as the interrupt period won't be paused when we enter a filtered
context, something that would only be solved with a round of ->stop(). But
as you said, I really suspect this is not viable.

