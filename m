Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551Ab2FOVVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 17:21:32 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:57676 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab2FOVVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 17:21:30 -0400
Date: Fri, 15 Jun 2012 14:19:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 6/6] rcu: Make rcutorture fakewriters invoke
 rcu_barrier()
Message-ID: <20120615211902.GK2389@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120615185725.GA25163@linux.vnet.ibm.com>
 <1339786674-25265-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1339786674-25265-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120615203705.GE31184@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615203705.GE31184@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061521-3270-0000-0000-0000073776BD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 01:37:05PM -0700, Josh Triplett wrote:
> On Fri, Jun 15, 2012 at 11:57:54AM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> > 
> > The current rcutorture rcu_barrier() testing never intentionally runs
> > more than one instance of rcu_barrier() at a given time.  This fails
> > to test the the shiny new concurrency features of rcu_barrier().  This
> > commit therefore modifies the rcutorture fakewriter kthread to randomly
> > invoke rcu_barrier() rather than the usual synchronize_rcu().
> > 
> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/rcutorture.c |    6 +++++-
> >  1 files changed, 5 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> > index 54a3745..dfb4e20 100644
> > --- a/kernel/rcutorture.c
> > +++ b/kernel/rcutorture.c
> > @@ -1025,7 +1025,11 @@ rcu_torture_fakewriter(void *arg)
> >  	do {
> >  		schedule_timeout_uninterruptible(1 + rcu_random(&rand)%10);
> >  		udelay(rcu_random(&rand) & 0x3ff);
> > -		cur_ops->sync();
> > +		if (cur_ops->cb_barrier != NULL &&
> > +		    rcu_random(&rand) % (NR_CPUS * 8) == 0)
> 
> NR_CPUS seems like an odd choice here.  I assume you want to control for
> having many rcu_torture_fakewriter threads, and aim for the same average
> rate of barrier calls across the whole set of threads regardless of the
> number of threads.  However, NR_CPUS does not accurately reflect either
> the number of fakewriter threads (which a user can set arbitrarily) or
> the number of CPUs currently on the system (since NR_CPUS represents the
> compile-time limit).  I'd suggest changing this to use the actual number
> of fakewriter threads, which rcutorture knows at start time.

Indeed, this should use the number of online CPUs.  Which should be
easy to compute, will fix.

Also will fix the commit message as suggested, and apply your reviewed-bys
as specified.

							Thanx, Paul

