Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933269Ab1JZPHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 11:07:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37997 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933076Ab1JZPHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 11:07:07 -0400
Date: Wed, 26 Oct 2011 17:05:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer changes for v3.2
Message-ID: <20111026150517.GA25293@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-core-for-linus

 Thanks,

	Ingo

------------------>
Heiko Carstens (2):
      nohz: Remove "Switched to NOHz mode" debugging messages
      time, s390: Get rid of compile warning

Jamie Iles (1):
      dw_apb_timer: constify clocksource name

John Stultz (9):
      alarmtimers: Change alarmtimer functions to return alarmtimer_restart values
      alarmtimers: Push rearming peroidic timers down into alamrtimer handler
      alarmtimers: Add alarm_forward functionality
      alarmtimers: Remove interval cap limit hack
      alarmtimers: Remove period from alarm structure
      alarmtimers: Add more refined alarm state tracking
      alarmtimers: Add try_to_cancel functionality
      alarmtimers: Rework RTC device selection using class interface
      time: Cleanup old CONFIG_GENERIC_TIME references that snuck in

Martin Schwidefsky (3):
      clockevents: Make minimum delay adjustments configurable
      clockevents: Add direct ktime programming function
      s390: Use direct ktime path for s390 clockevent device

Michal Hocko (4):
      cputime: Clean up cputime_to_usecs and usecs_to_cputime macros
      nohz: Fix update_ts_time_stat idle accounting
      nohz: Make idle/iowait counter update conditional
      proc: Consider NO_HZ when printing idle and iowait times

Peter Zijlstra (1):
      posix-cpu-timers: Cure SMP accounting oddities

Thomas Gleixner (2):
      clocksource: Make watchdog reset lockless
      alarmtimers: Fix error handling

hank (1):
      time: Change jiffies_to_clock_t() argument type to unsigned long


 arch/arm/Kconfig                       |    4 -
 arch/mn10300/Kconfig                   |    3 -
 arch/s390/kernel/time.c                |   13 +-
 arch/tile/Kconfig                      |    3 -
 arch/tile/configs/tilegx_defconfig     |    1 -
 arch/tile/configs/tilepro_defconfig    |    1 -
 arch/um/defconfig                      |    1 -
 arch/x86/Kconfig                       |    1 +
 arch/xtensa/configs/iss_defconfig      |    1 -
 arch/xtensa/configs/s6105_defconfig    |    1 -
 drivers/clocksource/dw_apb_timer.c     |    2 +-
 drivers/cpufreq/cpufreq_conservative.c |    4 +-
 drivers/cpufreq/cpufreq_ondemand.c     |    4 +-
 fs/proc/stat.c                         |   41 ++++-
 include/asm-generic/cputime.h          |    4 +-
 include/linux/alarmtimer.h             |   51 ++++++-
 include/linux/clockchips.h             |   12 +-
 include/linux/dw_apb_timer.h           |    2 +-
 include/linux/jiffies.h                |    2 +-
 include/linux/posix-timers.h           |    5 +-
 include/linux/sched.h                  |    1 -
 kernel/posix-cpu-timers.c              |    5 +-
 kernel/sched.c                         |   24 ---
 kernel/time.c                          |    2 +-
 kernel/time/Kconfig                    |    2 +
 kernel/time/alarmtimer.c               |  266 ++++++++++++++++++++++----------
 kernel/time/clockevents.c              |  129 ++++++++++++++--
 kernel/time/clocksource.c              |   38 ++---
 kernel/time/tick-broadcast.c           |    4 +-
 kernel/time/tick-common.c              |    4 +-
 kernel/time/tick-internal.h            |    2 -
 kernel/time/tick-oneshot.c             |   77 +---------
 kernel/time/tick-sched.c               |   55 +++++--
 33 files changed, 480 insertions(+), 285 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 2c71a8f..37cc722 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -347,7 +347,6 @@ config ARCH_GEMINI
 config ARCH_PRIMA2
 	bool "CSR SiRFSoC PRIMA2 ARM Cortex A9 Platform"
 	select CPU_V7
-	select GENERIC_TIME
 	select NO_IOPORT
 	select GENERIC_CLOCKEVENTS
 	select CLKDEV_LOOKUP
@@ -520,7 +519,6 @@ config ARCH_LPC32XX
 	select ARM_AMBA
 	select USB_ARCH_HAS_OHCI
 	select CLKDEV_LOOKUP
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	help
 	  Support for the NXP LPC32XX family of processors
@@ -599,7 +597,6 @@ config ARCH_TEGRA
 	bool "NVIDIA Tegra"
 	select CLKDEV_LOOKUP
 	select CLKSRC_MMIO
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_GPIO
 	select HAVE_CLK
@@ -911,7 +908,6 @@ config ARCH_VT8500
 config ARCH_ZYNQ
 	bool "Xilinx Zynq ARM Cortex A9 Platform"
 	select CPU_V7
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select CLKDEV_LOOKUP
 	select ARM_GIC
diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 1f87034..5f7f2f8d 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -47,9 +47,6 @@ config GENERIC_CMOS_UPDATE
 config GENERIC_HWEIGHT
 	def_bool y
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_CLOCKEVENTS
 	def_bool y
 
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index dff9330..8d65bd0 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -109,10 +109,14 @@ static void fixup_clock_comparator(unsigned long long delta)
 	set_clock_comparator(S390_lowcore.clock_comparator);
 }
 
