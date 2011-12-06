Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab1LFTWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:22:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:34475 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102Ab1LFTWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:22:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,308,1320652800"; 
   d="scan'208";a="99294205"
Subject: Re: [patch v3 1/6] sched, nohz: introduce nohz_flags in the struct
 rq
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Venki Pallipadi <venki@google.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>,
        "Shi, Alex" <alex.shi@intel.com>
Date: Tue, 06 Dec 2011 11:26:34 -0800
In-Reply-To: <20111206121401.GA12083@linux.vnet.ibm.com>
References: <20111202010731.344451602@sbsiddha-desk.sc.intel.com>
	 <20111202010832.499438999@sbsiddha-desk.sc.intel.com>
	 <20111206121401.GA12083@linux.vnet.ibm.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1323199594.1984.18.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-06 at 04:14 -0800, Srivatsa Vaddagiri wrote:
> * Suresh Siddha <suresh.b.siddha@intel.com> [2011-12-01 17:07:32]:
> 
> > @@ -4866,18 +4866,15 @@ static void nohz_balancer_kick(int cpu)
> >  			return;
> >  	}
> > 
> > -	if (!cpu_rq(ilb_cpu)->nohz_balance_kick) {
> > -		cpu_rq(ilb_cpu)->nohz_balance_kick = 1;
> > -
> > -		smp_mb();
> > -		/*
> > -		 * Use smp_send_reschedule() instead of resched_cpu().
> > -		 * This way we generate a sched IPI on the target cpu which
> > -		 * is idle. And the softirq performing nohz idle load balance
> > -		 * will be run before returning from the IPI.
> > -		 */
> > -		smp_send_reschedule(ilb_cpu);
> > -	}
> > +	if (test_and_set_bit(NOHZ_BALANCE_KICK, nohz_flags(cpu)))
> 
> s/cpu/ilb_cpu?

correct. Thanks again. Peter, can you queue the appended fix too?

> Also given that 'cpu' argument to nohz_balancer_kick() is no longer used, we can
> avoid passing any argument to it as well ..

we do use it currently in the find_new_ilb().

thanks,
suresh
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: sched, nohz: set the NOHZ_BALANCE_KICK flag for idle load balancer

Intention is to set the NOHZ_BALANCE_KICK flag for the 'ilb_cpu'. Not
for the 'cpu' which is the local cpu. Fix the typo.

Reported-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 kernel/sched/fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 65a6f8b..9e34688 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4852,7 +4852,7 @@ static void nohz_balancer_kick(int cpu)
 	if (ilb_cpu >= nr_cpu_ids)
 		return;
 
-	if (test_and_set_bit(NOHZ_BALANCE_KICK, nohz_flags(cpu)))
+	if (test_and_set_bit(NOHZ_BALANCE_KICK, nohz_flags(ilb_cpu)))
 		return;
 	/*
 	 * Use smp_send_reschedule() instead of resched_cpu().


