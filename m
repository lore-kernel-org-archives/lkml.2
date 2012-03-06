Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031095Ab2CFVmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 16:42:47 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:51659 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757300Ab2CFVmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:42:04 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of venki@google.com designates 10.182.86.201 as permitted sender) smtp.mail=venki@google.com; dkim=pass header.i=venki@google.com
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
Subject: [PATCH 3/5] mips: Use common fork_idle_from_wq in smpboot
Date: Tue,  6 Mar 2012 13:41:12 -0800
Message-Id: <1331070074-31717-4-git-send-email-venki@google.com>
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
 arch/mips/kernel/smp.c |   47 +++--------------------------------------------
 1 files changed, 3 insertions(+), 44 deletions(-)

diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index 32c1e95..37a4133 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -191,54 +191,13 @@ void __devinit smp_prepare_boot_cpu(void)
  * and keep control until "cpu_online(cpu)" is set.  Note: cpu is
  * physical, not logical.
  */
-static struct task_struct *cpu_idle_thread[NR_CPUS];
-
-struct create_idle {
-	struct work_struct work;
-	struct task_struct *idle;
-	struct completion done;
-	int cpu;
-};
-
-static void __cpuinit do_fork_idle(struct work_struct *work)
-{
-	struct create_idle *c_idle =
-		container_of(work, struct create_idle, work);
-
-	c_idle->idle = fork_idle(c_idle->cpu);
-	complete(&c_idle->done);
-}
-
 int __cpuinit __cpu_up(unsigned int cpu)
 {
 	struct task_struct *idle;
 
-	/*
-	 * Processor goes to start_secondary(), sets online flag
-	 * The following code is purely to make sure
-	 * Linux can schedule processes on this slave.
-	 */
-	if (!cpu_idle_thread[cpu]) {
-		/*
-		 * Schedule work item to avoid forking user task
-		 * Ported from arch/x86/kernel/smpboot.c
-		 */
-		struct create_idle c_idle = {
-			.cpu    = cpu,
-			.done   = COMPLETION_INITIALIZER_ONSTACK(c_idle.done),
-		};
-
-		INIT_WORK_ONSTACK(&c_idle.work, do_fork_idle);
-		schedule_work(&c_idle.work);
-		wait_for_completion(&c_idle.done);
-		idle = cpu_idle_thread[cpu] = c_idle.idle;
-
-		if (IS_ERR(idle))
-			panic(KERN_ERR "Fork failed for CPU %d", cpu);
-	} else {
-		idle = cpu_idle_thread[cpu];
-		init_idle(idle, cpu);
-	}
+	idle = fork_idle_from_wq(cpu);
+	if (IS_ERR(idle))
+		panic(KERN_ERR "Fork failed for CPU %d", cpu);
 
 	mp_ops->boot_secondary(cpu, idle);
 
-- 
1.7.7.3

