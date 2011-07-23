Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab1GWPNj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 11:13:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:37308 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab1GWPNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 11:13:33 -0400
Date: Sat, 23 Jul 2011 17:13:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [ANNOUNCE] 3.0-rt2
Message-ID: <alpine.LFD.2.02.1107231706380.2702@ionos>
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

I'm pleased to announce the 3.0-rt2 release.

Changes versus 3.0-rt1:

  * mqueue fix (Yoshitake Kobayashi)

  * dca locking fix (Mike Galbraith)

  * trace updates (Carsten Emde)

  * Fixed vprintk wreckage and rcutorture (tglx)

Known issues:

  * Some weird "console=..." commandline + config dependent
    interactions which have been not yet investigated down to their
    root cause. Result in a boot hang. YMMV

Patch against 3.0 can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/patch-3.0-rt2.patch.bz2

The split quilt queue is available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/patches-3.0-rt2.tar.bz2

Delta patch below.

Thanks,

	tglx
----
 arch/arm/kernel/early_printk.c        |   17 ++----------
 arch/blackfin/kernel/early_printk.c   |    2 -
 arch/microblaze/kernel/early_printk.c |   25 ++----------------
 arch/mips/kernel/early_printk.c       |   10 +++----
 arch/powerpc/kernel/udbg.c            |    6 +---
 arch/sh/kernel/sh_bios.c              |    2 -
 arch/sparc/kernel/setup_32.c          |    1 
 arch/sparc/kernel/setup_64.c          |    8 +++++-
 arch/tile/kernel/early_printk.c       |   26 +++----------------
 arch/um/kernel/early_printk.c         |    8 +++---
 arch/unicore32/kernel/early_printk.c  |   12 +++------
 arch/x86/kernel/early_printk.c        |   28 ---------------------
 drivers/dca/dca-core.c                |    6 ++--
 include/linux/console.h               |    1 
 include/linux/printk.h                |   13 +++++----
 include/linux/rcupdate.h              |    2 -
 include/linux/rcutree.h               |    4 +--
 ipc/mqueue.c                          |    8 ++++--
 kernel/printk.c                       |   45 +++++++++++++++++++++++++---------
 kernel/trace/latency_hist.c           |   21 ++++++++++-----
 kernel/watchdog.c                     |    3 --
 localversion-rt                       |    2 -
 22 files changed, 104 insertions(+), 146 deletions(-)

Index: linux-2.6/arch/x86/kernel/early_printk.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/early_printk.c
+++ linux-2.6/arch/x86/kernel/early_printk.c
@@ -169,31 +169,6 @@ static struct console early_serial_conso
 	.index =	-1,
 };
 
