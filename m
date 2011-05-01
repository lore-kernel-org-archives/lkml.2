Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760412Ab1EANhw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:37:52 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38899 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413Ab1EANW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:26 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 24/86] rcu: Switch to this_cpu() primitives
Date: Sun,  1 May 2011 06:21:04 -0700
Message-Id: <1304256126-26015-24-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

This removes a couple of lines from invoke_rcu_cpu_kthread(), improving
readability.

Reported-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ee8442d..03f7148 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1480,18 +1480,14 @@ static void rcu_process_callbacks(void)
 static void invoke_rcu_cpu_kthread(void)
 {
 	unsigned long flags;
-	wait_queue_head_t *q;
-	int cpu;
 
 	local_irq_save(flags);
-	cpu = smp_processor_id();
-	per_cpu(rcu_cpu_has_work, cpu) = 1;
-	if (per_cpu(rcu_cpu_kthread_task, cpu) == NULL) {
+	__this_cpu_write(rcu_cpu_has_work, 1);
+	if (__this_cpu_read(rcu_cpu_kthread_task) == NULL) {
 		local_irq_restore(flags);
 		return;
 	}
-	q = &per_cpu(rcu_cpu_wq, cpu);
-	wake_up(q);
+	wake_up(&__get_cpu_var(rcu_cpu_wq));
 	local_irq_restore(flags);
 }
 
-- 
1.7.3.2

