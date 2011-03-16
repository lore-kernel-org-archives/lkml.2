Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab1CPOVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 10:21:23 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34847 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab1CPOVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 10:21:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=BQZEmGkKnDILdbdg5dUEHhSQJhZGzXcAM8lEpiYRWevCOrG4MVyW7c1on3Cm2jldu5
         DqMVq1IQWUqlodr2k5apMTA6LvVpmE/qUqA9GQpIcncBjUxm8vkiqsjA7hfMl8ruXKhL
         7YBrincTG/SzRCbZ5uS27VTqi84Vn64hw24RQ=
Date: Wed, 16 Mar 2011 15:21:11 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lin Ming <minggr@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: Re: [RFC PATCH 1/4] perf: Starter and stopper events
Message-ID: <20110316142109.GC1774@nowhere>
References: <1300130283-10466-1-git-send-email-fweisbec@gmail.com>
 <1300130283-10466-2-git-send-email-fweisbec@gmail.com>
 <AANLkTim4gFdxn3pHZuxXe-AwTCYrnUHHeFkEK6wisYiL@mail.gmail.com>
 <20110315175415.GA6605@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110315175415.GA6605@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 06:54:19PM +0100, Frederic Weisbecker wrote:
> On Tue, Mar 15, 2011 at 10:36:18PM +0800, Lin Ming wrote:
> > On Tue, Mar 15, 2011 at 3:18 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > >
> > > +static void perf_event_pause_resume(struct perf_event *event, int nmi,
> > > +                                   struct perf_sample_data *data,
> > > +                                   struct pt_regs *regs)
> > > +{
> > > +       struct perf_event *iter;
> > > +       unsigned long flags;
> > > +
> > > +       /*
> > > +        * Ensure the targets can't be sched in/out concurrently.
> > > +        * Disabling irqs is sufficient for that because starters/stoppers
> > > +        * are on the same cpu/task.
> > > +        */
> > > +       local_irq_save(flags);
> > 
> > Could you explain this more detail?
> 
> Yeah, I should have detailed that more.
> 
> So, I put a constraint in starters and stoppers: those must be attached
> to the same task and cpu than the target. That allows us to do this
> pause/resume lockless if we can ensure that:
> 
> - target sched in/out can't interrupt perf_event_pause_resume()
> - perf_event_pause_resume() can interrupt the target in the middle of
> event_sched_in()
> 
> So that both are strictly serialized.
> 
> We need to ensure that the target event can not be concurrently scheduled
> in (->add()) or scheduled out (->del() ), so that when we check
> PERF_EVENT_STATE_ACTIVE, we know that the event is currently running
> and is not going to move while we do our checks and we call start() and
> stop().
> 
> So the rationale is that the target can not be in the middle of
> event_sched_in() or event_sched_out() when the starter/stopper
> trigger. We have no guarantee of that currently, especially because
> of events that trigger in NMIs, but also for other corner cases may
> be, so I'll need to think about it later. Why not by using pmu_disable_all()
> on the starter/stopper when the target is about to schedule in/out, until
> we know the event->state really reflects the hardware and logical states.
> 
> Now event_sched_in() and event_sched_out() can still be called from an
> IPI to enable/disable an event. Hence the interrupts disabled to prevent
> from that.
>  
> > > +
> > > +
> > > +       /* Prevent the targets from being removed under us. */
> > > +       rcu_read_lock();

And BTW this rcu_read_lock() is not necessary. The target can not be removed
under us.

And also there is another race to take care about: if the starter and the stopper
trigger at the same time, we are going to call ->start() and ->stop() concurrently.
Not sure yet how to solve that.
