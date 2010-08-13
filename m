Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab0HMTpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 15:45:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:13894 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433Ab0HMTp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 15:45:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,365,1278313200"; 
   d="scan'208";a="647482405"
Message-Id: <20100813193911.827207098@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Fri, 13 Aug 2010 12:45:40 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: chris@frostnet.net, debian00@aliceadsl.fr, hpa@zytor.com,
        jonathan.protzenko@gmail.com, mans@mansr.com, psastudio@mail.ru,
        rjw@sisk.pl, stephan.eicher@web.de, sxxe@gmx.de, thomas@archlinux.org,
        venki@google.com, wonghow@gmail.com,
        Suresh Siddha <suresh.b.siddha@intel.com>, stable@kernel.org
Subject: [patch 1/3] sched: init rt_avg stat whenever rq comes online
References: <20100813190539.410550989@sbsiddha-MOBL3.sc.intel.com>
Content-Disposition: inline; filename=sched_reset_rt_avg_stat_online.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TSC's get reset after suspend/resume and this leads to a scenario of
rq->clock (sched_clock_cpu()) less than rq->age_stamp. This leads
to a big value returned by scale_rt_power() and the resulting big group
power set by the update_group_power() is causing improper load balancing
between busy and idle cpu's after suspend/resume.

This resulted in multi-threaded workloads (like kernel-compilation) go slower
after suspend/resume cycle on core i5 laptops.

Realign rq->age_stamp to rq->clock and reset rq->rt_avg in rq_online_rt().

Addresses the primary issue reported in the
https://bugzilla.kernel.org/show_bug.cgi?id=15559
(Bad performance after suspend on Intel i7 and i5)

Reported-by: Florian Pritz <flo@xssn.at>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: stable@kernel.org	[2.6.32+]
---

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index d10c80e..a00af73 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1550,6 +1550,12 @@ static void rq_online_rt(struct rq *rq)
 	__enable_runtime(rq);
 
 	cpupri_set(&rq->rd->cpupri, rq->cpu, rq->rt.highest_prio.curr);
+
+	/*
+ 	 * Reset RT average stat and its time stamp.
+ 	 */
+	rq->age_stamp = rq->clock;
+	rq->rt_avg = 0;
 }
 
 /* Assumes rq->lock is held */


