Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab2EAAGC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 20:06:02 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:52058 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab2EAAF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 20:05:59 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 36/41] sched: Update nohz rq clock before searching busiest group on load balancing
Date: Tue,  1 May 2012 01:55:10 +0200
Message-Id: <1335830115-14335-37-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While load balancing an rq target, we look for the busiest group.
This operation may require an uptodate rq clock if we end up calling
scale_rt_power(). To this end, update it manually if the target is
running tickless.

DOUBT: don't we actually also need this in vanilla kernel, in case
this_cpu is in dyntick-idle mode?

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/fair.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index cd871e7..af8377f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4466,6 +4466,19 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 
 	schedstat_inc(sd, lb_count[idle]);
 
+	/*
+	 * find_busiest_group() may need an uptodate cpu clock
+	 * for find_busiest_group() (see scale_rt_power()). If
+	 * the CPU is nohz, it's clock may be stale.
+	 */
+	if (cpuset_cpu_adaptive_nohz(this_cpu)) {
+		local_irq_save(flags);
+		raw_spin_lock(&this_rq->lock);
+		update_rq_clock(this_rq);
+		raw_spin_unlock(&this_rq->lock);
+		local_irq_restore(flags);
+	}
+
 redo:
 	group = find_busiest_group(sd, this_cpu, &imbalance, idle,
 				   cpus, balance);
-- 
1.7.5.4

