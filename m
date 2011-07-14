Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab1GNRcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 13:32:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53889 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141Ab1GNRcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 13:32:24 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=MwenTAR9eMQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pa3g6D_HNDuHUzRkWbMA:9 a=XaXIR2LGPqWJ16Sm8C8A:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: INFO: possible circular locking dependency detected
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110714170540.GE2349@linux.vnet.ibm.com>
References: <20110714144946.GA3354@swordfish.minsk.epam.com>
	 <1310662707.27864.38.camel@gandalf.stny.rr.com>
	 <1310662929.27864.40.camel@gandalf.stny.rr.com>
	 <20110714170540.GE2349@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 14 Jul 2011 13:32:22 -0400
Message-ID: <1310664742.27864.45.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-14 at 10:05 -0700, Paul E. McKenney wrote:
> On Thu, Jul 14, 2011 at 01:02:09PM -0400, Steven Rostedt wrote:
> > On Thu, 2011-07-14 at 12:58 -0400, Steven Rostedt wrote:
> > 
> > > void __rcu_read_unlock(void)
> > > {
> > > 	struct task_struct *t = current;
> > > 
> > > 	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutree.c */
> > > 	--t->rcu_read_lock_nesting;
> > > 	barrier();  /* decrement before load of ->rcu_read_unlock_special */
> > > 	if (t->rcu_read_lock_nesting == 0 &&
> > > 	    unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
> > > 		rcu_read_unlock_special(t);
> > > 
> > > Thus the question is, how did we get rcu_read_unlock_special set here?
> > 
> > Looks like another process could set this with:
> > 
> > static int rcu_boost(struct rcu_node *rnp)
> > {
> > 	[...]
> > 	t = container_of(tb, struct task_struct, rcu_node_entry);
> > 	rt_mutex_init_proxy_locked(&mtx, t);
> > 	t->rcu_boost_mutex = &mtx;
> > 	t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BOOSTED;
> 
> But only if that task was preempted while in the RCU read-side critical
> section that resulted in the call to rcu_read_unlock_special(), which
> should not happen if the task has irqs disabled for the duration of that
> RCU read-side critical section, right?
> 

static void rcu_read_unlock_special(struct task_struct *t)
{
	[...]
	special = t->rcu_read_unlock_special;   (A)
	[...]

		for (;;) {			(B)
			rnp = t->rcu_blocked_node;
			raw_spin_lock(&rnp->lock);  /* irqs already disabled. */
			if (rnp == t->rcu_blocked_node)
				break;
			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
		}
	[...]
		list_del_init(&t->rcu_node_entry);
	[...]
		if (empty)
			raw_spin_unlock_irqrestore(&rnp->lock, flags);
		else
			rcu_report_unblock_qs_rnp(rnp, flags);

		/* Unboost if we were boosted. */
		if (special & RCU_READ_UNLOCK_BOOSTED) {
			t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BOOSTED;
			rt_mutex_unlock(t->rcu_boost_mutex);
			t->rcu_boost_mutex = NULL;
		}


Now what happens if between (A) and (B) the kthread wakes up and calls
rc_boost()?

static int rcu_boost(struct rcu_node *rnp)
{
	[...]
	raw_spin_lock_irqsave(&rnp->lock, flags);
	[...]
	t = container_of(tb, struct task_struct, rcu_node_entry);
	[...]
	t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BOOSTED;
	raw_spin_unlock_irqrestore(&rnp->lock, flags);


Seems that we could have RCU_READ_UNLOCK_BOOSTED set, and never get
cleared, because rcu_read_unlock_special() doesn't look at the flags
directly, but at a local variable. The next rcu_read_unlock() will now
see this flag set!

-- Steve


