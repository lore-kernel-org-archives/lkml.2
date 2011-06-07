Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab1FGSLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:11:37 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:50951 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425Ab1FGSLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:11:36 -0400
Date: Tue, 7 Jun 2011 11:11:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: remove rcu_read_lock from wake_affine
Message-ID: <20110607181131.GD2286@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110607101251.777.34547.stgit@IBM-009124035060.in.ibm.com>
 <1307442411.2322.246.camel@twins>
 <20110607172606.GA2286@linux.vnet.ibm.com>
 <1307467763.2322.282.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307467763.2322.282.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 07:29:23PM +0200, Peter Zijlstra wrote:
> On Tue, 2011-06-07 at 10:26 -0700, Paul E. McKenney wrote:
> > 
> > Nikunj, one such approach is is "WARN_ON_ONCE(!rcu_read_lock_held())".
> > 
> > This will complain if this function is called without an rcu_read_lock()
> > in effect, but only if CONFIG_PROVE_RCU=y.
> 
> rcu_lockdep_assert(rcu_read_lock_held()) would be nicer,

Good point!

>                                                          however, since
> the below:
> 
> > > >  static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
> > > >  {
> > > >     s64 this_load, load;
> > > > @@ -1481,7 +1482,6 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
> > > >      * effect of the currently running task from the load
> > > >      * of the current CPU:
> > > >      */
> > > > -   rcu_read_lock();
> > > >     if (sync) {
> > > >             tg = task_group(current);
> > > >             weight = current->se.load.weight; 
> 
> task_group() has an rcu_dereference_check() in, its really not needed,
> the thing will yell if we get this wrong.

Fair enough!  The main reason for adding it at this level as well is
to prevent people from "fixing" splats by adding rcu_read_lock() and
rcu_read_unlock() at this level.  But you would see any such patch, so
such a "fix" would not get far.  ;-)

							Thanx, Paul
