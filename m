Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665Ab1AUNib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 08:38:31 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:59859 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750817Ab1AUNia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 08:38:30 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1/GJKBzQw/GCJXQUgCeE4G5Db/1nhvfdYKuYPz0Mn
	PAcxGK3UrVRvTd
From: Torben Hohn <torbenh@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: johnstul@us.ibm.com, hch@infradead.org, tglx@tglx.de,
        Torben Hohn <torbenh@gmx.de>
Subject: [PATCH] RFC: change do_timer() to take xtime lock, and provide do_timer_locked()
Date: Fri, 21 Jan 2011 14:38:10 +0100
Message-Id: <1295617090-24896-1-git-send-email-torbenh@gmx.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <AANLkTikS0WAUngUXVx3uCynXt07-1L+=aR5A09XOMtK9@mail.gmail.com>
References: <AANLkTikS0WAUngUXVx3uCynXt07-1L+=aR5A09XOMtK9@mail.gmail.com>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in an effort to reduce occurrences of xtime_lock in the codebase,
this commit makes do_timer take the xtime lock.

there are quite some occurences where arch code seems to protect
other datastructures with this lock too.
we provide do_timer_locked() for these occurences.

however, for this change to make sense, we should try to get rid
of most calls to do_timer_locked()
gonna try to address that in other arch specific commits.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
---
 arch/alpha/kernel/time.c                   |    2 +-
 arch/arm/kernel/time.c                     |    4 ++--
 arch/arm/mach-clps711x/include/mach/time.h |    2 ++
 arch/blackfin/kernel/time.c                |    3 +--
 arch/cris/arch-v10/kernel/time.c           |    1 +
 arch/cris/arch-v32/kernel/time.c           |    4 ++--
 arch/frv/kernel/time.c                     |    2 +-
 arch/h8300/kernel/time.c                   |    3 +--
 arch/ia64/kernel/time.c                    |    2 +-
 arch/ia64/xen/time.c                       |    2 +-
 arch/m32r/kernel/time.c                    |    2 +-
 arch/m68k/kernel/time.c                    |    1 +
 arch/m68k/sun3/sun3ints.c                  |    1 +
 arch/m68knommu/kernel/time.c               |    5 +----
 arch/mn10300/kernel/time.c                 |    2 +-
 arch/parisc/kernel/time.c                  |    3 +--
 arch/sparc/kernel/pcic.c                   |    2 +-
 arch/sparc/kernel/time_32.c                |    2 +-
 arch/xtensa/kernel/time.c                  |    2 +-
 include/linux/sched.h                      |    1 +
 kernel/time/tick-common.c                  |    2 +-
 kernel/time/tick-sched.c                   |    2 +-
 kernel/timer.c                             |    9 ++++++++-
 23 files changed, 33 insertions(+), 26 deletions(-)

diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
index c1f3e7c..843344f 100644
--- a/arch/alpha/kernel/time.c
+++ b/arch/alpha/kernel/time.c
@@ -187,7 +187,7 @@ irqreturn_t timer_interrupt(int irq, void *dev)
 	nticks = delta >> FIX_SHIFT;
 
 	if (nticks)
-		do_timer(nticks);
+		do_timer_locked(nticks);
 
 	write_sequnlock(&xtime_lock);
 
diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
index 3d76bf2..ff83e3d 100644
--- a/arch/arm/kernel/time.c
+++ b/arch/arm/kernel/time.c
@@ -107,9 +107,9 @@ void timer_tick(void)
 {
 	profile_tick(CPU_PROFILING);
 	do_leds();
-	write_seqlock(&xtime_lock);
+
+	/* do_timer takes the xtime_lock itself now */
 	do_timer(1);
-	write_sequnlock(&xtime_lock);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
diff --git a/arch/arm/mach-clps711x/include/mach/time.h b/arch/arm/mach-clps711x/include/mach/time.h
index 8fe283c..b4fa8f7 100644
--- a/arch/arm/mach-clps711x/include/mach/time.h
+++ b/arch/arm/mach-clps711x/include/mach/time.h
@@ -30,6 +30,8 @@ p720t_timer_interrupt(int irq, void *dev_id)
 {
 	struct pt_regs *regs = get_irq_regs();
 	do_leds();
+
+	/* do_timer takes the xtime_lock itself now */
 	do_timer(1);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(regs));
diff --git a/arch/blackfin/kernel/time.c b/arch/blackfin/kernel/time.c
index c911361..2224697 100644
--- a/arch/blackfin/kernel/time.c
+++ b/arch/blackfin/kernel/time.c
@@ -121,9 +121,8 @@ __attribute__((l1_text))
 #endif
 irqreturn_t timer_interrupt(int irq, void *dummy)
 {
-	write_seqlock(&xtime_lock);
+	/* do_timer takes the xtime_lock itself now */
 	do_timer(1);
-	write_sequnlock(&xtime_lock);
 
 #ifdef CONFIG_IPIPE
 	update_root_process_times(get_irq_regs());
diff --git a/arch/cris/arch-v10/kernel/time.c b/arch/cris/arch-v10/kernel/time.c
index 00eb36f..e4d4352 100644
--- a/arch/cris/arch-v10/kernel/time.c
+++ b/arch/cris/arch-v10/kernel/time.c
@@ -176,6 +176,7 @@ timer_interrupt(int irq, void *dev_id)
 
 	/* call the real timer interrupt handler */
 
+	/* do_timer takes the xtime_lock itself now */
 	do_timer(1);
 	
         cris_do_profile(regs); /* Save profiling information */
diff --git a/arch/cris/arch-v32/kernel/time.c b/arch/cris/arch-v32/kernel/time.c
index a545211..997dc08 100644
--- a/arch/cris/arch-v32/kernel/time.c
+++ b/arch/cris/arch-v32/kernel/time.c
@@ -216,9 +216,9 @@ static inline irqreturn_t timer_interrupt(int irq, void *dev_id)
 		return IRQ_HANDLED;
 
 	/* Call the real timer interrupt handler */
-	write_seqlock(&xtime_lock);
+
+	/* do_timer takes the xtime_lock itself now */
 	do_timer(1);
-	write_sequnlock(&xtime_lock);
         return IRQ_HANDLED;
 }
 
diff --git a/arch/frv/kernel/time.c b/arch/frv/kernel/time.c
index 0ddbbae..f28d68c 100644
--- a/arch/frv/kernel/time.c
+++ b/arch/frv/kernel/time.c
@@ -64,7 +64,7 @@ static irqreturn_t timer_interrupt(int irq, void *dummy)
 	 */
 	write_seqlock(&xtime_lock);
 
-	do_timer(1);
+	do_timer_locked(1);
 
 #ifdef CONFIG_HEARTBEAT
 	static unsigned short n;
diff --git a/arch/h8300/kernel/time.c b/arch/h8300/kernel/time.c
index 165005a..b27c93d 100644
--- a/arch/h8300/kernel/time.c
+++ b/arch/h8300/kernel/time.c
@@ -35,9 +35,8 @@ void h8300_timer_tick(void)
 {
 	if (current->pid)
 		profile_tick(CPU_PROFILING);
-	write_seqlock(&xtime_lock);
+	/* do_timer takes the xtime_lock itself now */
 	do_timer(1);
-	write_sequnlock(&xtime_lock);
 	update_process_times(user_mode(get_irq_regs()));
 }
 
diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 9702fa9..7140493 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -198,7 +198,7 @@ timer_interrupt (int irq, void *dev_id)
 			 * xtime_lock.
 			 */
 			write_seqlock(&xtime_lock);
-			do_timer(1);
+			do_timer_locked(1);
 			local_cpu_data->itm_next = new_itm;
 			write_sequnlock(&xtime_lock);
 		} else
