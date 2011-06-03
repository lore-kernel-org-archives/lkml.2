Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab1FCQyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 12:54:24 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45748 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633Ab1FCQyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 12:54:23 -0400
Date: Fri, 3 Jun 2011 09:54:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, Jens Axboe <jaxboe@fusionio.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Mysterious CFQ crash and RCU
Message-ID: <20110603165417.GA7481@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110519222404.GG12600@redhat.com>
 <20110521210013.GJ2271@linux.vnet.ibm.com>
 <20110523152141.GB4019@redhat.com>
 <20110523153848.GC2310@linux.vnet.ibm.com>
 <1306401337.27271.3.camel@t41.thuisdomein>
 <20110603050724.GB2304@linux.vnet.ibm.com>
 <20110603134514.GA31057@redhat.com>
 <20110603153344.GB2333@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110603153344.GB2333@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 08:33:44AM -0700, Paul E. McKenney wrote:
> On Fri, Jun 03, 2011 at 09:45:14AM -0400, Vivek Goyal wrote:
> > On Thu, Jun 02, 2011 at 10:07:24PM -0700, Paul E. McKenney wrote:
> > 
> > [..]
> > > > Thu May 26 10:47:20 CEST 2011
> > > > /sys/kernel/debug/rcu/rcugp:
> > > > rcu_sched: completed=682249  gpnum=682250
> > > 
> > > 15 more seconds, a few thousand more grace periods.  About 500 grace
> > > periods per second, which is quite reasonable on a single-CPU system.
> > 
> > PaulB mentioned that crash happened at May 26 10:47:07. I am wondering
> > how are we able to sample the data after the crash. I am assuming
> > that above data gives information only before crash and does not
> > tell us anything about what happened just before crash. What am I missing.
> > 
> > PaulM, in one of the mails you had mentioned that one could print
> > context switch id to make sure we did not block in rcu section. Would
> > you have quick pointer where is context switch id stored. May be
> > I can write a small patch for PaulB.
> 
> From what I can see, the task_struct nvcsw and nivcsw fields should do
> it, though I am not seeing where these are incremented.

And Milton Miller pointed out that schedule() takes the address of
these fields in a local pointer "switch_count" and then increments
through this pointer.  So there you have it.

> So if these don't do what you need, the following (untested but trivial)
> patch will provide an rcu_switch_count in the task structure.

And he also noted that (nvcsw+nivcsw) is incremented only when context
switches from one task to another, while my patch below would count
every call to schedule(), whether or not a context switch occurs.

Either approach should work.

							Thanx, Paul

> ------------------------------------------------------------------------
> 
> rcu: add diagnostic per-task context-switch count
> 
> Note that this is also incremented by softirqs.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 2a8621c..5ef22e2 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1261,6 +1261,7 @@ struct task_struct {
>  #ifdef CONFIG_RCU_BOOST
>  	struct rt_mutex *rcu_boost_mutex;
>  #endif /* #ifdef CONFIG_RCU_BOOST */
> +	unsigned long rcu_switch_count;
>  
>  #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
>  	struct sched_info sched_info;
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 89419ff..080c6eb 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -154,6 +154,7 @@ void rcu_bh_qs(int cpu)
>   */
>  void rcu_note_context_switch(int cpu)
>  {
> +	current->rcu_switch_count++;
>  	rcu_sched_qs(cpu);
>  	rcu_preempt_note_context_switch(cpu);
>  }
