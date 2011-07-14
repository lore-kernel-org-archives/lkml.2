Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab1GNRGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 13:06:08 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44750 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932101Ab1GNRGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 13:06:07 -0400
Date: Thu, 14 Jul 2011 10:05:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: INFO: possible circular locking dependency detected
Message-ID: <20110714170540.GE2349@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110714144946.GA3354@swordfish.minsk.epam.com>
 <1310662707.27864.38.camel@gandalf.stny.rr.com>
 <1310662929.27864.40.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310662929.27864.40.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 01:02:09PM -0400, Steven Rostedt wrote:
> On Thu, 2011-07-14 at 12:58 -0400, Steven Rostedt wrote:
> 
> > void __rcu_read_unlock(void)
> > {
> > 	struct task_struct *t = current;
> > 
> > 	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutree.c */
> > 	--t->rcu_read_lock_nesting;
> > 	barrier();  /* decrement before load of ->rcu_read_unlock_special */
> > 	if (t->rcu_read_lock_nesting == 0 &&
> > 	    unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
> > 		rcu_read_unlock_special(t);
> > 
> > Thus the question is, how did we get rcu_read_unlock_special set here?
> 
> Looks like another process could set this with:
> 
> static int rcu_boost(struct rcu_node *rnp)
> {
> 	[...]
> 	t = container_of(tb, struct task_struct, rcu_node_entry);
> 	rt_mutex_init_proxy_locked(&mtx, t);
> 	t->rcu_boost_mutex = &mtx;
> 	t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BOOSTED;

But only if that task was preempted while in the RCU read-side critical
section that resulted in the call to rcu_read_unlock_special(), which
should not happen if the task has irqs disabled for the duration of that
RCU read-side critical section, right?

							Thanx, Paul
