Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837Ab2EXRy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 13:54:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:57200 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245Ab2EXRyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 13:54:54 -0400
Message-Id: <20120524175056.391516712@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 24 May 2012 17:54:51 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chen Gong <gong.chen@linux.intel.com>, tony.luck@intel.com, bp@amd64.org,
        x86@kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 1/2] x86: mce Cleanup timer mess
References: <20120524174943.989990966@linutronix.de>
Content-Disposition: inline; filename=x86-mce-cleanup-timer-mess.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use unsigned long for dealing with jiffies not int. Rename the
callback to something sensible. Use __this_cpu_read/write for
accessing per cpu data.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce.c
+++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1237,15 +1237,15 @@ void mce_log_therm_throt_event(__u64 sta
  * poller finds an MCE, poll 2x faster.  When the poller finds no more
  * errors, poll 2x slower (up to check_interval seconds).
  */
-static int check_interval = 5 * 60; /* 5 minutes */
+static unsigned long check_interval = 5 * 60; /* 5 minutes */
 
-static DEFINE_PER_CPU(int, mce_next_interval); /* in jiffies */
+static DEFINE_PER_CPU(unsigned long, mce_next_interval); /* in jiffies */
 static DEFINE_PER_CPU(struct timer_list, mce_timer);
 
-static void mce_start_timer(unsigned long data)
+static void mce_timer_fn(unsigned long data)
 {
-	struct timer_list *t = &per_cpu(mce_timer, data);
-	int *n;
+	struct timer_list *t = &__get_cpu_var(mce_timer);
+	unsigned long iv;
 
 	WARN_ON(smp_processor_id() != data);
 
@@ -1258,13 +1258,14 @@ static void mce_start_timer(unsigned lon
 	 * Alert userspace if needed.  If we logged an MCE, reduce the
 	 * polling interval, otherwise increase the polling interval.
 	 */
-	n = &__get_cpu_var(mce_next_interval);
+	iv = __this_cpu_read(mce_next_interval);
 	if (mce_notify_irq())
-		*n = max(*n/2, HZ/100);
+		iv = max(iv, (unsigned long) HZ/100);
 	else
-		*n = min(*n*2, (int)round_jiffies_relative(check_interval*HZ));
+		iv = min(iv * 2, round_jiffies_relative(check_interval * HZ));
+	__this_cpu_write(mce_next_interval, iv);
 
-	t->expires = jiffies + *n;
+	t->expires = jiffies + iv;
 	add_timer_on(t, smp_processor_id());
 }
 
@@ -1542,17 +1543,17 @@ static void __mcheck_cpu_init_vendor(str
 static void __mcheck_cpu_init_timer(void)
 {
 	struct timer_list *t = &__get_cpu_var(mce_timer);
-	int *n = &__get_cpu_var(mce_next_interval);
+	unsigned long iv = __this_cpu_read(mce_next_interval);
 
-	setup_timer(t, mce_start_timer, smp_processor_id());
+	setup_timer(t, mce_timer_fn, smp_processor_id());
 
 	if (mce_ignore_ce)
 		return;
 
-	*n = check_interval * HZ;
-	if (!*n)
+	__this_cpu_write(mce_next_interval, iv);
+	if (!iv)
 		return;
-	t->expires = round_jiffies(jiffies + *n);
+	t->expires = round_jiffies(jiffies + iv);
 	add_timer_on(t, smp_processor_id());
 }
 
@@ -2262,7 +2263,7 @@ mce_cpu_callback(struct notifier_block *
 	case CPU_DOWN_FAILED_FROZEN:
 		if (!mce_ignore_ce && check_interval) {
 			t->expires = round_jiffies(jiffies +
-					   __get_cpu_var(mce_next_interval));
+					per_cpu(mce_next_interval, cpu));
 			add_timer_on(t, cpu);
 		}
 		smp_call_function_single(cpu, mce_reenable_cpu, &action, 1);