diff --git a/arch/ia64/xen/time.c b/arch/ia64/xen/time.c
index c1c5445..0573a04 100644
--- a/arch/ia64/xen/time.c
+++ b/arch/ia64/xen/time.c
@@ -141,7 +141,7 @@ consider_steal_time(unsigned long new_itm)
 
 		if (cpu == time_keeper_id) {
 			write_seqlock(&xtime_lock);
-			do_timer(stolen + blocked);
+			do_timer_locked(stolen + blocked);
 			local_cpu_data->itm_next = delta_itm + new_itm;
 			write_sequnlock(&xtime_lock);
 		} else {
diff --git a/arch/m32r/kernel/time.c b/arch/m32r/kernel/time.c
index bda8682..5586ee5 100644
--- a/arch/m32r/kernel/time.c
+++ b/arch/m32r/kernel/time.c
@@ -114,7 +114,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 #ifndef CONFIG_SMP
 	profile_tick(CPU_PROFILING);
 #endif
-	/* XXX FIXME. Uh, the xtime_lock should be held here, no? */
+	/* do_timer() gets the xtime lock now */
 	do_timer(1);
 
 #ifndef CONFIG_SMP
diff --git a/arch/m68k/kernel/time.c b/arch/m68k/kernel/time.c
index 06438da..7f3a01b1 100644
--- a/arch/m68k/kernel/time.c
+++ b/arch/m68k/kernel/time.c
@@ -41,6 +41,7 @@ static inline int set_rtc_mmss(unsigned long nowtime)
  */
 static irqreturn_t timer_interrupt(int irq, void *dummy)
 {
+	/* do_timer takes the xtime_lock now */
 	do_timer(1);
 	update_process_times(user_mode(get_irq_regs()));
 	profile_tick(CPU_PROFILING);
diff --git a/arch/m68k/sun3/sun3ints.c b/arch/m68k/sun3/sun3ints.c
index 2d9e21b..ce1742c 100644
--- a/arch/m68k/sun3/sun3ints.c
+++ b/arch/m68k/sun3/sun3ints.c
@@ -66,6 +66,7 @@ static irqreturn_t sun3_int5(int irq, void *dev_id)
 #ifdef CONFIG_SUN3
 	intersil_clear();
 #endif
+	/* do_timer takes the xtime_lock now */
         do_timer(1);
 	update_process_times(user_mode(get_irq_regs()));
         if (!(kstat_cpu(0).irqs[irq] % 20))
diff --git a/arch/m68knommu/kernel/time.c b/arch/m68knommu/kernel/time.c
index d6ac2a4..d45eebb 100644
--- a/arch/m68knommu/kernel/time.c
+++ b/arch/m68knommu/kernel/time.c
@@ -44,12 +44,9 @@ irqreturn_t arch_timer_interrupt(int irq, void *dummy)
 	if (current->pid)
 		profile_tick(CPU_PROFILING);
 
-	write_seqlock(&xtime_lock);
-
+	/* do_timer takes the xtime_lock now */
 	do_timer(1);
 
-	write_sequnlock(&xtime_lock);
-
 	update_process_times(user_mode(get_irq_regs()));
 
 	return(IRQ_HANDLED);
diff --git a/arch/mn10300/kernel/time.c b/arch/mn10300/kernel/time.c
index 75da468..420feeb 100644
--- a/arch/mn10300/kernel/time.c
+++ b/arch/mn10300/kernel/time.c
@@ -114,7 +114,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 		mn10300_last_tsc += MN10300_TSC_PER_HZ;
 
 		/* advance the kernel's time tracking system */
-		do_timer(1);
+		do_timer_locked(1);
 	}
 
 	write_sequnlock(&xtime_lock);
diff --git a/arch/parisc/kernel/time.c b/arch/parisc/kernel/time.c
index 05511cc..c77ab78 100644
--- a/arch/parisc/kernel/time.c
+++ b/arch/parisc/kernel/time.c
@@ -163,9 +163,8 @@ irqreturn_t __irq_entry timer_interrupt(int irq, void *dev_id)
 	}
 
 	if (cpu == 0) {
-		write_seqlock(&xtime_lock);
+		/* do_timer takes the xtime_lock */
 		do_timer(ticks_elapsed);
-		write_sequnlock(&xtime_lock);
 	}
 
 	return IRQ_HANDLED;
