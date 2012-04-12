Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934909Ab2DLWGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 18:06:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:38858 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934761Ab2DLWG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 18:06:27 -0400
Date: Fri, 13 Apr 2012 00:06:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: [GIT pull] timer fixes for 3.4
Message-ID: <alpine.LFD.2.02.1204130004080.2542@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus


The itimer removal one is not strictly a fix, but I really wanted to
avoid a rebase of the urgent ones.

Thanks,

	tglx

------------------>
Martin Schwidefsky (1):
      proc: stats: Use arch_idle_time for idle and iowait times if available

Neal Cardwell (1):
      nohz: Fix stale jiffies update in tick_nohz_restart()

Sasikantha babu (1):
      itimer: Schedule silent NULL pointer fixup in setitimer() for removal

Suresh Siddha (1):
      clockevents: tTack broadcast device mode change in tick_broadcast_switch_to_oneshot()

Thomas Gleixner (3):
      tick: Document TICK_ONESHOT config option
      itimer: Use printk_once instead of WARN_ONCE
      Revert "clocksource: Load the ACPI PM clocksource asynchronously"


 Documentation/feature-removal-schedule.txt |    8 ++++++
 drivers/clocksource/acpi_pm.c              |   24 ++++++-------------
 fs/proc/stat.c                             |   34 +++++++++++++++++++++++-----
 kernel/itimer.c                            |    8 +++++-
 kernel/time/Kconfig                        |    4 +++
 kernel/time/tick-broadcast.c               |    4 ++-
 kernel/time/tick-sched.c                   |    4 +-
 7 files changed, 59 insertions(+), 27 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 0cad480..32fae81 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -529,3 +529,11 @@ When:	3.5
 Why:	The old kmap_atomic() with two arguments is deprecated, we only
 	keep it for backward compatibility for few cycles and then drop it.
 Who:	Cong Wang <amwang@redhat.com>
+
+----------------------------
+
+What:	setitimer accepts user NULL pointer (value)
+When:	3.6
+Why:	setitimer is not returning -EFAULT if user pointer is NULL. This
+	violates the spec.
+Who:	Sasikantha Babu <sasikanth.v19@gmail.com>
diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index 82e8820..6b5cf02 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -23,7 +23,6 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
-#include <linux/async.h>
 #include <asm/io.h>
 
 /*
@@ -180,15 +179,17 @@ static int verify_pmtmr_rate(void)
 /* Number of reads we try to get two different values */
 #define ACPI_PM_READ_CHECKS 10000
 
