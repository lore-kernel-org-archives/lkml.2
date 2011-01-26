Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab1AZPnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 10:43:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435Ab1AZPnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 10:43:53 -0500
Subject: Re: [PATCH 16/16] KVM-GST: adjust scheduler cpu power
From: Glauber Costa <glommer@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>
In-Reply-To: <1296035871.28776.1132.camel@laptop>
References: <1295892397-11354-1-git-send-email-glommer@redhat.com>
	 <1295892397-11354-17-git-send-email-glommer@redhat.com>
	 <1295893920.28776.468.camel@laptop>
	 <1295895083.15920.9.camel@mothafucka.localdomain>
	 <1295898690.28776.472.camel@laptop>
	 <1295985756.15920.33.camel@mothafucka.localdomain>
	 <1295986386.28776.1101.camel@laptop>
	 <1295988455.15920.35.camel@mothafucka.localdomain>
	 <1295989664.28776.1124.camel@laptop>
	 <1295990853.15920.37.camel@mothafucka.localdomain>
	 <1296035871.28776.1132.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Wed, 26 Jan 2011 13:43:37 -0200
Message-ID: <1296056617.3591.26.camel@mothafucka.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 10:57 +0100, Peter Zijlstra wrote:
> On Tue, 2011-01-25 at 19:27 -0200, Glauber Costa wrote:
> > On Tue, 2011-01-25 at 22:07 +0100, Peter Zijlstra wrote:
> > > On Tue, 2011-01-25 at 18:47 -0200, Glauber Costa wrote:
> > > > On Tue, 2011-01-25 at 21:13 +0100, Peter Zijlstra wrote:
> > > > > On Tue, 2011-01-25 at 18:02 -0200, Glauber Costa wrote:
> > > > > 
> > > > > > I fail to see how does clock_task influence cpu power.
> > > > > > If we also have to touch clock_task for better accounting of other
> > > > > > stuff, it is a separate story.
> > > > > > But for cpu_power, I really fail. Please enlighten me.
> > > > > 
> > > > > static void update_rq_clock_task(struct rq *rq, s64 delta)
> > > > > {
> > > > >         s64 irq_delta;
> > > > > 
> > > > >         irq_delta = irq_time_read(cpu_of(rq)) - rq->prev_irq_time;
> > > > > 
> > > > >         if (irq_delta > delta)
> > > > >                 irq_delta = delta;
> > > > > 
> > > > >         rq->prev_irq_time += irq_delta;
> > > > >         delta -= irq_delta;
> > > > >         rq->clock_task += delta;
> > > > > 
> > > > >         if (irq_delta && sched_feat(NONIRQ_POWER))
> > > > >                 sched_rt_avg_update(rq, irq_delta);
> > > > > }
> > > > > 
> > > > > its done through that sched_rt_avg_update() (should probably rename
> > > > > that), it computes a floating average of time not spend on fair tasks.
> > > > > 
> > > > It creates a dependency on CONFIG_IRQ_TIME_ACCOUNTING, though.
> > > > This piece of code is simply compiled out if this option is disabled.
> > > 
> > > We can pull this bit out and make the common bit also available for
> > > paravirt.
> > 
> > scale_rt_power() seems to do the right thing, but all the path leading
> > to it seem to work on rq->clock, rather than rq->clock_task.
> 
> Not quite, see how rq->clock_task is irq_delta less than the increment
> to rq->clock? You want it to be your steal-time delta less too.
yes, but once this delta is subtracted from rq->clock_task, this value is not
used to dictate power, unless I am mistaken.

power is adjusted according to scale_rt_power(), which does it using the
values of rq->rt_avg, rq->age_stamp, and rq->clock.

So whatever I store into rq->clock_task, but not rq->clock (which
correct me if I'm wrong, is expected to be walltime), will not be used
to adjust cpu power, which is what I'm trying to achieve.

> > Although I do can experiment with that as well, could you please
> > elaborate on what are your reasons to prefer this over than variations
> > of the method I proposed?
> 
> Because I want rq->clock_task to not include steal-time.
Sure, fair deal. But at this point, those demands seem orthogonal to me.