diff --git a/arch/sparc/kernel/pcic.c b/arch/sparc/kernel/pcic.c
index aeaa09a..1eb27ed 100644
--- a/arch/sparc/kernel/pcic.c
+++ b/arch/sparc/kernel/pcic.c
@@ -702,7 +702,7 @@ static irqreturn_t pcic_timer_handler (int irq, void *h)
 {
 	write_seqlock(&xtime_lock);	/* Dummy, to show that we remember */
 	pcic_clear_clock_irq();
-	do_timer(1);
+	do_timer_locked(1);
 	write_sequnlock(&xtime_lock);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
diff --git a/arch/sparc/kernel/time_32.c b/arch/sparc/kernel/time_32.c
index 9c743b1..b998602 100644
--- a/arch/sparc/kernel/time_32.c
+++ b/arch/sparc/kernel/time_32.c
@@ -101,7 +101,7 @@ static irqreturn_t timer_interrupt(int dummy, void *dev_id)
 
 	clear_clock_irq();
 
-	do_timer(1);
+	do_timer_locked(1);
 
 	write_sequnlock(&xtime_lock);
 
diff --git a/arch/xtensa/kernel/time.c b/arch/xtensa/kernel/time.c
index 19df764..9a13249 100644
--- a/arch/xtensa/kernel/time.c
+++ b/arch/xtensa/kernel/time.c
@@ -98,7 +98,7 @@ again:
 
 		write_seqlock(&xtime_lock);
 
-		do_timer(1); /* Linux handler in kernel/timer.c */
+		do_timer_locked(1); /* Linux handler in kernel/timer.c */
 
 		/* Note that writing CCOMPARE clears the interrupt. */
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d747f94..8659219 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2050,6 +2050,7 @@ extern void release_uids(struct user_namespace *ns);
 #include <asm/current.h>
 
 extern void do_timer(unsigned long ticks);
+extern void do_timer_locked(unsigned long ticks);
 
 extern int wake_up_state(struct task_struct *tsk, unsigned int state);
 extern int wake_up_process(struct task_struct *tsk);
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 051bc80..e2ec6df 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -65,7 +65,7 @@ static void tick_periodic(int cpu)
 		/* Keep track of the next tick event */
 		tick_next_period = ktime_add(tick_next_period, tick_period);
 
-		do_timer(1);
+		do_timer_locked(1);
 		write_sequnlock(&xtime_lock);
 	}
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 3e216e0..4e6a323 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -75,7 +75,7 @@ static void tick_do_update_jiffies64(ktime_t now)
 			last_jiffies_update = ktime_add_ns(last_jiffies_update,
 							   incr * ticks);
 		}
-		do_timer(++ticks);
+		do_timer_locked(++ticks);
 
 		/* Keep the tick_next_period variable up to date */
 		tick_next_period = ktime_add(last_jiffies_update, tick_period);
diff --git a/kernel/timer.c b/kernel/timer.c
index 43ca993..ddc724c 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1299,13 +1299,20 @@ void run_local_timers(void)
  * jiffies is defined in the linker script...
  */
 
-void do_timer(unsigned long ticks)
+void do_timer_locked(unsigned long ticks)
 {
 	jiffies_64 += ticks;
 	update_wall_time();
 	calc_global_load(ticks);
 }
 
+void do_timer(unsigned long ticks)
+{
+	write_seqlock(&xtime_lock);
+	do_timer_locked(ticks);
+	write_sequnlock(&xtime_lock);
+}
+
 #ifdef __ARCH_WANT_SYS_ALARM
 
 /*
-- 
1.7.2.3

