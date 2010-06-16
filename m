Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431Ab0FPXEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 19:04:46 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41021 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755354Ab0FPXEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 19:04:45 -0400
Date: Wed, 16 Jun 2010 16:04:41 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: [PATCH tip/core/urgent 1/3] rcu: fix lockdep splat in
 wake_affine()
Message-ID: <20100616230441.GK2457@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100615222923.GA14571@linux.vnet.ibm.com>
 <1276640983-14641-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1276669391.1745.594.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276669391.1745.594.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 08:23:11AM +0200, Peter Zijlstra wrote:
> On Tue, 2010-06-15 at 15:29 -0700, Paul E. McKenney wrote:
> > From: Daniel J Blueman <daniel.blueman@gmail.com>
> > 
> > With 2.6.35-rc1 and your patch in the context below, we still see
> > "include/linux/cgroup.h:534 invoked rcu_dereference_check() without
> > protection!", so need this additional patch:
> > 
> > Acquire read-side RCU lock around task_group() calls, addressing
> > "include/linux/cgroup.h:534 invoked rcu_dereference_check() without
> > protection!" warning.
> 
> Uhm,. this is all just slapping in rcu_read_lock() to make the warning
> go away, without explanation of what and why.
> 
> Its not obvious what the races is, nor how its handled.

Please let me know if my explanation in a recent email covers this.
If so, I will add it to the commit log.  If not, well, back to the
drawing board, I guess.  ;-)

							Thanx, Paul

> > Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/sched_fair.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> > index eed35ed..ca56133 100644
> > --- a/kernel/sched_fair.c
> > +++ b/kernel/sched_fair.c
> > @@ -1240,6 +1240,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
> >  	 * effect of the currently running task from the load
> >  	 * of the current CPU:
> >  	 */
> > +	rcu_read_lock();
> >  	if (sync) {
> >  		tg = task_group(current);
> >  		weight = current->se.load.weight;
> > @@ -1249,6 +1250,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
> >  	}
> >  
> >  	tg = task_group(p);
> > +	rcu_read_unlock();
> >  	weight = p->se.load.weight;
> >  
> >  	/*
> 
> 
