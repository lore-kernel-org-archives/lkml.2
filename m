Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab0DTPZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 11:25:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831Ab0DTPZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 11:25:01 -0400
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu, fweisbec@gmail.com
Cc: peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       dzickus@redhat.com
Subject: [PATCH 2/6] [watchdog] convert touch_softlockup_watchdog to touch_watchdog
Date: Tue, 20 Apr 2010 11:23:59 -0400
Message-Id: <1271777043-3807-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1271777043-3807-1-git-send-email-dzickus@redhat.com>
References: <1271777043-3807-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a scripted conversion to remove touch_softlockup_watchdog.

Also converts the once case of touch_all_softlockup_watchdogs to
touch_all_watchdogs.

This is done as part of the removal of the old softlockup code and
transition to the new softlockup code.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/ia64/kernel/time.c         |    2 +-
 arch/ia64/kernel/uncached.c     |    2 +-
 arch/ia64/xen/time.c            |    2 +-
 arch/mn10300/kernel/gdb-stub.c  |    2 +-
 arch/powerpc/kernel/swsusp_64.c |    2 +-
 arch/sparc/kernel/nmi.c         |    2 +-
 arch/x86/kernel/apic/nmi.c      |    2 +-
 arch/x86/xen/smp.c              |    2 +-
 drivers/ide/ide-iops.c          |    2 +-
 drivers/ide/ide-taskfile.c      |    2 +-
 drivers/mtd/nand/nand_base.c    |    4 ++--
 drivers/video/nvidia/nv_accel.c |    2 +-
 include/linux/nmi.h             |    7 +------
 include/linux/sched.h           |   26 ++++++++------------------
 kernel/kgdb.c                   |    6 +++---
 kernel/panic.c                  |    2 +-
 kernel/power/hibernate.c        |    2 +-
 kernel/sched.c                  |    2 +-
 kernel/sched_clock.c            |    2 +-
 kernel/sysctl.c                 |    9 ---------
 kernel/time/tick-sched.c        |    8 ++++----
 kernel/time/timekeeping.c       |    2 +-
 kernel/timer.c                  |    1 -
 kernel/watchdog.c               |   30 +-----------------------------
 24 files changed, 35 insertions(+), 88 deletions(-)

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index a35c661..e9f6a6f 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -368,7 +368,7 @@ ia64_init_itm (void)
 	paravirt_init_missing_ticks_accounting(smp_processor_id());
 
 	/* avoid softlock up message when cpu is unplug and plugged again. */
-	touch_softlockup_watchdog();
+	touch_watchdog();
 
 	/* Setup the CPU local timer tick */
 	ia64_cpu_local_tick();
diff --git a/arch/ia64/kernel/uncached.c b/arch/ia64/kernel/uncached.c
index a595823..d18107f 100644
--- a/arch/ia64/kernel/uncached.c
+++ b/arch/ia64/kernel/uncached.c
@@ -256,7 +256,7 @@ static int __init uncached_build_memmap(u64 uc_start, u64 uc_end, void *arg)
 	struct gen_pool *pool = uncached_pools[nid].pool;
 	size_t size = uc_end - uc_start;
 
-	touch_softlockup_watchdog();
+	touch_watchdog();
 
 	if (pool != NULL) {
 		memset((char *)uc_start, 0, size);
diff --git a/arch/ia64/xen/time.c b/arch/ia64/xen/time.c
index c1c5445..0fa7097 100644
--- a/arch/ia64/xen/time.c
+++ b/arch/ia64/xen/time.c
@@ -233,7 +233,7 @@ static void xen_local_tick_resume(void)
 {
 	/* Just trigger a tick.  */
 	ia64_cpu_local_tick();
-	touch_softlockup_watchdog();
+	touch_watchdog();
 }
 
 void
diff --git a/arch/mn10300/kernel/gdb-stub.c b/arch/mn10300/kernel/gdb-stub.c
index 41b1170..d639eae 100644
--- a/arch/mn10300/kernel/gdb-stub.c
+++ b/arch/mn10300/kernel/gdb-stub.c
@@ -1668,7 +1668,7 @@ done:
 	if (excep == EXCEP_NMI)
 		NMICR = NMICR_NMIF;
 
-	touch_softlockup_watchdog();
+	touch_watchdog();
 
 	local_irq_restore(epsw);
 	return 1;
diff --git a/arch/powerpc/kernel/swsusp_64.c b/arch/powerpc/kernel/swsusp_64.c
index 6f3f069..6f570bc 100644
--- a/arch/powerpc/kernel/swsusp_64.c
+++ b/arch/powerpc/kernel/swsusp_64.c
@@ -14,7 +14,7 @@
 void do_after_copyback(void)
 {
 	iommu_restore();
-	touch_softlockup_watchdog();
+	touch_watchdog();
 	mb();
 }
 
diff --git a/arch/sparc/kernel/nmi.c b/arch/sparc/kernel/nmi.c
index d242a73..a77875f 100644
--- a/arch/sparc/kernel/nmi.c
+++ b/arch/sparc/kernel/nmi.c
@@ -61,7 +61,7 @@ void touch_nmi_watchdog(void)
 		}
 	}
 
