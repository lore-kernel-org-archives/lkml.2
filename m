Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066Ab2IEBEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 21:04:51 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:32797 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758047Ab2IEBEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 21:04:33 -0400
Date: Tue, 4 Sep 2012 18:04:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Subject: Re: [PATCH tip/core/rcu 01/26] rcu: New rcu_user_enter() and
 rcu_user_exit() APIs
Message-ID: <20120905010422.GC2593@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120830210520.GA2824@linux.vnet.ibm.com>
 <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120831190733.GP4259@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120831190733.GP4259@jtriplet-mobl1>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090501-6148-0000-0000-00000946ED35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 12:07:33PM -0700, Josh Triplett wrote:
> On Thu, Aug 30, 2012 at 02:05:18PM -0700, Paul E. McKenney wrote:
> > From: Frederic Weisbecker <fweisbec@gmail.com>
> > 
> > RCU currently insists that only idle tasks can enter RCU idle mode, which
> > prohibits an adaptive tickless kernel (AKA nohz cpusets), which in turn
> > would mean that usermode execution would always take scheduling-clock
> > interrupts, even when there is only one task runnable on the CPU in
> > question.
> > 
> > This commit therefore adds rcu_user_enter() and rcu_user_exit(), which
> > allow non-idle tasks to enter RCU idle mode.  These are quite similar
> > to rcu_idle_enter() and rcu_idle_exit(), respectively, except that they
> > omit the idle-task checks.
> > 
> > [ Updated to use "user" flag rather than separate check functions. ]
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Alessio Igor Bogani <abogani@kernel.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Avi Kivity <avi@redhat.com>
> > Cc: Chris Metcalf <cmetcalf@tilera.com>
> > Cc: Christoph Lameter <cl@linux.com>
> > Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> > Cc: Geoff Levand <geoff@infradead.org>
> > Cc: Gilad Ben Yossef <gilad@benyossef.com>
> > Cc: Hakan Akkan <hakanakkan@gmail.com>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Kevin Hilman <khilman@ti.com>
> > Cc: Max Krasnyansky <maxk@qualcomm.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Stephen Hemminger <shemminger@vyatta.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> 
> A few suggestions below: an optional microoptimization and some bugfixes.
> With the bugfixes, and with or without the microoptimization:

Good catches!  Due to conflicts with later commits, I added these as
a separate commit.

							Thanx, Paul

> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> [...]
> > -static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
> > +static void rcu_eqs_enter_common(struct rcu_dynticks *rdtp, long long oldval,
> > +				bool user)
> >  {
> >  	trace_rcu_dyntick("Start", oldval, 0);
> > -	if (!is_idle_task(current)) {
> > +	if (!is_idle_task(current) && !user) {
> 
> Microoptimization: putting the !user check first (here and in the exit
> function) would allow the compiler to partially inline rcu_eqs_*_common
> into the two trivial wrappers and constant-fold away the test for !user.
> 
> > +void rcu_idle_enter(void)
> > +{
> > +	rcu_eqs_enter(0);
> > +}
> 
> s/0/false/
> 
> > +void rcu_user_enter(void)
> > +{
> > +	rcu_eqs_enter(1);
> > +}
> 
> s/1/true/
> 
> > -static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
> > +static void rcu_eqs_exit_common(struct rcu_dynticks *rdtp, long long oldval,
> > +			       int user)
> >  {
> >  	smp_mb__before_atomic_inc();  /* Force ordering w/previous sojourn. */
> >  	atomic_inc(&rdtp->dynticks);
> > @@ -464,7 +490,7 @@ static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
> >  	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
> >  	rcu_cleanup_after_idle(smp_processor_id());
> >  	trace_rcu_dyntick("End", oldval, rdtp->dynticks_nesting);
> > -	if (!is_idle_task(current)) {
> > +	if (!is_idle_task(current) && !user) {
> 
> Same micro-optimization as the enter function.
> 
> > +void rcu_idle_exit(void)
> > +{
> > +	rcu_eqs_exit(0);
> > +}
> 
> s/0/false/
> 
> > +void rcu_user_exit(void)
> > +{
> > +	rcu_eqs_exit(1);
> > +}
> 
> s/1/true/
> 
> > @@ -539,7 +586,7 @@ void rcu_irq_enter(void)
> >  	if (oldval)
> >  		trace_rcu_dyntick("++=", oldval, rdtp->dynticks_nesting);
> >  	else
> > -		rcu_idle_exit_common(rdtp, oldval);
> > +		rcu_eqs_exit_common(rdtp, oldval, 1);
> 
> s/1/true/, and likewise in rcu_irq_exit.
> 
> - Josh Triplett
> 

