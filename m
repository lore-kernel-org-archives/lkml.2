Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760868Ab2J2UoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:44:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18478 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235Ab2J2Uix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:38:53 -0400
X-Authority-Analysis: v=2.0 cv=KcBQQHkD c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=fRE2Z7D5Rc8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=_I1haf9WbHAA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=9AzMRrQhAAAA:8 a=NufY4J3AAAAA:8 a=KKAkSRfTAAAA:8 a=JfrnYn6hAAAA:8 a=ftUzEednAAAA:8 a=sozttTNsAAAA:8 a=EUspDBNiAAAA:8 a=VnNF1IyMAAAA:8 a=fh4mg5NFAAAA:8 a=yuHW65_V7381hc6k-hIA:9 a=MSl-tDqOz04A:10 a=LI9Vle30uBYA:10 a=jbrJJM5MRmoA:10 a=jEp0ucaQiEUA:10 a=SxxB86fLhQ4A:10 a=re9sYKne76oA:10 a=WwgC8nHKvroA:10 a=3Rfx1nUSh_UA:10 a=QwxQZocgbLcA:10 a=x2szoZtqnggA:10 a=IG2fH9E8heMA:10 a=Im-eZXwrtqoA:10 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121029203850.023551882@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 29 Oct 2012 16:27:34 -0400
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
Subject: [PATCH 23/32] sched: Update rq clock on nohz CPU before migrating tasks
References: <20121029202711.062749374@goodmis.org>
Content-Disposition: inline; filename=0023-sched-Update-rq-clock-on-nohz-CPU-before-migrating-t.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

Because the sched_class::put_prev_task() callback of rt and fair
classes are referring to the rq clock to update their runtime
statistics. A CPU running in tickless mode may carry a stale value.
We need to update it there.

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
 kernel/sched/core.c  |    6 ++++++
 kernel/sched/sched.h |    6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 783d5e4..f0fa54d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4851,6 +4851,12 @@ static void migrate_tasks(unsigned int dead_cpu)
 	 */
 	rq->stop = NULL;
 
+	/*
+	 * ->put_prev_task() need to have an up-to-date value
+	 * of rq->clock[_task]
+	 */
+	update_nohz_rq_clock(rq);
+
 	for ( ; ; ) {
 		/*
 		 * There's this thread running, bail when that's the only
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index c6cd9ec..1956494 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -948,6 +948,12 @@ static inline void dec_nr_running(struct rq *rq)
 
 extern void update_rq_clock(struct rq *rq);
 
+static inline void update_nohz_rq_clock(struct rq *rq)
+{
+	if (cpuset_cpu_adaptive_nohz(cpu_of(rq)))
+		update_rq_clock(rq);
+}
+
 extern void activate_task(struct rq *rq, struct task_struct *p, int flags);
 extern void deactivate_task(struct rq *rq, struct task_struct *p, int flags);
 
-- 
1.7.10.4