-	touch_softlockup_watchdog();
+	touch_watchdog();
 }
 EXPORT_SYMBOL(touch_nmi_watchdog);
 
diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index 5d47682..4fd1312 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -383,7 +383,7 @@ void touch_nmi_watchdog(void)
 	/*
 	 * Tickle the softlockup detector too:
 	 */
-	touch_softlockup_watchdog();
+	touch_watchdog();
 }
 EXPORT_SYMBOL(touch_nmi_watchdog);
 
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 563d205..b4cc3ff 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -60,7 +60,7 @@ static __cpuinit void cpu_bringup(void)
 	int cpu = smp_processor_id();
 
 	cpu_init();
-	touch_softlockup_watchdog();
+	touch_watchdog();
 	preempt_disable();
 
 	xen_enable_sysenter();
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 222c1ef..cc493e2 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -524,7 +524,7 @@ int ide_wait_not_busy(ide_hwif_t *hwif, unsigned long timeout)
 		 */
 		if (stat == 0xff)
 			return -ENODEV;
-		touch_softlockup_watchdog();
+		touch_watchdog();
 		touch_nmi_watchdog();
 	}
 	return -EBUSY;
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index cc8633c..6382883 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -291,7 +291,7 @@ static void ide_pio_datablock(ide_drive_t *drive, struct ide_cmd *cmd,
 	if (cmd->tf_flags & IDE_TFLAG_IO_16BIT)
 		drive->io_32bit = 0;
 
-	touch_softlockup_watchdog();
+	touch_watchdog();
 
 	if (cmd->tf_flags & IDE_TFLAG_MULTI_PIO)
 		nr_bytes = min_t(unsigned, cmd->nleft, drive->mult_count << 9);
diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 8f2958f..5ce4e3b 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -445,7 +445,7 @@ static void panic_nand_wait_ready(struct mtd_info *mtd, unsigned long timeo)
 	for (i = 0; i < timeo; i++) {
 		if (chip->dev_ready(mtd))
 			break;
-		touch_softlockup_watchdog();
+		touch_watchdog();
 		mdelay(1);
 	}
 }
@@ -468,7 +468,7 @@ void nand_wait_ready(struct mtd_info *mtd)
 	do {
 		if (chip->dev_ready(mtd))
 			break;
-		touch_softlockup_watchdog();
+		touch_watchdog();
 	} while (time_before(jiffies, timeo));
 	led_trigger_event(nand_led_trigger, LED_OFF);
 }
diff --git a/drivers/video/nvidia/nv_accel.c b/drivers/video/nvidia/nv_accel.c
index ad6472a..ff2e5c4 100644
--- a/drivers/video/nvidia/nv_accel.c
+++ b/drivers/video/nvidia/nv_accel.c
@@ -73,7 +73,7 @@ static inline void nvidiafb_safe_mode(struct fb_info *info)
 {
 	struct nvidia_par *par = info->par;
 
-	touch_softlockup_watchdog();
+	touch_watchdog();
 	info->pixmap.scan_align = 1;
 	par->lockup = 1;
 }
diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index abd48aa..425b12e 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -20,14 +20,10 @@ extern void touch_nmi_watchdog(void);
 extern void acpi_nmi_disable(void);
 extern void acpi_nmi_enable(void);
 #else
-#ifndef CONFIG_LOCKUP_DETECTOR
 static inline void touch_nmi_watchdog(void)
 {
-	touch_softlockup_watchdog();
+	touch_watchdog();
 }
