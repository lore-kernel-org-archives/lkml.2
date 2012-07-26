Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab2GZV01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:26:27 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:41537 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab2GZVUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:20:33 -0400
Date: Thu, 26 Jul 2012 14:19:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, sbw@mit.edu, srivatsa.bhat@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, vincent.guittot@linaro.org,
        amit.kucheria@linaro.org
Subject: [PATCH RFC] cpu: No more __stop_machine() in _cpu_down()
Message-ID: <20120726211927.GA26016@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072621-2356-0000-0000-000000B8C1B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The _cpu_down() function invoked as part of the CPU-hotplug offlining
process currently invokes __stop_machine(), which is slow and inflicts
substantial real-time latencies on the entire system.  This patch
substitutes stop_cpus() for __stop_machine() in order to improve
both performance and real-time latency.

This is currently unsafe, because there are a number of uses of
preempt_disable() that are intended to block CPU-hotplug offlining.
These will be fixed, but in the meantime, this commit is one way to help
locate them.  It nevertheless passes light rcutorture/hotplug stress
testing.  Meaning that we should not be relying on pure testing to find
places where people are relying on preemption disabling to block CPUs
from going offline.  ;-)

Not-yet-signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>

diff --git a/kernel/cpu.c b/kernel/cpu.c
index a4eb522..47e63a0 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -243,13 +243,18 @@ static int __ref take_cpu_down(void *_param)
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
 
@@ -281,7 +286,7 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 		goto out_release;
 	}
 
-	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
+	err = stop_cpus(cpumask_of(cpu), take_cpu_down, &tcd_param);
 	if (err) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
 		cpu_notify_nofail(CPU_DOWN_FAILED | mod, hcpu);

