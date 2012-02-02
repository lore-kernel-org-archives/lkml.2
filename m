Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab2BBQVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 11:21:18 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:33913 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab2BBQVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 11:21:17 -0500
Date: Thu, 2 Feb 2012 08:20:17 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 03/41] rcu: Add lockdep-RCU checks for
 simple self-deadlock
Message-ID: <20120202162017.GH2518@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120202005553.GD29058@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202005553.GD29058@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020216-2398-0000-0000-000003E2996B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 04:55:54PM -0800, Josh Triplett wrote:
> On Wed, Feb 01, 2012 at 11:41:21AM -0800, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > It is illegal to have a grace period within a same-flavor RCU read-side
> > critical section, so this commit adds lockdep-RCU checks to splat when
> > such abuse is encountered.  This commit does not detect more elaborate
> > RCU deadlock situations.  These situations might be a job for lockdep
> > enhancements.
> 
> Since doing so also violates the prohibition on blocking within an RCU
> read-side critical section, wouldn't it suffice to call might_sleep() or
> equivalent, which also detects other problems?  (Obviously this doesn't
> apply to SRCU, but it applies to the other variants of RCU.)

Yes, but...

The advantage of the lockdep-RCU splat is that it gives you a better
hint as to where the RCU read-side critical section was entered, which
is very helpful when tracking these down, especially when they are
intermittent.

On of the downsides of the Linux kernel community being more RCU-savvy
is that the errors they now tend to commit are more complex.  ;-)

And yes, I should also well check for the other variants of RCU read-side
critical section (other than RCU).  Done.

I also glued the strings together to promote grepability as you suggest
later.  (But I leave it to you to get checkpatch.pl upgraded -- it currently
warns about long lines, but not about strings split across lines.)

> > --- a/kernel/rcutiny.c
> > +++ b/kernel/rcutiny.c
> > @@ -319,6 +319,9 @@ static void rcu_process_callbacks(struct softirq_action *unused)
> >   */
> >  void synchronize_sched(void)
> >  {
> > +	rcu_lockdep_assert(!lock_is_held(&rcu_sched_lock_map),
> > +			   "Illegal grace period in RCU read-side "
> > +			   "critical section");
> 
> This message doesn't seem entirely obvious to me.  A grace period didn't
> occur; a synchronize call did, which tried to request a grace period
> that can never happen.

I suppose I might as well make it consistent with the other messages.  ;-)

> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -1816,6 +1816,9 @@ EXPORT_SYMBOL_GPL(call_rcu_bh);
> >   */
> >  void synchronize_sched(void)
> >  {
> > +	rcu_lockdep_assert(!lock_is_held(&rcu_sched_lock_map),
> > +			   "Illegal synchronize_sched() in RCU-sched "
> > +			   "read-side critical section");
> >  	if (rcu_blocking_is_gp())
> >  		return;
> >  	wait_rcu_gp(call_rcu_sched);
> > @@ -1833,6 +1836,9 @@ EXPORT_SYMBOL_GPL(synchronize_sched);
> >   */
> >  void synchronize_rcu_bh(void)
> >  {
> > +	rcu_lockdep_assert(!lock_is_held(&rcu_bh_lock_map),
> > +			   "Illegal synchronize_sched() in RCU-bh "
> > +			   "read-side critical section");
> 
> Copy-paste problem here: this should say synchronize_sched_bh.  (Or
> perhaps it should say __func__. :) )

Fixed, but will pass on __func__ for the moment.  Cool though it might
be to exercise varargs.  ;-)

> > --- a/kernel/srcu.c
> > +++ b/kernel/srcu.c
> > @@ -172,6 +172,10 @@ static void __synchronize_srcu(struct srcu_struct *sp, void (*sync_func)(void))
> >  {
> >  	int idx;
> >  
> > +	rcu_lockdep_assert(!lock_is_held(&sp->dep_map),
> > +			   "Illegal SRCU grace period in same-type "
> > +			   "SRCU read-side critical section");
> 
> Same issue with the message: a grace period didn't occur, and it never
> will; a call to synchronize_srcu requesting a grace period occurred.

Good catch, fixed!

							Thanx, Paul