-static void __init acpi_pm_clocksource_async(void *unused, async_cookie_t cookie)
+static int __init init_acpi_pm_clocksource(void)
 {
 	cycle_t value1, value2;
 	unsigned int i, j = 0;
 
+	if (!pmtmr_ioport)
+		return -ENODEV;
 
 	/* "verify" this timing source: */
 	for (j = 0; j < ACPI_PM_MONOTONICITY_CHECKS; j++) {
-		usleep_range(100 * j, 100 * j + 100);
+		udelay(100 * j);
 		value1 = clocksource_acpi_pm.read(&clocksource_acpi_pm);
 		for (i = 0; i < ACPI_PM_READ_CHECKS; i++) {
 			value2 = clocksource_acpi_pm.read(&clocksource_acpi_pm);
@@ -202,34 +203,25 @@ static void __init acpi_pm_clocksource_async(void *unused, async_cookie_t cookie
 			       " 0x%#llx, 0x%#llx - aborting.\n",
 			       value1, value2);
 			pmtmr_ioport = 0;
-			return;
+			return -EINVAL;
 		}
 		if (i == ACPI_PM_READ_CHECKS) {
 			printk(KERN_INFO "PM-Timer failed consistency check "
 			       " (0x%#llx) - aborting.\n", value1);
 			pmtmr_ioport = 0;
-			return;
+			return -ENODEV;
 		}
 	}
 
 	if (verify_pmtmr_rate() != 0){
 		pmtmr_ioport = 0;
-		return;
+		return -ENODEV;
 	}
 
-	clocksource_register_hz(&clocksource_acpi_pm,
+	return clocksource_register_hz(&clocksource_acpi_pm,
 						PMTMR_TICKS_PER_SEC);
 }
 
-static int __init init_acpi_pm_clocksource(void)
-{
-	if (!pmtmr_ioport)
-		return -ENODEV;
-
-	async_schedule(acpi_pm_clocksource_async, NULL);
-	return 0;
-}
-
 /* We use fs_initcall because we want the PCI fixups to have run
  * but we still need to load before device_initcall
  */
diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 6a0c62d..64c3b31 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -18,19 +18,39 @@
 #ifndef arch_irq_stat
 #define arch_irq_stat() 0
 #endif
-#ifndef arch_idle_time
-#define arch_idle_time(cpu) 0
-#endif
+
+#ifdef arch_idle_time
+
+static cputime64_t get_idle_time(int cpu)
+{
+	cputime64_t idle;
+
+	idle = kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE];
+	if (cpu_online(cpu) && !nr_iowait_cpu(cpu))
+		idle += arch_idle_time(cpu);
+	return idle;
+}
+
+static cputime64_t get_iowait_time(int cpu)
+{
+	cputime64_t iowait;
+
+	iowait = kcpustat_cpu(cpu).cpustat[CPUTIME_IOWAIT];
+	if (cpu_online(cpu) && nr_iowait_cpu(cpu))
+		iowait += arch_idle_time(cpu);
+	return iowait;
+}
+
+#else
 
 static u64 get_idle_time(int cpu)
 {
 	u64 idle, idle_time = get_cpu_idle_time_us(cpu, NULL);
 
-	if (idle_time == -1ULL) {
+	if (idle_time == -1ULL)
 		/* !NO_HZ so we can rely on cpustat.idle */
 		idle = kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE];
-		idle += arch_idle_time(cpu);
-	} else
+	else
 		idle = usecs_to_cputime64(idle_time);
 
 	return idle;
@@ -49,6 +69,8 @@ static u64 get_iowait_time(int cpu)
 	return iowait;
 }
 
+#endif
+
 static int show_stat(struct seq_file *p, void *v)
 {
 	int i, j;
diff --git a/kernel/itimer.c b/kernel/itimer.c
index 22000c3..8d262b4 100644
--- a/kernel/itimer.c
+++ b/kernel/itimer.c
@@ -284,8 +284,12 @@ SYSCALL_DEFINE3(setitimer, int, which, struct itimerval __user *, value,
 	if (value) {
 		if(copy_from_user(&set_buffer, value, sizeof(set_buffer)))
 			return -EFAULT;
-	} else
-		memset((char *) &set_buffer, 0, sizeof(set_buffer));
+	} else {
+		memset(&set_buffer, 0, sizeof(set_buffer));
+		printk_once(KERN_WARNING "%s calls setitimer() with new_value NULL pointer."
+			    " Misfeature support will be removed\n",
+			    current->comm);
+	}
 
 	error = do_setitimer(which, &set_buffer, ovalue ? &get_buffer : NULL);
 	if (error || !ovalue)
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 2cf9cc7..a20dc8a 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -1,6 +1,10 @@
 #
 # Timer subsystem related configuration options
 #
+
+# Core internal switch. Selected by NO_HZ / HIGH_RES_TIMERS. This is
+# only related to the tick functionality. Oneshot clockevent devices
+# are supported independ of this.
 config TICK_ONESHOT
 	bool
 
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index e883f57..bf57abd 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -575,10 +575,12 @@ void tick_broadcast_switch_to_oneshot(void)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
+
+	tick_broadcast_device.mode = TICKDEV_MODE_ONESHOT;
+
 	if (cpumask_empty(tick_get_broadcast_mask()))
 		goto end;
 
-	tick_broadcast_device.mode = TICKDEV_MODE_ONESHOT;
 	bc = tick_broadcast_device.evtdev;
 	if (bc)
 		tick_broadcast_setup_oneshot(bc);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 3526038..6a3a5b9 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -534,9 +534,9 @@ static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
 				hrtimer_get_expires(&ts->sched_timer), 0))
 				break;
 		}
-		/* Update jiffies and reread time */
-		tick_do_update_jiffies64(now);
+		/* Reread time and update jiffies */
 		now = ktime_get();
+		tick_do_update_jiffies64(now);
 	}
 }
 
