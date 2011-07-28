Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab1G1VnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 17:43:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:53407 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab1G1VnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 17:43:19 -0400
Date: Thu, 28 Jul 2011 23:43:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [ANNOUNCE] 3.0-rt6
Message-ID: <alpine.LFD.2.02.1107282213000.31246@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.0-rt6 release.

Changes versus 3.0-rt4 (I pushed out a rt5 w/o announce)

  * pin_cpu fix (Yong Zhang)

  * Various compile fixes (Yong Zhang & myself)

  * Serial fix for omap

  * Clocksource lockless watchdog reset

  * Reenabled CONFIG_RCU_BOOST (problem is unreproducible and maybe
    related to NO_HZ, which is still disabled. Paul is working on it!)

  * KGDB work^Whackaround (Jason Wessel)

    The kgdb workaround is really a hack and wants to be replaced by a
    proper overhaul for the console/tty maze.
    See: kgb-serial-hackaround.patch

As I said yesterday, I'm preparing for vanishing from the net. 

Please keep on testing and sending patches. Peter Zijlstra kindly
volunteered to cover for me. He'll pick up stuff and eventually push
out releases when a reasonable number of sane patches hits his inbox.

If you reply to that mail, please keep the Cc list intact to make sure
that all interested folks see it. It does not matter whether you are
subscribed to a particular mailing list or not. Just keep your fingers
away from the Cc list unless you have a very good reason to do
so. Hint for GUI mail "client" users: Hit "Reply to all" ....

For all those who are addicted to roadmaps, here is the roadmap I'm
caring about for the next two weeks:

  http://maps.google.com/maps?q=Fuchsenloch,+Schlier&hl=en&z=16

For the curious: Fuchsenloch == Fox hole. IOW: The place where fox and
rabbit say Good Night to each other.

And for those who care about estimates, here are my momentary
favourite Dilberts on this topic:

   http://dilbert.com/strips/comic/1995-11-10/
   http://dilbert.com/strips/comic/2010-05-05/

Patch against 3.0 can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/patch-3.0-rt6.patch.bz2

The split quilt queue is available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/patches-3.0-rt6.tar.bz2

Delta patch against 3.0-rt4 below.

Thanks,

	tglx
----
 arch/arm/include/asm/mmu.h       |    2 +-
 drivers/tty/serial/8250.c        |   13 +++++++++----
 drivers/tty/serial/omap-serial.c |    8 +++-----
 include/linux/kdb.h              |    2 ++
 init/Kconfig                     |    2 +-
 kernel/cpu.c                     |    4 +++-
 kernel/debug/kdb/kdb_io.c        |    6 ++----
 kernel/hrtimer.c                 |    4 +---
 kernel/time/clocksource.c        |   38 ++++++++++++++++++--------------------
 localversion-rt                  |    2 +-
 10 files changed, 41 insertions(+), 40 deletions(-)

