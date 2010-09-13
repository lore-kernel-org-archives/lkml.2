Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab0IMSCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 14:02:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:2827 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933Ab0IMSCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 14:02:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,360,1280732400"; 
   d="scan'208";a="324041137"
Subject: Re: [PATCH] generic-ipi: fix deadlock in __smp_call_function_single
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
In-Reply-To: <AANLkTi=Vrd0g-64oRYLo6fTj1SYYa++VG57vGn608tkA@mail.gmail.com>
References: <20100909135050.GB2228@osiris.boeblingen.de.ibm.com>
	 <1284116817.402.33.camel@laptop>
	 <20100910172805.a4fe5c7f.akpm@linux-foundation.org>
	 <1284196838.2251.12.camel@laptop>
	 <AANLkTi=Vrd0g-64oRYLo6fTj1SYYa++VG57vGn608tkA@mail.gmail.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 13 Sep 2010 11:02:21 -0700
Message-Id: <1284400941.2684.19.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-11 at 09:42 -0700, Venkatesh Pallipadi wrote:
> Also, as we don't have rq lock around this point, it seems possible
> that the CPU that was busy and wants to kick idle load balance on
> remote CPU, could have become idle and nominated itself as idle load
> balancer.

A busy cpu (currently running something -- one task on the rq atleast)
can't become idle in the middle of trigger_load_balance().

What might be happening is similar what you said but the opposite of it.

cpu-x is idle which is also ilb_cpu
got a scheduler tick during idle
and the nohz_kick_needed() in trigger_load_balance() checks for
rq_x->nr_running which might not be zero (because of someone waking a
task on this rq etc) and this leads to the situation of the cpu-x
sending a kick to itself.

Perhaps the more appropriate patch would be(?):

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 134f7ed..5b5aa97 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3632,7 +3632,7 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
 	if (time_before(now, nohz.next_balance))
 		return 0;
 
-	if (!rq->nr_running)
+	if (rq->idle_at_tick)
 		return 0;
 
 	first_pick_cpu = atomic_read(&nohz.first_pick_cpu);


