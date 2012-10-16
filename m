Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab2JPS7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 14:59:19 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:35141 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871Ab2JPS7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 14:59:18 -0400
Date: Tue, 16 Oct 2012 11:58:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] brw_mutex: big read-write mutex
Message-ID: <20121016185852.GH2385@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121015190958.GA4799@redhat.com>
 <20121015191018.GA4816@redhat.com>
 <20121015232814.GC3010@linux.vnet.ibm.com>
 <20121016155623.GA4028@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121016155623.GA4028@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101618-2398-0000-0000-00000C7A6DDA
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00183036; UDB=6.00041459; UTC=2012-10-16
 18:59:17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 05:56:23PM +0200, Oleg Nesterov wrote:
> Paul, thanks for looking!
> 
> On 10/15, Paul E. McKenney wrote:
> >
> > > +void brw_start_read(struct brw_mutex *brw)
> > > +{
> > > +	for (;;) {
> > > +		bool done = false;
> > > +
> > > +		preempt_disable();
> > > +		if (likely(!atomic_read(&brw->write_ctr))) {
> > > +			__this_cpu_inc(*brw->read_ctr);
> > > +			done = true;
> > > +		}
> >
> > brw_start_read() is not recursive -- attempting to call it recursively
> > can result in deadlock if a writer has shown up in the meantime.
> 
> Yes, yes, it is not recursive. Like rw_semaphore.
> 
> > Which is often OK, but not sure what you intended.
> 
> I forgot to document this in the changelog.

Hey, I had to ask.  ;-)

> > > +void brw_end_read(struct brw_mutex *brw)
> > > +{
> >
> > I believe that you need smp_mb() here.
> 
> I don't understand why...
> 
> > The wake_up_all()'s memory barriers
> > do not suffice because some other reader might have awakened the writer
> > between this_cpu_dec() and wake_up_all().
> 
> But __wake_up(q) takes q->lock? And the same lock is taken by
> prepare_to_wait(), so how can the writer miss the result of _dec?

Suppose that the writer arrives and sees that the value of the counter
is zero, and thus never sleeps, and so is also not awakened?  Unless I
am missing something, there are no memory barriers in that case.

Which means that you also need an smp_mb() after the wait_event()
in the writer, now that I think on it.

> > > +	this_cpu_dec(*brw->read_ctr);
> > > +
> > > +	if (unlikely(atomic_read(&brw->write_ctr)))
> > > +		wake_up_all(&brw->write_waitq);
> > > +}
> >
> > Of course, it would be good to avoid smp_mb on the fast path.  Here is
> > one way to avoid it:
> >
> > void brw_end_read(struct brw_mutex *brw)
> > {
> > 	if (unlikely(atomic_read(&brw->write_ctr))) {
> > 		smp_mb();
> > 		this_cpu_dec(*brw->read_ctr);
> > 		wake_up_all(&brw->write_waitq);
> 
> Hmm... still can't understand.
> 
> It seems that this mb() is needed to ensure that brw_end_read() can't
> miss write_ctr != 0.
> 
> But we do not care unless the writer already does wait_event(). And
> before it does wait_event() it calls synchronize_sched() after it sets
> write_ctr != 0. Doesn't this mean that after that any preempt-disabled
> section must see write_ctr != 0 ?
> 
> This code actually checks write_ctr after preempt_disable + enable,
> but I think this doesn't matter?
> 
> Paul, most probably I misunderstood you. Could you spell please?

Let me try outlining the sequence of events that I am worried about...

1.	Task A invokes brw_start_read().  There is no writer, so it
	takes the fastpath.

2.	Task B invokes brw_start_write(), atomically increments
	&brw->write_ctr, and executes synchronize_sched().

3.	Task A invokes brw_end_read() and does this_cpu_dec().

4.	Task B invokes wait_event(), which invokes brw_read_ctr()
	and sees the result as zero.  Therefore, Task B does
	not sleep, does not acquire locks, and does not execute
	any memory barriers.  As a result, ordering is not
	guaranteed between Task A's read-side critical section
	and Task B's upcoming write-side critical section.

So I believe that you need smp_mb() in both brw_end_read() and
brw_start_write().

Sigh...  It is quite possible that you also need an smp_mb() in
brw_start_read(), but let's start with just the scenario above.

So, does the above scenario show a problem, or am I confused?

> > > +void brw_start_write(struct brw_mutex *brw)
> > > +{
> > > +	atomic_inc(&brw->write_ctr);
> > > +	synchronize_sched();
> > > +	/*
> > > +	 * Thereafter brw_*_read() must see write_ctr != 0,
> > > +	 * and we should see the result of __this_cpu_inc().
> > > +	 */
> > > +	wait_event(brw->write_waitq, brw_read_ctr(brw) == 0);
> >
> > This looks like it allows multiple writers to proceed concurrently.
> > They both increment, do a synchronize_sched(), do the wait_event(),
> > and then are both awakened by the last reader.
> 
> Yes. From the changelog:
> 
> 	Unlike rw_semaphore it allows multiple writers too,
> 	just "read" and "write" are mutually exclusive.

OK, color me blind!  ;-)

> > Was that the intent?  (The implementation of brw_end_write() makes
> > it look like it is in fact the intent.)
> 
> Please look at 2/2.
> 
> Multiple uprobe_register() or uprobe_unregister() can run at the
> same time to install/remove the system-wide breakpoint, and
> brw_start_write() is used to block dup_mmap() to avoid the race.
> But they do not block each other.

Ah, makes sense, thank you!

							Thanx, Paul

