Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab0FCSbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 14:31:06 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38657 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546Ab0FCSbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 14:31:03 -0400
Date: Thu, 3 Jun 2010 11:30:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] RCU: don't turn off lockdep when find suspicious
 rcu_dereference_check() usage
Message-ID: <20100603183040.GA2385@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <AANLkTinNygSdXsg3vAVRHttAMh6nX4tauNKn3XnfQC_x@mail.gmail.com>
 <20100602145653.GA2385@linux.vnet.ibm.com>
 <4C07743C.7030204@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C07743C.7030204@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 05:22:04PM +0800, Li Zefan wrote:
> Paul E. McKenney wrote:
> > On Tue, Jun 01, 2010 at 02:06:13PM +0100, Daniel J Blueman wrote:
> >> Hi Paul,
> >>
> >> With 2.6.35-rc1 and your patch in the context below, we still see
> >> "include/linux/cgroup.h:534 invoked rcu_dereference_check() without
> >> protection!", so need this additional patch:
> >>
> >> Acquire read-side RCU lock around task_group() calls, addressing
> >> "include/linux/cgroup.h:534 invoked rcu_dereference_check() without
> >> protection!" warning.
> >>
> >> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
> > 
> > Thank you, Daniel!  I have queued this for 2.6.35.
> > 
> > I had to apply the patch by hand due to line wrapping.  Could you please
> > check your email-agent settings?  This simple patch was no problem to
> > hand apply, but for a larger patch this process would be both tedious
> > and error prone.
> > 
> > 							Thanx, Paul
> > 
> >> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> >> index 217e4a9..50ec9ea 100644
> >> --- a/kernel/sched_fair.c
> >> +++ b/kernel/sched_fair.c
> >> @@ -1241,6 +1241,7 @@ static int wake_affine(struct sched_domain *sd,
> >> struct task_struct *p, int sync)
> >>  	 * effect of the currently running task from the load
> >>  	 * of the current CPU:
> >>  	 */
> >> +	rcu_read_lock();
> >>  	if (sync) {
> >>  		tg = task_group(current);
> >>  		weight = current->se.load.weight;
> >> @@ -1250,6 +1251,7 @@ static int wake_affine(struct sched_domain *sd,
> >> struct task_struct *p, int sync)
> >>  	}
> >>
> >>  	tg = task_group(p);
> >> +	rcu_read_unlock();
> 
> Hmmm.. I think it's not safe to access tg after rcu_read_unlock.

It does indeed look unsafe.  How about the following on top of this patch?

> >>  	weight = p->se.load.weight;
> >>
> >>  	imbalance = 100 + (sd->imbalance_pct - 100) / 2;

Seems worth reviewing the other uses of task_group():

1.	set_task_rq() -- only a runqueue and a sched_rt_entity leave
	the RCU read-side critical section.  Runqueues do persist.
	I don't claim to understand the sched_rt_entity life cycle.

2.	__sched_setscheduler() -- not clear to me that this one is
	protected to begin with.  If it is somehow correctly protected,
	it discards the RCU-protected pointer immediately, so is OK
	otherwise.

3.	cpu_cgroup_destroy() -- ditto.

4.	cpu_shares_read_u64() -- ditto.

5.	print_task() -- protected by rcu_read_lock() and discards the
	RCU-protected pointer immediately, so this one is OK.

Any task_group() experts able to weigh in on #2, #3, and #4?

							Thanx, Paul

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 50ec9ea..224ef98 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1251,7 +1251,6 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	}
 
 	tg = task_group(p);
-	rcu_read_unlock();
 	weight = p->se.load.weight;
 
 	imbalance = 100 + (sd->imbalance_pct - 100) / 2;
@@ -1268,6 +1267,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	balanced = !this_load ||
 		100*(this_load + effective_load(tg, this_cpu, weight, weight)) <=
 		imbalance*(load + effective_load(tg, prev_cpu, 0, weight));
+	rcu_read_unlock();
 
 	/*
 	 * If the currently running task will sleep within
