Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034Ab2CFVmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 16:42:15 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:51659 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031372Ab2CFVmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:42:10 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of venki@google.com designates 10.182.160.10 as permitted sender) smtp.mail=venki@google.com; dkim=pass header.i=venki@google.com
MIME-Version: 1.0
From: Venkatesh Pallipadi <venki@google.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Aaron Durbin <adurbin@google.com>,
        Paul Turner <pjt@google.com>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH 5/5] s390: Use common fork_idle_from_wq in smpboot
Date: Tue,  6 Mar 2012 13:41:14 -0800
Message-Id: <1331070074-31717-6-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331070074-31717-1-git-send-email-venki@google.com>
References: <1330710103.30167.84.camel@sbsiddha-desk.sc.intel.com>
 <1331070074-31717-1-git-send-email-venki@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup. Instead of reimplementing fork_idle on wq and idle task caching,
use fork_idle_from_wq().

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 arch/s390/kernel/smp.c |   38 +++++---------------------------------
 1 files changed, 5 insertions(+), 33 deletions(-)

diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 2398ce6..7255a57 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -58,8 +58,6 @@
 /* logical cpu to cpu address */
 unsigned short __cpu_logical_map[NR_CPUS];
 
-static struct task_struct *current_set[NR_CPUS];
-
 static u8 smp_cpu_type;
 static int smp_use_sigp_detection;
 
@@ -562,22 +560,6 @@ int __cpuinit start_secondary(void *cpuvoid)
 	return 0;
 }
 
-struct create_idle {
-	struct work_struct work;
-	struct task_struct *idle;
-	struct completion done;
-	int cpu;
-};
-
-static void __cpuinit smp_fork_idle(struct work_struct *work)
-{
-	struct create_idle *c_idle;
-
-	c_idle = container_of(work, struct create_idle, work);
-	c_idle->idle = fork_idle(c_idle->cpu);
-	complete(&c_idle->done);
-}
-
 static int __cpuinit smp_alloc_lowcore(int cpu)
 {
 	unsigned long async_stack, panic_stack;
@@ -644,7 +626,6 @@ static void smp_free_lowcore(int cpu)
 int __cpuinit __cpu_up(unsigned int cpu)
 {
 	struct _lowcore *cpu_lowcore;
-	struct create_idle c_idle;
 	struct task_struct *idle;
 	struct stack_frame *sf;
 	u32 lowcore;
@@ -652,19 +633,11 @@ int __cpuinit __cpu_up(unsigned int cpu)
 
 	if (smp_cpu_state[cpu] != CPU_STATE_CONFIGURED)
 		return -EIO;
-	idle = current_set[cpu];
-	if (!idle) {
-		c_idle.done = COMPLETION_INITIALIZER_ONSTACK(c_idle.done);
-		INIT_WORK_ONSTACK(&c_idle.work, smp_fork_idle);
-		c_idle.cpu = cpu;
-		schedule_work(&c_idle.work);
-		wait_for_completion(&c_idle.done);
-		if (IS_ERR(c_idle.idle))
-			return PTR_ERR(c_idle.idle);
-		idle = c_idle.idle;
-		current_set[cpu] = c_idle.idle;
-	}
-	init_idle(idle, cpu);
+
+	idle = fork_idle_from_wq(cpu);
+	if (IS_ERR(idle))
+		return PTR_ERR(idle);
+
 	if (smp_alloc_lowcore(cpu))
 		return -ENOMEM;
 	do {
@@ -836,7 +809,6 @@ void __init smp_prepare_boot_cpu(void)
 	set_cpu_present(0, true);
 	set_cpu_online(0, true);
 	S390_lowcore.percpu_offset = __per_cpu_offset[0];
-	current_set[0] = current;
 	smp_cpu_state[0] = CPU_STATE_CONFIGURED;
 	cpu_set_polarization(0, POLARIZATION_UNKNOWN);
 }
-- 
1.7.7.3

