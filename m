Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab2EVME6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 08:04:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:54094 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab2EVME4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 08:04:56 -0400
Message-ID: <1337688268.9698.29.camel@twins>
Subject: Re: [tip:sched/numa] sched/numa: Introduce sys_numa_{t,m}bind()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        pjt@google.com, cl@linux.com, riel@redhat.com, bharata.rao@gmail.com,
        akpm@linux-foundation.org, Lee.Schermerhorn@hp.com,
        aarcange@redhat.com, danms@us.ibm.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Date: Tue, 22 May 2012 14:04:28 +0200
In-Reply-To: <alpine.DEB.2.00.1205211932350.13682@chino.kir.corp.google.com>
References: <tip-nf7brf1b88w0ojwuf689xeet@git.kernel.org>
	 <alpine.DEB.2.00.1205191922250.24674@chino.kir.corp.google.com>
	 <20120521084046.GB31407@gmail.com>
	 <alpine.DEB.2.00.1205211914100.13682@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.1205211932350.13682@chino.kir.corp.google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-21 at 19:42 -0700, David Rientjes wrote:
> On Mon, 21 May 2012, David Rientjes wrote:
> 
> > [    0.602181] divide error: 0000 [#1] SMP 
> > [    0.606159] CPU 0 
> > [    0.608003] Modules linked in:
> > [    0.611266] 
> > [    0.612767] Pid: 1, comm: swapper/0 Not tainted 3.4.0 #1
> > [    0.620912] RIP: 0010:[<ffffffff810af9ab>]  [<ffffffff810af9ab>] update_sd_lb_stats+0x38b/0x740
> 
> This is 
> 
> 4ec4412e kernel/sched/fair.c 3876)      if (local_group) {
> bd939f45 kernel/sched/fair.c 3877)              if (env->idle != CPU_NEWLY_IDLE) {
> 04f733b4 kernel/sched/fair.c 3878)                      if (balance_cpu != env->dst_cpu) {
> 4ec4412e kernel/sched/fair.c 3879)                              *balance = 0;
> 4ec4412e kernel/sched/fair.c 3880)                              return;
> 4ec4412e kernel/sched/fair.c 3881)                      }
> bd939f45 kernel/sched/fair.c 3882)                      update_group_power(env->sd, env->dst_cpu);
> 4ec4412e kernel/sched/fair.c 3883)              } else if (time_after_eq(jiffies, group->sgp->next_update))
> bd939f45 kernel/sched/fair.c 3884)                      update_group_power(env->sd, env->dst_cpu);
> 1e3c88bd kernel/sched_fair.c 3885)      }
> 1e3c88bd kernel/sched_fair.c 3886) 
> 1e3c88bd kernel/sched_fair.c 3887)      /* Adjust by relative CPU power of the group */
> 9c3f75cb kernel/sched_fair.c 3888)      sgs->avg_load = (sgs->group_load*SCHED_POWER_SCALE) / group->sgp->power;
> 
> the divide of group->sgp->power.  This doesn't happen when reverting back 
> to sched/urgent at 30b4e9eb783d ("sched: Fix KVM and ia64 boot crash due 
> to sched_groups circular linked list assumption").  Let me know if you'd 
> like a bisect if the problem isn't immediately obvious.


I'm fairly sure you'll hit cb83b629b with your bisect (I've got one more
report on this).

So the code in build_sched_domains() initializes the group->sgp->power
stuff through init_sched_groups_power(), which ends up calling
update_cpu_power() for every individual cpu and update_group_power() for
groups.

Now update_cpu_power() should ensure ->power isn't ever 0 -- it sets it
to 1 in that case, update_group_power() computes a straight sum of
power, which being assumed are all >0 should also result in >0.

Only after we initialize the power in build_sched_domains() do we
install the domains, so we should never hit the above.

Now clearly we do so there's a hole somewhere.. let me carefully read
all that.

The below appears to contain a bug, not sure its the one you're
triggering, but who knows. Lemme stare more.

---
Subject: sched: Make sure to not re-read variables after validation

We could re-read rq->rt_avg after we validated it was smaller than
total, invalidating the check and resulting in an unintended negative.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched/fair.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index de49ed5..54dca4d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3697,15 +3697,22 @@ unsigned long __weak arch_scale_smt_power(struct sched_domain *sd, int cpu)
 unsigned long scale_rt_power(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
-	u64 total, available;
+	u64 total, available, age_stamp, avg;
 
-	total = sched_avg_period() + (rq->clock - rq->age_stamp);
+	/*
+	 * Since we're reading these variables without serialization make sure
+	 * we read them once before doing sanity checks on them.
+	 */
+	age_stamp = ACCESS_ONCE(rq->age_stamp);
+	avg = ACCESS_ONCE(rq->rt_avg);
+
+	total = sched_avg_period() + (rq->clock - age_stamp);
 
-	if (unlikely(total < rq->rt_avg)) {
+	if (unlikely(total < avg)) {
 		/* Ensures that power won't end up being negative */
 		available = 0;
 	} else {
-		available = total - rq->rt_avg;
+		available = total - avg;
 	}
 
 	if (unlikely((s64)total < SCHED_POWER_SCALE))

