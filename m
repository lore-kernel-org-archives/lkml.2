Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760886Ab2J2Uqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:46:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33059 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756592Ab2J2Uiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:38:52 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=AUbvrMH2qqkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=wYVtAbzh1nsA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=9AzMRrQhAAAA:8 a=NufY4J3AAAAA:8 a=KKAkSRfTAAAA:8 a=JfrnYn6hAAAA:8 a=ftUzEednAAAA:8 a=sozttTNsAAAA:8 a=EUspDBNiAAAA:8 a=VnNF1IyMAAAA:8 a=fh4mg5NFAAAA:8 a=0E5r2NFd_aCqEBBxegYA:9 a=MSl-tDqOz04A:10 a=LI9Vle30uBYA:10 a=jbrJJM5MRmoA:10 a=jEp0ucaQiEUA:10 a=SxxB86fLhQ4A:10 a=re9sYKne76oA:10 a=WwgC8nHKvroA:10 a=3Rfx1nUSh_UA:10 a=QwxQZocgbLcA:10 a=x2szoZtqnggA:10 a=IG2fH9E8heMA:10 a=Im-eZXwrtqoA:10 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121029203847.530724313@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 29 Oct 2012 16:27:17 -0400
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
Subject: [PATCH 06/32] nohz/cpuset: Dont turn off the tick if rcu needs it
References: <20121029202711.062749374@goodmis.org>
Content-Disposition: inline; filename=0006-nohz-cpuset-Don-t-turn-off-the-tick-if-rcu-needs-it.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

If RCU is waiting for the current CPU to complete a grace
period, don't turn off the tick. Unlike dynctik-idle, we
are not necessarily going to enter into rcu extended quiescent
state, so we may need to keep the tick to note current CPU's
quiescent states.

[added build fix from Zen Lin]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/rcupdate.h |    1 +
 kernel/rcutree.c         |    3 +--
 kernel/time/tick-sched.c |   22 ++++++++++++++++++----
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 7c968e4..9804c3a 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -186,6 +186,7 @@ static inline int rcu_preempt_depth(void)
 extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
 extern void rcu_check_callbacks(int cpu, int user);
+extern int rcu_pending(int cpu);
 struct notifier_block;
 extern void rcu_idle_enter(void);
 extern void rcu_idle_exit(void);
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 74df86b..0dca81f 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -234,7 +234,6 @@ module_param(jiffies_till_next_fqs, ulong, 0644);
 
 static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *));
 static void force_quiescent_state(struct rcu_state *rsp);
-static int rcu_pending(int cpu);
 
 /*
  * Return the number of RCU-sched batches processed thus far for debug & stats.
@@ -2429,7 +2428,7 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
  * by the current CPU, returning 1 if so.  This function is part of the
  * RCU implementation; it is -not- an exported member of the RCU API.
  */
-static int rcu_pending(int cpu)
+int rcu_pending(int cpu)
 {
 	struct rcu_state *rsp;
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 35047b2..de3c8fe 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -512,9 +512,21 @@ void tick_nohz_idle_enter(void)
 	local_irq_enable();
 }
 
+#ifdef CONFIG_CPUSETS_NO_HZ
+static bool can_stop_adaptive_tick(void)
+{
+	if (!sched_can_stop_tick())
+		return false;
+
+	/* Is there a grace period to complete ? */
+	if (rcu_pending(smp_processor_id()))
+		return false;
+
+	return true;
+}
+
 static void tick_nohz_cpuset_stop_tick(struct tick_sched *ts)
 {
-#ifdef CONFIG_CPUSETS_NO_HZ
 	int cpu = smp_processor_id();
 
 	if (!cpuset_adaptive_nohz() || is_idle_task(current))
@@ -523,12 +535,14 @@ static void tick_nohz_cpuset_stop_tick(struct tick_sched *ts)
 	if (!ts->tick_stopped && ts->nohz_mode == NOHZ_MODE_INACTIVE)
 		return;
 
-	if (!sched_can_stop_tick())
+	if (!can_stop_adaptive_tick())
 		return;
 
 	tick_nohz_stop_sched_tick(ts, ktime_get(), cpu);
-#endif
 }
+#else
+static void tick_nohz_cpuset_stop_tick(struct tick_sched *ts) { }
+#endif
 
 /**
  * tick_nohz_irq_exit - update next tick event from interrupt exit
@@ -860,7 +874,7 @@ void tick_nohz_check_adaptive(void)
 
 	if (cpuset_adaptive_nohz()) {
 		if (ts->tick_stopped && !is_idle_task(current)) {
-			if (!sched_can_stop_tick())
+			if (!can_stop_adaptive_tick())
 				tick_nohz_restart_sched_tick();
 		}
 	}
-- 
1.7.10.4


