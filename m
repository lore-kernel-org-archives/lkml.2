Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863Ab2IDWrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 18:47:10 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:41176 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757824Ab2IDWrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 18:47:08 -0400
Date: Tue, 4 Sep 2012 15:46:59 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 09/15] rcu: Avoid
 rcu_print_detail_task_stall_rnp() segfault
Message-ID: <20120904224659.GT2593@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346352988-32444-9-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120831181917.GG4259@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120831181917.GG4259@jtriplet-mobl1>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090422-7408-0000-0000-000008305995
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 11:19:17AM -0700, Josh Triplett wrote:
> On Thu, Aug 30, 2012 at 11:56:22AM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > The rcu_print_detail_task_stall_rnp() function invokes
> > rcu_preempt_blocked_readers_cgp() to verify that there are some preempted
> > RCU readers blocking the current grace period outside of the protection
> > of the rcu_node structure's ->lock.  This means that the last blocked
> > reader might exit its RCU read-side critical section and remove itself
> > from the ->blkd_tasks list before the ->lock is acquired, resulting in
> > a segmentation fault when the subsequent code attempts to dereference
> > the now-NULL gp_tasks pointer.
> > 
> > This commit therefore moves the test under the lock.  This will not
> > have measurable effect on lock contention because this code is invoked
> > only when printing RCU CPU stall warnings, in other words, in the common
> > case, never.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/rcutree_plugin.h |    6 ++++--
> >  1 files changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> > index 139a803..c02dc1d 100644
> > --- a/kernel/rcutree_plugin.h
> > +++ b/kernel/rcutree_plugin.h
> > @@ -422,9 +422,11 @@ static void rcu_print_detail_task_stall_rnp(struct rcu_node *rnp)
> >  	unsigned long flags;
> >  	struct task_struct *t;
> >  
> > -	if (!rcu_preempt_blocked_readers_cgp(rnp))
> > -		return;
> >  	raw_spin_lock_irqsave(&rnp->lock, flags);
> > +	if (!rcu_preempt_blocked_readers_cgp(rnp)) {
> > +		raw_spin_unlock_irqrestore(&rnp->lock, flags);
> > +		return;
> > +	}
> >  	t = list_entry(rnp->gp_tasks,
> >  		       struct task_struct, rcu_node_entry);
> >  	list_for_each_entry_continue(t, &rnp->blkd_tasks, rcu_node_entry)
> 
> Given the small number of lines of code inside the critical section
> here, I think this would look clearer without the early return and
> duplicate lock release:
> 
> 	raw_spin_lock_irqsave(&rnp->lock, flags);
> 	if (rcu_preempt_blocked_readers_cgp(rnp)) {
> 		...
> 	}
> 	raw_spin_unlock_irqrestore(&rnp->lock, flags);

You might well be right, but doing that gets me another line longer
than 80 characters.

Hey, I have an excuse -- I actually spent a significant fraction of
my career using punched cards.  ;-)

							Thanx, Paul

