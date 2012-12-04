Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab2LDI4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 03:56:38 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:53796 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab2LDI4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 03:56:35 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH 05/10] kick_process(),
 cpu-hotplug: Prevent offlining of target CPU properly
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org
Cc: sbw@mit.edu, tj@kernel.org, amit.kucheria@linaro.org, rostedt@goodmis.org,
        rjw@sisk.pl, srivatsa.bhat@linux.vnet.ibm.com,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 04 Dec 2012 14:25:06 +0530
Message-ID: <20121204085504.25919.38913.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20121204085149.25919.29920.stgit@srivatsabhat.in.ibm.com>
References: <20121204085149.25919.29920.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120408-5564-0000-0000-000005A05D4A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With stop_machine() gone from the CPU offline path, we can't depend on
preempt_disable() to prevent CPUs from going offline from under us.

Use the get/put_online_cpus_stable_atomic() APIs to prevent CPUs from going
offline, while invoking from atomic context.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/sched/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ef6ada4..c1a5d93 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1091,11 +1091,11 @@ void kick_process(struct task_struct *p)
 {
 	int cpu;
 
-	preempt_disable();
+	get_online_cpus_stable_atomic();
 	cpu = task_cpu(p);
 	if ((cpu != smp_processor_id()) && task_curr(p))
 		smp_send_reschedule(cpu);
-	preempt_enable();
+	put_online_cpus_stable_atomic();
 }
 EXPORT_SYMBOL_GPL(kick_process);
 #endif /* CONFIG_SMP */

