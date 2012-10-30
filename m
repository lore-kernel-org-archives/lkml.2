Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934058Ab2J3Qyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:54:54 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56686 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934018Ab2J3Qyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:54:52 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/7] cpu: No more __stop_machine() in _cpu_down()
Date: Tue, 30 Oct 2012 09:54:32 -0700
Message-Id: <1351616076-25617-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351616076-25617-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030165415.GA25438@linux.vnet.ibm.com>
 <1351616076-25617-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103016-7182-0000-0000-000002FDB4A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The _cpu_down() function invoked as part of the CPU-hotplug offlining
process currently invokes __stop_machine(), which is slow and inflicts
substantial real-time latencies on the entire system.  This patch
substitutes stop_cpus() for __stop_machine() in order to improve
both performance and real-time latency.

This is currently unsafe, because there are a number of uses of
preempt_disable() that are intended to block CPU-hotplug offlining.
These will be fixed, but in the meantime, this commit is one way to help
locate them.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/cpu.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 42bd331..6b37ce0 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -247,13 +247,18 @@ static int __ref take_cpu_down(void *_param)
 {
 	struct take_cpu_down_param *param = _param;
 	int err;
+	unsigned long flags;
 
 	/* Ensure this CPU doesn't handle any more interrupts. */
+	local_irq_save(flags);
 	err = __cpu_disable();
-	if (err < 0)
+	if (err < 0) {
+		local_irq_restore(flags);
 		return err;
+	}
 
 	cpu_notify(CPU_DYING | param->mod, param->hcpu);
+	local_irq_restore(flags);
 	return 0;
 }
 
@@ -286,7 +291,7 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	}
 	smpboot_park_threads(cpu);
 
-	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
+	err = stop_cpus(cpumask_of(cpu), take_cpu_down, &tcd_param);
 	if (err) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
 		smpboot_unpark_threads(cpu);
-- 
1.7.8

