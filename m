Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760932Ab2J2UtO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:49:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10288 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab2J2Uiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:38:50 -0400
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=DuqvtLA_qqAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Me_FlEMpy54A:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=9AzMRrQhAAAA:8 a=NufY4J3AAAAA:8 a=KKAkSRfTAAAA:8 a=JfrnYn6hAAAA:8 a=ftUzEednAAAA:8 a=sozttTNsAAAA:8 a=EUspDBNiAAAA:8 a=VnNF1IyMAAAA:8 a=fh4mg5NFAAAA:8 a=MRhHgciI7kP6BGRa9P4A:9 a=MSl-tDqOz04A:10 a=LI9Vle30uBYA:10 a=jbrJJM5MRmoA:10 a=jEp0ucaQiEUA:10 a=SxxB86fLhQ4A:10 a=re9sYKne76oA:10 a=WwgC8nHKvroA:10 a=3Rfx1nUSh_UA:10 a=QwxQZocgbLcA:10 a=x2szoZtqnggA:10 a=IG2fH9E8heMA:10 a=Im-eZXwrtqoA:10 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121029203847.966629295@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 29 Oct 2012 16:27:20 -0400
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
Subject: [PATCH 09/32] nohz/cpuset: Restart tick when nohz flag is cleared on cpuset
References: <20121029202711.062749374@goodmis.org>
Content-Disposition: inline; filename=0009-nohz-cpuset-Restart-tick-when-nohz-flag-is-cleared-o.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

Issue an IPI to restart the tick on a CPU that belongs
to a cpuset when its nohz flag gets cleared.

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
 include/linux/cpuset.h   |    2 ++
 kernel/cpuset.c          |   25 +++++++++++++++++++++++--
 kernel/time/tick-sched.c |    8 ++++++++
 3 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 7e7eb41..631968b 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -260,6 +260,8 @@ static inline bool cpuset_adaptive_nohz(void)
 	 */
 	return cpuset_cpu_adaptive_nohz(smp_processor_id());
 }
+
+extern void cpuset_exit_nohz_interrupt(void *unused);
 #else
 static inline bool cpuset_cpu_adaptive_nohz(int cpu) { return false; }
 static inline bool cpuset_adaptive_nohz(void) { return false; }
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 6319d8e..1b67e5b 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1200,6 +1200,14 @@ static void cpuset_change_flag(struct task_struct *tsk,
 
 DEFINE_PER_CPU(atomic_t, cpu_adaptive_nohz_ref);
 
+static void cpu_exit_nohz(int cpu)
+{
+	preempt_disable();
+	smp_call_function_single(cpu, cpuset_exit_nohz_interrupt,
+				 NULL, true);
+	preempt_enable();
+}
+
 static void update_nohz_cpus(struct cpuset *old_cs, struct cpuset *cs)
 {
 	int cpu;
@@ -1211,9 +1219,22 @@ static void update_nohz_cpus(struct cpuset *old_cs, struct cpuset *cs)
 	for_each_cpu(cpu, cs->cpus_allowed) {
 		atomic_t *ref = &per_cpu(cpu_adaptive_nohz_ref, cpu);
 		if (is_adaptive_nohz(cs))
-			atomic_inc(ref);
+			val = atomic_inc_return(ref);
 		else
-			atomic_dec(ref);
+			val = atomic_dec_return(ref);
+
+		if (!val) {
+			/*
+			 * The update to cpu_adaptive_nohz_ref must be
+			 * visible right away. So that once we restart the tick
+			 * from the IPI, it won't be stopped again due to cache
+			 * update lag.
+			 * FIXME: We probably need more to ensure this value is really
+			 * visible right away.
+			 */
+			smp_mb();
+			cpu_exit_nohz(cpu);
+		}
 	}
 }
 #else
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 0a5e650..de7de68 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -884,6 +884,14 @@ void tick_nohz_check_adaptive(void)
 	}
 }
 
+void cpuset_exit_nohz_interrupt(void *unused)
+{
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+
+	if (ts->tick_stopped && !is_idle_task(current))
+		tick_nohz_restart_adaptive();
+}
+
 void tick_nohz_post_schedule(void)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
-- 
1.7.10.4


