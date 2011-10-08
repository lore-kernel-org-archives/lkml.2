Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565Ab1JHAIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 20:08:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:62202 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763Ab1JHAIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 20:08:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="61078606"
Subject: Re: [patch v2 1/2] sched: Use resched IPI to kick off the nohz idle
 balance
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
        Prarit Bhargava <prarit@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Date: Fri, 07 Oct 2011 17:09:46 -0700
In-Reply-To: <20111006172731.GA31781@redhat.com>
References: <20111003220934.834943260@sbsiddha-desk.sc.intel.com>
	 <20111006172731.GA31781@redhat.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1318032586.11592.206.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-06 at 10:27 -0700, Vivek Goyal wrote:
> On Mon, Oct 03, 2011 at 03:09:00PM -0700, Suresh Siddha wrote:
> [..]
> > 
> >    [ This issue is present from 2.6.35+ kernels, but marking it -stable
> >      only from v3.0+ as the proposed fix depends on the scheduler_ipi()
> >      that is introduced recently. ]
> > 
> 
> Hi Suresh,
> 
> Are you planning to fix this issue for older kernels too? I am wondering
> how to go about fixing it there.
> 

Vivek, Initially when Prarit brought this issue to me, I gave an ugly
quick fix (Appended) for a quick try. But I would recommend we back port
the couple of mainline patches that introduced scheduler_ipi() code
along with these two patches. Thoughts?

---
Quick and dirty fix for the deadlock caused by the nohz balance logic.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index bc8ee99..f48b950 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3618,6 +3618,7 @@ static DEFINE_PER_CPU(struct call_single_data, remote_sched_softirq_cb);
 static void trigger_sched_softirq(void *data)
 {
 	raise_softirq_irqoff(SCHED_SOFTIRQ);
+	this_rq()->nohz_balance_kick = 2;
 }
 
 static inline void init_sched_softirq_csd(struct call_single_data *csd)
@@ -3977,7 +3978,7 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
 	struct rq *rq;
 	int balance_cpu;
 
-	if (idle != CPU_IDLE || !this_rq->nohz_balance_kick)
+	if (idle != CPU_IDLE || (this_rq->nohz_balance_kick != 2))
 		return;
 
 	for_each_cpu(balance_cpu, nohz.idle_cpus_mask) {