-static int s390_next_event(unsigned long delta,
+static int s390_next_ktime(ktime_t expires,
 			   struct clock_event_device *evt)
 {
-	S390_lowcore.clock_comparator = get_clock() + delta;
+	u64 nsecs;
+
+	nsecs = ktime_to_ns(ktime_sub(expires, ktime_get_monotonic_offset()));
+	do_div(nsecs, 125);
+	S390_lowcore.clock_comparator = TOD_UNIX_EPOCH + (nsecs << 9);
 	set_clock_comparator(S390_lowcore.clock_comparator);
 	return 0;
 }
@@ -137,14 +141,15 @@ void init_cpu_timer(void)
 	cpu = smp_processor_id();
 	cd = &per_cpu(comparators, cpu);
 	cd->name		= "comparator";
-	cd->features		= CLOCK_EVT_FEAT_ONESHOT;
+	cd->features		= CLOCK_EVT_FEAT_ONESHOT |
+				  CLOCK_EVT_FEAT_KTIME;
 	cd->mult		= 16777;
 	cd->shift		= 12;
 	cd->min_delta_ns	= 1;
 	cd->max_delta_ns	= LONG_MAX;
 	cd->rating		= 400;
 	cd->cpumask		= cpumask_of(cpu);
-	cd->set_next_event	= s390_next_event;
+	cd->set_next_ktime	= s390_next_ktime;
 	cd->set_mode		= s390_set_mode;
 
 	clockevents_register_device(cd);
diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index b30f71a..70a0de4 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -46,9 +46,6 @@ config NEED_PER_CPU_PAGE_FIRST_CHUNK
 config SYS_SUPPORTS_HUGETLBFS
 	def_bool y
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_CLOCKEVENTS
 	def_bool y
 
diff --git a/arch/tile/configs/tilegx_defconfig b/arch/tile/configs/tilegx_defconfig
index 2ad73fb..dafdbba 100644
--- a/arch/tile/configs/tilegx_defconfig
+++ b/arch/tile/configs/tilegx_defconfig
@@ -11,7 +11,6 @@ CONFIG_HAVE_ARCH_ALLOC_REMAP=y
 CONFIG_HAVE_SETUP_PER_CPU_AREA=y
 CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
 CONFIG_SYS_SUPPORTS_HUGETLBFS=y
-CONFIG_GENERIC_TIME=y
 CONFIG_GENERIC_CLOCKEVENTS=y
 CONFIG_RWSEM_GENERIC_SPINLOCK=y
 CONFIG_DEFAULT_MIGRATION_COST=10000000
diff --git a/arch/tile/configs/tilepro_defconfig b/arch/tile/configs/tilepro_defconfig
index f58dc36..6f05f969 100644
--- a/arch/tile/configs/tilepro_defconfig
+++ b/arch/tile/configs/tilepro_defconfig
@@ -11,7 +11,6 @@ CONFIG_HAVE_ARCH_ALLOC_REMAP=y
 CONFIG_HAVE_SETUP_PER_CPU_AREA=y
 CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
 CONFIG_SYS_SUPPORTS_HUGETLBFS=y
-CONFIG_GENERIC_TIME=y
 CONFIG_GENERIC_CLOCKEVENTS=y
 CONFIG_RWSEM_GENERIC_SPINLOCK=y
 CONFIG_DEFAULT_MIGRATION_COST=10000000
diff --git a/arch/um/defconfig b/arch/um/defconfig
index 9f7634f..761f5e1 100644
--- a/arch/um/defconfig
+++ b/arch/um/defconfig
@@ -13,7 +13,6 @@ CONFIG_LOCKDEP_SUPPORT=y
 # CONFIG_STACKTRACE_SUPPORT is not set
 CONFIG_GENERIC_CALIBRATE_DELAY=y
 CONFIG_GENERIC_BUG=y
-CONFIG_GENERIC_TIME=y
 CONFIG_GENERIC_CLOCKEVENTS=y
 CONFIG_IRQ_RELEASE_METHOD=y
 CONFIG_HZ=100
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6a47bb2..a1609cd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -68,6 +68,7 @@ config X86
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_IRQ_SHOW
+	select GENERIC_CLOCKEVENTS_MIN_ADJUST
 	select IRQ_FORCED_THREADING
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_BPF_JIT if (X86_64 && NET)
diff --git a/arch/xtensa/configs/iss_defconfig b/arch/xtensa/configs/iss_defconfig
index 0234cd1..f932b30 100644
--- a/arch/xtensa/configs/iss_defconfig
+++ b/arch/xtensa/configs/iss_defconfig
@@ -15,7 +15,6 @@ CONFIG_GENERIC_GPIO=y
 # CONFIG_ARCH_HAS_ILOG2_U64 is not set
 CONFIG_NO_IOPORT=y
 CONFIG_HZ=100
-CONFIG_GENERIC_TIME=y
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 CONFIG_CONSTRUCTORS=y
 
diff --git a/arch/xtensa/configs/s6105_defconfig b/arch/xtensa/configs/s6105_defconfig
index 4891abb..550e8ed 100644
--- a/arch/xtensa/configs/s6105_defconfig
+++ b/arch/xtensa/configs/s6105_defconfig
@@ -15,7 +15,6 @@ CONFIG_GENERIC_GPIO=y
 # CONFIG_ARCH_HAS_ILOG2_U64 is not set
 CONFIG_NO_IOPORT=y
 CONFIG_HZ=100
-CONFIG_GENERIC_TIME=y
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
 #
diff --git a/drivers/clocksource/dw_apb_timer.c b/drivers/clocksource/dw_apb_timer.c
index 580f870..8c2a35f 100644
--- a/drivers/clocksource/dw_apb_timer.c
+++ b/drivers/clocksource/dw_apb_timer.c
@@ -348,7 +348,7 @@ static void apbt_restart_clocksource(struct clocksource *cs)
  * dw_apb_clocksource_register() as the next step.
  */
 struct dw_apb_clocksource *
-dw_apb_clocksource_init(unsigned rating, char *name, void __iomem *base,
+dw_apb_clocksource_init(unsigned rating, const char *name, void __iomem *base,
 			unsigned long freq)
 {
 	struct dw_apb_clocksource *dw_cs = kzalloc(sizeof(*dw_cs), GFP_KERNEL);
diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index 33b56e5..c97b468 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -120,10 +120,12 @@ static inline cputime64_t get_cpu_idle_time_jiffy(unsigned int cpu,
 
 static inline cputime64_t get_cpu_idle_time(unsigned int cpu, cputime64_t *wall)
 {
-	u64 idle_time = get_cpu_idle_time_us(cpu, wall);
+	u64 idle_time = get_cpu_idle_time_us(cpu, NULL);
 
 	if (idle_time == -1ULL)
 		return get_cpu_idle_time_jiffy(cpu, wall);
+	else
+		idle_time += get_cpu_iowait_time_us(cpu, wall);
 
 	return idle_time;
 }
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 891360e..07756bd 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -144,10 +144,12 @@ static inline cputime64_t get_cpu_idle_time_jiffy(unsigned int cpu,
 
 static inline cputime64_t get_cpu_idle_time(unsigned int cpu, cputime64_t *wall)
 {
-	u64 idle_time = get_cpu_idle_time_us(cpu, wall);
+	u64 idle_time = get_cpu_idle_time_us(cpu, NULL);
 
 	if (idle_time == -1ULL)
 		return get_cpu_idle_time_jiffy(cpu, wall);
+	else
+		idle_time += get_cpu_iowait_time_us(cpu, wall);
 
 	return idle_time;
 }
diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 9758b65..42b274d 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -10,6 +10,7 @@
 #include <linux/time.h>
 #include <linux/irqnr.h>
 #include <asm/cputime.h>
+#include <linux/tick.h>
 
 #ifndef arch_irq_stat_cpu
 #define arch_irq_stat_cpu(cpu) 0
@@ -21,6 +22,35 @@
 #define arch_idle_time(cpu) 0
 #endif
 
+static cputime64_t get_idle_time(int cpu)
+{
+	u64 idle_time = get_cpu_idle_time_us(cpu, NULL);
+	cputime64_t idle;
+
+	if (idle_time == -1ULL) {
+		/* !NO_HZ so we can rely on cpustat.idle */
+		idle = kstat_cpu(cpu).cpustat.idle;
+		idle = cputime64_add(idle, arch_idle_time(cpu));
+	} else
+		idle = usecs_to_cputime(idle_time);
+
+	return idle;
+}
+
+static cputime64_t get_iowait_time(int cpu)
+{
+	u64 iowait_time = get_cpu_iowait_time_us(cpu, NULL);
+	cputime64_t iowait;
+
+	if (iowait_time == -1ULL)
+		/* !NO_HZ so we can rely on cpustat.iowait */
+		iowait = kstat_cpu(cpu).cpustat.iowait;
+	else
+		iowait = usecs_to_cputime(iowait_time);
+
+	return iowait;
+}
+
 static int show_stat(struct seq_file *p, void *v)
 {
 	int i, j;
@@ -42,9 +72,8 @@ static int show_stat(struct seq_file *p, void *v)
 		user = cputime64_add(user, kstat_cpu(i).cpustat.user);
 		nice = cputime64_add(nice, kstat_cpu(i).cpustat.nice);
 		system = cputime64_add(system, kstat_cpu(i).cpustat.system);
-		idle = cputime64_add(idle, kstat_cpu(i).cpustat.idle);
-		idle = cputime64_add(idle, arch_idle_time(i));
-		iowait = cputime64_add(iowait, kstat_cpu(i).cpustat.iowait);
+		idle = cputime64_add(idle, get_idle_time(i));
+		iowait = cputime64_add(iowait, get_iowait_time(i));
 		irq = cputime64_add(irq, kstat_cpu(i).cpustat.irq);
 		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
 		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
@@ -76,14 +105,12 @@ static int show_stat(struct seq_file *p, void *v)
 		(unsigned long long)cputime64_to_clock_t(guest),
 		(unsigned long long)cputime64_to_clock_t(guest_nice));
 	for_each_online_cpu(i) {
-
 		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
 		user = kstat_cpu(i).cpustat.user;
 		nice = kstat_cpu(i).cpustat.nice;
 		system = kstat_cpu(i).cpustat.system;
-		idle = kstat_cpu(i).cpustat.idle;
-		idle = cputime64_add(idle, arch_idle_time(i));
-		iowait = kstat_cpu(i).cpustat.iowait;
+		idle = get_idle_time(i);
+		iowait = get_iowait_time(i);
 		irq = kstat_cpu(i).cpustat.irq;
 		softirq = kstat_cpu(i).cpustat.softirq;
 		steal = kstat_cpu(i).cpustat.steal;
diff --git a/include/asm-generic/cputime.h b/include/asm-generic/cputime.h
index 61e03dd..62ce682 100644
--- a/include/asm-generic/cputime.h
+++ b/include/asm-generic/cputime.h
@@ -38,8 +38,8 @@ typedef u64 cputime64_t;
 /*
  * Convert cputime to microseconds and back.
  */
-#define cputime_to_usecs(__ct)		jiffies_to_usecs(__ct);
-#define usecs_to_cputime(__msecs)	usecs_to_jiffies(__msecs);
+#define cputime_to_usecs(__ct)		jiffies_to_usecs(__ct)
+#define usecs_to_cputime(__msecs)	usecs_to_jiffies(__msecs)
 
 /*
  * Convert cputime to seconds and back.
diff --git a/include/linux/alarmtimer.h b/include/linux/alarmtimer.h
index c5d6095..975009e 100644
--- a/include/linux/alarmtimer.h
+++ b/include/linux/alarmtimer.h
@@ -13,6 +13,16 @@ enum alarmtimer_type {
 	ALARM_NUMTYPE,
 };
 
+enum alarmtimer_restart {
+	ALARMTIMER_NORESTART,
+	ALARMTIMER_RESTART,
+};
+
+
+#define ALARMTIMER_STATE_INACTIVE	0x00
+#define ALARMTIMER_STATE_ENQUEUED	0x01
+#define ALARMTIMER_STATE_CALLBACK	0x02
+
 /**
  * struct alarm - Alarm timer structure
  * @node:	timerqueue node for adding to the event list this value
@@ -25,16 +35,45 @@ enum alarmtimer_type {
  */
 struct alarm {
 	struct timerqueue_node	node;
-	ktime_t			period;
-	void			(*function)(struct alarm *);
+	enum alarmtimer_restart	(*function)(struct alarm *, ktime_t now);
 	enum alarmtimer_type	type;
-	bool			enabled;
+	int			state;
 	void			*data;
 };
 
 void alarm_init(struct alarm *alarm, enum alarmtimer_type type,
-		void (*function)(struct alarm *));
-void alarm_start(struct alarm *alarm, ktime_t start, ktime_t period);
-void alarm_cancel(struct alarm *alarm);
+		enum alarmtimer_restart (*function)(struct alarm *, ktime_t));
+void alarm_start(struct alarm *alarm, ktime_t start);
+int alarm_try_to_cancel(struct alarm *alarm);
+int alarm_cancel(struct alarm *alarm);
+
+u64 alarm_forward(struct alarm *alarm, ktime_t now, ktime_t interval);
+
+/*
+ * A alarmtimer is active, when it is enqueued into timerqueue or the
+ * callback function is running.
+ */
+static inline int alarmtimer_active(const struct alarm *timer)
+{
+	return timer->state != ALARMTIMER_STATE_INACTIVE;
+}
+
+/*
+ * Helper function to check, whether the timer is on one of the queues
+ */
+static inline int alarmtimer_is_queued(struct alarm *timer)
+{
+	return timer->state & ALARMTIMER_STATE_ENQUEUED;
+}
+
+/*
+ * Helper function to check, whether the timer is running the callback
+ * function
+ */
+static inline int alarmtimer_callback_running(struct alarm *timer)
+{
+	return timer->state & ALARMTIMER_STATE_CALLBACK;
+}
+
 
 #endif
diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index d6733e2..81e803e 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -45,20 +45,22 @@ enum clock_event_nofitiers {
  */
 #define CLOCK_EVT_FEAT_PERIODIC		0x000001
 #define CLOCK_EVT_FEAT_ONESHOT		0x000002
+#define CLOCK_EVT_FEAT_KTIME		0x000004
 /*
  * x86(64) specific misfeatures:
  *
  * - Clockevent source stops in C3 State and needs broadcast support.
  * - Local APIC timer is used as a dummy device.
  */
-#define CLOCK_EVT_FEAT_C3STOP		0x000004
-#define CLOCK_EVT_FEAT_DUMMY		0x000008
+#define CLOCK_EVT_FEAT_C3STOP		0x000008
+#define CLOCK_EVT_FEAT_DUMMY		0x000010
 
 /**
  * struct clock_event_device - clock event device descriptor
  * @event_handler:	Assigned by the framework to be called by the low
  *			level handler of the event source
- * @set_next_event:	set next event function
+ * @set_next_event:	set next event function using a clocksource delta
+ * @set_next_ktime:	set next event function using a direct ktime value
  * @next_event:		local storage for the next event in oneshot mode
  * @max_delta_ns:	maximum delta value in ns
  * @min_delta_ns:	minimum delta value in ns
@@ -81,6 +83,8 @@ struct clock_event_device {
 	void			(*event_handler)(struct clock_event_device *);
 	int			(*set_next_event)(unsigned long evt,
 						  struct clock_event_device *);
+	int			(*set_next_ktime)(ktime_t expires,
+						  struct clock_event_device *);
 	ktime_t			next_event;
 	u64			max_delta_ns;
 	u64			min_delta_ns;
@@ -140,7 +144,7 @@ extern void clockevents_set_mode(struct clock_event_device *dev,
 				 enum clock_event_mode mode);
 extern int clockevents_register_notifier(struct notifier_block *nb);
 extern int clockevents_program_event(struct clock_event_device *dev,
-				     ktime_t expires, ktime_t now);
+				     ktime_t expires, bool force);
 
 extern void clockevents_handle_noop(struct clock_event_device *dev);
 
diff --git a/include/linux/dw_apb_timer.h b/include/linux/dw_apb_timer.h
index 49638ea..07261d5 100644
--- a/include/linux/dw_apb_timer.h
+++ b/include/linux/dw_apb_timer.h
@@ -46,7 +46,7 @@ struct dw_apb_clock_event_device *
 dw_apb_clockevent_init(int cpu, const char *name, unsigned rating,
 		       void __iomem *base, int irq, unsigned long freq);
 struct dw_apb_clocksource *
-dw_apb_clocksource_init(unsigned rating, char *name, void __iomem *base,
+dw_apb_clocksource_init(unsigned rating, const char *name, void __iomem *base,
 			unsigned long freq);
 void dw_apb_clocksource_register(struct dw_apb_clocksource *dw_cs);
 void dw_apb_clocksource_start(struct dw_apb_clocksource *dw_cs);
diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index f97672a..265e2c3 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -303,7 +303,7 @@ extern void jiffies_to_timespec(const unsigned long jiffies,
 extern unsigned long timeval_to_jiffies(const struct timeval *value);
 extern void jiffies_to_timeval(const unsigned long jiffies,
 			       struct timeval *value);
-extern clock_t jiffies_to_clock_t(long x);
+extern clock_t jiffies_to_clock_t(unsigned long x);
 extern unsigned long clock_t_to_jiffies(unsigned long x);
 extern u64 jiffies_64_to_clock_t(u64 x);
 extern u64 nsec_to_clock_t(u64 x);
diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 959c141..042058f 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -81,7 +81,10 @@ struct k_itimer {
 			unsigned long incr;
 			unsigned long expires;
 		} mmtimer;
-		struct alarm alarmtimer;
+		struct {
+			struct alarm alarmtimer;
+			ktime_t interval;
+		} alarm;
 		struct rcu_head rcu;
 	} it;
 };
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 20b03bf..2909fe7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1955,7 +1955,6 @@ static inline void disable_sched_clock_irqtime(void) {}
 
 extern unsigned long long
 task_sched_runtime(struct task_struct *task);
-extern unsigned long long thread_group_sched_runtime(struct task_struct *task);
 
 /* sched_exec is called by processes performing an exec */
 #ifdef CONFIG_SMP
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 58f405b..c8008dd 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -250,7 +250,7 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 	do {
 		times->utime = cputime_add(times->utime, t->utime);
 		times->stime = cputime_add(times->stime, t->stime);
-		times->sum_exec_runtime += t->se.sum_exec_runtime;
+		times->sum_exec_runtime += task_sched_runtime(t);
 	} while_each_thread(tsk, t);
 out:
 	rcu_read_unlock();
@@ -312,7 +312,8 @@ static int cpu_clock_sample_group(const clockid_t which_clock,
 		cpu->cpu = cputime.utime;
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched = thread_group_sched_runtime(p);
+		thread_group_cputime(p, &cputime);
+		cpu->sched = cputime.sum_exec_runtime;
 		break;
 	}
 	return 0;
diff --git a/kernel/sched.c b/kernel/sched.c
index ccacdbd..e1290ec 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3725,30 +3725,6 @@ unsigned long long task_sched_runtime(struct task_struct *p)
 }
 
 /*
- * Return sum_exec_runtime for the thread group.
- * In case the task is currently running, return the sum plus current's
- * pending runtime that have not been accounted yet.
- *
- * Note that the thread group might have other running tasks as well,
- * so the return value not includes other pending runtime that other
- * running tasks might have.
- */
-unsigned long long thread_group_sched_runtime(struct task_struct *p)
-{
-	struct task_cputime totals;
-	unsigned long flags;
-	struct rq *rq;
-	u64 ns;
-
-	rq = task_rq_lock(p, &flags);
-	thread_group_cputime(p, &totals);
-	ns = totals.sum_exec_runtime + do_task_delta_exec(p, rq);
-	task_rq_unlock(rq, p, &flags);
-
-	return ns;
-}
-
-/*
  * Account user cpu time to a process.
  * @p: the process that the cpu time gets accounted to
  * @cputime: the cpu time spent in user space since the last update
diff --git a/kernel/time.c b/kernel/time.c
index 8e8dc6d..d776062 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -575,7 +575,7 @@ EXPORT_SYMBOL(jiffies_to_timeval);
 /*
  * Convert jiffies/jiffies_64 to clock_t and back.
  */
-clock_t jiffies_to_clock_t(long x)
+clock_t jiffies_to_clock_t(unsigned long x)
 {
 #if (TICK_NSEC % (NSEC_PER_SEC / USER_HZ)) == 0
 # if HZ < USER_HZ
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index f06a8a3..b26c222 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -27,3 +27,5 @@ config GENERIC_CLOCKEVENTS_BUILD
 	default y
 	depends on GENERIC_CLOCKEVENTS || GENERIC_CLOCKEVENTS_MIGR
 
+config GENERIC_CLOCKEVENTS_MIN_ADJUST
+	bool
diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index ea5e1a9..c436e79 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -53,27 +53,6 @@ static struct rtc_device	*rtcdev;
 static DEFINE_SPINLOCK(rtcdev_lock);
 
 /**
- * has_wakealarm - check rtc device has wakealarm ability
- * @dev: current device
- * @name_ptr: name to be returned
- *
- * This helper function checks to see if the rtc device can wake
- * from suspend.
- */
-static int has_wakealarm(struct device *dev, void *name_ptr)
-{
-	struct rtc_device *candidate = to_rtc_device(dev);
-
-	if (!candidate->ops->set_alarm)
-		return 0;
-	if (!device_may_wakeup(candidate->dev.parent))
-		return 0;
-
-	*(const char **)name_ptr = dev_name(dev);
-	return 1;
-}
-
-/**
  * alarmtimer_get_rtcdev - Return selected rtcdevice
  *
  * This function returns the rtc device to use for wakealarms.
@@ -82,37 +61,64 @@ static int has_wakealarm(struct device *dev, void *name_ptr)
  */
 static struct rtc_device *alarmtimer_get_rtcdev(void)
 {
-	struct device *dev;
-	char *str;
 	unsigned long flags;
 	struct rtc_device *ret;
 
 	spin_lock_irqsave(&rtcdev_lock, flags);
-	if (!rtcdev) {
-		/* Find an rtc device and init the rtc_timer */
-		dev = class_find_device(rtc_class, NULL, &str, has_wakealarm);
-		/* If we have a device then str is valid. See has_wakealarm() */
-		if (dev) {
-			rtcdev = rtc_class_open(str);
-			/*
-			 * Drop the reference we got in class_find_device,
-			 * rtc_open takes its own.
-			 */
-			put_device(dev);
-			rtc_timer_init(&rtctimer, NULL, NULL);
-		}
-	}
 	ret = rtcdev;
 	spin_unlock_irqrestore(&rtcdev_lock, flags);
 
 	return ret;
 }
+
+
+static int alarmtimer_rtc_add_device(struct device *dev,
+				struct class_interface *class_intf)
+{
+	unsigned long flags;
+	struct rtc_device *rtc = to_rtc_device(dev);
+
+	if (rtcdev)
+		return -EBUSY;
+
+	if (!rtc->ops->set_alarm)
+		return -1;
+	if (!device_may_wakeup(rtc->dev.parent))
+		return -1;
+
+	spin_lock_irqsave(&rtcdev_lock, flags);
+	if (!rtcdev) {
+		rtcdev = rtc;
+		/* hold a reference so it doesn't go away */
+		get_device(dev);
+	}
+	spin_unlock_irqrestore(&rtcdev_lock, flags);
+	return 0;
+}
+
+static struct class_interface alarmtimer_rtc_interface = {
+	.add_dev = &alarmtimer_rtc_add_device,
+};
+
+static int alarmtimer_rtc_interface_setup(void)
+{
+	alarmtimer_rtc_interface.class = rtc_class;
+	return class_interface_register(&alarmtimer_rtc_interface);
+}
+static void alarmtimer_rtc_interface_remove(void)
+{
+	class_interface_unregister(&alarmtimer_rtc_interface);
+}
 #else
-#define alarmtimer_get_rtcdev() (0)
-#define rtcdev (0)
+static inline struct rtc_device *alarmtimer_get_rtcdev(void)
+{
+	return NULL;
+}
+#define rtcdev (NULL)
+static inline int alarmtimer_rtc_interface_setup(void) { return 0; }
+static inline void alarmtimer_rtc_interface_remove(void) { }
 #endif
 
-
 /**
  * alarmtimer_enqueue - Adds an alarm timer to an alarm_base timerqueue
  * @base: pointer to the base where the timer is being run
@@ -126,6 +132,8 @@ static struct rtc_device *alarmtimer_get_rtcdev(void)
 static void alarmtimer_enqueue(struct alarm_base *base, struct alarm *alarm)
 {
 	timerqueue_add(&base->timerqueue, &alarm->node);
+	alarm->state |= ALARMTIMER_STATE_ENQUEUED;
+
 	if (&alarm->node == timerqueue_getnext(&base->timerqueue)) {
 		hrtimer_try_to_cancel(&base->timer);
 		hrtimer_start(&base->timer, alarm->node.expires,
@@ -147,7 +155,12 @@ static void alarmtimer_remove(struct alarm_base *base, struct alarm *alarm)
 {
 	struct timerqueue_node *next = timerqueue_getnext(&base->timerqueue);
 
+	if (!(alarm->state & ALARMTIMER_STATE_ENQUEUED))
+		return;
+
 	timerqueue_del(&base->timerqueue, &alarm->node);
+	alarm->state &= ~ALARMTIMER_STATE_ENQUEUED;
+
 	if (next == &alarm->node) {
 		hrtimer_try_to_cancel(&base->timer);
 		next = timerqueue_getnext(&base->timerqueue);
@@ -174,6 +187,7 @@ static enum hrtimer_restart alarmtimer_fired(struct hrtimer *timer)
 	unsigned long flags;
 	ktime_t now;
 	int ret = HRTIMER_NORESTART;
+	int restart = ALARMTIMER_NORESTART;
 
 	spin_lock_irqsave(&base->lock, flags);
 	now = base->gettime();
@@ -187,17 +201,19 @@ static enum hrtimer_restart alarmtimer_fired(struct hrtimer *timer)
 		alarm = container_of(next, struct alarm, node);
 
 		timerqueue_del(&base->timerqueue, &alarm->node);
-		alarm->enabled = 0;
-		/* Re-add periodic timers */
-		if (alarm->period.tv64) {
-			alarm->node.expires = ktime_add(expired, alarm->period);
-			timerqueue_add(&base->timerqueue, &alarm->node);
-			alarm->enabled = 1;
-		}
+		alarm->state &= ~ALARMTIMER_STATE_ENQUEUED;
+
+		alarm->state |= ALARMTIMER_STATE_CALLBACK;
 		spin_unlock_irqrestore(&base->lock, flags);
 		if (alarm->function)
-			alarm->function(alarm);
+			restart = alarm->function(alarm, now);
 		spin_lock_irqsave(&base->lock, flags);
+		alarm->state &= ~ALARMTIMER_STATE_CALLBACK;
+
+		if (restart != ALARMTIMER_NORESTART) {
+			timerqueue_add(&base->timerqueue, &alarm->node);
+			alarm->state |= ALARMTIMER_STATE_ENQUEUED;
+		}
 	}
 
 	if (next) {
@@ -234,7 +250,7 @@ static int alarmtimer_suspend(struct device *dev)
 	freezer_delta = ktime_set(0, 0);
 	spin_unlock_irqrestore(&freezer_delta_lock, flags);
 
-	rtc = rtcdev;
+	rtc = alarmtimer_get_rtcdev();
 	/* If we have no rtcdev, just return */
 	if (!rtc)
 		return 0;
@@ -299,53 +315,111 @@ static void alarmtimer_freezerset(ktime_t absexp, enum alarmtimer_type type)
  * @function: callback that is run when the alarm fires
  */
 void alarm_init(struct alarm *alarm, enum alarmtimer_type type,
-		void (*function)(struct alarm *))
+		enum alarmtimer_restart (*function)(struct alarm *, ktime_t))
 {
 	timerqueue_init(&alarm->node);
-	alarm->period = ktime_set(0, 0);
 	alarm->function = function;
 	alarm->type = type;
-	alarm->enabled = 0;
+	alarm->state = ALARMTIMER_STATE_INACTIVE;
 }
 
 /**
  * alarm_start - Sets an alarm to fire
  * @alarm: ptr to alarm to set
  * @start: time to run the alarm
- * @period: period at which the alarm will recur
  */
-void alarm_start(struct alarm *alarm, ktime_t start, ktime_t period)
+void alarm_start(struct alarm *alarm, ktime_t start)
 {
 	struct alarm_base *base = &alarm_bases[alarm->type];
 	unsigned long flags;
 
 	spin_lock_irqsave(&base->lock, flags);
-	if (alarm->enabled)
+	if (alarmtimer_active(alarm))
 		alarmtimer_remove(base, alarm);
 	alarm->node.expires = start;
-	alarm->period = period;
 	alarmtimer_enqueue(base, alarm);
-	alarm->enabled = 1;
 	spin_unlock_irqrestore(&base->lock, flags);
 }
 
 /**
- * alarm_cancel - Tries to cancel an alarm timer
+ * alarm_try_to_cancel - Tries to cancel an alarm timer
  * @alarm: ptr to alarm to be canceled
+ *
+ * Returns 1 if the timer was canceled, 0 if it was not running,
+ * and -1 if the callback was running
  */
-void alarm_cancel(struct alarm *alarm)
+int alarm_try_to_cancel(struct alarm *alarm)
 {
 	struct alarm_base *base = &alarm_bases[alarm->type];
 	unsigned long flags;
-
+	int ret = -1;
 	spin_lock_irqsave(&base->lock, flags);
-	if (alarm->enabled)
+
+	if (alarmtimer_callback_running(alarm))
+		goto out;
+
+	if (alarmtimer_is_queued(alarm)) {
 		alarmtimer_remove(base, alarm);
-	alarm->enabled = 0;
+		ret = 1;
+	} else
+		ret = 0;
+out:
 	spin_unlock_irqrestore(&base->lock, flags);
+	return ret;
+}
+
+
+/**
+ * alarm_cancel - Spins trying to cancel an alarm timer until it is done
+ * @alarm: ptr to alarm to be canceled
+ *
+ * Returns 1 if the timer was canceled, 0 if it was not active.
+ */
+int alarm_cancel(struct alarm *alarm)
+{
+	for (;;) {
+		int ret = alarm_try_to_cancel(alarm);
+		if (ret >= 0)
+			return ret;
+		cpu_relax();
+	}
+}
+
+
+u64 alarm_forward(struct alarm *alarm, ktime_t now, ktime_t interval)
+{
+	u64 overrun = 1;
+	ktime_t delta;
+
+	delta = ktime_sub(now, alarm->node.expires);
+
+	if (delta.tv64 < 0)
+		return 0;
+
+	if (unlikely(delta.tv64 >= interval.tv64)) {
+		s64 incr = ktime_to_ns(interval);
+
+		overrun = ktime_divns(delta, incr);
+
+		alarm->node.expires = ktime_add_ns(alarm->node.expires,
+							incr*overrun);
+
+		if (alarm->node.expires.tv64 > now.tv64)
+			return overrun;
+		/*
+		 * This (and the ktime_add() below) is the
+		 * correction for exact:
+		 */
+		overrun++;
+	}
+
+	alarm->node.expires = ktime_add(alarm->node.expires, interval);
+	return overrun;
 }
 
 
+
+
 /**
  * clock2alarm - helper that converts from clockid to alarmtypes
  * @clockid: clockid.
@@ -365,12 +439,21 @@ static enum alarmtimer_type clock2alarm(clockid_t clockid)
  *
  * Posix timer callback for expired alarm timers.
  */
-static void alarm_handle_timer(struct alarm *alarm)
+static enum alarmtimer_restart alarm_handle_timer(struct alarm *alarm,
+							ktime_t now)
 {
 	struct k_itimer *ptr = container_of(alarm, struct k_itimer,
-						it.alarmtimer);
+						it.alarm.alarmtimer);
 	if (posix_timer_event(ptr, 0) != 0)
 		ptr->it_overrun++;
+
+	/* Re-add periodic timers */
+	if (ptr->it.alarm.interval.tv64) {
+		ptr->it_overrun += alarm_forward(alarm, now,
+						ptr->it.alarm.interval);
+		return ALARMTIMER_RESTART;
+	}
+	return ALARMTIMER_NORESTART;
 }
 
 /**
@@ -427,7 +510,7 @@ static int alarm_timer_create(struct k_itimer *new_timer)
 
 	type = clock2alarm(new_timer->it_clock);
 	base = &alarm_bases[type];
-	alarm_init(&new_timer->it.alarmtimer, type, alarm_handle_timer);
+	alarm_init(&new_timer->it.alarm.alarmtimer, type, alarm_handle_timer);
 	return 0;
 }
 
@@ -444,9 +527,9 @@ static void alarm_timer_get(struct k_itimer *timr,
 	memset(cur_setting, 0, sizeof(struct itimerspec));
 
 	cur_setting->it_interval =
-			ktime_to_timespec(timr->it.alarmtimer.period);
+			ktime_to_timespec(timr->it.alarm.interval);
 	cur_setting->it_value =
-			ktime_to_timespec(timr->it.alarmtimer.node.expires);
+		ktime_to_timespec(timr->it.alarm.alarmtimer.node.expires);
 	return;
 }
 
@@ -461,7 +544,9 @@ static int alarm_timer_del(struct k_itimer *timr)
 	if (!rtcdev)
 		return -ENOTSUPP;
 
-	alarm_cancel(&timr->it.alarmtimer);
+	if (alarm_try_to_cancel(&timr->it.alarm.alarmtimer) < 0)
+		return TIMER_RETRY;
+
 	return 0;
 }
 
@@ -481,25 +566,17 @@ static int alarm_timer_set(struct k_itimer *timr, int flags,
 	if (!rtcdev)
 		return -ENOTSUPP;
 
-	/*
-	 * XXX HACK! Currently we can DOS a system if the interval
-	 * period on alarmtimers is too small. Cap the interval here
-	 * to 100us and solve this properly in a future patch! -jstultz
-	 */
-	if ((new_setting->it_interval.tv_sec == 0) &&
-			(new_setting->it_interval.tv_nsec < 100000))
-		new_setting->it_interval.tv_nsec = 100000;
-
 	if (old_setting)
 		alarm_timer_get(timr, old_setting);
 
 	/* If the timer was already set, cancel it */
-	alarm_cancel(&timr->it.alarmtimer);
+	if (alarm_try_to_cancel(&timr->it.alarm.alarmtimer) < 0)
+		return TIMER_RETRY;
 
 	/* start the timer */
-	alarm_start(&timr->it.alarmtimer,
-			timespec_to_ktime(new_setting->it_value),
-			timespec_to_ktime(new_setting->it_interval));
+	timr->it.alarm.interval = timespec_to_ktime(new_setting->it_interval);
+	alarm_start(&timr->it.alarm.alarmtimer,
+			timespec_to_ktime(new_setting->it_value));
 	return 0;
 }
 
@@ -509,13 +586,15 @@ static int alarm_timer_set(struct k_itimer *timr, int flags,
  *
  * Wakes up the task that set the alarmtimer
  */
-static void alarmtimer_nsleep_wakeup(struct alarm *alarm)
+static enum alarmtimer_restart alarmtimer_nsleep_wakeup(struct alarm *alarm,
+								ktime_t now)
 {
 	struct task_struct *task = (struct task_struct *)alarm->data;
 
 	alarm->data = NULL;
 	if (task)
 		wake_up_process(task);
+	return ALARMTIMER_NORESTART;
 }
 
 /**
@@ -530,7 +609,7 @@ static int alarmtimer_do_nsleep(struct alarm *alarm, ktime_t absexp)
 	alarm->data = (void *)current;
 	do {
 		set_current_state(TASK_INTERRUPTIBLE);
-		alarm_start(alarm, absexp, ktime_set(0, 0));
+		alarm_start(alarm, absexp);
 		if (likely(alarm->data))
 			schedule();
 
@@ -691,6 +770,7 @@ static struct platform_driver alarmtimer_driver = {
  */
 static int __init alarmtimer_init(void)
 {
+	struct platform_device *pdev;
 	int error = 0;
 	int i;
 	struct k_clock alarm_clock = {
@@ -719,10 +799,26 @@ static int __init alarmtimer_init(void)
 				HRTIMER_MODE_ABS);
 		alarm_bases[i].timer.function = alarmtimer_fired;
 	}
+
+	error = alarmtimer_rtc_interface_setup();
+	if (error)
+		return error;
+
 	error = platform_driver_register(&alarmtimer_driver);
-	platform_device_register_simple("alarmtimer", -1, NULL, 0);
+	if (error)
+		goto out_if;
 
+	pdev = platform_device_register_simple("alarmtimer", -1, NULL, 0);
+	if (IS_ERR(pdev)) {
+		error = PTR_ERR(pdev);
+		goto out_drv;
+	}
+	return 0;
+
+out_drv:
+	platform_driver_unregister(&alarmtimer_driver);
+out_if:
+	alarmtimer_rtc_interface_remove();
 	return error;
 }
 device_initcall(alarmtimer_init);
-
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index e4c699d..1ecd6ba 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -94,42 +94,143 @@ void clockevents_shutdown(struct clock_event_device *dev)
 	dev->next_event.tv64 = KTIME_MAX;
 }
 
+#ifdef CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST
+
+/* Limit min_delta to a jiffie */
+#define MIN_DELTA_LIMIT		(NSEC_PER_SEC / HZ)
+
+/**
+ * clockevents_increase_min_delta - raise minimum delta of a clock event device
+ * @dev:       device to increase the minimum delta
+ *
+ * Returns 0 on success, -ETIME when the minimum delta reached the limit.
+ */
+static int clockevents_increase_min_delta(struct clock_event_device *dev)
+{
+	/* Nothing to do if we already reached the limit */
+	if (dev->min_delta_ns >= MIN_DELTA_LIMIT) {
+		printk(KERN_WARNING "CE: Reprogramming failure. Giving up\n");
+		dev->next_event.tv64 = KTIME_MAX;
+		return -ETIME;
+	}
+
+	if (dev->min_delta_ns < 5000)
+		dev->min_delta_ns = 5000;
+	else
+		dev->min_delta_ns += dev->min_delta_ns >> 1;
+
+	if (dev->min_delta_ns > MIN_DELTA_LIMIT)
+		dev->min_delta_ns = MIN_DELTA_LIMIT;
+
+	printk(KERN_WARNING "CE: %s increased min_delta_ns to %llu nsec\n",
+	       dev->name ? dev->name : "?",
+	       (unsigned long long) dev->min_delta_ns);
+	return 0;
+}
+
+/**
+ * clockevents_program_min_delta - Set clock event device to the minimum delay.
+ * @dev:	device to program
+ *
+ * Returns 0 on success, -ETIME when the retry loop failed.
+ */
+static int clockevents_program_min_delta(struct clock_event_device *dev)
+{
+	unsigned long long clc;
+	int64_t delta;
+	int i;
+
+	for (i = 0;;) {
+		delta = dev->min_delta_ns;
+		dev->next_event = ktime_add_ns(ktime_get(), delta);
+
+		if (dev->mode == CLOCK_EVT_MODE_SHUTDOWN)
+			return 0;
+
+		dev->retries++;
+		clc = ((unsigned long long) delta * dev->mult) >> dev->shift;
+		if (dev->set_next_event((unsigned long) clc, dev) == 0)
+			return 0;
+
+		if (++i > 2) {
+			/*
+			 * We tried 3 times to program the device with the
+			 * given min_delta_ns. Try to increase the minimum
+			 * delta, if that fails as well get out of here.
+			 */
+			if (clockevents_increase_min_delta(dev))
+				return -ETIME;
+			i = 0;
+		}
+	}
+}
+
+#else  /* CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST */
+
+/**
+ * clockevents_program_min_delta - Set clock event device to the minimum delay.
+ * @dev:	device to program
+ *
+ * Returns 0 on success, -ETIME when the retry loop failed.
+ */
+static int clockevents_program_min_delta(struct clock_event_device *dev)
+{
+	unsigned long long clc;
+	int64_t delta;
+
+	delta = dev->min_delta_ns;
+	dev->next_event = ktime_add_ns(ktime_get(), delta);
+
+	if (dev->mode == CLOCK_EVT_MODE_SHUTDOWN)
+		return 0;
+
+	dev->retries++;
+	clc = ((unsigned long long) delta * dev->mult) >> dev->shift;
+	return dev->set_next_event((unsigned long) clc, dev);
+}
+
+#endif /* CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST */
+
 /**
  * clockevents_program_event - Reprogram the clock event device.
+ * @dev:	device to program
  * @expires:	absolute expiry time (monotonic clock)
+ * @force:	program minimum delay if expires can not be set
  *
  * Returns 0 on success, -ETIME when the event is in the past.
  */
 int clockevents_program_event(struct clock_event_device *dev, ktime_t expires,
-			      ktime_t now)
+			      bool force)
 {
 	unsigned long long clc;
 	int64_t delta;
+	int rc;
 
 	if (unlikely(expires.tv64 < 0)) {
 		WARN_ON_ONCE(1);
 		return -ETIME;
 	}
 
-	delta = ktime_to_ns(ktime_sub(expires, now));
-
-	if (delta <= 0)
-		return -ETIME;
-
 	dev->next_event = expires;
 
 	if (dev->mode == CLOCK_EVT_MODE_SHUTDOWN)
 		return 0;
 
-	if (delta > dev->max_delta_ns)
-		delta = dev->max_delta_ns;
-	if (delta < dev->min_delta_ns)
-		delta = dev->min_delta_ns;
+	/* Shortcut for clockevent devices that can deal with ktime. */
+	if (dev->features & CLOCK_EVT_FEAT_KTIME)
+		return dev->set_next_ktime(expires, dev);
+
+	delta = ktime_to_ns(ktime_sub(expires, ktime_get()));
+	if (delta <= 0)
+		return force ? clockevents_program_min_delta(dev) : -ETIME;
 
-	clc = delta * dev->mult;
-	clc >>= dev->shift;
+	delta = min(delta, (int64_t) dev->max_delta_ns);
+	delta = max(delta, (int64_t) dev->min_delta_ns);
 
-	return dev->set_next_event((unsigned long) clc, dev);
+	clc = ((unsigned long long) delta * dev->mult) >> dev->shift;
+	rc = dev->set_next_event((unsigned long) clc, dev);
+
+	return (rc && force) ? clockevents_program_min_delta(dev) : rc;
 }
 
 /**
@@ -258,7 +359,7 @@ int clockevents_update_freq(struct clock_event_device *dev, u32 freq)
 	if (dev->mode != CLOCK_EVT_MODE_ONESHOT)
 		return 0;
 
-	return clockevents_program_event(dev, dev->next_event, ktime_get());
+	return clockevents_program_event(dev, dev->next_event, false);
 }
 
 /*
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index e0980f0..cf52fda 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -186,6 +186,7 @@ static struct timer_list watchdog_timer;
 static DECLARE_WORK(watchdog_work, clocksource_watchdog_work);
 static DEFINE_SPINLOCK(watchdog_lock);
 static int watchdog_running;
+static atomic_t watchdog_reset_pending;
 
 static int clocksource_watchdog_kthread(void *data);
 static void __clocksource_change_rating(struct clocksource *cs, int rating);
@@ -247,12 +248,14 @@ static void clocksource_watchdog(unsigned long data)
 	struct clocksource *cs;
 	cycle_t csnow, wdnow;
 	int64_t wd_nsec, cs_nsec;
-	int next_cpu;
+	int next_cpu, reset_pending;
 
 	spin_lock(&watchdog_lock);
 	if (!watchdog_running)
 		goto out;
 
+	reset_pending = atomic_read(&watchdog_reset_pending);
+
 	list_for_each_entry(cs, &watchdog_list, wd_list) {
 
 		/* Clocksource already marked unstable? */
@@ -268,7 +271,8 @@ static void clocksource_watchdog(unsigned long data)
 		local_irq_enable();
 
 		/* Clocksource initialized ? */
-		if (!(cs->flags & CLOCK_SOURCE_WATCHDOG)) {
+		if (!(cs->flags & CLOCK_SOURCE_WATCHDOG) ||
+		    atomic_read(&watchdog_reset_pending)) {
 			cs->flags |= CLOCK_SOURCE_WATCHDOG;
 			cs->wd_last = wdnow;
 			cs->cs_last = csnow;
@@ -283,8 +287,11 @@ static void clocksource_watchdog(unsigned long data)
 		cs->cs_last = csnow;
 		cs->wd_last = wdnow;
 
+		if (atomic_read(&watchdog_reset_pending))
+			continue;
+
 		/* Check the deviation from the watchdog clocksource. */
-		if (abs(cs_nsec - wd_nsec) > WATCHDOG_THRESHOLD) {
+		if ((abs(cs_nsec - wd_nsec) > WATCHDOG_THRESHOLD)) {
 			clocksource_unstable(cs, cs_nsec - wd_nsec);
 			continue;
 		}
@@ -303,6 +310,13 @@ static void clocksource_watchdog(unsigned long data)
 	}
 
 	/*
+	 * We only clear the watchdog_reset_pending, when we did a
+	 * full cycle through all clocksources.
+	 */
+	if (reset_pending)
+		atomic_dec(&watchdog_reset_pending);
+
+	/*
 	 * Cycle through CPUs to check if the CPUs stay synchronized
 	 * to each other.
 	 */
@@ -344,23 +358,7 @@ static inline void clocksource_reset_watchdog(void)
 
 static void clocksource_resume_watchdog(void)
 {
-	unsigned long flags;
-
-	/*
-	 * We use trylock here to avoid a potential dead lock when
-	 * kgdb calls this code after the kernel has been stopped with
-	 * watchdog_lock held. When watchdog_lock is held we just
-	 * return and accept, that the watchdog might trigger and mark
-	 * the monitored clock source (usually TSC) unstable.
-	 *
-	 * This does not affect the other caller clocksource_resume()
-	 * because at this point the kernel is UP, interrupts are
-	 * disabled and nothing can hold watchdog_lock.
-	 */
-	if (!spin_trylock_irqsave(&watchdog_lock, flags))
-		return;
-	clocksource_reset_watchdog();
-	spin_unlock_irqrestore(&watchdog_lock, flags);
+	atomic_inc(&watchdog_reset_pending);
 }
 
 static void clocksource_enqueue_watchdog(struct clocksource *cs)
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index c7218d1..f954282 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -194,7 +194,7 @@ static void tick_handle_periodic_broadcast(struct clock_event_device *dev)
 	for (next = dev->next_event; ;) {
 		next = ktime_add(next, tick_period);
 
-		if (!clockevents_program_event(dev, next, ktime_get()))
+		if (!clockevents_program_event(dev, next, false))
 			return;
 		tick_do_periodic_broadcast();
 	}
@@ -373,7 +373,7 @@ static int tick_broadcast_set_event(ktime_t expires, int force)
 {
 	struct clock_event_device *bc = tick_broadcast_device.evtdev;
 
-	return tick_dev_program_event(bc, expires, force);
+	return clockevents_program_event(bc, expires, force);
 }
 
 int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 119528d..da6c9ec 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -94,7 +94,7 @@ void tick_handle_periodic(struct clock_event_device *dev)
 	 */
 	next = ktime_add(dev->next_event, tick_period);
 	for (;;) {
-		if (!clockevents_program_event(dev, next, ktime_get()))
+		if (!clockevents_program_event(dev, next, false))
 			return;
 		/*
 		 * Have to be careful here. If we're in oneshot mode,
@@ -137,7 +137,7 @@ void tick_setup_periodic(struct clock_event_device *dev, int broadcast)
 		clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
 
 		for (;;) {
-			if (!clockevents_program_event(dev, next, ktime_get()))
+			if (!clockevents_program_event(dev, next, false))
 				return;
 			next = ktime_add(next, tick_period);
 		}
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 1009b06..4e265b9 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -26,8 +26,6 @@ extern void clockevents_shutdown(struct clock_event_device *dev);
 extern void tick_setup_oneshot(struct clock_event_device *newdev,
 			       void (*handler)(struct clock_event_device *),
 			       ktime_t nextevt);
-extern int tick_dev_program_event(struct clock_event_device *dev,
-				  ktime_t expires, int force);
 extern int tick_program_event(ktime_t expires, int force);
 extern void tick_oneshot_notify(void);
 extern int tick_switch_to_oneshot(void (*handler)(struct clock_event_device *));
diff --git a/kernel/time/tick-oneshot.c b/kernel/time/tick-oneshot.c
index 2d04411..8241090 100644
--- a/kernel/time/tick-oneshot.c
+++ b/kernel/time/tick-oneshot.c
@@ -21,74 +21,6 @@
 
 #include "tick-internal.h"
 
-/* Limit min_delta to a jiffie */
-#define MIN_DELTA_LIMIT		(NSEC_PER_SEC / HZ)
-
-static int tick_increase_min_delta(struct clock_event_device *dev)
-{
-	/* Nothing to do if we already reached the limit */
-	if (dev->min_delta_ns >= MIN_DELTA_LIMIT)
-		return -ETIME;
-
-	if (dev->min_delta_ns < 5000)
-		dev->min_delta_ns = 5000;
-	else
-		dev->min_delta_ns += dev->min_delta_ns >> 1;
-
-	if (dev->min_delta_ns > MIN_DELTA_LIMIT)
-		dev->min_delta_ns = MIN_DELTA_LIMIT;
-
-	printk(KERN_WARNING "CE: %s increased min_delta_ns to %llu nsec\n",
-	       dev->name ? dev->name : "?",
-	       (unsigned long long) dev->min_delta_ns);
-	return 0;
-}
-
-/**
- * tick_program_event internal worker function
- */
-int tick_dev_program_event(struct clock_event_device *dev, ktime_t expires,
-			   int force)
-{
-	ktime_t now = ktime_get();
-	int i;
-
-	for (i = 0;;) {
-		int ret = clockevents_program_event(dev, expires, now);
-
-		if (!ret || !force)
-			return ret;
-
-		dev->retries++;
-		/*
-		 * We tried 3 times to program the device with the given
-		 * min_delta_ns. If that's not working then we increase it
-		 * and emit a warning.
-		 */
-		if (++i > 2) {
-			/* Increase the min. delta and try again */
-			if (tick_increase_min_delta(dev)) {
-				/*
-				 * Get out of the loop if min_delta_ns
-				 * hit the limit already. That's
-				 * better than staying here forever.
-				 *
-				 * We clear next_event so we have a
-				 * chance that the box survives.
-				 */
-				printk(KERN_WARNING
-				       "CE: Reprogramming failure. Giving up\n");
-				dev->next_event.tv64 = KTIME_MAX;
-				return -ETIME;
-			}
-			i = 0;
-		}
-
-		now = ktime_get();
-		expires = ktime_add_ns(now, dev->min_delta_ns);
-	}
-}
-
 /**
  * tick_program_event
  */
@@ -96,7 +28,7 @@ int tick_program_event(ktime_t expires, int force)
 {
 	struct clock_event_device *dev = __this_cpu_read(tick_cpu_device.evtdev);
 
-	return tick_dev_program_event(dev, expires, force);
+	return clockevents_program_event(dev, expires, force);
 }
 
 /**
@@ -104,11 +36,10 @@ int tick_program_event(ktime_t expires, int force)
  */
 void tick_resume_oneshot(void)
 {
-	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
-	struct clock_event_device *dev = td->evtdev;
+	struct clock_event_device *dev = __this_cpu_read(tick_cpu_device.evtdev);
 
 	clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
-	tick_program_event(ktime_get(), 1);
+	clockevents_program_event(dev, ktime_get(), true);
 }
 
 /**
@@ -120,7 +51,7 @@ void tick_setup_oneshot(struct clock_event_device *newdev,
 {
 	newdev->event_handler = handler;
 	clockevents_set_mode(newdev, CLOCK_EVT_MODE_ONESHOT);
-	tick_dev_program_event(newdev, next_event, 1);
+	clockevents_program_event(newdev, next_event, true);
 }
 
 /**
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d5097c4..7e2e081 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -159,9 +159,10 @@ update_ts_time_stats(int cpu, struct tick_sched *ts, ktime_t now, u64 *last_upda
 
 	if (ts->idle_active) {
 		delta = ktime_sub(now, ts->idle_entrytime);
-		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
 		if (nr_iowait_cpu(cpu) > 0)
 			ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
+		else
+			ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
 		ts->idle_entrytime = now;
 	}
 
@@ -197,11 +198,11 @@ static ktime_t tick_nohz_start_idle(int cpu, struct tick_sched *ts)
 /**
  * get_cpu_idle_time_us - get the total idle time of a cpu
  * @cpu: CPU number to query
- * @last_update_time: variable to store update time in
+ * @last_update_time: variable to store update time in. Do not update
+ * counters if NULL.
  *
  * Return the cummulative idle time (since boot) for a given
- * CPU, in microseconds. The idle time returned includes
- * the iowait time (unlike what "top" and co report).
+ * CPU, in microseconds.
  *
  * This time is measured via accounting rather than sampling,
  * and is as accurate as ktime_get() is.
@@ -211,20 +212,35 @@ static ktime_t tick_nohz_start_idle(int cpu, struct tick_sched *ts)
 u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	ktime_t now, idle;
 
 	if (!tick_nohz_enabled)
 		return -1;
 
-	update_ts_time_stats(cpu, ts, ktime_get(), last_update_time);
+	now = ktime_get();
+	if (last_update_time) {
+		update_ts_time_stats(cpu, ts, now, last_update_time);
+		idle = ts->idle_sleeptime;
+	} else {
+		if (ts->idle_active && !nr_iowait_cpu(cpu)) {
+			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
+
+			idle = ktime_add(ts->idle_sleeptime, delta);
+		} else {
+			idle = ts->idle_sleeptime;
+		}
+	}
+
+	return ktime_to_us(idle);
 
-	return ktime_to_us(ts->idle_sleeptime);
 }
 EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
 
-/*
+/**
  * get_cpu_iowait_time_us - get the total iowait time of a cpu
  * @cpu: CPU number to query
- * @last_update_time: variable to store update time in
+ * @last_update_time: variable to store update time in. Do not update
+ * counters if NULL.
  *
  * Return the cummulative iowait time (since boot) for a given
  * CPU, in microseconds.
@@ -237,13 +253,26 @@ EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
 u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	ktime_t now, iowait;
 
 	if (!tick_nohz_enabled)
 		return -1;
 
-	update_ts_time_stats(cpu, ts, ktime_get(), last_update_time);
+	now = ktime_get();
+	if (last_update_time) {
+		update_ts_time_stats(cpu, ts, now, last_update_time);
+		iowait = ts->iowait_sleeptime;
+	} else {
+		if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
+			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
 
-	return ktime_to_us(ts->iowait_sleeptime);
+			iowait = ktime_add(ts->iowait_sleeptime, delta);
+		} else {
+			iowait = ts->iowait_sleeptime;
+		}
+	}
+
+	return ktime_to_us(iowait);
 }
 EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);
 
@@ -640,8 +669,6 @@ static void tick_nohz_switch_to_nohz(void)
 		next = ktime_add(next, tick_period);
 	}
 	local_irq_enable();
-
-	printk(KERN_INFO "Switched to NOHz mode on CPU #%d\n", smp_processor_id());
 }
 
 /*
@@ -793,10 +820,8 @@ void tick_setup_sched_timer(void)
 	}
 
 #ifdef CONFIG_NO_HZ
-	if (tick_nohz_enabled) {
+	if (tick_nohz_enabled)
 		ts->nohz_mode = NOHZ_MODE_HIGHRES;
-		printk(KERN_INFO "Switched to NOHz mode on CPU #%d\n", smp_processor_id());
-	}
 #endif
 }
 #endif /* HIGH_RES_TIMERS */
