Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab2GRH7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 03:59:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:42420 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858Ab2GRH6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 03:58:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="179422672"
From: Chen Gong <gong.chen@linux.intel.com>
To: tglx@linutronix.de
Cc: tony.luck@intel.com, bp@amd64.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Chen Gong <gong.chen@linux.intel.com>
Subject: [PATCH 3/5] x86: mce: Split timer init
Date: Wed, 18 Jul 2012 15:59:32 -0400
Message-Id: <1342641574-32126-4-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1342641574-32126-1-git-send-email-gong.chen@linux.intel.com>
References: <1342641574-32126-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split timer init function into the init and the start part, so the
start part can replace the open coded version in CPU_DOWN_FAILED.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index da27c5d..9bc425f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1554,23 +1554,28 @@ static void __mcheck_cpu_init_vendor(struct cpuinfo_x86 *c)
 	}
 }
 
-static void __mcheck_cpu_init_timer(void)
+static void mce_start_timer(unsigned int cpu, struct timer_list *t)
 {
-	struct timer_list *t = &__get_cpu_var(mce_timer);
 	unsigned long iv = check_interval * HZ;
 
-	setup_timer(t, mce_timer_fn, smp_processor_id());
+	__this_cpu_write(mce_next_interval, iv);
 
-	if (mce_ignore_ce)
+	if (mce_ignore_ce || !iv)
 		return;
 
-	__this_cpu_write(mce_next_interval, iv);
-	if (!iv)
-		return;
 	t->expires = round_jiffies(jiffies + iv);
 	add_timer_on(t, smp_processor_id());
 }
 
+static void __mcheck_cpu_init_timer(void)
+{
+	struct timer_list *t = &__get_cpu_var(mce_timer);
+	unsigned int cpu = smp_processor_id();
+
+	setup_timer(t, mce_timer_fn, cpu);
+	mce_start_timer(cpu, t);
+}
+
 /* Handle unconfigured int18 (should never happen) */
 static void unexpected_machine_check(struct pt_regs *regs, long error_code)
 {
@@ -2275,12 +2280,8 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		break;
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
-		if (!mce_ignore_ce && check_interval) {
-			t->expires = round_jiffies(jiffies +
-					per_cpu(mce_next_interval, cpu));
-			add_timer_on(t, cpu);
-		}
 		smp_call_function_single(cpu, mce_reenable_cpu, &action, 1);
+		mce_start_timer(cpu, t);
 		break;
 	case CPU_POST_DEAD:
 		/* intentionally ignoring frozen here */
-- 
1.7.10.4

