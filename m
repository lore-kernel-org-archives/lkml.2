Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab0IMSEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 14:04:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:44050 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614Ab0IMSEW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 14:04:22 -0400
Subject: [RFC][PATCH] sched: Improve tick preemption
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1284393215.2275.383.camel@laptop>
References: <20100911173732.551632040@efficios.com>
	 <20100911174003.051303123@efficios.com> <1284231470.2251.52.camel@laptop>
	 <20100911195708.GA9273@Krystal> <1284288072.2251.91.camel@laptop>
	 <20100912203712.GD32327@Krystal>  <1284382387.2275.265.camel@laptop>
	 <1284383758.2275.283.camel@laptop>
	 <1284386179.10436.6.camel@marge.simson.net>
	 <1284393215.2275.383.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Sep 2010 20:04:11 +0200
Message-ID: <1284401051.2275.416.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On an SMP machine, but sysctl knobs adjusted as if it were UP and
everything ran with schedtool -a1

For workload I used: make O=defconfig-build -j10 kernel/

(full bzImage builds take like forever with a single cpu, runs were done
cache-hot)

Normal:

# for i in {latency,min_granularity,wakeup_granularity}; do cat sched_${i}_ns; done
6000000
2000000
1000000


#schedtool -a1 -e ./wakeup-latency
maximum latency: 22169.0 µs
average latency: 1559.8 µs
missed timer events: 0


# for i in {latency,min_granularity,wakeup_granularity}; do cat sched_${i}_ns; done
6000000
750000
1000000

# schedtool -a1 -e ./wakeup-latency 
maximum latency: 11999.9 µs
average latency: 710.9 µs
missed timer events: 0


Patched:

# for i in {latency,min_granularity,wakeup_granularity}; do cat sched_${i}_ns; done
6000000
2000000
1000000

maximum latency: 18042.3 µs
average latency: 2729.3 µs
missed timer events: 0


# for i in {latency,min_granularity,wakeup_granularity}; do cat sched_${i}_ns; done
6000000
750000
1000000

maximum latency: 9985.8 µs
average latency: 551.4 µs
missed timer events: 0


Could others try and reproduce this while I try and run a few other
benchmarks?

---
Subject: sched: Improve tick preemption

Regular tick preemption has a few issues:

 - it compares delta_exec (wall-time) with an unweighted measure
   (min_gran)

 - that min_gran might be too small for systems with a small number
   of tasks.

Cure the first issue by instead comparing the vruntime (virtual time)
difference with this unweighted measure.

Cure the second issue by computing the actual granularity for small
systems.

Reported-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 9b5b4f8..0011622 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -457,6 +457,16 @@ static u64 __sched_period(unsigned long nr_running)
 	return period;
 }
 
+static u64 __sched_gran(unsigned long nr_running)
+{
+	unsigned long latency = sysctl_sched_latency;
+
+	if (nr_running >= sched_nr_latency)
+		return sysctl_sched_min_granularity;
+
+	return latency / nr_running;
+}
+
 /*
  * We calculate the wall-time slice from the period by taking a part
  * proportional to the weight.
@@ -865,14 +875,13 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
 
-	if (delta_exec < sysctl_sched_min_granularity)
-		return;
-
 	if (cfs_rq->nr_running > 1) {
 		struct sched_entity *se = __pick_next_entity(cfs_rq);
 		s64 delta = curr->vruntime - se->vruntime;
+		if (delta < sysctl_sched_min_granularity)
+			return;
 
-		if (delta > ideal_runtime)
+		if (delta > __sched_gran(cfs_rq->nr_running))
 			resched_task(rq_of(cfs_rq)->curr);
 	}
 }