-#else
-extern void touch_nmi_watchdog(void);
-#endif
 static inline void acpi_nmi_disable(void) { }
 static inline void acpi_nmi_enable(void) { }
 #endif
@@ -52,7 +48,6 @@ static inline bool trigger_all_cpu_backtrace(void)
 #endif
 
 #ifdef CONFIG_LOCKUP_DETECTOR
-int hw_nmi_is_cpu_stuck(struct pt_regs *);
 u64 hw_nmi_get_sample_period(void);
 extern int watchdog_enabled;
 struct ctl_table;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2455ff5..0c128ad 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -307,23 +307,19 @@ extern void scheduler_tick(void);
 
 extern void sched_show_task(struct task_struct *p);
 
-#ifdef CONFIG_DETECT_SOFTLOCKUP
-extern void softlockup_tick(void);
-extern void touch_softlockup_watchdog(void);
-extern void touch_all_softlockup_watchdogs(void);
-extern int proc_dosoftlockup_thresh(struct ctl_table *table, int write,
-				    void __user *buffer,
-				    size_t *lenp, loff_t *ppos);
+#ifdef CONFIG_LOCKUP_DETECTOR
+extern void touch_watchdog(void);
+extern void touch_all_watchdogs(void);
 extern unsigned int  softlockup_panic;
 extern int softlockup_thresh;
+extern int proc_dowatchdog_thresh(struct ctl_table *table, int write,
+				  void __user *buffer,
+				  size_t *lenp, loff_t *ppos);
 #else
-static inline void softlockup_tick(void)
-{
-}
-static inline void touch_softlockup_watchdog(void)
+static inline void touch_watchdog(void)
 {
 }
-static inline void touch_all_softlockup_watchdogs(void)
+static inline void touch_all_watchdogs(void)
 {
 }
 #endif
@@ -338,12 +334,6 @@ extern int proc_dohung_task_timeout_secs(struct ctl_table *table, int write,
 					 size_t *lenp, loff_t *ppos);
 #endif
 
-#ifdef CONFIG_LOCKUP_DETECTOR
-extern int proc_dowatchdog_thresh(struct ctl_table *table, int write,
-				  void __user *buffer,
-				  size_t *lenp, loff_t *ppos);
-#endif
-
 /* Attach to any functions which should be ignored in wchan output. */
 #define __sched		__attribute__((__section__(".sched.text")))
 
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 2eb517e..15df969 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -596,7 +596,7 @@ static void kgdb_wait(struct pt_regs *regs)
 
 	/* Signal the primary CPU that we are done: */
 	atomic_set(&cpu_in_kgdb[cpu], 0);
-	touch_softlockup_watchdog();
+	touch_watchdog();
 	clocksource_touch_watchdog();
 	local_irq_restore(flags);
 }
@@ -1450,7 +1450,7 @@ acquirelock:
 	    (kgdb_info[cpu].task &&
 	     kgdb_info[cpu].task->pid != kgdb_sstep_pid) && --sstep_tries) {
 		atomic_set(&kgdb_active, -1);
-		touch_softlockup_watchdog();
+		touch_watchdog();
 		clocksource_touch_watchdog();
 		local_irq_restore(flags);
 
@@ -1550,7 +1550,7 @@ kgdb_restore:
 	}
 	/* Free kgdb_active */
 	atomic_set(&kgdb_active, -1);
-	touch_softlockup_watchdog();
+	touch_watchdog();
 	clocksource_touch_watchdog();
 	local_irq_restore(flags);
 
diff --git a/kernel/panic.c b/kernel/panic.c
index c787333..eda8051 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -136,7 +136,7 @@ NORET_TYPE void panic(const char * fmt, ...)
 #endif
 	local_irq_enable();
 	for (i = 0; ; ) {
-		touch_softlockup_watchdog();
+		touch_watchdog();
 		i += panic_blink(i);
 		mdelay(1);
 		i++;
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index bbfe472..217929a 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -415,7 +415,7 @@ static int resume_target_kernel(bool platform_mode)
 	 */
 	swsusp_free();
 	restore_processor_state();
-	touch_softlockup_watchdog();
+	touch_watchdog();
 
 	sysdev_resume();
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 7266b91..2e82485 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6991,7 +6991,7 @@ void show_state_filter(unsigned long state_filter)
 			sched_show_task(p);
 	} while_each_thread(g, p);
 
