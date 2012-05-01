Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657Ab2EAXZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 19:25:28 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:38643 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756805Ab2EAXZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 19:25:26 -0400
Date: Tue, 1 May 2012 16:25:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Hugh Dickins <hughd@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: linux-next ppc64: RCU mods cause __might_sleep BUGs
Message-ID: <20120501232516.GR2441@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LSU.2.00.1204301451270.2986@eggly.anvils>
 <1335832418.20866.95.camel@pasglop>
 <alpine.LSU.2.00.1204302142310.27208@eggly.anvils>
 <20120501142208.GA2441@linux.vnet.ibm.com>
 <alpine.LSU.2.00.1205011410360.28232@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1205011410360.28232@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050123-2398-0000-0000-00000645F466
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 02:42:02PM -0700, Hugh Dickins wrote:
> On Tue, 1 May 2012, Paul E. McKenney wrote:
> > On Mon, Apr 30, 2012 at 10:10:06PM -0700, Hugh Dickins wrote:
> > > On Tue, 1 May 2012, Benjamin Herrenschmidt wrote:
> > > > On Mon, 2012-04-30 at 15:37 -0700, Hugh Dickins wrote:
> > > > > 
> > > > > BUG: sleeping function called from invalid context at include/linux/pagemap.h:354
> > > > > in_atomic(): 0, irqs_disabled(): 0, pid: 6886, name: cc1
> > > > > Call Trace:
> > > > > [c0000001a99f78e0] [c00000000000f34c] .show_stack+0x6c/0x16c (unreliable)
> > > > > [c0000001a99f7990] [c000000000077b40] .__might_sleep+0x11c/0x134
> > > > > [c0000001a99f7a10] [c0000000000c6228] .filemap_fault+0x1fc/0x494
> > > > > [c0000001a99f7af0] [c0000000000e7c9c] .__do_fault+0x120/0x684
> > > > > [c0000001a99f7c00] [c000000000025790] .do_page_fault+0x458/0x664
> > > > > [c0000001a99f7e30] [c000000000005868] handle_page_fault+0x10/0x30
> > > > > 
> 
> > My guess is that the following happened:
> > 
> > 1.	Task A is running, with its state in RCU's per-CPU variables.
> > 
> > 2.	Task A creates Task B and switches to it, but without invoking
> > 	schedule_tail() or schedule().  Task B is now running, with
> > 	Task A's state in RCU's per-CPU variables.
> > 
> > 3.	Task B switches context, saving Task A's per-CPU RCU variables
> > 	(with modifications by Task B, just for fun).
> > 
> > 4.	Task A starts running again, and loads obsolete versions of its
> > 	per-CPU RCU variables.  This can cause rcu_read_unlock_do_special()
> > 	to be invoked at inappropriate times, which could cause
> > 	pretty arbitrary misbehavior.
> > 
> > 5.	Mismatched values for the RCU read-side nesting could cause
> > 	the read-side critical section to complete prematurely, which
> > 	could cause all manner of mischief.  However, I would expect
> > 	this to trigger the WARN_ON_ONCE() in __rcu_read_unlock().
> > 
> > Hmmm...
> 
> I didn't find anything corresponding to that under arch/powerpc.

Nor did I.  :-(

> There is something I found, that I had high hopes for, but sadly no,
> it does not fix it.  I may be wrong, it's a long time since I thought
> about what happens in fork().  But I believe the rcu_switch_from(prev)
> you added to schedule_tail() is bogus: doesn't schedule_tail() more or
> less amount to a jump into schedule(), for the child to be as if it's
> emerging from the switch_to() in schedule()?
> 
> So I think the rcu_switch_from(prev) has already been done by the prev
> task on the cpu, as it goes into switch_to() in schedule().  So at best
> you're duplicating that in schedule_tail(), and at worst (I don't know
> if the prev task can get far enough away for this to matter) you're
> messing with its state.  Probably difficult to do any harm (those fields
> don't matter while it's on another cpu, and it has to get on another cpu
> for them to change), but it does look wrong to me.

I do believe that you are correct.  /me wonders if it was really such
a good idea to tie RCU this closely to the scheduler...

I also agree that the chance of error is small.  The parent would have
to be blocked for the child to have any probability of doing harm,
but we need the probability to be zero, which it does not appear to be.

I will semi-revert this change as you suggest.

> But commenting out that line did not fix my issues.  And if you agree,
> you'll probably prefer, not to comment out the line, but revert back to
> rcu_switch_from(void) and just add the rcu_switch_to() to schedule_tail().
> 
> Something else that I noticed in comments on rcu_switch_from() in
> sched.h (er, is sched.h really the right place for this code?): it says
> "if rcu_read_unlock_special is zero, then rcu_read_lock_nesting must
> also be zero" - shouldn't that say "non-zero" in each case?

No, but the variables should be reversed.  It should read "Both
cases rely on the fact that if rcu_read_lock_nesting is zero, then
rcu_read_unlock_special must also be zero."  Here are the two cases:

1.	rcu_read_lock_nesting is zero:  Then rcu_read_unlock_special
	must also be zero, so there is no way to get to the
	rcu_read_unlock_do_special() function.  A scheduling-clock
	interrupt might later set one of the rcu_read_unlock_special
	bits, but only RCU_READ_UNLOCK_BLOCKED, which is OK because
	rcu_read_unlock_do_special() does not mess with the scheduler
	in this case.

2.	rcu_read_lock_nesting is non-zero: Then the task is blocking
	within an RCU read-side critical section, so none of the
	scheduler's or architecture's read-side critical sections
	can have the outermost rcu_read_unlock(), so the
	rcu_read_unlock_do_special() function will not be invoked
	in the first place.

Thank you for catching this!

> I must turn away from this right now, and come back to it later.

Thank you very much for all your help with this!

							Thanx, Paul

