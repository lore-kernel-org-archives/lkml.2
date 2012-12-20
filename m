Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab2LTSfF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 13:35:05 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:41176 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab2LTSeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 13:34:09 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 18/24] sched: Update nohz rq clock before searching busiest group on load balancing
Date: Thu, 20 Dec 2012 19:33:05 +0100
Message-Id: <1356028391-14427-19-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
References: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
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
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/fair.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 291e225..b1b791d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4795,6 +4795,19 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 
 	schedstat_inc(sd, lb_count[idle]);
 
+	/*
+	 * find_busiest_group() may need an uptodate cpu clock
+	 * for find_busiest_group() (see scale_rt_power()). If
+	 * the CPU is nohz, it's clock may be stale.
+	 */
+	if (tick_nohz_full_cpu(this_cpu)) {
+		local_irq_save(flags);
+		raw_spin_lock(&this_rq->lock);
+		update_rq_clock(this_rq);
+		raw_spin_unlock(&this_rq->lock);
+		local_irq_restore(flags);
+	}
+
 redo:
 	group = find_busiest_group(&env, balance);
 
-- 
1.7.5.4

