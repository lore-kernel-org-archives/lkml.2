Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816Ab2FFV3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:29:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:52063 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756395Ab2FFV1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:27:16 -0400
Message-Id: <20120606212334.710908084@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jun 2012 21:27:14 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Borislav Petkov <borislav.petkov@amd.com>,
        Chen Gong <gong.chen@linux.intel.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch 4/6] x86: mce: Split timer init
References: <20120606211746.693649684@linutronix.de>
Content-Disposition: inline; filename=x86-mce-split-timer-init.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split timer init function into the init and the start part, so the
start part can replace the open coded version in CPU_DOWN_FAILED.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

Index: tip/arch/x86/kernel/cpu/mcheck/mce.c
===================================================================
--- tip.orig/arch/x86/kernel/cpu/mcheck/mce.c
+++ tip/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1554,23 +1554,28 @@ static void __mcheck_cpu_init_vendor(str
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
@@ -2275,12 +2280,8 @@ mce_cpu_callback(struct notifier_block *
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


