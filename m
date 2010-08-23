Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab0HWUnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 16:43:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:21312 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785Ab0HWUnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 16:43:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,259,1280732400"; 
   d="scan'208";a="650475242"
Subject: Re: [patch 3/3] sched: move sched_avg_update() to update_cpu_load()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chris@frostnet.net" <chris@frostnet.net>,
        "debian00@aliceadsl.fr" <debian00@aliceadsl.fr>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jonathan.protzenko@gmail.com" <jonathan.protzenko@gmail.com>,
        "mans@mansr.com" <mans@mansr.com>,
        "psastudio@mail.ru" <psastudio@mail.ru>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "stephan.eicher@web.de" <stephan.eicher@web.de>,
        "sxxe@gmx.de" <sxxe@gmx.de>,
        "thomas@archlinux.org" <thomas@archlinux.org>,
        "venki@google.com" <venki@google.com>,
        "wonghow@gmail.com" <wonghow@gmail.com>
In-Reply-To: <1282312043.2605.1033.camel@laptop>
References: <20100813190539.410550989@sbsiddha-MOBL3.sc.intel.com>
	 <20100813193911.999833492@sbsiddha-MOBL3.sc.intel.com>
	 <1281945634.1926.968.camel@laptop>
	 <1281980769.2676.33.camel@sbsiddha-MOBL3.sc.intel.com>
	 <1281987086.1926.1890.camel@laptop>
	 <1282265478.10905.1.camel@sbsiddha-MOBL3.sc.intel.com>
	 <1282312043.2605.1033.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corp
Date: Mon, 23 Aug 2010 13:42:51 -0700
Message-Id: <1282596171.2694.3.camel@sbsiddha-MOBL3>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-20 at 06:47 -0700, Peter Zijlstra wrote:
> breaks CONFIG_SMP=n builds..
> 
>   CC      kernel/sched.o
> /usr/src/linux-2.6/kernel/sched.c: In function ‘update_cpu_load’:
> /usr/src/linux-2.6/kernel/sched.c:3186: error: implicit declaration of function ‘sched_avg_update’  CC      kernel/sched.o
> /usr/src/linux-2.6/kernel/sched.c: In function ‘update_cpu_load’:
> /usr/src/linux-2.6/kernel/sched.c:3186: error: implicit declaration of function ‘sched_avg_update’

Updated patch appended. Thanks.
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: sched: move sched_avg_update() to update_cpu_load()

Currently sched_avg_update() (which updates rt_avg stats in the rq) is getting
called from scale_rt_power() (in the load balance context) which doesn't take
rq->lock.

Fix it by moving the sched_avg_update() to more appropriate update_cpu_load()
where the CFS load gets updated aswell.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 kernel/sched.c      |    6 ++++++
 kernel/sched_fair.c |    2 --
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 41541d7..f95bbbe 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1294,6 +1294,10 @@ static void resched_task(struct task_struct *p)
 static void sched_rt_avg_update(struct rq *rq, u64 rt_delta)
 {
 }
+
+static void sched_avg_update(struct rq *rq)
+{
+}
 #endif /* CONFIG_SMP */
 
 #if BITS_PER_LONG == 32
@@ -3182,6 +3186,8 @@ static void update_cpu_load(struct rq *this_rq)
 
 		this_rq->cpu_load[i] = (old_load * (scale - 1) + new_load) >> i;
 	}
+
+	sched_avg_update(this_rq);
 }
 
 static void update_cpu_load_active(struct rq *this_rq)
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 806d1b2..a2bf7bd 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2268,8 +2268,6 @@ unsigned long scale_rt_power(int cpu)
 	struct rq *rq = cpu_rq(cpu);
 	u64 total, available;
 
-	sched_avg_update(rq);
-
 	total = sched_avg_period() + (rq->clock - rq->age_stamp);
 	available = total - rq->rt_avg;
 


