Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760823Ab2J2UoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:44:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10288 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787Ab2J2Uix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:38:53 -0400
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Rr-zUMreGdkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=5zYnBtOpk0cA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=9AzMRrQhAAAA:8 a=NufY4J3AAAAA:8 a=KKAkSRfTAAAA:8 a=JfrnYn6hAAAA:8 a=ftUzEednAAAA:8 a=sozttTNsAAAA:8 a=EUspDBNiAAAA:8 a=VnNF1IyMAAAA:8 a=fh4mg5NFAAAA:8 a=fiaL1sVHFq21geOVfxEA:9 a=MSl-tDqOz04A:10 a=LI9Vle30uBYA:10 a=jbrJJM5MRmoA:10 a=jEp0ucaQiEUA:10 a=SxxB86fLhQ4A:10 a=re9sYKne76oA:10 a=WwgC8nHKvroA:10 a=3Rfx1nUSh_UA:10 a=QwxQZocgbLcA:10 a=x2szoZtqnggA:10 a=IG2fH9E8heMA:10 a=Im-eZXwrtqoA:10 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121029203850.612013355@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 29 Oct 2012 16:27:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Subject: [PATCH 27/32] sched: Update clock of nohz busiest rq before balancing
References: <20121029202711.062749374@goodmis.org>
Content-Disposition: inline; filename=0027-sched-Update-clock-of-nohz-busiest-rq-before-balanci.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

move_tasks() and active_load_balance_cpu_stop() both need
to have the busiest rq clock uptodate because they may end
up calling can_migrate_task() that uses rq->clock_task
to determine if the task running in the busiest runqueue
is cache hot.

Hence if the busiest runqueue is tickless, update its clock
before reading it.

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
[ Forward port conflicts ]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched/fair.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f320922..a63e641 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4231,6 +4231,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 {
 	int ld_moved, cur_ld_moved, active_balance = 0;
 	int lb_iterations, max_lb_iterations;
+	int clock_updated;
 	struct sched_group *group;
 	struct rq *busiest;
 	unsigned long flags;
@@ -4274,6 +4275,7 @@ redo:
 
 	ld_moved = 0;
 	lb_iterations = 1;
+	clock_updated = 0;
 	if (busiest->nr_running > 1) {
 		/*
 		 * Attempt to move tasks. If find_busiest_group has found
@@ -4297,6 +4299,14 @@ more_balance:
 		 */
 		cur_ld_moved = move_tasks(&env);
 		ld_moved += cur_ld_moved;
+
+		/*
+		 * Move tasks may end up calling can_migrate_task() which
+		 * requires an uptodate value of the rq clock.
+		 */
+		update_nohz_rq_clock(busiest);
+		clock_updated = 1;
+
 		double_rq_unlock(env.dst_rq, busiest);
 		local_irq_restore(flags);
 
@@ -4392,6 +4402,13 @@ more_balance:
 				busiest->active_balance = 1;
 				busiest->push_cpu = this_cpu;
 				active_balance = 1;
+				/*
+				 * active_load_balance_cpu_stop may end up calling
+				 * can_migrate_task() which requires an uptodate
+				 * value of the rq clock.
+				 */
+				if (!clock_updated)
+					update_nohz_rq_clock(busiest);
 			}
 			raw_spin_unlock_irqrestore(&busiest->lock, flags);
 
-- 
1.7.10.4