-/* Direct interface for emergencies */
-static struct console *early_console = &early_vga_console;
-int early_console_initialized;
-
-asmlinkage void early_printk(const char *fmt, ...)
-{
-	char buf[512];
-	int n;
-	va_list ap;
-
-	va_start(ap, fmt);
-	n = vscnprintf(buf, sizeof(buf), fmt, ap);
-	early_console->write(early_console, buf, n);
-	va_end(ap);
-}
-
-asmlinkage void early_vprintk(const char *fmt, va_list ap)
-{
-	char buf[512];
-	int n;
-
-	n = vscnprintf(buf, sizeof(buf), fmt, ap);
-	early_console->write(early_console, buf, n);
-}
-
 static inline void early_console_register(struct console *con, int keep_early)
 {
 	if (early_console->index != -1) {
@@ -216,9 +191,8 @@ static int __init setup_early_printk(cha
 	if (!buf)
 		return 0;
 
-	if (early_console_initialized)
+	if (early_console)
 		return 0;
-	early_console_initialized = 1;
 
 	keep = (strstr(buf, "keep") != NULL);
 
Index: linux-2.6/drivers/dca/dca-core.c
===================================================================
--- linux-2.6.orig/drivers/dca/dca-core.c
+++ linux-2.6/drivers/dca/dca-core.c
@@ -101,10 +101,10 @@ static void unregister_dca_providers(voi
 
 	INIT_LIST_HEAD(&unregistered_providers);
 
-	spin_lock_irqsave(&dca_lock, flags);
+	raw_spin_lock_irqsave(&dca_lock, flags);
 
 	if (list_empty(&dca_domains)) {
-		spin_unlock_irqrestore(&dca_lock, flags);
+		raw_spin_unlock_irqrestore(&dca_lock, flags);
 		return;
 	}
 
@@ -116,7 +116,7 @@ static void unregister_dca_providers(voi
 
 	dca_free_domain(domain);
 
-	spin_unlock_irqrestore(&dca_lock, flags);
+	raw_spin_unlock_irqrestore(&dca_lock, flags);
 
 	list_for_each_entry_safe(dca, _dca, &unregistered_providers, node) {
 		dca_sysfs_remove_provider(dca);
Index: linux-2.6/include/linux/printk.h
===================================================================
--- linux-2.6.orig/include/linux/printk.h
+++ linux-2.6/include/linux/printk.h
@@ -88,11 +88,15 @@ int no_printk(const char *fmt, ...)
 	return 0;
 }
 
-extern int early_console_initialized;
-
+#ifdef CONFIG_EARLY_PRINTK
 extern asmlinkage __attribute__ ((format (printf, 1, 2)))
 void early_printk(const char *fmt, ...);
-void early_vprintk(const char *fmt, va_list args);
+extern void printk_kill(void);
+#else
+static inline __attribute__ ((format (printf, 1, 2))) __cold
+void early_printk(const char *s, ...) { }
+static inline void printk_kill(void) { }
+#endif
 
 extern int printk_needs_cpu(int cpu);
 extern void printk_tick(void);
@@ -112,9 +116,6 @@ extern int __printk_ratelimit(const char
 #define printk_ratelimit() __printk_ratelimit(__func__)
 extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 				   unsigned int interval_msec);
-
-extern void printk_kill(void);
-
 extern int printk_delay_msec;
 extern int dmesg_restrict;
 extern int kptr_restrict;
Index: linux-2.6/include/linux/rcupdate.h
===================================================================
--- linux-2.6.orig/include/linux/rcupdate.h
+++ linux-2.6/include/linux/rcupdate.h
@@ -80,7 +80,7 @@ extern void call_rcu_sched(struct rcu_he
 extern void synchronize_sched(void);
 
 #ifdef CONFIG_PREEMPT_RT_FULL
-# define rcu_barrier_bh()	rcu_barrier()
+# define rcu_barrier_bh		rcu_barrier
 #else
 extern void rcu_barrier_bh(void);
 #endif
Index: linux-2.6/include/linux/rcutree.h
===================================================================
--- linux-2.6.orig/include/linux/rcutree.h
+++ linux-2.6/include/linux/rcutree.h
@@ -84,8 +84,8 @@ extern void rcu_sched_force_quiescent_st
 extern void rcu_bh_force_quiescent_state(void);
 extern long rcu_batches_completed_bh(void);
 #else
-# define rcu_bh_force_quiescent_state()	rcu_force_quiescent_state()
-# define rcu_batches_completed_bh()	rcu_batches_completed()
+# define rcu_bh_force_quiescent_state	rcu_force_quiescent_state
+# define rcu_batches_completed_bh	rcu_batches_completed
 #endif
 
 /* A context switch is a grace period for RCU-sched and RCU-bh. */
Index: linux-2.6/ipc/mqueue.c
===================================================================
--- linux-2.6.orig/ipc/mqueue.c
+++ linux-2.6/ipc/mqueue.c
@@ -841,15 +841,19 @@ static inline void pipelined_receive(str
 		wake_up_interruptible(&info->wait_q);
 		return;
 	}
+	/*
+	 * Keep them in one critical section for PREEMPT_RT:
+	 */
+	preempt_disable_rt();
 	msg_insert(sender->msg, info);
 	list_del(&sender->list);
 	sender->state = STATE_PENDING;
 	wake_up_process(sender->task);
 	smp_wmb();
 	sender->state = STATE_READY;
+	preempt_enable_rt();
 }
-
-SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqdes, const char __user *, u_msg_ptr,
+ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqdes, const char __user *, u_msg_ptr,
 		size_t, msg_len, unsigned int, msg_prio,
 		const struct timespec __user *, u_abs_timeout)
 {
Index: linux-2.6/kernel/printk.c
===================================================================
--- linux-2.6.orig/kernel/printk.c
+++ linux-2.6/kernel/printk.c
@@ -44,13 +44,6 @@
 
 #include <asm/uaccess.h>
 
-/*
- * Architectures can override it:
- */
-void asmlinkage __attribute__((weak)) early_printk(const char *fmt, ...)
-{
-}
-
 #define __LOG_BUF_LEN	(1 << CONFIG_LOG_BUF_SHIFT)
 
 /* printk's without a loglevel use this.. */
@@ -521,6 +514,25 @@ static void __call_console_drivers(unsig
 	migrate_enable();
 }
 
+#ifdef CONFIG_EARLY_PRINTK
+struct console *early_console;
+
+static void early_vprintk(const char *fmt, va_list ap)
+{
+	char buf[512];
+	int n = vscnprintf(buf, sizeof(buf), fmt, ap);
+	if (early_console)
+		early_console->write(early_console, buf, n);
+}
+
+asmlinkage void early_printk(const char *fmt, ...)
+{
+	va_list ap;
+	va_start(ap, fmt);
+	early_vprintk(fmt, ap);
+	va_end(ap);
+}
+
 /*
  * This is independent of any log levels - a global
  * kill switch that turns off all of printk.
@@ -534,6 +546,20 @@ void printk_kill(void)
 	printk_killswitch = 1;
 }
 
+static int forced_early_printk(const char *fmt, va_list ap)
+{
+	if (!printk_killswitch)
+		return 0;
+	early_vprintk(fmt, ap);
+	return 1;
+}
+#else
+static inline int forced_early_printk(const char *fmt, va_list ap)
+{
+	return 0;
+}
+#endif
+
 static int __read_mostly ignore_loglevel;
 
 static int __init ignore_loglevel_setup(char *str)
@@ -858,10 +884,8 @@ asmlinkage int vprintk(const char *fmt, 
 	 * Fall back to early_printk if a debugging subsystem has
 	 * killed printk output
 	 */
-	if (unlikely(printk_killswitch)) {
-		early_vprintk(fmt, args);
+	if (unlikely(forced_early_printk(fmt, args)))
 		return 1;
-	}
 
 	boot_delay_msec();
 	printk_delay();
@@ -1575,7 +1599,6 @@ void register_console(struct console *ne
 		for_each_console(bcon)
 			if (bcon->flags & CON_BOOT)
 				unregister_console(bcon);
-		early_console_initialized = 0;
 	} else {
 		printk(KERN_INFO "%sconsole [%s%d] enabled\n",
 			(newcon->flags & CON_BOOT) ? "boot" : "" ,
Index: linux-2.6/kernel/trace/latency_hist.c
===================================================================
--- linux-2.6.orig/kernel/trace/latency_hist.c
+++ linux-2.6/kernel/trace/latency_hist.c
@@ -223,9 +223,8 @@ void notrace latency_hist(int latency_ty
 	} else
 		my_hist->hist_array[latency]++;
 
-	if (latency < my_hist->min_lat)
-		my_hist->min_lat = latency;
-	if (latency > my_hist->max_lat) {
+	if (unlikely(latency > my_hist->max_lat ||
+	    my_hist->min_lat == ULONG_MAX)) {
 #if defined(CONFIG_WAKEUP_LATENCY_HIST) || \
     defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 		if (latency_type == WAKEUP_LATENCY ||
@@ -246,6 +245,8 @@ void notrace latency_hist(int latency_ty
 #endif
 		my_hist->max_lat = latency;
 	}
+	if (unlikely(latency < my_hist->min_lat))
+		my_hist->min_lat = latency;
 	my_hist->total_samples++;
 	my_hist->accumulate_lat += latency;
 }
@@ -360,7 +361,7 @@ static struct file_operations latency_hi
 static void clear_maxlatprocdata(struct maxlatproc_data *mp)
 {
 	mp->comm[0] = mp->current_comm[0] = '\0';
-	mp->prio = mp->current_prio = mp->current_pid =
+	mp->prio = mp->current_prio = mp->pid = mp->current_pid =
 	    mp->latency = mp->timeroffset = -1;
 	mp->timestamp = 0;
 }
@@ -372,7 +373,7 @@ static void hist_reset(struct hist_data 
 	memset(hist->hist_array, 0, sizeof(hist->hist_array));
 	hist->below_hist_bound_samples = 0ULL;
 	hist->above_hist_bound_samples = 0ULL;
-	hist->min_lat = 0xFFFFFFFFUL;
+	hist->min_lat = ULONG_MAX;
 	hist->max_lat = 0UL;
 	hist->total_samples = 0ULL;
 	hist->accumulate_lat = 0ULL;
@@ -496,15 +497,21 @@ show_maxlatproc(struct file *file, char 
 	int strmaxlen = (TASK_COMM_LEN * 2) + (8 * 8);
 	unsigned long long t;
 	unsigned long usecs, secs;
-	char *buf = kmalloc(strmaxlen, GFP_KERNEL);
+	char *buf;
 
+	if (mp->pid == -1 || mp->current_pid == -1) {
+		buf = "(none)\n";
+		return simple_read_from_buffer(ubuf, cnt, ppos, buf,
+		    strlen(buf));
+	}
+
+	buf = kmalloc(strmaxlen, GFP_KERNEL);
 	if (buf == NULL)
 		return -ENOMEM;
 
 	t = ns2usecs(mp->timestamp);
 	usecs = do_div(t, USEC_PER_SEC);
 	secs = (unsigned long) t;
-
 	r = snprintf(buf, strmaxlen,
 	    "%d %d %ld (%ld) %s <- %d %d %s %lu.%06lu\n", mp->pid,
 	    MAX_RT_PRIO-1 - mp->prio, mp->latency, mp->timeroffset, mp->comm,
Index: linux-2.6/kernel/watchdog.c
===================================================================
--- linux-2.6.orig/kernel/watchdog.c
+++ linux-2.6/kernel/watchdog.c
@@ -240,8 +240,7 @@ static void watchdog_overflow_callback(s
 		 * If early-printk is enabled then make sure we do not
 		 * lock up in printk() and kill console logging:
 		 */
-		if (early_console_initialized)
-			printk_kill();
+		printk_kill();
 
 		if (hardlockup_panic) {
 			panic("Watchdog detected hard LOCKUP on cpu %d", this_cpu);
Index: linux-2.6/localversion-rt
===================================================================
--- linux-2.6.orig/localversion-rt
+++ linux-2.6/localversion-rt
@@ -1 +1 @@
--rt1
+-rt2
Index: linux-2.6/arch/arm/kernel/early_printk.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/early_printk.c
+++ linux-2.6/arch/arm/kernel/early_printk.c
@@ -29,28 +29,17 @@ static void early_console_write(struct c
 	early_write(s, n);
 }
 
-static struct console early_console = {
+static struct console early_console_dev = {
 	.name =		"earlycon",
 	.write =	early_console_write,
 	.flags =	CON_PRINTBUFFER | CON_BOOT,
 	.index =	-1,
 };
 
-asmlinkage void early_printk(const char *fmt, ...)
-{
-	char buf[512];
-	int n;
-	va_list ap;
-
-	va_start(ap, fmt);
-	n = vscnprintf(buf, sizeof(buf), fmt, ap);
-	early_write(buf, n);
-	va_end(ap);
-}
-
 static int __init setup_early_printk(char *buf)
 {
-	register_console(&early_console);
+	early_console = &early_console_dev;
+	register_console(&early_console_dev);
 	return 0;
 }
 
Index: linux-2.6/arch/blackfin/kernel/early_printk.c
===================================================================
--- linux-2.6.orig/arch/blackfin/kernel/early_printk.c
+++ linux-2.6/arch/blackfin/kernel/early_printk.c
@@ -25,8 +25,6 @@ extern struct console *bfin_earlyserial_
 extern struct console *bfin_jc_early_init(void);
 #endif
 
-static struct console *early_console;
-
 /* Default console */
 #define DEFAULT_PORT 0
 #define DEFAULT_CFLAG CS8|B57600
Index: linux-2.6/arch/microblaze/kernel/early_printk.c
===================================================================
--- linux-2.6.orig/arch/microblaze/kernel/early_printk.c
+++ linux-2.6/arch/microblaze/kernel/early_printk.c
@@ -21,7 +21,6 @@
 #include <asm/setup.h>
 #include <asm/prom.h>
 
-static u32 early_console_initialized;
 static u32 base_addr;
 
 #ifdef CONFIG_SERIAL_UARTLITE_CONSOLE
@@ -109,31 +108,14 @@ static struct console early_serial_uart1
 };
 #endif /* CONFIG_SERIAL_8250_CONSOLE */
 
-static struct console *early_console;
-
-void early_printk(const char *fmt, ...)
-{
-	char buf[512];
-	int n;
-	va_list ap;
-
-	if (early_console_initialized) {
-		va_start(ap, fmt);
-		n = vscnprintf(buf, 512, fmt, ap);
-		early_console->write(early_console, buf, n);
-		va_end(ap);
-	}
-}
-
 int __init setup_early_printk(char *opt)
 {
-	if (early_console_initialized)
+	if (early_console)
 		return 1;
 
 #ifdef CONFIG_SERIAL_UARTLITE_CONSOLE
 	base_addr = early_uartlite_console();
 	if (base_addr) {
-		early_console_initialized = 1;
 #ifdef CONFIG_MMU
 		early_console_reg_tlb_alloc(base_addr);
 #endif
@@ -151,7 +133,6 @@ int __init setup_early_printk(char *opt)
 	base_addr = early_uart16550_console();
 	base_addr &= ~3; /* clear register offset */
 	if (base_addr) {
-		early_console_initialized = 1;
 #ifdef CONFIG_MMU
 		early_console_reg_tlb_alloc(base_addr);
 #endif
@@ -171,9 +152,9 @@ int __init setup_early_printk(char *opt)
 
 void __init disable_early_printk(void)
 {
-	if (!early_console_initialized || !early_console)
+	if (!early_console)
 		return;
 	printk(KERN_WARNING "disabling early console\n");
 	unregister_console(early_console);
-	early_console_initialized = 0;
+	early_console = NULL;
 }
Index: linux-2.6/arch/mips/kernel/early_printk.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/early_printk.c
+++ linux-2.6/arch/mips/kernel/early_printk.c
@@ -25,20 +25,18 @@ early_console_write(struct console *con,
 	}
 }
 
-static struct console early_console __initdata = {
+static struct console early_console_prom = {
 	.name	= "early",
 	.write	= early_console_write,
 	.flags	= CON_PRINTBUFFER | CON_BOOT,
 	.index	= -1
 };
 
-static int early_console_initialized __initdata;
-
 void __init setup_early_printk(void)
 {
-	if (early_console_initialized)
+	if (early_console)
 		return;
-	early_console_initialized = 1;
+	early_console = &early_console_prom;
 
-	register_console(&early_console);
+	register_console(&early_console_prom);
 }
Index: linux-2.6/arch/powerpc/kernel/udbg.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/udbg.c
+++ linux-2.6/arch/powerpc/kernel/udbg.c
@@ -169,15 +169,13 @@ static struct console udbg_console = {
 	.index	= 0,
 };
 
-static int early_console_initialized;
-
 /*
  * Called by setup_system after ppc_md->probe and ppc_md->early_init.
  * Call it again after setting udbg_putc in ppc_md->setup_arch.
  */
 void __init register_early_udbg_console(void)
 {
-	if (early_console_initialized)
+	if (early_console)
 		return;
 
 	if (!udbg_putc)
@@ -187,7 +185,7 @@ void __init register_early_udbg_console(
 		printk(KERN_INFO "early console immortal !\n");
 		udbg_console.flags &= ~CON_BOOT;
 	}
-	early_console_initialized = 1;
+	early_console = &udbg_console;
 	register_console(&udbg_console);
 }
 
Index: linux-2.6/arch/sh/kernel/sh_bios.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/sh_bios.c
+++ linux-2.6/arch/sh/kernel/sh_bios.c
@@ -144,8 +144,6 @@ static struct console bios_console = {
 	.index		= -1,
 };
 
-static struct console *early_console;
-
 static int __init setup_early_printk(char *buf)
 {
 	int keep_early = 0;
Index: linux-2.6/arch/sparc/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/setup_32.c
+++ linux-2.6/arch/sparc/kernel/setup_32.c
@@ -220,6 +220,7 @@ void __init setup_arch(char **cmdline_p)
 
 	boot_flags_init(*cmdline_p);
 
+	early_console = &prom_early_console;
 	register_console(&prom_early_console);
 
 	/* Set sparc_cpu_model */
Index: linux-2.6/arch/sparc/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/setup_64.c
+++ linux-2.6/arch/sparc/kernel/setup_64.c
@@ -278,6 +278,12 @@ void __init boot_cpu_id_too_large(int cp
 }
 #endif
 
+static inline void register_prom_console(void)
+{
+	early_console = &prom_early_console;
+	register_console(&prom_early_console);
+}
+
 void __init setup_arch(char **cmdline_p)
 {
 	/* Initialize PROM console and command line. */
@@ -289,7 +295,7 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_EARLYFB
 	if (btext_find_display())
 #endif
-		register_console(&prom_early_console);
+		register_prom_console();
 
 	if (tlb_type == hypervisor)
 		printk("ARCH: SUN4V\n");
Index: linux-2.6/arch/tile/kernel/early_printk.c
===================================================================
--- linux-2.6.orig/arch/tile/kernel/early_printk.c
+++ linux-2.6/arch/tile/kernel/early_printk.c
@@ -32,25 +32,8 @@ static struct console early_hv_console =
 };
 
 /* Direct interface for emergencies */
-static struct console *early_console = &early_hv_console;
-static int early_console_initialized;
 static int early_console_complete;
 
-static void early_vprintk(const char *fmt, va_list ap)
-{
-	char buf[512];
-	int n = vscnprintf(buf, sizeof(buf), fmt, ap);
-	early_console->write(early_console, buf, n);
-}
-
-void early_printk(const char *fmt, ...)
-{
-	va_list ap;
-	va_start(ap, fmt);
-	early_vprintk(fmt, ap);
-	va_end(ap);
-}
-
 void early_panic(const char *fmt, ...)
 {
 	va_list ap;
@@ -68,14 +51,13 @@ static int __initdata keep_early;
 
 static int __init setup_early_printk(char *str)
 {
-	if (early_console_initialized)
+	if (early_console)
 		return 1;
 
 	if (str != NULL && strncmp(str, "keep", 4) == 0)
 		keep_early = 1;
 
 	early_console = &early_hv_console;
-	early_console_initialized = 1;
 	register_console(early_console);
 
 	return 0;
@@ -84,12 +66,12 @@ static int __init setup_early_printk(cha
 void __init disable_early_printk(void)
 {
 	early_console_complete = 1;
-	if (!early_console_initialized || !early_console)
+	if (!early_console)
 		return;
 	if (!keep_early) {
 		early_printk("disabling early console\n");
 		unregister_console(early_console);
-		early_console_initialized = 0;
+		early_console = NULL;
 	} else {
 		early_printk("keeping early console\n");
 	}
@@ -97,7 +79,7 @@ void __init disable_early_printk(void)
 
 void warn_early_printk(void)
 {
-	if (early_console_complete || early_console_initialized)
+	if (early_console_complete || early_console)
 		return;
 	early_printk("\
 Machine shutting down before console output is fully initialized.\n\
Index: linux-2.6/arch/um/kernel/early_printk.c
===================================================================
--- linux-2.6.orig/arch/um/kernel/early_printk.c
+++ linux-2.6/arch/um/kernel/early_printk.c
@@ -16,7 +16,7 @@ static void early_console_write(struct c
 	um_early_printk(s, n);
 }
 
-static struct console early_console = {
+static struct console early_console_dev = {
 	.name = "earlycon",
 	.write = early_console_write,
 	.flags = CON_BOOT,
@@ -25,8 +25,10 @@ static struct console early_console = {
 
 static int __init setup_early_printk(char *buf)
 {
-	register_console(&early_console);
-
+	if (!early_console) {
+		early_console = &early_console_dev;
+		register_console(&early_console_dev);
+	}
 	return 0;
 }
 
Index: linux-2.6/arch/unicore32/kernel/early_printk.c
===================================================================
--- linux-2.6.orig/arch/unicore32/kernel/early_printk.c
+++ linux-2.6/arch/unicore32/kernel/early_printk.c
@@ -33,21 +33,17 @@ static struct console early_ocd_console 
 	.index =	-1,
 };
 
-/* Direct interface for emergencies */
-static struct console *early_console = &early_ocd_console;
-
-static int __initdata keep_early;
-
 static int __init setup_early_printk(char *buf)
 {
-	if (!buf)
+	int keep_early;
+
+	if (!buf || early_console)
 		return 0;
 
 	if (strstr(buf, "keep"))
 		keep_early = 1;
 
-	if (!strncmp(buf, "ocd", 3))
-		early_console = &early_ocd_console;
+	early_console = &early_ocd_console;
 
 	if (keep_early)
 		early_console->flags &= ~CON_BOOT;
Index: linux-2.6/include/linux/console.h
===================================================================
--- linux-2.6.orig/include/linux/console.h
+++ linux-2.6/include/linux/console.h
@@ -133,6 +133,7 @@ struct console {
 	for (con = console_drivers; con != NULL; con = con->next)
 
 extern int console_set_on_cmdline;
+extern struct console *early_console;
 
 extern int add_preferred_console(char *name, int idx, char *options);
 extern int update_console_cmdline(char *name, int idx, char *name_new, int idx_new, char *options);
