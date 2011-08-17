Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab1HQQID (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 12:08:03 -0400
Received: from relay2.sgi.com ([192.48.179.30]:39521 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753939Ab1HQQIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 12:08:01 -0400
Date: Wed, 17 Aug 2011 11:07:59 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] specific do_timer_cpu value for nohz off mode
Message-ID: <20110817160759.GA3482@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reposting this, as this was posted 2 weeks ago with no replies.

Jiffies updates are currently done by the tick_do_timer_cpu.  This has a
non-deterministic value that can be any running cpu on the system.  It
changes dynamically in nohz mode.  When nohz mode is off, it gets set to
a more static, but still non-deterministic value.

While the nohz behavior is necessary, is there a reason why the nohz off
case can't have a specific value, say 0 as it was on earlier kernels?
If the cpu is offlined, let the value change at that time (note that the
x86 arch disallows offlining cpu 0).

There are certain cases where this would be advantageous, especially where
timely jiffies updates may not necessarily occur on specific processors.

The following sample patch presents one way that this could be done.
Processors wait for the selected cpu to enter high resolution mode before
they do so.

Note that this patch is not hotplug aware (however, should the
tick_static_do_timer_cpu be offlined, the tick_do_timer_cpu simply becomes
another cpu anyway).

Comments on this idea, or the sample patch?

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
---
 Documentation/kernel-parameters.txt |    8 +++++
 kernel/time/tick-sched.c            |   46 ++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

Index: linux/kernel/time/tick-sched.c
===================================================================
--- linux.orig/kernel/time/tick-sched.c
+++ linux/kernel/time/tick-sched.c
@@ -30,11 +30,54 @@
  */
 static DEFINE_PER_CPU(struct tick_sched, tick_cpu_sched);
 
+DECLARE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases);
+
 /*
  * The time, when the last jiffy update happened. Protected by xtime_lock.
  */
 static ktime_t last_jiffies_update;
 
+/*
+ * Static tick_do_timer_cpu
+ */
+static int tick_static_do_timer_cpu __read_mostly = -1;
+
+/*
+ * Set tick_do_timer_cpu to a static cpu.
+ *
+ * Supported on systems w/nohz=off only.
+ * Selected cpu can be offlined.  If this is done, another cpu will be chosen,
+ * but will not revert back if selected cpu is onlined again.
+ */
+static int __init setup_static_do_timer_cpu(char *s)
+{
+	if (kstrtoint(s, 0, &tick_static_do_timer_cpu) < 0) {
+		printk(KERN_WARNING "Invalid tick_static_do_timer_cpu specified\n");
+		return 0;
+	}
+	printk(KERN_INFO "Set tick_static_do_timer_cpu %d\n",
+		tick_static_do_timer_cpu);
+
+	return 1;
+}
+__setup("do_timer_cpu=", setup_static_do_timer_cpu);
+
+/*
+ * Check to see if we need to wait for the selected static do_timer_cpu
+ * to enter high res mode first.
+ */
+static int wait_for_static_do_timer_cpu(void)
+{
+	if (tick_static_do_timer_cpu == -1)
+		return 0;
+
+	if (smp_processor_id() != tick_static_do_timer_cpu &&
+	    !*per_cpu_ptr(&hrtimer_bases.hres_active, tick_static_do_timer_cpu))
+		return 1;
+
+	return 0;
+}
+
 struct tick_sched *tick_get_tick_sched(int cpu)
 {
 	return &per_cpu(tick_cpu_sched, cpu);
@@ -848,6 +891,9 @@ int tick_check_oneshot_change(int allow_
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 
+	if (!allow_nohz && !tick_nohz_enabled && wait_for_static_do_timer_cpu())
+		return 0;
+
 	if (!test_and_clear_bit(0, &ts->check_clocks))
 		return 0;
 
Index: linux/Documentation/kernel-parameters.txt
===================================================================
--- linux.orig/Documentation/kernel-parameters.txt
+++ linux/Documentation/kernel-parameters.txt
@@ -665,6 +665,14 @@ bytes respectively. Such letter suffixes
 			The filter can be disabled or changed to another
 			driver later using sysfs.
 
+	do_timer_cpu=<cpu number>
+			This selects the cpu to process jiffies updates
+			when nohz mode is disabled.
+			Works only with high resolution mode enabled.
+			The selected cpu can be offlined.  If this is done,
+			another cpu will be chosen, but will not revert back
+			if the selected cpu is onlined again.
+
 	dscc4.setup=	[NET]
 
 	earlycon=	[KNL] Output early console device and options.
