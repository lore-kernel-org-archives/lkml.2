Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab1KBUer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:34:47 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33347 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509Ab1KBUcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:32:03 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 28/28] rcu: Fix idle-task checks
Date: Wed,  2 Nov 2011 13:30:49 -0700
Message-Id: <1320265849-5744-28-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111102203017.GA3830@linux.vnet.ibm.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
x-cbid: 11110220-9360-0000-0000-00000045A4FC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

RCU has traditionally relied on idle_cpu() to determine whether a given
CPU is running in the context of an idle task, but recent changes have
invalidated this approach.  This commit therefore switches from idle_cpu
to "current->pid != 0".

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Suggested-by: Carsten Emde <C.Emde@osadl.org>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Tested-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutiny.c |    4 ++--
 kernel/rcutree.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index f4e7bc3..35f8a07 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -65,7 +65,7 @@ static void rcu_idle_enter_common(long long oldval)
 		return;
 	}
 	RCU_TRACE(trace_rcu_dyntick("Start", oldval, rcu_dynticks_nesting));
-	if (!idle_cpu(smp_processor_id())) {
+	if (current->pid != 0) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
 		RCU_TRACE(trace_rcu_dyntick("Error on entry: not idle task",
@@ -119,7 +119,7 @@ static void rcu_idle_exit_common(long long oldval)
 		return;
 	}
 	RCU_TRACE(trace_rcu_dyntick("End", oldval, rcu_dynticks_nesting));
-	if (!idle_cpu(smp_processor_id())) {
+	if (!current->pid != 0) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
 		RCU_TRACE(trace_rcu_dyntick("Error on exit: not idle task",
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 3d7b474..414af68 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -355,7 +355,7 @@ static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
 		return;
 	}
 	trace_rcu_dyntick("Start", oldval, rdtp->dynticks_nesting);
-	if (!idle_cpu(smp_processor_id())) {
+	if (current->pid != 0) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
 		trace_rcu_dyntick("Error on entry: not idle task",
@@ -449,7 +449,7 @@ static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
 	smp_mb__after_atomic_inc();  /* See above. */
 	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
 	trace_rcu_dyntick("End", oldval, rdtp->dynticks_nesting);
-	if (!idle_cpu(smp_processor_id())) {
+	if (current->pid != 0) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
 		trace_rcu_dyntick("Error on exit: not idle task",
-- 
1.7.3.2