-	touch_all_softlockup_watchdogs();
+	touch_all_watchdogs();
 
 #ifdef CONFIG_SCHED_DEBUG
 	sysrq_sched_debug_show();
diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index 5b49613..f98b3e4 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -232,7 +232,7 @@ void sched_clock_idle_wakeup_event(u64 delta_ns)
 		return;
 
 	sched_clock_tick();
-	touch_softlockup_watchdog();
+	touch_watchdog();
 }
 EXPORT_SYMBOL_GPL(sched_clock_idle_wakeup_event);
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 1083897..1fec781 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -827,15 +827,6 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
-	{
-		.procname	= "softlockup_thresh",
-		.data		= &softlockup_thresh,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dosoftlockup_thresh,
-		.extra1		= &neg_one,
-		.extra2		= &sixty,
-	},
 #endif
 #ifdef CONFIG_DETECT_HUNG_TASK
 	{
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index f992762..29035ac 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -147,7 +147,7 @@ static void tick_nohz_update_jiffies(ktime_t now)
 	tick_do_update_jiffies64(now);
 	local_irq_restore(flags);
 
-	touch_softlockup_watchdog();
+	touch_watchdog();
 }
 
 static void tick_nohz_stop_idle(int cpu, ktime_t now)
@@ -494,7 +494,7 @@ void tick_nohz_restart_sched_tick(void)
 		account_idle_ticks(ticks);
 #endif
 
-	touch_softlockup_watchdog();
+	touch_watchdog();
 	/*
 	 * Cancel the scheduled timer and restore the tick
 	 */
@@ -547,7 +547,7 @@ static void tick_nohz_handler(struct clock_event_device *dev)
 	 * do when we go busy again does not account too much ticks.
 	 */
 	if (ts->tick_stopped) {
-		touch_softlockup_watchdog();
+		touch_watchdog();
 		ts->idle_jiffies++;
 	}
 
@@ -708,7 +708,7 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 		 * when we go busy again does not account too much ticks.
 		 */
 		if (ts->tick_stopped) {
-			touch_softlockup_watchdog();
+			touch_watchdog();
 			ts->idle_jiffies++;
 		}
 		update_process_times(user_mode(regs));
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 7faaa32..661fc40 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -600,7 +600,7 @@ static int timekeeping_resume(struct sys_device *dev)
 	timekeeping_suspended = 0;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
-	touch_softlockup_watchdog();
+	touch_watchdog();
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
 
diff --git a/kernel/timer.c b/kernel/timer.c
index c61a794..80c8da5 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1223,7 +1223,6 @@ void run_local_timers(void)
 {
 	hrtimer_run_queues();
 	raise_softirq(TIMER_SOFTIRQ);
-	softlockup_tick();
 }
 
 /*
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 6c87d7d..73529a8 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -125,7 +125,7 @@ void touch_watchdog(void)
 }
 EXPORT_SYMBOL(touch_watchdog);
 
-void touch_all_watchdog(void)
+void touch_all_watchdogs(void)
 {
 	int cpu;
 
@@ -144,25 +144,6 @@ void touch_nmi_watchdog(void)
 }
 EXPORT_SYMBOL(touch_nmi_watchdog);
 
-void touch_all_nmi_watchdog(void)
-{
-	touch_all_watchdog();
-}
-
-void touch_softlockup_watchdog(void)
-{
-	touch_watchdog();
-}
-
-void touch_all_softlockup_watchdogs(void)
-{
-	touch_all_watchdog();
-}
-
-void softlockup_tick(void)
-{
-}
-
 #ifdef CONFIG_PERF_EVENTS_NMI
 /* watchdog detector functions */
 static int is_hardlockup(int cpu)
@@ -510,15 +491,6 @@ int proc_dowatchdog_thresh(struct ctl_table *table, int write,
 {
 	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 }
-
-/* stub functions */
-int proc_dosoftlockup_thresh(struct ctl_table *table, int write,
-			     void __user *buffer,
-			     size_t *lenp, loff_t *ppos)
-{
-	return proc_dowatchdog_thresh(table, write, buffer, lenp, ppos);
-}
-/* end of stub functions */
 #endif /* CONFIG_SYSCTL */
 
 
-- 
1.6.5.2

