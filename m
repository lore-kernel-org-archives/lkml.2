Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab1HLJHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 05:07:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49995 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab1HLJHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 05:07:20 -0400
Date: Fri, 12 Aug 2011 11:06:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alex Neronskiy <zakmagnus@chromium.org>, linux-kernel@vger.kernel.org,
        Don Zickus <dzickus@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Alex Neronskiy <zakmagnus@chromium.com>
Subject: Re: [PATCH v6 2/2] Output stall data in debugfs
Message-ID: <20110812090607.GE28956@elte.hu>
References: <1312999364-21104-1-git-send-email-zakmagnus@chromium.org>
 <1312999364-21104-2-git-send-email-zakmagnus@chromium.org>
 <1313091323.8491.30.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313091323.8491.30.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -1.9
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.9 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.1 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2011-08-10 at 11:02 -0700, Alex Neronskiy wrote:
> > @@ -210,22 +236,27 @@ void touch_softlockup_watchdog_sync(void)
> >  /* watchdog detector functions */
> >  static void update_hardstall(unsigned long stall, int this_cpu)
> >  {
> >         if (stall > hardstall_thresh && stall > worst_hardstall) {
> >                 unsigned long flags;
> > +               spin_lock_irqsave(&hardstall_write_lock, flags);
> > +               if (stall > worst_hardstall) {
> > +                       int write_ind = hard_read_ind;
> > +                       int locked = spin_trylock(&hardstall_locks[write_ind]);
> > +                       /* cannot wait, so if there's contention,
> > +                        * switch buffers */
> > +                       if (!locked)
> > +                               write_ind = !write_ind;
> > +
> >                         worst_hardstall = stall;
> > +                       hardstall_traces[write_ind].nr_entries = 0;
> > +                       save_stack_trace(&hardstall_traces[write_ind]);
> >  
> > +                       /* tell readers to use the new buffer from now on */
> > +                       hard_read_ind = write_ind;
> > +                       if (locked)
> > +                               spin_unlock(&hardstall_locks[write_ind]);
> > +               }
> > +               spin_unlock_irqrestore(&hardstall_write_lock, flags);
> >         }
> >  } 
> 
> That must be the most convoluted locking I've seen in a while.. OMG!

Well, but there are conceptual problems at the higher levels: the 
concept of recording a worst-case (or best-case) latency is not 
limited to the comparatively minor usecase of soft-watchdog stalls.

We have numerous tracers in ftrace that output their own kinds of 
min/max latencies, with associated stack trace signatures.

So the right approach would *not* be to add yet another 
special-purpose debugfs variant for this, but to integrate this 
capability into perf tracing. That way it would be useful for:

 - soft stalls
 - irq service latencies
 - irq disable latencies
 - preempt disable latencies
 - wakeup latencies
 - and much more: it could be used for just about any event that 
   measures some sort of latency.

To implement it i'd first suggest to add a TRACE_EVENT() for the 
softwatchdog latencies, and then look at how a stack-trace attached 
to the worst-case latency could be emitted via the perf ring-buffer.

We do something very, very similar for callchains already, so all the 
low level machinery is already there.

Alex, would you be interested in taking a stab at this approach? Such 
an approach looks a *lot* more palatable from an upstream merge point 
of view and it would give you all the functionality that the current 
patches are providing you (and more).

Thanks,

	Ingo
