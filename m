Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab1BCPr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 10:47:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37191 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932210Ab1BCPrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 10:47:25 -0500
Date: Thu, 3 Feb 2011 16:47:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20110203154708.GA11267@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Eric Dumazet (1):
      perf: Fix alloc_callchain_buffers()

Marcin Slusarz (3):
      watchdog: Fix broken nowatchdog logic
      watchdog: Fix sysctl consistency
      watchdog: Don't change watchdog state on read of sysctl

Peter Zijlstra (1):
      perf: Fix reading in perf_event_read()

Stephane Eranian (1):
      perf: Fix Pentium4 raw event validation


 arch/x86/kernel/cpu/perf_event_p4.c |   12 ++++++++-
 kernel/perf_event.c                 |   10 ++++----
 kernel/watchdog.c                   |   43 +++++++++++++++-------------------
 3 files changed, 34 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index e56b9bf..f7a0993 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -682,7 +682,7 @@ static int p4_validate_raw_event(struct perf_event *event)
 	 * if an event is shared accross the logical threads
 	 * the user needs special permissions to be able to use it
 	 */
-	if (p4_event_bind_map[v].shared) {
+	if (p4_ht_active() && p4_event_bind_map[v].shared) {
 		if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
 			return -EACCES;
 	}
@@ -727,7 +727,8 @@ static int p4_hw_config(struct perf_event *event)
 		event->hw.config = p4_set_ht_bit(event->hw.config);
 
 	if (event->attr.type == PERF_TYPE_RAW) {
-
+		struct p4_event_bind *bind;
+		unsigned int esel;
 		/*
 		 * Clear bits we reserve to be managed by kernel itself
 		 * and never allowed from a user space
@@ -743,6 +744,13 @@ static int p4_hw_config(struct perf_event *event)
 		 * bits since we keep additional info here (for cache events and etc)
 		 */
 		event->hw.config |= event->attr.config;
+		bind = p4_config_get_bind(event->attr.config);
+		if (!bind) {
+			rc = -EINVAL;
+			goto out;
+		}
+		esel = P4_OPCODE_ESEL(bind->opcode);
+		event->hw.config |= p4_config_pack_cccr(P4_CCCR_ESEL(esel));
 	}
 
 	rc = x86_setup_perfctr(event);
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 126a302..999835b 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1901,11 +1901,12 @@ static void __perf_event_read(void *info)
 		return;
 
 	raw_spin_lock(&ctx->lock);
-	update_context_time(ctx);
+	if (ctx->is_active)
+		update_context_time(ctx);
 	update_event_times(event);
+	if (event->state == PERF_EVENT_STATE_ACTIVE)
+		event->pmu->read(event);
 	raw_spin_unlock(&ctx->lock);
-
-	event->pmu->read(event);
 }
 
 static inline u64 perf_event_count(struct perf_event *event)
@@ -1999,8 +2000,7 @@ static int alloc_callchain_buffers(void)
 	 * accessed from NMI. Use a temporary manual per cpu allocation
 	 * until that gets sorted out.
 	 */
-	size = sizeof(*entries) + sizeof(struct perf_callchain_entry *) *
-		num_possible_cpus();
+	size = offsetof(struct callchain_cpus_entries, cpu_entries[nr_cpu_ids]);
 
 	entries = kzalloc(size, GFP_KERNEL);
 	if (!entries)
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index d7ebdf4..f37f974 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -27,7 +27,7 @@
 #include <asm/irq_regs.h>
 #include <linux/perf_event.h>
 
-int watchdog_enabled;
+int watchdog_enabled = 1;
 int __read_mostly softlockup_thresh = 60;
 
 static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
@@ -43,9 +43,6 @@ static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_saved);
 static DEFINE_PER_CPU(struct perf_event *, watchdog_ev);
 #endif
 
-static int no_watchdog;
-
-
 /* boot commands */
 /*
  * Should we panic when a soft-lockup or hard-lockup occurs:
@@ -58,7 +55,7 @@ static int __init hardlockup_panic_setup(char *str)
 	if (!strncmp(str, "panic", 5))
 		hardlockup_panic = 1;
 	else if (!strncmp(str, "0", 1))
-		no_watchdog = 1;
+		watchdog_enabled = 0;
 	return 1;
 }
 __setup("nmi_watchdog=", hardlockup_panic_setup);
@@ -77,7 +74,7 @@ __setup("softlockup_panic=", softlockup_panic_setup);
 
 static int __init nowatchdog_setup(char *str)
 {
-	no_watchdog = 1;
+	watchdog_enabled = 0;
 	return 1;
 }
 __setup("nowatchdog", nowatchdog_setup);
@@ -85,7 +82,7 @@ __setup("nowatchdog", nowatchdog_setup);
 /* deprecated */
 static int __init nosoftlockup_setup(char *str)
 {
-	no_watchdog = 1;
+	watchdog_enabled = 0;
 	return 1;
 }
 __setup("nosoftlockup", nosoftlockup_setup);
@@ -432,9 +429,6 @@ static int watchdog_enable(int cpu)
 		wake_up_process(p);
 	}
 
-	/* if any cpu succeeds, watchdog is considered enabled for the system */
-	watchdog_enabled = 1;
-
 	return 0;
 }
 
@@ -462,12 +456,16 @@ static void watchdog_disable(int cpu)
 static void watchdog_enable_all_cpus(void)
 {
 	int cpu;
-	int result = 0;
+
+	watchdog_enabled = 0;
 
 	for_each_online_cpu(cpu)
-		result += watchdog_enable(cpu);
+		if (!watchdog_enable(cpu))
+			/* if any cpu succeeds, watchdog is considered
+			   enabled for the system */
+			watchdog_enabled = 1;
 
-	if (result)
+	if (!watchdog_enabled)
 		printk(KERN_ERR "watchdog: failed to be enabled on some cpus\n");
 
 }
@@ -476,9 +474,6 @@ static void watchdog_disable_all_cpus(void)
 {
 	int cpu;
 
-	if (no_watchdog)
-		return;
-
 	for_each_online_cpu(cpu)
 		watchdog_disable(cpu);
 
@@ -498,10 +493,12 @@ int proc_dowatchdog_enabled(struct ctl_table *table, int write,
 {
 	proc_dointvec(table, write, buffer, length, ppos);
 
-	if (watchdog_enabled)
-		watchdog_enable_all_cpus();
-	else
-		watchdog_disable_all_cpus();
+	if (write) {
+		if (watchdog_enabled)
+			watchdog_enable_all_cpus();
+		else
+			watchdog_disable_all_cpus();
+	}
 	return 0;
 }
 
@@ -530,7 +527,8 @@ cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		break;
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		err = watchdog_enable(hotcpu);
+		if (watchdog_enabled)
+			err = watchdog_enable(hotcpu);
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
@@ -555,9 +553,6 @@ void __init lockup_detector_init(void)
 	void *cpu = (void *)(long)smp_processor_id();
 	int err;
 
-	if (no_watchdog)
-		return;
-
 	err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
 	WARN_ON(notifier_to_errno(err));
 
