Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab2IFLdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 07:33:31 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:60053 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab2IFLd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 07:33:28 -0400
X-AuditID: b753bd60-900c0ba0000047ca-47-504888b31b96
X-AuditID: b753bd60-900c0ba0000047ca-47-504888b31b96
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC v2 PATCH 04/21] x86: Avoid RCU warnings on slave CPUs
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 06 Sep 2012 20:27:40 +0900
Message-ID: <20120906112739.13320.53090.stgit@kvmdev>
In-Reply-To: <20120906112718.13320.8231.stgit@kvmdev>
References: <20120906112718.13320.8231.stgit@kvmdev>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize rcu related variables to avoid warnings about RCU usage while
slave CPUs is running specified functions. Also notify RCU subsystem before
the slave CPU is entered into idle state.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 arch/x86/kernel/smpboot.c |    4 ++++
 kernel/rcutree.c          |   14 ++++++++++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index e8cfe377..45dfc1d 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -382,6 +382,8 @@ notrace static void __cpuinit start_slave_cpu(void *unused)
 		f = per_cpu(slave_cpu_func, cpu);
 		per_cpu(slave_cpu_func, cpu).func = NULL;
 
+		rcu_note_context_switch(cpu);
+
 		if (!f.func) {
 			native_safe_halt();
 			continue;
@@ -1005,6 +1007,8 @@ int __cpuinit slave_cpu_up(unsigned int cpu)
 	if (IS_ERR(idle))
 		return PTR_ERR(idle);
 
+	slave_cpu_notify(CPU_SLAVE_UP_PREPARE, cpu);
+
 	ret = __native_cpu_up(cpu, idle, 1);
 
 	cpu_maps_update_done();
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index f280e54..31a7c8c 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2589,6 +2589,9 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
+#ifdef CONFIG_SLAVE_CPU
+	case CPU_SLAVE_UP_PREPARE:
+#endif
 		rcu_prepare_cpu(cpu);
 		rcu_prepare_kthreads(cpu);
 		break;
@@ -2603,6 +2606,9 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 		break;
 	case CPU_DYING:
 	case CPU_DYING_FROZEN:
+#ifdef CONFIG_SLAVE_CPU
+	case CPU_SLAVE_DYING:
+#endif
 		/*
 		 * The whole machine is "stopped" except this CPU, so we can
 		 * touch any data without introducing corruption. We send the
@@ -2616,6 +2622,9 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 	case CPU_DEAD_FROZEN:
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
+#ifdef CONFIG_SLAVE_CPU
+	case CPU_SLAVE_DEAD:
+#endif
 		for_each_rcu_flavor(rsp)
 			rcu_cleanup_dead_cpu(cpu, rsp);
 		break;
@@ -2797,6 +2806,10 @@ static void __init rcu_init_geometry(void)
 	rcu_num_nodes -= n;
 }
 
+static struct notifier_block __cpuinitdata rcu_slave_nb = {
+	.notifier_call = rcu_cpu_notify,
+};
+
 void __init rcu_init(void)
 {
 	int cpu;
@@ -2814,6 +2827,7 @@ void __init rcu_init(void)
 	 * or the scheduler are operational.
 	 */
 	cpu_notifier(rcu_cpu_notify, 0);
+	register_slave_cpu_notifier(&rcu_slave_nb);
 	for_each_online_cpu(cpu)
 		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
 	check_cpu_stall_init();


