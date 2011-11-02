Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab1KBUep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:34:45 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59596 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534Ab1KBUcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:32:04 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 23/28] powerpc: Tell RCU about idle after hcall tracing
Date: Wed,  2 Nov 2011 13:30:44 -0700
Message-Id: <1320265849-5744-23-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111102203017.GA3830@linux.vnet.ibm.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
x-cbid: 11110220-5930-0000-0000-000000D6370F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

The PowerPC pSeries platform (CONFIG_PPC_PSERIES=y) enables
hypervisor-call tracing for CONFIG_TRACEPOINTS=y kernels.  One of the
hypervisor calls that is traced is the H_CEDE call in the idle loop
that tells the hypervisor that this OS instance no longer needs the
current CPU.  However, tracing uses RCU, so this combination of kernel
configuration variables needs to avoid telling RCU about the current CPU's
idleness until after the H_CEDE-entry tracing completes on the one hand,
and must tell RCU that the the current CPU is no longer idle before the
H_CEDE-exit tracing starts.

In all other cases, it suffices to inform RCU of CPU idleness upon
idle-loop entry and exit.

This commit makes the required adjustments.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/idle.c            |   16 ++++++++++++++--
 arch/powerpc/platforms/pseries/lpar.c |    4 ++++
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index 2e782a3..3cd73d1 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -46,6 +46,12 @@ static int __init powersave_off(char *arg)
 }
 __setup("powersave=off", powersave_off);
 
+#if defined(CONFIG_PPC_PSERIES) && defined(CONFIG_TRACEPOINTS)
+static const bool idle_uses_rcu = 1;
+#else
+static const bool idle_uses_rcu;
+#endif
+
 /*
  * The body of the idle task.
  */
@@ -56,7 +62,10 @@ void cpu_idle(void)
 
 	set_thread_flag(TIF_POLLING_NRFLAG);
 	while (1) {
-		tick_nohz_idle_enter_norcu();
+		if (idle_uses_rcu)
+			tick_nohz_idle_enter();
+		else
+			tick_nohz_idle_enter_norcu();
 		while (!need_resched() && !cpu_should_die()) {
 			ppc64_runlatch_off();
 
@@ -93,7 +102,10 @@ void cpu_idle(void)
 
 		HMT_medium();
 		ppc64_runlatch_on();
-		tick_nohz_idle_exit_norcu();
+		if (idle_uses_rcu)
+			tick_nohz_idle_exit();
+		else
+			tick_nohz_idle_exit_norcu();
 		preempt_enable_no_resched();
 		if (cpu_should_die())
 			cpu_die();
diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index c9a29da..be2a026 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -554,6 +554,8 @@ void __trace_hcall_entry(unsigned long opcode, unsigned long *args)
 
 	(*depth)++;
 	trace_hcall_entry(opcode, args);
+	if (opcode == H_CEDE)
+		rcu_idle_enter();
 	(*depth)--;
 
 out:
@@ -574,6 +576,8 @@ void __trace_hcall_exit(long opcode, unsigned long retval,
 		goto out;
 
 	(*depth)++;
+	if (opcode == H_CEDE)
+		rcu_idle_exit();
 	trace_hcall_exit(opcode, retval, retbuf);
 	(*depth)--;
 
-- 
1.7.3.2

