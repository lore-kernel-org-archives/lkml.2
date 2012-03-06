Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031342Ab2CFVmF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 16:42:05 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51056 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965219Ab2CFVmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:42:01 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of venki@google.com designates 10.60.4.10 as permitted sender) smtp.mail=venki@google.com; dkim=pass header.i=venki@google.com
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
Subject: [PATCH 2/5] ia64: Use common fork_idle_from_wq in smpboot
Date: Tue,  6 Mar 2012 13:41:11 -0800
Message-Id: <1331070074-31717-3-git-send-email-venki@google.com>
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
 arch/ia64/kernel/smpboot.c |   49 +++----------------------------------------
 1 files changed, 4 insertions(+), 45 deletions(-)

diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
index 5590979..b9026fa 100644
--- a/arch/ia64/kernel/smpboot.c
+++ b/arch/ia64/kernel/smpboot.c
@@ -95,13 +95,8 @@ struct sal_to_os_boot *sal_state_for_booting_cpu = &sal_boot_rendez_state[0];
 
 #define set_brendez_area(x) (sal_state_for_booting_cpu = &sal_boot_rendez_state[(x)]);
 
-#define get_idle_for_cpu(x)		(idle_thread_array[(x)])
-#define set_idle_for_cpu(x,p)	(idle_thread_array[(x)] = (p))
-
 #else
 
-#define get_idle_for_cpu(x)		(NULL)
-#define set_idle_for_cpu(x,p)
 #define set_brendez_area(x)
 #endif
 
@@ -481,53 +476,17 @@ struct pt_regs * __cpuinit idle_regs(struct pt_regs *regs)
 	return NULL;
 }
 
-struct create_idle {
-	struct work_struct work;
-	struct task_struct *idle;
-	struct completion done;
-	int cpu;
-};
-
-void __cpuinit
-do_fork_idle(struct work_struct *work)
-{
-	struct create_idle *c_idle =
-		container_of(work, struct create_idle, work);
-
-	c_idle->idle = fork_idle(c_idle->cpu);
-	complete(&c_idle->done);
-}
-
 static int __cpuinit
 do_boot_cpu (int sapicid, int cpu)
 {
 	int timeout;
-	struct create_idle c_idle = {
-		.work = __WORK_INITIALIZER(c_idle.work, do_fork_idle),
-		.cpu	= cpu,
-		.done	= COMPLETION_INITIALIZER(c_idle.done),
-	};
-
-	/*
-	 * We can't use kernel_thread since we must avoid to
-	 * reschedule the child.
-	 */
- 	c_idle.idle = get_idle_for_cpu(cpu);
- 	if (c_idle.idle) {
-		init_idle(c_idle.idle, cpu);
- 		goto do_rest;
-	}
-
-	schedule_work(&c_idle.work);
-	wait_for_completion(&c_idle.done);
+	struct task_struct *idle;
 
-	if (IS_ERR(c_idle.idle))
+	idle = fork_idle_from_wq(cpu);
+	if (IS_ERR(idle))
 		panic("failed fork for CPU %d", cpu);
 
-	set_idle_for_cpu(cpu, c_idle.idle);
-
-do_rest:
-	task_for_booting_cpu = c_idle.idle;
+	task_for_booting_cpu = idle;
 
 	Dprintk("Sending wakeup vector %lu to AP 0x%x/0x%x.\n", ap_wakeup_vector, cpu, sapicid);
 
-- 
1.7.7.3