Index: linux-2.6/arch/arm/include/asm/mmu.h
===================================================================
--- linux-2.6.orig/arch/arm/include/asm/mmu.h
+++ linux-2.6/arch/arm/include/asm/mmu.h
@@ -16,7 +16,7 @@ typedef struct {
 
 /* init_mm.context.id_lock should be initialized. */
 #define INIT_MM_CONTEXT(name)                                                 \
-	.context.id_lock    = __SPIN_LOCK_UNLOCKED(name.context.id_lock),
+	.context.id_lock    = __RAW_SPIN_LOCK_UNLOCKED(name.context.id_lock),
 #else
 #define ASID(mm)	(0)
 #endif
Index: linux-2.6/drivers/tty/serial/8250.c
===================================================================
--- linux-2.6.orig/drivers/tty/serial/8250.c
+++ linux-2.6/drivers/tty/serial/8250.c
@@ -38,6 +38,7 @@
 #include <linux/nmi.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/kdb.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -2894,10 +2895,14 @@ serial8250_console_write(struct console 
 
 	touch_nmi_watchdog();
 
-	if (up->port.sysrq || oops_in_progress)
-		locked = spin_trylock_irqsave(&up->port.lock, flags);
-	else
-		spin_lock_irqsave(&up->port.lock, flags);
+	if (unlikely(in_kdb_printk())) {
+		locked = 0;
+	} else {
+		if (up->port.sysrq || oops_in_progress)
+			locked = spin_trylock_irqsave(&up->port.lock, flags);
+		else
+			spin_lock_irqsave(&up->port.lock, flags);
+	}
 
 	/*
 	 *	First save the IER then disable the interrupts
Index: linux-2.6/init/Kconfig
===================================================================
--- linux-2.6.orig/init/Kconfig
+++ linux-2.6/init/Kconfig
@@ -493,7 +493,7 @@ config TREE_RCU_TRACE
 
 config RCU_BOOST
 	bool "Enable RCU priority boosting"
-	depends on RT_MUTEXES && PREEMPT_RCU && !RT_PREEMPT_FULL
+	depends on RT_MUTEXES && PREEMPT_RCU
 	default n
 	help
 	  This option boosts the priority of preempted RCU readers that
Index: linux-2.6/kernel/cpu.c
===================================================================
--- linux-2.6.orig/kernel/cpu.c
+++ linux-2.6/kernel/cpu.c
@@ -75,9 +75,11 @@ static DEFINE_PER_CPU(struct hotplug_pcp
  */
 void pin_current_cpu(void)
 {
-	struct hotplug_pcp *hp = &__get_cpu_var(hotplug_pcp);
+	struct hotplug_pcp *hp;
 
 retry:
+	hp = &__get_cpu_var(hotplug_pcp);
+
 	if (!hp->unplug || hp->refcount || preempt_count() > 1 ||
 	    hp->unplug == current || (current->flags & PF_STOMPER)) {
 		hp->refcount++;
Index: linux-2.6/kernel/hrtimer.c
===================================================================
--- linux-2.6.orig/kernel/hrtimer.c
+++ linux-2.6/kernel/hrtimer.c
@@ -1294,11 +1294,9 @@ static void __run_hrtimer(struct hrtimer
 	timer->state &= ~HRTIMER_STATE_CALLBACK;
 }
 
-
-#ifdef CONFIG_PREEMPT_RT_BASE
-
 static enum hrtimer_restart hrtimer_wakeup(struct hrtimer *timer);
 
+#ifdef CONFIG_PREEMPT_RT_BASE
 static void hrtimer_rt_reprogram(int restart, struct hrtimer *timer,
 				 struct hrtimer_clock_base *base)
 {
Index: linux-2.6/localversion-rt
===================================================================
--- linux-2.6.orig/localversion-rt
+++ linux-2.6/localversion-rt
@@ -1 +1 @@
--rt4
+-rt6
Index: linux-2.6/kernel/time/clocksource.c
===================================================================
--- linux-2.6.orig/kernel/time/clocksource.c
+++ linux-2.6/kernel/time/clocksource.c
@@ -186,6 +186,7 @@ static struct timer_list watchdog_timer;
 static DECLARE_WORK(watchdog_work, clocksource_watchdog_work);
 static DEFINE_SPINLOCK(watchdog_lock);
 static int watchdog_running;
+static atomic_t watchdog_reset_pending;
 
 static int clocksource_watchdog_kthread(void *data);
 static void __clocksource_change_rating(struct clocksource *cs, int rating);
@@ -247,12 +248,14 @@ static void clocksource_watchdog(unsigne
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
@@ -268,7 +271,8 @@ static void clocksource_watchdog(unsigne
 		local_irq_enable();
 
 		/* Clocksource initialized ? */
-		if (!(cs->flags & CLOCK_SOURCE_WATCHDOG)) {
+		if (!(cs->flags & CLOCK_SOURCE_WATCHDOG) ||
+		    atomic_read(&watchdog_reset_pending)) {
 			cs->flags |= CLOCK_SOURCE_WATCHDOG;
 			cs->wd_last = wdnow;
 			cs->cs_last = csnow;
@@ -283,8 +287,11 @@ static void clocksource_watchdog(unsigne
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
@@ -303,6 +310,13 @@ static void clocksource_watchdog(unsigne
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
@@ -344,23 +358,7 @@ static inline void clocksource_reset_wat
 
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
Index: linux-2.6/drivers/tty/serial/omap-serial.c
===================================================================
--- linux-2.6.orig/drivers/tty/serial/omap-serial.c
+++ linux-2.6/drivers/tty/serial/omap-serial.c
@@ -947,13 +947,12 @@ serial_omap_console_write(struct console
 	unsigned int ier;
 	int locked = 1;
 
-	local_irq_save(flags);
 	if (up->port.sysrq)
 		locked = 0;
 	else if (oops_in_progress)
-		locked = spin_trylock(&up->port.lock);
+		locked = spin_trylock_irqsave(&up->port.lock, flags);
 	else
-		spin_lock(&up->port.lock);
+		spin_lock_irqsave(&up->port.lock, flags);
 
 	/*
 	 * First save the IER then disable the interrupts
@@ -980,8 +979,7 @@ serial_omap_console_write(struct console
 		check_modem_status(up);
 
 	if (locked)
-		spin_unlock(&up->port.lock);
-	local_irq_restore(flags);
+		spin_unlock_irqrestore(&up->port.lock, flags);
 }
 
 static int __init
Index: linux-2.6/include/linux/kdb.h
===================================================================
--- linux-2.6.orig/include/linux/kdb.h
+++ linux-2.6/include/linux/kdb.h
@@ -153,12 +153,14 @@ extern int kdb_register(char *, kdb_func
 extern int kdb_register_repeat(char *, kdb_func_t, char *, char *,
 			       short, kdb_repeat_t);
 extern int kdb_unregister(char *);
+#define in_kdb_printk() (kdb_trap_printk)
 #else /* ! CONFIG_KGDB_KDB */
 #define kdb_printf(...)
 #define kdb_init(x)
 #define kdb_register(...)
 #define kdb_register_repeat(...)
 #define kdb_uregister(x)
+#define in_kdb_printk() (0)
 #endif	/* CONFIG_KGDB_KDB */
 enum {
 	KDB_NOT_INITIALIZED,
Index: linux-2.6/kernel/debug/kdb/kdb_io.c
===================================================================
--- linux-2.6.orig/kernel/debug/kdb/kdb_io.c
+++ linux-2.6/kernel/debug/kdb/kdb_io.c
@@ -539,7 +539,6 @@ int vkdb_printf(const char *fmt, va_list
 	int diag;
 	int linecount;
 	int logging, saved_loglevel = 0;
-	int saved_trap_printk;
 	int got_printf_lock = 0;
 	int retlen = 0;
 	int fnd, len;
@@ -550,8 +549,6 @@ int vkdb_printf(const char *fmt, va_list
 	unsigned long uninitialized_var(flags);
 
 	preempt_disable();
-	saved_trap_printk = kdb_trap_printk;
-	kdb_trap_printk = 0;
 
 	/* Serialize kdb_printf if multiple cpus try to write at once.
 	 * But if any cpu goes recursive in kdb, just print the output,
@@ -807,7 +804,6 @@ kdb_print_out:
 	} else {
 		__release(kdb_printf_lock);
 	}
-	kdb_trap_printk = saved_trap_printk;
 	preempt_enable();
 	return retlen;
 }
@@ -817,9 +813,11 @@ int kdb_printf(const char *fmt, ...)
 	va_list ap;
 	int r;
 
+	kdb_trap_printk++;
 	va_start(ap, fmt);
 	r = vkdb_printf(fmt, ap);
 	va_end(ap);
+	kdb_trap_printk--;
 
 	return r;
 }
