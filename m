Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625Ab2J2Ui4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:38:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9739 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab2J2Uit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:38:49 -0400
X-Authority-Analysis: v=2.0 cv=KcBQQHkD c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Y9Ssy5JFCG4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=fkAimxw8Ax4A:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=9AzMRrQhAAAA:8 a=NufY4J3AAAAA:8 a=KKAkSRfTAAAA:8 a=JfrnYn6hAAAA:8 a=ftUzEednAAAA:8 a=sozttTNsAAAA:8 a=EUspDBNiAAAA:8 a=VnNF1IyMAAAA:8 a=fh4mg5NFAAAA:8 a=4W55MVCP-s-fNgFRcs8A:9 a=MSl-tDqOz04A:10 a=LI9Vle30uBYA:10 a=jbrJJM5MRmoA:10 a=jEp0ucaQiEUA:10 a=SxxB86fLhQ4A:10 a=re9sYKne76oA:10 a=WwgC8nHKvroA:10 a=3Rfx1nUSh_UA:10 a=QwxQZocgbLcA:10 a=x2szoZtqnggA:10 a=IG2fH9E8heMA:10 a=Im-eZXwrtqoA:10 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121029203847.098399427@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 29 Oct 2012 16:27:14 -0400
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
Subject: [PATCH 03/32] nohz: Try not to give the timekeeping duty to an adaptive tickless
 cpu
References: <20121029202711.062749374@goodmis.org>
Content-Disposition: inline; filename=0003-nohz-Try-not-to-give-the-timekeeping-duty-to-an-adap.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

Try to give the timekeeing duty to a CPU that doesn't belong
to any nohz cpuset when possible, so that we increase the chance
for these nohz cpusets to run their CPUs out of periodic tick
mode.

[TODO: We need to find a way to ensure there is always one non-nohz
running CPU maintaining the timekeeping duty if every non-idle CPUs are
adaptive tickless]

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
 kernel/time/tick-sched.c |   52 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 41 insertions(+), 11 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d6d16fe..c7a78c6 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -20,6 +20,7 @@
 #include <linux/profile.h>
 #include <linux/sched.h>
 #include <linux/module.h>
+#include <linux/cpuset.h>
 
 #include <asm/irq_regs.h>
 
@@ -789,6 +790,45 @@ void tick_check_idle(int cpu)
 	tick_check_nohz(cpu);
 }
 
+#ifdef CONFIG_CPUSETS_NO_HZ
+
+/*
+ * Take the timer duty if nobody is taking care of it.
+ * If a CPU already does and and it's in a nohz cpuset,
+ * then take the charge so that it can switch to nohz mode.
+ */
+static void tick_do_timer_check_handler(int cpu)
+{
+	int handler = tick_do_timer_cpu;
+
+	if (unlikely(handler == TICK_DO_TIMER_NONE)) {
+		tick_do_timer_cpu = cpu;
+	} else {
+		if (!cpuset_adaptive_nohz() &&
+		    cpuset_cpu_adaptive_nohz(handler))
+			tick_do_timer_cpu = cpu;
+	}
+}
+
+#else
+
+static void tick_do_timer_check_handler(int cpu)
+{
+#ifdef CONFIG_NO_HZ
+	/*
+	 * Check if the do_timer duty was dropped. We don't care about
+	 * concurrency: This happens only when the cpu in charge went
+	 * into a long sleep. If two cpus happen to assign themself to
+	 * this duty, then the jiffies update is still serialized by
+	 * xtime_lock.
+	 */
+	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE))
+		tick_do_timer_cpu = cpu;
+#endif
+}
+
+#endif /* CONFIG_CPUSETS_NO_HZ */
+
 /*
  * High resolution timer specific code
  */
@@ -805,17 +845,7 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 	ktime_t now = ktime_get();
 	int cpu = smp_processor_id();
 
-#ifdef CONFIG_NO_HZ
-	/*
-	 * Check if the do_timer duty was dropped. We don't care about
-	 * concurrency: This happens only when the cpu in charge went
-	 * into a long sleep. If two cpus happen to assign themself to
-	 * this duty, then the jiffies update is still serialized by
-	 * xtime_lock.
-	 */
-	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE))
-		tick_do_timer_cpu = cpu;
-#endif
+	tick_do_timer_check_handler(cpu);
 
 	/* Check, if the jiffies need an update */
 	if (tick_do_timer_cpu == cpu)
-- 
1.7.10.4


